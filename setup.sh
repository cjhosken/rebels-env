SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTALL_DIR=$HOME/.rebels
USERNAME=$(whoami)

/public/devel/24-25/bin/new_install_python.sh

echo "REBELS: Installing scripts in $HOME/.rebels..."
cp -r $SCRIPT_DIR/* $INSTALL_DIR -n

echo "Installing Software dependencies..."

REBELS_SOFTWARE_DIR="$INSTALL_DIR/software"

uv pip install -r $REBELS_SOFTWARE_DIR/houTete/requirements.txt
uv pip install -r $REBELS_SOFTWARE_DIR/splash/requirements.txt

cd $INSTALL_DIR
git pull

echo "REBELS: Setting up .bashrc..."
echo '# REBELS SOURCE - DO NOT MODIFY"' >> ~/.bashrc
echo "source ~/.rebels/source.sh" >> ~/.bashrc