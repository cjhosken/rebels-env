import argparse
import sys, os
sys.path.append("/public/devel/2022/pfx/qube/api/python")
import qb

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--job-name", required=True)
    parser.add_argument("--hipfile", required=True)
    parser.add_argument("--rop", required=True)
    parser.add_argument("--frames", help="0-100x1")
    parser.add_argument("--cpus", type=int, default=10)
    parser.add_argument("--project", required=True)
    parser.add_argument("--username", required=True)
    parser.add_argument("--output", default="")
    
    args = parser.parse_args()
    
    setup_command = """
    HFS="/opt/software/hfs20.5.332"
    HFS_VERSION="20.5"
    PYTHON_VERSION="python3.11"
    
    cd $HFS; source houdini_setup_bash
    export HOUDINI_PATH=$HOUDINI_PATH:$HOME/houdini$HFS_VERSION:$HFS/houdini:/opt/sidefx_packages/SideFXLabs$HFS_VERSION
    
    SEARCH_PATH="$HOME/.plugins/htoa"
    HTOA_DIR=$(ls -d $SEARCH_PATH/htoa-* 2>/dev/null | head -n 1)
    if [ -n "$HTOA_DIR" ]; then
        export HTOA="$HTOA_DIR"
        export HOUDINI_PATH="$HOUDINI_PATH:$HTOA"
    else
        echo "Warning: HtoA plugin directory not found!" >&2
    fi

    """
            
    render_command = f"hython $HB/hrender.py -e -F QB_FRAME_NUMBER "
    
    render_command += f"-d {args.rop} "
    render_command += args.hipfile.replace("/home", "/render")

    job_command = setup_command + render_command
        
    print(job_command)

    # Create qb job
    job = {
        "name" : args.job_name,
        "cpus" : int(args.cpus),
        "agenda" : qb.genframes(args.frames),

        "cwd" : os.path.join("/render", args.username),
        "env" : {"HOME" : os.path.join("/render", args.username)},
        "prototype" : "cmdrange",
        "package": {
            "shell" : "/bin/bash",
            "cmdline": job_command
        }
    }

    qb.submit([job])
    
    print(f"Submitted {args.job_name}")

if __name__ == "__main__":
    main()