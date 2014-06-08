# ----------------------------------------------------------------------------
# Common constants and variables
# ----------------------------------------------------------------------------

Set-StrictMode -Version Latest

$debugging_tools_path = $Env:WIN_DEBUGGING_TOOLS_PATH
$debugging_tools_available = $debugging_tools_path -ne $null

$python2_path = $Env:PYTHON2_PATH
$python2_exe = Join-Path $python2_path "python.exe"
$python2_available = Test-Path $python2_exe

$7zip_path = $Env:7ZIP_PATH
$7zip_exe = Join-Path $7zip_path "7z.exe"
$7zip_available = Test-Path $7zip_exe

$application_name = "AOSCrashDumpAnalysis"
$application_path = Join-Path $Env:PROGRAMFILES $application_name
$analyse_script_file = Join-Path $application_path "analyse_crash_dump.ps1"
$analyse_impl_script_file = Join-Path $application_path "analyse_impl.py"
$auto_analysis_script_file = Join-Path $application_path "auto_analysis.ps1"
$config_template_file = Join-Path $application_path "config_template.xml"
$run_silent_ps_script_file = Join-Path $application_path `
                                       "run_powershell_script_silently.vbs"

$appdata_path = Join-Path $Env:APPDATA $application_name
$config_file = Join-Path $appdata_path "config.xml"
$log_file = Join-Path $appdata_path "log.txt"

$scheduled_task_name = $application_name
