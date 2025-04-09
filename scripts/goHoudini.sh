#!/bin/bash

############################################
# Set Environment Variables
############################################

# Setup Environment Variables
HERE=$(pwd)
FILE=""

# Custom OCIO Config from Jeremy Hardin
# export OCIO=/public/bapublic/jhardin/tools/OCIO/BU_nov2024_config.ocio

# LICENSE SERVERS
export SESI_LMHOST=lepe.bournemouth.ac.uk

# Houdini Environment Variables
HFS="/opt/hfs20.5.332"
HFS_VERSION="20.5"
PYTHON_VERSION="python3.11"
export HOUDINI_DSO_ERROR=1

# Houdiin Setup Script
cd $HFS
source houdini_setup_bash

# Clear PYTHONPATH to avoid any issues
PYTHONPATH=""

# Default of HOUDINI_TEMP_DIR is on the root partition in /tmp so moving it to /transfer
# Check if /transfer is mounted
if ! mountpoint -q /transfer; then
    echo "/transfer is not mounted. Using fallback path for HOUDINI_TEMP_DIR."
    export HOUDINI_TEMP_DIR="$HOME/tmp/houdini_temp"
else
    export HOUDINI_TEMP_DIR=/transfer/houdini_temp
fi

############################################
# Plugins
############################################

# Initialize render engines to be disabled by default
USE_RENDERMAN=false
USE_ARNOLD=false

# Check command-line arguments for render engine flags
for arg in "$@"; do
    case $arg in
        --prman)
            USE_RENDERMAN=true
            ;;
        --arnold)
            USE_ARNOLD=true
            ;;
        *)
            FILE="$FILE $arg"
            ;;
    esac
done

export HOUDINI_PATH=$HOUDINI_PATH:$HOME/houdini$HFS_VERSION:$HFS/houdini:/opt/sidefx_packages/SideFXLabs$HFS_VERSION

# ----- Renderman ----- #
#
# RENDERMAN IS CRASHING
# Memory Allocation Error: A memory allocation error occurred, probably due to insufficient memory.
# 34493: Fatal error: Segmentation fault (sent by pid 34493)
# Spawn Error: : No such file or directory
# Error running xmessage
# Argument list:
#   0: xmessage
#   1: A memory allocation error occurred, probably
# due to insufficient memory.
# Crash log saved to /transfer/houdini_temp/crash.s5605094_34493_log.txt
# sh: xmessage: command not found
#
# Crash report from 97cae600; Unknown App Version 20.5.332 [linux-x86_64-gcc11.2]
#Uptime 0 seconds
#Thu Feb  6 13:36:31 2025
#Caught signal 11

