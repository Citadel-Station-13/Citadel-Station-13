

//Keeps track of the time for the ID console. Having it as a global variable prevents people from dismantling/reassembling it to
//increase the slots of many jobs.
GLOBAL_VAR_INIT(time_last_changed_position, 0)

/obj/machinery/computer/card
	name = "identification console"
	desc = "You can use this to manage jobs and ID access."
	icon_screen = "id"
	icon_keyboard = "id_key"
	req_one_access = list(ACCESS_HEADS, ACCESS_CHANGE_IDS)
	circuit = /obj/item/circuitboard/computer/card
	var/mode = 0
	var/printing = null
	var/target_dept = 0 //Which department this computer has access to. 0=all departments

	//Cooldown for closing positions in seconds
	//if set to -1: No cooldown... probably a bad idea
	//if set to 0: Not able to close "original" positions. You can only close positions that you have opened before
	var/change_position_cooldown = 30
	//Jobs you cannot open new positions for
	var/list/blacklisted = list(
		"AI",
		"Assistant",
		"Cyborg",
		"Captain",
		"Head of Personnel",
		"Head of Security",
		"Chief Engineer",
		"Research Director",
		"Chief Medical Officer")

	//The scaling factor of max total positions in relation to the total amount of people on board the station in %
	var/max_relative_positions = 30 //30%: Seems reasonable, limit of 6 @ 20 players

	//This is used to keep track of opened positions for jobs to allow instant closing
	//Assoc array: "JobName" = (int)<Opened Positions>
	var/list/opened_positions = list()
	var/obj/item/card/id/inserted_scan_id
	var/obj/item/card/id/inserted_modify_id
	var/list/region_access = null
	var/list/head_subordinates = null

	light_color = LIGHT_COLOR_BLUE

/obj/machinery/computer/card/examine(mob/user)
	..()
	if(inserted_scan_id || inserted_modify_id)
		to_chat(user, "<span class='notice'>Alt-click to eject the ID card.</span>")

/obj/machinery/computer/card/Initialize()
	. = ..()
	change_position_cooldown = CONFIG_GET(number/id_console_jobslot_delay)

/obj/machinery/computer/card/examine(mob/user)
	. = ..()
	if(inserted_scan_id || inserted_modify_id)
		to_chat(user, "<span class='notice'>Alt-click to eject the ID card.</span>")

/obj/machinery/computer/card/attackby(obj/I, mob/user, params)
	if(istype(I, /obj/item/card/id))
		if(!inserted_scan_id)
			if(id_insert(user, I, inserted_scan_id))
				inserted_scan_id = I
				return
		if(!inserted_modify_id)
			if(id_insert(user, I, inserted_modify_id))
				inserted_modify_id = I
				return
		else
			to_chat(user, "<span class='warning'>There's already an ID card in the console!</span>")
	else
		return ..()

/obj/machinery/computer/card/Destroy()
	if(inserted_scan_id)
		qdel(inserted_scan_id)
		inserted_scan_id = null
	if(inserted_modify_id)
		qdel(inserted_modify_id)
		inserted_modify_id = null
	return ..()

/obj/machinery/computer/card/handle_atom_del(atom/A)
	..()
	if(A == inserted_scan_id)
		inserted_scan_id = null
		updateUsrDialog()
	if(A == inserted_modify_id)
		inserted_modify_id = null
		updateUsrDialog()

/obj/machinery/computer/card/on_deconstruction()
	if(inserted_scan_id)
		inserted_scan_id.forceMove(drop_location())
		inserted_scan_id = null
	if(inserted_modify_id)
		inserted_modify_id.forceMove(drop_location())
		inserted_modify_id = null

//Check if you can't open a new position for a certain job
/obj/machinery/computer/card/proc/job_blacklisted(jobtitle)
	return (jobtitle in blacklisted)


