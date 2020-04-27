// The language of the vinebings. Yes, it's a shameless ripoff of elvish.
/datum/language/sylvan
	name = "Sylvan"
	desc = "A complicated, ancient language spoken by vine like beings."
	speech_verb = "expresses"
	ask_verb = "inquires"
	exclaim_verb = "declares"
	key = "h"
	space_chance = 20
	syllables = list(
		"fii", "sii", "rii", "rel", "maa", "ala", "san", "tol", "tok", "dia", "eres",
    	"fal", "tis", "bis", "qel", "aras", "losk", "rasa", "eob", "hil", "tanl", "aere",
    	"fer", "bal", "pii", "dala", "ban", "foe", "doa", "cii", "uis", "mel", "wex",
    	"incas", "int", "elc", "ent", "aws", "qip", "nas", "vil", "jens", "dila", "fa",
    	"la", "re", "do", "ji", "ae", "so", "qe", "ce", "na", "mo", "ha", "yu"
	)
	icon = 'icons/obj/hydroponics/harvest.dmi'
	icon_state = "lily"
	default_priority = 90

/datum/language_holder/venus
	languages = list(/datum/language/common, /datum/language/sylvan, /datum/language/machine)
	only_speaks_language = /datum/language/sylvan
