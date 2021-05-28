/obj/item/clothing/shoes/proc/step_action() //this was made to rewrite clown shoes squeaking
	SEND_SIGNAL(src, COMSIG_SHOES_STEP_ACTION)

/obj/item/clothing/shoes/sneakers/mime
	name = "mime shoes"
	icon_state = "mime"

/obj/item/clothing/shoes/combat //basic syndicate combat boots for nuke ops and mob corpses
	name = "combat boots"
	desc = "High speed, low drag combat boots."
	icon_state = "combat"
	item_state = "jackboots"
	lefthand_file = 'icons/mob/inhands/equipment/security_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/security_righthand.dmi'
	armor = list("melee" = 25, "bullet" = 25, "laser" = 25, "energy" = 25, "bomb" = 50, "bio" = 10, "rad" = 0, "fire" = 70, "acid" = 50)
	strip_delay = 70
	resistance_flags = NONE
	permeability_coefficient = 0.05 //Thick soles, and covers the ankle
	pocket_storage_component_path = /datum/component/storage/concrete/pockets/shoes
	lace_time = 12 SECONDS

/obj/item/clothing/shoes/combat/sneakboots
	name = "insidious sneakboots"
	desc = "A pair of insidious boots with special noise muffling soles which very slightly drown out your footsteps. They would be absolutely perfect for stealth operations were it not for the iconic Syndicate flairs."
	icon_state = "sneakboots"
	item_state = "sneakboots"
	resistance_flags = FIRE_PROOF |  ACID_PROOF

/obj/item/clothing/shoes/combat/sneakboots/equipped(mob/user, slot)
	. = ..()
	if(slot == SLOT_SHOES)
		ADD_TRAIT(user, TRAIT_SILENT_STEP, SHOES_TRAIT)

/obj/item/clothing/shoes/combat/sneakboots/dropped(mob/user)
	. = ..()
	REMOVE_TRAIT(user, TRAIT_SILENT_STEP, SHOES_TRAIT)

/obj/item/clothing/shoes/combat/swat //overpowered boots for death squads
	name = "\improper SWAT boots"
	desc = "High speed, no drag combat boots."
	permeability_coefficient = 0.01
	clothing_flags = NOSLIP
	armor = list("melee" = 40, "bullet" = 30, "laser" = 25, "energy" = 25, "bomb" = 50, "bio" = 30, "rad" = 30, "fire" = 90, "acid" = 50)

/obj/item/clothing/shoes/sandal
	desc = "A pair of rather plain wooden sandals."
	name = "sandals"
	icon_state = "wizard"
	custom_materials = list(/datum/material/wood = MINERAL_MATERIAL_AMOUNT * 0.5)
	strip_delay = 50
	equip_delay_other = 50
	permeability_coefficient = 0.9
	can_be_tied = FALSE

/obj/item/clothing/shoes/sandal/marisa
	desc = "A pair of magic black shoes."
	name = "magic shoes"
	icon_state = "black"
	resistance_flags = FIRE_PROOF |  ACID_PROOF

/obj/item/clothing/shoes/sandal/magic
	name = "magical sandals"
	desc = "A pair of sandals imbued with magic."
	resistance_flags = FIRE_PROOF |  ACID_PROOF

/obj/item/clothing/shoes/galoshes
	desc = "A pair of yellow rubber boots, designed to prevent slipping on wet surfaces."
	name = "galoshes"
	icon_state = "galoshes"
	permeability_coefficient = 0.01
	clothing_flags = NOSLIP
	slowdown = SHOES_SLOWDOWN+1
	strip_delay = 50
	equip_delay_other = 50
	resistance_flags = NONE
	armor = list("melee" = 0, "bullet" = 0, "laser" = 0, "energy" = 0, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 40, "acid" = 75)
	custom_price = PRICE_ABOVE_EXPENSIVE
	can_be_tied = FALSE

