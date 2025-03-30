Set shell = CreateObject("WScript.Shell" )
shell.Run """C:\Program Files\VcXsrv\fullscreen.xlaunch"""
shell.Run "arch -c ""~/.local/bin/startup.sh""", 0
