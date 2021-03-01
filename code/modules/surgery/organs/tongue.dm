#define TONGUE_MAX_HEALTH 60

/obj/item/organ/tongue
	name = "tongue"
	desc = "A fleshy muscle mostly used for lying."
	icon_state = "tonguenormal"
	zone = BODY_ZONE_PRECISE_MOUTH
	slot = ORGAN_SLOT_TONGUE
	attack_verb = list("licked", "slobbered", "slapped", "frenched", "tongued")
	var/list/languages_possible
	var/say_mod = null
	var/taste_sensitivity = 15 // lower is more sensitive.
	maxHealth = TONGUE_MAX_HEALTH
	var/list/initial_accents //the ones the tongue starts with, not what it currently has
	var/list/accents = list() //done in order of priority (please always apply abductor accent and stuttering last)
	var/static/list/languages_possible_base = typecacheof(list(
		/datum/language/common,
		/datum/language/draconic,
		/datum/language/codespeak,
		/datum/language/monkey,
		/datum/language/narsie,
		/datum/language/beachbum,
		/datum/language/ratvar,
		/datum/language/aphasia,
		/datum/language/slime,
		/datum/language/vampiric,
		/datum/language/dwarf,
		/datum/language/signlanguage,
	))
	healing_factor = STANDARD_ORGAN_HEALING*5 //Fast!!
	decay_factor = STANDARD_ORGAN_DECAY/2

/obj/item/organ/tongue/Initialize(mapload)
	. = ..()
	for(var/accent in initial_accents)
		accents += new accent
	low_threshold_passed = "<span class='info'>Your [name] feels a little sore.</span>"
	low_threshold_cleared = "<span class='info'>Your [name] soreness has subsided.</span>"
	high_threshold_passed = "<span class='warning'>Your [name] is really starting to hurt.</span>"
	high_threshold_cleared = "<span class='info'>The pain of your [name] has subsided a little.</span>"
	now_failing = "<span class='warning'>Your [name] feels like it's about to fall out!.</span>"
	now_fixed = "<span class='info'>The excruciating pain of your [name] has subsided.</span>"
	languages_possible = languages_possible_base

/obj/item/organ/tongue/proc/handle_speech(datum/source, list/speech_args) //this wont proc unless there's initial_accents on the tongue
	for(var/datum/accent/speech_modifier in accents)
		speech_args = speech_modifier.modify_speech(speech_args, source, owner)

/obj/item/organ/tongue/applyOrganDamage(d, maximum = maxHealth)
	. = ..()
	if(damage >= maxHealth)
		to_chat(owner, "<span class='userdanger'>Your tongue is singed beyond recognition, and disintegrates!</span>")
		SSblackbox.record_feedback("tally", "fermi_chem", 1, "Tongues lost to Fermi")
		qdel(src)

/obj/item/organ/tongue/Insert(mob/living/carbon/M, special = 0, drop_if_replaced = TRUE)
	..()
	if(say_mod && M.dna && M.dna.species)
		M.dna.species.say_mod = say_mod
	if(length(initial_accents) || length(accents))
		RegisterSignal(M, COMSIG_MOB_SAY, .proc/handle_speech)
	M.UnregisterSignal(M, COMSIG_MOB_SAY)

/obj/item/organ/tongue/Remove(special = FALSE)
	if(!QDELETED(owner))
		if(say_mod && owner.dna?.species)
			owner.dna.species.say_mod = initial(owner.dna.species.say_mod)
		UnregisterSignal(owner, COMSIG_MOB_SAY, .proc/handle_speech)
		owner.RegisterSignal(owner, COMSIG_MOB_SAY, /mob/living/carbon/.proc/handle_tongueless_speech)
	return ..()

/obj/item/organ/tongue/could_speak_language(language)
	return is_type_in_typecache(language, languages_possible)

/obj/item/organ/tongue/lizard
	name = "forked tongue"
	desc = "A thin and long muscle typically found in reptilian races, apparently moonlights as a nose."
	icon_state = "tonguelizard"
	say_mod = "hisses"
	taste_sensitivity = 10 // combined nose + tongue, extra sensitive
	maxHealth = 40 //extra sensitivity means tongue is more susceptible to damage
	initial_accents = list(/datum/accent/lizard)

