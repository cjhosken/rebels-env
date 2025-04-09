SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTALL_DIR=$HOME/.rebels
USERNAME=$(whoami)

echo "REBELS: Installing scripts in $HOme/.rebels"
git clone git@github.com:cjhosken/ncca-lab-scripts.git $INSTALL_DIR

cd $INSTALL_DIR
git pull



echo "REBELS: Setting up .bashrc..."
BASHRC="$HOME/.bashrc"


touch $BASHRC

SOURCE_COMMAND="source $INSTALL_DIR/source.sh"
    
# Check if marker exists
if ! grep -qF "$SOURCE_COMMAND" "$BASHRC"; then
    echo "" >> "$BASHRC"
    echo "" >> "$BASHRC"
    echo "# REBELS SOURCE - DO NOT MODIFY" >> "$BASHRC"
    echo "" >> "$BASHRC"
    echo "$SOURCE_COMMAND" >> "$BASHRC"
fi