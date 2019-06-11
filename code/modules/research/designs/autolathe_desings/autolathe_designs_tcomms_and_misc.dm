///////////////////////////////////
//////////Autolathe Designs ///////
///////////////////////////////////
/////////////
////T-Comms//
/////////////

/datum/design/signaler
	name = "Remote Signaling Device"
	id = "signaler"
	build_type = AUTOLATHE
	materials = list(MAT_METAL = 400, MAT_GLASS = 120)
	build_path = /obj/item/assembly/signaler
	category = list("initial", "T-Comm")

/datum/design/radio_headset
	name = "Radio Headset"
	id = "radio_headset"
	build_type = AUTOLATHE
	materials = list(MAT_METAL = 75)
	build_path = /obj/item/radio/headset
	category = list("initial", "T-Comm")

/datum/design/bounced_radio
	name = "Station Bounced Radio"
	id = "bounced_radio"
	build_type = AUTOLATHE
	materials = list(MAT_METAL = 75, MAT_GLASS = 25)
	build_path = /obj/item/radio/off
	category = list("initial", "T-Comm")

/datum/design/intercom_frame
	name = "Intercom Frame"
	id = "intercom_frame"
	build_type = AUTOLATHE
	materials = list(MAT_METAL = 75, MAT_GLASS = 25)
	build_path = /obj/item/wallframe/intercom
	category = list("initial", "T-Comm")

/////////////
////MISC/////
/////////////

/datum/design/camera
	name = "Camera"
	id = "camera"
	build_type = AUTOLATHE
	materials = list(MAT_METAL = 50, MAT_GLASS = 100)
	build_path = /obj/item/camera
	category = list("initial", "Misc")

/datum/design/camera_film
	name = "Camera Film Cartridge"
	id = "camera_film"
	build_type = AUTOLATHE
	materials = list(MAT_METAL = 10, MAT_GLASS = 10)
	build_path = /obj/item/camera_film
	category = list("initial", "Misc")

/datum/design/earmuffs
	name = "Earmuffs"
	id = "earmuffs"
	build_type = AUTOLATHE
	materials = list(MAT_METAL = 500, MAT_GLASS = 500)
	build_path = /obj/item/clothing/ears/earmuffs
	category = list("initial", "Misc")

/datum/design/pipe_painter
	name = "Pipe Painter"
	id = "pipe_painter"
	build_type = AUTOLATHE
	materials = list(MAT_METAL = 5000, MAT_GLASS = 2000)
	build_path = /obj/item/pipe_painter
	category = list("initial", "Misc")

/datum/design/airlock_painter
	name = "Airlock Painter"
	id = "airlock_painter"
	build_type = AUTOLATHE
	materials = list(MAT_METAL = 50, MAT_GLASS = 50)
	build_path = /obj/item/airlock_painter
	category = list("initial", "Misc")

/datum/design/cultivator
	name = "Cultivator"
	id = "cultivator"
	build_type = AUTOLATHE
	materials = list(MAT_METAL=50)
	build_path = /obj/item/cultivator
	category = list("initial","Misc")

/datum/design/plant_analyzer
	name = "Plant Analyzer"
	id = "plant_analyzer"
	build_type = AUTOLATHE
	materials = list(MAT_METAL = 30, MAT_GLASS = 20)
	build_path = /obj/item/plant_analyzer
	category = list("initial","Misc")

/datum/design/shovel
	name = "Shovel"
	id = "shovel"
	build_type = AUTOLATHE
	materials = list(MAT_METAL = 50)
	build_path = /obj/item/shovel
	category = list("initial","Misc")

/datum/design/spade
	name = "Spade"
	id = "spade"
	build_type = AUTOLATHE
	materials = list(MAT_METAL = 50)
	build_path = /obj/item/shovel/spade
	category = list("initial","Misc")

/datum/design/hatchet
	name = "Hatchet"
	id = "hatchet"
	build_type = AUTOLATHE
	materials = list(MAT_METAL = 15000)
	build_path = /obj/item/hatchet
	category = list("initial","Misc")

/datum/design/recorder
	name = "Universal Recorder"
	id = "recorder"
	build_type = AUTOLATHE
	materials = list(MAT_METAL = 60, MAT_GLASS = 30)
	build_path = /obj/item/taperecorder/empty
	category = list("initial", "Misc")

