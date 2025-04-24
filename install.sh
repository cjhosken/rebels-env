DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTALL_DIR=$HOME/.rebels
USERNAME=$(whoami)
HERE=$(pwd)

# Setting up default install.
git clone git@github.com:cjhosken/ncca-lab-scripts.git $HOME/ncca-lab-scripts
$HOME/ncca-lab-scripts/install.sh
rm -rf $HOME/ncca-lab-scripts

echo "REBELS: Installing scripts in $HOME/.rebels..."
mkdir -p $INSTALL_DIR/{scripts,ocio,tools}

# Copy files only if source exists
[ -d "$DIR/scripts" ] && cp -r $DIR/scripts/* $INSTALL_DIR/scripts/ -n
[ -d "$DIR/ocio" ] && cp -r $DIR/ocio/* $INSTALL_DIR/ocio/ -n
[ -d "$DIR/tools" ] && cp -r $DIR/tools/* $INSTALL_DIR/tools/ -n

uv pip install -r $INSTALL_DIR/tools/houTete/requirements.txt
uv pip install -r $INSTALL_DIR/tools/splash/requirements.txt

# Install ComfyUI
git clone --branch v0.3.29 https://github.com/comfyanonymous/ComfyUI.git $INSTALL_DIR/tools/ComfyUI
uv pip install -r $INSTALL_DIR/tools/ComfyUI/requirements.txt

# Install ComfyUI Manager
git clone https://github.com/Comfy-Org/ComfyUI-Manager.git $INSTALL_DIR/tools/ComfyUI/custom_nodes/ComfyUI-Manager
uv pip install -r $INSTALL_DIR/tools/ComfyUI/custom_nodes/ComfyUI-Manager/requirements.txt

# Install ComfyUI HunYuan3D-2
git clone https://github.com/kijai/ComfyUI-Hunyuan3DWrapper.git $INSTALL_DIR/tools/ComfyUI/custom_nodes/ComfyUI-Hunyuan3DWrapper
uv pip install -r $INSTALL_DIR/tools/ComfyUI/custom_nodes/ComfyUI-Hunyuan3DWrapper/requirements.txt

# Install Stable Diffusion
wget https://huggingface.co/CompVis/stable-diffusion-v-1-4-original/resolve/main/sd-v1-4.ckpt -O $INSTALL_DIR/tools/ComfyUI/models/checkpoints/stablediffusion-v1-4.ckpt
# Install HunYuan3D-2
wget https://huggingface.co/tencent/Hunyuan3D-2mv/resolve/main/hunyuan3d-dit-v2-mv-turbo/model.fp16.safetensors -O $INSTALL_DIR/tools/ComfyUI/models/checkpoints/hunyuan3d-dit-v2-mv-turbo.safetensors

cd $INSTALL_DIR
git pull

SOURCE_SCRIPT="""
# Custom REBELS Go scripts
source $INSTALL_DIR/scripts/source.sh
"""

echo "$SOURCE_SCRIPT" >> ~/.bashrc