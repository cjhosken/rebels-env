echo "REBELS: Starting HouTete - this can take a few seconds..."
echo

unset QT_PLUGIN_PATH
unset XDG_DATA_DIRS


DIR=$(dirname "$(realpath "${BASH_SOURCE[0]}")")

export QB_SUPERVISOR=tete.bournemouth.ac.uk
export QB_DOMAIN=ncca
export PYTHONPATH=""
export QBDIR=/public/devel/2022/pfx/qube/
export PATH=$PATH:$QBDIR/bin:$QBDIR/sbin

SEARCH_PATH="$HOME/.ncca/plugins/htoa"
HTOA=$(ls -d $SEARCH_PATH/htoa-* 2>/dev/null | head -n 1)

export HOUDINI_PATH=$HTOA:$HOUDINI_PATH

python $DIR/../tools/houTete/main.py

echo "REBELS: HouTete has quit."