/*/datum/uplink_item/stealthy_tools/syndi_borer
	name = "Syndicate Brain Slug"
	desc = "A small cortical borer, modified to be completely loyal to the owner. \
			Genetically infertile, these brain slugs can assist medically in a support role, or take direct action \
			to assist their host."
	item = /obj/item/weapon/antag_spawner/syndi_borer
	refundable = TRUE
	cost = 10
	surplus = 20 //Let's not have this be too common
	exclude_modes = list(/datum/game_mode/nuclear) */

/datum/uplink_item/stealthy_tools/holoparasite
	name="Holoparasite Injector"
	desc="It contains an alien nanoswarm of unknown origin.\
		  Though capable of near sorcerous feats via use of hardlight holograms and nanomachines.\
		  It requires an organic host as a home base and source of fuel." //This is the description of the actual injector. Feel free to change this for uplink purposes//
	item = /obj/item/weapon/storage/box/syndie_kit/holoparasite
	refundable = TRUE
	cost = 15 //I'm working off the borer. Price subject to change
	surplus = 20 //Nobody needs a ton of parasites
	exclude_modes = list(/datum/game_mode/nuclear)
	refund_path = /obj/item/weapon/guardiancreator/tech/choose/traitor


/obj/item/weapon/storage/box/syndie_kit/holoparasite
	name = "box"

/obj/item/weapon/storage/box/syndie_kit/holoparasite/PopulateContents()
	new /obj/item/weapon/guardiancreator/tech/choose/traitor(src)
	new /obj/item/weapon/paper/guardian(src)