//Logic check for Topic() if you can open the job
/obj/machinery/computer/card/proc/can_open_job(datum/job/job)
	if(job)
		if(!job_blacklisted(job.title))
			if((job.total_positions <= GLOB.player_list.len * (max_relative_positions / 100)))
				var/delta = (world.time / 10) - GLOB.time_last_changed_position
				if((change_position_cooldown < delta) || (opened_positions[job.title] < 0))
					return 1
				return -2
			return -1
	return 0

//Logic check for Topic() if you can close the job
/obj/machinery/computer/card/proc/can_close_job(datum/job/job)
	if(job)
		if(!job_blacklisted(job.title))
			if(job.total_positions > job.current_positions)
				var/delta = (world.time / 10) - GLOB.time_last_changed_position
				if((change_position_cooldown < delta) || (opened_positions[job.title] > 0))
					return 1
				return -2
			return -1
	return 0

/obj/machinery/computer/card/proc/id_insert(mob/user, obj/item/card/id/I, target)
	if(istype(I))
		if(target)
			to_chat(user, "<span class='warning'>There's already an ID card in the console!</span>")
			return FALSE
		if(!user.transferItemToLoc(I, src))
			return FALSE
		user.visible_message("<span class='notice'>[user] inserts an ID card into the console.</span>", \
							"<span class='notice'>You insert the ID card into the console.</span>")
		playsound(src, 'sound/machines/terminal_insert_disc.ogg', 50, FALSE)
		updateUsrDialog()
		return TRUE

/obj/machinery/computer/card/proc/id_eject(mob/user, obj/target)
	if(!target)
		to_chat(user, "<span class='warning'>There's no ID card in the console!</span>")
		return FALSE
	else
		target.forceMove(drop_location())
		if(!issilicon(user) && Adjacent(user))
			user.put_in_hands(target)
		user.visible_message("<span class='notice'>[user] gets an ID card from the console.</span>", \
							"<span class='notice'>You get the ID card from the console.</span>")
		playsound(src, 'sound/machines/terminal_insert_disc.ogg', 50, FALSE)
		updateUsrDialog()
		return TRUE

/obj/machinery/computer/card/AltClick(mob/user)
	..()
	if(!user.canUseTopic(src, !issilicon(user)) || !is_operational())
		return
	if(inserted_modify_id)
		if(id_eject(user, inserted_modify_id))
			inserted_modify_id = null
			authenticated = FALSE
			return
	if(inserted_scan_id)
		if(id_eject(user, inserted_scan_id))
			inserted_scan_id = null
			authenticated = FALSE
			return

