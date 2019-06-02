/obj/item/gun/magic/nerf
	name = "N.E.R.F gun"
	desc = "A weapon that uses bluespace, redspace, and whatever other bullshit Central Command can come up with, to literally make anything worse than it currently is. Why? Because why not."
	icon = 'modular_citadel/icons/obj/guns/cit_guns.dmi'
	icon_state = "toymag"
	fire_sound = 'modular_citadel/sound/weapons/pew.ogg'
	ammo_type = /obj/item/ammo_casing/nerf
	max_charges = 1
	recharge_rate = 0
	can_charge = 0

/obj/item/gun/magic/nerf/attack_self(mob/user)
	if(!charges)
		charges++
		recharge_newshot()
		playsound(src, 'modular_citadel/sound/weapons/itsnerfornothing.ogg', 75)
	else
		to_chat(user, "<span class='warning'>The [src] locks up, it's already charged.</span>")
		playsound(src, 'sound/weapons/gun_dry_fire_1.ogg', 75)

/obj/item/ammo_casing/nerf/
	projectile_type = /obj/item/projectile/nerf
	harmful = FALSE // nerfing surely cant hurt you

/obj/item/projectile/nerf/
	name = "N.E.R.F dart"
	icon = 'icons/obj/guns/toy.dmi'
	icon_state = "foamdart_proj"
	damage = 0
	damage_type = OXY
	nodamage = 1

/obj/item/projectile/nerf/on_hit(atom/target)
	..()
	target.name = "\improper nerfed [target]"
	if(isitem(target))
		var/obj/item/O = target
		O.force = max(O.force-5, 1)
		O.throwforce = max(O.throwforce-5, 1)
		O.armour_penetration = max(O.armour_penetration-5, 1)
		if(istype(O, /obj/item/gun/))
			var/obj/item/gun/G = O
			G.recoil += 5
			G.spread += 5
			G.fire_delay += 5
	if(ismob(target))
		var/mob/living/M = target
		M.maxHealth = max(M.maxHealth-5, 1)
		M.health = max(M.health-5, 1)
		if(isanimal(M))
			var/mob/living/simple_animal/A = M
			A.melee_damage_lower = max(A.melee_damage_lower-5, 1)
			A.melee_damage_upper = max(A.melee_damage_upper-5, 1)
			A.obj_damage = max(A.obj_damage-5, 1)
			A.armour_penetration = max(A.obj_damage-5, 1)
	if(ismachinery(target))
		var/obj/machinery/C = target
		C.idle_power_usage += 500
		C.active_power_usage += 500
