/obj/item/clothing/head/wizard
	name = "wizard hat"
	desc = "Strange-looking hat-wear that most certainly belongs to a real magic user."
	icon_state = "wizard"
	gas_transfer_coefficient = 0.01 // IT'S MAGICAL OKAY JEEZ +1 TO NOT DIE
	permeability_coefficient = 0.01
	armor = list(MELEE = 30, BULLET = 20, LASER = 20, ENERGY = 20, BOMB = 20, BIO = 20, RAD = 20, FIRE = 100, ACID = 100, WOUND = 20)
	strip_delay = 50
	equip_delay_other = 50
	resistance_flags = FIRE_PROOF | ACID_PROOF
	dog_fashion = /datum/dog_fashion/head/blue_wizard
	beepsky_fashion = /datum/beepsky_fashion/wizard
	var/magic_flags = SPELL_WIZARD_HAT

/obj/item/clothing/head/wizard/ComponentInitialize()
	. = ..()
	if(magic_flags)
		AddElement(/datum/element/spellcasting, magic_flags, ITEM_SLOT_HEAD)

/obj/item/clothing/head/wizard/red
	name = "red wizard hat"
	desc = "Strange-looking red hat-wear that most certainly belongs to a real magic user."
	icon_state = "redwizard"
	dog_fashion = /datum/dog_fashion/head/red_wizard

/obj/item/clothing/head/wizard/yellow
	name = "yellow wizard hat"
	desc = "Strange-looking yellow hat-wear that most certainly belongs to a powerful magic user."
	icon_state = "yellowwizard"
	dog_fashion = null

/obj/item/clothing/head/wizard/black
	name = "black wizard hat"
	desc = "Strange-looking black hat-wear that most certainly belongs to a real skeleton. Spooky."
	icon_state = "blackwizard"
	dog_fashion = null

/obj/item/clothing/head/wizard/fake
	name = "wizard hat"
	desc = "It has WIZZARD written across it in sequins. Comes with a cool beard."
	icon_state = "wizard-fake"
	gas_transfer_coefficient = 1
	permeability_coefficient = 1
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 0, ACID = 0)
	resistance_flags = FLAMMABLE
	magic_flags = NONE

/obj/item/clothing/head/wizard/marisa
	name = "witch hat"
	desc = "Strange-looking hat-wear. Makes you want to cast fireballs."
	icon_state = "marisa"
	dog_fashion = null

/obj/item/clothing/head/wizard/magus
	name = "\improper Magus helm"
	desc = "A mysterious helmet that hums with an unearthly power."
	icon_state = "magus"
	item_state = "magus"
	dog_fashion = null
	magic_flags = SPELL_WIZARD_HAT|SPELL_CULT_HELMET

/obj/item/clothing/head/wizard/santa
	name = "Santa's hat"
	desc = "Ho ho ho. Merrry X-mas!"
	icon_state = "santahat"
	flags_inv = HIDEHAIR|HIDEFACIALHAIR
	dog_fashion = null

/obj/item/clothing/suit/wizrobe
	name = "wizard robe"
	desc = "A magnificent, gem-lined robe that seems to radiate power."
	icon_state = "wizard"
	item_state = "wizrobe"
	gas_transfer_coefficient = 0.01
	permeability_coefficient = 0.01
	body_parts_covered = CHEST|GROIN|ARMS|LEGS
	armor = list(MELEE = 30, BULLET = 20, LASER = 20, ENERGY = 20, BOMB = 20, BIO = 20, RAD = 20, FIRE = 100, ACID = 100, WOUND = 20)
	allowed = list(/obj/item/teleportation_scroll)
	flags_inv = HIDEJUMPSUIT
	strip_delay = 50
	equip_delay_other = 50
	resistance_flags = FIRE_PROOF | ACID_PROOF
	mutantrace_variation = STYLE_DIGITIGRADE|STYLE_NO_ANTHRO_ICON
	var/magic_flags = SPELL_WIZARD_ROBE

/obj/item/clothing/suit/wizrobe/ComponentInitialize()
	. = ..()
	if(magic_flags)
		AddElement(/datum/element/spellcasting, magic_flags, ITEM_SLOT_OCLOTHING)

