import os, stat
import paramiko
from PySide6.QtWidgets import QMessageBox, QApplication

class Tete:
    def __init__(self, username, password):
        self.connect(username, password)
        self.app = QApplication.instance()

    def connect(self, username, password):
        transport = paramiko.Transport(("tete.bournemouth.ac.uk", 22))
        transport.connect(None, username, password)
            
        self.sftp = paramiko.SFTPClient.from_transport(transport)

    def exists(self, remote_path=""):
        """
        Check if a file or directory exists on the remote SFTP server.

        Args:
        - sftp: SFTP connection object (not used in this placeholder function).
        - remote_path (str): Path to the remote file or directory.

        Returns:
        - bool: True if the file or directory exists, False otherwise.

        This is a placeholder function that always returns True.
        """
        try:
            self.sftp.stat(remote_path)
        except:
            return False
        return True

    def isdir(self, remote_path=""):
        """
        Check if a path on the remote SFTP server is a directory.

        Args:
        - sftp: SFTP connection object (not used in this placeholder function).
        - remote_path (str): Path to the remote file or directory.

        Returns:
        - bool: True if the path is a directory, False otherwise.

        This is a placeholder function that always returns False.
        """
        try:
            return stat.S_ISDIR(self.sftp.stat(remote_path).st_mode)
        except FileNotFoundError:
            return False

    def isfile(self, remote_path=""):
        """
        Check if a path on the remote SFTP server is a file.

        Args:
        - sftp: SFTP connection object (not used in this placeholder function).
        - remote_path (str): Path to the remote file or directory.

        Returns:
        - bool: True if the path is a file, False otherwise.

        This is a placeholder function that always returns False.
        """
        try:
            return stat.S_ISREG(self.sftp.stat(remote_path).st_mode)
        except FileNotFoundError:
            return False

    def download(self, remote_path="", local_path=""):
        """
        Download a file or directory from the remote SFTP server to the local machine.

        Args:
        - sftp: SFTP connection object.
        - remote_path (str): Path to the remote file or directory.
        - local_path (str): Path to save the downloaded file or directory locally.
        """
        try:
            # Check if the remote path is a directory
            if self.isdir(remote_path):  # Directory mode check
                # If it's a directory, create the local directory
                os.makedirs(local_path, exist_ok=True)
                
                # List contents of the remote directory
                for item in sftp.listdir(remote_path):
                    remote_item_path = os.path.join(remote_path, item)
                    local_item_path = os.path.join(local_path, item)
                    
                    # Recursively download each item
                    self.download(remote_item_path, local_item_path)
            else:
                # If it's a file, download it
                sftp.get(remote_path, local_path)
        except Exception as e:
            print(f"An unexpected error occurred: {e}")

    def upload(self, local_path="", remote_path="", ignore=[]):
        """
        Recursively upload a file or directory from the local machine to the remote SFTP server,
        with the option to ignore specific files or directories.

        Args:
        - sftp: SFTP connection object.
        - local_path (str): Path to the local file or directory.
        - remote_path (str): Path to save the uploaded file or directory on the remote server.
        - ignore (list): List of filenames or directory names to ignore during the upload.
        """

        if self.exists(remote_path):
            response = QMessageBox.question(
                None,
                "Overwrite Confirmation",
                f"'{remote_path}' already exists. Overwrite?",
                QMessageBox.StandardButton.Yes | QMessageBox.StandardButton.No
            )
                
            if response == QMessageBox.StandardButton.No:
                return

            self.delete(remote_path)

        # Check if the local path is a directory
        if os.path.isdir(local_path):
            try:
                self.sftp.mkdir(remote_path)
            except IOError:
                # Directory already exists or error occurred (skip creating)
                pass

            # Iterate over the directory contents
            for item in os.listdir(local_path):
                local_item_path = os.path.join(local_path, item)
                remote_item_path = os.path.join(remote_path, item)

                # Skip the item if it is in the ignore list
                if item in ignore:
                    continue

                # Recursively upload each file or directory
                self.upload(local_item_path, remote_item_path, ignore)
        else:
            # Upload the file if it is not in the ignore list
            if os.path.basename(local_path) not in ignore:
                self.sftp.put(local_path, remote_path)


    def delete(self, remote_path):
        """
        Recursively delete a file or directory on the remote SFTP server.

        Args:
        - sftp: SFTP connection object.
        - remote_path (str): Path to the remote file or directory to delete.
        """
        try:
            if self.isdir(remote_path):
                # If it's a directory, list all its contents
                for item in self.ls(remote_path):
                    item_path = os.path.join(remote_path, item)
                    self.delete(item_path)  # Recursively delete each item
                
                # After all contents are deleted, remove the directory itself
                self.sftp.rmdir(remote_path)
            else:
                # If it's a file, delete it
                self.sftp.remove(remote_path)
        except IOError as e:
            print(f"Failed to delete {remote_path}: {e}")

    def ls(self, path=""):
        if path == "":
            raise ValueError("A Path must be provided")
        try:
            # List the contents of the directory
            directory_contents = self.sftp.listdir(path)
            return directory_contents
        except IOError as e:
            print(f"An error occurred: {e}")
            return []

    def close(self):
        self.sftp.close()