echo "REBELS: Starting Splash - this can take a few seconds..."
echo

#!/bin/bash
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Default values for the arguments
DEFAULT_TITLE="RENDERING"
DEFAULT_SUBTITLE="Please do not touch!"
DEFAULT_CONTACT="The REBELS Team"

# If arguments are provided, use them, otherwise use the default values
TITLE="${1:-$DEFAULT_TITLE}"
SUBTITLE="${2:-$DEFAULT_SUBTITLE}"
CONTACT="${3:-$DEFAULT_CONTACT}"

python3 $REBELS_SOFTWARE_DIR/splash/main.py "$TITLE" "$SUBTITLE" "$CONTACT"

echo "REBELS: Splash has quit."