/obj/item/clothing/shoes/galoshes/dry
	name = "absorbent galoshes"
	desc = "A pair of orange rubber boots, designed to prevent slipping on wet surfaces while also drying them."
	icon_state = "galoshes_dry"

/obj/item/clothing/shoes/sneakers/noslip
	desc = "A pair of black shoes, they have the soles of galoshes making them unable to be slipped on a wet surface."
	name = "black shoes"
	icon_state = "black"
	permeability_coefficient = 0.30
	clothing_flags = NOSLIP
	strip_delay = 50
	equip_delay_other = 50
	resistance_flags = NONE

/obj/item/clothing/shoes/galoshes/dry/step_action()
	var/turf/open/t_loc = get_turf(src)
	SEND_SIGNAL(t_loc, COMSIG_TURF_MAKE_DRY, TURF_WET_WATER, TRUE, INFINITY)

/obj/item/clothing/shoes/clown_shoes
	desc = "The prankster's standard-issue clowning shoes. Damn, they're huge! Ctrl-click to toggle waddle dampeners."
	name = "clown shoes"
	icon_state = "clown_shoes"
	slowdown = SHOES_SLOWDOWN+1
	pocket_storage_component_path = /datum/component/storage/concrete/pockets/shoes/clown
	lace_time = 20 SECONDS // how the hell do these laces even work??
	var/datum/component/waddle
	var/enabled_waddle = TRUE

/obj/item/clothing/shoes/clown_shoes/Initialize()
	. = ..()
	AddComponent(/datum/component/squeak, list('sound/effects/clownstep1.ogg'=1,'sound/effects/clownstep2.ogg'=1), 50)

/obj/item/clothing/shoes/clown_shoes/equipped(mob/user, slot)
	. = ..()
	if(slot == SLOT_SHOES)
		if(enabled_waddle)
			waddle = user.AddComponent(/datum/component/waddling)
		if(user.mind && HAS_TRAIT(user.mind, TRAIT_CLOWN_MENTALITY))
			SEND_SIGNAL(user, COMSIG_CLEAR_MOOD_EVENT, "noshoes")

/obj/item/clothing/shoes/clown_shoes/dropped(mob/user)
	. = ..()
	QDEL_NULL(waddle)
	if(user.mind && HAS_TRAIT(user.mind, TRAIT_CLOWN_MENTALITY))
		SEND_SIGNAL(user, COMSIG_ADD_MOOD_EVENT, "noshoes", /datum/mood_event/noshoes)

/obj/item/clothing/shoes/clown_shoes/CtrlClick(mob/living/user)
	if(!isliving(user))
		return
	if(user.get_active_held_item() != src)
		to_chat(user, "<span class='warning'>You must hold the [src] in your hand to do this!</span>")
		return
	if (!enabled_waddle)
		to_chat(user, "<span class='notice'>You switch off the waddle dampeners!</span>")
		enabled_waddle = TRUE
	else
		to_chat(user, "<span class='notice'>You switch on the waddle dampeners!</span>")
		enabled_waddle = FALSE

/obj/item/clothing/shoes/clown_shoes/jester
	name = "jester shoes"
	desc = "A court jester's shoes, updated with modern squeaking technology."
	icon_state = "jester_shoes"

/obj/item/clothing/shoes/jackboots
	name = "jackboots"
	desc = "Nanotrasen-issue Security combat boots for combat scenarios or combat situations. All combat, all the time."
	icon_state = "jackboots"
	lefthand_file = 'icons/mob/inhands/equipment/security_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/security_righthand.dmi'
	strip_delay = 50
	equip_delay_other = 50
	resistance_flags = NONE
	permeability_coefficient = 0.05 //Thick soles, and covers the ankle
	pocket_storage_component_path = /datum/component/storage/concrete/pockets/shoes
	lace_time = 12 SECONDS

/obj/item/clothing/shoes/jackboots/fast
	slowdown = -1

