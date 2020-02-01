// 5.56mm (NT-ARG Boarder)

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
	armour_penetration = 15 //Let's not go overboard here

/obj/item/projectile/bullet/a57x28/hp
	name = "5.7x28mm bullet"
	damage = 40 //Three shot kill
	armour_penetration = -50 //Let bulletproof armor do its thing