echo "REBELS: Starting ComfyUI - this can take a few seconds..."

DIR=$(dirname "$(realpath "${BASH_SOURCE[0]}")")

python $DIR/../tools/ComfyUI/main.py --auto-launch

echo "REBELS: ComfyUI has quit."