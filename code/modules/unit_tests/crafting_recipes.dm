/datum/unit_test/crafting_recipes/Run()
	for(var/i in GLOB.crafting_recipes)
		var/datum/crafting_recipe/R = i
		if(!R.subcategory)
			Fail("Invalid subcategory on [R] ([R.type]).")
		if(!R.category && (R.cateogry != CAT_NONE))
			Fail("Invalid category on [R] ([R.type])")
