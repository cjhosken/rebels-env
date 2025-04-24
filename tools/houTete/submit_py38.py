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
    
    setup_command = """cd /opt/software/hfs20.5.332; source houdini_setup_bash;"""
            
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