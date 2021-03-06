#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%

#Include <VMR>

#Include, ./main.ahk

DetectHiddenWindows, On
activateKeyboards()
; FIXME i dont know if all these global variables are bad and/or how to do it differently
global currentlyPlaying
config_file:="./config/config.ini"
global toggle_soundboard := false

global voicemeeter := new VMR()
voicemeeter.login()

voicemeeter.recorder["mode.PlayOnLoad"]:=1
voicemeeter.recorder["mode.Loop"]:=0

LoadSounds(Gui) {
    global sound_array := []
    IniRead, SoundsDir, ./config/config.ini, voicemeeter, soundsDir 
    Loop Files, %SoundsDir%\*, R  ; Recurse into subfolders.
    {
        sound_array.Push(A_LoopFileName)
        IniWrite, %A_LoopFileFullPath%, ./config/config.ini, voicemeeter-sounds, %A_LoopFileName%
        state_bool := toggle_soundboard ? "True" : "False"
        Gui, Add, Text,, Index: %A_Index% - File: %A_LoopFileName% - Soundboard state: %state_bool% 
    }
    if(Gui)
        Gui, show, ,Available Sounds
        SetTimer, Destroy, 5000
        return
}
PlaySound(Sound, name) {
    if (!voicemeeter.recorder.play = 0 and name = currentlyPlaying) {
        voicemeeter.recorder.stop:=1 
        return
    }
    currentlyPlaying := name
    voicemeeter.recorder.load:= Sound
}
readINI(file, ini_section, ini_key) {
    IniRead, OutputVar,  %file%, %ini_section%, %ini_key%
    return OutputVar
}
#if kb1.IsActive and WinExist("ahk_exe voicemeeter8.exe")
    m::
        voicemeeter.bus[7].mute-- ; bind ctrl+M to toggle mute 0q
        if (!voicemeeter.bus[7].mute) {
            ToolTip, Mic muted 
        }else {
            ToolTip, Mic unmuted 
        }
        SetTimer, RemoveToolTip, 3000
        return
    ; Load new sounds
    ^+!l::
        Gui, Destroy
        LoadSounds(true)
        return
    ^+!s:: 
        toggle_soundboard := !toggle_soundboard
        if(toggle_soundboard){
            Gui, Destroy
            Gui, Font, s16
            Gui, Add, Text,, You enabled on the soundboard!!
            Gui, Font, s7
            LoadSounds(false)
            Gui, Show,, Toggle Soundboard!
            SetTimer, Destroy, 1000
            return
        }
        else 
            Gui, Destroy
            Gui, Font, s16
            Gui, Add, Text, x15 y35, You disabled the soundboard!!
            Gui, Show,, Toggle Soundboard!
            SetTimer, Destroy, 1000
            return
            Destroy:
                Gui, Destroy
        return
    ; TODO maybe put this into a function or do it with a GUI
    #if kb1.IsActive and WinExist("ahk_exe voicemeeter8.exe") and toggle_soundboard
    ,::PlaySound(readINI(config_file, "voicemeeter-sounds", sound_array[1]), sound_array[1])
    .::PlaySound(readINI(config_file, "voicemeeter-sounds", sound_array[2]), sound_array[2])
    /::PlaySound(readINI(config_file, "voicemeeter-sounds", sound_array[3]), sound_array[3])
    RShift::PlaySound(readINI(config_file, "voicemeeter-sounds", sound_array[4]), sound_array[4])

    ^+m::
        voicemeeter.recorder.A1--
        if (voicemeeter.recorder.A1) {
            ToolTip, Muted the recorder playback for A1 
        }else {
            ToolTip, Unmuted the recorder playback for A1 
        }
        SetTimer, RemoveToolTip, 3000
        return
        RemoveToolTip:
            ToolTip
        return
#if