Set shell = CreateObject("WScript.Shell" )
shell.Run """C:\Program Files\VcXsrv\fullscreen.xlaunch"""
shell.Run "arch -c ""~/.scripts/startup.sh""", 0