/obj/item/clothing/suit/wizrobe/red
	name = "red wizard robe"
	desc = "A magnificent red gem-lined robe that seems to radiate power."
	icon_state = "redwizard"
	item_state = "redwizrobe"

/obj/item/clothing/suit/wizrobe/yellow
	name = "yellow wizard robe"
	desc = "A magnificent yellow gem-lined robe that seems to radiate power."
	icon_state = "yellowwizard"
	item_state = "yellowwizrobe"

/obj/item/clothing/suit/wizrobe/black
	name = "black wizard robe"
	desc = "An unnerving black gem-lined robe that reeks of death and decay."
	icon_state = "blackwizard"
	item_state = "blackwizrobe"

/obj/item/clothing/suit/wizrobe/marisa
	name = "witch robe"
	desc = "Magic is all about the spell power, ZE!"
	icon_state = "marisa"
	item_state = "marisarobe"

/obj/item/clothing/suit/wizrobe/magusblue
	name = "\improper Magus robe"
	desc = "A set of armored robes that seem to radiate a dark power."
	icon_state = "magusblue"
	item_state = "magusblue"
	mutantrace_variation = STYLE_DIGITIGRADE
	magic_flags = SPELL_WIZARD_ROBE|SPELL_CULT_ARMOR

/obj/item/clothing/suit/wizrobe/magusred
	name = "\improper Magus robe"
	desc = "A set of armored robes that seem to radiate a dark power."
	icon_state = "magusred"
	item_state = "magusred"
	mutantrace_variation = STYLE_DIGITIGRADE
	magic_flags = SPELL_WIZARD_ROBE|SPELL_CULT_ARMOR

/obj/item/clothing/suit/wizrobe/santa
	name = "Santa's suit"
	desc = "Festive!"
	icon_state = "santa"
	item_state = "santa"
	mutantrace_variation = STYLE_DIGITIGRADE

/obj/item/clothing/suit/wizrobe/fake
	desc = "A rather dull blue robe meant to mimick real wizard robes."
	icon_state = "wizard-fake"
	gas_transfer_coefficient = 1
	permeability_coefficient = 1
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 0, ACID = 0)
	resistance_flags = FLAMMABLE
	magic_flags = NONE

/obj/item/clothing/head/wizard/marisa/fake
	gas_transfer_coefficient = 1
	permeability_coefficient = 1
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 0, ACID = 0)
	resistance_flags = FLAMMABLE
	magic_flags = NONE

/obj/item/clothing/suit/wizrobe/marisa/fake
	gas_transfer_coefficient = 1
	permeability_coefficient = 1
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 0, ACID = 0)
	resistance_flags = FLAMMABLE
	magic_flags = NONE

/obj/item/clothing/suit/wizrobe/paper
	name = "papier-mache robe" // no non-latin characters!
	desc = "A robe held together by various bits of clear-tape and paste."
	icon_state = "wizard-paper"
	item_state = "wizard-paper"
	var/robe_charge = TRUE
	actions_types = list(/datum/action/item_action/stickmen)

/obj/item/clothing/suit/wizrobe/paper/item_action_slot_check(slot, mob/user, datum/action/A)
	if(A.type == /datum/action/item_action/stickmen && slot != ITEM_SLOT_OCLOTHING)
		return FALSE
	return ..()

//Stickmemes. VV-friendly.
/datum/action/item_action/stickmen
	name = "Summon Stick Minions"
	desc = "Allows you to summon faithful stickmen allies to aide you in battle."
	icon_icon = 'icons/mob/actions/actions_minor_antag.dmi'
	button_icon_state = "art_summon"
	var/ready = TRUE
	var/list/summoned_stickmen = list()
	var/summoned_mob_path = /mob/living/simple_animal/hostile/stickman //Must be an hostile animal path.
	var/max_stickmen = 8
	var/cooldown = 3 SECONDS
	var/list/book_of_grudges = list()

/datum/action/item_action/stickmen/New(Target)
	..()
	if(isitem(Target))
		RegisterSignal(Target, COMSIG_PARENT_EXAMINE, PROC_REF(give_infos))

