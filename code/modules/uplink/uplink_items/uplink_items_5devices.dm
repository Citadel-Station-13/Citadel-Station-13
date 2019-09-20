/**
 * See Uplink_items file for formating and vars
 *
 * Items that can be spawned from an uplink. Can be limited by gamemode.
**/

// Electronic Devices
/datum/uplink_item/devices
	category = "Electronic Devices"

//Non-Clown-Ops

//Non-Nuke-Ops

//Non-Any-Ops

//Clown-Ops-Only

/datum/uplink_item/devices/bananashield
	name = "Bananium Energy Shield"
	desc = "A clown's most powerful defensive weapon, this personal shield provides near immunity to ranged energy attacks \
		by bouncing them back at the ones who fired them. It can also be thrown to bounce off of people, slipping them, \
		and returning to you even if you miss. WARNING: DO NOT ATTEMPT TO STAND ON SHIELD WHILE DEPLOYED, EVEN IF WEARING ANTI-SLIP SHOES."
	item = /obj/item/shield/energy/bananium
	cost = 16
	surplus = 0
	include_modes = list(/datum/game_mode/nuclear/clown_ops)

//Nuke-Ops-Only

/datum/uplink_item/devices/shield
	name = "Energy Shield"
	desc = "An incredibly robust personal shield projector, capable of reflecting all energy projectiles \
			and blocking physical attacks. It is highly recommended you purchase this if you are using a one handed weapon."
	item = /obj/item/shield/energy
	cost = 16
	surplus = 20
	include_modes = list(/datum/game_mode/nuclear)

//Both Ops

/datum/uplink_item/devices/potion
	name = "Syndicate Sentience Potion"
	item = /obj/item/slimepotion/slime/sentience/nuclear
	desc = "A potion recovered at great risk by undercover Syndicate operatives and then subsequently modified with Syndicate technology. \
			Using it will make any animal sentient, and bound to serve you, as well as implanting an internal radio for communication and an internal ID card for opening doors."
	cost = 2
	include_modes = list(/datum/game_mode/nuclear, /datum/game_mode/nuclear/clown_ops)
	restricted = TRUE

//Any-one

/datum/uplink_item/devices/binary
	name = "Binary Translator Key"
	desc = "A key that, when inserted into a radio headset, allows you to listen to and talk with silicon-based lifeforms, \
			such as AI units and cyborgs, over their private binary channel. Caution should \
			be taken while doing this, as unless they are allied with you, they are programmed to report such intrusions."
	item = /obj/item/encryptionkey/binary
	cost = 2
	surplus = 75
	restricted = TRUE

/datum/uplink_item/devices/compressionkit
	name = "Bluespace Compression Kit"
	desc = "A modified version of a BSRPED that can be used to reduce the size of most items while retaining their original functions! \
			Does not work on storage items. \
			Recharge using bluespace crystals. \
			Comes with 5 charges."
	item = /obj/item/compressionkit
	cost = 8

/datum/uplink_item/devices/briefcase_launchpad
	name = "Briefcase Launchpad"
	desc = "A briefcase containing a launchpad, a device able to teleport items and people to and from targets up to twenty tiles away from the briefcase. \
			Also includes a remote control, disguised as an ordinary folder. Touch the briefcase with the remote to link it."
	surplus = 0
	item = /obj/item/storage/briefcase/launchpad
	cost = 6

/datum/uplink_item/devices/emag
	name = "Cryptographic Sequencer"
	desc = "The cryptographic sequencer, electromagnetic card, or emag, is a small card that unlocks hidden functions \
			in electronic devices, subverts intended functions, and easily breaks security mechanisms. Starts with only 10 charges"
	item = /obj/item/card/emag
	cost = 6

/datum/uplink_item/devices/camera_bug
	name = "Camera Bug"
	desc = "Enables you to view all cameras on the main network, set up motion alerts and track a target. \
			Bugging cameras allows you to disable them remotely."
	item = /obj/item/camera_bug
	cost = 1
	surplus = 90

/datum/uplink_item/devices/fakenucleardisk
	name = "Decoy Nuclear Authentication Disk"
	desc = "It's just a normal disk. Visually it's identical to the real deal, but it won't hold up under closer scrutiny by the Captain. \
			Don't try to give this to us to complete your objective, we know better!"
	item = /obj/item/disk/nuclear/fake
	cost = 1
	surplus = 1

/datum/uplink_item/devices/emagrecharge
	name = "Electromagnet Charging Device"
	desc = "A small device intended for recharging Cryptographic Sequencers. Using it will add five extra charges to the Cryptographic Sequencer."
	item = /obj/item/emagrecharge
	cost = 2

/datum/uplink_item/devices/hacked_module
	name = "Hacked AI Law Upload Module"
	desc = "When used with an upload console, this module allows you to upload priority laws to an artificial intelligence. \
			Be careful with wording, as artificial intelligences may look for loopholes to exploit."
	item = /obj/item/aiModule/syndicate
	cost = 5

/datum/uplink_item/devices/singularity_beacon
	name = "Power Beacon"
	desc = "When screwed to wiring attached to an electric grid and activated, this large device pulls any \
			active gravitational singularities or tesla balls towards it. This will not work when the engine is still \
			in containment. Because of its size, it cannot be carried. Ordering this \
			sends you a small beacon that will teleport the larger beacon to your location upon activation."
	item = /obj/item/sbeacondrop
	cost = 14

/datum/uplink_item/devices/powersink
	name = "Power Sink"
	desc = "When screwed to wiring attached to a power grid and activated, this large device lights up and places excessive \
			load on the grid, causing a station-wide blackout. The sink is large and cannot be stored in most \
			traditional bags and boxes. Caution: Will explode if the powernet contains sufficient amounts of energy."
	item = /obj/item/powersink
	cost = 7

/datum/uplink_item/devices/encryptionkey
	name = "Syndicate Encryption Key"
	desc = "A key that, when inserted into a radio headset, allows you to listen to all station department channels \
			as well as talk on an encrypted Syndicate channel with other agents that have the same key."
	item = /obj/item/encryptionkey/syndicate
	cost = 2
	surplus = 75
	restricted = TRUE