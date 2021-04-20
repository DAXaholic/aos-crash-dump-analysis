# ----------------------------------------------------------------------------
# Description: Sets up the automatic analysis of new crash dumps by creating
#              a scheduled task which calls auto_analysis.ps1 every minute.
# Author:      Aaron Kunz
# Date:        2014-05-23
# ----------------------------------------------------------------------------

Set-StrictMode -Version Latest

function CurrentScriptDirectory() {
    return Split-Path $Script:MyInvocation.MyCommand.Path
}

function CreateScheduledTask() {
    $task_command = "wscript " +
                    "'$run_silent_ps_script_file' " +
                    "'$auto_analysis_script_file'"
    [void]$(schtasks /Create /TN $scheduled_task_name `
                     /SC MINUTE /MO 1 `
                     /TR $task_command)
}

function DeleteExistingScheduledTask() {
    [void]$(schtasks /Query /TN $scheduled_task_name 2>&1)
    if ($LASTEXITCODE -eq 0) {
        [void]$(schtasks /Delete /F /TN $scheduled_task_name)
    }
}

function CreateConfigurationFile() {
    if (!(Test-Path $appdata_path)) {
        [void](New-Item $appdata_path -Force -Type Directory)
    }
    Copy-Item $config_template_file $config_file -Force
}

function ThrowIfNo7Zip() {
    if (!($7zip_available)) {
        throw "Environment variable '7ZIP_PATH' doesn't exist"
    }
}

function Main() {
    ThrowIfNo7Zip
    CreateConfigurationFile
    DeleteExistingScheduledTask
    CreateScheduledTask
}

# Dot source common.ps1
$common_script = Join-Path (CurrentScriptDirectory) "common.ps1"
. $common_script

# Script entry point
Main
