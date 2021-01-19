///////////////////////////////////
/////Headset Encryption////////////
///////////////////////////////////

/datum/design/encryption
		materials = list(/datum/material/iron = 500, /datum/material/glass = 500, /datum/material/silver = 200)
		build_type = PROTOLATHE | IMPRINTER
		construction_time = 50
		category = list("Subspace Telecomms")

/datum/design/encryption/eng_key
	name = "Engineering radio encryption key"
	desc = "Encryption key for the Engineering channel."
	id = "eng_key"
	build_path = /obj/item/encryptionkey/headset_eng
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING

/datum/design/encryption/sci_key
	name = "Science radio encryption key"
	desc = "Encryption key for the Science channel."
	id = "sci_key"
	build_path = /obj/item/encryptionkey/headset_sci
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE

/datum/design/encryption/supply_key
	name = "Supply radio encryption key"
	desc = "Encryption key for the Supply channel."
	id = "supply_key"
	build_path = /obj/item/encryptionkey/headset_cargo
	departmental_flags = DEPARTMENTAL_FLAG_CARGO

/datum/design/encryption/med_key
	name = "Medical radio encryption key"
	desc = "Encryption key for the Medical channel."
	id = "med_key"
	build_path = /obj/item/encryptionkey/headset_med
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL

/datum/design/encryption/serv_key
	name = "Service radio encryption key"
	desc = "Encryption key for the Service channel."
	id = "serv_key"
	build_path = /obj/item/encryptionkey/headset_service
	departmental_flags = DEPARTMENTAL_FLAG_SERVICE

///////////////////////////////////
////////Telecomm Server////////////
///////////////////////////////////

/datum/design/board/message_server
	name = "Machine Design (Message Server)"
	desc = "Allows for the construction of Message Server."
	id = "message-server"
	build_path = /obj/item/circuitboard/machine/telecomms/message_server
	category = list("Subspace Telecomms")
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING | DEPARTMENTAL_FLAG_SCIENCE
