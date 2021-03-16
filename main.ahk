#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#SingleInstance force
#Persistent
#include <AutoHotInterception>

#Include, Voicemeeter\Voicemeeter.ahk

DetectHiddenWindows, On
config_file:="./config/config.ini"

activateKeyboards() {
    AHI := new AutoHotInterception()
    id1 := AHI.GetKeyboardId(0x05AC, 0x0221, 1)
    id2 := AHI.GetKeyboardIdFromHandle("HID\UVHID&Col04", 1)
    global kb1 := AHI.CreateContextManager(id1)
    global kb2 := AHI.CreateContextManager(id2)
}

activateKeyboards()

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
^+t::
    WinGet, title
    MsgBox, 0, Hfdk, %title%
c::Open("Chrome.exe")  ; Open Chrome
^c::Run chrome.exe "--new-window " ; Open new window for chrome

d::Open("C:\Users\zareg\AppData\Local\Discord\Update1.exe --processStart Discord.exe") ; Open Discord
g::Run, "https://GitHub.com" ; Open GitHub
y::Run, "https://youtube.com" ; Open Youtube
t::Run, "https://twitch.tv" ; Open Youtube

; Type current Project directory
p::
    IniRead, WorkingDir, %config_file%, project, workingDir
    SendInput, %WorkingDir%
    return
; Set Project directory for current project
^w::
    IniRead, OldWorkingDir, %config_file%, project, workingDir
    if OldWorkingDir = "ERROR"
        FileSelectFolder, WorkingDir, ,3
    else
        FileSelectFolder, WorkingDir, *%OldWorkingDir%,3
    WorkingDir := RegExReplace(WorkingDir, "\\$")
    if (WorkingDir = "") 
        return   
    OldWorkingDir := WorkingDir
    IniWrite, %OldWorkingDir%, %config_file%, project, workingDir
    return
; Go to Dir and git pull
!w::
    IniRead, WorkingDir, %config_file%, project, workingDir
    Run, %ComSpec% /k cd %WorkingDir% && git pull
    return
#if

^Esc::
	ExitApp
    