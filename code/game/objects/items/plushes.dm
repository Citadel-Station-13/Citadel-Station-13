/obj/item/toy/plush
	name = "plush"
	desc = "This is the special coder plush, do not steal."
	icon = 'icons/obj/plushes.dmi'
	icon_state = "debug"
	attack_verb = list("thumped", "whomped", "bumped")
	w_class = WEIGHT_CLASS_SMALL
	resistance_flags = FLAMMABLE
	var/list/squeak_override //Weighted list; If you want your plush to have different squeak sounds use this
	var/stuffed = TRUE //If the plushie has stuffing in it
	var/obj/item/grenade/grenade //You can remove the stuffing from a plushie and add a grenade to it for *nefarious uses*
	//--love ~<3--
	gender = NEUTER
	var/obj/item/toy/plush/lover
	var/obj/item/toy/plush/partner
	var/obj/item/toy/plush/plush_child
	var/obj/item/toy/plush/paternal_parent	//who initiated creation
	var/obj/item/toy/plush/maternal_parent	//who owns, see love()
	var/static/list/breeding_blacklist = typecacheof(/obj/item/toy/plush/carpplushie/dehy_carp) // you cannot have sexual relations with this plush
	var/list/scorned	= list()	//who the plush hates
	var/list/scorned_by	= list()	//who hates the plush, to remove external references on Destroy()
	var/heartbroken = FALSE
	var/vowbroken = FALSE
	var/young = FALSE
	var/mood_message
	var/list/love_message
	var/list/partner_message
	var/list/heartbroken_message
	var/list/vowbroken_message
	var/list/parent_message
	var/normal_desc
	//--end of love :'(--

/obj/item/toy/plush/Initialize()
	. = ..()
	AddComponent(/datum/component/squeak, squeak_override)

	//have we decided if Pinocchio goes in the blue or pink aisle yet?
	if(gender == NEUTER)
		if(prob(50))
			gender = FEMALE
		else
			gender = MALE

	love_message		= list("\n[src] is so happy, \he could rip a seam!")
	partner_message		= list("\n[src] has a ring on \his finger! It says bound to my dear [partner].")
	heartbroken_message	= list("\n[src] looks so sad.")
	vowbroken_message	= list("\n[src] lost \his ring...")
	parent_message		= list("\n[src] can't remember what sleep is.")

	normal_desc = desc

/obj/item/toy/plush/Destroy()
	QDEL_NULL(grenade)

	//inform next of kin and... acquaintances
	if(partner)
		partner.bad_news(src)
		partner = null
		lover = null
	else if(lover)
		lover.bad_news(src)
		lover = null

	if(paternal_parent)
		paternal_parent.bad_news(src)
		paternal_parent = null

	if(maternal_parent)
		maternal_parent.bad_news(src)
		maternal_parent = null

	if(plush_child)
		plush_child.bad_news(src)
		plush_child = null

	var/i
	var/obj/item/toy/plush/P
	for(i=1, i<=scorned.len, i++)
		P = scorned[i]
		P.bad_news(src)
	scorned = null

	for(i=1, i<=scorned_by.len, i++)
		P = scorned_by[i]
		P.bad_news(src)
	scorned_by = null

	//null remaining lists
	squeak_override = null

	love_message = null
	partner_message = null
	heartbroken_message = null
	vowbroken_message = null
	parent_message = null

	return ..()

/obj/item/toy/plush/handle_atom_del(atom/A)
	if(A == grenade)
		grenade = null
	..()

/obj/item/toy/plush/attack_self(mob/user)
	. = ..()
	if(stuffed || grenade)
		to_chat(user, "<span class='notice'>You pet [src]. D'awww.</span>")
		if(grenade && !grenade.active)
			if(istype(grenade, /obj/item/grenade/chem_grenade))
				var/obj/item/grenade/chem_grenade/G = grenade
				if(G.nadeassembly) //We're activated through different methods
					return
			log_game("[key_name(user)] activated a hidden grenade in [src].")
			grenade.preprime(user, msg = FALSE, volume = 10)
			SEND_SIGNAL(user, COMSIG_ADD_MOOD_EVENT,"plushpet", /datum/mood_event/plushpet)
	else
		to_chat(user, "<span class='notice'>You try to pet [src], but it has no stuffing. Aww...</span>")
		SEND_SIGNAL(user, COMSIG_ADD_MOOD_EVENT,"plush_nostuffing", /datum/mood_event/plush_nostuffing)