/obj/item/clothing/shoes/winterboots
	name = "winter boots"
	desc = "Boots lined with 'synthetic' animal fur."
	icon_state = "winterboots"
	permeability_coefficient = 0.15
	cold_protection = FEET|LEGS
	min_cold_protection_temperature = SHOES_MIN_TEMP_PROTECT
	heat_protection = FEET|LEGS
	max_heat_protection_temperature = SHOES_MAX_TEMP_PROTECT
	pocket_storage_component_path = /datum/component/storage/concrete/pockets/shoes
	lace_time = 8 SECONDS

/obj/item/clothing/shoes/winterboots/ice_boots
	name = "ice hiking boots"
	desc = "A pair of winter boots with special grips on the bottom, designed to prevent slipping on frozen surfaces."
	icon_state = "iceboots"
	item_state = "iceboots"
	clothing_flags = NOSLIP_ICE

/obj/item/clothing/shoes/winterboots/christmasbootsr
	name = "red christmas boots"
	desc = "A pair of fluffy red christmas boots!"
	icon_state = "christmasbootsr"

/obj/item/clothing/shoes/winterboots/christmasbootsg
	name = "green christmas boots"
	desc = "A pair of fluffy green christmas boots!"
	icon_state = "christmasbootsg"

/obj/item/clothing/shoes/winterboots/santaboots
	name = "santa boots"
	desc = "A pair of santa boots! How traditional!!"
	icon_state = "santaboots"

/obj/item/clothing/shoes/workboots
	name = "work boots"
	desc = "Nanotrasen-issue Engineering lace-up work boots for the especially blue-collar."
	icon_state = "workboots"
	lefthand_file = 'icons/mob/inhands/equipment/security_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/security_righthand.dmi'
	permeability_coefficient = 0.15
	strip_delay = 40
	equip_delay_other = 40
	pocket_storage_component_path = /datum/component/storage/concrete/pockets/shoes
	lace_time = 8 SECONDS

/obj/item/clothing/shoes/workboots/mining
	name = "mining boots"
	desc = "Steel-toed mining boots for mining in hazardous environments. Very good at keeping toes uncrushed."
	icon_state = "explorer"
	cold_protection = FEET|LEGS
	min_cold_protection_temperature = SHOES_MIN_TEMP_PROTECT
	heat_protection = FEET|LEGS
	max_heat_protection_temperature = SHOES_MAX_TEMP_PROTECT
	resistance_flags = FIRE_PROOF

/obj/item/clothing/shoes/cult
	name = "\improper Nar'Sien invoker boots"
	desc = "A pair of boots worn by the followers of Nar'Sie."
	icon_state = "cult"
	cold_protection = FEET
	min_cold_protection_temperature = SHOES_MIN_TEMP_PROTECT
	heat_protection = FEET
	max_heat_protection_temperature = SHOES_MAX_TEMP_PROTECT
	lace_time = 10 SECONDS

/obj/item/clothing/shoes/cult/alt
	name = "cultist boots"
	icon_state = "cultalt"

/obj/item/clothing/shoes/cult/alt/ghost
	item_flags = DROPDEL

/obj/item/clothing/shoes/cult/alt/ghost/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, CULT_TRAIT)

/obj/item/clothing/shoes/cyborg
	name = "cyborg boots"
	desc = "Shoes for a cyborg costume."
	icon_state = "boots"

/obj/item/clothing/shoes/laceup
	name = "laceup shoes"
	desc = "The height of fashion, and they're pre-polished!"
	icon_state = "laceups"
	equip_delay_other = 50

/obj/item/clothing/shoes/roman
	name = "roman sandals"
	desc = "Sandals with buckled leather straps on it."
	icon_state = "roman"
	strip_delay = 100
	equip_delay_other = 100
	permeability_coefficient = 0.9
	can_be_tied = FALSE

/obj/item/clothing/shoes/griffin
	name = "griffon boots"
	desc = "A pair of costume boots fashioned after bird talons."
	icon_state = "griffinboots"
	pocket_storage_component_path = /datum/component/storage/concrete/pockets/shoes
	lace_time = 8 SECONDS

