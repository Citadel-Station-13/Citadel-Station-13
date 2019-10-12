//Darkmode preference by Kmc2000//

/*
This lets you switch chat themes by using winset and CSS loading, you must relog to see this change (or rebuild your browseroutput datum)
Things to note:
If you change ANYTHING in interface/skin.dmf you need to change it here:
Format:
winset(src, "window as appears in skin.dmf after elem", "var to change = desired value")
How this works:
I've added a function to browseroutput.js which registers a cookie for darkmode and swaps the chat accordingly. You can find the button to do this under the "cog" icon next to the ping button (top right of chat)
This then swaps the window theme automatically
Thanks to spacemaniac and mcdonald for help with the JS side of this.
*/

/client/proc/force_white_theme() //There's no way round it. We're essentially changing the skin by hand. It's painful but it works, and is the way Lummox suggested.
	//Main windows
	winset(src, "infowindow", "background-color = [COLOR_WHITEMODE_DARKBACKGROUND];text-color = [COLOR_WHITEMODE_TEXT]")
	winset(src, "info", "background-color = [COLOR_WHITEMODE_BACKGROUND];text-color = [COLOR_WHITEMODE_TEXT]")
	winset(src, "browseroutput", "background-color = [COLOR_WHITEMODE_DARKBACKGROUND];text-color = [COLOR_WHITEMODE_TEXT]")
	winset(src, "outputwindow", "background-color = [COLOR_WHITEMODE_DARKBACKGROUND];text-color = [COLOR_WHITEMODE_TEXT]")
	winset(src, "mainwindow", "background-color = [COLOR_WHITEMODE_DARKBACKGROUND]")
	winset(src, "split", "background-color = [COLOR_WHITEMODE_BACKGROUND]")
	//Buttons
	winset(src, "changelog", "background-color = [COLOR_WHITEMODE_INFO_BUTTONS_BG];text-color = [COLOR_WHITEMODE_TEXT]")
	winset(src, "rules", "background-color = [COLOR_WHITEMODE_INFO_BUTTONS_BG];text-color = [COLOR_WHITEMODE_TEXT]")
	winset(src, "wiki", "background-color = [COLOR_WHITEMODE_INFO_BUTTONS_BG];text-color = [COLOR_WHITEMODE_TEXT]")
	winset(src, "forum", "background-color = [COLOR_WHITEMODE_INFO_BUTTONS_BG];text-color = [COLOR_WHITEMODE_TEXT]")
	winset(src, "github", "background-color = [COLOR_WHITEMODE_INFO_BUTTONS_BG];text-color = [COLOR_WHITEMODE_TEXT]")
	winset(src, "report-issue", "background-color = [COLOR_WHITEMODE_ISSUE_BUTTON_BG];text-color = [COLOR_WHITEMODE_TEXT]")
	//Status and verb tabs
	winset(src, "output", "background-color = [COLOR_WHITEMODE_BACKGROUND];text-color = [COLOR_WHITEMODE_TEXT]")
	winset(src, "statwindow", "background-color = [COLOR_WHITEMODE_DARKBACKGROUND];text-color = [COLOR_WHITEMODE_TEXT]")
	winset(src, "stat", "background-color = [COLOR_WHITEMODE_BACKGROUND];tab-background-color = [COLOR_WHITEMODE_DARKBACKGROUND];\
				text-color = [COLOR_WHITEMODE_TEXT];tab-text-color = [COLOR_WHITEMODE_TEXT];\
				prefix-color = [COLOR_WHITEMODE_TEXT];suffix-color = [COLOR_WHITEMODE_TEXT]")
	//Etc.
	winset(src, "say", "background-color = [COLOR_WHITEMODE_DARKBACKGROUND];text-color = [COLOR_WHITEMODE_TEXT]")
	winset(src, "asset_cache_browser", "background-color = [COLOR_WHITEMODE_DARKBACKGROUND];text-color = [COLOR_WHITEMODE_TEXT]")
	winset(src, "tooltip", "background-color = [COLOR_WHITEMODE_BACKGROUND];text-color = [COLOR_WHITEMODE_TEXT]")

/client/proc/force_dark_theme() //Inversely, if theyre using white theme and want to swap to the superior dark theme, let's get WINSET() ing
	//Main windows
	winset(src, "infowindow", "background-color = [COLOR_DARKMODE_DARKBACKGROUND];text-color = [COLOR_DARKMODE_TEXT]")
	winset(src, "info", "background-color = [COLOR_DARKMODE_BACKGROUND];text-color = [COLOR_DARKMODE_TEXT]")
	winset(src, "browseroutput", "background-color = [COLOR_DARKMODE_BACKGROUND];text-color = [COLOR_DARKMODE_TEXT]")
	winset(src, "outputwindow", "background-color = [COLOR_DARKMODE_BACKGROUND];text-color = [COLOR_DARKMODE_TEXT]")
	winset(src, "mainwindow", "background-color = [COLOR_DARKMODE_DARKBACKGROUND]")
	winset(src, "split", "background-color = [COLOR_DARKMODE_BACKGROUND]")
	//Buttons
	winset(src, "changelog", "background-color = [COLOR_DARKMODE_INFO_BUTTONS_BG];text-color = [COLOR_DARKMODE_TEXT]")
	winset(src, "rules", "background-color = [COLOR_DARKMODE_INFO_BUTTONS_BG];text-color = [COLOR_DARKMODE_TEXT]")
	winset(src, "wiki", "background-color = [COLOR_DARKMODE_INFO_BUTTONS_BG];text-color = [COLOR_DARKMODE_TEXT]")
	winset(src, "forum", "background-color = [COLOR_DARKMODE_INFO_BUTTONS_BG];text-color = [COLOR_DARKMODE_TEXT]")
	winset(src, "github", "background-color = [COLOR_DARKMODE_INFO_BUTTONS_BG];text-color = [COLOR_DARKMODE_TEXT]")
	winset(src, "report-issue", "background-color = [COLOR_DARKMODE_ISSUE_BUTTON_BG];text-color = [COLOR_DARKMODE_TEXT]")
	//Status and verb tabs
	winset(src, "output", "background-color = [COLOR_DARKMODE_BACKGROUND];text-color = [COLOR_DARKMODE_TEXT]")
	winset(src, "statwindow", "background-color = [COLOR_DARKMODE_DARKBACKGROUND];text-color = [COLOR_DARKMODE_TEXT]")
	winset(src, "stat", "background-color = [COLOR_DARKMODE_DARKBACKGROUND];tab-background-color = [COLOR_DARKMODE_BACKGROUND];\
				text-color = [COLOR_DARKMODE_TEXT];tab-text-color = [COLOR_DARKMODE_TEXT];\
				prefix-color = [COLOR_DARKMODE_TEXT];suffix-color = [COLOR_DARKMODE_TEXT]")
	//Etc.
	winset(src, "say", "background-color = [COLOR_DARKMODE_BACKGROUND];text-color = [COLOR_DARKMODE_TEXT]")
	winset(src, "asset_cache_browser", "background-color = [COLOR_DARKMODE_BACKGROUND];text-color = [COLOR_DARKMODE_TEXT]")
	winset(src, "tooltip", "background-color = [COLOR_DARKMODE_BACKGROUND];text-color = [COLOR_DARKMODE_TEXT]")