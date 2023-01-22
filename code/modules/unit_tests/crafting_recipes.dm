/datum/unit_test/crafting_recipes/Run()
	for(var/i in GLOB.crafting_recipes)
		var/datum/crafting_recipe/R = i
		if(!R.subcategory)
			TEST_FAIL("Invalid subcategory on [R] ([R.type]).")
		if(!R.category && (R.category != CAT_NONE))
			TEST_FAIL("Invalid category on [R] ([R.type])")
