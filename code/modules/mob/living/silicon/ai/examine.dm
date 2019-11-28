/mob/living/silicon/ai/examine(mob/user)
	. = list("<span class='info'>*---------*\nThis is [icon2html(src, user)] <EM>[src]</EM>!")
	if (stat == DEAD)
		. += "<span class='deadsay'>It appears to be powered-down.</span>"
	else
		. += "<span class='warning'>"
		if (getBruteLoss())
			if (getBruteLoss() < 30)
				. += "It looks slightly dented."
			else
				. += "<B>It looks severely dented!</B>"
		if (getFireLoss())
			if (getFireLoss() < 30)
				. += "It looks slightly charred."
			else
				. += "<B>Its casing is melted and heat-warped!</B>"
		. += "</span>"
		if(deployed_shell)
			. += "The wireless networking light is blinking."
		else if (!shunted && !client)
			. += "[src]Core.exe has stopped responding! NTOS is searching for a solution to the problem..."
	. += "*---------*</span>"

	. += ..()