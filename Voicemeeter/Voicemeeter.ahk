#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%

#Include <VMR>

#Include, ./main.ahk

DetectHiddenWindows, On
activateKeyboards()
LoadSounds()

global currentlyPlaying
config_file:="./config/config.ini"
toggle_soundboard := false

global voicemeeter := new VMR()
voicemeeter.login()

voicemeeter.recorder["mode.PlayOnLoad"]:=1
voicemeeter.recorder["mode.Loop"]:=0

LoadSounds() {
    global sound_array := []
    IniRead, SoundsDir, ./config/config.ini, voicemeeter, soundsDir 
    Loop Files, %SoundsDir%\*.mp3, R  ; Recurse into subfolders.
    {
        sound_array.Push(A_LoopFileName)
        IniWrite, %A_LoopFileFullPath%, ./config/config.ini, voicemeeter-sounds, %A_LoopFileName%
    }
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
    m::voicemeeter.bus[7].mute-- ; bind ctrl+M to toggle mute 0q
    ^+!s:: 
        toggle_soundboard := !toggle_soundboard
        Gui, Font, s16
        if(toggle_soundboard)
            Gui, Add, Text, center x15 y35, You enabled on the soundboard!!
        else 
            Gui, Add, Text, x15 y35, You disabled the soundboard!!
        Gui, Show, W350 H100, Toggle Soundboard!
        SetTimer, Destroy, 1000
        return
        Destroy:
            Gui, Destroy
        return
    ; TODO maybe put this into a function
    #if kb1.IsActive and WinExist("ahk_exe voicemeeter8.exe") and toggle_soundboard
    ,::PlaySound(readINI(config_file, "voicemeeter-sounds", sound_array[1]), sound_array[1])
    .::PlaySound(readINI(config_file, "voicemeeter-sounds", sound_array[2]), sound_array[2])
    /::PlaySound(readINI(config_file, "voicemeeter-sounds", sound_array[3]), sound_array[3])
#if