/datum/antagonist/graffiti_artist
	name = "Graffiti Artist"
	antagpanel_category = "Graffiti Artist"
	job_rank = ROLE_GRAFFITI_ARTIST
	show_name_in_check_antagonists = TRUE
	show_to_ghosts = TRUE
	threat = 8

	var/paint_amount = 100
	var/maximum_paint = 100
	var/paint_recharge_rate = 3
	var/obj/effect/proc_holder/spell/targeted/conjure_item/spraycan/conjure_spraycan

/datum/antagonist/graffiti_artist/on_gain()
	forge_objectives()
	. = ..()

/datum/antagonist/graffiti_artist/on_removal()
	if(special_spraycan)
		qdel(special_spraycan)
	. = ..()

/datum/antagonist/graffiti_artist/proc/forge_objectives()
	var/datum/objective/vandalize_objective = new("Vandalize the station with your art.")
	vandalize_objective.owner = owner
	objectives += vandalize_objective

	var/datum/objective/art_objective = new("Leave some crew alive to appreciate your art so that the Wizard Federation's art department can return to its former glory.")
	art_objective.owner = owner
	objectives += art_objective

	var/datum/objective/escape/escape_objective = new
	escape_objective.owner = owner
	objectives += escape_objective

/datum/antagonist/graffiti_artist/greet()
	to_chat(owner, "<span class='boldannounce'>The Wizard Federation's art department has assigned you the mission of vandalizing this station. You have been kitted with a standard issue Wizard Federation spraycan.</span>")

	owner.announce_objectives()

// actual effects
/datum/antagonist/graffiti_artist/apply_innate_effects()
	RegisterSignal(owner.current,COMSIG_LIVING_BIOLOGICAL_LIFE,.proc/on_antag_process)
	owner.current.hud_used?.lingchemdisplay?.icon_state = "paint_display"
	conjure_spraycan = new
	owner.current.AddSpell(conjure_spraycan)
	. = ..()

/datum/antagonist/graffiti_artist/remove_innate_effects()
	UnregisterSignal(owner.current,COMSIG_LIVING_BIOLOGICAL_LIFE)
	owner.current.hud_used?.lingchemdisplay?.icon_state = "power_display"
	owner.current.RemoveSpell(conjure_spraycan)
	. = ..()

/datum/antagonist/graffiti_artist/proc/on_antag_process()
	paint_amount = min(paint_amount + paint_recharge_rate, maximum_paint)
	update_hud()

/datum/antagonist/graffiti_artist/proc/update_hud()
	owner.current.hud_used?.lingchemdisplay?.invisibility = 0
	owner.current.hud_used?.lingchemdisplay?.maptext = "<div align='center' valign='middle' style='position:relative; top:0px; left:6px'><font color='#ffffff'>[round(paint_amount)]</font></div>"
