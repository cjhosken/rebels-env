import sys
import os
import glob
import paramiko
import subprocess
from pathlib import Path
from tete import Tete
from PySide6.QtWidgets import (
    QApplication, QWidget, QVBoxLayout, QHBoxLayout, QLabel,
    QPushButton, QFileDialog, QComboBox, QSpinBox, QLineEdit, QMessageBox, QInputDialog
)
from PySide6.QtGui import QPalette, QColor
from PySide6.QtCore import Qt

class DarkThemeApp(QWidget):
    def __init__(self):
        super().__init__()
        self.setWindowTitle("HouTete | REBELS")
        self.setMinimumSize(500, 400)
        self.setup_ui()

    def setup_ui(self):
        layout = QVBoxLayout()

        self.job_name = QLineEdit()
        self.job_name.setPlaceholderText("Job Name...")
        self.job_name.setText(f"{os.getlogin()}_job")
        layout.addWidget(QLabel("Job Name:"))
        layout.addWidget(self.job_name)

        # Project Folder Selection
        folder_layout = QHBoxLayout()
        self.folder_line_edit = QLineEdit()
        self.folder_line_edit.setPlaceholderText("Select a root project folder...")
        self.browse_button = QPushButton("Browse")
        self.browse_button.clicked.connect(self.browse_folder)
        folder_layout.addWidget(self.folder_line_edit)
        folder_layout.addWidget(self.browse_button)
        layout.addWidget(QLabel("Project Folder ($JOB):"))
        layout.addLayout(folder_layout)

        # Houdini File Selection
        hipfile_layout = QHBoxLayout()
        self.hipfile_line_edit = QLineEdit()
        self.hipfile_line_edit.setPlaceholderText("Path to .hip or .hipnc file")
        self.hipfile_browse_button = QPushButton("Browse")
        self.hipfile_browse_button.clicked.connect(self.browse_hip_file)
        hipfile_layout.addWidget(self.hipfile_line_edit)
        hipfile_layout.addWidget(self.hipfile_browse_button)
        layout.addWidget(QLabel("Houdini File ($HIP):"))
        layout.addLayout(hipfile_layout)

        # ROP Path Input + Selector
        rop_layout = QHBoxLayout()
        self.text_input = QLineEdit()
        self.text_input.setPlaceholderText("Houdini ROP Path...")
        self.rop_browse_button = QPushButton("Select ROP")
        self.rop_browse_button.clicked.connect(self.select_rop_path)
        rop_layout.addWidget(self.text_input)
        rop_layout.addWidget(self.rop_browse_button)
        layout.addWidget(QLabel("ROP Path:"))
        layout.addLayout(rop_layout)

        # Frame Range
        frame_range_layout = QHBoxLayout()
        self.start_frame = QSpinBox()
        self.start_frame.setRange(0, 100000)
        self.start_frame.setValue(1)
        self.end_frame = QSpinBox()
        self.end_frame.setRange(0, 100000)
        self.end_frame.setValue(240)
        self.frame_step = QSpinBox()
        self.frame_step.setRange(1, 100)
        self.frame_step.setValue(1)
        frame_range_layout.addWidget(QLabel("Start Frame:"))
        frame_range_layout.addWidget(self.start_frame)
        frame_range_layout.addWidget(QLabel("End Frame:"))
        frame_range_layout.addWidget(self.end_frame)
        frame_range_layout.addWidget(QLabel("Step:"))
        frame_range_layout.addWidget(self.frame_step)
        layout.addWidget(QLabel("Frame Range:"))
        layout.addLayout(frame_range_layout)

        # Output Path
        self.output_path_edit = QLineEdit()
        self.output_path_edit.setPlaceholderText("Override Output File Path...")
        layout.addWidget(QLabel("Output File Path Override:"))
        layout.addWidget(self.output_path_edit)

        # CPU Nodes
        self.spinbox = QSpinBox()
        self.spinbox.setValue(10)
        self.spinbox.setRange(1, 50)
        layout.addWidget(QLabel("Number of CPU Nodes:"))
        layout.addWidget(self.spinbox)

        # Buttons
        button_layout = QHBoxLayout()
        self.ok_button = QPushButton("Submit Job")
        self.ok_button.clicked.connect(self.submit_job)
        self.cancel_button = QPushButton("Quit")
        self.cancel_button.clicked.connect(self.close)
        button_layout.addWidget(self.ok_button)
        button_layout.addWidget(self.cancel_button)
        layout.addLayout(button_layout)

        self.setLayout(layout)

    def browse_folder(self):
        folder = QFileDialog.getExistingDirectory(self, "Select Folder", os.path.expanduser("~"))
        if folder:
            self.folder_line_edit.setText(folder)

    def browse_hip_file(self):
        file, _ = QFileDialog.getOpenFileName(self, "Select Houdini File", filter="Houdini Files (*.hip *.hipnc)")
        if file:
            self.hipfile_line_edit.setText(file)

    def select_rop_path(self):
        try:
            import hou
            hip_path = self.hipfile_line_edit.text()
            if not os.path.exists(hip_path):
                QMessageBox.critical(self, "Houdini File Not Found", "Please specify an existing Houdini file.")
                return

            hou.hipFile.load(hip_path, suppress_save_prompt=True)

            # Recursive search for all ROP nodes
            def find_rop_nodes(root):
                rops = []
                for node in root.allSubChildren():
                    if "rop" in node.type().name().lower():
                        rops.append(node)
                return rops

            all_rops = find_rop_nodes(hou.node("/"))
            if not all_rops:
                QMessageBox.information(self, "No ROPs Found", "No ROP nodes found in the entire scene.")
                return

            rop_paths = [node.path() for node in all_rops]
            selected_rop, ok = QInputDialog.getItem(self, "Select ROP Node", "Choose a ROP Node:", rop_paths, 0, False)
            if ok and selected_rop:
                self.text_input.setText(selected_rop)
                rop_node = hou.node(selected_rop)

                # Frame range
                if rop_node.parmTuple("f"):
                    frame_values = rop_node.parmTuple("f").eval()
                    self.start_frame.setValue(int(frame_values[0]))
                    self.end_frame.setValue(int(frame_values[1]))
                    self.frame_step.setValue(int(frame_values[2]))

        except Exception as e:
            QMessageBox.critical(self, "Error loading ROPs", str(e))



    def submit_job(self):
        job_name = self.job_name.text()
        project_folder = self.folder_line_edit.text()
        hou_file = self.hipfile_line_edit.text()
        rop_node = self.text_input.text()

        frame_range = (self.start_frame.value(), self.end_frame.value(), self.frame_step.value())
        cpus = self.spinbox.value()
        output_override = self.output_path_edit.text()

        if not job_name or not hou_file or not rop_node:
            QMessageBox.critical(self, "Missing Information", "Please fill in all required fields:     \n- Job Name\n- Project Folder\n- Houdini File\n- ROP Node \n")
            return
        
        try:
            # Get username (default to current user)
            default_username = os.getenv('USER') or os.getenv('USERNAME') or 'user'
            username, ok = QInputDialog.getText(self, 'Username', 'Enter username:', text=default_username)
            if not ok or not username:
                raise Exception("Invalid Username")
                
            # Get password
            password, ok = QInputDialog.getText(self, 'Password', 'Enter password:', QLineEdit.Password)
            if not ok or not password:
                raise Exception("Invalid Password")

            print(f"""
            Submitting job: {job_name}
            {f"Project Folder: {project_folder}" if project_folder else ""}
            Houdini File: {hou_file}
            ROP Node: {rop_node}
            Frame Range: {frame_range}
            Number of CPU Nodes: {cpus}
            {f"Output File Path Override: {output_override}" if output_override else ""}
            Username: {username}              
            """)

            remote_project_folder = os.path.join(f"/home", username, job_name)
            remote_hou_file = hou_file.replace(project_folder, remote_project_folder)
            
            tete = Tete(username, password)

            print("Uploading: ", project_folder, "->", remote_project_folder)

            tete.upload(project_folder, remote_project_folder)
            tete.close()

            print("Uploaded!")

            args = [
                "--job-name", job_name,
                "--hipfile", remote_hou_file,
                "--project", remote_project_folder,
                "--rop", rop_node,
                "--frames", f"{frame_range[0]}-{frame_range[1]}x{frame_range[2]}",
                "--username", username,
                "--cpus", str(cpus)
            ]

            args.extend(["--output", output_override])

            cmd = ["uvx", "python@3.8", os.path.join(str(Path(__file__).parent), "submit_py38.py")] + args

            result = subprocess.run(
                cmd,
                capture_output=True,
                text=True
            )

            if result.returncode != 0:
                error_msg = f"Submission failed:\n{result.stderr}"
                print(error_msg)  # Debug
                raise Exception(error_msg)

            print("Job submitted successfully!")
            print(result.stdout)

        except Exception as e:
            QMessageBox.critical(self, "Error submitting Job", str(e))
            import traceback
            traceback.print_exc()
        

