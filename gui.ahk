global macroRunning := false
global statusText
global myGui := false
global linkInput

TraySetIcon("GAGM.ico")

CreateMyGui() {
    global myGui, statusText, linkInput
    myGui := Gui("-MaximizeBox", "GAGM by legend4d")
    myGui.SetFont("s10", "Segoe UI")
    myGui.AddText("x10 y10 w400 h50", "GROW A GARDEN MACRO BY legend4d")
    startBtn := myGui.AddButton("x10 y50 w80 h30", "Start")
    startBtn.OnEvent("Click", StartMacro)
    stopBtn := myGui.AddButton("x110 y50 w80 h30", "Stop")
    stopBtn.OnEvent("Click", StopMacro)
    myGui.AddText("x10 y130 w60 h25", "PS link:")
    linkInput := myGui.AddEdit("x70 y130 w250 h25 vLinkInput")
    statusText := myGui.AddText("x10 y100 w500 h25", "Status: Idle")
    myGui.Show("w600 h170")
}
