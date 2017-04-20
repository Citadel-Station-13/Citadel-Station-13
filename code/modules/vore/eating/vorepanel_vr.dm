//
// Vore management panel for players
//

/mob/living/proc/insidePanel()
	set name = "Vore Panel"
	set category = "Vore"

	var/datum/vore_look/picker_holder = new()
	picker_holder.loop = picker_holder
	picker_holder.selected = vore_organs[vore_selected]

	var/dat = picker_holder.gen_vui(src)

	picker_holder.popup = new(src, "insidePanel","Vore Panel", 400, 600, picker_holder)
	picker_holder.popup.set_content(dat)
	picker_holder.popup.open()

//
// Callback Handler for the Inside form
//
/datum/vore_look
	var/datum/belly/selected
	var/datum/browser/popup
	var/loop = null;  // Magic self-reference to stop the handler from being GC'd before user takes action.

/datum/vore_look/Topic(href,href_list[])
	if (vp_interact(href, href_list))
		popup.set_content(gen_vui(usr))
		usr << output(popup.get_content(), "insidePanel.browser")

/datum/vore_look/proc/gen_vui(var/mob/living/user)
	var/dat

	if (is_vore_predator(user.loc))
		var/mob/living/eater = user.loc
		var/datum/belly/inside_belly

		//This big block here figures out where the prey is
		inside_belly = check_belly(user)

		if(inside_belly)
			dat += "<font color = 'green'>You are currently inside</font> <font color = 'yellow'>[eater]'s</font> <font color = 'red'>[inside_belly]</font>!<br><br>"

			if(inside_belly.inside_flavor)
				dat += "[inside_belly.inside_flavor]<br><br>"

			if (inside_belly.internal_contents.len > 1)
				dat += "You can see the following around you:<br>"
				for (var/atom/movable/O in inside_belly.internal_contents)
					if(istype(O,/mob/living))
						var/mob/living/M = O
						//That's just you
						if(M == user)
							continue
					//Anything else
					dat += "<a href='?src=\ref[src];outsidepick=\ref[O];outsidebelly=\ref[inside_belly]'>[O]</a>"
	else
		dat += "You aren't inside anyone."

	dat += "<HR>"

	dat += "<ol style='list-style: none; padding: 0; overflow: auto;'>"
	for(var/K in user.vore_organs) //Fuggin can't iterate over values
		var/datum/belly/B = user.vore_organs[K]
		if(B == selected)
			dat += "<li style='float: left'><a href='?src=\ref[src];bellypick=\ref[B]'><b>[B.name]</b>"
		else
			dat += "<li style='float: left'><a href='?src=\ref[src];bellypick=\ref[B]'>[B.name]"

		var/spanstyle
		switch(B.digest_mode)
			if(DM_HOLD)
				spanstyle = ""
			if(DM_DIGEST)
				spanstyle = "color:red;"
			if(DM_HEAL)
				spanstyle = "color:green;"

		dat += "<span style='[spanstyle]'> ([B.internal_contents.len])</span></a></li>"

	if(user.vore_organs.len < 10)
		dat += "<li style='float: left'><a href='?src=\ref[src];newbelly=1'>New+</a></li>"
	dat += "</ol>"
	dat += "<HR>"

	// Selected Belly (contents, configuration)
	if(!selected)
		dat += "No belly selected. Click one to select it."
	else
		if(selected.internal_contents.len > 0)
			dat += "<b>Contents:</b> "
			for(var/O in selected.internal_contents)
				dat += "<a href='?src=\ref[src];insidepick=\ref[O]'>[O]</a>"

			//If there's more than one thing, add an [All] button
			if(selected.internal_contents.len > 1)
				dat += "<a href='?src=\ref[src];insidepick=1;pickall=1'>\[All\]</a>"

			dat += "<HR>"

		//Belly Name Button
		dat += "<a href='?src=\ref[src];b_name=\ref[selected]'>Name:</a>"
		dat += " '[selected.name]'"

		//Digest Mode Button
		dat += "<br><a href='?src=\ref[src];b_mode=\ref[selected]'>Belly Mode:</a>"
		dat += " [selected.digest_mode]"

		//Belly verb
		dat += "<br><a href='?src=\ref[src];b_verb=\ref[selected]'>Vore Verb:</a>"
		dat += " '[selected.vore_verb]'"

		//Inside flavortext
		dat += "<br><a href='?src=\ref[src];b_desc=\ref[selected]'>Flavor Text:</a>"
		dat += " '[selected.inside_flavor]'"

		//Belly sound
		dat += "<br><a href='?src=\ref[src];b_sound=\ref[selected]'>Set Vore Sound</a>"
		dat += "<a href='?src=\ref[src];b_soundtest=\ref[selected]'>Test</a>"

		//Belly messages
		dat += "<br><a href='?src=\ref[src];b_msgs=\ref[selected]'>Belly Messages</a>"

		//Delete button
		dat += "<br><a style='background:#990000;' href='?src=\ref[src];b_del=\ref[selected]'>Delete Belly</a>"

	dat += "<HR>"

	//Under the last HR, save and stuff.
	dat += "<a href='?src=\ref[src];saveprefs=1'>Save Prefs</a>"
	dat += "<a href='?src=\ref[src];refresh=1'>Refresh</a>"

	switch(user.digestable)
		if(TRUE)
			dat += "<a href='?src=\ref[src];toggledg=1'>Toggle Digestable (Currently: ON)</a>"
		if(FALSE)
			dat += "<a href='?src=\ref[src];toggledg=1'>Toggle Digestable (Currently: OFF)</a>"

	switch(user.devourable)
		if(TRUE)
			dat += "<a href='?src=\ref[src];toggledvor=1'>Toggle Devourable (Currently: ON)</a>"
		if(FALSE)
			dat += "<a href='?src=\ref[src];toggledvor=1'>Toggle Devourable (Currently: OFF)</a>"

	//Returns the dat html to the vore_look
	return dat

