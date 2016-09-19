/obj/item/weapon/robot_module/loader
	name = "loader robot module"
/obj/item/weapon/robot_module/loader/New()
	..()
	emag = new /obj/item/borg/stun(src)
	modules += new /obj/item/weapon/extinguisher(src)
	modules += new /obj/item/weapon/weldingtool/largetank/cyborg(src)
	modules += new /obj/item/weapon/screwdriver(src)
	modules += new /obj/item/weapon/wrench(src)
	modules += new /obj/item/weapon/crowbar(src)
	modules += new /obj/item/weapon/wirecutters(src)
	modules += new /obj/item/device/multitool(src)
	modules += new /obj/item/device/t_scanner(src)
	modules += new /obj/item/device/analyzer(src)
	modules += new /obj/item/device/assembly/signaler
	modules += new /obj/item/weapon/soap/nanotrasen(src)

	fix_modules()

/obj/item/weapon/robot_module/k9
	name = "Security K-9 Unit module"
/obj/item/weapon/robot_module/k9/New()
	..()
	modules += new /obj/item/weapon/restraints/handcuffs/cable/zipties/cyborg/dog(src)
	modules += new /obj/item/weapon/dogborg/jaws/big(src)
	modules += new /obj/item/weapon/dogborg/pounce(src)
	modules += new /obj/item/clothing/mask/gas/sechailer/cyborg(src)
	modules += new /obj/item/weapon/soap/tongue(src)
	modules += new /obj/item/device/analyzer/nose(src)
	modules += new /obj/item/weapon/storage/bag/borgdelivery(src)
	//modules += new /obj/item/device/assembly/signaler(src)
	//modules += new /obj/item/device/detective_scanner(src)
	modules += new /obj/item/weapon/gun/energy/disabler/cyborg(src)
	emag = new /obj/item/weapon/gun/energy/laser/cyborg(src)
	fix_modules()

/obj/item/weapon/robot_module/security/respawn_consumable(mob/living/silicon/robot/R, coeff = 1)
	..()
	var/obj/item/weapon/gun/energy/gun/advtaser/cyborg/T = locate(/obj/item/weapon/gun/energy/gun/advtaser/cyborg) in get_usable_modules()
	if(T)
		if(T.power_supply.charge < T.power_supply.maxcharge)
			var/obj/item/ammo_casing/energy/S = T.ammo_type[T.select]
			T.power_supply.give(S.e_cost * coeff)
			T.update_icon()
		else
			T.charge_tick = 0
	fix_modules()

/obj/item/weapon/robot_module/borgi
	name = "Borgi module"

/obj/item/weapon/robot_module/borgi/New()
	..()
	modules += new /obj/item/weapon/dogborg/jaws/small(src)
	modules += new /obj/item/weapon/storage/bag/borgdelivery(src)
	modules += new /obj/item/weapon/soap/tongue(src)
	modules += new /obj/item/device/healthanalyzer(src)
	modules += new /obj/item/device/analyzer/nose(src)
	emag = new /obj/item/weapon/dogborg/pounce(src)
	fix_modules()

/obj/item/weapon/robot_module/medihound
	name = "MediHound module"

/obj/item/weapon/robot_module/medihound/New()
	..()
	modules += new /obj/item/weapon/dogborg/jaws/small(src)
	modules += new /obj/item/weapon/storage/bag/borgdelivery(src)
	modules += new /obj/item/device/analyzer/nose(src)
	modules += new /obj/item/weapon/soap/tongue(src)
	modules += new /obj/item/device/healthanalyzer(src)
	modules += new /obj/item/weapon/dogborg/sleeper(src)
	modules += new /obj/item/weapon/twohanded/shockpaddles/hound(src)
	modules += new /obj/item/device/sensor_device(src)
	emag = new /obj/item/weapon/dogborg/pounce(src)
	fix_modules()