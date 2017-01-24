var/list/ai_list = list()

//Not sure why this is necessary...
/proc/AutoUpdateAI(obj/subject)
	var/is_in_use = 0
	if (subject!=null)
		for(var/A in ai_list)
			var/mob/living/silicon/ai/M = A
			if ((M.client && M.machine == subject))
				is_in_use = 1
				subject.attack_ai(M)
	return is_in_use


/mob/living/silicon/ai
	name = "AI"
	icon = 'icons/mob/AI.dmi'
	icon_state = "ai"
	anchored = 1
	density = 1
	canmove = 0
	status_flags = CANSTUN|CANPUSH
	a_intent = INTENT_HARM //so we always get pushed instead of trying to swap
	force_compose = 1 //This ensures that the AI always composes it's own hear message. Needed for hrefs and job display.
	sight = SEE_TURFS | SEE_MOBS | SEE_OBJS
	see_in_dark = 8
	med_hud = DATA_HUD_MEDICAL_BASIC
	sec_hud = DATA_HUD_SECURITY_BASIC
	mob_size = MOB_SIZE_LARGE
	var/list/network = list("SS13")
	var/obj/machinery/camera/current = null
	var/list/connected_robots = list()
	var/aiRestorePowerRoutine = 0
	var/requires_power = POWER_REQ_ALL
	//var/list/laws = list()
	var/alarms = list("Motion"=list(), "Fire"=list(), "Atmosphere"=list(), "Power"=list(), "Camera"=list(), "Burglar"=list())
	var/viewalerts = 0
	var/icon/holo_icon//Default is assigned when AI is created.
	var/obj/mecha/controlled_mech //For controlled_mech a mech, to determine whether to relaymove or use the AI eye.
	var/radio_enabled = 1 //Determins if a carded AI can speak with its built in radio or not.
	radiomod = ";" //AIs will, by default, state their laws on the internal radio.
	var/obj/item/device/pda/ai/aiPDA = null
	var/obj/item/device/multitool/aiMulti = null
	var/mob/living/simple_animal/bot/Bot
	var/tracking = 0 //this is 1 if the AI is currently tracking somebody, but the track has not yet been completed.
	var/datum/effect_system/spark_spread/spark_system//So they can initialize sparks whenever/N

	//MALFUNCTION
	var/datum/module_picker/malf_picker
	var/list/datum/AI_Module/current_modules = list()
	var/can_dominate_mechs = 0
	var/shunted = 0 //1 if the AI is currently shunted. Used to differentiate between shunted and ghosted/braindead

	var/control_disabled = 0 // Set to 1 to stop AI from interacting via Click()
	var/malfhacking = 0 // More or less a copy of the above var, so that malf AIs can hack and still get new cyborgs -- NeoFite
	var/malf_cooldown = 0 //Cooldown var for malf modules

	var/obj/machinery/power/apc/malfhack = null
	var/explosive = 0 //does the AI explode when it dies?

	var/mob/living/silicon/ai/parent = null
	var/camera_light_on = 0
	var/list/obj/machinery/camera/lit_cameras = list()

	var/datum/trackable/track = new()

	var/last_paper_seen = null
	var/can_shunt = 1
	var/last_announcement = "" // For AI VOX, if enabled
	var/turf/waypoint //Holds the turf of the currently selected waypoint.
	var/waypoint_mode = 0 //Waypoint mode is for selecting a turf via clicking.
	var/apc_override = 0 //hack for letting the AI use its APC even when visionless
	var/nuking = FALSE
	var/obj/machinery/doomsday_device/doomsday_device

	var/mob/camera/aiEye/eyeobj = new()
	var/sprint = 10
	var/cooldown = 0
	var/acceleration = 1

	var/obj/machinery/camera/portable/builtInCamera

