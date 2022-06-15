GUIFunctions.AddTab("Auto Progress")

global g_AutoProgress := new IC_AutoProgress_Component
global g_checkEnd := false

log := "N/A"
currentZone := 0
running := "No"
g_checkEnd := false

Gui, ICScriptHub:Tab, Auto Progress
Gui, ICScriptHub:Font, w800
Gui, ICScriptHub:Add, Text, x15 y+15, Auto Progress

Gui, ICScriptHub:Font, w600
Gui, ICScriptHub:Add, Text, x15 y+15, Running?
Gui, ICScriptHub:Font, w400
Gui, ICScriptHub:Add, Text, x+5 w200 vRunning, %running%

Gui, ICScriptHub:Add, Button, x15 y+15 w60 vButtonStart, Start
startFunc := ObjBindMethod(g_AutoProgress, "Start")
GuiControl,ICScriptHub: +g, ButtonStart, % startFunc

Gui, ICScriptHub:Add, Button, x+25 w60 vButtonStop, Stop
endFunc := ObjBindMethod(g_AutoProgress, "End")
GuiControl,ICScriptHub: +g, ButtonStop, % endFunc

Gui, ICScriptHub:Font, w600
Gui, ICScriptHub:Add, Text, x15 y+15, Status:
Gui, ICScriptHub:Font, w400
Gui, ICScriptHub:Add, Text, x+5 w200 vLog, %log%

Gui, ICScriptHub:Font, w600
Gui, ICScriptHub:Add, Text, x15 y+15, Current Zone: 
Gui, ICScriptHub:Font, w400
Gui, ICScriptHub:Add, Text, x+5 w200 vCurrentZone, %currentZone%

g_AutoProgress.BuildToolTips()

class IC_AutoProgress_Component
{   

	BuildTooltips()
    	{
      	GUIFunctions.AddToolTip("ButtonStart", "Start Auto Progress Spam")
        	GUIFunctions.AddToolTip("ButtonStop", "Stop Auto Progress Spam")
    	}
    
	Start()
	{
		g_checkEnd := false
		log := "The Auto Progress has been enabled."
		running := "Yes"
				
		GuiControl, ICScriptHub:, Log, %log%
		GuiControl, ICScriptHub:, Running, %running%
		
		g_SF.Hwnd := WinExist("ahk_exe IdleDragons.exe")
        	Process, Exist, IdleDragons.exe
        	g_SF.PID := ErrorLevel
        	Process, Priority, % g_SF.PID, High
        	g_SF.Memory.OpenProcessReader()
		g_SF.VerifyAdventureLoaded()					
							
		loop
		{
			if (!Mod( g_SF.Memory.ReadCurrentZone(), 5 ) AND Mod( g_SF.Memory.ReadHighestZone(), 5 ) AND !g_SF.Memory.ReadTransitioning())
                		g_SF.ToggleAutoProgress(1,true)
                		g_SF.ToggleAutoProgress(1)
						
			currentZone := g_SF.Memory.ReadCurrentZone()

			GuiControl, ICScriptHub:, CurrentZone, %currentZone%
			
			Sleep, 20

			if(g_checkEnd)
				return
		}
		return
	}

      End()
      {
      	g_checkEnd := true
		log := "The Auto Progress has been disabled."
		running := "No"
		
		GuiControl, ICScriptHub:, Log, %log%
		GuiControl, ICScriptHub:, Running, %running%
		
		return
      }
}

#include %A_LineFile%\..\..\..\SharedFunctions\IC_SharedFunctions_Class.ahk
#include %A_LineFile%\..\..\..\SharedFunctions\ObjRegisterActive.ahk