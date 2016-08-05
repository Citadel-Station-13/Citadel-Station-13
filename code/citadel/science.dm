datum/design/shrinkray
	name = "Shrink Ray"
	desc = "Make people small."
	id = "shrinkray"
	req_tech = list("combat" = 5, "materials" = 3, "engineering" = 2, "biotech" = 3)
	build_type = PROTOLATHE
	materials = list("$metal" = 5000, "$glass" = 1000, "$diamond" = 1500)
	build_path = /obj/item/weapon/gun/energy/laser/sizeray/one
	category = list("Weapons")

datum/design/growthray
	name = "Growth Ray"
	desc = "Make people small... To the person you hit."
	id = "growthray"
	req_tech = list("combat" = 5, "materials" = 4, "engineering" = 3, "bluespace" = 2)
	build_type = PROTOLATHE
	materials = list("$metal" = 5000, "$glass" = 1000, "$diamond" = 1500)
	build_path = /obj/item/weapon/gun/energy/laser/sizeray/two
	category = list("Weapons")

datum/design/stethoscope
	name = "Stethoscope"
	desc = "An ordinary stethoscope."
	id = "stethoscope"
	req_tech = list("biotech" = 2)
	build_type = PROTOLATHE
	materials = list("$metal" = 50)
	build_path = /obj/item/clothing/tie/stethoscope
	category = list("Medical")

/*
datum/design/stethoscope_advanced
	name = "Stethoscope (Advanced)"
	desc = "An advanced stethoscope that can read micro-vibrations produced by DNA, or possibly something less silly."
	id = "stethoscope_advanced"
	req_tech = list("biotech" = 3, "magnets" = 2)
	build_type = PROTOLATHE
	materials = list("$metal" = 500)
	build_path = /obj/item/clothing/tie/stethoscope/advanced
	category = list("Medical")*/