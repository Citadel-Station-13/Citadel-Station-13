/*

### This file contains a list of all the areas in your station. Format is as follows:

/area/CATEGORY/OR/DESCRIPTOR/NAME   (you can make as many subdivisions as you want)
	name = "NICE NAME" (not required but makes things really nice)
	icon = 'ICON FILENAME' (defaults to 'icons/turf/areas.dmi')
	icon_state = "NAME OF ICON" (defaults to "unknown" (blank))
	requires_power = FALSE (defaults to true)
	ambience_index = AMBIENCE_GENERIC   (picks the ambience from an assoc list in ambience.dm)
	ambientsounds = list() (defaults to ambience_index's assoc on Initialize(). override it as "ambientsounds = list('sound/ambience/signal.ogg')" or by changing ambience_index)

NOTE: there are two lists of areas in the end of this file: centcom and station itself. Please maintain these lists valid. --rastaf0

*/


/*-----------------------------------------------------------------------------*/

/area/ai_monitored //stub defined ai_monitored.dm

/area/ai_monitored/turret_protected


/area/ai_monitored/turret_protected/AIsatextFP
	name = "AI Sat Ext"
	icon_state = "storage"

/area/ai_monitored/turret_protected/AIsatextFS
	name = "AI Sat Ext"
	icon_state = "storage"

/area/ai_monitored/turret_protected/AIsatextAS
	name = "AI Sat Ext"
	icon_state = "storage"

/area/ai_monitored/turret_protected/AIsatextAP
	name = "AI Sat Ext"
	icon_state = "storage"

/area/arrival
	requires_power = FALSE

/area/arrival/start
	name = "Arrival Area"
	icon_state = "start"

/area/admin
	name = "Admin room"
	icon_state = "start"

/area/space
	icon_state = "space"
	requires_power = TRUE
	always_unpowered = TRUE
	dynamic_lighting = DYNAMIC_LIGHTING_DISABLED
	power_light = FALSE
	power_equip = FALSE
	power_environ = FALSE
	area_flags = UNIQUE_AREA | NO_ALERTS
	outdoors = TRUE
	persistent_debris_allowed = FALSE
	ambientsounds = SPACE
	considered_hull_exterior = TRUE
	flags_1 = CAN_BE_DIRTY_1
	sound_environment = SOUND_AREA_SPACE

/area/space/nearstation
	icon_state = "space_near"
	dynamic_lighting = DYNAMIC_LIGHTING_IFSTARLIGHT

/area/space/station_ruins //Paint this area where you want station ruins to be allowed to spawn

/area/start
	name = "start area"
	icon_state = "start"
	requires_power = FALSE
	dynamic_lighting = DYNAMIC_LIGHTING_DISABLED
	has_gravity = STANDARD_GRAVITY


/area/testroom
	requires_power = FALSE
	name = "Test Room"
	icon_state = "storage"

//EXTRA

/area/asteroid
	name = "Asteroid"
	icon_state = "asteroid"
	requires_power = FALSE
	has_gravity = STANDARD_GRAVITY
	area_flags = UNIQUE_AREA
	// ambience_index = AMBIENCE_MINING
	ambientsounds = MINING
	flags_1 = CAN_BE_DIRTY_1
	sound_environment = SOUND_AREA_ASTEROID
	// min_ambience_cooldown = 70 SECONDS
	// max_ambience_cooldown = 220 SECONDS

/area/asteroid/nearstation
	dynamic_lighting = DYNAMIC_LIGHTING_FORCED
	// ambience_index = AMBIENCE_RUINS
	ambientsounds = RUINS
	always_unpowered = FALSE
	requires_power = TRUE
	area_flags = UNIQUE_AREA | BLOBS_ALLOWED

/area/asteroid/nearstation/bomb_site
	name = "Bomb Testing Asteroid"

/area/asteroid/cave
	name = "Asteroid - Underground"
	icon_state = "cave"
	requires_power = FALSE
	outdoors = TRUE
	area_flags = UNIQUE_AREA | NO_ALERTS

/area/asteroid/cave/space
	name = "Asteroid - Space"

/area/asteroid/artifactroom
	name = "Asteroid - Artifact"
	icon_state = "cave"
	ambientsounds = RUINS
	area_flags = UNIQUE_AREA | NO_ALERTS

/area/asteroid/artifactroom/Initialize(mapload)
	. = ..()
	set_dynamic_lighting()

//STATION13

//AI

/area/ai_monitored
	sound_environment = SOUND_AREA_STANDARD_STATION

/area/ai_monitored/aisat/exterior
	name = "AI Satellite Exterior"
	icon_state = "ai"
	// airlock_wires = /datum/wires/airlock/ai

/area/ai_monitored/command/storage/satellite
	name = "AI Satellite Maint"
	icon_state = "ai_storage"
	// ambience_index = AMBIENCE_DANGER
	ambientsounds = HIGHSEC
	// airlock_wires = /datum/wires/airlock/ai

//AI - Turret_protected

/area/ai_monitored/turret_protected
	ambientsounds = list('sound/ambience/ambimalf.ogg', 'sound/ambience/ambitech.ogg', 'sound/ambience/ambitech2.ogg', 'sound/ambience/ambiatmos.ogg', 'sound/ambience/ambiatmos2.ogg')
	// airlock_wires = /datum/wires/airlock/ai

/area/ai_monitored/turret_protected/ai_upload
	name = "AI Upload Chamber"
	icon_state = "ai_upload"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/ai_monitored/turret_protected/ai_upload_foyer
	name = "AI Upload Access"
	icon_state = "ai_upload_foyer"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/ai_monitored/turret_protected/ai
	name = "AI Chamber"
	icon_state = "ai_chamber"

/area/ai_monitored/turret_protected/aisat
	name = "AI Satellite"
	icon_state = "ai"
	sound_environment = SOUND_ENVIRONMENT_ROOM

/area/ai_monitored/turret_protected/aisat/atmos
	name = "AI Satellite Atmos"
	icon_state = "ai"

/area/ai_monitored/turret_protected/aisat/foyer
	name = "AI Satellite Foyer"
	icon_state = "ai_foyer"

/area/ai_monitored/turret_protected/aisat/service
	name = "AI Satellite Service"
	icon_state = "ai"

/area/ai_monitored/turret_protected/aisat/hallway
	name = "AI Satellite Hallway"
	icon_state = "ai"

/area/ai_monitored/turret_protected/aisat_interior
	name = "AI Satellite Antechamber"
	icon_state = "ai_interior"
	sound_environment = SOUND_AREA_LARGE_ENCLOSED

