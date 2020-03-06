#define STUNBATON_CHARGE_LENIENCY 0.3
#define STUNBATON_DEPLETION_RATE 0.006

/obj/item/melee/baton
	name = "stunbaton"
	desc = "A stun baton for incapacitating people with."
	icon_state = "stunbaton"
	item_state = "baton"
	lefthand_file = 'icons/mob/inhands/equipment/security_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/security_righthand.dmi'
	slot_flags = ITEM_SLOT_BELT
	force = 10
	throwforce = 7
	w_class = WEIGHT_CLASS_NORMAL
	attack_verb = list("beaten")
	armor = list("melee" = 0, "bullet" = 0, "laser" = 0, "energy" = 0, "bomb" = 50, "bio" = 0, "rad" = 0, "fire" = 80, "acid" = 80)

	var/stamforce = 25
	var/status = FALSE
	var/knockdown = TRUE
	var/obj/item/stock_parts/cell/cell
	var/hitcost = 750
	var/throw_hit_chance = 35
	var/preload_cell_type //if not empty the baton starts with this type of cell

/obj/item/melee/baton/examine(mob/user)
	. = ..()
	. += "<span class='notice'>Right click attack while in combat mode to disarm instead of stun.</span>"

/obj/item/melee/baton/get_cell()
	. = cell
	if(iscyborg(loc))
		var/mob/living/silicon/robot/R = loc
		. = R.get_cell()

/obj/item/melee/baton/suicide_act(mob/user)
	user.visible_message("<span class='suicide'>[user] is putting the live [name] in [user.p_their()] mouth! It looks like [user.p_theyre()] trying to commit suicide!</span>")
	return (FIRELOSS)

/obj/item/melee/baton/Initialize(mapload)
	. = ..()
	if(preload_cell_type)
		if(!ispath(preload_cell_type,/obj/item/stock_parts/cell))
			log_mapping("[src] at [AREACOORD(src)] had an invalid preload_cell_type: [preload_cell_type].")
		else
			cell = new preload_cell_type(src)
	update_icon()

/obj/item/melee/baton/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	..()
	//Only mob/living types have stun handling
	if(status && prob(throw_hit_chance) && iscarbon(hit_atom))
		baton_stun(hit_atom)

/obj/item/melee/baton/loaded //this one starts with a cell pre-installed.
	preload_cell_type = /obj/item/stock_parts/cell/high/plus

/obj/item/melee/baton/proc/deductcharge(chrgdeductamt, chargecheck = TRUE, explode = TRUE)
	var/obj/item/stock_parts/cell/copper_top = get_cell()
	if(!copper_top)
		switch_status(FALSE, TRUE)
		return FALSE
	//Note this value returned is significant, as it will determine
	//if a stun is applied or not

	copper_top.use(min(chrgdeductamt, copper_top.charge), explode)
	if(QDELETED(src))
		return FALSE
	if(status && (!copper_top || !copper_top.charge || (chargecheck && copper_top.charge < (hitcost * STUNBATON_CHARGE_LENIENCY))))
		//we're below minimum, turn off
		switch_status(FALSE)

/obj/item/melee/baton/proc/switch_status(new_status = FALSE, silent = FALSE)
	if(status != new_status)
		status = new_status
		if(!silent)
			playsound(loc, "sparks", 75, 1, -1)
		if(status)
			START_PROCESSING(SSobj, src)
		else
			STOP_PROCESSING(SSobj, src)
	update_icon()

/obj/item/melee/baton/process()
	deductcharge(round(hitcost * STUNBATON_DEPLETION_RATE), FALSE, FALSE)

/obj/item/melee/baton/update_icon_state()
	if(status)
		icon_state = "[initial(name)]_active"
	else if(!cell)
		icon_state = "[initial(name)]_nocell"
	else
		icon_state = "[initial(name)]"

/obj/item/melee/baton/examine(mob/user)
	. = ..()
	var/obj/item/stock_parts/cell/copper_top = get_cell()
	if(copper_top)
		. += "<span class='notice'>\The [src] is [round(copper_top.percent())]% charged.</span>"
	else
		. += "<span class='warning'>\The [src] does not have a power source installed.</span>"