/obj/item/clothing/shoes/bhop
	name = "jump boots"
	desc = "A specialized pair of combat boots with a built-in propulsion system for rapid foward movement."
	icon_state = "jetboots"
	resistance_flags = FIRE_PROOF
	pocket_storage_component_path = /datum/component/storage/concrete/pockets/shoes
	actions_types = list(/datum/action/item_action/bhop)
	permeability_coefficient = 0.05
	var/jumpdistance = 5 //-1 from to see the actual distance, e.g 4 goes over 3 tiles
	var/jumpspeed = 3
	var/recharging_rate = 60 //default 6 seconds between each dash
	var/recharging_time = 0 //time until next dash
	var/jumping = FALSE //are we mid-jump?

/obj/item/clothing/shoes/bhop/ui_action_click(mob/user, action)
	if(!isliving(user))
		return

	if(jumping)
		return

	if(recharging_time > world.time)
		to_chat(user, "<span class='warning'>The boot's internal propulsion needs to recharge still!</span>")
		return

	var/atom/target = get_edge_target_turf(user, user.dir) //gets the user's direction

	if (user.throw_at(target, jumpdistance, jumpspeed, spin = FALSE, diagonals_first = TRUE))
		playsound(src, 'sound/effects/stealthoff.ogg', 50, 1, 1)
		recharging_time = world.time + recharging_rate
		user.visible_message("<span class='warning'>[usr] dashes forward into the air!</span>")
	else
		to_chat(user, "<span class='warning'>Something prevents you from dashing forward!</span>")

/obj/item/clothing/shoes/singery
	name = "yellow performer's boots"
	desc = "These boots were made for dancing."
	icon_state = "ysing"
	equip_delay_other = 50

/obj/item/clothing/shoes/singerb
	name = "blue performer's boots"
	desc = "These boots were made for dancing."
	icon_state = "bsing"
	equip_delay_other = 50

/obj/item/clothing/shoes/bronze
	name = "bronze boots"
	desc = "A giant, clunky pair of shoes crudely made out of bronze. Why would anyone wear these?"
	icon = 'icons/obj/clothing/clockwork_garb.dmi'
	icon_state = "clockwork_treads"
	lace_time = 8 SECONDS

/obj/item/clothing/shoes/bronze/Initialize()
	. = ..()
	AddComponent(/datum/component/squeak, list('sound/machines/clockcult/integration_cog_install.ogg' = 1, 'sound/magic/clockwork/fellowship_armory.ogg' = 1), 50)

/obj/item/clothing/shoes/wheelys
	name = "Wheely-Heels"
	desc = "Uses patented retractable wheel technology. Never sacrifice speed for style - not that this provides much of either." //Thanks Fel
	icon_state = "wheelys"
	actions_types = list(/datum/action/item_action/wheelys)
	var/wheelToggle = FALSE //False means wheels are not popped out
	var/obj/vehicle/ridden/scooter/wheelys/W

/obj/item/clothing/shoes/wheelys/Initialize()
	. = ..()
	W = new /obj/vehicle/ridden/scooter/wheelys(null)

/obj/item/clothing/shoes/wheelys/ui_action_click(mob/user, action)
	if(!isliving(user))
		return
	if(!istype(user.get_item_by_slot(SLOT_SHOES), /obj/item/clothing/shoes/wheelys))
		to_chat(user, "<span class='warning'>You must be wearing the wheely-heels to use them!</span>")
		return
	if(!(W.is_occupant(user)))
		wheelToggle = FALSE
	if(wheelToggle)
		W.unbuckle_mob(user)
		wheelToggle = FALSE
		return
	W.forceMove(get_turf(user))
	W.buckle_mob(user)
	wheelToggle = TRUE

/obj/item/clothing/shoes/wheelys/dropped(mob/user)
	if(wheelToggle)
		W.unbuckle_mob(user)
		wheelToggle = FALSE
	..()

