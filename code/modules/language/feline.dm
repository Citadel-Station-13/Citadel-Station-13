
/datum/language/feline
	name = "Cat Chatter"
	desc = "A language involving a lot of ear flicks, tail wiggling and long penatrating stares"
	speech_verb = "mews"
	ask_verb = "purrs"
	exclaim_verb = "mrowls"
	whisper_verb = "chirps"

	signlang_verb = list("signs", "gestures")

	key = "F"

	default_priority = 0          // the language that an atom knows with the highest "default_priority" is selected by default.

	icon = 'icons/misc/language.dmi'
	icon_state = "feline"

	flags = TONGUELESS_SPEECH


	syllables = list(
	"mow", "mar", "mer", "muh", "mew", "mur", "mie", "mph",
	"cha", "chy", "choh", "char", "chur", "caou", "cou", "cur", "cee",
	"bah", "bha", "bhe", "broh", "bee", "bouh", "boo", "bop", "birr", "borr", "burr",
	"ahh", "arr", "aow", "air", "aogh", "arp", "awo", "aff",
	"err", "eap",
	"who" )

	sentence_chance = 5      // Likelihood of making a new sentence after each syllable.
	space_chance = 55        // Likelihood of getting a space in the random scramble string