/obj/item/organ/tongue/fly
	name = "proboscis"
	desc = "A freakish looking meat tube that apparently can take in liquids."
	icon_state = "tonguefly"
	say_mod = "buzzes"
	taste_sensitivity = 25 // you eat vomit, this is a mercy
	maxHealth = 80 //years of eatting trash has made your tongue strong
	initial_accents = list(/datum/accent/fly)

/obj/item/organ/tongue/abductor
	name = "superlingual matrix"
	desc = "A mysterious structure that allows for instant communication between users. Pretty impressive until you need to eat something."
	icon_state = "tongueayylmao"
	say_mod = "gibbers"
	taste_sensitivity = 101 // ayys cannot taste anything.
	maxHealth = 120 //Ayys probe a lot
	initial_accents = list(/datum/accent/abductor)
	var/mothership

/obj/item/organ/tongue/abductor/attack_self(mob/living/carbon/human/H)
	if(!istype(H))
		return

	var/obj/item/organ/tongue/abductor/T = H.getorganslot(ORGAN_SLOT_TONGUE)
	if(!istype(T))
		return

	if(T.mothership == mothership)
		to_chat(H, "<span class='notice'>[src] is already attuned to the same channel as your own.</span>")
		return

	H.visible_message("<span class='notice'>[H] holds [src] in their hands, and concentrates for a moment.</span>", "<span class='notice'>You attempt to modify the attunation of [src].</span>")
	if(do_after(H, delay=15, target=src))
		to_chat(H, "<span class='notice'>You attune [src] to your own channel.</span>")
		mothership = T.mothership

/obj/item/organ/tongue/abductor/examine(mob/M)
	. = ..()
	if(HAS_TRAIT(M, TRAIT_ABDUCTOR_TRAINING) || HAS_TRAIT(M.mind, TRAIT_ABDUCTOR_TRAINING) || isobserver(M))
		if(!mothership)
			. += "<span class='notice'>It is not attuned to a specific mothership.</span>"
		else
			. += "<span class='notice'>It is attuned to [mothership].</span>"

/obj/item/organ/tongue/zombie
	name = "rotting tongue"
	desc = "Between the decay and the fact that it's just lying there you doubt a tongue has ever seemed less sexy."
	icon_state = "tonguezombie"
	say_mod = "moans"
	taste_sensitivity = 32
	maxHealth = 65 //Stop! It's already dead...!
	initial_accents = list(/datum/accent/zombie)

/obj/item/organ/tongue/alien
	name = "alien tongue"
	desc = "According to leading xenobiologists the evolutionary benefit of having a second mouth in your mouth is \"that it looks badass\"."
	icon_state = "tonguexeno"
	say_mod = "hisses"
	taste_sensitivity = 10 // LIZARDS ARE ALIENS CONFIRMED
	maxHealth = 500 //They've a little mouth for a tongue, so it's pretty rhobust
	initial_accents = list(/datum/accent/alien)
	var/static/list/languages_possible_alien = typecacheof(list(
		/datum/language/xenocommon,
		/datum/language/common,
		/datum/language/draconic,
		/datum/language/ratvar,
		/datum/language/monkey))

/obj/item/organ/tongue/alien/Initialize(mapload)
	. = ..()
	languages_possible = languages_possible_alien

/obj/item/organ/tongue/bone
	name = "bone \"tongue\""
	desc = "Apparently skeletons alter the sounds they produce through oscillation of their teeth, hence their characteristic rattling."
	icon_state = "tonguebone"
	say_mod = "rattles"
	organ_flags = ORGAN_NO_SPOIL
	attack_verb = list("bitten", "chattered", "chomped", "enamelled", "boned")
	taste_sensitivity = 101 // skeletons cannot taste anything
	maxHealth = 75 //Take brute damage instead
	var/chattering = FALSE
	var/phomeme_type = "sans"
	var/list/phomeme_types = list(/datum/accent/span/sans, /datum/accent/span/papyrus)

/obj/item/organ/tongue/bone/Initialize()
	initial_accents += pick(phomeme_types)
	. = ..()

/obj/item/organ/tongue/bone/applyOrganDamage(var/d, var/maximum = maxHealth)
	if(d < 0)
		return
	if(!owner)
		return
	var/target = owner.get_bodypart(BODY_ZONE_HEAD)
	owner.apply_damage(d, BURN, target)
	to_chat(owner, "<span class='userdanger'>You feel your skull burning! Oof, your bones!</span>")
	return

