/datum/unit_test/character_saving/Run()
	try
		var/datum/preferences/P = new
		P.load_path("test")
		P.features["flavor_text"] = "Foo"
		P.features["ooc_notes"] = "Bar"
		P.save_character()
		P.load_character()
		if(P.features["flavor_text"] != "Foo")
			Fail("Flavor text is failing to save.")
		if(P.features["ooc_notes"] != "Bar")
			Fail("OOC text is failing to save.")
		P.save_character()
		P.load_character()
		if(P.features["flavor_text"] != "Foo")
			Fail("Repeated saving and loading possibly causing save deletion.")
	catch(var/exception/e)
		Fail("Failed to save and load character due to exception [e.file]:[e.line], [e.name]")
