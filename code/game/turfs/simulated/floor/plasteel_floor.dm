/turf/open/floor/plasteel
	icon_state = "floor"
	floor_tile = /obj/item/stack/tile/plasteel
	broken_states = list("damaged1", "damaged2", "damaged3", "damaged4", "damaged5")
	burnt_states = list("floorscorched1", "floorscorched2")

/turf/open/floor/plasteel/examine(mob/user)
	. = ..()
	. += "<span class='notice'>There's a <b>small crack</b> on the edge of it.</span>"

/turf/open/floor/plasteel/update_icon()
	if(!..())
		return 0
	if(!broken && !burnt)
		icon_state = icon_regular_floor


/turf/open/floor/plasteel/airless
	initial_gas_mix = AIRLESS_ATMOS
/turf/open/floor/plasteel/telecomms
	initial_gas_mix = TCOMMS_ATMOS


/turf/open/floor/plasteel/dark
	icon_state = "darkfull"
/turf/open/floor/plasteel/dark/airless
	initial_gas_mix = AIRLESS_ATMOS
/turf/open/floor/plasteel/dark/telecomms
	initial_gas_mix = TCOMMS_ATMOS
/turf/open/floor/plasteel/airless/dark
	icon_state = "darkfull"
/turf/open/floor/plasteel/dark/side
	icon_state = "dark"
/turf/open/floor/plasteel/dark/corner
	icon_state = "darkcorner"
/turf/open/floor/plasteel/checker
	icon_state = "checker"


/turf/open/floor/plasteel/white
	icon_state = "white"
/turf/open/floor/plasteel/white/side
	icon_state = "whitehall"
/turf/open/floor/plasteel/white/corner
	icon_state = "whitecorner"
/turf/open/floor/plasteel/airless/white
	icon_state = "white"
/turf/open/floor/plasteel/airless/white/side
	icon_state = "whitehall"
/turf/open/floor/plasteel/airless/white/corner
	icon_state = "whitecorner"
/turf/open/floor/plasteel/white/telecomms
	initial_gas_mix = TCOMMS_ATMOS


/turf/open/floor/plasteel/yellowsiding
	icon_state = "yellowsiding"
/turf/open/floor/plasteel/yellowsiding/corner
	icon_state = "yellowcornersiding"


/turf/open/floor/plasteel/recharge_floor
	icon_state = "recharge_floor"
/turf/open/floor/plasteel/recharge_floor/asteroid
	icon_state = "recharge_floor_asteroid"


/turf/open/floor/plasteel/chapel
	icon_state = "chapel"

/turf/open/floor/plasteel/chapel_floor
	icon_state = "chapel_alt"

/turf/open/floor/plasteel/showroomfloor
	icon_state = "showroomfloor"


/turf/open/floor/plasteel/solarpanel
	icon_state = "solarpanel"
/turf/open/floor/plasteel/airless/solarpanel
	icon_state = "solarpanel"



/turf/open/floor/plasteel/freezer
	icon_state = "freezerfloor"
/turf/open/floor/plasteel/freezer/airless
	initial_gas_mix = AIRLESS_ATMOS

/turf/open/floor/plasteel/grimy
	icon_state = "grimy"
	tiled_dirt = FALSE

/turf/open/floor/plasteel/cafeteria
	icon_state = "cafeteria"

/turf/open/floor/plasteel/airless/cafeteria
	icon_state = "cafeteria"


/turf/open/floor/plasteel/cult
	icon_state = "cult"
	name = "engraved floor"

/turf/open/floor/plasteel/vaporwave
	icon_state = "pinkblack"

/turf/open/floor/plasteel/goonplaque
	icon_state = "plaque"
	name = "commemorative plaque"
	desc = "\"This is a plaque in honour of our comrades on the G4407 Stations. Hopefully TG4407 model can live up to your fame and fortune.\" Scratched in beneath that is a crude image of a meteor and a spaceman. The spaceman is laughing. The meteor is exploding."
	tiled_dirt = FALSE

/turf/open/floor/plasteel/cult/narsie_act()
	return
/turf/open/floor/plasteel/cult/airless
	initial_gas_mix = AIRLESS_ATMOS


/turf/open/floor/plasteel/stairs
	icon_state = "stairs"
	tiled_dirt = FALSE
