//Darkmode preference by Kmc2000//

/*
This lets you switch chat themes by using winset and CSS loading, you must relog to see this change (or rebuild your browseroutput datum)
Things to note:
If you change ANYTHING in interface/skin.dmf you need to change it here:
Format:
winset(src, "window as appears in skin.dmf after elem", "var to change = currentvalue;var to change = desired value")
How this works:
I've added a function to browseroutput.js which registers a cookie for darkmode and swaps the chat accordingly. You can find the button to do this under the "cog" icon next to the ping button (top right of chat)
This then swaps the window theme automatically
Thanks to spacemaniac and mcdonald for help with the JS side of this.
*/

/client/proc/force_white_theme() //There's no way round it. We're essentially changing the skin by hand. It's painful but it works, and is the way Lummox suggested.
	//Main windows
	winset(src, "infowindow", "background-color = [COLOR_DARKMODE_DARKBACKGROUND];background-color = [COLOR_WHITEMODE_DARKBACKGROUND]")
	winset(src, "infowindow", "text-color = [COLOR_DARKMODE_TEXT];text-color = [COLOR_WHITEMODE_TEXT]")
	winset(src, "info", "background-color = [COLOR_DARKMODE_BACKGROUND];background-color = [COLOR_WHITEMODE_BACKGROUND]")
	winset(src, "info", "text-color = [COLOR_DARKMODE_TEXT];text-color = [COLOR_WHITEMODE_TEXT]")
	winset(src, "browseroutput", "background-color = [COLOR_DARKMODE_BACKGROUND];background-color = [COLOR_DARKMODE_INFO_BUTTONS_BG]")
	winset(src, "browseroutput", "text-color = [COLOR_DARKMODE_TEXT];text-color = [COLOR_WHITEMODE_TEXT]")
	winset(src, "outputwindow", "background-color = [COLOR_DARKMODE_BACKGROUND];background-color = [COLOR_WHITEMODE_DARKBACKGROUND]")
	winset(src, "outputwindow", "text-color = [COLOR_DARKMODE_TEXT];text-color = [COLOR_WHITEMODE_TEXT]")
	winset(src, "mainwindow", "background-color = [COLOR_DARKMODE_DARKBACKGROUND];background-color = [COLOR_WHITEMODE_DARKBACKGROUND]")
	winset(src, "split", "background-color = [COLOR_DARKMODE_DARKBACKGROUND];background-color = [COLOR_WHITEMODE_BACKGROUND]")
	//Buttons
	winset(src, "changelog", "background-color = [COLOR_DARKMODE_INFO_BUTTONS_BG];background-color = [COLOR_WHITEMODE_INFO_BUTTONS_BG]")
	winset(src, "changelog", "text-color = [COLOR_DARKMODE_TEXT];text-color = [COLOR_WHITEMODE_TEXT]")
	winset(src, "rules", "background-color = [COLOR_DARKMODE_INFO_BUTTONS_BG];background-color = [COLOR_WHITEMODE_INFO_BUTTONS_BG]")
	winset(src, "rules", "text-color = [COLOR_DARKMODE_TEXT];text-color = [COLOR_WHITEMODE_TEXT]")
	winset(src, "wiki", "background-color = [COLOR_DARKMODE_INFO_BUTTONS_BG];background-color = [COLOR_WHITEMODE_INFO_BUTTONS_BG]")
	winset(src, "wiki", "text-color = [COLOR_DARKMODE_TEXT];text-color = [COLOR_WHITEMODE_TEXT]")
	winset(src, "forum", "background-color = [COLOR_DARKMODE_INFO_BUTTONS_BG];background-color = [COLOR_WHITEMODE_INFO_BUTTONS_BG]")
	winset(src, "forum", "text-color = [COLOR_DARKMODE_TEXT];text-color = [COLOR_WHITEMODE_TEXT]")
	winset(src, "github", "background-color = [COLOR_DARKMODE_INFO_BUTTONS_BG];background-color = [COLOR_WHITEMODE_INFO_BUTTONS_BG]")
	winset(src, "github", "text-color = [COLOR_DARKMODE_TEXT];text-color = [COLOR_WHITEMODE_TEXT]")
	winset(src, "report-issue", "background-color = [COLOR_DARKMODE_ISSUE_BUTTON_BG];background-color = [COLOR_WHITEMODE_ISSUE_BUTTON_BG]")
	winset(src, "report-issue", "text-color = [COLOR_DARKMODE_TEXT];text-color = [COLOR_WHITEMODE_TEXT]")
	//Status and verb tabs
	winset(src, "output", "background-color = [COLOR_DARKMODE_DARKBACKGROUND];background-color = [COLOR_WHITEMODE_BACKGROUND]")
	winset(src, "output", "text-color = [COLOR_DARKMODE_TEXT];text-color = [COLOR_WHITEMODE_TEXT]")
	winset(src, "statwindow", "background-color = [COLOR_DARKMODE_BACKGROUND];background-color = [COLOR_WHITEMODE_DARKBACKGROUND]")
	winset(src, "statwindow", "text-color = #eaeaea;text-color = [COLOR_WHITEMODE_TEXT]")
	winset(src, "stat", "background-color = [COLOR_DARKMODE_DARKBACKGROUND];background-color = [COLOR_WHITEMODE_BACKGROUND]")
	winset(src, "stat", "tab-background-color = [COLOR_DARKMODE_BACKGROUND];tab-background-color = [COLOR_WHITEMODE_DARKBACKGROUND]")
	winset(src, "stat", "text-color = [COLOR_DARKMODE_TEXT];text-color = [COLOR_WHITEMODE_TEXT]")
	winset(src, "stat", "tab-text-color = [COLOR_DARKMODE_TEXT];tab-text-color = [COLOR_WHITEMODE_TEXT]")
	winset(src, "stat", "prefix-color = [COLOR_DARKMODE_TEXT];prefix-color = [COLOR_WHITEMODE_TEXT]")
	winset(src, "stat", "suffix-color = [COLOR_DARKMODE_TEXT];suffix-color = [COLOR_WHITEMODE_TEXT]")
	//Etc.
	winset(src, "say", "background-color = [COLOR_DARKMODE_DARKBACKGROUND];background-color = [COLOR_WHITEMODE_DARKBACKGROUND]")
	winset(src, "say", "text-color = [COLOR_DARKMODE_TEXT];text-color = [COLOR_WHITEMODE_TEXT]")
	winset(src, "asset_cache_browser", "background-color = [COLOR_DARKMODE_BACKGROUND];background-color = [COLOR_WHITEMODE_DARKBACKGROUND]")
	winset(src, "asset_cache_browser", "text-color = [COLOR_DARKMODE_TEXT];text-color = [COLOR_WHITEMODE_TEXT]")
	winset(src, "tooltip", "background-color = [COLOR_DARKMODE_BACKGROUND];background-color = [COLOR_WHITEMODE_BACKGROUND]")
	winset(src, "tooltip", "text-color = [COLOR_DARKMODE_TEXT];text-color = [COLOR_WHITEMODE_TEXT]")

