/mob/living/silicon/ai/examine(mob/user)
	. = list("<span class='info'>This is [icon2html(src, user)] <EM>[src]</EM>!")
	if (stat == DEAD)
		. += "<span class='deadsay'>It appears to be powered-down.</span>"
	else
		if (getBruteLoss())
			if (getBruteLoss() < 30)
				. += "<span class='warning'>It looks slightly dented.</span>"
			else
				. += "<span class='danger'>It looks severely dented!</span>"
		if (getFireLoss())
			if (getFireLoss() < 30)
				. += "<span class='warning'>It looks slightly charred.</span>"
			else
				. += "<span class='danger'>Its casing is melted and heat-warped!</span>"
		if(deployed_shell)
			. += "The wireless networking light is blinking."
		else if (!shunted && !client)
			. += "[src]Core.exe has stopped responding! NTOS is searching for a solution to the problem..."

	if(LAZYLEN(.) > 1)
		.[2] = "<hr>[.[2]]"

	. += ..()