/obj/item/melee/baton/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/stock_parts/cell))
		var/obj/item/stock_parts/cell/C = W
		if(cell)
			to_chat(user, "<span class='notice'>[src] already has a cell.</span>")
		else
			if(C.maxcharge < (hitcost * STUNBATON_CHARGE_LENIENCY))
				to_chat(user, "<span class='notice'>[src] requires a higher capacity cell.</span>")
				return
			if(!user.transferItemToLoc(W, src))
				return
			cell = W
			to_chat(user, "<span class='notice'>You install a cell in [src].</span>")
			update_icon()

	else if(istype(W, /obj/item/screwdriver))
		if(cell)
			cell.update_icon()
			cell.forceMove(get_turf(src))
			cell = null
			to_chat(user, "<span class='notice'>You remove the cell from [src].</span>")
			switch_status(FALSE, TRUE)
	else
		return ..()

/obj/item/melee/baton/attack_self(mob/user)
	var/obj/item/stock_parts/cell/copper_top = get_cell()
	if(!copper_top || copper_top.charge < (hitcost * STUNBATON_CHARGE_LENIENCY))
		switch_status(FALSE, TRUE)
		if(!copper_top)
			to_chat(user, "<span class='warning'>[src] does not have a power source!</span>")
		else
			to_chat(user, "<span class='warning'>[src] is out of charge.</span>")
	else
		switch_status(!status)
		to_chat(user, "<span class='notice'>[src] is now [status ? "on" : "off"].</span>")
	add_fingerprint(user)

/obj/item/melee/baton/attack(mob/M, mob/living/carbon/human/user)
	var/interrupt = common_baton_melee(M, user, FALSE)
	if(!interrupt)
		..()

/obj/item/melee/baton/alt_pre_attack(atom/A, mob/living/user, params)
	. = common_baton_melee(A, user, TRUE)		//return true (attackchain interrupt) if this also returns true. no harm-disarming.
	user.changeNext_move(CLICK_CD_MELEE)

//return TRUE to interrupt attack chain.
/obj/item/melee/baton/proc/common_baton_melee(mob/M, mob/living/user, disarming = FALSE)
	if(iscyborg(M) || !isliving(M))		//can't baton cyborgs
		return FALSE
	if(status && HAS_TRAIT(user, TRAIT_CLUMSY) && prob(50))
		clowning_around(user)
	if(user.getStaminaLoss() >= STAMINA_SOFTCRIT)			//CIT CHANGE - makes it impossible to baton in stamina softcrit
		to_chat(user, "<span class='danger'>You're too exhausted for that.</span>")
		return TRUE
	if(ishuman(M))
		var/mob/living/carbon/human/L = M
		if(check_martial_counter(L, user))
			return TRUE
	if(status)
		if(baton_stun(M, user, disarming))
			user.do_attack_animation(M)
			user.adjustStaminaLossBuffered(getweight())		//CIT CHANGE - makes stunbatonning others cost stamina
	else if(user.a_intent != INTENT_HARM)			//they'll try to bash in the last proc.
		M.visible_message("<span class='warning'>[user] has prodded [M] with [src]. Luckily it was off.</span>", \
						"<span class='warning'>[user] has prodded you with [src]. Luckily it was off</span>")
	return disarming || (user.a_intent != INTENT_HARM)

/obj/item/melee/baton/proc/baton_stun(mob/living/L, mob/user, disarming = FALSE)
	if(L.check_shields(src, 0, "[user]'s [name]", MELEE_ATTACK)) //No message; check_shields() handles that
		playsound(L, 'sound/weapons/genhit.ogg', 50, 1)
		return FALSE
	var/stunpwr = stamforce
	var/obj/item/stock_parts/cell/our_cell = get_cell()
	if(!our_cell)
		switch_status(FALSE)
		return FALSE
	var/stuncharge = our_cell.charge
	deductcharge(hitcost, FALSE)
	if(QDELETED(src) || QDELETED(our_cell)) //it was rigged
		return FALSE
	if(stuncharge < hitcost)
		if(stuncharge < (hitcost * STUNBATON_CHARGE_LENIENCY))
			L.visible_message("<span class='warning'>[user] has prodded [L] with [src]. Luckily it was out of charge.</span>", \
							"<span class='warning'>[user] has prodded you with [src]. Luckily it was out of charge.</span>")
			return FALSE
		stunpwr *= round(stuncharge/hitcost, 0.1)

	if(!disarming)
		if(knockdown)
			L.DefaultCombatKnockdown(50, override_stamdmg = 0)		//knockdown
		L.adjustStaminaLoss(stunpwr)
	else
		L.drop_all_held_items()					//no knockdown/stamina damage, instead disarm.

	L.apply_effect(EFFECT_STUTTER, stamforce)
	SEND_SIGNAL(L, COMSIG_LIVING_MINOR_SHOCK)
	if(user)
		L.lastattacker = user.real_name
		L.lastattackerckey = user.ckey
		L.visible_message("<span class='danger'>[user] has [disarming? "disarmed" : "stunned"] [L] with [src]!</span>", \
								"<span class='userdanger'>[user] has [disarming? "disarmed" : "stunned"] you with [src]!</span>")
		log_combat(user, L, disarming? "disarmed" : "stunned")

	playsound(loc, 'sound/weapons/egloves.ogg', 50, 1, -1)

	if(ishuman(L))
		var/mob/living/carbon/human/H = L
		H.forcesay(GLOB.hit_appends)


	return TRUE

