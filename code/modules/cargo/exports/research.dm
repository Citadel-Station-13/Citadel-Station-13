// Sell tech levels
/datum/export/tech
	cost = 500
	unit_name = "technology data disk"
	export_types = list(/obj/item/disk/tech_disk)
	var/list/techLevels = list()

/datum/export/tech/get_cost(obj/O)
	var/obj/item/disk/tech_disk/D = O
	var/cost = 0
	for(var/V in D.tech_stored)
		if(!V)
			continue
<<<<<<< HEAD
		var/datum/tech/tech = V
		cost += tech.getCost(techLevels[tech.id])
	return ..() * cost
=======
		var/datum/techweb_node/TWN = D.stored_research.researched_nodes[V]
		cost += TWN.export_price
	return cost
>>>>>>> ef0973c... Merge pull request #33063 from kevinz000/patch-394

/datum/export/tech/sell_object(obj/O)
	..()
	var/obj/item/disk/tech_disk/D = O
	for(var/V in D.tech_stored)
		if(!V)
			continue
		var/datum/tech/tech = V
		techLevels[tech.id] = max(techLevels[tech.id], tech.level)