/obj/item/toy/plush/attackby(obj/item/I, mob/living/user, params)
	if(I.get_sharpness())
		if(!grenade)
			if(!stuffed)
				to_chat(user, "<span class='warning'>You already murdered it!</span>")
				return
			user.visible_message("<span class='notice'>[user] tears out the stuffing from [src]!</span>", "<span class='notice'>You rip a bunch of the stuffing from [src]. Murderer.</span>")
			I.play_tool_sound(src)
			stuffed = FALSE
			SEND_SIGNAL(user, COMSIG_ADD_MOOD_EVENT,"plushjack", /datum/mood_event/plushjack)
		else
			to_chat(user, "<span class='notice'>You remove the grenade from [src].</span>")
			user.put_in_hands(grenade)
			grenade = null
		return
	if(istype(I, /obj/item/grenade))
		if(stuffed)
			to_chat(user, "<span class='warning'>You need to remove some stuffing first!</span>")
			return
		if(grenade)
			to_chat(user, "<span class='warning'>[src] already has a grenade!</span>")
			return
		if(!user.transferItemToLoc(I, src))
			return
		user.visible_message("<span class='warning'>[user] slides [grenade] into [src].</span>", \
		"<span class='danger'>You slide [I] into [src].</span>")
		grenade = I
		var/turf/grenade_turf = get_turf(src)
		log_game("[key_name(user)] added a grenade ([I.name]) to [src] at [AREACOORD(grenade_turf)].")
		return
	if(istype(I, /obj/item/toy/plush))
		love(I, user)
		SEND_SIGNAL(user, COMSIG_ADD_MOOD_EVENT,"plushplay", /datum/mood_event/plushplay)
		return
	return ..()

/obj/item/toy/plush/proc/love(obj/item/toy/plush/Kisser, mob/living/user)	//~<3
	var/chance = 100	//to steal a kiss, surely there's a 100% chance no-one would reject a plush such as I?
	var/concern = 20	//perhaps something might cloud true love with doubt
	var/loyalty = 30	//why should another get between us?
	var/duty = 50		//conquering another's is what I live for

	//we are not catholic
	if(young == TRUE || Kisser.young == TRUE)
		user.show_message("<span class='notice'>[src] plays tag with [Kisser].</span>", MSG_VISUAL,
			"<span class='notice'>They're happy.</span>", 0)
		Kisser.cheer_up()
		cheer_up()

	//never again
	else if(Kisser in scorned)
		//message, visible, alternate message, neither visible nor audible
		user.show_message("<span class='notice'>[src] rejects the advances of [Kisser]!</span>", MSG_VISUAL,
			"<span class='notice'>That didn't feel like it worked.</span>", 0)
	else if(src in Kisser.scorned)
		user.show_message("<span class='notice'>[Kisser] realises who [src] is and turns away.</span>", MSG_VISUAL,
			"<span class='notice'>That didn't feel like it worked.</span>", 0)

	//first comes love
	else if(Kisser.lover != src && Kisser.partner != src)	//cannot be lovers or married
		if(Kisser.lover)	//if the initiator has a lover
			Kisser.lover.heartbreak(Kisser)	//the old lover can get over the kiss-and-run whilst the kisser has some fun
			chance -= concern	//one heart already broken, what does another mean?
		if(lover)	//if the recipient has a lover
			chance -= loyalty	//mustn't... but those lips
		if(partner)	//if the recipient has a partner
			chance -= duty	//do we mate for life?

		if(prob(chance))	//did we bag a date?
			user.visible_message("<span class='notice'>[user] makes [Kisser] kiss [src]!</span>",
									"<span class='notice'>You make [Kisser] kiss [src]!</span>")
			if(lover)	//who cares for the past, we live in the present
				lover.heartbreak(src)
			new_lover(Kisser)
			Kisser.new_lover(src)
		else
			user.show_message("<span class='notice'>[src] rejects the advances of [Kisser], maybe next time?</span>", MSG_VISUAL,
								"<span class='notice'>That didn't feel like it worked, this time.</span>", 0)

	//then comes marriage
	else if(Kisser.lover == src && Kisser.partner != src)	//need to be lovers (assumes loving is a two way street) but not married (also assumes similar)
		user.visible_message("<span class='notice'>[user] pronounces [Kisser] and [src] married! D'aw.</span>",
									"<span class='notice'>You pronounce [Kisser] and [src] married!</span>")
		new_partner(Kisser)
		Kisser.new_partner(src)

	//then comes a baby in a baby's carriage, or an adoption in an adoption's orphanage
	else if(Kisser.partner == src && !plush_child)	//the one advancing does not take ownership of the child and we have a one child policy in the toyshop
		user.visible_message("<span class='notice'>[user] is going to break [Kisser] and [src] by bashing them like that.</span>",
									"<span class='notice'>[Kisser] passionately embraces [src] in your hands. Look away you perv!</span>")
		if(plop(Kisser))
			user.visible_message("<span class='notice'>Something drops at the feet of [user].</span>",
								"<span class='notice'>The miracle of oh god did that just come out of [src]?!</span>")

	//then comes protection, or abstinence if we are catholic
	else if(Kisser.partner == src && plush_child)
		user.visible_message("<span class='notice'>[user] makes [Kisser] nuzzle [src]!</span>",
									"<span class='notice'>You make [Kisser] nuzzle [src]!</span>")

	//then oh fuck something unexpected happened
	else
		user.show_message("<span class='warning'>[Kisser] and [src] don't know what to do with one another.</span>", 0)

