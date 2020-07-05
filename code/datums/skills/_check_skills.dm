// yeah yeah verbs suck whatever I suck at this fix this someone please - kevinz000

/mob/verb/check_skills()
	set name = "Check Skills"
	set category = "IC"
	set desc = "Check your skills (if you have any..)"

	if(!mind)
		to_chat(usr, "<span class='warning'>How do you check the skills of [(usr == src)? "yourself when you are" : "something"] without a mind?</span>")
		return
	if(!mind.skill_holder)
		to_chat(usr, "<span class='warning'>How do you check the skills of [(usr == src)? "yourself when you are" : "something"] without the capability for skills? (PROBABLY A BUG, PRESS F1.)</span>")
		return
	var/datum/browser/B = new(usr, "skilldisplay_[REF(src)]", "Skills of [src]")
	B.set_content(mind.skill_html_readout())
	B.open()
