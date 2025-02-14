#Requires AutoHotkey v2.0
#SingleInstance Force
CoordMode "Mouse", "Screen"
CoordMode "Pixel", "Screen"

; Helper Macro for MBDVidia. Supports the Distance Tolerance (must be mapped to D in settings) and Geometric Tolerance (must be mapped to G)
; increases productivity by streamlining repetitive tasks and allowing the user to use more shortcuts than the software allows. 
; Requirements: Must run on 1920 x 1080 

; variables tracking when macro is active or not
dActivated := false
dDoubleActivated := false
clickCountD := 0

gActivated := false
clickCountG := 0

; Compile all images
pathZero := A_ScriptDir "\0_pic.png"    
pathAngle := A_ScriptDir "\angle.png"
pathCancel := A_ScriptDir "\cancel_button.png"    
pathCF := A_ScriptDir "\cf_pic.png"    
pathCheck2 := A_ScriptDir "\check_2.png"    
pathCheckD := A_ScriptDir "\check_decolor_pic.png"    
pathCheck := A_ScriptDir "\check_pic.png"    
pathDist := A_ScriptDir "\distance.png"    
pathF := A_ScriptDir "\f_pic.png"    
pathFAngle := A_ScriptDir "\feature_angle.png"    
pathFSize := A_ScriptDir "\feature_size.png"    
pathGear := A_ScriptDir "\gear_pic.png"    
pathLogo := A_ScriptDir "\logo_pic.png"    
pathMacTest := A_ScriptDir "\macro_test1.png"    
pathST := A_ScriptDir "\st_pic.png"    
pathU := A_ScriptDir "\u_pic.png"    


; show top left GUI when MBDVidia is active
global fullGui := Gui()
fullGui.Opt("+AlwaysOnTop +ToolWindow -Caption +OwnDialogs +E0x08000000")
fullGui.BackColor := "White" 
WinSetTransColor "White", fullGui
fullGui.Add("Picture", "x0 y0 w15 h15", pathMacTest)  ; Adjust size and position
isGuiVisible := false
SetTimer CheckWindow, 1000  ; Check every 1000ms if MBDVidia is active


;;;; Resolution Settings to Make Images Scalable ;;;;

; Reference resolution (original image size)
refWidth := 1920
refHeight := 1200

; Get current screen resolution
currentWidth := 1920
currentHeight := 1200

; Calculate independent scaling factors
scaleFactorX := currentWidth / refWidth
scaleFactorY := currentHeight / refHeight

; Use the minimum scale factor to maintain aspect ratio
scaleFactor := Min(scaleFactorX, scaleFactorY)

; List of image names
imageNames := ["zero", "angle", "cancel", "cf", "check_decolor", "check", "distance", "f", "feature_ang", "feature_size", "gear", "st", "u"]

; Original widths and heights (you need to provide these)
imageSizes := Map(  ; Format: "imageName" => [width, height]
    "zero", [11, 16],
    "angle", [21, 22],
    "cancel", [65, 18],
    "cf", [21, 16],
    "check_decolor", [21, 21],
    "check", [21, 20],
    "distance", [21, 20],
    "f", [20, 19],
    "feature_ang", [74, 19],
    "feature_size", [15, 16],
    "gear", [20, 20],
    "st", [21, 16],
    "u", [20, 21]
)

; Store scaled image sizes
scaledImages := Map()

; Loop through images and calculate scaled sizes
for imageName in imageNames {
    originalSize := imageSizes[imageName]  ; Get [width, height]
    scaledWidth := Round(originalSize[1] * scaleFactor)
    scaledHeight := Round(originalSize[2] * scaleFactor)

    scaledImages[imageName] := [scaledWidth, scaledHeight]  ; Store in array
}

; MsgBox " " A_ScreenWidth " " A_ScreenHeight " " scaleFactor
; Display the calculated array
; output := "Scaled Image Sizes:`n"
; for imageName, size in scaledImages {
;     output .= imageName ": " size[1] "x" size[2] "`n"
; }
; MsgBox output  ; Show results


