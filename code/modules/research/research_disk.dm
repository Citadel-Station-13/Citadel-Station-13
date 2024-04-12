
/obj/item/disk/tech_disk
	name = "technology disk"
	desc = "A disk for storing technology data for further research."
	icon_state = "datadisk0"
	custom_materials = list(/datum/material/iron=300, /datum/material/glass=100)
	var/datum/techweb/stored_research

/obj/item/disk/tech_disk/Initialize(mapload)
	. = ..()
	pixel_x = rand(-5, 5)
	pixel_y = rand(-5, 5)
	stored_research = new /datum/techweb

/obj/item/disk/tech_disk/debug
	name = "\improper CentCom technology disk"
	desc = "A debug item for research"
	custom_materials = null

/obj/item/disk/tech_disk/debug/Initialize(mapload)
	. = ..()
	stored_research = new /datum/techweb/admin

/obj/item/disk/tech_disk/major
	name = "Reformatted technology disk"
	desc = "A disk containing a new, completed tech from the B.E.P.I.S. Upload the disk to an R&D Console to redeem the tech."
	icon_state = "rndmajordisk"
	custom_materials = list(/datum/material/iron=300, /datum/material/glass=100)

/obj/item/disk/tech_disk/major/Initialize(mapload)
	. = ..()
	stored_research = new /datum/techweb/bepis

/obj/item/disk/tech_disk/illegal
	name = "Illegal technology disk"
	desc = "A technology disk containing schematics for syndicate inspired equipment."
	custom_materials = null

/obj/item/disk/tech_disk/illegal/Initialize(mapload)
	. = ..()
	stored_research = new /datum/techweb/syndicate

/obj/item/disk/tech_disk/abductor
	name = "Gray technology disk"
	desc = "You feel like it's not Gray because of its color."
	custom_materials = null

/obj/item/disk/tech_disk/abductor/Initialize(mapload)
	. = ..()
	stored_research = new /datum/techweb/abductor