/obj/item/toy/plush/proc/heartbreak(obj/item/toy/plush/Brutus)
	if(lover != Brutus)
		to_chat(world, "lover != Brutus")
		return	//why are we considering someone we don't love?

	scorned.Add(Brutus)
	Brutus.scorned_by(src)

	lover = null
	Brutus.lover = null	//feeling's mutual

	heartbroken = TRUE
	mood_message = pick(heartbroken_message)

	if(partner == Brutus)	//oh dear...
		partner = null
		Brutus.partner = null	//it'd be weird otherwise
		vowbroken = TRUE
		mood_message = pick(vowbroken_message)

	update_desc()

/obj/item/toy/plush/proc/scorned_by(obj/item/toy/plush/Outmoded)
	scorned_by.Add(Outmoded)

/obj/item/toy/plush/proc/new_lover(obj/item/toy/plush/Juliet)
	if(lover == Juliet)
		return	//nice try
	lover = Juliet

	cheer_up()
	lover.cheer_up()

	mood_message = pick(love_message)
	update_desc()

	if(partner)	//who?
		partner = null	//more like who cares

/obj/item/toy/plush/proc/new_partner(obj/item/toy/plush/Apple_of_my_eye)
	if(partner == Apple_of_my_eye)
		return	//double marriage is just insecurity
	if(lover != Apple_of_my_eye)
		return	//union not born out of love will falter

	partner = Apple_of_my_eye

	heal_memories()
	partner.heal_memories()

	mood_message = pick(partner_message)
	update_desc()

/obj/item/toy/plush/proc/plop(obj/item/toy/plush/Daddy)
	if(partner != Daddy)
		return	FALSE //we do not have bastards in our toyshop

	if(is_type_in_typecache(Daddy, breeding_blacklist))
		return FALSE // some love is forbidden

	if(prob(50))	//it has my eyes
		plush_child = new type(get_turf(loc))
	else	//it has your eyes
		plush_child = new Daddy.type(get_turf(loc))

	plush_child.make_young(src, Daddy)

/obj/item/toy/plush/proc/make_young(obj/item/toy/plush/Mama, obj/item/toy/plush/Dada)
	if(Mama == Dada)
		return	//cloning is reserved for plants and spacemen

	maternal_parent = Mama
	paternal_parent = Dada
	young = TRUE
	name = "[Mama] Jr"	//Icelandic naming convention pending
	normal_desc = "[src] is a little baby of [maternal_parent] and [paternal_parent]!"	//original desc won't be used so the child can have moods
	update_desc()

	Mama.mood_message = pick(Mama.parent_message)
	Mama.update_desc()
	Dada.mood_message = pick(Dada.parent_message)
	Dada.update_desc()

/obj/item/toy/plush/proc/bad_news(obj/item/toy/plush/Deceased)	//cotton to cotton, sawdust to sawdust
	var/is_that_letter_for_me = FALSE
	if(partner == Deceased)	//covers marriage
		is_that_letter_for_me = TRUE
		partner = null
		lover = null
	else if(lover == Deceased)	//covers lovers
		is_that_letter_for_me = TRUE
		lover = null

	//covers children
	if(maternal_parent == Deceased)
		is_that_letter_for_me = TRUE
		maternal_parent = null

	if(paternal_parent == Deceased)
		is_that_letter_for_me = TRUE
		paternal_parent = null

	//covers parents
	if(plush_child == Deceased)
		is_that_letter_for_me = TRUE
		plush_child = null

	//covers bad memories
	if(Deceased in scorned)
		scorned.Remove(Deceased)
		cheer_up()	//what cold button eyes you have

	if(Deceased in scorned_by)
		scorned_by.Remove(Deceased)

	//all references to the departed should be cleaned up by now

	if(is_that_letter_for_me)
		heartbroken = TRUE
		mood_message = pick(heartbroken_message)
		update_desc()

/obj/item/toy/plush/proc/cheer_up()	//it'll be all right
	if(!heartbroken)
		return	//you cannot make smile what is already
	if(vowbroken)
		return	//it's a pretty big deal

	heartbroken = !heartbroken

	if(mood_message in heartbroken_message)
		mood_message = null
	update_desc()

/obj/item/toy/plush/proc/heal_memories()	//time fixes all wounds
	if(!vowbroken)
		vowbroken = !vowbroken
		if(mood_message in vowbroken_message)
			mood_message = null
	cheer_up()

/obj/item/toy/plush/proc/update_desc()
	desc = normal_desc
	if(mood_message)
		desc += mood_message