/area/ai_monitored/turret_protected/ai_sat_ext_as
	name = "AI Sat Ext"
	icon_state = "ai_sat_east"

/area/ai_monitored/turret_protected/ai_sat_ext_ap
	name = "AI Sat Ext"
	icon_state = "ai_sat_west"

//Maintenance

/area/maintenance
	name = "Generic Maintenance"
	// ambience_index = AMBIENCE_MAINT
	ambientsounds = MAINTENANCE
	area_flags = BLOBS_ALLOWED | UNIQUE_AREA | CULT_PERMITTED
	// airlock_wires = /datum/wires/airlock/maint
	sound_environment = SOUND_AREA_TUNNEL_ENCLOSED
	minimap_color = "#454545"

//Maintenance - Departmental

/area/maintenance/department/chapel
	name = "Chapel Maintenance"
	icon_state = "maint_chapel"

/area/maintenance/department/chapel/monastery
	name = "Monastery Maintenance"
	icon_state = "maint_monastery"

/area/maintenance/department/crew_quarters/bar
	name = "Bar Maintenance"
	icon_state = "maint_bar"
	sound_environment = SOUND_AREA_WOODFLOOR

/area/maintenance/department/crew_quarters/dorms
	name = "Dormitory Maintenance"
	icon_state = "maint_dorms"

/area/maintenance/department/crew_quarters/locker
	name = "Locker Room Maintenance"
	icon_state = "maint_locker"

/area/maintenance/department/eva
	name = "EVA Maintenance"
	icon_state = "maint_eva"

/area/maintenance/department/electrical
	name = "Electrical Maintenance"
	icon_state = "maint_electrical"

/area/maintenance/department/engine/atmos
	name = "Atmospherics Maintenance"
	icon_state = "maint_atmos"

/area/maintenance/department/security
	name = "Security Maintenance"
	icon_state = "maint_sec"

/area/maintenance/department/security/upper
	name = "Upper Security Maintenance"

/area/maintenance/department/security/brig
	name = "Brig Maintenance"
	icon_state = "maint_brig"

/area/maintenance/department/medical
	name = "Medbay Maintenance"
	icon_state = "medbay_maint"

/area/maintenance/department/medical/central
	name = "Central Medbay Maintenance"
	icon_state = "medbay_maint_central"

/area/maintenance/department/medical/morgue
	name = "Morgue Maintenance"
	icon_state = "morgue_maint"

/area/maintenance/department/science
	name = "Science Maintenance"
	icon_state = "maint_sci"

/area/maintenance/department/science/central
	name = "Central Science Maintenance"
	icon_state = "maint_sci_central"

/area/maintenance/department/cargo
	name = "Cargo Maintenance"
	icon_state = "maint_cargo"

/area/maintenance/department/bridge
	name = "Bridge Maintenance"
	icon_state = "maint_bridge"

/area/maintenance/department/engine
	name = "Engineering Maintenance"
	icon_state = "maint_engi"

/area/maintenance/department/science/xenobiology
	name = "Xenobiology Maintenance"
	icon_state = "xenomaint"
	area_flags = VALID_TERRITORY | BLOBS_ALLOWED | UNIQUE_AREA | XENOBIOLOGY_COMPATIBLE | CULT_PERMITTED

//Maintenance - Prison

/area/maintenance/prison
	name = "Prison Maintenance"
	icon_state = "prison_maintenance"

/area/maintenance/prison/fore
	name = "Prison Fore Maintenance"
	icon_state = "prison_maintenance"

/area/maintenance/prison/starboard
	name = "Prison Starboard Maintenance"
	icon_state = "prison_maintenance"

/area/maintenance/prison/aft
	name = "Prison Aft Maintenance"
	icon_state = "prison_maintenance"

/area/maintenance/prison/port
	name = "Prison Port Maintenance"
	icon_state = "prison_maintenance"

//Maintenance - Generic

/area/maintenance/arrivals/north
	name = "Arrivals North Maintenance"
	icon_state = "fpmaint"

/area/maintenance/arrivals/north_2
	name = "Arrivals North Maintenance"
	icon_state = "fpmaint"

/area/maintenance/aft
	name = "Aft Maintenance"
	icon_state = "amaint"

/area/maintenance/aft/upper
	name = "Upper Aft Maintenance"

/area/maintenance/aft/secondary
	name = "Aft Maintenance"
	icon_state = "amaint_2"

/area/maintenance/central
	name = "Central Maintenance"
	icon_state = "maintcentral"

/area/maintenance/central/secondary
	name = "Central Maintenance"
	icon_state = "maintcentral"

/area/maintenance/fore
	name = "Fore Maintenance"
	icon_state = "fmaint"

/area/maintenance/fore/upper
	name = "Upper Fore Maintenance"

/area/maintenance/fore/secondary
	name = "Fore Maintenance"
	icon_state = "fmaint_2"

/area/maintenance/starboard
	name = "Starboard Maintenance"
	icon_state = "smaint"

/area/maintenance/starboard/upper
	name = "Upper Starboard Maintenance"

/area/maintenance/starboard/central
	name = "Central Starboard Maintenance"
	icon_state = "smaint"

/area/maintenance/starboard/secondary
	name = "Secondary Starboard Maintenance"
	icon_state = "smaint_2"

/area/maintenance/starboard/aft
	name = "Starboard Quarter Maintenance"
	icon_state = "asmaint"

/area/maintenance/starboard/aft/secondary
	name = "Secondary Starboard Quarter Maintenance"
	icon_state = "asmaint_2"

/area/maintenance/starboard/fore
	name = "Starboard Bow Maintenance"
	icon_state = "fsmaint"

/area/maintenance/port
	name = "Port Maintenance"
	icon_state = "pmaint"

/area/maintenance/port/central
	name = "Central Port Maintenance"
	icon_state = "maintcentral"

/area/maintenance/port/aft
	name = "Port Quarter Maintenance"
	icon_state = "apmaint"

/area/maintenance/port/fore
	name = "Port Bow Maintenance"
	icon_state = "fpmaint"

/area/maintenance/disposal
	name = "Waste Disposal"
	icon_state = "disposal"

/area/maintenance/disposal/incinerator
	name = "Incinerator"
	icon_state = "incinerator"

/area/maintenance/bar
	name = "Maintenance Bar"
	icon_state = "bar"

/area/maintenance/bar/cafe
	name = "Abandoned Cafe"
	icon_state = "cafeteria"