/mob/living/silicon/ai/New(loc, datum/ai_laws/L, obj/item/device/mmi/B, safety = 0)
	..()
	if(!safety) //Only used by AIize() to successfully spawn an AI.
		if(!B) //If there is no player/brain inside.
			new/obj/structure/AIcore/deactivated(loc) //New empty terminal.
			qdel(src)//Delete AI.
			return
		else
			if(B.brainmob.mind)
				B.brainmob.mind.transfer_to(src)
				rename_self("ai")
				if(mind.special_role)
					mind.store_memory("As an AI, you must obey your silicon laws above all else. Your objectives will consider you to be dead.")
					src << "<span class='userdanger'>You have been installed as an AI! </span>"
					src << "<span class='danger'>You must obey your silicon laws above all else. Your objectives will consider you to be dead.</span>"

			src << "<B>You are playing the station's AI. The AI cannot move, but can interact with many objects while viewing them (through cameras).</B>"
			src << "<B>To look at other parts of the station, click on yourself to get a camera menu.</B>"
			src << "<B>While observing through a camera, you can use most (networked) devices which you can see, such as computers, APCs, intercoms, doors, etc.</B>"
			src << "To use something, simply click on it."
			src << "Use say :b to speak to your cyborgs through binary."
			src << "For department channels, use the following say commands:"
			src << ":o - AI Private, :c - Command, :s - Security, :e - Engineering, :u - Supply, :v - Service, :m - Medical, :n - Science."
			show_laws()
			src << "<b>These laws may be changed by other players, or by you being the traitor.</b>"

			job = "AI"

	rename_self("ai")
	name = real_name

	holo_icon = getHologramIcon(icon('icons/mob/AI.dmi',"holo1"))

	spark_system = new /datum/effect_system/spark_spread()
	spark_system.set_up(5, 0, src)
	spark_system.attach(src)

	if(L)
		if (istype(L, /datum/ai_laws))
			laws = L
	else
		make_laws()

	verbs += /mob/living/silicon/ai/proc/show_laws_verb

	aiPDA = new/obj/item/device/pda/ai(src)
	aiPDA.owner = name
	aiPDA.ownjob = "AI"
	aiPDA.name = name + " (" + aiPDA.ownjob + ")"

	aiMulti = new(src)
	radio = new /obj/item/device/radio/headset/ai(src)
	aicamera = new/obj/item/device/camera/siliconcam/ai_camera(src)

	if(isturf(loc))
		verbs.Add(/mob/living/silicon/ai/proc/ai_network_change, \
		/mob/living/silicon/ai/proc/ai_statuschange, /mob/living/silicon/ai/proc/ai_hologram_change, \
		/mob/living/silicon/ai/proc/toggle_camera_light, /mob/living/silicon/ai/proc/botcall,\
		/mob/living/silicon/ai/proc/control_integrated_radio, /mob/living/silicon/ai/proc/set_automatic_say_channel)

	ai_list += src
	shuttle_caller_list += src

	eyeobj.ai = src
	eyeobj.name = "[src.name] (AI Eye)" // Give it a name
	eyeobj.loc = src.loc

	builtInCamera = new /obj/machinery/camera/portable(src)
	builtInCamera.network = list("SS13")


/mob/living/silicon/ai/Destroy()
	ai_list -= src
	shuttle_caller_list -= src
	SSshuttle.autoEvac()
	qdel(eyeobj) // No AI, no Eye
	malfhack = null

	. = ..()


