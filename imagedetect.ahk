#Include <ImagePut>

; Detects an image inside the Roblox window using ImagePut.
; Returns [x, y] if found, or false if not.
DetectImageInRobloxWindow(imagePath, variation := 0) {
    robloxHwnd := WinExist("ahk_exe RobloxPlayerBeta.exe")
    if !robloxHwnd
        return false

    ; Get client area of the Roblox window
    WinGetClientPos(&x, &y, &w, &h, robloxHwnd)

    ; Build search area coordinates
    x2 := x + w - 1
    y2 := y + h - 1

    ; Add variation (tolerance) if specified
    searchParams := (variation > 0) ? ("*" variation " " imagePath) : imagePath

    ; Use ImagePut's ImageSearch (returns 1 if found, 0 if not)
    if ImageSearch(&foundX, &foundY, x, y, x2, y2, searchParams)
        return [foundX, foundY]
    return false
}