/area/maintenance/space_hut
	name = "Space Hut"
	icon_state = "spacehut"

/area/maintenance/space_hut/cabin
	name = "Abandoned Cabin"

/area/maintenance/space_hut/plasmaman
	name = "Abandoned Plasmaman Friendly Startup"

/area/maintenance/space_hut/observatory
	name = "Space Observatory"

//Hallway

/area/hallway
	nightshift_public_area = NIGHTSHIFT_AREA_PUBLIC
	sound_environment = SOUND_AREA_STANDARD_STATION
	minimap_color = "#aaaaaa"

/area/hallway/primary
	name = "Primary Hallway"

/area/hallway/primary/aft
	name = "Aft Primary Hallway"
	icon_state = "hallA"

/area/hallway/primary/fore
	name = "Fore Primary Hallway"
	icon_state = "hallF"

/area/hallway/primary/starboard
	name = "Starboard Primary Hallway"
	icon_state = "hallS"

/area/hallway/primary/starboard/aft
	name = "Starboard Quarter Primary Hallway"
	icon_state = "hallAS"

/area/hallway/primary/starboard/fore
	name = "Starboard Bow Primary Hallway"
	icon_state = "hallFS"

/area/hallway/primary/port
	name = "Port Primary Hallway"
	icon_state = "hallP"

/area/hallway/primary/port/aft
	name = "Port Quarter Primary Hallway"
	icon_state = "hallAP"

/area/hallway/primary/port/fore
	name = "Port Bow Primary Hallway"
	icon_state = "hallFP"

/area/hallway/primary/central
	name = "Central Primary Hallway"
	icon_state = "hallC"

/area/hallway/primary/upper
	name = "Upper Central Primary Hallway"
	icon_state = "hallC"

/area/hallway/secondary/command
	name = "Command Hallway"
	icon_state = "bridge_hallway"

/area/hallway/secondary/construction
	name = "Construction Area"
	icon_state = "construction"

/area/hallway/secondary/exit
	name = "Escape Shuttle Hallway"
	icon_state = "escape"
	minimap_color = "#baa0a0"

/area/hallway/secondary/exit/departure_lounge
	name = "Departure Lounge"
	icon_state = "escape_lounge"

/area/hallway/secondary/entry
	name = "Arrival Shuttle Hallway"
	icon_state = "entry"
	minimap_color = "#a0a0ba"

/area/hallway/secondary/service
	name = "Service Hallway"
	icon_state = "hall_service"

//Command

/area/command
	name = "Command"
	icon_state = "Bridge"
	ambientsounds = list('sound/ambience/signal.ogg')
	// airlock_wires = /datum/wires/airlock/command
	sound_environment = SOUND_AREA_STANDARD_STATION

/area/command/bridge
	name = "Bridge"
	icon_state = "bridge"

/area/command/meeting_room
	name = "Heads of Staff Meeting Room"
	icon_state = "meeting"
	sound_environment = SOUND_AREA_MEDIUM_SOFTFLOOR

/area/command/meeting_room/council
	name = "Council Chamber"
	icon_state = "meeting"
	sound_environment = SOUND_AREA_MEDIUM_SOFTFLOOR

/area/command/corporate_showroom
	name = "Corporate Showroom"
	icon_state = "showroom"
	sound_environment = SOUND_AREA_MEDIUM_SOFTFLOOR

/area/command/heads_quarters

/area/command/heads_quarters/captain
	name = "Captain's Office"
	icon_state = "captain"
	clockwork_warp_allowed = FALSE
	sound_environment = SOUND_AREA_WOODFLOOR

/area/command/heads_quarters/captain/private
	name = "Captain's Quarters"
	icon_state = "captain_private"
	sound_environment = SOUND_AREA_WOODFLOOR

/area/command/heads_quarters/ce
	name = "Chief Engineer's Office"
	icon_state = "ce_office"

/area/command/heads_quarters/ce/private
	name = "Chief Engineer's Private Quarters"
	icon_state = "ce_private"

/area/command/heads_quarters/cmo
	name = "Chief Medical Officer's Office"
	icon_state = "cmo_office"

/area/command/heads_quarters/cmo/private
	name = "Chief Medical Officer's Office"
	icon_state = "cmo_private"

/area/command/heads_quarters/hop
	name = "Head of Personnel's Office"
	icon_state = "hop_office"

/area/command/heads_quarters/hop/private
	name = "Head of Personnel's Private Quarters"
	icon_state = "hop_private"

/area/command/heads_quarters/hos
	name = "Head of Security's Office"
	icon_state = "hos_office"

/area/command/heads_quarters/hos/private
	name = "Head of Security's Private Quarters"
	icon_state = "hos_private"

/area/command/heads_quarters/rd
	name = "Research Director's Office"
	icon_state = "rd_office"

/area/command/heads_quarters/rd/private
	name = "Research Director's Private Quarters"
	icon_state = "rd_private"

//Command - Teleporters

/area/command/teleporter
	name = "Teleporter Room"
	icon_state = "teleporter"
	// ambience_index = AMBIENCE_ENGI
	ambientsounds = ENGINEERING

/area/command/gateway
	name = "Gateway"
	icon_state = "gateway"
	// ambience_index = AMBIENCE_ENGI
	ambientsounds = ENGINEERING

//Command - AI Monitored

/area/ai_monitored/command/storage/eva
	name = "EVA Storage"
	icon_state = "eva"
	// ambience_index = AMBIENCE_DANGER
	clockwork_warp_allowed = FALSE
	ambientsounds = HIGHSEC

/area/ai_monitored/command/storage/eva/upper
	name = "Upper EVA Storage"

/area/ai_monitored/command/nuke_storage
	name = "Vault"
	icon_state = "nuke_storage"
	// airlock_wires = /datum/wires/airlock/command
	ambientsounds = HIGHSEC
//Commons

/area/commons
	name = "Crew Quarters"
	sound_environment = SOUND_AREA_STANDARD_STATION
	area_flags = BLOBS_ALLOWED | UNIQUE_AREA | CULT_PERMITTED

/area/commons/dorms
	name = "Dormitories"
	icon_state = "dorms"

/area/commons/dorms/barracks
	name = "Sleep Barracks"

/area/commons/dorms/barracks/male
	name = "Male Sleep Barracks"
	icon_state = "dorms_male"

/area/commons/dorms/barracks/female
	name = "Female Sleep Barracks"
	icon_state = "dorms_female"