/obj/item/toy/plush/random
	name = "Illegal plushie"
	desc = "Something fucked up"
	var/blacklisted_plushes = list(/obj/item/toy/plush/carpplushie/dehy_carp, /obj/item/toy/plush/awakenedplushie, /obj/item/toy/plush/random)

/obj/item/toy/plush/random/Initialize()
	var/newtype = pick(subtypesof(/obj/item/toy/plush) - typecacheof(blacklisted_plushes))
	new newtype(loc)
	return INITIALIZE_HINT_QDEL

/obj/item/toy/plush/carpplushie
	name = "space carp plushie"
	desc = "An adorable stuffed toy that resembles a space carp."
	icon_state = "carpplush"
	item_state = "carp_plushie"
	attack_verb = list("bitten", "eaten", "fin slapped")
	squeak_override = list('sound/weapons/bite.ogg'=1)

/obj/item/toy/plush/bubbleplush
	name = "bubblegum plushie"
	desc = "The friendly red demon that gives good miners gifts."
	icon_state = "bubbleplush"
	attack_verb = list("rends")
	squeak_override = list('sound/magic/demon_attack1.ogg'=1)

/obj/item/toy/plush/plushvar
	name = "ratvar plushie"
	desc = "An adorable plushie of the clockwork justiciar himself with new and improved spring arm action."
	icon_state = "plushvar"
	var/obj/item/toy/plush/narplush/clash_target
	gender = MALE	//he's a boy, right?

/obj/item/toy/plush/plushvar/Moved()
	. = ..()
	if(clash_target)
		return
	var/obj/item/toy/plush/narplush/P = locate() in range(1, src)
	if(P && istype(P.loc, /turf/open) && !P.clashing)
		clash_of_the_plushies(P)

/obj/item/toy/plush/plushvar/proc/clash_of_the_plushies(obj/item/toy/plush/narplush/P)
	clash_target = P
	P.clashing = TRUE
	say("YOU.")
	P.say("Ratvar?!")
	var/obj/item/toy/plush/a_winnar_is
	var/victory_chance = 10
	for(var/i in 1 to 10) //We only fight ten times max
		if(QDELETED(src))
			P.clashing = FALSE
			return
		if(QDELETED(P))
			clash_target = null
			return
		if(!Adjacent(P))
			visible_message("<span class='warning'>The two plushies angrily flail at each other before giving up.</span>")
			clash_target = null
			P.clashing = FALSE
			return
		playsound(src, 'sound/magic/clockwork/ratvar_attack.ogg', 50, TRUE, frequency = 2)
		sleep(2.4)
		if(QDELETED(src))
			P.clashing = FALSE
			return
		if(QDELETED(P))
			clash_target = null
			return
		if(prob(victory_chance))
			a_winnar_is = src
			break
		P.SpinAnimation(5, 0)
		sleep(5)
		if(QDELETED(src))
			P.clashing = FALSE
			return
		if(QDELETED(P))
			clash_target = null
			return
		playsound(P, 'sound/magic/clockwork/narsie_attack.ogg', 50, TRUE, frequency = 2)
		sleep(3.3)
		if(QDELETED(src))
			P.clashing = FALSE
			return
		if(QDELETED(P))
			clash_target = null
			return
		if(prob(victory_chance))
			a_winnar_is = P
			break
		SpinAnimation(5, 0)
		victory_chance += 10
		sleep(5)
	if(!a_winnar_is)
		a_winnar_is = pick(src, P)
	if(a_winnar_is == src)
		say(pick("DIE.", "ROT."))
		P.say(pick("Nooooo...", "Not die. To y-", "Die. Ratv-", "Sas tyen re-"))
		playsound(src, 'sound/magic/clockwork/anima_fragment_attack.ogg', 50, TRUE, frequency = 2)
		playsound(P, 'sound/magic/demon_dies.ogg', 50, TRUE, frequency = 2)
		explosion(P, 0, 0, 1)
		qdel(P)
		clash_target = null
	else
		say("NO! I will not be banished again...")
		P.say(pick("Ha.", "Ra'sha fonn dest.", "You fool. To come here."))
		playsound(src, 'sound/magic/clockwork/anima_fragment_death.ogg', 62, TRUE, frequency = 2)
		playsound(P, 'sound/magic/demon_attack1.ogg', 50, TRUE, frequency = 2)
		explosion(src, 0, 0, 1)
		qdel(src)
		P.clashing = FALSE

/obj/item/toy/plush/narplush
	name = "\improper Nar'Sie plushie"
	desc = "A small stuffed doll of the elder goddess Nar'Sie. Who thought this was a good children's toy?"
	icon_state = "narplush"
	var/clashing
	var/is_invoker = TRUE
	gender = FEMALE	//it's canon if the toy is

/obj/item/toy/plush/narplush/Moved()
	. = ..()
	var/obj/item/toy/plush/plushvar/P = locate() in range(1, src)
	if(P && istype(P.loc, /turf/open) && !P.clash_target && !clashing)
		P.clash_of_the_plushies(src)

