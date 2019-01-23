/client/verb/aooc(msg as text)
	set name = "AOOC"
	set desc = "An OOC channel exclusive to antagonists."
	set category = "OOC"

	if(GLOB.say_disabled)	//This is here to try to identify lag problems
		to_chat(usr, "<span class='danger'>Speech is currently admin-disabled.</span>")
		return

	if(!mob)
		return

	if(!holder)
		if(mob.stat == DEAD)
			to_chat(usr, "<span class='danger'>You cannot use AOOC while dead.</span>")
			return
		if(!is_special_character(mob))
			to_chat(usr, "<span class='danger'>You aren't an antagonist!</span>")
		if(prefs.muted & MUTE_OOC)
			to_chat(src, "<span class='danger'>You cannot use AOOC (muted).</span>")
			return
		if(jobban_isbanned(src.mob, "OOC"))
			to_chat(src, "<span class='danger'>You are banned from OOC.</span>")
			return
		if(!GLOB.aooc_allowed)
			to_chat(src, "<span class='danger'>AOOC is currently muted.</span>")
			return
	if(QDELETED(src))
		return

	msg = copytext(sanitize(msg), 1, MAX_MESSAGE_LEN)
	var/raw_msg = msg

	if(!msg)
		return

	msg = emoji_parse(msg)

	if(!holder)
		if(handle_spam_prevention(msg,MUTE_OOC))
			return
		if(findtext(msg, "byond://"))
			to_chat(src, "<B>Advertising other servers is not allowed.</B>")
			log_admin("[key_name(src)] has attempted to advertise in AOOC: [msg]")
			message_admins("[key_name_admin(src)] has attempted to advertise in AOOC: [msg]")
			return

	mob.log_talk(raw_msg,LOG_OOC, tag="(AOOC)")

	var/keyname = key
	if(prefs.unlock_content)
		if(prefs.toggles & MEMBER_PUBLIC)
			keyname = "<font color='[prefs.ooccolor ? prefs.ooccolor : GLOB.antag_ooc_colour]'>[icon2html('icons/member_content.dmi', world, "blag")][keyname]</font>"
	//The linkify span classes and linkify=TRUE below make ooc text get clickable chat href links if you pass in something resembling a url

	var/antaglisting = list()

	for(var/datum/mind/M in get_antag_minds(/datum/antagonist))
		if(!M.current || !M.current.client || isnewplayer(M.current))
			continue
		antaglisting |= M.current.client

	for(var/mob/M in GLOB.player_list)
		if(M.client && (M.stat == DEAD || M.client.holder) && !istype(M, /mob/dead/new_player))
			antaglisting |= M.client

	for(var/client/C in antaglisting)
		if(!C || !istype(C))
			continue
		if(holder)
			if(!holder.fakekey || C.holder)
				if(check_rights_for(src, R_ADMIN))
					to_chat(C, "<span class='adminooc'>[CONFIG_GET(flag/allow_admin_ooccolor) && prefs.ooccolor ? "<font color=[prefs.ooccolor]>" :"" ]<span class='prefix'>Antag OOC:</span> <EM>[keyname][holder.fakekey ? "/([holder.fakekey])" : ""]:</EM> <span class='message linkify'>[msg]</span></span></font>")
				else
					to_chat(C, "<span class='adminobserverooc'><span class='prefix'>Antag OOC:</span> <EM>[keyname][holder.fakekey ? "/([holder.fakekey])" : ""]:</EM> <span class='message linkify'>[msg]</span></span>")
			else
				to_chat(C, "<font color='[GLOB.antag_ooc_colour]'><span class='ooc'><span class='prefix'>Antag OOC:</span> <EM>[holder.fakekey ? holder.fakekey : key]:</EM> <span class='message linkify'>[msg]</span></span></font>")
		else if(!(key in C.prefs.ignoring))
			to_chat(C, "<font color='[GLOB.antag_ooc_colour]'><span class='ooc'><span class='prefix'>Antag OOC:</span> <EM>[keyname]:</EM> <span class='message linkify'>[msg]</span></span></font>")

GLOBAL_VAR_INIT(antag_ooc_colour, AOOC_COLOR)

/client/proc/set_aooc(newColor as color)
	set name = "Set Antag OOC Color"
	set desc = "Modifies antag OOC Color"
	set category = "Fun"
	GLOB.antag_ooc_colour = sanitize_ooccolor(newColor)

/client/proc/reset_aooc()
	set name = "Reset Antag OOC Color"
	set desc = "Returns antag OOC Color to default"
	set category = "Fun"
	GLOB.antag_ooc_colour = AOOC_COLOR

/proc/toggle_aooc(toggle = null)
	if(toggle != null) //if we're specifically en/disabling ooc
		if(toggle != GLOB.aooc_allowed)
			GLOB.aooc_allowed = toggle
		else
			return
	else //otherwise just toggle it
		GLOB.aooc_allowed = !GLOB.aooc_allowed

	var/antaglisting = list()	//Only those who have access to AOOC need to know if it's enabled or not.

	for(var/datum/mind/M in get_antag_minds(/datum/antagonist))
		if(!M.current || !M.current.client || isnewplayer(M.current))
			continue
		antaglisting |= M.current.client

	for(var/mob/M in GLOB.player_list)
		if(M.client && (M.stat == DEAD || M.client.holder))
			antaglisting |= M.client

	for(var/client/C in antaglisting)
		if(!C || !istype(C))
			continue
		to_chat(C, "<B>The Antagonist OOC channel has been [GLOB.aooc_allowed ? "enabled. If you're an antagonist, you can access it through the \"AOOC\" verb." : "disabled"].</B>")