/area/commons/toilet
	name = "Dormitory Toilets"
	icon_state = "toilet"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/commons/toilet/auxiliary
	name = "Auxiliary Restrooms"
	icon_state = "toilet"

/area/commons/toilet/locker
	name = "Locker Toilets"
	icon_state = "toilet"

/area/commons/toilet/restrooms
	name = "Restrooms"
	icon_state = "toilet"

/area/commons/toilet/female
	name = "Female Toilets"
	icon_state = "toilet"

/area/commons/toilet/male
	name = "Male Toilets"
	icon_state = "toilet"

/area/commons/locker
	name = "Locker Room"
	icon_state = "locker"

/area/commons/lounge
	name = "Lounge"
	icon_state = "lounge"
	sound_environment = SOUND_AREA_SMALL_SOFTFLOOR

/area/commons/arcade
	name = "Arcade"
	icon_state = "abandoned_g_den"
	nightshift_public_area = NIGHTSHIFT_AREA_RECREATION

/area/commons/fitness
	name = "Fitness Room"
	icon_state = "fitness"

/area/commons/fitness/locker_room
	name = "Unisex Locker Room"
	icon_state = "locker"

/area/commons/fitness/locker_room/male
	name = "Male Locker Room"
	icon_state = "locker_male"

/area/commons/fitness/locker_room/female
	name = "Female Locker Room"
	icon_state = "locker_female"

/area/commons/fitness/pool
	name = "Pool Area"
	icon_state = "pool"

/area/commons/fitness/recreation
	name = "Recreation Area"
	icon_state = "rec"

// Commons - Vacant Rooms

/area/commons/vacant_room
	name = "Vacant Room"
	icon_state = "vacant_room"
	// ambience_index = AMBIENCE_MAINT
	ambientsounds = MAINTENANCE

/area/commons/vacant_room/office
	name = "Vacant Office"
	icon_state = "vacant_office"

/area/commons/vacant_room/office/b
	name = "Vacant Office"
	icon_state = "vacant_office"

/area/commons/vacant_room/commissary
	name = "Vacant Commissary"
	icon_state = "vacant_commissary"

//Commons - Storage
/area/commons/storage
	sound_environment = SOUND_AREA_STANDARD_STATION

/area/commons/storage/tools
	name = "Auxiliary Tool Storage"
	icon_state = "tool_storage"

/area/commons/storage/primary
	name = "Primary Tool Storage"
	icon_state = "primary_storage"

/area/commons/storage/auxiliary
	name = "Auxiliary Tool Storage"
	icon_state = "primary_storage"

/area/commons/storage/art
	name = "Art Supply Storage"
	icon_state = "art_storage"

/area/commons/storage/emergency
	name = "Emergency Storage"
	icon_state = "emergencystorage"

/area/commons/storage/emergency/starboard
	name = "Starboard Emergency Storage"
	icon_state = "emergency_storage"

/area/commons/storage/emergency/port
	name = "Port Emergency Storage"
	icon_state = "emergency_storage"

/area/commons/storage/mining
	name = "Public Mining Storage"
	icon_state = "mining"

//Areas that predominantly only apply to CogStation

/area/commons/dorms/blue
	name = "Blue Dorms"
	icon_state = "dorms"
	nightshift_public_area = NIGHTSHIFT_AREA_NONE

/area/commons/dorms/purple
	name = "Purple Dorms"
	icon_state = "dorms"
	nightshift_public_area = NIGHTSHIFT_AREA_NONE

/area/commons/lounge/jazz
	name = "Jazz Lounge"
	icon_state = "yellow"
	ambientsounds = list('sound/ambience/ambidet1.ogg','sound/ambience/ambidet2.ogg')
	nightshift_public_area = NIGHTSHIFT_AREA_RECREATION

/area/commons/fitness/cogpool
	name = "Pool"
	icon_state = "fitness"
	clockwork_warp_fail = "Pool's closed."
	nightshift_public_area = NIGHTSHIFT_AREA_RECREATION

/area/service/barbershop
	name = "Barbershop"
	icon_state = "blue"
	nightshift_public_area = NIGHTSHIFT_AREA_RECREATION

/area/service/observatory
	name = "Observatory"
	icon_state = "Sleep"

/area/hallway/secondary/civilian
	name = "Civilian Wing"
	icon_state = "hallFS"

/area/engineering/atmos/aftair
	name = "Aft Air Hookup"
	icon_state = "atmos"
	flags_1 = NONE

/area/engineering/teg
	name = "Thermo-Electric Generator"
	icon_state = "engine"

/area/engineering/teg/hotloop
	name = "Hot Loop"
	icon_state = "red"

/area/engineering/teg/coldloop
	name = "Cold Loop"
	icon_state = "blue"

/area/engineering/workshop
	name = "Engineering Workshop"
	icon_state = "engine"

/area/engineering/substation
	name = "Electrical Substation"
	icon_state = "engine"

/area/security/courtroom/jury
	name = "Jury Room"
	icon_state = "courtroom"

/area/cargo/miningdock/airless
	name = "Mining Dock"
	icon_state = "mining"
	has_gravity = STANDARD_GRAVITY
	outdoors = TRUE
	ambientsounds = SPACE
	area_flags = UNIQUE_AREA

/area/cargo/miningdock/airless/no_grav
	name = "Mining Dock"
	icon_state = "mining"
	dynamic_lighting = DYNAMIC_LIGHTING_IFSTARLIGHT
	power_light = FALSE
	power_equip = FALSE
	power_environ = FALSE
	outdoors = TRUE
	ambientsounds = SPACE
	area_flags = UNIQUE_AREA

//Service

// /area/service
// 	airlock_wires = /datum/wires/airlock/service

/area/service/cafeteria
	name = "Cafeteria"
	icon_state = "cafeteria"

/area/service/cafeteria/lunchroom
	name = "Lunchroom"
	icon_state = "cafeteria"
	nightshift_public_area = NIGHTSHIFT_AREA_RECREATION

/area/service/kitchen
	name = "Kitchen"
	icon_state = "kitchen"

/area/service/kitchen/coldroom
	name = "Kitchen Cold Room"
	icon_state = "kitchen_cold"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/service/bar
	name = "Bar"
	icon_state = "bar"
	// mood_bonus = 5
	// mood_message = "<span class='nicegreen'>I love being in the bar!</span>\n"
	// mood_trait = TRAIT_EXTROVERT
	// airlock_wires = /datum/wires/airlock/service
	nightshift_public_area = NIGHTSHIFT_AREA_RECREATION
	sound_environment = SOUND_AREA_WOODFLOOR