/datum/vore_look/proc/vp_interact(href, href_list)
	var/mob/living/user = usr
	for(var/H in href_list)

	if(href_list["close"])
		del(src)  // Cleanup
		return

	if(href_list["outsidepick"])
		var/tgt = locate(href_list["outsidepick"])
		var/datum/belly/OB = locate(href_list["outsidebelly"])
		var/intent = "Examine"

		if(istype(tgt,/mob/living))
			var/mob/living/M = tgt
			intent = alert("What do you want to do to them?","Query","Examine","Help Out","Devour")
			switch(intent)
				if("Examine") //Examine a mob inside another mob
					M.examine(user)

				if("Help Out") //Help the inside-mob out
					to_chat(user, "<font color='green'>You begin to push [M] to freedom!</font>")
					to_chat(M, "[usr] begins to push you to freedom!")
					M.loc << "<span class='warning'>Someone is trying to escape from inside you!</span>"
					sleep(50)
					if(prob(33))
						OB.release_specific_contents(M)
						to_chat(usr, "<font color='green'>You manage to help [M] to safety!</font>")
						to_chat(M, "<font color='green'>[user] pushes you free!</font>")
						M.loc << "<span class='alert'>[M] forces free of the confines of your body!</span>"
					else
						to_chat(user, "<span class='alert'>[M] slips back down inside despite your efforts.</span>")
						to_chat(M, "<span class='alert'> Even with [user]'s help, you slip back inside again.</span>")
						M.loc << "<font color='green'>Your body efficiently shoves [M] back where they belong.</font>"

				if("Devour") //Eat the inside mob
					if(!user.vore_selected)
						to_chat(user, "<span class='warning'>Pick a belly on yourself first!</span>")
						return TRUE

					var/datum/belly/TB = user.vore_organs[user.vore_selected]
					to_chat(user, "<span class='warning'>You begin to [lowertext(TB.vore_verb)] [M] into your [lowertext(TB.name)]!</span>")
					to_chat(M, "<span class='warning'>[user] begins to [lowertext(TB.vore_verb)] you into their [lowertext(TB.name)]!</span>")
					M.loc << "<span class='warning'>Someone inside you is eating someone else!</span>"

					sleep(TB.nonhuman_prey_swallow_time)
					if((user in OB.internal_contents) && (M in OB.internal_contents))
						to_chat(user, "<span class='warning'>You manage to [lowertext(TB.vore_verb)] [M] into your [lowertext(TB.name)]!</span>")
						to_chat(M, "<span class='warning'>[user] manages to [lowertext(TB.vore_verb)] you into their [lowertext(TB.name)]!</span>")
						M.loc << "<span class='warning'>Someone inside you has eaten someone else!</span>"
						M.loc = user
						TB.nom_mob(M)
						OB.internal_contents -= M

		else if(istype(tgt,/obj/item))
			var/obj/item/T = tgt
			intent = alert("What do you want to do to that?","Query","Examine","Use Hand")
			switch(intent)
				if("Examine")
					T.examine(user)

				if("Use Hand")
					if(user.stat)
						to_chat(user, "<span class='warning'>You can't do that in your state!</span>")
						return TRUE

					user.ClickOn(T)
					sleep(5) //Seems to exit too fast for the panel to update

	if(href_list["insidepick"])
		var/intent

		//Handle the [All] choice. Ugh inelegant. Someone make this pretty.
		if(href_list["pickall"])
			intent = alert("Eject all, Move all?","Query","Eject all","Cancel","Move all")
			switch(intent)
				if("Cancel")
					return 1

				if("Eject all")
					if(user.stat)
						to_chat(user, "<span class='warning'>You can't do that in your state!</span>")
						return TRUE

					selected.release_all_contents()
					playsound(user, 'sound/vore/pred/escape.ogg', volume=80)
					user.loc << "<span class='danger'>Everything is released from [user]!</span>"

				if("Move all")
					if(user.stat)
						to_chat(user, "<span class='warning'>You can't do that in your state!</span>")
						return TRUE

					var/choice = input("Move all where?","Select Belly") in user.vore_organs + "Cancel - Don't Move"

					if(choice == "Cancel - Don't Move")
						return TRUE
					else
						var/datum/belly/B = user.vore_organs[choice]
						for(var/atom/movable/tgt in selected.internal_contents)
							selected.internal_contents -= tgt
							B.internal_contents += tgt

							to_chat(tgt, "<span class='warning'>You're squished from [user]'s [selected] to their [B]!</span>")

						for(var/mob/hearer in range(1,user))
							hearer << sound('sound/vore/pred/stomachmove.ogg',volume=80)
			return TRUE


		var/atom/movable/tgt = locate(href_list["insidepick"])
		intent = "Examine"
		intent = alert("Examine, Eject, Move? Examine if you want to leave this box.","Query","Examine","Eject","Move")
		switch(intent)
			if("Examine")
				tgt.examine(user)

			if("Eject")
				if(user.stat)
					to_chat(user, "<span class='warning'>You can't do that in your state!</span>")
					return TRUE

				selected.release_specific_contents(tgt)
				playsound(user, 'sound/effects/splat.ogg', 50, 1)
				user.loc << "<span class='danger'>[tgt] is released from [user]!</span>"

			if("Move")
				if(user.stat)
					to_chat(user, "<span class='warning'>You can't do that in your state!</span>")
					return TRUE

				var/choice = input("Move [tgt] where?","Select Belly") in user.vore_organs + "Cancel - Don't Move"

				if(choice == "Cancel - Don't Move")
					return TRUE
				else
					var/datum/belly/B = user.vore_organs[choice]
					selected.internal_contents -= tgt
					B.internal_contents += tgt

					to_chat(tgt, "<span class='warning'>You're squished from [user]'s [lowertext(selected.name)] to their [lowertext(B.name)]!</span>")
					for(var/mob/hearer in range(1,user))
						hearer << sound('sound/vore/pred/stomachmove.ogg',volume=80)

	if(href_list["newbelly"])
		if(user.vore_organs.len >= 10)
			return TRUE

		var/new_name = html_encode(input(usr,"New belly's name:","New Belly") as text|null)

		if(length(new_name) > 12 || length(new_name) < 2)
			to_chat(usr, "<span class='warning'>Entered belly name is too long.</span>")
			return FALSE
		if(new_name in user.vore_organs)
			to_chat(usr, "<span class='warning'>No duplicate belly names, please.</span>")
			return FALSE

		var/datum/belly/NB = new(user)
		NB.name = new_name
		NB.owner = user //might be the thing we all needed.
		user.vore_organs[new_name] = NB
		selected = NB

	if(href_list["bellypick"])
		selected = locate(href_list["bellypick"])
		user.vore_selected = selected.name

	if(href_list["b_name"])
		var/new_name = html_encode(input(usr,"Belly's new name:","New Name") as text|null)

		if(length(new_name) > 12 || length(new_name) < 2)
			to_chat(usr, "<span class='warning'>Entered belly name length invalid (must be longer than 2, shorter than 12).</span>")
			return FALSE
		if(new_name in user.vore_organs)
			to_chat(usr, "<span class='warning'>No duplicate belly names, please.</span>")
			return FALSE

		user.vore_organs[new_name] = selected
		user.vore_organs -= selected.name
		selected.name = new_name

	if(href_list["b_mode"])
		var/list/menu_list = selected.digest_modes

		if(selected.digest_modes.len == 1) // Don't do anything
			return 1
		if(selected.digest_modes.len == 2) // Just toggle... there's probably a more elegant way to do this...
			var/index = selected.digest_modes.Find(selected.digest_mode)
			switch(index)
				if(1)
					selected.digest_mode = selected.digest_modes[2]
				if(2)
					selected.digest_mode = selected.digest_modes[1]
		else
			selected.digest_mode = input("Choose Mode (currently [selected.digest_mode])") in menu_list

	if(href_list["b_desc"])
		var/new_desc = html_encode(input(usr,"Belly Description (1024 char limit):","New Description",selected.inside_flavor) as message|null)
		new_desc = readd_quotes(new_desc)

		if(length(new_desc) > 1024)
			to_chat(usr, "<span class='warning'>Entered belly desc too long. 1024 character limit.</span>")
			return FALSE

		selected.inside_flavor = new_desc

	if(href_list["b_msgs"])
		var/list/messages = list(
			"Digest Message (to prey)",
			"Digest Message (to you)",
			"Struggle Message (outside)",
			"Struggle Message (inside)",
			"Examine Message (when full)",
			"Reset All To Default",
			"Cancel - No Changes"
		)

		alert(user,"Setting abusive or deceptive messages will result in a ban. Consider this your warning. Max 150 characters per message, max 10 messages per topic.","Really, don't.")
		var/choice = input(user,"Select a type to modify. Messages from each topic are pulled at random when needed.","Pick Type") in messages
		var/help = " Press enter twice to separate messages. '%pred' will be replaced with your name. '%prey' will be replaced with the prey's name. '%belly' will be replaced with your belly's name."

		switch(choice)
			if("Digest Message (to prey)")
				var/new_message = input(user,"These are sent to prey when they expire. Write them in 2nd person ('you feel X'). Avoid using %prey in this type."+help,"Digest Message (to prey)",selected.get_messages("dmp")) as message
				if(new_message)
					selected.set_messages(new_message,"dmp")

			if("Digest Message (to you)")
				var/new_message = input(user,"These are sent to you when prey expires in you. Write them in 2nd person ('you feel X'). Avoid using %pred in this type."+help,"Digest Message (to you)",selected.get_messages("dmo")) as message
				if(new_message)
					selected.set_messages(new_message,"dmo")

			if("Struggle Message (outside)")
				var/new_message = input(user,"These are sent to those nearby when prey struggles. Write them in 3rd person ('X's Y bulges')."+help,"Struggle Message (outside)",selected.get_messages("smo")) as message
				if(new_message)
					selected.set_messages(new_message,"smo")

			if("Struggle Message (inside)")
				var/new_message = input(user,"These are sent to prey when they struggle. Write them in 2nd person ('you feel X'). Avoid using %prey in this type."+help,"Struggle Message (inside)",selected.get_messages("smi")) as message
				if(new_message)
					selected.set_messages(new_message,"smi")

			if("Examine Message (when full)")
				var/new_message = input(user,"These are sent to people who examine you when this belly has contents. Write them in 3rd person ('Their %belly is bulging'). Do not use %pred or %prey in this type."+help,"Examine Message (when full)",selected.get_messages("em")) as message
				if(new_message)
					selected.set_messages(new_message,"em")

			if("Reset All To Default")
				var/confirm = alert(user,"This will delete any custom messages. Are you sure?","Confirmation","DELETE","Cancel")
				if(confirm == "DELETE")
					selected.digest_messages_prey = initial(selected.digest_messages_prey)
					selected.digest_messages_owner = initial(selected.digest_messages_owner)
					selected.struggle_messages_outside = initial(selected.struggle_messages_outside)
					selected.struggle_messages_inside = initial(selected.struggle_messages_inside)

			if("Cancel - No Changes")
				return TRUE

	if(href_list["b_verb"])
		var/new_verb = html_encode(input(usr,"New verb when eating (infinitive tense, e.g. nom or swallow):","New Verb") as text|null)

		if(length(new_verb) > 12 || length(new_verb) < 2)
			to_chat(usr, "<span class='warning'>Entered verb length invalid (must be longer than 2, shorter than 12).</span>")
			return FALSE

		selected.vore_verb = new_verb

	if(href_list["b_sound"])
		var/choice = input(user,"Currently set to [selected.vore_sound]","Select Sound") in GLOB.pred_vore_sounds + "Cancel - No Changes"

		if(choice == "Cancel")
			return 1

		selected.vore_sound = GLOB.pred_vore_sounds[choice]

	if(href_list["b_soundtest"])
		user << selected.vore_sound

	if(href_list["b_del"])
		if(selected.internal_contents.len)
			to_chat(usr, "<span class='warning'>Can't delete bellies with contents!</span>")
		else if(selected.immutable)
			to_chat(usr, "<span class='warning'>This belly is marked as undeletable.</span>")
		else if(user.vore_organs.len == 1)
			to_chat(usr, "<span class='warning'>You must have at least one belly.</span>")
		else
			var/alert = alert("Are you sure you want to delete [selected]?","Confirmation","Delete","Cancel")
			if(alert == "Delete" && !selected.internal_contents.len)
				user.vore_organs -= selected.name
				user.vore_organs.Remove(selected)
				selected = user.vore_organs[1]
				user.vore_selected = user.vore_organs[1]

	if(href_list["saveprefs"])
		if(user.save_vore_prefs())
			to_chat(user, "<span class='notice'>Belly Preferences saved!</span>")

		else
			to_chat(user, "<span class='warning'>ERROR: Belly Preferences were not saved!</span>")
			log_admin("Could not save vore prefs on USER: [user].")


	if(href_list["toggledg"])
		var/choice = alert(user, "This button is for those who don't like being digested. It can make you undigestable to all mobs. Digesting you is currently: [user.digestable ? "Allowed" : "Prevented"]", "", "Allow Digestion", "Cancel", "Prevent Digestion")
		switch(choice)
			if("Cancel")
				return 1
			if("Allow Digestion")
				user.digestable = TRUE
			if("Prevent Digestion")
				user.digestable = FALSE

		if(user.client.prefs_vr)
			user.client.prefs_vr.digestable = user.digestable

	if(href_list["toggledvor"])
		var/choice = alert(user, "This button is for those who don't like vore at all. Devouring you is currently: [user.devourable ? "Allowed" : "Prevented"]", "", "Allow Devourment", "Cancel", "Prevent Devourment")
		switch(choice)
			if("Cancel")
				return 1
			if("Allow Devourment")
				user.devourable = TRUE
			if("Prevent Devourment")
				user.devourable = FALSE

		if(user.client.prefs_vr)
			user.client.prefs_vr.devourable = user.devourable

	//Refresh when interacted with, returning 1 makes vore_look.Topic update
	return 1
