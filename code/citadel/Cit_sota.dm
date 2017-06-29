// This is where i will store my retarded projects that get deleted everytime TG changes the fucking mining vendor


/obj/item/weapon/storage/box/medipens/Surival_box
	name = "Survival Pen Pack"
	Desc = "A pack of survival Pens to keep even the most retarded of miners alive"
	illustation = "syringe"

/obj/item/weapon/storage/box/medipens/Surival_box/PopulateContents()
	for(var/i in 1 to 10)
		new /obj/item/weapon/reagent_containers/hypospray/medipen/survival