/mob/living/silicon/ai/verb/pick_icon()
	set category = "AI Commands"
	set name = "Set AI Core Display"
	if(stat || aiRestorePowerRoutine)
		return

		//if(icon_state == initial(icon_state))
	var/icontype = input("Please, select a display!", "AI", null/*, null*/) in list("Clown", "Monochrome", "Blue", "Inverted", "Firewall", "Green", "Red", "Static", "Red October", "House", "Heartline", "Hades", "Helios", "President", "Syndicat Meow", "Alien", "Too Deep", "Triumvirate", "Triumvirate-M", "Text", "Matrix", "Dorf", "Bliss", "Not Malf", "Fuzzy", "Goon", "Database", "Glitchman", "Murica", "Nanotrasen", "Gentoo", "Angel")
	if(icontype == "Clown")
		icon_state = "ai-clown2"
	else if(icontype == "Monochrome")
		icon_state = "ai-mono"
	else if(icontype == "Blue")
		icon_state = "ai"
	else if(icontype == "Inverted")
		icon_state = "ai-u"
	else if(icontype == "Firewall")
		icon_state = "ai-magma"
	else if(icontype == "Green")
		icon_state = "ai-wierd"
	else if(icontype == "Red")
		icon_state = "ai-malf"
	else if(icontype == "Static")
		icon_state = "ai-static"
	else if(icontype == "Red October")
		icon_state = "ai-redoctober"
	else if(icontype == "House")
		icon_state = "ai-house"
	else if(icontype == "Heartline")
		icon_state = "ai-heartline"
	else if(icontype == "Hades")
		icon_state = "ai-hades"
	else if(icontype == "Helios")
		icon_state = "ai-helios"
	else if(icontype == "President")
		icon_state = "ai-pres"
	else if(icontype == "Syndicat Meow")
		icon_state = "ai-syndicatmeow"
	else if(icontype == "Alien")
		icon_state = "ai-alien"
	else if(icontype == "Too Deep")
		icon_state = "ai-toodeep"
	else if(icontype == "Triumvirate")
		icon_state = "ai-triumvirate"
	else if(icontype == "Triumvirate-M")
		icon_state = "ai-triumvirate-malf"
	else if(icontype == "Text")
		icon_state = "ai-text"
	else if(icontype == "Matrix")
		icon_state = "ai-matrix"
	else if(icontype == "Dorf")
		icon_state = "ai-dorf"
	else if(icontype == "Bliss")
		icon_state = "ai-bliss"
	else if(icontype == "Not Malf")
		icon_state = "ai-notmalf"
	else if(icontype == "Fuzzy")
		icon_state = "ai-fuzz"
	else if(icontype == "Goon")
		icon_state = "ai-goon"
	else if(icontype == "Database")
		icon_state = "ai-database"
	else if(icontype == "Glitchman")
		icon_state = "ai-glitchman"
	else if(icontype == "Murica")
		icon_state = "ai-murica"
	else if(icontype == "Nanotrasen")
		icon_state = "ai-nanotrasen"
	else if(icontype == "Gentoo")
		icon_state = "ai-gentoo"
	else if(icontype == "Angel")
		icon_state = "ai-angel"
	//else
			//usr <<"You can only change your display once!"
			//return

/mob/living/silicon/ai/Stat()
	..()
	if(statpanel("Status"))
		if(!stat)
			stat(null, text("System integrity: [(health+100)/2]%"))
			stat(null, "Station Time: [worldtime2text()]")
			stat(null, text("Connected cyborgs: [connected_robots.len]"))
			var/area/borg_area
			for(var/mob/living/silicon/robot/R in connected_robots)
				borg_area = get_area(R)
				var/robot_status = "Nominal"
				if(R.stat || !R.client)
					robot_status = "OFFLINE"
				else if(!R.cell || R.cell.charge <= 0)
					robot_status = "DEPOWERED"
				//Name, Health, Battery, Module, Area, and Status! Everything an AI wants to know about its borgies!
				stat(null, text("[R.name] | S.Integrity: [R.health]% | Cell: [R.cell ? "[R.cell.charge]/[R.cell.maxcharge]" : "Empty"] | \
 				Module: [R.designation] | Loc: [borg_area.name] | Status: [robot_status]"))
		else
			stat(null, text("Systems nonfunctional"))

/mob/living/silicon/ai/proc/ai_alerts()
	var/dat = "<HEAD><TITLE>Current Station Alerts</TITLE><META HTTP-EQUIV='Refresh' CONTENT='10'></HEAD><BODY>\n"
	dat += "<A HREF='?src=\ref[src];mach_close=aialerts'>Close</A><BR><BR>"
	for (var/cat in alarms)
		dat += text("<B>[]</B><BR>\n", cat)
		var/list/L = alarms[cat]
		if (L.len)
			for (var/alarm in L)
				var/list/alm = L[alarm]
				var/area/A = alm[1]
				var/C = alm[2]
				var/list/sources = alm[3]
				dat += "<NOBR>"
				if (C && istype(C, /list))
					var/dat2 = ""
					for (var/obj/machinery/camera/I in C)
						dat2 += text("[]<A HREF=?src=\ref[];switchcamera=\ref[]>[]</A>", (dat2=="") ? "" : " | ", src, I, I.c_tag)
					dat += text("-- [] ([])", A.name, (dat2!="") ? dat2 : "No Camera")
				else if (C && istype(C, /obj/machinery/camera))
					var/obj/machinery/camera/Ctmp = C
					dat += text("-- [] (<A HREF=?src=\ref[];switchcamera=\ref[]>[]</A>)", A.name, src, C, Ctmp.c_tag)
				else
					dat += text("-- [] (No Camera)", A.name)
				if (sources.len > 1)
					dat += text("- [] sources", sources.len)
				dat += "</NOBR><BR>\n"
		else
			dat += "-- All Systems Nominal<BR>\n"
		dat += "<BR>\n"

	viewalerts = 1
	src << browse(dat, "window=aialerts&can_close=0")