/obj/item/toy/plush/narplush/hugbox
	desc = "A small stuffed doll of the elder goddess Nar'Sie. Who thought this was a good children's toy? <b>It looks sad.</b>"
	is_invoker = FALSE

/obj/item/toy/plush/lizardplushie
	name = "lizard plushie"
	desc = "An adorable stuffed toy that resembles a lizardperson."
	icon_state = "plushie_lizard"
	item_state = "plushie_lizard"
	attack_verb = list("clawed", "hissed", "tail slapped")
	squeak_override = list('sound/weapons/slash.ogg' = 1)

/obj/item/toy/plush/lizardplushie/durgit
	icon_state = "durgit"
	item_state = "durgit"
	squeak_override = list('modular_citadel/sound/voice/weh.ogg' = 1) //Durgit's the origin of the sound

/obj/item/toy/plush/lizardplushie/rio
	icon_state = "rio"
	item_state = "rio"

/obj/item/toy/plush/lizardplushie/dan
	icon_state = "dan"
	item_state = "dan"

/obj/item/toy/plush/lizardplushie/urinsu
	icon_state = "urinsu"
	item_state = "urinsu"

/obj/item/toy/plush/lizardplushie/arfrehn
	icon_state = "arfrehn"
	item_state = "arfrehn"

/obj/item/toy/plush/lizardplushie/soars
	icon_state = "soars"
	item_state = "soars"

/obj/item/toy/plush/lizardplushie/ghostie
	icon_state = "ghostie"
	item_state = "ghostie"

/obj/item/toy/plush/lizardplushie/amber
	icon_state = "amber"
	item_state = "amber"

/obj/item/toy/plush/lizardplushie/cyan
	icon_state = "cyan"
	item_state = "cyan"

/obj/item/toy/plush/lizardplushie/meena
	icon_state = "meena"
	item_state = "meena"

/obj/item/toy/plush/lizardplushie/stalks
	icon_state = "stalks"
	item_state = "stalks"

/obj/item/toy/plush/lizardplushie/kobold
	icon_state = "kobold"
	item_state = "kobold"

/obj/item/toy/plush/lizardplushie/gorgi
	icon_state = "gorgi"
	item_state = "gorgi"

/obj/item/toy/plush/lizardplushie/almaz
	icon_state = "almaz"
	item_state = "almaz"
	squeak_override = list('modular_citadel/sound/voice/raptor_purr.ogg' = 1)

/obj/item/toy/plush/lizardplushie/garou
	icon_state = "garou"
	item_state = "garou"

/obj/item/toy/plush/lizardplushie/augments
	icon_state = "augments"
	item_state = "augments"
	squeak_override = list('modular_citadel/sound/voice/weh.ogg' = 1) //I have no mouth and I must weh
	attack_verb = list("hugged", "patted", "snugged", "booped")

/obj/item/toy/plush/lizardplushie/xekov
	icon_state = "xekov"
	item_state = "xekov"

/obj/item/toy/plush/lizardplushie/greg
	icon_state = "greg"
	item_state = "greg"

/obj/item/toy/plush/lizardplushie/sin
	icon_state = "sin"
	item_state = "sin"
	desc = "An adorable stuffed toy that resembles a lizardperson.. It faintly smells of sulfur."

/obj/item/toy/plush/lizardplushie/ends
	icon_state = "ends"
	item_state = "ends"

/obj/item/toy/plush/lizardplushie/lyssa
	icon_state = "lyssa"
	item_state = "lyssa"

/obj/item/toy/plush/snakeplushie
	name = "snake plushie"
	desc = "An adorable stuffed toy that resembles a snake. Not to be mistaken for the real thing."
	icon_state = "plushie_snake"
	item_state = "plushie_snake"
	attack_verb = list("bitten", "hissed", "tail slapped")
	squeak_override = list('modular_citadel/sound/voice/hiss.ogg' = 1)

/obj/item/toy/plush/snakeplushie/sasha
	icon_state = "sasha"
	item_state = "sasha"

/obj/item/toy/plush/snakeplushie/shay
	icon_state = "shay"
	item_state = "shay"

/obj/item/toy/plush/snakeplushie/vulken
	icon_state = "vulken"
	item_state = "vulken"

/obj/item/toy/plush/nukeplushie
	name = "operative plushie"
	desc = "A stuffed toy that resembles a syndicate nuclear operative. The tag claims operatives to be purely fictitious."
	icon_state = "plushie_nuke"
	item_state = "plushie_nuke"
	attack_verb = list("shot", "nuked", "detonated")
	squeak_override = list('sound/effects/hit_punch.ogg' = 1)

