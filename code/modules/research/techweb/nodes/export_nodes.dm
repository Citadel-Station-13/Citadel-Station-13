/datum/techweb_node/blueprinted_bottles
	id = "blueprinted_bottles"
	display_name = "License Bottling"
	description = "Some Branded bottles to print and export."
	starting_node = TRUE
	design_ids = list("gin", "wine", "whiskey", "vodka", "tequila", "patron", "rum", "kahlua", "vermouth", "goldschlager", "hcider", "cognac", "absinthe", "grappa", "sake", "fernet", "applejack", "champagne", "blazaam", "trappist", "grenadine", "autobottler")

/datum/techweb_node/blueprinted_exports
	id = "blueprinted_exports"
	display_name = "License Exports"
	description = "Some Branded bottles to print and export."
	starting_node = TRUE
	design_ids = list("gin_export", "wine_export", "whiskey_export", "vodka_export", "tequila_export", "patron_export", "rum_export", "kahlua_export", "vermouth_export", "goldschlager_export", "hcider_export", "cognac_export", "absinthe_export", "grappa_export", "sake_export", "fernet_export", "applejack_export", "champagne_export", "blazaam_export", "trappist_export", "grenadine_export")

/datum/techweb_node/bottle_exports
	id = "bottle_exports"
	display_name = "Advanced Bottling"
	prereq_ids = list("blueprinted_bottles")
	description = "New bottles for printing, storage and selling."
	design_ids = list("minikeg", "blooddrop", "slim_gold", "white_bloodmoon", "greenroad", "emptyglassbottle", "largeemptyglassbottle", "emptypitcher")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 250)