/area/service/bar/Initialize(mapload)
	. = ..()
	GLOB.bar_areas += src

/area/service/bar/atrium
	name = "Atrium"
	icon_state = "bar"
	sound_environment = SOUND_AREA_WOODFLOOR

/area/service/electronic_marketing_den
	name = "Electronic Marketing Den"
	icon_state = "abandoned_m_den"

/area/service/abandoned_gambling_den
	name = "Abandoned Gambling Den"
	icon_state = "abandoned_g_den"

/area/service/abandoned_gambling_den/secondary
	icon_state = "abandoned_g_den_2"

/area/service/theater
	name = "Theater"
	icon_state = "theatre"
	sound_environment = SOUND_AREA_WOODFLOOR

/area/service/theater/abandoned
	name = "Abandoned Theater"
	icon_state = "abandoned_theatre"

/area/service/theater/clown
	name = "Clown's Office"
	icon_state = "theatre"

/area/service/theater/mime
	name = "Mime's Office"
	icon_state = "theatre"

/area/commons/cryopod
	name = "Cryogenics"
	icon_state = "cryosleep"

/area/service/library
	name = "Library"
	icon_state = "library"
	// mood_bonus = 5
	// mood_message = "<span class='nicegreen'>I love being in the library!</span>\n"
	// mood_trait = TRAIT_INTROVERT
	area_flags = BLOBS_ALLOWED | UNIQUE_AREA | CULT_PERMITTED
	sound_environment = SOUND_AREA_LARGE_SOFTFLOOR

/area/service/library/lounge
	name = "Library Lounge"
	icon_state = "library_lounge"
	sound_environment = SOUND_AREA_SMALL_SOFTFLOOR

/area/service/library/artgallery
	name = " Art Gallery"
	icon_state = "library_gallery"

/area/service/library/private
	name = "Library Private Study"
	icon_state = "library_gallery_private"

/area/service/library/upper
	name = "Library Upper Floor"
	icon_state = "library"

/area/service/library/printer
	name = "Library Printer Room"
	icon_state = "library"

/area/service/library/abandoned
	name = "Abandoned Library"
	icon_state = "abandoned_library"
	nightshift_public_area = NIGHTSHIFT_AREA_NONE

/area/service/chapel
	icon_state = "chapel"
	// mood_bonus = 5
	// mood_message = "<span class='nicegreen'>Being in the chapel brings me peace.</span>\n"
	// mood_trait = TRAIT_SPIRITUAL
	// ambience_index = AMBIENCE_HOLY
	clockwork_warp_allowed = FALSE
	clockwork_warp_fail = "The consecration here prevents you from warping in."
	nightshift_public_area = NIGHTSHIFT_AREA_RECREATION
	ambientsounds = HOLY
	flags_1 = NONE
	sound_environment = SOUND_AREA_LARGE_ENCLOSED

/area/service/chapel/main
	name = "Chapel"

/area/service/chapel/main/monastery
	name = "Monastery"
	nightshift_public_area = NIGHTSHIFT_AREA_NONE

/area/service/chapel/office
	name = "Chapel Office"
	icon_state = "chapeloffice"

/area/service/chapel/asteroid
	name = "Chapel Asteroid"
	icon_state = "explored"
	sound_environment = SOUND_AREA_ASTEROID

/area/service/chapel/asteroid/monastery
	name = "Monastery Asteroid"

/area/service/chapel/dock
	name = "Chapel Dock"
	icon_state = "construction"

/area/service/lawoffice
	name = "Law Office"
	icon_state = "law"
	sound_environment = SOUND_AREA_SMALL_SOFTFLOOR

/area/service/janitor
	name = "Custodial Closet"
	icon_state = "janitor"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED
	area_flags = BLOBS_ALLOWED | UNIQUE_AREA | CULT_PERMITTED

/area/service/janitor/aux
	name = "Auxiliary Custodial Closet"
	icon_state = "janitor"
	flags_1 = NONE

/area/service/hydroponics
	name = "Hydroponics"
	icon_state = "hydro"
	// airlock_wires = /datum/wires/airlock/service
	sound_environment = SOUND_AREA_STANDARD_STATION

/area/service/hydroponics/lobby
	name = "Hydroponics Lobby"
	icon_state = "hydro"

/area/service/hydroponics/upper
	name = "Upper Hydroponics"
	icon_state = "hydro"

/area/service/hydroponics/garden
	name = "Garden"
	icon_state = "garden"

/area/service/hydroponics/garden/abandoned
	name = "Abandoned Garden"
	icon_state = "abandoned_garden"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/service/hydroponics/garden/monastery
	name = "Monastery Garden"
	icon_state = "hydro"

//Engineering

/area/engineering
	ambientsounds = ENGINEERING
	// ambience_index = AMBIENCE_ENGI
	// airlock_wires = /datum/wires/airlock/engineering
	sound_environment = SOUND_AREA_LARGE_ENCLOSED

/area/engineering/engine_smes
	name = "Engineering SMES"
	icon_state = "engine_smes"

/area/engineering/main
	name = "Engineering"
	icon_state = "engine"

/area/engineering/atmos
	name = "Atmospherics"
	icon_state = "atmos"

/area/engineering/atmos/upper
	name = "Upper Atmospherics"

/area/engineering/atmospherics_engine
	name = "Atmospherics Engine"
	icon_state = "atmos_engine"
	area_flags = BLOBS_ALLOWED | UNIQUE_AREA | CULT_PERMITTED

/area/engineering/lobby
	name = "Engineering Lobby"
	icon_state = "engi_lobby"

/area/engineering/supermatter
	name = "Supermatter Engine"
	icon_state = "engine_sm"
	area_flags = BLOBS_ALLOWED | UNIQUE_AREA | CULT_PERMITTED
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/engineering/break_room
	name = "Engineering Foyer"
	icon_state = "engine_break"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/engineering/gravity_generator
	name = "Gravity Generator Room"
	icon_state = "grav_gen"
	clockwork_warp_allowed = FALSE
	clockwork_warp_fail = "The gravitons generated here could throw off your warp's destination and possibly throw you into deep space."
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/engineering/secure_construction
	name = "Secure Construction Area"
	icon_state = "engine"

/area/engineering/storage
	name = "Engineering Storage"
	icon_state = "engi_storage"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/engineering/storage_shared
	name = "Shared Engineering Storage"
	icon_state = "engi_storage"