/obj/item/melee/baton/proc/clowning_around(mob/living/user)
	user.visible_message("<span class='danger'>[user] accidentally hits [user.p_them()]self with [src]!</span>", \
						"<span class='userdanger'>You accidentally hit yourself with [src]!</span>")
	SEND_SIGNAL(user, COMSIG_LIVING_MINOR_SHOCK)
	user.DefaultCombatKnockdown(stamforce*6)
	playsound(loc, 'sound/weapons/egloves.ogg', 50, 1, -1)
	deductcharge(hitcost)

/obj/item/melee/baton/emp_act(severity)
	. = ..()
	if (!(. & EMP_PROTECT_SELF))
		switch_status(FALSE)
		if(!iscyborg(loc))
			deductcharge(1000 / severity, TRUE, FALSE)

/obj/item/melee/baton/stunsword
	name = "stunsword"
	desc = "not actually sharp, this sword is functionally identical to a stunbaton"
	icon = 'modular_citadel/icons/obj/stunsword.dmi'
	icon_state = "stunsword"
	item_state = "sword"
	lefthand_file = 'modular_citadel/icons/mob/inhands/stunsword_left.dmi'
	righthand_file = 'modular_citadel/icons/mob/inhands/stunsword_right.dmi'

/obj/item/melee/baton/stunsword/get_belt_overlay()
	if(istype(loc, /obj/item/storage/belt/sabre))
		return mutable_appearance('icons/obj/clothing/belt_overlays.dmi', "stunsword")
	return ..()

/obj/item/melee/baton/stunsword/get_worn_belt_overlay(icon_file)
	return mutable_appearance(icon_file, "-stunsword")

/obj/item/ssword_kit
	name = "stunsword kit"
	desc = "a modkit for making a stunbaton into a stunsword"
	icon = 'icons/obj/vending_restock.dmi'
	icon_state = "refill_donksoft"
	var/product = /obj/item/melee/baton/stunsword //what it makes
	var/list/fromitem = list(/obj/item/melee/baton, /obj/item/melee/baton/loaded) //what it needs
	afterattack(obj/O, mob/user as mob)
		if(istype(O, product))
			to_chat(user,"<span class='warning'>[O] is already modified!")
		else if(O.type in fromitem) //makes sure O is the right thing
			var/obj/item/melee/baton/B = O
			if(!B.cell) //checks for a powercell in the baton. If there isn't one, continue. If there is, warn the user to take it out
				new product(usr.loc) //spawns the product
				user.visible_message("<span class='warning'>[user] modifies [O]!","<span class='warning'>You modify the [O]!")
				qdel(O) //Gets rid of the baton
				qdel(src) //gets rid of the kit

			else
				to_chat(user,"<span class='warning'>Remove the powercell first!</span>") //We make this check because the stunsword starts without a battery.
		else
			to_chat(user, "<span class='warning'> You can't modify [O] with this kit!</span>")

//Makeshift stun baton. Replacement for stun gloves.
/obj/item/melee/baton/cattleprod
	name = "stunprod"
	desc = "An improvised stun baton."
	icon_state = "stunprod_nocell"
	item_state = "prod"
	lefthand_file = 'icons/mob/inhands/weapons/melee_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/melee_righthand.dmi'
	w_class = WEIGHT_CLASS_BULKY
	force = 3
	throwforce = 5
	stamforce = 25
	hitcost = 1000
	knockdown = FALSE
	throw_hit_chance = 10
	slot_flags = ITEM_SLOT_BACK
	var/obj/item/assembly/igniter/sparkler

/obj/item/melee/baton/cattleprod/Initialize()
	. = ..()
	sparkler = new (src)
	sparkler.activate_cooldown = 5

/obj/item/melee/baton/cattleprod/baton_stun()
	sparkler?.activate()
	. = ..()


#undef STUNBATON_CHARGE_LENIENCY
#undef STUNBATON_DEPLETION_RATE
