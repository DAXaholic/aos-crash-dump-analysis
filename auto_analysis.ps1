# ----------------------------------------------------------------------------
# Description: Performs the automatic analysis of new dumps. This script will
#              be triggered by the scheduled task which was set up by
#              set_up_auto_analysis.ps1.
# Author:      Aaron Kunz
# Date:        2014-05-24
# ----------------------------------------------------------------------------

Set-StrictMode -Version Latest

$log_enabled = $false
$dump_sources = @()
$retention_period = [timespan]::Zero

function CurrentScriptDirectory() {
    return Split-Path $Script:MyInvocation.MyCommand.Path
}

function Log($message) {
    Write-Host $message
    if ($log_enabled) {
        Add-Content $log_file $message
    }
}

function CleanUpDumpSourceMovePath($move_path) {
    $now = [datetime]::UtcNow
    Get-ChildItem -Path $move_path |
        Where-Object { ($now - $_.CreationTimeUtc) -gt $retention_period } |
        ForEach-Object { Remove-Item -Path $_.FullName -Force }
}

function AnalysisFileNameForDumpFile($dump) {
    return (Join-Path $dump.Directory.FullName $dump.BaseName) + ".txt"
}

function CompressedDumpFileNameForDumpFile($dump) {
    return (Join-Path $dump.Directory.FullName $dump.BaseName) + ".7z"
}

function MoveDumpAndAnalysisFileToDestination($dump, $move_path) {
    if (!(Test-Path $move_path)) {
        [void](New-Item $move_path -ItemType Directory)
    }
    if (Test-Path $dump) {
        Move-Item $dump $move_path -Force
    }
    $analysis_name = AnalysisFileNameForDumpFile $dump
    if (Test-Path $analysis_name) {
        Move-Item $analysis_name $move_path -Force
    }
    $archive_name = CompressedDumpFileNameForDumpFile $dump
    if (Test-Path $archive_name) {
        Move-Item $archive_name $move_path -Force
    }
}

function CompressDumpFile($dump) {
    if ($7zip_available) {
        $archive_name = CompressedDumpFileNameForDumpFile $dump
        [void](& $7zip_exe a $archive_name $dump.FullName)
        if ($LASTEXITCODE -eq 0) {
            Remove-Item $dump.FullName
        }
    }
}

function AnalyseDumpFile($dump) {
    $analysis_name = AnalysisFileNameForDumpFile $dump
    & $analyse_script_file $dump.FullName | Out-File $analysis_name
}

function IsFileBeingWritten($file) {
    $init_length = $file.Length
    Start-Sleep 1
    $new_length = $file.Length
    return $init_length -ne $new_length
}

function ProcessDumpFile($dump) {
    Log ("Process dump '{0}'" -f $dump.Name)
    if (IsFileBeingWritten $dump) {
        Log ("Skip dump '{0}' as it is still written" -f $dump.Name)
    }
    else {
        AnalyseDumpFile $dump
        CompressDumpFile $dump
    }
}

function ProcessDumpSource($source_path, $move_path) {
    if (!(Test-Path $source_path)) {
        Log ("Source path '{0}' doesn't exist" -f $source_path)
        return
    }
    $dumps = @(Get-ChildItem $source_path | ? {$_.Name -like "*.dmp"})
    foreach ($d in $dumps) {
        ProcessDumpFile $d
        MoveDumpAndAnalysisFileToDestination $d $move_path
    }
    CleanUpDumpSourceMovePath $move_path
}

function ProcessDumpSources {
    Log ("Started on {0}" -f (Get-Date -Format s))
    foreach ($ds in $dump_sources) {
        ProcessDumpSource $ds.source_path $ds.move_path
    }
    Log ("Finished on {0}" -f (Get-Date -Format s))
}

function ParsePeriodString($period_string) {
    try {
        return [System.Xml.XmlConvert]::ToTimeSpan($period_string)
    }
    catch {
        return $null
    }
}

function ReadConfigurationFile() {
    $xmldoc = [xml](Get-Content $config_file)
    $configuration = $xmldoc.configuration
    $options = $configuration.options
    $Script:log_enabled = $options.log -eq "true"
    $Script:dump_sources = $configuration.dump_source
    $Script:retention_period = ParsePeriodString $options.retention_period
    if ($Script:retention_period -eq $null) {
        Log ("Retention period {0} is invalid." -f $options.retention_period)
        $Script:retention_period = [timespan]::MaxValue
    }
}

function Main() {
    ReadConfigurationFile
    ProcessDumpSources
}

# Dot source common.ps1
$common_script = Join-Path (CurrentScriptDirectory) "common.ps1"
. $common_script

# Script entry point
Main