/turf/open/floor/plasteel/stairs/left
	icon_state = "stairs-l"
/turf/open/floor/plasteel/stairs/medium
	icon_state = "stairs-m"
/turf/open/floor/plasteel/stairs/right
	icon_state = "stairs-r"
/turf/open/floor/plasteel/stairs/old
	icon_state = "stairs-old"


/turf/open/floor/plasteel/rockvault
	icon_state = "rockvault"
/turf/open/floor/plasteel/rockvault/alien
	icon_state = "alienvault"
/turf/open/floor/plasteel/rockvault/sandstone
	icon_state = "sandstonevault"


/turf/open/floor/plasteel/elevatorshaft
	icon_state = "elevatorshaft"

/turf/open/floor/plasteel/bluespace
	icon_state = "bluespace"

/turf/open/floor/plasteel/sepia
	icon_state = "sepia"

///////////////////////////////
// Pre-Applied Decal Floors //
//////////////////////////////

// Neutral
/turf/open/floor/plasteel/neutral
	icon_state = "neutral_full"
/turf/open/floor/plasteel/neutral/side
	icon_state = "neutral"
/turf/open/floor/plasteel/neutral/corner
	icon_state = "neutral_corner"

// Dark Neutral
/turf/open/floor/plasteel/dark/neutral
	icon_state = "dark_neutral_full"
/turf/open/floor/plasteel/dark/neutral/checker
	icon_state = "dark_neutral_checker"
/turf/open/floor/plasteel/dark/neutral/side
	icon_state = "dark_neutral"
/turf/open/floor/plasteel/dark/neutral/corner
	icon_state = "dark_neutral_corner"

// Dark Security
/turf/open/floor/plasteel/dark/security
	icon_state = "dark_red_full"
/turf/open/floor/plasteel/dark/security/checker
	icon_state = "dark_red_checker"
/turf/open/floor/plasteel/dark/security/side
	icon_state = "dark_red"
/turf/open/floor/plasteel/dark/security/corner
	icon_state = "dark_red_corner"

// Engineering
/turf/open/floor/plasteel/engineering
	icon_state = "engineering_full"
/turf/open/floor/plasteel/engineering/side
	icon_state = "engineering"
/turf/open/floor/plasteel/engineering/corner
	icon_state = "engineering_corner"

// Atmospherics
/turf/open/floor/plasteel/atmospherics
	icon_state = "atmospherics_full"
/turf/open/floor/plasteel/atmospherics/side
	icon_state = "atmospherics"
/turf/open/floor/plasteel/atmospherics/corner
	icon_state = "atmospherics_corner"

// Command
/turf/open/floor/plasteel/command
	icon_state = "command_full"
/turf/open/floor/plasteel/command/side
	icon_state = "command"
/turf/open/floor/plasteel/command/corner
	icon_state = "command_corner"

// Medical
/turf/open/floor/plasteel/medical
	icon_state = "medical_full"
/turf/open/floor/plasteel/medical/alt
	icon_state = "medical_alt"
/turf/open/floor/plasteel/medical/side
	icon_state = "medical"
/turf/open/floor/plasteel/medical/corner
	icon_state = "medical_corner"

// Security
/turf/open/floor/plasteel/security
	icon_state = "security_full"
/turf/open/floor/plasteel/security/side
	icon_state = "security"
/turf/open/floor/plasteel/security/corner
	icon_state = "security_corner"

// Cargo
/turf/open/floor/plasteel/cargo
	icon_state = "cargo_full"
/turf/open/floor/plasteel/cargo/side
	icon_state = "cargo"
/turf/open/floor/plasteel/cargo/corner
	icon_state = "cargo_corner"

// Misc
/turf/open/floor/plasteel/showroomfloor/shower
	icon_state = "shower"
/turf/open/floor/plasteel/goonplaque/alien
	icon_state = "plaque1"
	desc = "\"This is a plaque is a collaboration of iconography celebrating the peaceful collaboration between the people of Earth and distant alien species."
/turf/open/floor/plasteel/goonplaque/charter
	icon_state = "plaque2"
	desc = "\"A golden plaque. Etched into it is the introductory article for a cross-species interplanetary constitution, guaranteeing equal rights between species that Nanotrasen relunctantly agreed to."