; Press "d" once to activate the shortcut
~d:: {
    Sleep(300)
    ; check if dTol is on
    result := ImageSearch(&FoundX, &FoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, "*w" scaledImages["cancel"][1] " *h" scaledImages["cancel"][2] " *100 " pathCancel)
    if (result) {
        global dActivated := true
        global clickCount := 0  ; Reset click count
        global dDoubleActivated := false
        SetTimer ResetStateD, -30000  ; Reset after 30 seconds if no clicks occur
        
        ; every time d is on, default to feature size
        if (ImageSearch(&FoundX1, &FoundY1, 0, 0, A_ScreenWidth, A_ScreenHeight, "*w" scaledImages["feature_size"][1] " *h" scaledImages["feature_size"][2] " *100 " pathFSize)) {
            MouseGetPos &xpos, &ypos
            MouseMove FoundX1 + 35, FoundY1 + 6
            Click("left")
            DllCall("SetCursorPos", "Int", xpos, "Int", ypos)
        }

        ; show active
        if (dActivated) {
            global myGui := Gui()
            myGui.Opt("+AlwaysOnTop +ToolWindow -Caption +OwnDialogs +E0x08000000")  ; E0x20 makes it click-through
            myGui.BackColor := "White"  ; Transparent areas will show as black unless color key is set
            WinSetTransColor "White", myGui
            myGui.Add("Picture", "x0 y0 w20 h20", pathLogo)  ; Adjust size and position
            myGui.Show("x" (FoundX + 75) " y" (FoundY - 3) " NoActivate")
            
        }
    }
    else {
        ResetStateD()
    }
}

; aLt + d brings up menu manually for the distance tolerance
!d:: {
    Sleep(200)

    SetTimer KeepFocus, 50  ; Continuously check focus
    message := InputBox("", "Enter tolerance:", "w200 h80")
    SetTimer KeepFocus, 0  ; stop checking focus

    if (message.Result = "OK" && message.Value != "") {
        Send("{Tab}")  ; Press Tab key
        Sleep(150)  ; Short delay to ensure smooth input
        Send(message.Value)  ; Type the entered value

        Send("{Tab 3}")  ; Press Tab key
        Sleep(150)
        Send("-" message.Value)

        Send("{Tab 2}")
        Send("{Enter}")
    }

    ResetStateD()
    
}

; alt + g brings up menu manually for the geo tolerance
!g:: {
    Sleep(300)
    ; pop up active GUI
    ImageSearch(&FoundX, &FoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, "*w" scaledImages["cancel"][1] " *h" scaledImages["cancel"][2] " *100 " pathCancel)
    global myGui := Gui()
    myGui.Opt("+AlwaysOnTop +ToolWindow -Caption +OwnDialogs +E0x08000000")  ; E0x20 makes it click-through
    myGui.BackColor := "White"  ; Transparent areas will show as black unless color key is set
    WinSetTransColor "White", myGui
    myGui.Add("Picture", "x0 y0 w20 h20", pathLogo)  ; Adjust size and position
    myGui.Show("x" (FoundX + 75) " y" (FoundY - 3) " NoActivate")

    SetTimer KeepFocus, 50  ; Continuously check focus
    message := InputBox("", "Enter tolerance:", "w200 h80")
    SetTimer KeepFocus, 0  ; stop checking focus

    if (message.Result = "OK" && message.Value != "") {
        
        CoordMode "Pixel", "Client"
        CoordMode "Mouse", "Client"
        ; once message is sent, scan for the st or cf to locate the pop-up box
        stResult := ImageSearch(&FoundXst, &FoundYst, 0, 0, A_ScreenWidth, A_ScreenHeight, "*w" scaledImages["st"][1] " *h" scaledImages["st"][2] " *50 " pathST)
        cfResult := ImageSearch(&FoundXcf, &FoundYcf, 0, 0, A_ScreenWidth, A_ScreenHeight, "*w" scaledImages["cf"][1] " *h" scaledImages["cf"][2] " *50 " pathCF)

        checkResult := ImageSearch(&FoundXcheck, &FoundYcheck, 0, 0, A_ScreenWidth, A_ScreenHeight, "*w" scaledImages["check"][1] " *h" scaledImages["check"][2] " *50 " pathCheck)
        checkDResult := ImageSearch(&FoundXcheckD, &FoundYcheckD, 0, 0, A_ScreenWidth, A_ScreenHeight, "*w" scaledImages["check_decolor"][1] " *h" scaledImages["check_decolor"][2] " *50 " pathCheckD)
        
        MouseGetPos &xpos, &ypos
        Sleep(100)

        ; if it finds the colored check mark
        if (checkResult) {
            zeroResult := ImageSearch(&FoundX0, &FoundY0, (FoundXcheck - 650), (FoundYcheck - 30), (FoundXcheck), (FoundYcheck + 50), "*w" scaledImages["zero"][1] " *h" scaledImages["zero"][2] " *50 " pathZero)
            if (zeroResult) {
                MouseMove FoundX0, FoundY0                    
            }
        }

        ; if it finds the decolored check mark
        else if (checkDResult) {
            zeroResult := ImageSearch(&FoundX0, &FoundY0, (FoundXcheckD - 650), (FoundYcheckD - 30), (FoundXcheckD), (FoundYcheckD + 50), "*w" scaledImages["zero"][1] " *h" scaledImages["zero"][2] " *50 " pathZero)
            if (zeroResult) {
                MouseMove FoundX0, FoundY0                    
            }
        }

        ; if it finds the st button
        else if (stResult) {
            zeroResult := ImageSearch(&FoundX0, &FoundY0, (FoundXst - 350), (FoundYst - 30), FoundXst, FoundYst + 50, "*w" scaledImages["zero"][1] " *h" scaledImages["zero"][2] " *100 " pathZero)
            if (zeroResult) {
                MouseMove FoundX0, FoundY0
            }
        }

        ; if it finds the cf button
        else if (cfResult) {
            zeroResult := ImageSearch(&FoundX0, &FoundY0, (FoundXcf - 450), (FoundYcf - 30), FoundXcf, FoundYcf + 50, "*w" scaledImages["zero"][1] " *h" scaledImages["zero"][2] " *100 " pathZero)
            if (zeroResult) {
                MouseMove FoundX0, FoundY0
            }
        }

        ; double click the text box, enter in the tolerance, return mouse to previous position
        Click("left")
        Click("left")
        Send(message.Value)
        Sleep(50)
        MouseMove xpos, ypos
    }

    ResetStateG()  ; Reset after execution
}

