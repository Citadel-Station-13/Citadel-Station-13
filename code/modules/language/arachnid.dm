/datum/language/arachnid
	name = "Rachnidian"
	desc = "A language that exploits the multiple limbs of arachnids to do subtle dance like movements to communicate.\
	A proper speaker's movements are quick and sharp enough to make audible whiffs and thumps however, which are intelligible over the radio."
	speech_verb = "chitter"
	ask_verb = "chitter"
	exclaim_verb = "chitter"
	key = "r"
	flags = NO_STUTTER | LANGUAGE_HIDE_ICON_IF_NOT_UNDERSTOOD

	icon_state = "arachnid"
	chooseable_roundstart = TRUE

/datum/language/arachnid/scramble(input)
	. = prob(65) ? "<i>wiff</i>" : "<i>thump</i>"
	. += (copytext(input, length(input)) == "?") ? "?" : "!"