/mob/living/silicon/ai/proc/ai_roster()
	var/dat = "<html><head><title>Crew Roster</title></head><body><b>Crew Roster:</b><br><br>"

	dat += data_core.get_manifest()
	dat += "</body></html>"

	src << browse(dat, "window=airoster")
	onclose(src, "airoster")

/mob/living/silicon/ai/proc/ai_call_shuttle()
	if(stat == DEAD)
		return //won't work if dead
	if(isAI(usr))
		var/mob/living/silicon/ai/AI = src
		if(AI.control_disabled)
			usr << "Wireless control is disabled!"
			return

	var/reason = input(src, "What is the nature of your emergency? ([CALL_SHUTTLE_REASON_LENGTH] characters required.)", "Confirm Shuttle Call") as null|text

	if(trim(reason))
		SSshuttle.requestEvac(src, reason)

	// hack to display shuttle timer
	if(!EMERGENCY_IDLE_OR_RECALLED)
		var/obj/machinery/computer/communications/C = locate() in machines
		if(C)
			C.post_status("shuttle")

/mob/living/silicon/ai/cancel_camera()
	view_core()

/mob/living/silicon/ai/verb/toggle_anchor()
	set category = "AI Commands"
	set name = "Toggle Floor Bolts"
	if(!isturf(loc)) // if their location isn't a turf
		return // stop
	if(stat == DEAD)
		return //won't work if dead
	anchored = !anchored // Toggles the anchor

	src << "<b>You are now [anchored ? "" : "un"]anchored.</b>"
	// the message in the [] will change depending whether or not the AI is anchored

/mob/living/silicon/ai/update_canmove() //If the AI dies, mobs won't go through it anymore
	return 0

/mob/living/silicon/ai/proc/ai_cancel_call()
	set category = "Malfunction"
	if(stat == DEAD)
		return //won't work if dead
	if(isAI(usr))
		var/mob/living/silicon/ai/AI = src
		if(AI.control_disabled)
			src	 << "Wireless control is disabled!"
			return
	SSshuttle.cancelEvac(src)
	return

/mob/living/silicon/ai/restrained(ignore_grab)
	. = 0

/mob/living/silicon/ai/Topic(href, href_list)
	if(usr != src)
		return
	..()
	if (href_list["mach_close"])
		if (href_list["mach_close"] == "aialerts")
			viewalerts = 0
		var/t1 = text("window=[]", href_list["mach_close"])
		unset_machine()
		src << browse(null, t1)
	if (href_list["switchcamera"])
		switchCamera(locate(href_list["switchcamera"])) in cameranet.cameras
	if (href_list["showalerts"])
		ai_alerts()
#ifdef AI_VOX
	if(href_list["say_word"])
		play_vox_word(href_list["say_word"], null, src)
		return
#endif
	if(href_list["show_paper"])
		if(last_paper_seen)
			src << browse(last_paper_seen, "window=show_paper")
	//Carn: holopad requests
	if(href_list["jumptoholopad"])
		var/obj/machinery/holopad/H = locate(href_list["jumptoholopad"])
		if(stat == CONSCIOUS)
			if(H)
				H.attack_ai(src) //may as well recycle
			else
				src << "<span class='notice'>Unable to locate the holopad.</span>"
	if(href_list["track"])
		var/string = href_list["track"]
		trackable_mobs()
		var/list/trackeable = list()
		trackeable += track.humans + track.others
		var/list/target = list()
		for(var/I in trackeable)
			var/mob/M = trackeable[I]
			if(M.name == string)
				target += M
		if(name == string)
			target += src
		if(target.len)
			ai_actual_track(pick(target))
		else
			src << "Target is not on or near any active cameras on the station."
		return
	if(href_list["callbot"]) //Command a bot to move to a selected location.
		Bot = locate(href_list["callbot"]) in living_mob_list
		if(!Bot || Bot.remote_disabled || src.control_disabled)
			return //True if there is no bot found, the bot is manually emagged, or the AI is carded with wireless off.
		waypoint_mode = 1
		src << "<span class='notice'>Set your waypoint by clicking on a valid location free of obstructions.</span>"
		return
	if(href_list["interface"]) //Remotely connect to a bot!
		Bot = locate(href_list["interface"]) in living_mob_list
		if(!Bot || Bot.remote_disabled || src.control_disabled)
			return
		Bot.attack_ai(src)
	if(href_list["botrefresh"]) //Refreshes the bot control panel.
		botcall()
		return

	if (href_list["ai_take_control"]) //Mech domination
		var/obj/mecha/M = locate(href_list["ai_take_control"])
		if(controlled_mech)
			src << "You are already loaded into an onboard computer!"
			return
		if(M)
			M.transfer_ai(AI_MECH_HACK,src, usr) //Called om the mech itself.