/datum/design/tape
	name = "Tape"
	id = "tape"
	build_type = AUTOLATHE
	materials = list(MAT_METAL = 20, MAT_GLASS = 5)
	build_path = /obj/item/tape/random
	category = list("initial", "Misc")

/datum/design/igniter
	name = "Igniter"
	id = "igniter"
	build_type = AUTOLATHE
	materials = list(MAT_METAL = 500, MAT_GLASS = 50)
	build_path = /obj/item/assembly/igniter
	category = list("initial", "Misc")

/datum/design/infrared_emitter
	name = "Infrared Emitter"
	id = "infrared_emitter"
	build_type = AUTOLATHE
	materials = list(MAT_METAL = 1000, MAT_GLASS = 500)
	build_path = /obj/item/assembly/infra
	category = list("initial", "Misc")

/datum/design/timer
	name = "Timer"
	id = "timer"
	build_type = AUTOLATHE
	materials = list(MAT_METAL = 500, MAT_GLASS = 50)
	build_path = /obj/item/assembly/timer
	category = list("initial", "Misc")

/datum/design/voice_analyser
	name = "Voice Analyser"
	id = "voice_analyser"
	build_type = AUTOLATHE
	materials = list(MAT_METAL = 500, MAT_GLASS = 50)
	build_path = /obj/item/assembly/voice
	category = list("initial", "Misc")

/datum/design/prox_sensor
	name = "Proximity Sensor"
	id = "prox_sensor"
	build_type = AUTOLATHE
	materials = list(MAT_METAL = 800, MAT_GLASS = 200)
	build_path = /obj/item/assembly/prox_sensor
	category = list("initial", "Misc")

/datum/design/foam_dart
	name = "Box of Foam Darts"
	id = "foam_dart"
	build_type = AUTOLATHE
	materials = list(MAT_METAL = 500)
	build_path = /obj/item/ammo_box/foambox
	category = list("initial", "Misc")

/datum/design/laptop
	name = "Laptop Frame"
	id = "laptop"
	build_type = AUTOLATHE
	materials = list(MAT_METAL = 10000, MAT_GLASS = 1000)
	build_path = /obj/item/modular_computer/laptop/buildable
	category = list("initial","Misc")

/datum/design/tablet
	name = "Tablet Frame"
	id = "tablet"
	build_type = AUTOLATHE
	materials = list(MAT_METAL = 2000, MAT_GLASS = 1000)
	build_path = /obj/item/modular_computer/tablet
	category = list("initial","Misc")

/datum/design/slime_scanner
	name = "Slime Scanner"
	id = "slime_scanner"
	build_type = AUTOLATHE
	materials = list(MAT_METAL = 300, MAT_GLASS = 200)
	build_path = /obj/item/slime_scanner
	category = list("initial", "Misc")

/datum/design/pet_carrier
	name = "Pet Carrier"
	id = "pet_carrier"
	build_type = AUTOLATHE
	materials = list(MAT_METAL = 7500, MAT_GLASS = 100)
	build_path = /obj/item/pet_carrier
	category = list("initial", "Misc")

/datum/design/packageWrap
	name = "Package Wrapping"
	id = "packagewrap"
	build_type = AUTOLATHE
	materials = list(MAT_METAL = 200, MAT_GLASS = 200)
	build_path = /obj/item/stack/packageWrap
	category = list("initial", "Misc")
	maxstack = 30

/datum/design/holodisk
	name = "Holodisk"
	id = "holodisk"
	build_type = AUTOLATHE
	materials = list(MAT_METAL = 100, MAT_GLASS = 100)
	build_path = /obj/item/disk/holodisk
	category = list("initial", "Misc")

/datum/design/lock_collar
	name = "Lockable Collar"
	id = "lock_collar"
	build_type = AUTOLATHE
	materials = list(MAT_METAL = 1200, MAT_GLASS = 100)
	build_path = /obj/item/clothing/neck/petcollar/locked
	category = list("initial", "Misc")

/datum/design/collar_key
	name = "Collar Key"
	id = "collar_key"
	build_type = AUTOLATHE
	materials = list(MAT_METAL = 300, MAT_GLASS = 150)
	build_path = /obj/item/key/collar
	category = list("initial", "Misc")