/obj/machinery/computer/card/ui_interact(mob/user)
	. = ..()
	var/dat
	if(!SSticker)
		return
	if (mode == 1) // accessing crew manifest
		var/crew = ""
		for(var/datum/data/record/t in sortRecord(GLOB.data_core.general))
			crew += t.fields["name"] + " - " + t.fields["rank"] + "<br>"
		dat = "<tt><b>Crew Manifest:</b><br>Please use security record computer to modify entries.<br><br>[crew]<a href='?src=[REF(src)];choice=print'>Print</a><br><br><a href='?src=[REF(src)];choice=mode;mode_target=0'>Access ID modification console.</a><br></tt>"

	else if(mode == 2)
		// JOB MANAGEMENT
		dat = "<a href='?src=[REF(src)];choice=return'>Return</a>"
		dat += " || Confirm Identity: "
		var/S
		if(inserted_scan_id)
			S = html_encode(inserted_scan_id.name)
		else
			S = "--------"
		dat += "<a href='?src=[REF(src)];choice=inserted_scan_id'>[S]</a>"
		dat += "<table>"
		dat += "<tr><td style='width:25%'><b>Job</b></td><td style='width:25%'><b>Slots</b></td><td style='width:25%'><b>Open job</b></td><td style='width:25%'><b>Close job</b><td style='width:25%'><b>Prioritize</b></td></td></tr>"
		var/ID
		if(inserted_scan_id && (ACCESS_CHANGE_IDS in inserted_scan_id.access) && !target_dept)
			ID = 1
		else
			ID = 0
		for(var/datum/job/job in SSjob.occupations)
			dat += "<tr>"
			if(job.title in blacklisted)
				continue
			dat += "<td>[job.title]</td>"
			dat += "<td>[job.current_positions]/[job.total_positions]</td>"
			dat += "<td>"
			switch(can_open_job(job))
				if(1)
					if(ID)
						dat += "<a href='?src=[REF(src)];choice=make_job_available;job=[job.title]'>Open Position</a><br>"
					else
						dat += "Open Position"
				if(-1)
					dat += "Denied"
				if(-2)
					var/time_to_wait = round(change_position_cooldown - ((world.time / 10) - GLOB.time_last_changed_position), 1)
					var/mins = round(time_to_wait / 60)
					var/seconds = time_to_wait - (60*mins)
					dat += "Cooldown ongoing: [mins]:[(seconds < 10) ? "0[seconds]" : "[seconds]"]"
				if(0)
					dat += "Denied"
			dat += "</td><td>"
			switch(can_close_job(job))
				if(1)
					if(ID)
						dat += "<a href='?src=[REF(src)];choice=make_job_unavailable;job=[job.title]'>Close Position</a>"
					else
						dat += "Close Position"
				if(-1)
					dat += "Denied"
				if(-2)
					var/time_to_wait = round(change_position_cooldown - ((world.time / 10) - GLOB.time_last_changed_position), 1)
					var/mins = round(time_to_wait / 60)
					var/seconds = time_to_wait - (60*mins)
					dat += "Cooldown ongoing: [mins]:[(seconds < 10) ? "0[seconds]" : "[seconds]"]"
				if(0)
					dat += "Denied"
			dat += "</td><td>"
			switch(job.total_positions)
				if(0)
					dat += "Denied"
				else
					if(ID)
						if(job in SSjob.prioritized_jobs)
							dat += "<a href='?src=[REF(src)];choice=prioritize_job;job=[job.title]'>Deprioritize</a>"
						else
							if(SSjob.prioritized_jobs.len < 5)
								dat += "<a href='?src=[REF(src)];choice=prioritize_job;job=[job.title]'>Prioritize</a>"
							else
								dat += "Denied"
					else
						dat += "Prioritize"

			dat += "</td></tr>"
		dat += "</table>"
	else
		var/header = ""

		var/target_name
		var/target_owner
		var/target_rank
		if(inserted_modify_id)
			target_name = html_encode(inserted_modify_id.name)
		else
			target_name = "--------"
		if(inserted_modify_id && inserted_modify_id.registered_name)
			target_owner = html_encode(inserted_modify_id.registered_name)
		else
			target_owner = "--------"
		if(inserted_modify_id && inserted_modify_id.assignment)
			target_rank = html_encode(inserted_modify_id.assignment)
		else
			target_rank = "Unassigned"

		var/scan_name
		if(inserted_scan_id)
			scan_name = html_encode(inserted_scan_id.name)
		else
			scan_name = "--------"

		if(!authenticated)
			header += "<br><i>Please insert the cards into the slots</i><br>"
			header += "Target: <a href='?src=[REF(src)];choice=inserted_modify_id'>[target_name]</a><br>"
			header += "Confirm Identity: <a href='?src=[REF(src)];choice=inserted_scan_id'>[scan_name]</a><br>"
		else
			header += "<div align='center'><br>"
			header += "<a href='?src=[REF(src)];choice=inserted_modify_id'>Remove [target_name]</a> || "
			header += "<a href='?src=[REF(src)];choice=inserted_scan_id'>Remove [scan_name]</a> <br> "
			header += "<a href='?src=[REF(src)];choice=mode;mode_target=1'>Access Crew Manifest</a> <br> "
			header += "<a href='?src=[REF(src)];choice=logout'>Log Out</a></div>"

		header += "<hr>"

		var/jobs_all = ""
		var/list/alljobs = list("Unassigned")
		alljobs += (istype(src, /obj/machinery/computer/card/centcom)? get_all_centcom_jobs() : get_all_jobs()) + "Custom"
		for(var/job in alljobs)
			jobs_all += "<a href='?src=[REF(src)];choice=assign;assign_target=[job]'>[replacetext(job, " ", "&nbsp")]</a> " //make sure there isn't a line break in the middle of a job


		var/body

		if (authenticated && inserted_modify_id)

			var/carddesc = text("")
			var/jobs = text("")
			if( authenticated == 2)
				carddesc += {"<script type="text/javascript">
									function markRed(){
										var nameField = document.getElementById('namefield');
										nameField.style.backgroundColor = "#FFDDDD";
									}
									function markGreen(){
										var nameField = document.getElementById('namefield');
										nameField.style.backgroundColor = "#DDFFDD";
									}
									function showAll(){
										var allJobsSlot = document.getElementById('alljobsslot');
										allJobsSlot.innerHTML = "<a href='#' onclick='hideAll()'>hide</a><br>"+ "[jobs_all]";
									}
									function hideAll(){
										var allJobsSlot = document.getElementById('alljobsslot');
										allJobsSlot.innerHTML = "<a href='#' onclick='showAll()'>show</a>";
									}
								</script>"}
				carddesc += "<form name='cardcomp' action='?src=[REF(src)]' method='get'>"
				carddesc += "<input type='hidden' name='src' value='[REF(src)]'>"
				carddesc += "<input type='hidden' name='choice' value='reg'>"
				carddesc += "<b>registered name:</b> <input type='text' id='namefield' name='reg' value='[target_owner]' style='width:250px; background-color:white;' onchange='markRed()'>"
				carddesc += "<input type='submit' value='Rename' onclick='markGreen()'>"
				carddesc += "</form>"
				carddesc += "<b>Assignment:</b> "

				jobs += "<span id='alljobsslot'><a href='#' onclick='showAll()'>[target_rank]</a></span>" //CHECK THIS

			else
				carddesc += "<b>registered_name:</b> [target_owner]</span>"
				jobs += "<b>Assignment:</b> [target_rank] (<a href='?src=[REF(src)];choice=demote'>Demote</a>)</span>"

			var/accesses = ""
			if(istype(src, /obj/machinery/computer/card/centcom))
				accesses += "<h5>Central Command:</h5>"
				for(var/A in get_all_centcom_access())
					if(A in inserted_modify_id.access)
						accesses += "<a href='?src=[REF(src)];choice=access;access_target=[A];allowed=0'><font color=\"red\">[replacetext(get_centcom_access_desc(A), " ", "&nbsp")]</font></a> "
					else
						accesses += "<a href='?src=[REF(src)];choice=access;access_target=[A];allowed=1'>[replacetext(get_centcom_access_desc(A), " ", "&nbsp")]</a> "
			else
				accesses += "<div align='center'><b>Access</b></div>"
				accesses += "<table style='width:100%'>"
				accesses += "<tr>"
				for(var/i = 1; i <= 7; i++)
					if(authenticated == 1 && !(i in region_access))
						continue
					accesses += "<td style='width:14%'><b>[get_region_accesses_name(i)]:</b></td>"
				accesses += "</tr><tr>"
				for(var/i = 1; i <= 7; i++)
					if(authenticated == 1 && !(i in region_access))
						continue
					accesses += "<td style='width:14%' valign='top'>"
					for(var/A in get_region_accesses(i))
						if(A in inserted_modify_id.access)
							accesses += "<a href='?src=[REF(src)];choice=access;access_target=[A];allowed=0'><font color=\"red\">[replacetext(get_access_desc(A), " ", "&nbsp")]</font></a> "
						else
							accesses += "<a href='?src=[REF(src)];choice=access;access_target=[A];allowed=1'>[replacetext(get_access_desc(A), " ", "&nbsp")]</a> "
						accesses += "<br>"
					accesses += "</td>"
				accesses += "</tr></table>"
			body = "[carddesc]<br>[jobs]<br><br>[accesses]" //CHECK THIS

		else
			body = "<a href='?src=[REF(src)];choice=auth'>{Log in}</a> <br><hr>"
			body += "<a href='?src=[REF(src)];choice=mode;mode_target=1'>Access Crew Manifest</a>"
			if(!target_dept)
				body += "<br><hr><a href = '?src=[REF(src)];choice=mode;mode_target=2'>Job Management</a>"

		dat = "<tt>[header][body]<hr><br></tt>"
	var/datum/browser/popup = new(user, "id_com", src.name, 900, 620)
	popup.set_content(dat)
	popup.set_title_image(user.browse_rsc_icon(src.icon, src.icon_state))
	popup.open()

/obj/machinery/computer/card/Topic(href, href_list)
	if(..())
		return

	if(!usr.canUseTopic(src, !issilicon(usr)) || !is_operational())
		usr.unset_machine()
		usr << browse(null, "window=id_com")
		return

	usr.set_machine(src)
	switch(href_list["choice"])
		if ("inserted_modify_id")
			if (inserted_modify_id)
				if(id_eject(usr, inserted_modify_id))
					inserted_modify_id = null
			else
				var/mob/M = usr
				var/obj/item/card/id/I = M.get_idcard(TRUE)
				if(id_insert(usr, I, inserted_modify_id))
					inserted_modify_id = I
		if ("inserted_scan_id")
			if (inserted_scan_id)
				if(id_eject(usr, inserted_scan_id))
					inserted_scan_id = null
			else
				var/mob/M = usr
				var/obj/item/card/id/I = M.get_idcard(TRUE)
				if(id_insert(usr, I, inserted_scan_id))
					inserted_scan_id = I
		if ("auth")
			if ((!( authenticated ) && (inserted_scan_id || issilicon(usr)) && (inserted_modify_id || mode)))
				if (check_access(inserted_scan_id))
					region_access = list()
					head_subordinates = list()
					if(ACCESS_CHANGE_IDS in inserted_scan_id.access)
						if(target_dept)
							head_subordinates = get_all_jobs()
							region_access |= target_dept
							authenticated = 1
						else
							authenticated = 2
						playsound(src, 'sound/machines/terminal_on.ogg', 50, FALSE)

					else
						if((ACCESS_HOP in inserted_scan_id.access) && ((target_dept==1) || !target_dept))
							region_access |= 1
							get_subordinates("Head of Personnel")
						if((ACCESS_HOS in inserted_scan_id.access) && ((target_dept==2) || !target_dept))
							region_access |= 2
							get_subordinates("Head of Security")
						if((ACCESS_CMO in inserted_scan_id.access) && ((target_dept==3) || !target_dept))
							region_access |= 3
							get_subordinates("Chief Medical Officer")
						if((ACCESS_RD in inserted_scan_id.access) && ((target_dept==4) || !target_dept))
							region_access |= 4
							get_subordinates("Research Director")
						if((ACCESS_CE in inserted_scan_id.access) && ((target_dept==5) || !target_dept))
							region_access |= 5
							get_subordinates("Chief Engineer")
						if((ACCESS_QM in inserted_scan_id.access) && ((target_dept==6) || !target_dept))
							region_access |= 6
							get_subordinates("Quartermaster")
						if(region_access)
							authenticated = 1
			else if ((!( authenticated ) && issilicon(usr)) && (!inserted_modify_id))
				to_chat(usr, "<span class='warning'>You can't modify an ID without an ID inserted to modify! Once one is in the modify slot on the computer, you can log in.</span>")
		if ("logout")
			region_access = null
			head_subordinates = null
			authenticated = 0
			playsound(src, 'sound/machines/terminal_off.ogg', 50, FALSE)

		if("access")
			if(href_list["allowed"])
				if(authenticated)
					var/access_type = text2num(href_list["access_target"])
					var/access_allowed = text2num(href_list["allowed"])
					if(access_type in (istype(src, /obj/machinery/computer/card/centcom)?get_all_centcom_access() : get_all_accesses()))
						inserted_modify_id.access -= access_type
						if(access_allowed == 1)
							inserted_modify_id.access += access_type
						playsound(src, "terminal_type", 50, FALSE)
		if ("assign")
			if (authenticated == 2)
				var/t1 = href_list["assign_target"]
				if(t1 == "Custom")
					var/newJob = reject_bad_text(input("Enter a custom job assignment.", "Assignment", inserted_modify_id ? inserted_modify_id.assignment : "Unassigned"), MAX_NAME_LEN)
					if(newJob)
						t1 = newJob

				else if(t1 == "Unassigned")
					inserted_modify_id.access -= get_all_accesses()

				else
					var/datum/job/jobdatum
					for(var/jobtype in typesof(/datum/job))
						var/datum/job/J = new jobtype
						if(ckey(J.title) == ckey(t1))
							jobdatum = J
							updateUsrDialog()
							break
					if(!jobdatum)
						to_chat(usr, "<span class='error'>No log exists for this job.</span>")
						updateUsrDialog()
						return

					inserted_modify_id.access = ( istype(src, /obj/machinery/computer/card/centcom) ? get_centcom_access(t1) : jobdatum.get_access() )
				if (inserted_modify_id)
					inserted_modify_id.assignment = t1
					playsound(src, 'sound/machines/terminal_prompt_confirm.ogg', 50, FALSE)
		if ("demote")
			if(inserted_modify_id.assignment in head_subordinates || inserted_modify_id.assignment == "Assistant")
				inserted_modify_id.assignment = "Unassigned"
				playsound(src, 'sound/machines/terminal_prompt_confirm.ogg', 50, FALSE)
			else
				to_chat(usr, "<span class='error'>You are not authorized to demote this position.</span>")
		if ("reg")
			if (authenticated)
				var/t2 = inserted_modify_id
				if ((authenticated && inserted_modify_id == t2 && (in_range(src, usr) || issilicon(usr)) && isturf(loc)))
					var/newName = reject_bad_name(href_list["reg"])
					if(newName)
						inserted_modify_id.registered_name = newName
						playsound(src, 'sound/machines/terminal_prompt_confirm.ogg', 50, FALSE)
					else
						to_chat(usr, "<span class='error'>Invalid name entered.</span>")
						updateUsrDialog()
						return
		if ("mode")
			mode = text2num(href_list["mode_target"])

		if("return")
			//DISPLAY MAIN MENU
			mode = 3;
			playsound(src, "terminal_type", 25, FALSE)

		if("make_job_available")
			// MAKE ANOTHER JOB POSITION AVAILABLE FOR LATE JOINERS
			if(inserted_scan_id && (ACCESS_CHANGE_IDS in inserted_scan_id.access) && !target_dept)
				var/edit_job_target = href_list["job"]
				var/datum/job/j = SSjob.GetJob(edit_job_target)
				if(!j)
					updateUsrDialog()
					return 0
				if(can_open_job(j) != 1)
					updateUsrDialog()
					return 0
				if(opened_positions[edit_job_target] >= 0)
					GLOB.time_last_changed_position = world.time / 10
				j.total_positions++
				opened_positions[edit_job_target]++
				playsound(src, 'sound/machines/terminal_prompt_confirm.ogg', 50, FALSE)

		if("make_job_unavailable")
			// MAKE JOB POSITION UNAVAILABLE FOR LATE JOINERS
			if(inserted_scan_id && (ACCESS_CHANGE_IDS in inserted_scan_id.access) && !target_dept)
				var/edit_job_target = href_list["job"]
				var/datum/job/j = SSjob.GetJob(edit_job_target)
				if(!j)
					updateUsrDialog()
					return 0
				if(can_close_job(j) != 1)
					updateUsrDialog()
					return 0
				//Allow instant closing without cooldown if a position has been opened before
				if(opened_positions[edit_job_target] <= 0)
					GLOB.time_last_changed_position = world.time / 10
				j.total_positions--
				opened_positions[edit_job_target]--
				playsound(src, 'sound/machines/terminal_prompt_deny.ogg', 50, FALSE)

		if ("prioritize_job")
			// TOGGLE WHETHER JOB APPEARS AS PRIORITIZED IN THE LOBBY
			if(inserted_scan_id && (ACCESS_CHANGE_IDS in inserted_scan_id.access) && !target_dept)
				var/priority_target = href_list["job"]
				var/datum/job/j = SSjob.GetJob(priority_target)
				if(!j)
					updateUsrDialog()
					return 0
				var/priority = TRUE
				if(j in SSjob.prioritized_jobs)
					SSjob.prioritized_jobs -= j
					priority = FALSE
				else if(j.total_positions <= j.current_positions)
					to_chat(usr, "<span class='notice'>[j.title] has had all positions filled. Open up more slots before prioritizing it.</span>")
					updateUsrDialog()
					return
				else
					SSjob.prioritized_jobs += j
				to_chat(usr, "<span class='notice'>[j.title] has been successfully [priority ?  "prioritized" : "unprioritized"]. Potential employees will notice your request.</span>")
				playsound(src, 'sound/machines/terminal_prompt_confirm.ogg', 50, FALSE)

		if ("print")
			if (!( printing ))
				printing = 1
				sleep(50)
				var/obj/item/paper/P = new /obj/item/paper( loc )
				var/t1 = "<B>Crew Manifest:</B><BR>"
				for(var/datum/data/record/t in sortRecord(GLOB.data_core.general))
					t1 += t.fields["name"] + " - " + t.fields["rank"] + "<br>"
				P.info = t1
				P.name = "paper- 'Crew Manifest'"
				printing = null
				playsound(src, 'sound/machines/terminal_insert_disc.ogg', 50, FALSE)
	if (inserted_modify_id)
		inserted_modify_id.update_label()
	updateUsrDialog()

/obj/machinery/computer/card/proc/get_subordinates(rank)
	for(var/datum/job/job in SSjob.occupations)
		if(rank in job.department_head)
			head_subordinates += job.title

/obj/machinery/computer/card/centcom
	name = "\improper CentCom identification console"
	circuit = /obj/item/circuitboard/computer/card/centcom
	req_access = list(ACCESS_CENT_CAPTAIN)

/obj/machinery/computer/card/minor
	name = "department management console"
	desc = "You can use this to change ID's for specific departments."
	icon_screen = "idminor"
	circuit = /obj/item/circuitboard/computer/card/minor

/obj/machinery/computer/card/minor/Initialize()
	. = ..()
	var/obj/item/circuitboard/computer/card/minor/typed_circuit = circuit
	if(target_dept)
		typed_circuit.target_dept = target_dept
	else
		target_dept = typed_circuit.target_dept
	var/list/dept_list = list("civilian","security","medical","science","engineering","cargo")
	name = "[dept_list[target_dept]] department console"

/obj/machinery/computer/card/minor/hos
	target_dept = 2
	icon_screen = "idhos"

	light_color = LIGHT_COLOR_RED

/obj/machinery/computer/card/minor/cmo
	target_dept = 3
	icon_screen = "idcmo"

/obj/machinery/computer/card/minor/rd
	target_dept = 4
	icon_screen = "idrd"

	light_color = LIGHT_COLOR_PINK

/obj/machinery/computer/card/minor/ce
	target_dept = 5
	icon_screen = "idce"

	light_color = LIGHT_COLOR_YELLOW

/obj/machinery/computer/card/minor/qm
	target_dept = 6
	icon_screen = "idqm"

	light_color = LIGHT_COLOR_ORANGE