/mob/living/silicon/ai/proc/switchCamera(obj/machinery/camera/C)

	if(!tracking)
		cameraFollow = null

	if (!C || stat == DEAD) //C.can_use())
		return 0

	if(!src.eyeobj)
		view_core()
		return
	// ok, we're alive, camera is good and in our network...
	eyeobj.setLoc(get_turf(C))
	//machine = src

	return 1

/mob/living/silicon/ai/proc/botcall()
	set category = "AI Commands"
	set name = "Access Robot Control"
	set desc = "Wirelessly control various automatic robots."
	if(stat == 2)
		return //won't work if dead

	if(control_disabled)
		src << "Wireless communication is disabled."
		return
	var/turf/ai_current_turf = get_turf(src)
	var/ai_Zlevel = ai_current_turf.z
	var/d
	var/area/bot_area
	d += "<A HREF=?src=\ref[src];botrefresh=1>Query network status</A><br>"
	d += "<table width='100%'><tr><td width='40%'><h3>Name</h3></td><td width='30%'><h3>Status</h3></td><td width='30%'><h3>Location</h3></td><td width='10%'><h3>Control</h3></td></tr>"

	for (Bot in living_mob_list)
		if(Bot.z == ai_Zlevel && !Bot.remote_disabled) //Only non-emagged bots on the same Z-level are detected!
			bot_area = get_area(Bot)
			var/bot_mode = Bot.get_mode()
			d += "<tr><td width='30%'>[Bot.hacked ? "<span class='bad'>(!)</span>" : ""] [Bot.name]</A> ([Bot.model])</td>"
			//If the bot is on, it will display the bot's current mode status. If the bot is not mode, it will just report "Idle". "Inactive if it is not on at all.
			d += "<td width='30%'>[bot_mode]</td>"
			d += "<td width='30%'>[bot_area.name]</td>"
			d += "<td width='10%'><A HREF=?src=\ref[src];interface=\ref[Bot]>Interface</A></td>"
			d += "<td width='10%'><A HREF=?src=\ref[src];callbot=\ref[Bot]>Call</A></td>"
			d += "</tr>"
			d = format_text(d)

	var/datum/browser/popup = new(src, "botcall", "Remote Robot Control", 700, 400)
	popup.set_content(d)
	popup.open()

/mob/living/silicon/ai/proc/set_waypoint(atom/A)
	var/turf/turf_check = get_turf(A)
		//The target must be in view of a camera or near the core.
	if(turf_check in range(get_turf(src)))
		call_bot(turf_check)
	else if(cameranet && cameranet.checkTurfVis(turf_check))
		call_bot(turf_check)
	else
		src << "<span class='danger'>Selected location is not visible.</span>"

/mob/living/silicon/ai/proc/call_bot(turf/waypoint)

	if(!Bot)
		return

	if(Bot.calling_ai && Bot.calling_ai != src) //Prevents an override if another AI is controlling this bot.
		src << "<span class='danger'>Interface error. Unit is already in use.</span>"
		return

	Bot.call_bot(src, waypoint)

/mob/living/silicon/ai/triggerAlarm(class, area/A, O, obj/alarmsource)
	if(alarmsource.z != z)
		return
	if (stat == 2)
		return 1
	var/list/L = alarms[class]
	for (var/I in L)
		if (I == A.name)
			var/list/alarm = L[I]
			var/list/sources = alarm[3]
			if (!(alarmsource in sources))
				sources += alarmsource
			return 1
	var/obj/machinery/camera/C = null
	var/list/CL = null
	if (O && istype(O, /list))
		CL = O
		if (CL.len == 1)
			C = CL[1]
	else if (O && istype(O, /obj/machinery/camera))
		C = O
	L[A.name] = list(A, (C) ? C : O, list(alarmsource))
	if (O)
		if (C && C.can_use())
			queueAlarm("--- [class] alarm detected in [A.name]! (<A HREF=?src=\ref[src];switchcamera=\ref[C]>[C.c_tag]</A>)", class)
		else if (CL && CL.len)
			var/foo = 0
			var/dat2 = ""
			for (var/obj/machinery/camera/I in CL)
				dat2 += text("[]<A HREF=?src=\ref[];switchcamera=\ref[]>[]</A>", (!foo) ? "" : " | ", src, I, I.c_tag)	//I'm not fixing this shit...
				foo = 1
			queueAlarm(text ("--- [] alarm detected in []! ([])", class, A.name, dat2), class)
		else
			queueAlarm(text("--- [] alarm detected in []! (No Camera)", class, A.name), class)
	else
		queueAlarm(text("--- [] alarm detected in []! (No Camera)", class, A.name), class)
	if (viewalerts) ai_alerts()
	return 1