; when g is pressed activate Geometric Tolerance Macro
~g:: {
    Sleep(300)
    ; check if gTol is on
    result := ImageSearch(&FoundX, &FoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, "*w" scaledImages["cancel"][1] " *h" scaledImages["cancel"][2] " *100 " pathCancel)
    if (result) {
        global dActivated := false
        global dDoubleActivated := false
        global gActivated := true

        SetTimer ResetStateD, -30000  ; Reset after 30 seconds if no clicks occur

        ; show active GUI
        if (gActivated) {
            global myGui := Gui()
            myGui.Opt("+AlwaysOnTop +ToolWindow -Caption +OwnDialogs +E0x08000000")  ; E0x20 makes it click-through
            myGui.BackColor := "White"  ; Transparent areas will show as black unless color key is set
            WinSetTransColor "White", myGui
            myGui.Add("Picture", "x0 y0 w20 h20", pathLogo)  ; Adjust size and position
            myGui.Show("x" (FoundX + 75) " y" (FoundY - 3) " NoActivate")
        }

        ; if the menu is open, find the gear icon to open up the menu
        gearResult := ImageSearch(&FoundXgear, &FoundYgear, 0, 0, A_ScreenWidth, A_ScreenHeight, "*w" scaledImages["gear"][1] " *h" scaledImages["gear"][2] " *70 " pathGear)
        if (gearResult) {
            Sleep(250)
            MouseGetPos &xpos, &ypos
            MouseMove (FoundXgear + 90), (FoundYgear + 40)
            Click("Left")
            MouseMove xpos, ypos
        }
    }
    else {
        ResetStateG()
    }
    
}