/area/engineering/transit_tube
	name = "Transit Tube"
	icon_state = "transit_tube"

/area/engineering/storage/tech
	name = "Technical Storage"
	icon_state = "aux_storage"
	clockwork_warp_allowed = FALSE

/area/engineering/storage/tcomms
	name = "Telecomms Storage"
	icon_state = "tcom"
	area_flags = BLOBS_ALLOWED | UNIQUE_AREA | CULT_PERMITTED
	clockwork_warp_allowed = FALSE

//Engineering - Construction

/area/construction
	name = "Construction Area"
	icon_state = "construction"
	// ambience_index = AMBIENCE_ENGI
	ambientsounds = ENGINEERING
	sound_environment = SOUND_AREA_STANDARD_STATION

/area/construction/mining/aux_base
	name = "Auxiliary Base Construction"
	icon_state = "aux_base_construction"
	sound_environment = SOUND_AREA_MEDIUM_SOFTFLOOR

/area/construction/secondary
	name = "Secondary Construction Area"
	icon_state = "yellow"

/area/construction/storage_wing
	name = "Storage Wing"
	icon_state = "storage_wing"

//Solars

/area/solars
	requires_power = FALSE
	dynamic_lighting = DYNAMIC_LIGHTING_IFSTARLIGHT
	area_flags = UNIQUE_AREA
	flags_1 = NONE
	// ambience_index = AMBIENCE_ENGI
	ambientsounds = ENGINEERING
	// airlock_wires = /datum/wires/airlock/engineering
	sound_environment = SOUND_AREA_SPACE

/area/solars/fore
	name = "Fore Solar Array"
	icon_state = "yellow"
	sound_environment = SOUND_AREA_STANDARD_STATION

/area/solars/aft
	name = "Aft Solar Array"
	icon_state = "yellow"

/area/solars/aux/port
	name = "Port Bow Auxiliary Solar Array"
	icon_state = "panelsA"

/area/solars/aux/starboard
	name = "Starboard Bow Auxiliary Solar Array"
	icon_state = "panelsA"

/area/solars/starboard
	name = "Starboard Solar Array"
	icon_state = "panelsS"

/area/solars/starboard/aft
	name = "Starboard Quarter Solar Array"
	icon_state = "panelsAS"

/area/solars/starboard/fore
	name = "Starboard Bow Solar Array"
	icon_state = "panelsFS"

/area/solars/port
	name = "Port Solar Array"
	icon_state = "panelsP"

/area/solars/port/aft
	name = "Port Quarter Solar Array"
	icon_state = "panelsAP"

/area/solars/port/fore
	name = "Port Bow Solar Array"
	icon_state = "panelsFP"

/area/solars/aisat
	name = "AI Satellite Solars"
	icon_state = "yellow"


//Solar Maint

/area/maintenance/solars
	name = "Solar Maintenance"
	icon_state = "yellow"

/area/maintenance/solars/port
	name = "Port Solar Maintenance"
	icon_state = "SolarcontrolP"

/area/maintenance/solars/port/aft
	name = "Port Quarter Solar Maintenance"
	icon_state = "SolarcontrolAP"

/area/maintenance/solars/port/fore
	name = "Port Bow Solar Maintenance"
	icon_state = "SolarcontrolFP"

/area/maintenance/solars/starboard
	name = "Starboard Solar Maintenance"
	icon_state = "SolarcontrolS"

/area/maintenance/solars/starboard/aft
	name = "Starboard Quarter Solar Maintenance"
	icon_state = "SolarcontrolAS"

/area/maintenance/solars/starboard/fore
	name = "Starboard Bow Solar Maintenance"
	icon_state = "SolarcontrolFS"

/area/maintenance/solars/aux/port
	name = "Port Auxiliary Solar Maintenance"
	icon_state = "SolarcontrolA"

/area/maintenance/solars/aux/port/aft
	name = "Port Quarter Auxiliary Solar Maintenance"
	icon_state = "SolarcontrolAP"

/area/maintenance/solars/aux/port/fore
	name = "Port Bow Auxiliary Solar Maintenance"
	icon_state = "SolarcontrolA"

/area/maintenance/solars/aux/starboard
	name = "Starboard Auxiliary Solar Maintenance"
	icon_state = "SolarcontrolA"

/area/maintenance/solars/aux/starboard/aft
	name = "Starboard Quarter Auxiliary Solar Maintenance"
	icon_state = "SolarcontrolA"

/area/maintenance/solars/aux/starboard/fore
	name = "Starboard Bow Auxiliary Solar Maintenance"
	icon_state = "SolarcontrolA"
//MedBay

/area/medical
	name = "Medical"
	icon_state = "medbay1"
	// ambience_index = AMBIENCE_MEDICAL
	// airlock_wires = /datum/wires/airlock/medbay
	sound_environment = SOUND_AREA_STANDARD_STATION
	// min_ambience_cooldown = 90 SECONDS
	// max_ambience_cooldown = 180 SECONDS

/area/medical/clinic
	name = "Clinic"
	icon_state = "medbay3"
	ambientsounds = MEDICAL

/area/medical/abandoned
	name = "Abandoned Medbay"
	icon_state = "abandoned_medbay"
	ambientsounds = list('sound/ambience/signal.ogg')
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/medical/medbay/central
	name = "Medbay Central"
	icon_state = "med_central"

/area/medical/medbay/front_office
	name = "Medbay Front Office"
	icon_state = "medbay"
	music = 'sound/ambience/signal.ogg'

/area/medical/medbay/lobby
	name = "Medbay Lobby"
	icon_state = "med_lobby"

	//Medbay is a large area, these additional areas help level out APC load.

/area/medical/medbay/zone2
	name = "Medbay"
	icon_state = "medbay2"

/area/medical/medbay/zone3
	name = "Medbay"
	icon_state = "medbay3"
	music = 'sound/ambience/signal.ogg'

/area/medical/medbay/aft
	name = "Medbay Aft"
	icon_state = "med_aft"

/area/medical/storage
	name = "Medbay Storage"
	icon_state = "med_storage"

/area/medical/paramedic
	name = "Paramedic Dispatch"
	icon_state = "paramedic"

/area/medical/office
	name = "Medical Office"
	icon_state = "med_office"

/area/medical/surgery/room_c
	name = "Surgery C"
	icon_state = "surgery"

/area/medical/surgery/room_d
	name = "Surgery D"
	icon_state = "surgery"

/area/medical/break_room
	name = "Medical Break Room"
	icon_state = "med_break"