/mob/living/silicon/ai/cancelAlarm(class, area/A, obj/origin)
	var/list/L = alarms[class]
	var/cleared = 0
	for (var/I in L)
		if (I == A.name)
			var/list/alarm = L[I]
			var/list/srcs  = alarm[3]
			if (origin in srcs)
				srcs -= origin
			if (srcs.len == 0)
				cleared = 1
				L -= I
	if (cleared)
		queueAlarm("--- [class] alarm in [A.name] has been cleared.", class, 0)
		if (viewalerts) ai_alerts()
	return !cleared

//Replaces /mob/living/silicon/ai/verb/change_network() in ai.dm & camera.dm
//Adds in /mob/living/silicon/ai/proc/ai_network_change() instead
//Addition by Mord_Sith to define AI's network change ability
/mob/living/silicon/ai/proc/ai_network_change()
	set category = "AI Commands"
	set name = "Jump To Network"
	unset_machine()
	cameraFollow = null
	var/cameralist[0]

	if(stat == 2)
		return //won't work if dead

	var/mob/living/silicon/ai/U = usr

	for (var/obj/machinery/camera/C in cameranet.cameras)
		if(!C.can_use())
			continue

		var/list/tempnetwork = C.network
		tempnetwork.Remove("CREED", "thunder", "RD", "toxins", "Prison")
		if(tempnetwork.len)
			for(var/i in C.network)
				cameralist[i] = i
	var/old_network = network
	network = input(U, "Which network would you like to view?") as null|anything in cameralist

	if(!U.eyeobj)
		U.view_core()
		return

	if(isnull(network))
		network = old_network // If nothing is selected
	else
		for(var/obj/machinery/camera/C in cameranet.cameras)
			if(!C.can_use())
				continue
			if(network in C.network)
				U.eyeobj.setLoc(get_turf(C))
				break
	src << "<span class='notice'>Switched to [network] camera network.</span>"
//End of code by Mord_Sith


/mob/living/silicon/ai/proc/choose_modules()
	set category = "Malfunction"
	set name = "Choose Module"

	malf_picker.use(src)

/mob/living/silicon/ai/proc/ai_statuschange()
	set category = "AI Commands"
	set name = "AI Status"

	if(stat == 2)
		return //won't work if dead
	var/list/ai_emotions = list("Very Happy", "Happy", "Neutral", "Unsure", "Confused", "Sad", "BSOD", "Blank", "Problems?", "Awesome", "Facepalm", "Friend Computer", "Dorfy", "Blue Glow", "Red Glow")
	var/emote = input("Please, select a status!", "AI Status", null, null) in ai_emotions
	for (var/obj/machinery/M in machines) //change status
		if(istype(M, /obj/machinery/ai_status_display))
			var/obj/machinery/ai_status_display/AISD = M
			AISD.emotion = emote
		//if Friend Computer, change ALL displays
		else if(istype(M, /obj/machinery/status_display))

			var/obj/machinery/status_display/SD = M
			if(emote=="Friend Computer")
				SD.friendc = 1
			else
				SD.friendc = 0
	return

