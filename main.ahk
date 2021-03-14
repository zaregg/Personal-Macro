#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#SingleInstance force
#Persistent
#include <AutoHotInterception>

AHI := new AutoHotInterception()
id1 := AHI.GetKeyboardId(0x05AC, 0x0221, 1)
id2 := AHI.GetKeyboardIdFromHandle("HID\UVHID&Col04", 1)
kb1 := AHI.CreateContextManager(id1)
kb2 := AHI.CreateContextManager(id2)

IfNotExist, ./config
    FileCreateDir, ./config
return

Open(Program)
{
    Process, Exist, %Program%
    pid := ErrorLevel
    if pid = 0
        run, %Program%
    else if !WinActive("AHK_PID " pid)
        WinActivate, AHK_PID %pid%
    return 
}
#if kb2.isActive 
Numpad2::Send #{Down}
Numpad4::Send #+{Left}
Numpad6::Send #+{Right}
Numpad8::Send #{Up}
^c::Open("Chrome.exe")
^d::Open("C:\Users\zareg\AppData\Local\Discord\Update1.exe --processStart Discord.exe")
^y::Run, "https://youtube.com"
^t::Run, "https://twitch.tv"

#if kb1.IsActive
c::Open("Chrome.exe")  ; Open Chrome
^c::Run chrome.exe "--new-window " ; Open new window for chrome

d::Open("C:\Users\zareg\AppData\Local\Discord\Update1.exe --processStart Discord.exe") ; Open Discord
g::Run, "https://GitHub.com" ; Open GitHub

; Type current Project directory
p::
    IniRead, WorkingDir, ./config/config.ini, project, dir
    SendInput, %WorkingDir%
    return
; Set Project directory for current project
^w::
    IniRead, OldWorkingDir, ./config/config.ini, project, dir
    if OldWorkingDir = "ERROR"
        FileSelectFolder, WorkingDir, ,3
    else
        FileSelectFolder, WorkingDir, *%OldWorkingDir%,3
    WorkingDir := RegExReplace(WorkingDir, "\\$")
    if (WorkingDir = "") 
        return
    OldWorkingDir := WorkingDir
    IniWrite, %OldWorkingDir%, ./config/config.ini, project, dir
    return
; Go to Dir and git pull
!w::
    IniRead, WorkingDir, ./config/config.ini, project, dir
    Run, %ComSpec% /k cd %WorkingDir% && git pull
    return
#if

^Esc::
	ExitApp
