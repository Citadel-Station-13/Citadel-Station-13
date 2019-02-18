
SUBSYSTEM_DEF(research)
	name = "Research"
	priority = FIRE_PRIORITY_RESEARCH
	wait = 10
	init_order = INIT_ORDER_RESEARCH
	var/list/invalid_design_ids = list()		//associative id = number of times
	var/list/invalid_node_ids = list()			//associative id = number of times
	var/list/invalid_node_boost = list()		//associative id = error message
	var/list/obj/machinery/rnd/server/servers = list()
	var/datum/techweb/science/science_tech
	var/datum/techweb/admin/admin_tech
	var/list/techweb_nodes = list()				//associative id = node datum
	var/list/techweb_categories = list()		//category name = list(node.id = node)
	var/list/techweb_designs = list()			//associative id = node datum
	var/list/techweb_nodes_starting = list()	//associative id = node datum
	var/list/techweb_boost_items = list()		//associative double-layer path = list(id = list(point_type = point_discount))
	var/list/techweb_nodes_hidden = list()		//Nodes that should be hidden by default.
	var/list/techweb_point_items = list(		//path = list(point type = value)
	/obj/item/assembly/signaler/anomaly = list(TECHWEB_POINT_TYPE_GENERIC = 2500),
	/obj/item/assembly/signaler/anomaly = list(TECHWEB_POINT_TYPE_GENERIC = 5000),   // Cit three more anomalys anomalys
	/obj/item/assembly/signaler/anomaly = list(TECHWEB_POINT_TYPE_GENERIC = 7500),
	/obj/item/assembly/signaler/anomaly = list(TECHWEB_POINT_TYPE_GENERIC = 10000),
	//   -   Slime Extracts!   - 
	/obj/item/slime_extract/grey = list(TECHWEB_POINT_TYPE_GENERIC = 500),    // Adds in slime core deconing
	/obj/item/slime_extract/metal = list(TECHWEB_POINT_TYPE_GENERIC = 750),
	/obj/item/slime_extract/purple = list(TECHWEB_POINT_TYPE_GENERIC = 750),
	/obj/item/slime_extract/orange = list(TECHWEB_POINT_TYPE_GENERIC = 750),
	/obj/item/slime_extract/blue = list(TECHWEB_POINT_TYPE_GENERIC = 750),
	/obj/item/slime_extract/yellow = list(TECHWEB_POINT_TYPE_GENERIC = 1000),
	/obj/item/slime_extract/silver = list(TECHWEB_POINT_TYPE_GENERIC = 1000),
	/obj/item/slime_extract/darkblue = list(TECHWEB_POINT_TYPE_GENERIC = 1000),
	/obj/item/slime_extract/darkpurple = list(TECHWEB_POINT_TYPE_GENERIC = 1000),
	/obj/item/slime_extract/bluespace = list(TECHWEB_POINT_TYPE_GENERIC = 1250),
	/obj/item/slime_extract/sepia = list(TECHWEB_POINT_TYPE_GENERIC = 1250),
	/obj/item/slime_extract/cerulean = list(TECHWEB_POINT_TYPE_GENERIC = 1250),
	/obj/item/slime_extract/pyrite = list(TECHWEB_POINT_TYPE_GENERIC = 1250),
	/obj/item/slime_extract/red = list(TECHWEB_POINT_TYPE_GENERIC = 1250),
	/obj/item/slime_extract/green = list(TECHWEB_POINT_TYPE_GENERIC = 1250),
	/obj/item/slime_extract/pink = list(TECHWEB_POINT_TYPE_GENERIC = 1250),
	/obj/item/slime_extract/gold = list(TECHWEB_POINT_TYPE_GENERIC = 1250),
	/obj/item/slime_extract/black = list(TECHWEB_POINT_TYPE_GENERIC = 1500),
	/obj/item/slime_extract/adamantine =list (TECHWEB_POINT_TYPE_GENERIC = 1500),
	/obj/item/slime_extract/oil = list(TECHWEB_POINT_TYPE_GENERIC = 1500),
	/obj/item/slime_extract/lightpink = list(TECHWEB_POINT_TYPE_GENERIC = 1500),
	/obj/item/slime_extract/rainbow = list(TECHWEB_POINT_TYPE_GENERIC = 2500),
		//  Reproductive -    Crossbreading Cores!    - (Grey Cores)
	/obj/item/slimecross/reproductive/grey = list(TECHWEB_POINT_TYPE_GENERIC = 1000),
	/obj/item/slimecross/reproductive/orange = list(TECHWEB_POINT_TYPE_GENERIC = 1500),
	/obj/item/slimecross/reproductive/purple = list(TECHWEB_POINT_TYPE_GENERIC = 1500),
	/obj/item/slimecross/reproductive/blue = list(TECHWEB_POINT_TYPE_GENERIC = 1500),
	/obj/item/slimecross/reproductive/metal = list(TECHWEB_POINT_TYPE_GENERIC = 1500),
	/obj/item/slimecross/reproductive/yellow = list(TECHWEB_POINT_TYPE_GENERIC = 1750),
	/obj/item/slimecross/reproductive/darkpurple = list(TECHWEB_POINT_TYPE_GENERIC = 1750),
	/obj/item/slimecross/reproductive/darkblue = list(TECHWEB_POINT_TYPE_GENERIC = 1750),
	/obj/item/slimecross/reproductive/silver = list(TECHWEB_POINT_TYPE_GENERIC = 1750),
	/obj/item/slimecross/reproductive/bluespace = list(TECHWEB_POINT_TYPE_GENERIC = 2000),
	/obj/item/slimecross/reproductive/sepia = list(TECHWEB_POINT_TYPE_GENERIC = 2000),
	/obj/item/slimecross/reproductive/cerulean = list(TECHWEB_POINT_TYPE_GENERIC = 2000),
	/obj/item/slimecross/reproductive/pyrite = list(TECHWEB_POINT_TYPE_GENERIC = 2000),
	/obj/item/slimecross/reproductive/red = list(TECHWEB_POINT_TYPE_GENERIC = 2250),
	/obj/item/slimecross/reproductive/green = list(TECHWEB_POINT_TYPE_GENERIC = 2250),
	/obj/item/slimecross/reproductive/pink = list(TECHWEB_POINT_TYPE_GENERIC = 2250),
	/obj/item/slimecross/reproductive/gold = list(TECHWEB_POINT_TYPE_GENERIC = 2250),
	/obj/item/slimecross/reproductive/oil = list(TECHWEB_POINT_TYPE_GENERIC = 2500),
	/obj/item/slimecross/reproductive/black = list(TECHWEB_POINT_TYPE_GENERIC = 2500),
	/obj/item/slimecross/reproductive/lightpink = list(TECHWEB_POINT_TYPE_GENERIC = 2500),
	/obj/item/slimecross/reproductive/adamantine = list(TECHWEB_POINT_TYPE_GENERIC = 2500),
	/obj/item/slimecross/reproductive/rainbow = list(TECHWEB_POINT_TYPE_GENERIC = 2750),
	//  Burning -    Crossbreading Cores!    - (Orange Cores)
	/obj/item/slimecross/burning/grey = list(TECHWEB_POINT_TYPE_GENERIC = 2000),
	/obj/item/slimecross/burning/orange = list(TECHWEB_POINT_TYPE_GENERIC = 2500),
	/obj/item/slimecross/burning/purple = list(TECHWEB_POINT_TYPE_GENERIC = 2500),
	/obj/item/slimecross/burning/blue = list(TECHWEB_POINT_TYPE_GENERIC = 2500),
	/obj/item/slimecross/burning/metal = list(TECHWEB_POINT_TYPE_GENERIC = 2500),
	/obj/item/slimecross/burning/yellow = list(TECHWEB_POINT_TYPE_GENERIC = 2750),
	/obj/item/slimecross/burning/darkpurple = list(TECHWEB_POINT_TYPE_GENERIC = 2750),
	/obj/item/slimecross/burning/darkblue = list(TECHWEB_POINT_TYPE_GENERIC = 2750),
	/obj/item/slimecross/burning/silver = list(TECHWEB_POINT_TYPE_GENERIC = 2750),
	/obj/item/slimecross/burning/bluespace = list(TECHWEB_POINT_TYPE_GENERIC = 3000),
	/obj/item/slimecross/burning/sepia = list(TECHWEB_POINT_TYPE_GENERIC = 3000),
	/obj/item/slimecross/burning/cerulean = list(TECHWEB_POINT_TYPE_GENERIC = 3000),
	/obj/item/slimecross/burning/pyrite = list(TECHWEB_POINT_TYPE_GENERIC = 3000),
	/obj/item/slimecross/burning/red = list(TECHWEB_POINT_TYPE_GENERIC = 3250),
	/obj/item/slimecross/burning/green = list(TECHWEB_POINT_TYPE_GENERIC = 3250),
	/obj/item/slimecross/burning/pink = list(TECHWEB_POINT_TYPE_GENERIC = 3250),
	/obj/item/slimecross/burning/gold = list(TECHWEB_POINT_TYPE_GENERIC = 3250),
	/obj/item/slimecross/burning/oil = list(TECHWEB_POINT_TYPE_GENERIC = 3500),
	/obj/item/slimecross/burning/black = list(TECHWEB_POINT_TYPE_GENERIC = 3500),
	/obj/item/slimecross/burning/lightpink = list(TECHWEB_POINT_TYPE_GENERIC = 3500),
	/obj/item/slimecross/burning/adamantine = list(TECHWEB_POINT_TYPE_GENERIC = 3500),
	/obj/item/slimecross/burning/rainbow = list(TECHWEB_POINT_TYPE_GENERIC = 3750),
		//  Regenerative -    Crossbreading Cores!    - (Purple Cores)
	/obj/item/slimecross/regenerative/grey = list(TECHWEB_POINT_TYPE_GENERIC = 2000),
	/obj/item/slimecross/regenerative/orange = list(TECHWEB_POINT_TYPE_GENERIC = 2500),
	/obj/item/slimecross/regenerative/purple = list(TECHWEB_POINT_TYPE_GENERIC = 2500),
	/obj/item/slimecross/regenerative/blue = list(TECHWEB_POINT_TYPE_GENERIC = 2500),
	/obj/item/slimecross/regenerative/metal = list(TECHWEB_POINT_TYPE_GENERIC = 2500),
	/obj/item/slimecross/regenerative/yellow = list(TECHWEB_POINT_TYPE_GENERIC = 2750),
	/obj/item/slimecross/regenerative/darkpurple = list(TECHWEB_POINT_TYPE_GENERIC = 2750),
	/obj/item/slimecross/regenerative/darkblue = list(TECHWEB_POINT_TYPE_GENERIC = 2750),
	/obj/item/slimecross/regenerative/silver = list(TECHWEB_POINT_TYPE_GENERIC = 2750),
	/obj/item/slimecross/regenerative/bluespace = list(TECHWEB_POINT_TYPE_GENERIC = 3000),
	/obj/item/slimecross/regenerative/sepia = list(TECHWEB_POINT_TYPE_GENERIC = 3000),
	/obj/item/slimecross/regenerative/cerulean = list(TECHWEB_POINT_TYPE_GENERIC = 3000),
	/obj/item/slimecross/regenerative/pyrite = list(TECHWEB_POINT_TYPE_GENERIC = 3000),
	/obj/item/slimecross/regenerative/red = list(TECHWEB_POINT_TYPE_GENERIC = 3250),
	/obj/item/slimecross/regenerative/green = list(TECHWEB_POINT_TYPE_GENERIC = 3250),
	/obj/item/slimecross/regenerative/pink = list(TECHWEB_POINT_TYPE_GENERIC = 3250),
	/obj/item/slimecross/regenerative/gold = list(TECHWEB_POINT_TYPE_GENERIC = 3250),
	/obj/item/slimecross/regenerative/oil = list(TECHWEB_POINT_TYPE_GENERIC = 3500),
	/obj/item/slimecross/regenerative/black = list(TECHWEB_POINT_TYPE_GENERIC = 3500),
	/obj/item/slimecross/regenerative/lightpink = list(TECHWEB_POINT_TYPE_GENERIC = 3500),
	/obj/item/slimecross/regenerative/adamantine = list(TECHWEB_POINT_TYPE_GENERIC = 3500),
	/obj/item/slimecross/regenerative/rainbow = list(TECHWEB_POINT_TYPE_GENERIC = 3750),
		//  Stabilized -    Crossbreading Cores!    - (Blue Cores)
	/obj/item/slimecross/stabilized/grey = list(TECHWEB_POINT_TYPE_GENERIC = 2000),
	/obj/item/slimecross/stabilized/orange = list(TECHWEB_POINT_TYPE_GENERIC = 2500),
	/obj/item/slimecross/stabilized/purple = list(TECHWEB_POINT_TYPE_GENERIC = 2500),
	/obj/item/slimecross/stabilized/blue = list(TECHWEB_POINT_TYPE_GENERIC = 2500),
	/obj/item/slimecross/stabilized/metal = list(TECHWEB_POINT_TYPE_GENERIC = 2500),
	/obj/item/slimecross/stabilized/yellow = list(TECHWEB_POINT_TYPE_GENERIC = 2750),
	/obj/item/slimecross/stabilized/darkpurple = list(TECHWEB_POINT_TYPE_GENERIC = 2750),
	/obj/item/slimecross/stabilized/darkblue = list(TECHWEB_POINT_TYPE_GENERIC = 2750),
	/obj/item/slimecross/stabilized/silver = list(TECHWEB_POINT_TYPE_GENERIC = 2750),
	/obj/item/slimecross/stabilized/bluespace = list(TECHWEB_POINT_TYPE_GENERIC = 3000),
	/obj/item/slimecross/stabilized/sepia = list(TECHWEB_POINT_TYPE_GENERIC = 3000),
	/obj/item/slimecross/stabilized/cerulean = list(TECHWEB_POINT_TYPE_GENERIC = 3000),
	/obj/item/slimecross/stabilized/pyrite = list(TECHWEB_POINT_TYPE_GENERIC = 3000),
	/obj/item/slimecross/stabilized/red = list(TECHWEB_POINT_TYPE_GENERIC = 3250),
	/obj/item/slimecross/stabilized/green = list(TECHWEB_POINT_TYPE_GENERIC = 3250),
	/obj/item/slimecross/stabilized/pink = list(TECHWEB_POINT_TYPE_GENERIC = 3250),
	/obj/item/slimecross/stabilized/gold = list(TECHWEB_POINT_TYPE_GENERIC = 3250),
	/obj/item/slimecross/stabilized/oil = list(TECHWEB_POINT_TYPE_GENERIC = 3500),
	/obj/item/slimecross/stabilized/black = list(TECHWEB_POINT_TYPE_GENERIC = 3500),
	/obj/item/slimecross/stabilized/lightpink = list(TECHWEB_POINT_TYPE_GENERIC = 3500),
	/obj/item/slimecross/stabilized/adamantine = list(TECHWEB_POINT_TYPE_GENERIC = 3500),
	/obj/item/slimecross/stabilized/rainbow = list(TECHWEB_POINT_TYPE_GENERIC = 3750),
		//  Industrial -    Crossbreading Cores!    - (Metal Cores)
	/obj/item/slimecross/industrial/grey = list(TECHWEB_POINT_TYPE_GENERIC = 2000),
	/obj/item/slimecross/industrial/orange = list(TECHWEB_POINT_TYPE_GENERIC = 2500),
	/obj/item/slimecross/industrial/purple = list(TECHWEB_POINT_TYPE_GENERIC = 2500),
	/obj/item/slimecross/industrial/blue = list(TECHWEB_POINT_TYPE_GENERIC = 2500),
	/obj/item/slimecross/industrial/metal = list(TECHWEB_POINT_TYPE_GENERIC = 2500),
	/obj/item/slimecross/industrial/yellow = list(TECHWEB_POINT_TYPE_GENERIC = 2750),
	/obj/item/slimecross/industrial/darkpurple = list(TECHWEB_POINT_TYPE_GENERIC = 2750),
	/obj/item/slimecross/industrial/darkblue = list(TECHWEB_POINT_TYPE_GENERIC = 2750),
	/obj/item/slimecross/industrial/silver = list(TECHWEB_POINT_TYPE_GENERIC = 2750),
	/obj/item/slimecross/industrial/bluespace = list(TECHWEB_POINT_TYPE_GENERIC = 3000),
	/obj/item/slimecross/industrial/sepia = list(TECHWEB_POINT_TYPE_GENERIC = 3000),
	/obj/item/slimecross/industrial/cerulean = list(TECHWEB_POINT_TYPE_GENERIC = 3000),
	/obj/item/slimecross/industrial/pyrite = list(TECHWEB_POINT_TYPE_GENERIC = 3000),
	/obj/item/slimecross/industrial/red = list(TECHWEB_POINT_TYPE_GENERIC = 3250),
	/obj/item/slimecross/industrial/green = list(TECHWEB_POINT_TYPE_GENERIC = 3250),
	/obj/item/slimecross/industrial/pink = list(TECHWEB_POINT_TYPE_GENERIC = 3250),
	/obj/item/slimecross/industrial/gold = list(TECHWEB_POINT_TYPE_GENERIC = 3250),
	/obj/item/slimecross/industrial/oil = list(TECHWEB_POINT_TYPE_GENERIC = 3500),
	/obj/item/slimecross/industrial/black = list(TECHWEB_POINT_TYPE_GENERIC = 3500),
	/obj/item/slimecross/industrial/lightpink = list(TECHWEB_POINT_TYPE_GENERIC = 3500),
	/obj/item/slimecross/industrial/adamantine = list(TECHWEB_POINT_TYPE_GENERIC = 3500),
	/obj/item/slimecross/industrial/rainbow = list(TECHWEB_POINT_TYPE_GENERIC = 3750),
		//  Charged -    Crossbreading Cores!    - (Yellow Cores)
	/obj/item/slimecross/charged/grey = list(TECHWEB_POINT_TYPE_GENERIC = 2250),
	/obj/item/slimecross/charged/orange = list(TECHWEB_POINT_TYPE_GENERIC = 2750),
	/obj/item/slimecross/charged/purple = list(TECHWEB_POINT_TYPE_GENERIC = 2750),
	/obj/item/slimecross/charged/blue = list(TECHWEB_POINT_TYPE_GENERIC = 2750),
	/obj/item/slimecross/charged/metal = list(TECHWEB_POINT_TYPE_GENERIC = 2750),
	/obj/item/slimecross/charged/yellow = list(TECHWEB_POINT_TYPE_GENERIC = 3000),
	/obj/item/slimecross/charged/darkpurple = list(TECHWEB_POINT_TYPE_GENERIC = 3000),
	/obj/item/slimecross/charged/darkblue = list(TECHWEB_POINT_TYPE_GENERIC = 3000),
	/obj/item/slimecross/charged/silver = list(TECHWEB_POINT_TYPE_GENERIC = 3000),
	/obj/item/slimecross/charged/bluespace = list(TECHWEB_POINT_TYPE_GENERIC = 3250),
	/obj/item/slimecross/charged/sepia = list(TECHWEB_POINT_TYPE_GENERIC = 3250),
	/obj/item/slimecross/charged/cerulean = list(TECHWEB_POINT_TYPE_GENERIC = 3250),
	/obj/item/slimecross/charged/pyrite = list(TECHWEB_POINT_TYPE_GENERIC = 3250),
	/obj/item/slimecross/charged/red = list(TECHWEB_POINT_TYPE_GENERIC = 3500),
	/obj/item/slimecross/charged/green = list(TECHWEB_POINT_TYPE_GENERIC = 3500),
	/obj/item/slimecross/charged/pink = list(TECHWEB_POINT_TYPE_GENERIC = 3500),
	/obj/item/slimecross/charged/gold = list(TECHWEB_POINT_TYPE_GENERIC = 3500),
	/obj/item/slimecross/charged/oil = list(TECHWEB_POINT_TYPE_GENERIC = 3750),
	/obj/item/slimecross/charged/black = list(TECHWEB_POINT_TYPE_GENERIC = 3750),
	/obj/item/slimecross/charged/lightpink = list(TECHWEB_POINT_TYPE_GENERIC = 3750),
	/obj/item/slimecross/charged/adamantine = list(TECHWEB_POINT_TYPE_GENERIC = 3750),
	/obj/item/slimecross/charged/rainbow = list(TECHWEB_POINT_TYPE_GENERIC = 4000),
			//  Selfsustaining -    Crossbreading Cores!    - (Dark Purple Cores)
	/obj/item/slimecross/selfsustaining/grey = list(TECHWEB_POINT_TYPE_GENERIC = 2250),
	/obj/item/slimecross/selfsustaining/orange = list(TECHWEB_POINT_TYPE_GENERIC = 2750),
	/obj/item/slimecross/selfsustaining/purple = list(TECHWEB_POINT_TYPE_GENERIC = 2750),
	/obj/item/slimecross/selfsustaining/blue = list(TECHWEB_POINT_TYPE_GENERIC = 2750),
	/obj/item/slimecross/selfsustaining/metal = list(TECHWEB_POINT_TYPE_GENERIC = 2750),
	/obj/item/slimecross/selfsustaining/yellow = list(TECHWEB_POINT_TYPE_GENERIC = 3000),
	/obj/item/slimecross/selfsustaining/darkpurple = list(TECHWEB_POINT_TYPE_GENERIC = 3000),
	/obj/item/slimecross/selfsustaining/darkblue = list(TECHWEB_POINT_TYPE_GENERIC = 3000),
	/obj/item/slimecross/selfsustaining/silver = list(TECHWEB_POINT_TYPE_GENERIC = 3000),
	/obj/item/slimecross/selfsustaining/bluespace = list(TECHWEB_POINT_TYPE_GENERIC = 3250),
	/obj/item/slimecross/selfsustaining/sepia = list(TECHWEB_POINT_TYPE_GENERIC = 3250),
	/obj/item/slimecross/selfsustaining/cerulean = list(TECHWEB_POINT_TYPE_GENERIC = 3250),
	/obj/item/slimecross/selfsustaining/pyrite = list(TECHWEB_POINT_TYPE_GENERIC = 3250),
	/obj/item/slimecross/selfsustaining/red = list(TECHWEB_POINT_TYPE_GENERIC = 3500),
	/obj/item/slimecross/selfsustaining/green = list(TECHWEB_POINT_TYPE_GENERIC = 3500),
	/obj/item/slimecross/selfsustaining/pink = list(TECHWEB_POINT_TYPE_GENERIC = 3500),
	/obj/item/slimecross/selfsustaining/gold = list(TECHWEB_POINT_TYPE_GENERIC = 3500),
	/obj/item/slimecross/selfsustaining/oil = list(TECHWEB_POINT_TYPE_GENERIC = 3750),
	/obj/item/slimecross/selfsustaining/black = list(TECHWEB_POINT_TYPE_GENERIC = 3750),
	/obj/item/slimecross/selfsustaining/lightpink = list(TECHWEB_POINT_TYPE_GENERIC = 3750),
	/obj/item/slimecross/selfsustaining/adamantine = list(TECHWEB_POINT_TYPE_GENERIC = 3750),
	/obj/item/slimecross/selfsustaining/rainbow = list(TECHWEB_POINT_TYPE_GENERIC = 4000),
			//  Consuming -    Crossbreading Cores!    - (Sliver Cores)
	/obj/item/slimecross/consuming/grey = list(TECHWEB_POINT_TYPE_GENERIC = 2250),
	/obj/item/slimecross/consuming/orange = list(TECHWEB_POINT_TYPE_GENERIC = 2750),
	/obj/item/slimecross/consuming/purple = list(TECHWEB_POINT_TYPE_GENERIC = 2750),
	/obj/item/slimecross/consuming/blue = list(TECHWEB_POINT_TYPE_GENERIC = 2750),
	/obj/item/slimecross/consuming/metal = list(TECHWEB_POINT_TYPE_GENERIC = 2750),
	/obj/item/slimecross/consuming/yellow = list(TECHWEB_POINT_TYPE_GENERIC = 3000),
	/obj/item/slimecross/consuming/darkpurple = list(TECHWEB_POINT_TYPE_GENERIC = 3000),
	/obj/item/slimecross/consuming/darkblue = list(TECHWEB_POINT_TYPE_GENERIC = 3000),
	/obj/item/slimecross/consuming/silver = list(TECHWEB_POINT_TYPE_GENERIC = 3000),
	/obj/item/slimecross/consuming/bluespace = list(TECHWEB_POINT_TYPE_GENERIC = 3250),
	/obj/item/slimecross/consuming/sepia = list(TECHWEB_POINT_TYPE_GENERIC = 3250),
	/obj/item/slimecross/consuming/cerulean = list(TECHWEB_POINT_TYPE_GENERIC = 3250),
	/obj/item/slimecross/consuming/pyrite = list(TECHWEB_POINT_TYPE_GENERIC = 3250),
	/obj/item/slimecross/consuming/red = list(TECHWEB_POINT_TYPE_GENERIC = 3500),
	/obj/item/slimecross/consuming/green = list(TECHWEB_POINT_TYPE_GENERIC = 3500),
	/obj/item/slimecross/consuming/pink = list(TECHWEB_POINT_TYPE_GENERIC = 3500),
	/obj/item/slimecross/consuming/gold = list(TECHWEB_POINT_TYPE_GENERIC = 3500),
	/obj/item/slimecross/consuming/oil = list(TECHWEB_POINT_TYPE_GENERIC = 3750),
	/obj/item/slimecross/consuming/black = list(TECHWEB_POINT_TYPE_GENERIC = 3750),
	/obj/item/slimecross/consuming/lightpink = list(TECHWEB_POINT_TYPE_GENERIC = 3750),
	/obj/item/slimecross/consuming/adamantine = list(TECHWEB_POINT_TYPE_GENERIC = 3750),
	/obj/item/slimecross/consuming/rainbow = list(TECHWEB_POINT_TYPE_GENERIC = 4000),
		//  Prismatic -    Crossbreading Cores!    - (Pyrite Cores)
	/obj/item/slimecross/prismatic/grey = list(TECHWEB_POINT_TYPE_GENERIC = 2500),
	/obj/item/slimecross/prismatic/orange = list(TECHWEB_POINT_TYPE_GENERIC = 3000),
	/obj/item/slimecross/prismatic/purple = list(TECHWEB_POINT_TYPE_GENERIC = 3000),
	/obj/item/slimecross/prismatic/blue = list(TECHWEB_POINT_TYPE_GENERIC = 3000),
	/obj/item/slimecross/prismatic/metal = list(TECHWEB_POINT_TYPE_GENERIC = 3000),
	/obj/item/slimecross/prismatic/yellow = list(TECHWEB_POINT_TYPE_GENERIC = 3250),
	/obj/item/slimecross/prismatic/darkpurple = list(TECHWEB_POINT_TYPE_GENERIC = 3250),
	/obj/item/slimecross/prismatic/darkblue = list(TECHWEB_POINT_TYPE_GENERIC = 3250),
	/obj/item/slimecross/prismatic/silver = list(TECHWEB_POINT_TYPE_GENERIC = 3250),
	/obj/item/slimecross/prismatic/bluespace = list(TECHWEB_POINT_TYPE_GENERIC = 3500),
	/obj/item/slimecross/prismatic/sepia = list(TECHWEB_POINT_TYPE_GENERIC = 3500),
	/obj/item/slimecross/prismatic/cerulean = list(TECHWEB_POINT_TYPE_GENERIC = 3500),
	/obj/item/slimecross/prismatic/pyrite = list(TECHWEB_POINT_TYPE_GENERIC = 3500),
	/obj/item/slimecross/prismatic/red = list(TECHWEB_POINT_TYPE_GENERIC = 3750),
	/obj/item/slimecross/prismatic/green = list(TECHWEB_POINT_TYPE_GENERIC = 3750),
	/obj/item/slimecross/prismatic/pink = list(TECHWEB_POINT_TYPE_GENERIC = 3750),
	/obj/item/slimecross/prismatic/gold = list(TECHWEB_POINT_TYPE_GENERIC = 3750),
	/obj/item/slimecross/prismatic/oil = list(TECHWEB_POINT_TYPE_GENERIC = 4000),
	/obj/item/slimecross/prismatic/black = list(TECHWEB_POINT_TYPE_GENERIC = 4000),
	/obj/item/slimecross/prismatic/lightpink = list(TECHWEB_POINT_TYPE_GENERIC = 4000),
	/obj/item/slimecross/prismatic/adamantine = list(TECHWEB_POINT_TYPE_GENERIC = 4000),
	/obj/item/slimecross/prismatic/rainbow = list(TECHWEB_POINT_TYPE_GENERIC = 4250),
		//  Recurring -    Crossbreading Cores!    - (Cerulean Cores)
	/obj/item/slimecross/recurring/grey = list(TECHWEB_POINT_TYPE_GENERIC = 2500),
	/obj/item/slimecross/recurring/orange = list(TECHWEB_POINT_TYPE_GENERIC = 3000),
	/obj/item/slimecross/recurring/purple = list(TECHWEB_POINT_TYPE_GENERIC = 3000),
	/obj/item/slimecross/recurring/blue = list(TECHWEB_POINT_TYPE_GENERIC = 3000),
	/obj/item/slimecross/recurring/metal = list(TECHWEB_POINT_TYPE_GENERIC = 3000),
	/obj/item/slimecross/recurring/yellow = list(TECHWEB_POINT_TYPE_GENERIC = 3250),
	/obj/item/slimecross/recurring/darkpurple = list(TECHWEB_POINT_TYPE_GENERIC = 3250),
	/obj/item/slimecross/recurring/darkblue = list(TECHWEB_POINT_TYPE_GENERIC = 3250),
	/obj/item/slimecross/recurring/silver = list(TECHWEB_POINT_TYPE_GENERIC = 3250),
	/obj/item/slimecross/recurring/bluespace = list(TECHWEB_POINT_TYPE_GENERIC = 3500),
	/obj/item/slimecross/recurring/sepia = list(TECHWEB_POINT_TYPE_GENERIC = 3500),
	/obj/item/slimecross/recurring/cerulean = list(TECHWEB_POINT_TYPE_GENERIC = 3500),
	/obj/item/slimecross/recurring/pyrite = list(TECHWEB_POINT_TYPE_GENERIC = 3500),
	/obj/item/slimecross/recurring/red = list(TECHWEB_POINT_TYPE_GENERIC = 3750),
	/obj/item/slimecross/recurring/green = list(TECHWEB_POINT_TYPE_GENERIC = 3750),
	/obj/item/slimecross/recurring/pink = list(TECHWEB_POINT_TYPE_GENERIC = 3750),
	/obj/item/slimecross/recurring/gold = list(TECHWEB_POINT_TYPE_GENERIC = 3750),
	/obj/item/slimecross/recurring/oil = list(TECHWEB_POINT_TYPE_GENERIC = 4000),
	/obj/item/slimecross/recurring/black = list(TECHWEB_POINT_TYPE_GENERIC = 4000),
	/obj/item/slimecross/recurring/lightpink = list(TECHWEB_POINT_TYPE_GENERIC = 4000),
	/obj/item/slimecross/recurring/adamantine = list(TECHWEB_POINT_TYPE_GENERIC = 4000),
	/obj/item/slimecross/recurring/rainbow = list(TECHWEB_POINT_TYPE_GENERIC = 4250)
	)      // End of Cit changes
	var/list/errored_datums = list()
	var/list/point_types = list()				//typecache style type = TRUE list
	//----------------------------------------------
	var/list/single_server_income = list(TECHWEB_POINT_TYPE_GENERIC = 35)	//citadel edit - techwebs nerf
	var/multiserver_calculation = FALSE
	var/last_income
	//^^^^^^^^ ALL OF THESE ARE PER SECOND! ^^^^^^^^

	//Aiming for 1.5 hours to max R&D
	//[88nodes * 5000points/node] / [1.5hr * 90min/hr * 60s/min]
	//Around 450000 points max???

