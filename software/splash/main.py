import sys
import subprocess
import importlib

from PySide6.QtWidgets import QApplication, QMainWindow, QLabel, QVBoxLayout, QWidget
from PySide6.QtCore import Qt, QTimer, QTime
from PySide6.QtGui import QPalette, QColor, QFont, QShortcut, QPainter, QPen

class LoaderWidget(QWidget):
    def __init__(self, accent):
        super().__init__()

        self.accentColor = accent

        self.setFixedSize(400, 400)  # Set the size of the widget
        self.setWindowFlags(Qt.FramelessWindowHint)  # Hide window border
        self.setAttribute(Qt.WA_TranslucentBackground)  # Transparent background

        self.angle_outer = 0  # Angle for the outer circle
        self.angle_middle = 0
        self.angle_inner = 0  # Angle for the inner circle
        self.timer = QTimer(self)
        self.timer.timeout.connect(self.update_rotation)
        self.timer.start(16)  # ~60 FPS

    def update_rotation(self):
        scale = 2
        self.angle_outer += 1 * scale  # Increment outer circle angle
        self.angle_middle -= 2 * scale
        self.angle_inner += 2 * scale  # Increment inner circle angle (in opposite direction)
        self.update()  # Trigger a redraw of the widget

    def paintEvent(self, event):
        painter = QPainter(self)
        painter.setRenderHint(QPainter.Antialiasing)

        # Get the center of the widget
        widget_width = self.width()
        widget_height = self.height()
        center_x = widget_width / 2
        center_y = widget_height / 2

        # Draw the outer rotating partial circle (sector)
        thickness = 10
        outer_radius = 150  # Radius for the outer circle
        middle_radius = outer_radius - thickness*2
        inner_radius = middle_radius - thickness*2

        pen_outer = QPen(QColor(255, 255, 255))  # White color for outer circle
        pen_outer.setWidth(thickness)  # Set thickness for the outline
        painter.setPen(pen_outer)
        painter.save()
        painter.translate(center_x, center_y)  # Move to the center of the widget
        painter.rotate(self.angle_outer)  # Rotate the outer circle
        start_angle_outer = 0  # Start at 0 degrees (right side of the circle)
        span_angle_outer = 180 * 16  # Draw half the circle (180 degrees)
        painter.drawArc(-outer_radius, -outer_radius, 2 * outer_radius, 2 * outer_radius, start_angle_outer, span_angle_outer)
        painter.restore()

        # Draw the middle rotating partial circle (sector)
        pen_middle_rotate = QPen(self.accentColor)  # Red color for rotating middle circle
        pen_middle_rotate.setWidth(thickness)  # Set thickness for the outline
        painter.setPen(pen_middle_rotate)
        painter.save()
        painter.translate(center_x, center_y)  # Move to the center of the widget
        painter.rotate(self.angle_middle)  # Rotate the middle circle
        start_angle_middle_rotate = 0  # Start at 0 degrees (right side of the circle)
        span_angle_middle_rotate = 90 * 16  # Draw a quarter of the circle (90 degrees)
        painter.drawArc(-middle_radius, -middle_radius, 2 * middle_radius, 2 * middle_radius, start_angle_middle_rotate, span_angle_middle_rotate)
        painter.restore()

        # Draw the inner rotating partial circle (sector)
        pen_inner_rotate = QPen(QColor(255, 255, 255))  # White color for rotating inner circle
        pen_inner_rotate.setWidth(thickness)  # Set thickness for the outline
        painter.setPen(pen_inner_rotate)
        painter.save()
        painter.translate(center_x, center_y)  # Move to the center of the widget
        painter.rotate(self.angle_inner)  # Rotate the inner circle
        start_angle_inner = 0  # Start at 0 degrees (right side of the circle)
        span_angle_inner = 180 * 16  # Draw half the circle (180 degrees)
        painter.drawArc(-inner_radius, -inner_radius, 2 * inner_radius, 2 * inner_radius, start_angle_inner, span_angle_inner)
        painter.restore()

        painter.end()



