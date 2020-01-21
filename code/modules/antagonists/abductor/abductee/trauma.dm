/datum/brain_trauma/abductee
	name = "abductee mindsnapped"
	desc = "The patient's brain has been scrambled by experimental procedures."
	scan_desc = "brain scrambling"
	gain_text = "<span class='danger'>Your mind snaps.. you feel fragmented.</span>"
	lose_text = "<span class='boldnotice'>Your mind heals itself and you feel whole again.</span>"
	random_gain = FALSE
	clonable = TRUE

/datum/brain_trauma/abductee/on_gain()
	if(!owner.has_antag_datum(/datum/antagonist/abductee))
		owner.add_antag_datum(/datum/antagonist/abductee)

/datum/brain_trauma/abductee/on_lose()
	owner.remove_antag_datum(/datum/antagonist/abductee)
