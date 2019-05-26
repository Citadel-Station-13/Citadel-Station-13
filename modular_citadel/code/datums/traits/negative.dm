// Citadel-specific Negative Traits

//For reviewers: If you think it's a bad idea, feel free to remove it. I won't be upset :blobcat:
/datum/quirk/Hypno
	name = "Hypnotherapy user"
	desc = "You had hypnotherapy right before your shift, you're not sure it had any effects, though."
	mob_trait = "hypnotherapy"
	value = -1 //I mean, it can be a really bad trait to have, but on the other hand, some people want it?
	gain_text = "<span class='notice'>You really think the hypnotherapy helped you out.</span>"
	//lose_text = "<span class='notice'>You forget about the hypnotherapy you had, or did you even have it?</span>"

/datum/quirk/Hypno/add()
   //You caught me, it's not actually based off a trigger, stop spoiling the effect! Code diving ruins the magic!
   addtimer(CALLBACK(src, /datum/quirk/Hypno.proc/triggered, quirk_holder), rand(12000, 36000))//increase by 100, it's lower so I can test it.

//DOES NOT give any indication when someone is triggered - this is intentional so people don't abuse it, you're supposed to get a random thing said to you as a mini objective.
/datum/quirk/Hypno/proc/triggered(quirk_holder)//I figured I might as well make a trait of code I added.
   var/mob/living/carbon/human/H = quirk_holder
   var/list/seen = viewers(8, get_turf(H))
   seen -= quirk_holder
   if(LAZYLEN(seen) == 0)
      to_chat(H, "<span class='notice'><i>That object accidentally sets off your implanted trigger, sending you into a hypnotic daze!</i></span>")
   else
      to_chat(H, "<span class='notice'><i>[pick(seen)] accidentally sets off your implanted trigger, sending you into a hypnotic daze!</i></span>")
   H.apply_status_effect(/datum/status_effect/trance, 200, TRUE)
   message_admins("Trance applied")
   qdel(src)
