SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
USERNAME=$(whoami)

echo "Running script as $USERNAME"
cd "$SCRIPT_DIR" || exit 1

# Check for Git updates
echo "Checking for updates..."
if ! git pull; then
    echo "Git pull failed. Check SSH key or network."
    exit 1
fi



#TODO Setup the REBELS onedrive link. (make it work on restart)
#TODO Setup Go Scripts
#TODO Setup Tools