/obj/item/toy/plush/slimeplushie
	name = "slime plushie"
	desc = "An adorable stuffed toy that resembles a slime. It is practically just a hacky sack."
	icon_state = "plushie_slime"
	item_state = "plushie_slime"
	attack_verb = list("blorbled", "slimed", "absorbed", "glomped")
	squeak_override = list('sound/effects/blobattack.ogg' = 1)
	gender = FEMALE	//given all the jokes and drawings, I'm not sure the xenobiologists would make a slimeboy

/obj/item/toy/plush/slimeplushie/annie
	desc = "An adorable stuffed toy that resembles a slimey crewmember."
	icon_state = "annie"
	item_state = "annie"

/obj/item/toy/plush/slimeplushie/paxton
	desc = "An adorable stuffed toy that resembles a slimey crewmember."
	icon_state = "paxton"
	item_state = "paxton"
	attack_verb = list("CQC'd", "jabroni'd", "powergamed", "robusted", "cakehatted")
	gender = MALE

/obj/item/toy/plush/awakenedplushie
	name = "awakened plushie"
	desc = "An ancient plushie that has grown enlightened to the true nature of reality."
	icon_state = "plushie_awake"
	item_state = "plushie_awake"

/obj/item/toy/plush/awakenedplushie/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/edit_complainer)


/obj/item/toy/plush/beeplushie
	name = "bee plushie"
	desc = "A cute toy that resembles an even cuter bee."
	icon_state = "plushie_h"
	item_state = "plushie_h"
	attack_verb = list("stung")
	gender = FEMALE
	squeak_override = list('modular_citadel/sound/voice/scream_moth.ogg' = 1)

/obj/item/toy/plush/mothplushie
	name = "insect plushie"
	desc = "An adorable stuffed toy that resembles some kind of insect."
	icon_state = "bumble"
	item_state = "bumble"
	squeak_override = list('modular_citadel/sound/voice/mothsqueak.ogg' = 1)

/obj/item/toy/plush/mothplushie/nameko
	icon_state = "nameko"
	item_state = "nameko"

/obj/item/toy/plush/mothplushie/suru
	icon_state = "suru"
	item_state = "suru"

/obj/item/toy/plush/xeno
	name = "xenohybrid plushie"
	desc = "An adorable stuffed toy that resmembles a xenomorphic crewmember."
	icon_state = "seras"
	item_state = "seras"
	squeak_override = list('sound/voice/hiss2.ogg' = 1)

/obj/item/toy/plush/lampplushie
	name = "lamp plushie"
	desc = "A toy lamp plushie, doesn't actually make light, but it still toggles on and off. Click clack!"
	icon_state = "plushie_lamp"
	item_state = "plushie_lamp"
	attack_verb = list("lit", "flickered", "flashed")
	squeak_override = list('sound/weapons/magout.ogg' = 1)

/obj/item/toy/plush/box
	name = "cardboard plushie"
	desc = "A toy box plushie, it holds cotten. Only a baddie would place a bomb through the postal system..."
	icon_state = "box"
	item_state = "box"
	attack_verb = list("open", "closed", "packed", "hidden", "rigged", "bombed", "sent", "gave")

/obj/item/toy/plush/slaggy
	name = "slag plushie"
	desc = "A piece of slag with some googly eyes and a drawn on mouth."
	icon_state = "slaggy"
	item_state = "slaggy"
	attack_verb = list("melted", "refined", "stared")

/obj/item/toy/plush/mr_buckety
	name = "bucket plushie"
	desc = "A bucket that is missing its handle with some googly eyes and a drawn on mouth."
	icon_state = "mr_buckety"
	item_state = "mr_buckety"
	attack_verb = list("filled", "dumped", "stared")

/obj/item/toy/plush/dr_scanny
	name = "scanner plushie"
	desc = "A old outdated scanner that has been modified to have googly eyes, a dawn on mouth and, heart."
	icon_state = "dr_scanny"
	item_state = "dr_scanny"
	attack_verb = list("scanned", "beeped", "stared")

/obj/item/toy/plush/borgplushie
	name = "robot plushie"
	desc = "An adorable stuffed toy of a robot."
	icon_state = "securityk9"
	item_state = "securityk9"
	attack_verb = list("beeped", "booped", "pinged")
	squeak_override = list('sound/machines/beep.ogg' = 1)

/obj/item/toy/plush/borgplushie/medihound
	icon_state = "medihound"
	item_state = "medihound"

/obj/item/toy/plush/borgplushie/scrubpuppy
	icon_state = "scrubpuppy"
	item_state = "scrubpuppy"

/obj/item/toy/plush/borgplushie/seeking
	icon_state = "seeking"
	item_state = "seeking"

/obj/item/toy/plush/borgplushie/neeb
	icon_state = "neeb"
	item_state = "neeb"

/obj/item/toy/plush/borgplushie/bhijn
	desc = "An adorable stuffed toy of a IPC."
	icon_state = "bhijn"
	item_state = "bhijn"
	attack_verb = list("closed", "reworked", "merged")