/datum/action/item_action/stickmen/Destroy()
	for(var/A in summoned_stickmen)
		var/mob/living/simple_animal/hostile/S = A
		if(S.client)
			to_chat(S, "<span class='danger'>A dizzying sensation strikes you as the comglomerate of pencil lines you call \
						your body crumbles under the pressure of an invisible eraser, soon to join bilions discarded sketches. \
						It seems whatever was keeping you in this realm has come to an end, like all things.</span>")
		animate(S, alpha = 0, time = 5 SECONDS)
		QDEL_IN(S, 5 SECONDS)
	return ..()

/datum/action/item_action/stickmen/proc/give_infos(atom/source, mob/user, list/examine_list)
	examine_list += "<span class='notice'>Making sure you are properly wearing or holding it, \
					point at whatever you want to rally your minions to its position."
	examine_list += "While on <b>harm</b> intent, pointed mobs (minus you and the minions) \
					 will also be marked as foes for your minions to attack for the next 2 minutes.</span>"

/datum/action/item_action/stickmen/Grant(mob/M)
	. = ..()
	if(owner)
		RegisterSignal(M, COMSIG_MOB_POINTED, PROC_REF(rally))
	if(book_of_grudges[M]) //Stop attacking your new master.
		book_of_grudges -= M
		for(var/A in summoned_stickmen)
			var/mob/living/simple_animal/hostile/S = A
			if(!S.mind)
				S.LoseTarget()


/datum/action/item_action/stickmen/Remove(mob/M)
	. = ..()
	UnregisterSignal(M, COMSIG_MOB_POINTED)

/datum/action/item_action/stickmen/Trigger()
	. = ..()
	if(!.)
		return
	if(!ready)
		to_chat(owner, "<span class='warning'>[src]'s internal magic supply is still recharging!</span>")
		return FALSE
	var/summon = TRUE
	if(length(summoned_stickmen) >= max_stickmen)
		var/mob/living/simple_animal/hostile/S = popleft(summoned_stickmen)
		if(!S.client)
			qdel(S)
		else
			S.forceMove(owner.drop_location())
			S.revive(TRUE)
			summoned_stickmen[S] = TRUE
			summon = FALSE

	owner.say("Rise, my creation! Off your page into this realm!", forced = "stickman summoning")
	playsound(owner, 'sound/magic/summon_magic.ogg', 50, 1, 1)
	if(summon)
		var/mob/living/simple_animal/hostile/S = new summoned_mob_path (get_turf(usr))
		S.faction = owner.faction
		S.foes = book_of_grudges
		RegisterSignal(S, COMSIG_PARENT_QDELETING, PROC_REF(remove_from_list))
	ready = FALSE
	addtimer(CALLBACK(src, PROC_REF(ready_again)), cooldown)

/datum/action/item_action/stickmen/proc/remove_from_list(datum/source, forced)
	summoned_stickmen -= source

/datum/action/item_action/stickmen/proc/ready_again()
	ready = TRUE
	if(owner)
		to_chat(owner, "<span class='notice'>[src] hums, its internal magic supply restored.</span>")

/**
  * Rallies your army of stickmen to whichever target the user is pointing.
  * Should the user be on harm intent and the target be a living mob that's not the user or a fellow stickman,
  * said target will be added to a list of foes which the stickmen will gladly dispose regardless of faction.
  * This is designed so stickmen will move toward whatever you point at even when you don't want to, that's the downside.
  */
