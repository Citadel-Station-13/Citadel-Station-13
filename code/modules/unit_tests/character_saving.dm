#define UNIT_TEST_SAVING_FLAVOR_TEXT "Space"
#define UNIT_TEST_SAVING_SILICON_FLAVOR_TEXT "Station"
#define UNIT_TEST_SAVING_OOC_NOTES "Thirteen"

/datum/unit_test/character_saving/Run()
	try
		var/datum/preferences/P = new
		P.load_path("test")
		P.features["flavor_text"] = UNIT_TEST_SAVING_FLAVOR_TEXT
		P.features["silicon_flavor_text"] = UNIT_TEST_SAVING_SILICON_FLAVOR_TEXT
		P.features["ooc_notes"] = UNIT_TEST_SAVING_OOC_NOTES
		P.save_character()
		P.load_character()
		if(P.features["flavor_text"] != UNIT_TEST_SAVING_FLAVOR_TEXT)
			TEST_FAIL("Flavor text is failing to save.")
		if(P.features["silicon_flavor_text"] != UNIT_TEST_SAVING_SILICON_FLAVOR_TEXT)
			TEST_FAIL("Silicon flavor text is failing to save.")
		if(P.features["ooc_notes"] != UNIT_TEST_SAVING_OOC_NOTES)
			TEST_FAIL("OOC text is failing to save.")
		P.save_character()
		P.load_character()
		if((P.features["flavor_text"] != UNIT_TEST_SAVING_FLAVOR_TEXT) || (P.features["silicon_flavor_text"] != UNIT_TEST_SAVING_SILICON_FLAVOR_TEXT) || (P.features["ooc_notes"] != UNIT_TEST_SAVING_OOC_NOTES))
			TEST_FAIL("Repeated saving and loading possibly causing save deletion.")
	catch(var/exception/e)
		TEST_FAIL("Failed to save and load character due to exception [e.file]:[e.line], [e.name]")

#undef UNIT_TEST_SAVING_FLAVOR_TEXT
#undef UNIT_TEST_SAVING_SILICON_FLAVOR_TEXT
#undef UNIT_TEST_SAVING_OOC_NOTES
