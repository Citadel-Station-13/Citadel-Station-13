/obj/item/ammo_casing/syringegun
	name = "syringe gun spring"
	desc = "A high-power spring that throws syringes."
	projectile_type = /obj/item/projectile/bullet/dart/syringe
	firing_effect_type = null

/obj/item/ammo_casing/syringegun/ready_proj(atom/target, mob/living/user, quiet, zone_override = "")
	if(!BB)
		return
	if(istype(loc, /obj/item/gun/syringe))
		var/obj/item/gun/syringe/SG = loc
		if(!SG.syringes.len)
			return

		var/obj/item/reagent_containers/syringe/S = SG.syringes[1]

		S.reagents.trans_to(BB, S.reagents.total_volume)
		BB.name = S.name
		var/obj/item/projectile/bullet/dart/D = BB
		D.piercing = S.proj_piercing
		SG.syringes.Remove(S)
		qdel(S)
	..()

/obj/item/ammo_casing/chemgun
	name = "dart synthesiser"
	desc = "A high-power spring, linked to an energy-based dart synthesiser."
	projectile_type = /obj/item/projectile/bullet/dart/piercing
	firing_effect_type = null

/obj/item/ammo_casing/chemgun/ready_proj(atom/target, mob/living/user, quiet, zone_override = "")
	if(!BB)
		return
	if(istype(loc, /obj/item/gun/chem))
		var/obj/item/gun/chem/CG = loc
		if(CG.syringes_left <= 0)
			return
		CG.reagents.trans_to(BB, 10)
		BB.name = "chemical dart"
		CG.syringes_left--
	..()

/obj/item/ammo_casing/dnainjector
	name = "rigged syringe gun spring"
	desc = "A high-power spring that throws DNA injectors."
	projectile_type = /obj/item/projectile/bullet/dnainjector
	firing_effect_type = null

/obj/item/ammo_casing/dnainjector/ready_proj(atom/target, mob/living/user, quiet, zone_override = "")
	if(!BB)
		return
	if(istype(loc, /obj/item/gun/syringe/dna))
		var/obj/item/gun/syringe/dna/SG = loc
		if(!SG.syringes.len)
			return

		var/obj/item/dnainjector/S = popleft(SG.syringes)
		var/obj/item/projectile/bullet/dnainjector/D = BB
		S.forceMove(D)
		D.injector = S
	..()

/obj/item/ammo_casing/syringegun/dart
	name = "used air canister"
	desc = "A small canister of compressed gas."
	projectile_type = /obj/item/projectile/bullet/dart/syringe/dart
	firing_effect_type = null
	harmful = FALSE

/obj/item/ammo_casing/syringegun/dart/ready_proj(atom/target, mob/living/user, quiet, zone_override = "")
	..()
	var/obj/item/gun/syringe/SG = loc
	if(!SG.syringes.len)
		return
	var/obj/item/reagent_containers/syringe/dart/S = SG.syringes[1]
	if(S.emptrig == TRUE)
		var/obj/item/projectile/bullet/dart/syringe/dart/D = BB
		D.emptrig = TRUE