/area/medical/coldroom
	name = "Medical Cold Room"
	icon_state = "kitchen_cold"

/area/medical/patients_rooms
	name = "Patients' Rooms"
	icon_state = "patients"
	sound_environment = SOUND_AREA_SMALL_SOFTFLOOR

/area/medical/patients_rooms/room_a
	name = "Patient Room A"
	icon_state = "patients"

/area/medical/patients_rooms/room_b
	name = "Patient Room B"
	icon_state = "patients"

/area/medical/virology
	name = "Virology"
	icon_state = "virology"

/area/medical/morgue
	name = "Morgue"
	icon_state = "morgue"
	// ambience_index = AMBIENCE_SPOOKY
	ambientsounds = SPOOKY
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/medical/chemistry
	name = "Chemistry"
	icon_state = "chem"

/area/medical/pharmacy
	name = "Pharmacy"
	icon_state = "pharmacy"

/area/medical/surgery
	name = "Surgery"
	icon_state = "surgery"

/area/medical/surgery/room_b
	name = "Surgery B"
	icon_state = "surgery"

/area/medical/cryo
	name = "Cryogenics"
	icon_state = "cryo"

/area/medical/exam_room
	name = "Exam Room"
	icon_state = "exam_room"

/area/medical/genetics
	name = "Genetics Lab"
	icon_state = "genetics"

/area/medical/genetics/cloning
	name = "Cloning Lab"
	icon_state = "cloning"

/area/medical/treatment_center
	name = "Medbay Treatment Center"
	icon_state = "exam_room"

/area/medical/psychology
	name = "Psychology Office"
	// icon_state = "psychology"
	// mood_bonus = 3
	// mood_message = "<span class='nicegreen'>I feel at ease here.</span>\n"
	// ambientsounds = list('sound/ambience/aurora_caelus_short.ogg')

//Security

/area/security
	name = "Security"
	icon_state = "security"
	// ambience_index = AMBIENCE_DANGER
	ambientsounds = HIGHSEC
	// airlock_wires = /datum/wires/airlock/security
	sound_environment = SOUND_AREA_STANDARD_STATION

/area/security/office
	name = "Security Office"
	icon_state = "security"

/area/security/brig
	name = "Brig"
	icon_state = "brig"

/area/security/brig/upper
	name = "Brig Overlook"

/area/security/courtroom
	name = "Courtroom"
	icon_state = "courtroom"
	sound_environment = SOUND_AREA_LARGE_ENCLOSED

/area/security/prison
	name = "Prison Wing"
	icon_state = "sec_prison"

/area/security/prison/cells
	name = "Prison Wing Cells"
	icon_state = "prison_cells"

/area/security/prison/upper
	name = "Upper Prison Wing"
	icon_state = "prison_upper"

/area/security/prison/visit
	name = "Prison Visitation Area"
	icon_state = "prison_visit"

/area/security/prison/rec
	name = "Prison Rec Room"
	icon_state = "prison_rec"

/area/security/prison/mess
	name = "Prison Mess Hall"
	icon_state = "prison_mess"

/area/security/prison/work
	name = "Prison Work Room"
	icon_state = "prison_work"

/area/security/prison/shower
	name = "Prison Shower"
	icon_state = "prison_shower"

/area/security/prison/workout
	name = "Prison Gym"
	icon_state = "prison_workout"

/area/security/prison/garden
	name = "Prison Garden"
	icon_state = "prison_garden"

/area/security/processing
	name = "Labor Shuttle Dock"
	icon_state = "sec_processing"

/area/security/processing/cremation
	name = "Security Crematorium"
	icon_state = "sec_cremation"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/security/warden
	name = "Brig Control"
	icon_state = "warden"
	sound_environment = SOUND_AREA_SMALL_SOFTFLOOR

/area/security/detectives_office
	name = "Detective's Office"
	icon_state = "detective"
	ambientsounds = list('sound/ambience/ambidet1.ogg','sound/ambience/ambidet2.ogg')

/area/security/detectives_office/private_investigators_office
	name = "Private Investigator's Office"
	icon_state = "investigate_office"
	sound_environment = SOUND_AREA_SMALL_SOFTFLOOR

/area/security/range
	name = "Firing Range"
	icon_state = "firingrange"

/area/security/execution
	icon_state = "execution_room"

/area/security/execution/transfer
	name = "Transfer Centre"
	icon_state = "sec_processing"

/area/security/execution/education
	name = "Prisoner Education Chamber"

/area/security/checkpoint
	name = "Security Checkpoint"
	icon_state = "checkpoint1"

/area/security/checkpoint/auxiliary
	icon_state = "checkpoint_aux"

/area/security/checkpoint/escape
	icon_state = "checkpoint_esc"

/area/security/checkpoint/supply
	name = "Security Post - Cargo Bay"
	icon_state = "checkpoint_supp"

/area/security/checkpoint/engineering
	name = "Security Post - Engineering"
	icon_state = "checkpoint_engi"

/area/security/checkpoint/medical
	name = "Security Post - Medbay"
	icon_state = "checkpoint_med"

/area/security/checkpoint/science
	name = "Security Post - Science"
	icon_state = "checkpoint_sci"

/area/security/checkpoint/science/research
	name = "Security Post - Research Division"
	icon_state = "checkpoint_res"

/area/security/checkpoint/customs
	name = "Customs"
	icon_state = "customs_point"

/area/security/checkpoint/customs/auxiliary
	icon_state = "customs_point_aux"

//Security - AI Monitored
/area/ai_monitored/security/armory
	name = "Armory"
	icon_state = "armory"
	// ambience_index = AMBIENCE_DANGER
	ambientsounds = HIGHSEC
	clockwork_warp_allowed = FALSE // n omegalul
	// airlock_wires = /datum/wires/airlock/security

/area/ai_monitored/security/armory/upper
	name = "Upper Armory"

//Cargo

/area/cargo
	name = "Quartermasters"
	icon_state = "quart"
	// airlock_wires = /datum/wires/airlock/service
	sound_environment = SOUND_AREA_STANDARD_STATION

/area/cargo/sorting
	name = "Delivery Office"
	icon_state = "cargo_delivery"
	sound_environment = SOUND_AREA_STANDARD_STATION

/area/cargo/warehouse
	name = "Warehouse"
	icon_state = "cargo_warehouse"
	sound_environment = SOUND_AREA_LARGE_ENCLOSED

/area/cargo/warehouse/upper
	name = "Upper Warehouse"