def apply_dark_theme(app):
    dark_palette = QPalette()
    dark_palette.setColor(QPalette.Window, QColor(53, 53, 53))
    dark_palette.setColor(QPalette.WindowText, Qt.white)
    dark_palette.setColor(QPalette.Base, QColor(25, 25, 25))
    dark_palette.setColor(QPalette.AlternateBase, QColor(53, 53, 53))
    dark_palette.setColor(QPalette.ToolTipBase, Qt.white)
    dark_palette.setColor(QPalette.ToolTipText, Qt.white)
    dark_palette.setColor(QPalette.Text, Qt.white)
    dark_palette.setColor(QPalette.Button, QColor(53, 53, 53))
    dark_palette.setColor(QPalette.ButtonText, Qt.white)
    dark_palette.setColor(QPalette.BrightText, Qt.red)
    dark_palette.setColor(QPalette.Highlight, QColor(142, 45, 197).lighter())
    dark_palette.setColor(QPalette.HighlightedText, Qt.black)
    app.setPalette(dark_palette)
    app.setStyle("Fusion")

def main():
    houdini_python_path = "/opt/hfs20.5.332/houdini/python3.11libs"
    sys.path.append(houdini_python_path)

    try:
        import hou
        print("Houdini API loaded successfully!")
    except ImportError as e:
        print("Could not import hou module. Make sure Houdini is installed and the path is correct.")
        print(e)
        return

    app = QApplication(sys.argv)
    apply_dark_theme(app)
    window = DarkThemeApp()
    window.show()
    sys.exit(app.exec())

if __name__ == "__main__":
    main()