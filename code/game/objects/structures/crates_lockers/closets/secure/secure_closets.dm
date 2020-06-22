/obj/structure/closet/secure_closet
	name = "secure locker"
	desc = "It's a card-locked storage unit."
	locked = TRUE
	icon_state = "secure"
	max_integrity = 250
	armor = list("melee" = 30, "bullet" = 50, "laser" = 50, "energy" = 100, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 80, "acid" = 80)
	secure = TRUE
	var/melee_min_damage = 20

/obj/structure/closet/secure_closet/run_obj_armor(damage_amount, damage_type, damage_flag = 0, attack_dir)
	if(damage_flag == "melee" && damage_amount < melee_min_damage)
		return 0
	. = ..()

// Exists to work around the minimum 700 cr price for goodies / small items
/obj/structure/closet/secure_closet/goodies
	icon_state = "goodies"
	desc = "A sturdier card-locked storage unit used for bulky shipments."
	max_integrity = 500 // Same as crates.
	melee_min_damage = 25 // Idem.