/area/cargo/office
	name = "Cargo Office"
	icon_state = "cargo_office"

/area/cargo/storage
	name = "Cargo Bay"
	icon_state = "cargo_bay"
	sound_environment = SOUND_AREA_LARGE_ENCLOSED

/area/cargo/qm
	name = "Quartermaster's Office"
	icon_state = "quart_office"

/area/cargo/qm/private
	name = "Quartermaster's Private Quarters"
	icon_state = "quart"

/area/cargo/miningdock
	name = "Mining Dock"
	icon_state = "mining"

/area/cargo/miningdock/abandoned
	name = "Abandoned Mining Dock"
	icon_state = "mining"

/area/cargo/miningoffice
	name = "Mining Office"
	icon_state = "mining"

/area/cargo/miningstorage
	name = "Mining Storage"
	icon_state = "mining"

//Science

/area/science
	name = "Science Division"
	icon_state = "science"
	// airlock_wires = /datum/wires/airlock/science
	sound_environment = SOUND_AREA_STANDARD_STATION

/area/science/observatory
	name = "Research Observatory"
	icon_state = "research"

/area/science/lab
	name = "Research and Development"
	icon_state = "research"

/area/science/xenobiology
	name = "Xenobiology Lab"
	icon_state = "xenobio"

/area/science/cytology
	name = "Cytology Lab"
	icon_state = "cytology"

/area/science/storage
	name = "Toxins Storage"
	icon_state = "tox_storage"

/area/science/test_area
	name = "Toxins Test Area"
	icon_state = "tox_test"
	area_flags = BLOBS_ALLOWED | UNIQUE_AREA | CULT_PERMITTED

/area/science/mixing
	name = "Toxins Mixing Lab"
	icon_state = "tox_mix"

/area/science/mixing/chamber
	name = "Toxins Mixing Chamber"
	icon_state = "tox_mix_chamber"
	area_flags = BLOBS_ALLOWED | UNIQUE_AREA | CULT_PERMITTED

/area/science/misc_lab
	name = "Testing Lab"
	icon_state = "tox_misc"

/area/science/misc_lab/range
	name = "Research Testing Range"
	icon_state = "tox_range"

/area/science/server
	name = "Research Division Server Room"
	icon_state = "server"

/area/science/server/compcore
	name = "Computer Core"
	icon_state = "server"

/area/science/explab
	name = "Experimentation Lab"
	icon_state = "exp_lab"

/area/science/robotics
	name = "Robotics"
	icon_state = "robotics"

/area/science/robotics/mechbay
	name = "Mech Bay"
	icon_state = "mechbay"

/area/science/robotics/mechbay_cargo
	name = "Mech Bay"
	icon_state = "yellow"

/area/science/robotics/showroom
	name = "Robotics Showroom"
	icon_state = "showroom"

/area/science/robotics/lab
	name = "Robotics Lab"
	icon_state = "ass_line"

/area/science/research
	name = "Research Division"
	icon_state = "science"

/area/science/circuit
	name = "Circuitry Lab"
	icon_state = "cir_lab"

/area/science/research/lobby
	name = "Research Division Lobby"
	icon_state = "medresearch"

/area/science/research/abandoned
	name = "Abandoned Research Lab"
	icon_state = "abandoned_sci"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/science/nanite
	name = "Nanite Lab"
	icon_state = "nanite"

// Telecommunications Satellite

/area/tcommsat
	clockwork_warp_allowed = FALSE
	clockwork_warp_fail = "For safety reasons, warping here is disallowed; the radio and bluespace noise could cause catastrophic results."
	ambientsounds = list('sound/ambience/ambisin2.ogg', 'sound/ambience/signal.ogg', 'sound/ambience/signal.ogg', 'sound/ambience/ambigen10.ogg', 'sound/ambience/ambitech.ogg',\
											'sound/ambience/ambitech2.ogg', 'sound/ambience/ambitech3.ogg', 'sound/ambience/ambimystery.ogg')
	// airlock_wires = /datum/wires/airlock/engineering
	// network_root_id = STATION_NETWORK_ROOT // They should of unpluged the router before they left

/area/tcommsat/chamber
	name = "Abandoned Satellite"
	icon_state = "tcomsatcham"

/area/tcommsat/computer
	name = "Telecomms Control Room"
	icon_state = "tcomsatcomp"
	sound_environment = SOUND_AREA_MEDIUM_SOFTFLOOR

/area/tcommsat/server
	name = "Telecomms Server Room"
	icon_state = "tcomsatcham"

/area/tcommsat/lounge
	name = "Telecommunications Satellite Lounge"
	icon_state = "tcomsatlounge"

/area/tcommsat/server/upper
	name = "Upper Telecomms Server Room"

//Telecommunications - On Station

/area/comms
	name = "Communications Relay"
	icon_state = "tcomsatcham"
	sound_environment = SOUND_AREA_STANDARD_STATION

/area/server
	name = "Messaging Server Room"
	icon_state = "server"
	sound_environment = SOUND_AREA_STANDARD_STATION

//External Hull Access
/area/maintenance/external
	name = "External Hull Access"
	icon_state = "amaint"

/area/maintenance/external/aft
	name = "Aft External Hull Access"

/area/maintenance/external/port
	name = "Port External Hull Access"

/area/maintenance/external/port/bow
	name = "Port Bow External Hull Access"

//Routers (currently exclusive to CogStation)

/area/router
	name = "Routing Depot"
	icon_state = "yellow"
	ambientsounds = ENGINEERING

/area/router/service
	name = "Service Router"
	icon_state = "green"

/area/router/public
	name = "Public Router"
	icon_state = "yellow"

/area/router/sec
	name = "Security Router"
	icon_state = "blue"

/area/router/medsci
	name = "MedSci Router"
	icon_state = "yellow"

/area/router/eva
	name = "EVA Router"
	icon_state = "yellow"

/area/router/air
	name = "Airbridge Router"
	icon_state = "red"

/area/router/eng
	name = "Engineering Router"
	icon_state = "yellow"

/area/router/aux
	name = "Routing System"
	icon_state = "yellow"
	requires_power = FALSE
	has_gravity = STANDARD_GRAVITY
	always_unpowered = TRUE
	dynamic_lighting = DYNAMIC_LIGHTING_IFSTARLIGHT
	power_light = FALSE
	power_equip = FALSE
	power_environ = FALSE
	area_flags = UNIQUE_AREA // fuc u
	outdoors = TRUE
	ambientsounds = SPACE
