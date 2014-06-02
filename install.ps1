# ----------------------------------------------------------------------------
# Create directory under %PROGRAMFILES% and copy application files.
# ----------------------------------------------------------------------------

Set-StrictMode -Version Latest

$application_files = "README.rst",
                     "LICENSE",
                     "INSTALL.rst",
                     "common.ps1",
                     "analyse_crash_dump.ps1",
                     "analyse_impl.py",
                     "context.py",
                     "callstack.py",
                     "set_up_auto_analysis.ps1",
                     "config_template.xml",
                     "auto_analysis.ps1",
                     "run_powershell_script_silently.vbs"

function CurrentScriptDirectory() {
    return Split-Path $Script:MyInvocation.MyCommand.Path
}

function CopyApplicationFilesToApplicationDirectory() {
    foreach ($file in $application_files) {
        $file_path = Join-Path (CurrentScriptDirectory) $file
        Copy-Item $file_path $application_path -Force
    }
}

function CreateApplicationDirectory() {
    if (!(Test-Path $application_path)) {
        [void](New-Item $application_path -Force -Type Directory)
    }
}

function InstallApplication() {
    CreateApplicationDirectory
    CopyApplicationFilesToApplicationDirectory
}

function ThrowIfNoDebuggingTools() {
    if (!($debugging_tools_available)) {
        throw "Environment variable 'WIN_DEBUGGING_TOOLS_PATH' doesn't exist"
    }
}

function Main() {
    ThrowIfNoDebuggingTools
    InstallApplication
}

# Dot source common.ps1
$common_script = Join-Path (CurrentScriptDirectory) "common.ps1"
. $common_script

# Script entry point
Main
