// 5.56mm (Unused... for now)

/obj/item/projectile/bullet/a556
	name = "5.56mm bullet"
	damage = 35

// 7.62 (Nagant Rifle)

/obj/item/projectile/bullet/a762
	name = "7.62 bullet"
	damage = 60

/obj/item/projectile/bullet/a762_enchanted
	name = "enchanted 7.62 bullet"
	damage = 5
	stamina = 80

// 5.7x28mm (Robust M-90gl Rounds)
/obj/item/projectile/bullet/a57x28
	name = "5.7x28mm bullet"
	damage = 30 //Getting hit with a full burst is lethal assuming no armor
	armour_penetration = 10 //Let's not go overboard here

/obj/item/projectile/bullet/57x28_hp
	name = "5.7x28mm bullet"
	damage = 40 //Three shot kill
	armour_penetration = -40 //Let bulletproof armor do its thing