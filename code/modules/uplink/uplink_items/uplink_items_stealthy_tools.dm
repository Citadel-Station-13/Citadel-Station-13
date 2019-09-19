/**
 * See Uplink_items file for formating and vars
 *
 * Items that can be spawned from an uplink. Can be limited by gamemode.
**/

// Stealth Items
/datum/uplink_item/stealthy_tools
	category = "Infiltration and Distruption Tools"

//Non-Clown-Ops

/datum/uplink_item/stealthy_tools/suppressor
	name = "Suppressor"
	desc = "This suppressor will silence the shots of the weapon it is attached to for increased stealth and superior ambushing capability. \
			It is compatible with many small ballistic guns including the M92 and C-20r, but not revolvers or energy guns."
	item = /obj/item/suppressor
	cost = 1
	surplus = 10
	exclude_modes = list(/datum/game_mode/nuclear/clown_ops)

//Non-Nuke-Ops

/*/datum/uplink_item/stealthy_tools/syndi_borer
	name = "Syndicate Brain Slug"
	desc = "A small cortical borer, modified to be completely loyal to the owner. \
			Genetically infertile, these brain slugs can assist medically in a support role, or take direct action \
			to assist their host."
	item = /obj/item/antag_spawner/syndi_borer
	refundable = TRUE
	cost = 10
	surplus = 20 //Let's not have this be too common
	exclude_modes = list(/datum/game_mode/nuclear) */

//Non-Any-Ops

/datum/uplink_item/stealthy_tools/chameleon
	name = "Chameleon Kit"
	desc = "A set of items that contain chameleon technology allowing you to disguise as pretty much anything on the station, and more! \
			Due to budget cuts, the shoes don't provide protection against slipping."
	item = /obj/item/storage/box/syndie_kit/chameleon
	cost = 2
	exclude_modes = list(/datum/game_mode/nuclear, /datum/game_mode/nuclear/clown_ops) //necessary until nuke ops is reworked

/datum/uplink_item/stealthy_tools/syndigaloshes
	name = "No-Slip Chameleon Shoes"
	desc = "These shoes will allow the wearer to run on wet floors and slippery objects without falling down. \
			They do not work on heavily lubricated surfaces."
	item = /obj/item/clothing/shoes/chameleon/noslip
	cost = 2
	exclude_modes = list(/datum/game_mode/nuclear, /datum/game_mode/nuclear/clown_ops)
	player_minimum = 20

/datum/uplink_item/stealthy_tools/failsafe
	name = "Failsafe Uplink Code"
	desc = "When entered into the uplink, it will automatically self-destruct."
	item = /obj/effect/gibspawner/generic
	cost = 1
	surplus = 0
	restricted = TRUE
	exclude_modes = list(/datum/game_mode/nuclear, /datum/game_mode/nuclear/clown_ops)

/datum/uplink_item/stealthy_tools/failsafe/spawn_item(spawn_path, mob/user, datum/component/uplink/U)
	if(!U)
		return
	U.failsafe_code = U.generate_code()
	to_chat(user, "The new failsafe code for this uplink is now : [U.failsafe_code].")
	if(user.mind)
		user.mind.store_memory("Failsafe code for [U.parent] : [U.failsafe_code]")
	return U.parent //For log icon

/datum/uplink_item/stealthy_tools/mulligan
	name = "Mulligan"
	desc = "Screwed up and have security on your tail? This handy syringe will give you a completely new identity \
			and appearance."
	item = /obj/item/reagent_containers/syringe/mulligan
	cost = 3
	surplus = 30
	exclude_modes = list(/datum/game_mode/nuclear, /datum/game_mode/nuclear/clown_ops)

//Clown-Ops-Only

//Nuke-Ops-Only

/datum/uplink_item/stealthy_tools/syndigaloshes/nukep
	cost = 4
	include_modes = list(/datum/game_mode/nuclear)

//Both Ops

//Any-one

/datum/uplink_item/stealthy_tools/agent_card
	name = "Agent Identification Card"
	desc = "Agent cards prevent artificial intelligences from tracking the wearer, and can copy access \
			from other identification cards. The access is cumulative, so scanning one card does not erase the \
			access gained from another. In addition, they can be forged to display a new assignment and name. \
			This can be done an unlimited amount of times. Some Syndicate areas and devices can only be accessed \
			with these cards."
	item = /obj/item/card/id/syndicate
	cost = 2

/datum/uplink_item/stealthy_tools/chameleon_proj
	name = "Chameleon Projector"
	desc = "Projects an image across a user, disguising them as an object scanned with it, as long as they don't \
			move the projector from their hand. Disguised users move slowly, and projectiles pass over them."
	item = /obj/item/chameleon
	cost = 6

/datum/uplink_item/stealthy_tools/cutouts
	name = "Adaptive Cardboard Cutouts"
	desc = "These cardboard cutouts are coated with a thin material that prevents discoloration and makes the images on them appear more lifelike. \
			This pack contains three as well as a crayon for changing their appearances."
	item = /obj/item/storage/box/syndie_kit/cutouts
	cost = 1
	surplus = 20

/datum/uplink_item/stealthy_tools/jammer
	name = "Radio Jammer"
	desc = "This device will disrupt any nearby outgoing radio communication when activated. Does not affect binary chat."
	item = /obj/item/jammer
	cost = 5

/datum/uplink_item/stealthy_tools/emplight
	name = "EMP Flashlight"
	desc = "A small, self-recharging, short-ranged EMP device disguised as a working flashlight. \
		Useful for disrupting headsets, cameras, doors, lockers and borgs during stealth operations. \
		Attacking a target with this flashlight will direct an EM pulse at it and consumes a charge."
	item = /obj/item/flashlight/emp
	cost = 2
	surplus = 30

/datum/uplink_item/stealthy_tools/frame
	name = "F.R.A.M.E. PDA Cartridge"
	desc = "When inserted into a personal digital assistant, this cartridge gives you five PDA viruses which \
			when used cause the targeted PDA to become a new uplink with zero TCs, and immediately become unlocked. \
			You will receive the unlock code upon activating the virus, and the new uplink may be charged with \
			telecrystals normally."
	item = /obj/item/cartridge/virus/frame
	cost = 2
	restricted = TRUE

/datum/uplink_item/stealthy_tools/ai_detector
	name = "Artificial Intelligence Detector"
	desc = "A functional multitool that turns red when it detects an artificial intelligence watching it, and can be \
			activated to display their exact viewing location and nearby security camera blind spots. Knowing when \
			an artificial intelligence is watching you is useful for knowing when to maintain cover, and finding nearby \
			blind spots can help you identify escape routes."
	item = /obj/item/multitool/ai_detect
	cost = 1

/datum/uplink_item/stealthy_tools/codespeak_manual
	name = "Codespeak Manual"
	desc = "Syndicate agents can be trained to use a series of codewords to convey complex information, which sounds like random concepts and drinks to anyone listening. \
			This manual teaches you this Codespeak. You can also hit someone else with the manual in order to teach them. This is the deluxe edition, which has unlimited uses."
	item = /obj/item/codespeak_manual/unlimited
	cost = 3

/datum/uplink_item/stealthy_tools/smugglersatchel
	name = "Smuggler's Satchel"
	desc = "This satchel is thin enough to be hidden in the gap between plating and tiling; great for stashing \
			your stolen goods. Comes with a crowbar and a floor tile inside. Properly hidden satchels have been \
			known to survive intact even beyond the current shift. "
	item = /obj/item/storage/backpack/satchel/flat
	cost = 2
	surplus = 30
