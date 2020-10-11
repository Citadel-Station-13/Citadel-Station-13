// In here contains code and defaults for the clothing asset set system, aka "different sprites for different species."

/**
  * Gets a base appearance for a certain state with a certain asset set.
  */
/proc/get_base_worn_appearance(icon_state, asset_set)
	

GLOBAL_LIST_INIT(worn_asset_sets, initialize_worn_asset_sets())

/**
  * Initializes global list of clothing/worn asset sets. Must be a proc.
  */
/proc/initialize_worn_asset_sets()
	. = list()
	
