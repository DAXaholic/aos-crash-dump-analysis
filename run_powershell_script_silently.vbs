' ----------------------------------------------------------------------------
' Description:   Runs a PowerShell script without a console window.
'                Even with the command line argument '-windowstyle hidden'
'                there is shortly shown a console window. Therefore this helper
'                script was created.
' Author:        Aaron Kunz
' Creation Date: 2014-05-24
' ----------------------------------------------------------------------------

Option Explicit

dim shell
set shell = CreateObject("WScript.Shell")

dim powershellscript
powershellscript = Wscript.Arguments(0)

shell.Run "powershell &'" & powershellscript & "'", 0, True