//I am the icon meister. Bow fefore me.	//>fefore
/mob/living/silicon/ai/proc/ai_hologram_change()
	set name = "Change Hologram"
	set desc = "Change the default hologram available to AI to something else."
	set category = "AI Commands"

	if(stat == 2)
		return //won't work if dead
	var/input
	if(alert("Would you like to select a hologram based on a crew member or switch to unique avatar?",,"Crew Member","Unique")=="Crew Member")

		var/personnel_list[] = list()

		for(var/datum/data/record/t in data_core.locked)//Look in data core locked.
			personnel_list["[t.fields["name"]]: [t.fields["rank"]]"] = t.fields["image"]//Pull names, rank, and image.

		if(personnel_list.len)
			input = input("Select a crew member:") as null|anything in personnel_list
			var/icon/character_icon = personnel_list[input]
			if(character_icon)
				qdel(holo_icon)//Clear old icon so we're not storing it in memory.
				holo_icon = getHologramIcon(icon(character_icon))
		else
			alert("No suitable records found. Aborting.")

	else
		var/icon_list[] = list(
		"default",
		"floating face",
		"xeno queen",
		"space carp"
		)
		input = input("Please select a hologram:") as null|anything in icon_list
		if(input)
			qdel(holo_icon)
			switch(input)
				if("default")
					holo_icon = getHologramIcon(icon('icons/mob/AI.dmi',"holo1"))
				if("floating face")
					holo_icon = getHologramIcon(icon('icons/mob/AI.dmi',"holo2"))
				if("xeno queen")
					holo_icon = getHologramIcon(icon('icons/mob/AI.dmi',"holo3"))
				if("space carp")
					holo_icon = getHologramIcon(icon('icons/mob/AI.dmi',"holo4"))
	return

/mob/living/silicon/ai/proc/corereturn()
	set category = "Malfunction"
	set name = "Return to Main Core"

	var/obj/machinery/power/apc/apc = src.loc
	if(!istype(apc))
		src << "<span class='notice'>You are already in your Main Core.</span>"
		return
	apc.malfvacate()

/mob/living/silicon/ai/proc/toggle_camera_light()
	if(stat != CONSCIOUS)
		return

	camera_light_on = !camera_light_on

	if (!camera_light_on)
		src << "Camera lights deactivated."

		for (var/obj/machinery/camera/C in lit_cameras)
			C.SetLuminosity(0)
			lit_cameras = list()

		return

	light_cameras()

	src << "Camera lights activated."

//AI_CAMERA_LUMINOSITY

/mob/living/silicon/ai/proc/light_cameras()
	var/list/obj/machinery/camera/add = list()
	var/list/obj/machinery/camera/remove = list()
	var/list/obj/machinery/camera/visible = list()
	for (var/datum/camerachunk/CC in eyeobj.visibleCameraChunks)
		for (var/obj/machinery/camera/C in CC.cameras)
			if (!C.can_use() || get_dist(C, eyeobj) > 7)
				continue
			visible |= C

	add = visible - lit_cameras
	remove = lit_cameras - visible

	for (var/obj/machinery/camera/C in remove)
		lit_cameras -= C //Removed from list before turning off the light so that it doesn't check the AI looking away.
		C.Togglelight(0)
	for (var/obj/machinery/camera/C in add)
		C.Togglelight(1)
		lit_cameras |= C

/mob/living/silicon/ai/proc/control_integrated_radio()
	set name = "Transceiver Settings"
	set desc = "Allows you to change settings of your radio."
	set category = "AI Commands"

	if(stat == 2)
		return //won't work if dead

	src << "Accessing Subspace Transceiver control..."
	if (radio)
		radio.interact(src)

/mob/living/silicon/ai/proc/set_syndie_radio()
	if(radio)
		radio.make_syndie()

/mob/living/silicon/ai/proc/set_automatic_say_channel()
	set name = "Set Auto Announce Mode"
	set desc = "Modify the default radio setting for your automatic announcements."
	set category = "AI Commands"

	if(stat == 2)
		return //won't work if dead
	set_autosay()

/mob/living/silicon/ai/transfer_ai(interaction, mob/user, mob/living/silicon/ai/AI, obj/item/device/aicard/card)
	if(!..())
		return
	if(interaction == AI_TRANS_TO_CARD)//The only possible interaction. Upload AI mob to a card.
		if(!mind)
			user << "<span class='warning'>No intelligence patterns detected.</span>"    //No more magical carding of empty cores, AI RETURN TO BODY!!!11
			return
		new /obj/structure/AIcore/deactivated(loc)//Spawns a deactivated terminal at AI location.
		ai_restore_power()//So the AI initially has power.
		control_disabled = 1//Can't control things remotely if you're stuck in a card!
		radio_enabled = 0 	//No talking on the built-in radio for you either!
		forceMove(card)
		card.AI = src
		src << "You have been downloaded to a mobile storage device. Remote device connection severed."
		user << "<span class='boldnotice'>Transfer successful</span>: [name] ([rand(1000,9999)].exe) removed from host terminal and stored within local memory."

