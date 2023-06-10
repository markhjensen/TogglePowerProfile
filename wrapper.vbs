Set objShell = CreateObject("WScript.Shell")
scriptPath = WScript.Arguments.Item(0)
objShell.Run("powershell -windowstyle hidden -executionpolicy bypass -noninteractive ""&"" ""'" & scriptPath & "'"""),0