; Detect mouse clicks while in Geometric Macro or Distance Macro mode
~LButton:: {
    global dActivated, clickCountD, dDoubleActivated, gActivated, clickCountG

    ; if on dTol mode and on double click mode (distance or angle between two features)
    if (dActivated && dDoubleActivated) {
        clickCountD += 1
        if (clickCountD = 2) {
            ; Action to execute after "d" + 2 mouse clicks
            Sleep(300)
            SetTimer KeepFocus, 50  ; Continuously check focus
            message := InputBox("", "Enter tolerance:", "w200 h80")
            SetTimer KeepFocus, 0  ; stop checking focus

            if (message.Result = "OK" && message.Value != "") {
                Send("{Tab}")  ; Press Tab key
                Sleep(150)  ; Short delay to ensure smooth input
                Send(message.Value)  ; Type the entered value
                Sleep(150)
                Send("{Tab 3}")  ; Press Tab key
                Sleep(150)
                Send("-" message.Value)
                Sleep(150)
                Send("{Tab 2}")
                Send("{Enter}")
            }

            ResetStateD()  ; Reset after execution
        }
    }

    ; if on dTol mode and on single click mode (Feature Size or Feature Angle)
    else if (dActivated) {
        ; Action to execute after "d" after only 1 mouse click
        Sleep(300)
        SetTimer KeepFocus, 50  ; Continuously check focus
        message := InputBox("", "Enter tolerance:", "w200 h80")
        SetTimer KeepFocus, 0  ; stop checking focus

        if (message.Result = "OK" && message.Value != "") {
            Send("{Tab}")  ; Press Tab key
            Sleep(150)  ; Short delay to ensure smooth input
            Send(message.Value)  ; Type the entered value
            Sleep(150)
            Send("{Tab 3}")  ; Press Tab key
            Sleep(150)
            Send("-" message.Value)
            Sleep(150)
            Send("{Tab 2}")
            Send("{Enter}")
        }

        ResetStateD()  ; Reset after execution
    }

    ; if on gTol mode (activates on single click) - make it activate on triple click
    else if (gActivated) {        
        clickCountG += 1
        ; once 2 clicks happen, pop up the tolerance box
        if (clickCountG = 2) {
            Sleep(300)
            SetTimer KeepFocus, 50  ; Continuously check focus
            message := InputBox("", "Enter tolerance:", "w200 h80")
            SetTimer KeepFocus, 0  ; stop checking focus

            if (message.Result = "OK" && message.Value != "") {
                CoordMode "Pixel", "Client"
                CoordMode "Mouse", "Client"
                ; once message is sent, scan for the st or cf to locate the pop-up box
                stResult := ImageSearch(&FoundXst, &FoundYst, 0, 0, A_ScreenWidth, A_ScreenHeight, "*w" scaledImages["st"][1] " *h" scaledImages["st"][2] " *50 " pathST)
                cfResult := ImageSearch(&FoundXcf, &FoundYcf, 0, 0, A_ScreenWidth, A_ScreenHeight, "*w" scaledImages["cf"][1] " *h" scaledImages["cf"][2] " *50 " pathCF)

                checkResult := ImageSearch(&FoundXcheck, &FoundYcheck, 0, 0, A_ScreenWidth, A_ScreenHeight, "*w" scaledImages["check"][1] " *h" scaledImages["check"][2] " *50 " pathCheck)
                checkDResult := ImageSearch(&FoundXcheckD, &FoundYcheckD, 0, 0, A_ScreenWidth, A_ScreenHeight, "*w" scaledImages["check_decolor"][1] " *h" scaledImages["check_decolor"][2] " *50 " pathCheckD)
                
                MouseGetPos &xpos, &ypos
                Sleep(250)
                ; if it finds the colored check mark
                if (checkResult) {         
                    zeroResult := ImageSearch(&FoundX0, &FoundY0, (FoundXcheck - 650), (FoundYcheck - 30), (FoundXcheck), (FoundYcheck + 50), "*w" scaledImages["zero"][1] " *h" scaledImages["zero"][2] " *50 " pathZero)
                    if (zeroResult) {
                        MouseMove FoundX0, FoundY0                    
                    }
                }

                ; if it finds the decolored check mark
                else if (checkDResult) {
                    zeroResult := ImageSearch(&FoundX0, &FoundY0, (FoundXcheckD - 650), (FoundYcheckD - 30), (FoundXcheckD), (FoundYcheckD + 50), "*w" scaledImages["zero"][1] " *h" scaledImages["zero"][2] " *50 " pathZero)
                    if (zeroResult) {
                        MouseMove FoundX0, FoundY0                    
                    }
                }

                ; if it finds the st button
                else if (stResult) {
                    zeroResult := ImageSearch(&FoundX0, &FoundY0, (FoundXst - 350), (FoundYst - 30), FoundXst, FoundYst + 50, "*w" scaledImages["zero"][1] " *h" scaledImages["zero"][2] " *50 " pathZero)
                    if (zeroResult) {
                        MouseMove FoundX0, FoundY0
                    }
                }

                ; if it finds the cf button
                else if (cfResult) {
                    zeroResult := ImageSearch(&FoundX0, &FoundY0, (FoundXcf - 450), (FoundYcf - 30), FoundXcf, FoundYcf + 50, "*w" scaledImages["zero"][1] " *h" scaledImages["zero"][2] " *50 " pathZero)
                    if (zeroResult) {
                        MouseMove FoundX0, FoundY0
                    }
                }

                ; double click the text box, enter in the tolerance, return mouse to previous position
                Click("left")
                Click("left")
                Send(message.Value)
                Sleep(50)
                MouseMove xpos, ypos
            }

            ResetStateG()  ; Reset after execution
        }
    }
}

