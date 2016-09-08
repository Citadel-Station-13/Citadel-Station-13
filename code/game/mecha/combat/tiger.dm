/obj/mecha/combat/tiger
	desc = "A famous World War 2 German heavy tank."
	name = "\improper Panzerkampfwagen VI Tiger Ausf. E"
	icon = 'icons/mecha/tank.dmi'
	icon_state = "tiger"
	step_in = 5
	health = 500
	deflect_chance = 25
	damage_absorption = list("brute"=0.5,"fire"=0.7,"bullet"=0.45,"laser"=0.6,"energy"=0.7,"bomb"=0.7)
	max_temperature = 60000
	burn_state = LAVA_PROOF
	infra_luminosity = 3
	wreckage = /obj/structure/mecha_wreckage/tiger
	add_req_access = 0
	internal_damage_threshold = 25
	force = 45
	max_equip = 4
	bumpsmash = 1
	stepsound = 'sound/mecha/tankstep.ogg'
	turnsound = 'sound/mecha/tankturn.ogg'

/obj/mecha/combat/tiger/GrantActions(mob/living/user, human_occupant = 0)
	..()
	smoke_action.Grant(user, src)
	thrusters_action.Grant(user, src)
	zoom_action.Grant(user, src)

/obj/mecha/combat/tiger/RemoveActions(mob/living/user, human_occupant = 0)
	..()
	smoke_action.Remove(user)
	thrusters_action.Remove(user)
	zoom_action.Remove(user)

/obj/mecha/combat/tiger/loaded/New()
	..()
	var/obj/item/mecha_parts/mecha_equipment/ME = new /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/launcher/tank_barrel(src)
	ME.attach(src)
