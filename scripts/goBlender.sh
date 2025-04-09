#!/bin/bash

############################################
# Set Environment Variables
############################################

# Custom OCIO Config from Jeremy Hardin
# export OCIO=/public/bapublic/jhardin/tools/OCIO/BU_nov2024_config.ocio

############################################
# Plugins
############################################

# ----- Renderman ----- #
# RENDERMAN IS CRASHING
#
# [INFO] (MainThread) RenderManForBlender.rfb_logger start_interactive_render: Parsing scene...
# [DEBUG] (MainThread) RenderManForBlender.rfb_logger export: Creating root scene graph node
# [DEBUG] (MainThread) RenderManForBlender.rfb_logger export: Calling export_materials()
# [DEBUG] (MainThread) RenderManForBlender.rfb_logger export_shader_nodetree: Error Material Material needs a RenderMan BXDF
# [DEBUG] (MainThread) RenderManForBlender.rfb_logger export: Calling txmake_all()
# /home/s5605094/scripts/goBlender.sh: line 28: 35053 Aborted                 (core dumped) $HOME/software/blender-4.2.3-linux-x64/blender

export RFB_LOG_LEVEL=DEBUG

# ----- Arnold ----- #
export LD_LIBRARY_PATH=$HOME/Autodesk/btoa/bin:$LD_LIBRARY_PATH

############################################
# Launching
############################################

echo "Starting Blender - this can take a few seconds..."
echo
$HOME/software/blender-4.2.3-linux-x64/blender

echo "Blender has quit."