echo "REBELS: Starting HouTete - this can take a few seconds..."
echo

DIR=$(dirname "$(realpath "${BASH_SOURCE[0]}")")

python $DIR/../tools/houTete/main.py

echo "REBELS: HouTete has quit."