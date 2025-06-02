#Requires AutoHotkey v2
#Include gui.ahk
#Include imagedetect.ahk

F3::ToggleMacro()

ToggleMacro() {
    global macroRunning
    if macroRunning
        StopMacro()
    else
        StartMacro()
}

StartMacro(*) {
    global macroRunning, statusText, linkInput
    if macroRunning {
        statusText.Text := "Status: Already running"
        return
    }
    if WinExist("ahk_exe RobloxPlayerBeta.exe") {
        macroRunning := true
        statusText.Text := "Roblox already running! Waiting for game to load..."
        WinActivate
        SetTimer(WaitForPng, 500)
        return
    }
    link := Trim(linkInput.Text)
    deepLink := ConvertToDeepLink(link)
    if (deepLink = "") {
        statusText.Text := "Invalid link. Please paste a valid Roblox private server link or deep link."
        return
    }
    macroRunning := true
    statusText.Text := "Joining private server..."
    Run(deepLink)
    SetTimer(WaitForRobloxWindow, 500)
}

StopMacro(*) {
    global macroRunning, statusText, myGui
    macroRunning := false
    SetTimer(RunMacro, 0)
    SetTimer(WaitForRobloxWindow, 0)
    SetTimer(WaitForPng, 0)
    SetTimer(StartMacroAfterDelay, 0)
    statusText.Text := "Status: Stopped"
    if IsObject(myGui)
        WinActivate(myGui.hwnd)
}

ConvertToDeepLink(link) {
    if (SubStr(link, 1, 10) = "roblox://")
        return link
    if RegExMatch(link, "https://www\.roblox\.com/games/(\d+)[^?]*\?privateServerLinkCode=([\w-]+)", &m) {
        placeId := m[1]
        linkCode := m[2]
        return "roblox://placeId=" placeId "&linkCode=" linkCode
    }
    return ""
}

WaitForRobloxWindow(*) {
    global macroRunning, statusText
    if !macroRunning {
        SetTimer(WaitForRobloxWindow, 0)
        return
    }
    if WinExist("ahk_exe RobloxPlayerBeta.exe") {
        SetTimer(WaitForRobloxWindow, 0)
        statusText.Text := "Roblox found, waiting for game to load..."
        WinActivate
        SetTimer(WaitForPng, 500)
    }
}

WaitForPng(*) {
    global macroRunning, statusText
    if !macroRunning {
        SetTimer(WaitForPng, 0)
        return
    }
    imagePath := A_ScriptDir "\images\garden.png"
    result := DetectImageInRobloxWindow(imagePath, 30) ; 30 = tolerance/variation
    if result {
        SetTimer(WaitForPng, 0)
        statusText.Text := "Game loaded! Starting macro in 10 seconds..."
        SetTimer(StartMacroAfterDelay, -10000)
    }
}

StartMacroAfterDelay(*) {
    global macroRunning, statusText
    if !macroRunning
        return
    statusText.Text := "Macro running!"
    SetTimer(RunMacro, 1000)
}

RunMacro(*) {
    global macroRunning, statusText
    if !macroRunning
        return
    statusText.Text := "Macro running!"
    ; Your macro logic here...
}

; Start the GUI
CreateMyGui()