/obj/item/toy/plush/aiplush
	name = "AI plushie"
	desc = "A little stuffed toy AI core... it appears to be malfunctioning."
	icon_state = "exo"
	item_state = "exo"
	attack_verb = list("hacked", "detonated", "overloaded")
	squeak_override = list('sound/machines/beep.ogg' = 9, 'sound/machines/buzz-two.ogg' = 1)

/obj/item/toy/plush/bird
	name = "bird plushie"
	desc = "An adorable stuffed plushie that resembles an avian."
	icon_state = "sylas"
	item_state = "sylas"
	attack_verb = list("peeped", "beeped", "poofed")
	squeak_override = list('modular_citadel/sound/voice/peep.ogg' = 1)

/obj/item/toy/plush/bird/esela
	icon_state = "esela"
	item_state = "esela"

/obj/item/toy/plush/bird/jahonna
	icon_state = "jahonna"
	item_state = "jahonna"

/obj/item/toy/plush/bird/krick
	icon_state = "krick"
	item_state = "krick"

/obj/item/toy/plush/bird/birddi
	icon_state = "birddi"
	item_state = "birddi"

/obj/item/toy/plush/bird/jewel
	icon_state = "jewel"
	item_state = "jewel"

/obj/item/toy/plush/sergal
	name = "sergal plushie"
	desc = "An adorable stuffed plushie that resembles a sagaru."
	icon_state = "faux"
	item_state = "faux"
	squeak_override = list('modular_citadel/sound/voice/merp.ogg' = 1)

/obj/item/toy/plush/sergal/gladwyn
	icon_state = "gladwyn"
	item_state = "gladwyn"

/obj/item/toy/plush/sergal/jermaine
	icon_state = "jermaine"
	item_state = "jermaine"

/obj/item/toy/plush/mammal
	name = "mammal plushie"
	desc = "An adorable stuffed toy resembling some sort of crew member."
	icon_state = "dubious"
	item_state = "dubious"

/obj/item/toy/plush/mammal/gavin
	icon_state = "gavin"
	item_state = "gavin"

/obj/item/toy/plush/mammal/blep
	icon_state = "blep"
	item_state = "blep"

/obj/item/toy/plush/mammal/circe
	desc = "A luxuriously soft toy that resembles a nine-tailed kitsune."
	icon_state = "circe"
	item_state = "circe"
	attack_verb = list("medicated", "tailhugged", "kissed")

/obj/item/toy/plush/mammal/robin
	icon_state = "robin"
	item_state = "robin"

/obj/item/toy/plush/mammal/pavel
	icon_state = "pavel"
	item_state = "pavel"

/obj/item/toy/plush/mammal/mason
	icon_state = "mason"
	item_state = "mason"

/obj/item/toy/plush/mammal/oten
	icon_state = "oten"
	item_state = "oten"

/obj/item/toy/plush/mammal/ray
	icon_state = "ray"
	item_state = "ray"

/obj/item/toy/plush/mammal/redtail
	icon_state = "redtail"
	item_state = "redtail"

/obj/item/toy/plush/mammal/dawud
	icon_state = "dawud"
	item_state = "dawud"

/obj/item/toy/plush/mammal/edgar
	icon_state = "edgar"
	item_state = "edgar"
	attack_verb = list("collared", "tricked", "headpatted")

/obj/item/toy/plush/mammal/frank
	icon_state = "frank"
	item_state = "frank"

/obj/item/toy/plush/mammal/poojawa
	icon_state = "poojawa"
	item_state = "poojawa"

/obj/item/toy/plush/mammal/hazel
	icon_state = "hazel"
	item_state = "hazel"

/obj/item/toy/plush/mammal/joker
	icon_state = "joker"
	item_state = "joker"

/obj/item/toy/plush/mammal/gunther
	icon_state = "gunther"
	item_state = "gunther"

/obj/item/toy/plush/mammal/fox
	icon_state = "fox"
	item_state = "fox"

/obj/item/toy/plush/mammal/rae
	desc = "An adorable stuffed toy of an artic fox."
	icon_state = "rae"
	item_state = "rae"

/obj/item/toy/plush/mammal/zed
	desc = "A masked stuffed toy that resembles a fierce miner. He even comes with his own little crusher!"
	icon_state = "zed"
	item_state = "zed"
	attack_verb = list("ENDED", "CRUSHED", "GNOMED")

/obj/item/toy/plush/mammal/justin
	icon_state = "justin"
	item_state = "justin"
	attack_verb = list("buttslapped", "fixed")

/obj/item/toy/plush/mammal/reece
	icon_state = "reece"
	item_state = "reece"
	attack_verb = list("healed", "cured", "demoted")

/obj/item/toy/plush/mammal/redwood
	desc = "An adorable stuffed toy resembling a Nanotrasen Captain. That just happens to be a bunny."
	icon_state = "redwood"
	item_state = "redwood"
	attack_verb = list("ordered", "bapped", "reprimanded")