/datum/action/item_action/stickmen/proc/rally(mob/source, atom/A)
	var/turf/T = get_turf(A)
	var/list/surrounding_turfs = block(locate(T.x - 1, T.y - 1, T.z), locate(T.x + 1, T.y + 1, T.z))
	if(!surrounding_turfs.len)
		return
	if(source.a_intent == INTENT_HARM && A != source && !summoned_stickmen[A])
		var/mob/living/L
		if(isliving(A)) //Gettem boys!
			L = A
		else if(ismecha(A))
			var/obj/vehicle/sealed/mecha/M = A
			L = pick(M.occupants)
		if(L && L.stat != DEAD && !HAS_TRAIT(L, TRAIT_DEATHCOMA)) //Taking revenge on the deads would be proposterous.
			addtimer(CALLBACK(src, PROC_REF(clear_grudge), L), 2 MINUTES, TIMER_OVERRIDE|TIMER_UNIQUE)
			if(!book_of_grudges[L])
				RegisterSignal(L, list(COMSIG_PARENT_QDELETING, COMSIG_MOB_DEATH), PROC_REF(grudge_settled))
				book_of_grudges[L] = TRUE
	for(var/k in summoned_stickmen) //Shamelessly copied from the blob rally power
		var/mob/living/simple_animal/hostile/S = k
		if(!S.mind && isturf(S.loc) && get_dist(S, T) <= 10)
			S.LoseTarget()
			S.Goto(pick(surrounding_turfs), S.move_to_delay)

/datum/action/item_action/stickmen/proc/clear_grudge(mob/living/L)
	if(!QDELETED(L))
		book_of_grudges -= L

/datum/action/item_action/stickmen/proc/grudge_settled(mob/living/L)
	UnregisterSignal(L, list(COMSIG_PARENT_QDELETING, COMSIG_MOB_DEATH))
	book_of_grudges -= L

//Shielded Armour

/obj/item/clothing/suit/space/hardsuit/shielded/wizard
	name = "battlemage armour"
	desc = "Not all wizards are afraid of getting up close and personal."
	icon_state = "battlemage"
	item_state = "battlemage"
	recharge_rate = 0
	max_charges = INFINITY
	current_charges = 15
	shield_state = "shield-red"
	min_cold_protection_temperature = ARMOR_MIN_TEMP_PROTECT
	max_heat_protection_temperature = ARMOR_MAX_TEMP_PROTECT
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/shielded/wizard
	armor = list(MELEE = 30, BULLET = 20, LASER = 20, ENERGY = 20, BOMB = 20, BIO = 20, RAD = 20, FIRE = 100, ACID = 100)
	slowdown = 0
	resistance_flags = FIRE_PROOF | ACID_PROOF

/obj/item/clothing/suit/space/hardsuit/shielded/wizard/ComponentInitialize()
	. = ..()
	AddElement(/datum/element/spellcasting, SPELL_WIZARD_ROBE, ITEM_SLOT_OCLOTHING)

/obj/item/clothing/head/helmet/space/hardsuit/shielded/wizard
	name = "battlemage helmet"
	desc = "A suitably impressive helmet.."
	icon_state = "battlemage"
	item_state = "battlemage"
	min_cold_protection_temperature = ARMOR_MIN_TEMP_PROTECT
	max_heat_protection_temperature = ARMOR_MAX_TEMP_PROTECT
	armor = list(MELEE = 30, BULLET = 20, LASER = 20, ENERGY = 20, BOMB = 20, BIO = 20, RAD = 20, FIRE = 100, ACID = 100)
	actions_types = null //No inbuilt light
	resistance_flags = FIRE_PROOF | ACID_PROOF

/obj/item/clothing/head/helmet/space/hardsuit/shielded/wizard/ComponentInitialize()
	. = ..()
	AddElement(/datum/element/spellcasting, SPELL_WIZARD_HAT, ITEM_SLOT_HEAD)

/obj/item/clothing/head/helmet/space/hardsuit/shielded/wizard/attack_self(mob/user)
	return

/obj/item/wizard_armour_charge
	name = "battlemage shield charges"
	desc = "A powerful rune that will increase the number of hits a suit of battlemage armour can take before failing.."
	icon = 'icons/effects/effects.dmi'
	icon_state = "electricity2"

/obj/item/wizard_armour_charge/afterattack(obj/item/clothing/suit/space/hardsuit/shielded/wizard/W, mob/user)
	. = ..()
	if(!istype(W))
		to_chat(user, "<span class='warning'>The rune can only be used on battlemage armour!</span>")
		return
	var/datum/component/shielded/S = GetComponent(/datum/component/shielded)
	S.adjust_charges(8)
	to_chat(user, "<span class='notice'>You charge \the [W]. It can now absorb [S.charges] hits.</span>")
	qdel(src)