/obj/item/organ/tongue/bone/handle_speech(datum/source, list/speech_args)
	if(chattering)
		chatter(speech_args[SPEECH_MESSAGE], phomeme_type, source)
	..()

/obj/item/organ/tongue/bone/plasmaman
	name = "plasma bone \"tongue\""
	desc = "Like animated skeletons, Plasmamen vibrate their teeth in order to produce speech."
	icon_state = "tongueplasma"

/obj/item/organ/tongue/robot
	name = "robotic voicebox"
	desc = "A voice synthesizer that can interface with organic lifeforms."
	status = ORGAN_ROBOTIC
	organ_flags = ORGAN_NO_SPOIL
	icon_state = "tonguerobot"
	say_mod = "states"
	attack_verb = list("beeped", "booped")
	initial_accents = list(/datum/accent/span/robot)
	taste_sensitivity = 25 // not as good as an organic tongue
	maxHealth = 100 //RoboTongue!
	var/electronics_magic = TRUE

/obj/item/organ/tongue/robot/could_speak_language(language)
	return ..() || electronics_magic

/obj/item/organ/tongue/fluffy
	name = "fluffy tongue"
	desc = "OwO what's this?"
	icon_state = "tonguefluffy"
	taste_sensitivity = 10 // extra sensitive and inquisitive uwu
	maxHealth = 35 //Sensitive tongue!
	initial_accents = list(/datum/accent/fluffy)

/obj/item/organ/tongue/cybernetic
	name = "cybernetic tongue"
	desc = "A state of the art robotic tongue that can detect the pH of anything drank."
	icon_state = "tonguecybernetic"
	initial_accents = list(/datum/accent/span/robot)
	taste_sensitivity = 10
	maxHealth = 60 //It's robotic!
	organ_flags = ORGAN_SYNTHETIC

/obj/item/organ/tongue/cybernetic/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_SELF)
		return
	var/errormessage = list("Runtime in tongue.dm, line 39: Undefined operation \"zapzap ow my tongue\"", "afhsjifksahgjkaslfhashfjsak", "-1.#IND", "Graham's number", "inside you all along", "awaiting at least 1 approving review before merging this taste request")
	owner.say("The pH is appropriately [pick(errormessage)].", forced = "EMPed synthetic tongue")

/obj/item/organ/tongue/robot/ipc
	name = "positronic voicebox"
	say_mod = "beeps"
	desc = "A voice synthesizer used by IPCs to smoothly interface with organic lifeforms."
	electronics_magic = FALSE
	organ_flags = ORGAN_SYNTHETIC

/obj/item/organ/tongue/ethereal
	name = "electric discharger"
	desc = "A sophisticated ethereal organ, capable of synthesising speech via electrical discharge."
	icon_state = "electrotongue"
	say_mod = "crackles"
	attack_verb = list("shocked", "jolted", "zapped")
	taste_sensitivity = 101 // Not a tongue, they can't taste shit
	var/static/list/languages_possible_ethereal = typecacheof(list(
		/datum/language/common,
		/datum/language/draconic,
		/datum/language/codespeak,
		/datum/language/monkey,
		/datum/language/narsie,
		/datum/language/beachbum,
		/datum/language/aphasia,
		/datum/language/sylvan,
		/datum/language/voltaic
	))

/obj/item/organ/tongue/ethereal/Initialize(mapload)
	. = ..()
	languages_possible = languages_possible_ethereal

/obj/item/organ/tongue/arachnid
	name = "inner mandible"
	desc = "A set of soft, spoon-esque mandibles closer to the mouth opening, that allow for basic speech, and the ability to speak Rachnidian."
	say_mod = "chitters"
	var/static/list/languages_possible_arachnid = typecacheof(list(
		/datum/language/common,
		/datum/language/draconic,
		/datum/language/codespeak,
		/datum/language/monkey,
		/datum/language/narsie,
		/datum/language/beachbum,
		/datum/language/aphasia,
		/datum/language/arachnid,
	))

/obj/item/organ/tongue/arachnid/Initialize(mapload)
	. = ..()
	languages_possible = languages_possible_arachnid