; alt + 1 maps to FeatureSize
!1:: {
    result := ImageSearch(&FoundX, &FoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, "*w" scaledImages["cancel"][1] " *h" scaledImages["cancel"][2] " *100 " pathCancel)
    if (result) {
        resultFeature := ImageSearch(&FoundX1, &FoundY1, 0, 0, A_ScreenWidth, A_ScreenHeight, "*w" scaledImages["feature_size"][1] " *h" scaledImages["feature_size"][2] " *100 " pathFSize)
        if (resultFeature) {
            MouseGetPos &xpos, &ypos
            MouseMove FoundX1 + 35, FoundY1 + 6
            Click("left")
            DllCall("SetCursorPos", "Int", xpos, "Int", ypos)
            global dDoubleActivated := false
        }
    }
}

; alt + 2 maps to FeatureAngle
!2:: {
    result := ImageSearch(&FoundX, &FoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, "*w" scaledImages["cancel"][1] " *h" scaledImages["cancel"][2] " *100 " pathCancel)
    if (result) {
        resultFeature := ImageSearch(&FoundX1, &FoundY1, 0, 0, A_ScreenWidth, A_ScreenHeight, "*w" scaledImages["feature_ang"][1] " *h" scaledImages["feature_ang"][2] " *100 " pathFAngle)
        if (resultFeature) {
            MouseGetPos &xpos, &ypos
            MouseMove FoundX1 + 35, FoundY1 + 6
            Click("left")
            DllCall("SetCursorPos", "Int", xpos, "Int", ypos)
            global dDoubleActivated := false

        }
    }
}

; alt + 3 maps to Distance
!3:: {
    result := ImageSearch(&FoundX, &FoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, "*w" scaledImages["cancel"][1] " *h" scaledImages["cancel"][2] " *100 " pathCancel)
    if (result) {
        resultFeature := ImageSearch(&FoundX1, &FoundY1, 0, 0, A_ScreenWidth, A_ScreenHeight, "*w" scaledImages["distance"][1] " *h" scaledImages["distance"][2] " *100 " pathDist)
        if (resultFeature) {
            MouseGetPos &xpos, &ypos
            MouseMove FoundX1 + 35, FoundY1 + 6
            Click("left")
            DllCall("SetCursorPos", "Int", xpos, "Int", ypos)
            global dDoubleActivated := true

        }
    }
}

; alt + 4 maps to Angle
!4:: {
    result := ImageSearch(&FoundX, &FoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, "*w" scaledImages["cancel"][1] " *h" scaledImages["cancel"][2] " *100 " pathCancel)
    if (result) {
        resultFeature := ImageSearch(&FoundX1, &FoundY1, 0, 0, A_ScreenWidth, A_ScreenHeight, "*w" scaledImages["angle"][1] " *h" scaledImages["angle"][2] " *100 " pathAngle)
        if (resultFeature) {
            MouseGetPos &xpos, &ypos
            MouseMove FoundX1 + 35, FoundY1 + 6
            Click("left")
            DllCall("SetCursorPos", "Int", xpos, "Int", ypos)
            global dDoubleActivated := true

        }
    }
}


; Function to reset tracking state
ResetStateD() {
    Sleep(100)
    global dActivated := false
    global clickCountD := 0
    global dDoubleActivated := false
    if IsSet(myGui) && myGui {  ; Check if myGui exists and is valid
        myGui.Destroy()
    }
}

; Function to reset tracking state
ResetStateG() {
    Sleep(100)
    global gActivated := false
    global clickCountG := 0
    if IsSet(myGui) && myGui {  ; Check if myGui exists and is valid
        myGui.Destroy()
    }
}


; for d tol, just press "d" then 2 clicks, then it opens up the above

; for g tol, 1 click, opens up the popup, type in tolerance, then alt down to open up drop down menu
; after 1 click, it goes and enters it


; alt + x exits out of the entire program
!x::ExitApp

