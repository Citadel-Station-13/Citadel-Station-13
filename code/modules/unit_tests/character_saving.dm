/datum/unit_test/character_saving/Run()
	try
		var/datum/preferences/P = new
		P.load_path("test")
		P.load_character(0)
		P.save_character()
	catch(exception/e)
		Fail("Failed to save and load character due to exception [e.name]")
