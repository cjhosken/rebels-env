echo "REBELS: Starting Splash - this can take a few seconds..."
echo

#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Default values for the arguments
DEFAULT_TITLE="REBELS (FMP)"
DEFAULT_SUBTITLE="Rendering! Please do not touch!"
DEFAULT_CONTACT="""
s5605094@bournemouth.ac.uk
s5603506@bournemouth.ac.uk
s5644639@bournemouth.ac.uk
s5616347@bournemouth.ac.uk
"""

# If arguments are provided, use them, otherwise use the default values
TITLE="${1:-$DEFAULT_TITLE}"
SUBTITLE="${2:-$DEFAULT_SUBTITLE}"
CONTACT="${3:-$DEFAULT_CONTACT}"

python $DIR/../tools/splash/main.py "$TITLE" "$SUBTITLE" "$CONTACT"

echo "REBELS: Splash has quit."