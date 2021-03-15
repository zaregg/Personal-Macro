#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%

#Include <VMR>

#Include, ./main.ahk

activateKeyboards()

voicemeeter := new VMR()
voicemeeter.login()

voicemeeter.recorder["mode.PlayOnLoad"]:= true

voicemeeter.recorder.load:= "D:\Music\Trance-Music-for-Racing-Game.mp3"

Play(Song) {
    voicemeeter.recorder.stop:= true
    MsgBox, 0, Bruh, %Song%
    voicemeeter.recorder.load:= %Song%
    voicemeeter.recorder.play:= true
}
#if kb1.IsActive
    m::voicemeeter.bus[7].mute-- ; bind ctrl+M to toggle mute bus[1]
    ,::Play("D:\Music\why-are-you-gay.mp3")
    .::Send, {Alt down}{F2}{Alt up}
    /::Send, {Alt down}{F3}{Alt up}