/datum/controller/subsystem/research/Initialize()
	point_types = TECHWEB_POINT_TYPE_LIST_ASSOCIATIVE_NAMES
	initialize_all_techweb_designs()
	initialize_all_techweb_nodes()
	science_tech = new /datum/techweb/science
	admin_tech = new /datum/techweb/admin
	autosort_categories()
	return ..()

/datum/controller/subsystem/research/fire()
	var/list/bitcoins = list()
	if(multiserver_calculation)
		var/eff = calculate_server_coefficient()
		for(var/obj/machinery/rnd/server/miner in servers)
			var/list/result = (miner.mine())	//SLAVE AWAY, SLAVE.
			for(var/i in result)
				result[i] *= eff
				bitcoins[i] = bitcoins[i]? bitcoins[i] + result[i] : result[i]
	else
		for(var/obj/machinery/rnd/server/miner in servers)
			if(miner.working)
				bitcoins = single_server_income.Copy()
				break			//Just need one to work.
	if (!isnull(last_income))
		var/income_time_difference = world.time - last_income
		science_tech.last_bitcoins = bitcoins  // Doesn't take tick drift into account
		for(var/i in bitcoins)
			bitcoins[i] *= income_time_difference / 10
		science_tech.add_point_list(bitcoins)
	last_income = world.time

/datum/controller/subsystem/research/proc/calculate_server_coefficient()	//Diminishing returns.
	var/amt = servers.len
	if(!amt)
		return 0
	var/coeff = 100
	coeff = sqrt(coeff / amt)
	return coeff

/datum/controller/subsystem/research/proc/autosort_categories()
	for(var/i in techweb_nodes)
		var/datum/techweb_node/I = techweb_nodes[i]
		if(techweb_categories[I.category])
			techweb_categories[I.category][I.id] = I
		else
			techweb_categories[I.category] = list(I.id = I)
