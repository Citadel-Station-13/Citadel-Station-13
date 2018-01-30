/obj/machinery/disco
	/list/songs = list(
		new	/datum/track("This is how it goes", 						'sound/misc/Awoo1.ogg', 	2400, 	5),
		new /datum/track("Telephone Number", 							'sound/misc/Awoo2.ogg', 	2400, 	6),
		new /datum/track("Awoo", 										'sound/misc/Awoo3.ogg', 	2400, 	4),
		new	/datum/track("Wolf instinct",								'sound/misc/Awoo4.ogg',		2400, 	20),
		)

		list/available = list()
		if ("awoo")
			deejay('sound/misc/Awoo.ogg')