/obj/item/toy/plush/mammal/marisol
	desc = "An adorable stuffed toy resembling a demi-wolf security officer."
	icon_state = "marisol"
	item_state = "marisol"
	attack_verb = list("arrested", "harmbattoned", "lasered")

/obj/item/toy/plush/mammal/minty
	desc = "An adorable stuffed toy resembling some sort of crew member. It smells like mint.."
	icon_state = "minty"
	item_state = "minty"
	attack_verb = list("freshened", "brushed")

/obj/item/toy/plush/mammal/dog
	desc = "An adorable stuffed toy that resembles a canine."
	icon_state = "katlin"
	item_state = "katlin"
	attack_verb = list("barked", "boofed", "borked")
	squeak_override = list(
	'modular_citadel/sound/voice/bark1.ogg' = 1,
	'modular_citadel/sound/voice/bark2.ogg' = 1
	)

/obj/item/toy/plush/mammal/dog/frost
	icon_state = "frost"
	item_state = "frost"

/obj/item/toy/plush/mammal/dog/atticus
	icon_state = "atticus"
	item_state = "atticus"

/obj/item/toy/plush/mammal/dog/fletch
	icon_state = "fletch"
	item_state = "fletch"

/obj/item/toy/plush/mammal/dog/vincent
	icon_state = "vincent"
	item_state = "vincent"

/obj/item/toy/plush/mammal/dog/zigfried
	desc = "An adorable stuffed toy of a very good boy."
	icon_state = "zigfried"
	item_state = "zigfried"

/obj/item/toy/plush/mammal/dog/nikolai
	icon_state = "nikolai"
	item_state = "nikolai"

/obj/item/toy/plush/mammal/dog/flynn
	icon_state = "flynn"
	item_state = "flynn"

/obj/item/toy/plush/mammal/dog/fritz
	icon_state = "fritz"
	item_state = "fritz"
	attack_verb = list("barked", "boofed", "shotgun'd")
	obj_flags = UNIQUE_RENAME
	unique_reskin = list("Goodboye" = "fritz", "Badboye" = "fritz_bad")

/obj/item/toy/plush/mammal/dog/jesse
	desc = "An adorable wolf toy that resembles a cream-colored wolf. He has a little pride flag!"
	icon_state = "jesse"
	item_state = "jesse"
	attack_verb = list("greeted", "merc'd", "howdy'd")

/obj/item/toy/plush/catgirl
	name = "feline plushie"
	desc = "An adorable stuffed toy that resembles a feline."
	icon_state = "bailey"
	item_state = "bailey"
	attack_verb = list("headbutt", "scritched", "bit")
	squeak_override = list('modular_citadel/sound/voice/nya.ogg' = 1)

/obj/item/toy/plush/catgirl/mikeel
	desc = "An adorable stuffed toy of some tauric cat person."
	icon_state = "mikeel"
	item_state = "mikeel"

/obj/item/toy/plush/catgirl/skylar
	desc = "An adorable stuffed toy that resembles a degenerate."
	icon_state = "skylar2"
	item_state = "skylar2"
	attack_verb = list("powergamed", "merged", "tabled")
	squeak_override = list('sound/effects/meow1.ogg' = 1)

/obj/item/toy/plush/catgirl/drew
	icon_state = "drew"
	item_state = "drew"

/obj/item/toy/plush/catgirl/trilby
	desc = "A masked stuffed toy that resembles a feline scientist."
	icon_state = "trilby"
	item_state = "trilby"
	attack_verb = list("PR'd", "coded", "remembered")

/obj/item/toy/plush/catgirl/fermis
	name = "medcat plushie"
	desc = "An affectionate stuffed toy that resembles a certain medcat, comes complete with battery operated wagging tail!! You get the impression she's cheering you on to to find happiness and be kind to people."
	icon_state = "fermis"
	item_state = "fermis"
	attack_verb = list("cuddled", "petpatted", "wigglepurred")
	squeak_override = list('modular_citadel/sound/voice/merowr.ogg' = 1)

/obj/item/toy/plush/catgirl/mariaf
	desc = "An adorable stuffed toy that resembles a very tall cat girl."
	icon_state = "mariaf"
	item_state = "mariaf"
	attack_verb = list("hugged", "stabbed", "licked")

/obj/item/toy/plush/catgirl/maya
	desc = "An adorable stuffed toy that resembles an angry cat girl. She has her own tiny nuke disk!"
	icon_state = "maya"
	item_state = "maya"
	attack_verb = list("nuked", "arrested", "harmbatonned")

/obj/item/toy/plush/catgirl/marisa
	desc = "An adorable stuffed toy that resembles a crew member, or maybe a witch. Having it makes you feel you can win."
	icon_state = "marisa"
	item_state = "marisa"
	attack_verb = list("blasted", "sparked", "dazzled")