#Traceback from 34493 ThreadId=0x7fc1910cb400
#AP_Interface::coreDumpChaser(UTsignalHandlerArg) <libHoudiniUI.so>
#AP_Interface::si_CrashHandler::chaser(UTsignalHandlerArg) <libHoudiniUI.so>
#signalCallback(UTsignalHandlerArg) <libHoudiniUT.so>
#UT_Signal::UT_ComboSignalHandler::operator()(int, siginfo_t*, void*) const <libHoudiniUT.so>
#UT_Signal::processSignal(int, siginfo_t*, void*) <libHoudiniUT.so>
#__funlockfile <libpthread.so.0>
#gsignal <libpthread.so.0>
#UT_NoMemHandler::classNewHandler(unsigned long) <libHoudiniUT.so>
#operator new(unsigned long) <libstdc++.so.6>
#std::messages<wchar_t>::do_open(std::string const&, std::locale const&) const <libstdc++.so.6>
#std::ctype<wchar_t>::_M_initialize_ctype() <libstdc++.so.6>
#std::ctype<wchar_t>::_M_initialize_ctype() <libstdc++.so.6>
#std::__detail::_BracketMatcher<std::regex_traits<char>, true, true>::~_BracketMatcher() <PyOpenColorIO.so>
#void std::__introsort_loop<__gnu_cxx::__normal_iterator<char*, std::vector<char, std::allocator<char> > >, long, __gnu_cxx::__ops::_Iter_less_iter>(__gnu_cxx::__normal_iterator<char*, std::vector<char, std::allocator<char> > >, __gnu_cxx::__normal_iterator<char*, std::vector<char, std::allocator<char> > >, long, __gnu_cxx::__ops::_Iter_less_iter) <PyOpenColorIO.so>
#void std::__introsort_loop<__gnu_cxx::__normal_iterator<char*, std::vector<char, std::allocator<char> > >, long, __gnu_cxx::__ops::_Iter_less_iter>(__gnu_cxx::__normal_iterator<char*, std::vector<char, std::allocator<char> > >, __gnu_cxx::__normal_iterator<char*, std::vector<char, std::allocator<char> > >, long, __gnu_cxx::__ops::_Iter_less_iter) <PyOpenColorIO.so>
#void std::__introsort_loop<__gnu_cxx::__normal_iterator<char*, std::vector<char, std::allocator<char> > >, long, __gnu_cxx::__ops::_Iter_less_iter>(__gnu_cxx::__normal_iterator<char*, std::vector<char, std::allocator<char> > >, __gnu_cxx::__normal_iterator<char*, std::vector<char, std::allocator<char> > >, long, __gnu_cxx::__ops::_Iter_less_iter) <PyOpenColorIO.so>
#void std::__introsort_loop<__gnu_cxx::__normal_iterator<char*, std::vector<char, std::allocator<char> > >, long, __gnu_cxx::__ops::_Iter_less_iter>(__gnu_cxx::__normal_iterator<char*, std::vector<char, std::allocator<char> > >, __gnu_cxx::__normal_iterator<char*, std::vector<char, std::allocator<char> > >, long, __gnu_cxx::__ops::_Iter_less_iter) <PyOpenColorIO.so>
#RMANOCIO::Config::CreateFromFile(char const*) <PyOpenColorIO.so>
#pybind11::cpp_function::initialize<std::shared_ptr<RMANOCIO::Config const> (*&)(char const*), std::shared_ptr<RMANOCIO::Config const>, char const*, pybind11::name, pybind11::scope, pybind11::sibling, pybind11::arg, char const*>(std::shared_ptr<RMANOCIO::Config const> (*&)(char const*), std::shared_ptr<RMANOCIO::Config const> (*)(char const*), pybind11::name const&, pybind11::scope const&, pybind11::sibling const&, pybind11::arg const&, char const* const&)::{lambda(pybind11::detail::function_call&)#3}::_FUN(pybind11::detail::function_call&) <PyOpenColorIO.so>
#pybind11::cpp_function::dispatcher(_object*, _object*, _object*) <PyOpenColorIO.so>
#cfunction_call <libpython3.11.so.1.0>
#_PyObject_MakeTpCall.localalias <libpython3.11.so.1.0>
#_PyEval_EvalFrameDefault.localalias <libpython3.11.so.1.0>
#method_vectorcall <libpython3.11.so.1.0>
#_PyEval_EvalFrameDefault.localalias <libpython3.11.so.1.0>
#_PyFunction_Vectorcall.localalias <libpython3.11.so.1.0>
#slot_tp_init <libpython3.11.so.1.0>
#_PyObject_MakeTpCall.localalias <libpython3.11.so.1.0>
#_PyEval_EvalFrameDefault.localalias <libpython3.11.so.1.0>
#_PyEval_Vector <libpython3.11.so.1.0>
#PyEval_EvalCode.localalias <libpython3.11.so.1.0>
#PY_CompiledCode::evaluateUsingDicts(PY_Result::Type, void*, void*, PY_Result&) const <libHoudiniUT.so>
#PY_CompiledCode::evaluate(PY_Result::Type, PY_Result&) const <libHoudiniUT.so>
#PYrunPythonStatementsFromFile(char const*, PY_EvaluationContext*) <libHoudiniUT.so>
#MOT_Director::execPythonRCFiles() <libHoudiniOPZ.so>
#MOT_Director::MOT_Director(UT_StringHolder const&, bool, bool, bool) <libHoudiniOPZ.so>
#OPUI_MainApp::initApplication(UI_Manager*, int, char const**) <libHoudiniAPPS2.so>
#main <libHoudiniUI.so>
#__libc_start_main <libc.so.6>
#[0x40365c] <houdini-bin>
# 

RENDERMAN_VERSION=26.2
if $USE_RENDERMAN; then
    echo "Renderman 26.2 is broken!"
    export PIXAR_LICENSE_FILE=9010@talavera.bournemouth.ac.uk

   export RMANTREE=/opt/pixar/RenderManProServer-$RENDERMAN_VERSION
   export RFHTREE=/opt/pixar/RenderManForHoudini-$RENDERMAN_VERSION
   export RMAN_PROCEDURALPATH=$RFHTREE/$PYTHON_VERSION/20.5.278/openvdb:&
   export PATH=$RMANTREE/bin:$PATH
   export PYTHONPATH=$RMANTREE/bin:$PYTHONPATH
   
   RFH=$RFHTREE/3.11/20.5.278
   export HOUDINI_PATH=$HOUDINI_PATH:$RFH

else
    echo "RenderMan for Houdini is disabled. Use --prman to enable. (BROKEN)"
fi

# ----- Arnold ----- #
# Users will need to install the correct HtoA version from the Autodesk site and install it locally.
if $USE_ARNOLD; then
    export HOUDINI_PATH=$HOUDINI_PATH:$HTOA
else
    echo "Arnold for Houdini is disabled. Use --arnold to enable."
fi

############################################
# Launching
############################################

# Change back to the original directory
cd $HERE

echo "Starting Houdini from $HFS - this can take a few seconds..."
echo
houdini $FILE &