; when launched, if its not working as intended, press alt + e to reset everything without closing the program
!e:: {
    ResetStateD()
    ResetStateG()
    if (WinExist("Enter tolerance:")) {
        WinClose("Enter tolerance:")
    }

    if WinExist("ahk_class AutoHotkeyGUI") {
        WinClose("ahk_class AutoHotkeyGUI")  ; Close all AHK GUI windows
    } else {

    }
}


; This handler closes out of the AHK tolerance prompt when right clicked. If the user is in a Tolerance mode
; in MBDVidia, then it closes out of that as well.
#HotIf WinExist("Enter tolerance:") ; Cancel handler
RButton::{
    WinClose("Enter tolerance:")
    ; Send("{Escape}") ; Closes out of open window
    Sleep(100)
    MouseGetPos &xpos, &ypos
    ; Searches for "cancel" button and moves mouse there
    result := ImageSearch(&FoundX, &FoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, "*w" scaledImages["cancel"][1] " *h" scaledImages["cancel"][2] " *100 " pathCancel)
    if (result) {
        DllCall("SetCursorPos", "Int", (FoundX + 35), "Int", (FoundY + 6))
        Click("Left")  ; Perform a left mouse clicks
        DllCall("SetCursorPos", "Int", xpos, "Int", ypos)
    }
    ResetStateD()
}
; tilde key closes out of the box but leaves the dTol going so you can manually enter tolerances
`:: {
    WinClose("Enter tolerance:")
    ResetStateD()
    ResetStateG()
}
#HotIf

; if the checkmark appears on screen, and the enter tolerance window is not present, enter clicks on the check
#HotIf ((ImageSearch(&FoundXcheck1, &FoundYcheck1, 0, 0, A_ScreenWidth, A_ScreenHeight, "*w" scaledImages["check"][1] " *h" scaledImages["check"][2] " *50 " pathCheck) || (ImageSearch(&FoundXcheck2, &FoundYcheck2, 0, 0, A_ScreenWidth, A_ScreenHeight, "*50 " pathCheck2)))&& !WinExist("Enter tolerance:"))
Enter:: {
    MouseGetPos &xpos, &ypos
    res := ImageSearch(&FoundXcheck1, &FoundYcheck1, 0, 0, A_ScreenWidth, A_ScreenHeight, "*w" scaledImages["check"][1] " *h" scaledImages["check"][2] " *50 " pathCheck)
    res1 := ImageSearch(&FoundXcheck2, &FoundYcheck2, 0, 0, A_ScreenWidth, A_ScreenHeight, "*50 " pathCheck2)

    if (res) {
        MouseMove (FoundXcheck1 + 10), (FoundYcheck1 + 10)
        Click("left")
        Sleep(100)
        MouseMove xpos, ypos
    }
    else if (res1) {
        MouseMove (FoundXcheck2 + 10), (FoundYcheck2 + 10)
        Click("left")
        Sleep(100)
        MouseMove xpos, ypos
    }
}
#HotIf

; if cancel button is available, right click cancel out
#HotIf (ImageSearch(&FoundX, &FoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, "*w" scaledImages["cancel"][1] " *h" scaledImages["cancel"][2] " *100 " pathCancel))
RButton:: {
    MouseGetPos &xpos, &ypos
    res := ImageSearch(&FoundXcancel, &FoundYcancel, 0, 0, A_ScreenWidth, A_ScreenHeight, "*w" scaledImages["cancel"][1] " *h" scaledImages["cancel"][2] " *50 " pathCancel)
    if (res) {
        MouseMove (FoundXcancel + 35), (FoundYcancel + 6)
        Click "left"
        Click "left"
        MouseMove xpos, ypos
    }

    ResetStateD()
    ResetStateG()
}
#HotIf


; helper method so the tolerance pop-up box will always stay in focus
KeepFocus() {
    if (WinExist("Enter tolerance") && !WinActive("Enter tolerance:")) 
        WinActivate("Enter tolerance:")
}

; helper method to display the 'MBD macro' text when MBDVidia is active

CheckWindow() {
    global isGuiVisible, fullGui

    if WinExist("MBDVidia") && WinActive("MBDVidia") {  ; Check if window exists AND is active
        if !isGuiVisible {
            fullGui.Show("x150 y6 NoActivate")  ; Ensure GUI does NOT steal focus
            isGuiVisible := true
        }
    } else {
        if isGuiVisible {
            fullGui.Hide()
            isGuiVisible := false
        }
    }
}