/obj/item/clothing/shoes/wheelys/Destroy()
	QDEL_NULL(W)
	. = ..()

/obj/item/clothing/shoes/kindleKicks
	name = "Kindle Kicks"
	desc = "They'll sure kindle something in you, and it's not childhood nostalgia..."
	icon_state = "kindleKicks"
	actions_types = list(/datum/action/item_action/kindleKicks)
	var/lightCycle = 0
	var/active = FALSE

/obj/item/clothing/shoes/kindleKicks/ui_action_click(mob/user, action)
	if(active)
		return
	active = TRUE
	set_light(2, 3, rgb(rand(0,255),rand(0,255),rand(0,255)))
	addtimer(CALLBACK(src, .proc/lightUp), 5)

/obj/item/clothing/shoes/kindleKicks/proc/lightUp(mob/user)
	if(lightCycle < 15)
		set_light(2, 3, rgb(rand(0,255),rand(0,255),rand(0,255)))
		lightCycle += 1
		addtimer(CALLBACK(src, .proc/lightUp), 5)
	else
		set_light(0)
		lightCycle = 0
		active = FALSE

/obj/item/clothing/shoes/russian
	name = "russian boots"
	desc = "Comfy shoes."
	icon_state = "rus_shoes"
	item_state = "rus_shoes"
	pocket_storage_component_path = /datum/component/storage/concrete/pockets/shoes
	lace_time = 8 SECONDS

// kevin is into feet
/obj/item/clothing/shoes/wraps
	name = "gilded leg wraps"
	desc = "Ankle coverings. These ones have a golden design."
	icon_state = "gildedcuffs"
	body_parts_covered = FALSE
	can_be_tied = FALSE

/obj/item/clothing/shoes/wraps/silver
	name = "silver leg wraps"
	desc = "Ankle coverings. Not made of real silver."
	icon_state = "silvergildedcuffs"

/obj/item/clothing/shoes/wraps/red
	name = "red leg wraps"
	desc = "Ankle coverings. Show off your style with these shiny red ones!"
	icon_state = "redcuffs"

/obj/item/clothing/shoes/wraps/blue
	name = "blue leg wraps"
	desc = "Ankle coverings. Hang ten, brother."
	icon_state = "bluecuffs"

/obj/item/clothing/shoes/cowboyboots
	name = "cowboy boots"
	desc = "A standard pair of brown cowboy boots."
	icon_state = "cowboyboots"
	can_be_tied = FALSE

/obj/item/clothing/shoes/cowboyboots/black
	name = "black cowboy boots"
	desc = "A pair of black cowboy boots, pretty easy to scuff up."
	icon_state = "cowboyboots_black"

/obj/item/clothing/shoes/wallwalkers
	name = "wall walking boots"
	desc = "Contrary to popular belief, these do not allow you to walk on walls. Through bluespace magic stolen from an organisation that hoards technology, they simply allow you to slip through the atoms that make up anything, but only while walking, for safety reasons. As well as this, they unfortunately cause minor breath loss as the majority of atoms in your lungs are sucked out into any solid object you walk through. Make sure not to overuse them."
	icon_state = "walkboots"
	var/walkcool = 0
	var/wallcharges = 4
	var/newlocobject = null

/obj/item/clothing/shoes/timidcostume
	name = "timid woman boots"
	desc = "Ready to rock your hips back and forth? These boots have a polychromic finish."
	icon_state = "timidwoman"
	item_state = "timidwoman"

/obj/item/clothing/shoes/timidcostume/ComponentInitialize()
	. = ..()
	AddElement(/datum/element/polychromic, list("#0094FF"), 1)

/obj/item/clothing/shoes/timidcostume/man
	name = "timid man shoes"
	desc = "Ready to go kart racing? These shoes have a polychromic finish."
	icon_state = "timidman"
	item_state = "timidman"

