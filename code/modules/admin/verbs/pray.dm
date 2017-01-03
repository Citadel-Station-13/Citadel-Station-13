/mob/verb/pray(msg as text)
	set category = "IC"
	set name = "Pray"

	if(say_disabled)	//This is here to try to identify lag problems
		usr << "<span class='danger'>Speech is currently admin-disabled.</span>"
		return

	msg = copytext(sanitize(msg), 1, MAX_MESSAGE_LEN)
	if(!msg)
		return
	log_prayer("[src.key]/([src.name]): [msg]")
	if(usr.client)
		if(usr.client.prefs.muted & MUTE_PRAY)
			usr << "<span class='danger'>You cannot pray (muted).</span>"
			return
		if(src.client.handle_spam_prevention(msg,MUTE_PRAY))
			return

	var/image/cross = image('icons/obj/storage.dmi',"bible")
	var/font_color = "purple"
	var/prayer_type = "PRAYER"
	var/deity
	if(usr.job == "Chaplain")
		cross = image('icons/obj/storage.dmi',"kingyellow")
		font_color = "blue"
		prayer_type = "CHAPLAIN PRAYER"
		if(SSreligion.Bible_deity_name)
			deity = SSreligion.Bible_deity_name
	else if(iscultist(usr))
		cross = image('icons/obj/storage.dmi',"tome")
		font_color = "red"
		prayer_type = "CULTIST PRAYER"
		deity = "Nar-Sie"

	msg = "<span class='adminnotice'>\icon[cross] \
		<b><font color=[font_color]>[prayer_type][deity ? " (to [deity])" : ""]: </font>\
		[ADMIN_FULLMONTY(src)] [ADMIN_SC(src)]:</b> \
		[msg]</span>"

	for(var/client/C in admins)
		if(C.prefs.chat_toggles & CHAT_PRAYER)
			C << msg
			if(C.prefs.toggles & SOUND_PRAYERS)
				if(usr.job == "Chaplain")
					C << 'sound/effects/pray.ogg'
	usr << "Your prayers have been received by the gods."

	feedback_add_details("admin_verb","PR") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	//log_admin("HELP: [key_name(src)]: [msg]")

/proc/Centcomm_announce(text , mob/Sender)
	var/msg = copytext(sanitize(text), 1, MAX_MESSAGE_LEN)
	msg = "<span class='adminnotice'>\
		<b><font color=orange>CENTCOM:</font>\
		[ADMIN_FULLMONTY(Sender)] [ADMIN_BSA(Sender)] \
		[ADMIN_CENTCOM_REPLY(Sender)]:</b> \
		[msg]</span>"
	admins << msg
	for(var/obj/machinery/computer/communications/C in machines)
		C.overrideCooldown()

/proc/Syndicate_announce(text , mob/Sender)
	var/msg = copytext(sanitize(text), 1, MAX_MESSAGE_LEN)
	msg = "<span class='adminnotice'><b>\
		<font color=crimson>SYNDICATE:</font>\
		[ADMIN_FULLMONTY(Sender)] [ADMIN_BSA(Sender)] \
		[ADMIN_SYNDICATE_REPLY(Sender)]:</b> \
		[msg]</span>"
	admins << msg
	for(var/obj/machinery/computer/communications/C in machines)
		C.overrideCooldown()

/proc/Nuke_request(text , mob/Sender)
	var/msg = copytext(sanitize(text), 1, MAX_MESSAGE_LEN)
	msg = "<span class='adminnotice'>\
		<b><font color=orange>NUKE CODE REQUEST:</font>\
		[ADMIN_FULLMONTY(Sender)] [ADMIN_BSA(Sender)] \
		[ADMIN_CENTCOM_REPLY(Sender)] \
		[ADMIN_SET_SD_CODE]:</b> \
		[msg]</span>"
	admins << msg
	for(var/obj/machinery/computer/communications/C in machines)
		C.overrideCooldown()