/mob/living/silicon/ai/can_buckle()
	return 0

/mob/living/silicon/ai/canUseTopic(atom/movable/M, be_close = 0)
	if(stat)
		return
	if(be_close && !in_range(M, src))
		return
	//stop AIs from leaving windows open and using then after they lose vision
	//apc_override is needed here because AIs use their own APC when powerless
	//get_turf_pixel() is because APCs in maint aren't actually in view of the inner camera
	if(M && cameranet && !cameranet.checkTurfVis(get_turf_pixel(M)) && !apc_override)
		return
	return 1

/mob/living/silicon/ai/proc/relay_speech(message, atom/movable/speaker, message_langs, raw_message, radio_freq, list/spans)
	raw_message = lang_treat(speaker, message_langs, raw_message, spans)
	var/name_used = speaker.GetVoice()
	var/rendered = "<i><span class='game say'>Relayed Speech: <span class='name'>[name_used]</span> <span class='message'>[raw_message]</span></span></i>"
	show_message(rendered, 2)

/mob/living/silicon/ai/fully_replace_character_name(oldname,newname)
	..()
	if(oldname != real_name)
		if(eyeobj)
			eyeobj.name = "[newname] (AI Eye)"

		// Notify Cyborgs
		for(var/mob/living/silicon/robot/Slave in connected_robots)
			Slave.show_laws()

/mob/living/silicon/ai/replace_identification_name(oldname,newname)
	if(aiPDA)
		aiPDA.owner = newname
		aiPDA.name = newname + " (" + aiPDA.ownjob + ")"


/mob/living/silicon/ai/proc/add_malf_picker()
	src << "In the top right corner of the screen you will find the Malfunctions tab, where you can purchase various abilities, from upgraded surveillance to station ending doomsday devices."
	src << "You are also capable of hacking APCs, which grants you more points to spend on your Malfunction powers. The drawback is that a hacked APC will give you away if spotted by the crew. Hacking an APC takes 60 seconds."
	view_core() //A BYOND bug requires you to be viewing your core before your verbs update
	verbs += /mob/living/silicon/ai/proc/choose_modules
	malf_picker = new /datum/module_picker


/mob/living/silicon/ai/reset_perspective(atom/A)
	if(camera_light_on)
		light_cameras()
	if(istype(A,/obj/machinery/camera))
		current = A
	if(client)
		if(istype(A, /atom/movable))
			client.perspective = EYE_PERSPECTIVE
			client.eye = A
		else
			if(isturf(loc))
				if(eyeobj)
					client.eye = eyeobj
					client.perspective = MOB_PERSPECTIVE
				else
					client.eye = client.mob
					client.perspective = MOB_PERSPECTIVE
			else
				client.perspective = EYE_PERSPECTIVE
				client.eye = loc
		update_sight()
		if(client.eye != src)
			var/atom/AT = client.eye
			AT.get_remote_view_fullscreens(src)
		else
			clear_fullscreen("remote_view", 0)

/mob/living/silicon/ai/revive(full_heal = 0, admin_revive = 0)
	if(..()) //successfully ressuscitated from death
		icon_state = "ai"
		. = 1

/mob/living/silicon/ai/proc/malfhacked(obj/machinery/power/apc/apc)
	malfhack = null
	malfhacking = 0
	clear_alert("hackingapc")

	if(!istype(apc) || qdeleted(apc) || apc.stat & BROKEN)
		src << "<span class='danger'>Hack aborted. The designated APC no \
			longer exists on the power network.</span>"
		playsound(get_turf(src), 'sound/machines/buzz-two.ogg', 50, 1)
	else if(apc.aidisabled)
		src << "<span class='danger'>Hack aborted. \The [apc] is no \
			longer responding to our systems.</span>"
		playsound(get_turf(src), 'sound/machines/buzz-sigh.ogg', 50, 1)
	else
		malf_picker.processing_time += 10

		apc.malfai = parent || src
		apc.malfhack = TRUE
		apc.locked = TRUE
		apc.coverlocked = TRUE

		playsound(get_turf(src), 'sound/machines/ding.ogg', 50, 1)
		src << "Hack complete. \The [apc] is now under your \
			exclusive control."
		apc.update_icon()

/mob/living/silicon/ai/spawned/New(loc, datum/ai_laws/L, obj/item/device/mmi/B, safety = 0)
	..(loc,L,B,1)