/obj/item/clothing/shoes/wallwalkers/equipped(mob/user,slot)
	. = ..()
	if(slot == SLOT_SHOES)
		RegisterSignal(user, COMSIG_MOB_CLIENT_MOVE,.proc/intercept_user_move)

/obj/item/clothing/shoes/wallwalkers/dropped(mob/user)
	. = ..()
	UnregisterSignal(user, COMSIG_MOB_CLIENT_MOVE)

/obj/item/clothing/shoes/wallwalkers/attackby(obj/item/W, mob/user, params)
	. = ..()
	if(!istype(W, /obj/item/bluespacerecharge))
		return
	var/obj/item/bluespacerecharge/ER = W
	if(ER.uses)
		wallcharges += ER.uses
		to_chat(user, "<span class='notice'>You charged the bluespace crystal in the [src]. It now has [wallcharges] charges left.</span>")
		ER.uses = 0
		ER.icon_state = "[initial(ER.icon_state)]0"
	else
		to_chat(user, "<span class='warning'>[ER] has no crystal on it.</span>")

/obj/item/clothing/shoes/wallwalkers/examine(mob/user)
	. = ..()
	. += "<span class='warning'>It has [wallcharges] charges left.</span>"

/obj/item/clothing/shoes/wallwalkers/proc/intercept_user_move(mob/living/m, client/client, dir, newloc, oldloc)
	if (walkcool >= world.time || m.m_intent != MOVE_INTENT_WALK || wallcharges <= 0)
		return
	walkcool = world.time + m.movement_delay()
	var/issolid = FALSE
	var/turf/K = newloc
	if (istype(K))
		if (K.density)
			issolid = TRUE
	if (!issolid)
		for (var/atom/T in newloc) //stuff on the new turf
			if (!T.CanPass(m,newloc) && T != m)
				issolid = TRUE
				newlocobject = T
				break
		if (!issolid)
			for (var/atom/T in oldloc) //directional shit on the old turf
				if (!T.CanPass(m,newloc) && T != m && T != newlocobject)
					issolid = TRUE
					break
			newlocobject = null //stopping structures from using two charges because of how shitty the canpass code is
	m.forceMove(newloc)
	if (!issolid)
		return
	m.adjustOxyLoss(rand(5,13))
	if (prob(15))
		m.adjustBruteLoss(rand(4,7))
		to_chat(m,"<span class='warning'>You feel as if travelling through the solid object left something behind and it hurts!</span>")
	var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
	s.set_up(5, 1, oldloc)
	s.start()
	flash_lighting_fx(3, 3, LIGHT_COLOR_ORANGE)
	wallcharges--

/obj/item/bluespacerecharge
	name = "bluespace crystal recharging device"
	desc = "A small cell with two prongs lazily jabbed into it. It looks like it's made for replacing the crystals in bluespace devices."
	icon = 'icons/obj/module.dmi'
	icon_state = "bluespace_charge"
	item_flags = NOBLUDGEON
	w_class = WEIGHT_CLASS_TINY
	var/uses = 6

/obj/item/bluespacerecharge/examine(mob/user)
	. = ..()
	if(uses)
		. += "<span class='notice'>It can add up to [uses] charges to compatible devices.</span>"
	else
		. += "<span class='warning'>The crystal is gone.</span>"

/obj/item/bluespacerecharge/attackby(obj/item/I, mob/user, params)
	..()
	if(!istype(I, /obj/item/stack/ore/bluespace_crystal) || uses)
		return
	var/obj/item/stack/ore/bluespace_crystal/B = I
	if (B.amount < 10)
		return
	uses += 3
	to_chat(user, "<span class='notice'>You insert [I] into [src].</span>")
	B.use(10)
	icon_state = initial(icon_state)

/obj/item/clothing/shoes/swagshoes
	name = "swag shoes"
	desc = "They got me for my foams!"
	icon_state = "SwagShoes"
	item_state = "SwagShoes"