class MainWindow(QMainWindow):
    def __init__(self, title="RENDERING", subtitle="Please do not touch!", contact="REBELS Team"):
        super().__init__()
        self.setWindowTitle("Splash!")
        self.title_text = title
        self.subtitle_text = subtitle
        self.contact_text = contact

        print(self.contact_text)
        
        self.setup_ui()

        # Start the timer for elapsed time
        self.start_time = QTime(0, 0)  # Start from 00:00:00
        self.timer = QTimer(self)
        self.timer.timeout.connect(self.update_time)
        self.timer.start(1000) 


        # Make the window full screen
        self.showFullScreen()
        
        # Add a shortcut for quitting the application
        self.add_quit_shortcut()

    def setup_ui(self):
        """
        Add a 'RENDERING' label with white text.
        """

        backgroundColor = QColor(15, 20, 35)
        accent = QColor(215, 40, 70)

        palette = QPalette()
        palette.setColor(QPalette.Window, backgroundColor)  # Dark grey
        self.setPalette(palette)
        
        title = QLabel(self.title_text, self)
        title_font = QFont("Arial", 200, QFont.Bold)
        title.setStyleSheet("color: white;")
        title.setFont(title_font)

        subtitle = QLabel(self.subtitle_text, self)
        subtitle_font = QFont("Arial", 50, QFont.Thin)
        subtitle.setStyleSheet("color: white;")
        subtitle.setFont(subtitle_font)

        if (self.contact_text):
            info = QLabel(f"Contact: {self.contact_text}", self)
            info_font = QFont("Arial", 25, QFont.Thin)
            info.setStyleSheet("color: white;")
            info.setFont(info_font)

        self.time_label = QLabel("Time Elapsed: 00:00:00", self)
        self.time_label.setFont(QFont("Arial", 20))
        self.time_label.setStyleSheet("color: white;")
        self.time_label.setAlignment(Qt.AlignCenter)

        loading_circle = LoaderWidget(accent)

        # Set the label's layout
        central_widget = QWidget(self)
        layout = QVBoxLayout(central_widget)
        layout.addStretch()

        layout.addWidget(title, alignment=Qt.AlignCenter)
        layout.addWidget(subtitle, alignment=Qt.AlignCenter)
        layout.addStretch()
        layout.addWidget(self.time_label, alignment=Qt.AlignCenter)
        layout.addWidget(loading_circle, alignment=Qt.AlignCenter)

        if (self.contact_text):
            layout.addWidget(info, alignment=Qt.AlignCenter)
        layout.addStretch()

        central_widget.setLayout(layout)
        
        self.setCentralWidget(central_widget)

    def update_time(self):
        """
        Update the elapsed time every second.
        """
        self.start_time = self.start_time.addSecs(1)  # Increase time by 1 second
        formatted_time = self.start_time.toString("hh:mm:ss")  # Format time as HH:MM:SS
        self.time_label.setText(f"Time Elapsed: {formatted_time}")  # Update the label text

    def add_quit_shortcut(self):
        """
        Add a keyboard shortcut (Ctrl+Q) to quit the application.
        """
        quit_shortcut = QShortcut(Qt.CTRL | Qt.Key_Q, self)
        quit_shortcut.activated.connect(self.close_application)

    def close_application(self):
        """
        Gracefully close the application.
        """
        self.close()

def main():
    if len(sys.argv) < 4 or "-h" in sys.argv or "--help" in sys.argv:
        print("Usage: python script.py <title_text> <subtitle_text> <contact_info>")
        sys.exit(1)

    title_text = sys.argv[1]  # First argument is the title text
    subtitle_text = sys.argv[2]  # Second argument is the subtitle text
    contact_text = sys.argv[3]  # Third argument is the contact text

    app = QApplication(sys.argv)
    window = MainWindow(title_text, subtitle_text, contact_text)
    sys.exit(app.exec())

if __name__ == "__main__":
    main()