/client/proc/force_dark_theme() //Inversely, if theyre using white theme and want to swap to the superior dark theme, let's get WINSET() ing
	//Main windows
	winset(src, "infowindow", "background-color = [COLOR_WHITEMODE_DARKBACKGROUND];background-color = [COLOR_DARKMODE_DARKBACKGROUND]")
	winset(src, "infowindow", "text-color = [COLOR_WHITEMODE_TEXT];text-color = [COLOR_DARKMODE_TEXT]")
	winset(src, "info", "background-color = [COLOR_WHITEMODE_BACKGROUND];background-color = [COLOR_DARKMODE_BACKGROUND]")
	winset(src, "info", "text-color = [COLOR_WHITEMODE_TEXT];text-color = [COLOR_DARKMODE_TEXT]")
	winset(src, "browseroutput", "background-color = [COLOR_WHITEMODE_BACKGROUND];background-color = [COLOR_DARKMODE_BACKGROUND]")
	winset(src, "browseroutput", "text-color = [COLOR_WHITEMODE_TEXT];text-color = [COLOR_DARKMODE_TEXT]")
	winset(src, "outputwindow", "background-color = [COLOR_WHITEMODE_DARKBACKGROUND];background-color = [COLOR_DARKMODE_BACKGROUND]")
	winset(src, "outputwindow", "text-color = [COLOR_WHITEMODE_TEXT];text-color = [COLOR_DARKMODE_TEXT]")
	winset(src, "mainwindow", "background-color = [COLOR_WHITEMODE_DARKBACKGROUND];background-color = [COLOR_DARKMODE_DARKBACKGROUND]")
	winset(src, "split", "background-color = [COLOR_WHITEMODE_BACKGROUND];background-color = [COLOR_DARKMODE_BACKGROUND]")
	//Buttons
	winset(src, "changelog", "background-color = [COLOR_WHITEMODE_INFO_BUTTONS_BG];background-color = [COLOR_DARKMODE_INFO_BUTTONS_BG]")
	winset(src, "changelog", "text-color = [COLOR_WHITEMODE_TEXT];text-color = [COLOR_DARKMODE_TEXT]")
	winset(src, "rules", "background-color = [COLOR_WHITEMODE_INFO_BUTTONS_BG];background-color = [COLOR_DARKMODE_INFO_BUTTONS_BG]")
	winset(src, "rules", "text-color = [COLOR_WHITEMODE_TEXT];text-color = [COLOR_DARKMODE_TEXT]")
	winset(src, "wiki", "background-color = [COLOR_WHITEMODE_INFO_BUTTONS_BG];background-color = [COLOR_DARKMODE_INFO_BUTTONS_BG]")
	winset(src, "wiki", "text-color = [COLOR_WHITEMODE_TEXT];text-color = [COLOR_DARKMODE_TEXT]")
	winset(src, "forum", "background-color = [COLOR_WHITEMODE_INFO_BUTTONS_BG];background-color = [COLOR_DARKMODE_INFO_BUTTONS_BG]")
	winset(src, "forum", "text-color = [COLOR_WHITEMODE_TEXT];text-color = [COLOR_DARKMODE_TEXT]")
	winset(src, "github", "background-color = [COLOR_WHITEMODE_INFO_BUTTONS_BG];background-color = [COLOR_DARKMODE_INFO_BUTTONS_BG]")
	winset(src, "github", "text-color = [COLOR_WHITEMODE_TEXT];text-color = [COLOR_DARKMODE_TEXT]")
	winset(src, "report-issue", "background-color = [COLOR_WHITEMODE_ISSUE_BUTTON_BG];background-color = [COLOR_DARKMODE_ISSUE_BUTTON_BG]")
	winset(src, "report-issue", "text-color = [COLOR_WHITEMODE_TEXT];text-color = [COLOR_DARKMODE_TEXT]")
	//Status and verb tabs
	winset(src, "output", "background-color = [COLOR_WHITEMODE_DARKBACKGROUND];background-color = [COLOR_DARKMODE_BACKGROUND]")
	winset(src, "output", "text-color = [COLOR_WHITEMODE_TEXT];text-color = [COLOR_DARKMODE_TEXT]")
	winset(src, "statwindow", "background-color = [COLOR_WHITEMODE_DARKBACKGROUND];background-color = [COLOR_DARKMODE_DARKBACKGROUND]")
	winset(src, "statwindow", "text-color = [COLOR_WHITEMODE_TEXT];text-color = [COLOR_DARKMODE_TEXT]")
	winset(src, "stat", "background-color = [COLOR_WHITEMODE_BACKGROUND];background-color = [COLOR_DARKMODE_DARKBACKGROUND]")
	winset(src, "stat", "tab-background-color = [COLOR_WHITEMODE_DARKBACKGROUND];tab-background-color = [COLOR_DARKMODE_BACKGROUND]")
	winset(src, "stat", "text-color = [COLOR_WHITEMODE_TEXT];text-color = [COLOR_DARKMODE_TEXT]")
	winset(src, "stat", "tab-text-color = [COLOR_WHITEMODE_TEXT];tab-text-color = [COLOR_DARKMODE_TEXT]")
	winset(src, "stat", "prefix-color = [COLOR_WHITEMODE_TEXT];prefix-color = [COLOR_DARKMODE_TEXT]")
	winset(src, "stat", "suffix-color = [COLOR_WHITEMODE_TEXT];suffix-color = [COLOR_DARKMODE_TEXT]")
	//Etc.
	winset(src, "say", "background-color = [COLOR_WHITEMODE_DARKBACKGROUND];background-color = [COLOR_DARKMODE_BACKGROUND]")
	winset(src, "say", "text-color = [COLOR_WHITEMODE_TEXT];text-color = [COLOR_DARKMODE_TEXT]")
	winset(src, "asset_cache_browser", "background-color = [COLOR_WHITEMODE_DARKBACKGROUND];background-color = [COLOR_DARKMODE_BACKGROUND]")
	winset(src, "asset_cache_browser", "text-color = [COLOR_WHITEMODE_TEXT];text-color = [COLOR_DARKMODE_TEXT]")
	winset(src, "tooltip", "background-color = [COLOR_WHITEMODE_BACKGROUND];background-color = [COLOR_DARKMODE_BACKGROUND]")
	winset(src, "tooltip", "text-color = [COLOR_WHITEMODE_TEXT];text-color = [COLOR_DARKMODE_TEXT]")


/datum/asset/simple/goonchat
	verify = FALSE
	assets = list(
		"json2.min.js"             = 'code/modules/goonchat/browserassets/js/json2.min.js',
		"errorHandler.js"          = 'code/modules/goonchat/browserassets/js/errorHandler.js',
		"browserOutput.js"         = 'code/modules/goonchat/browserassets/js/browserOutput.js',
		"fontawesome-webfont.eot"  = 'tgui/assets/fonts/fontawesome-webfont.eot',
		"fontawesome-webfont.svg"  = 'tgui/assets/fonts/fontawesome-webfont.svg',
		"fontawesome-webfont.ttf"  = 'tgui/assets/fonts/fontawesome-webfont.ttf',
		"fontawesome-webfont.woff" = 'tgui/assets/fonts/fontawesome-webfont.woff',
		"font-awesome.css"	       = 'code/modules/goonchat/browserassets/css/font-awesome.css',
		"browserOutput.css"	       = 'code/modules/goonchat/browserassets/css/browserOutput.css',
		"browserOutput_white.css"  = 'code/modules/goonchat/browserassets/css/browserOutput_white.css',
	)
