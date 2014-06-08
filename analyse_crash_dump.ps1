# ----------------------------------------------------------------------------
# Show context and call stack of an AOS crash dump
# ----------------------------------------------------------------------------

Set-StrictMode -Version Latest

function CurrentScriptDirectory() {
    return Split-Path $Script:MyInvocation.MyCommand.Path
}

function DumpFileName() {
    return $Script:args[0]
}

function AnalyseDump() {
    $dump_arg = DumpFileName
    & $python2_exe $analyse_impl_script_file $dump_arg
}

function ThrowIfNoDebuggingTools() {
    if (!$debugging_tools_available) {
        throw "Environment variable 'WIN_DEBUGGING_TOOLS_PATH' doesn't exist"
    }
}

function ThrowIfNoPython() {
    if (!$python2_available) {
        throw "Environment variable 'PYTHON2_PATH' doesn't exist"
    }
}

function CheckArguments() {
    if ($Script:args.Count -ne 1) {
        throw "Exactly one argument expected"
    }
}

function Main() {
    CheckArguments
    ThrowIfNoDebuggingTools
    ThrowIfNoPython
    AnalyseDump
}

# Dot source common.ps1
$common_script = Join-Path (CurrentScriptDirectory) "common.ps1"
. $common_script

# Script entry point
Main
