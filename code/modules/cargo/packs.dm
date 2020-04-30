/datum/supply_pack
	var/name = "Crate"
	var/group = ""
	var/hidden = FALSE //Aka emag only
	var/contraband = FALSE //Requires a hacked console UNLESS DropPodOnly = TRUE, in which case it requires an emag
	var/cost = 700 // Minimum cost, or infinite points are possible.
	var/access = FALSE //What access does the Crate itself need?
	var/access_any = FALSE //Do we care about access?
	var/list/contains = null //What items are in the crate
	var/crate_name = "crate" //The crate that comes with each order
	var/desc = ""//no desc by default
	var/crate_type = /obj/structure/closet/crate //what kind of crate - Locked crates needed for access locked crates
	var/dangerous = FALSE // Should we message admins?
	var/special = FALSE //Event/Station Goals/Admin enabled packs
	var/special_enabled = FALSE
	var/DropPodOnly = FALSE //only usable by the Bluespace Drop Pod via the express cargo console
	var/admin_spawned = FALSE //Can only an admin spawn this crate?
	var/loading_time = 3 //How long does it take to load a packet onto the shuttle? by default its 3 seconds

// Cargo Restictions //
// These are used for when you want to stop cargo buying a crate type round start
// These are vage for a reason, and that is to allow others to use/exspand on them
	var/space_gear = FALSE //Hardsuits and higher level space gear
	var/heavy_firearms = FALSE //Larger and more powerful gear
	var/medco_trade = FALSE // Implants and medical based gear that are higher level
	var/blackmarket = FALSE // Drugs and none-syndi gear
	var/animal_handing = FALSE // More rare animal and hostile animals
	var/adv_sci = FALSE //Tech that is not made by NT but still are usefull

/datum/supply_pack/proc/generate(atom/A)
	var/obj/structure/closet/crate/C = new crate_type(A)
	C.name = crate_name
	if(access)
		C.req_access = list(access)
	if(access_any)
		C.req_one_access = access_any

	SSshuttle.supply.callTime -= loading_time

	fill(C)

	return C

/datum/supply_pack/proc/fill(obj/structure/closet/crate/C)
	if (admin_spawned)
		for(var/item in contains)
			var/atom/A = new item(C)
			A.flags_1 |= ADMIN_SPAWNED_1
	else
		for(var/item in contains)
			new item(C)
