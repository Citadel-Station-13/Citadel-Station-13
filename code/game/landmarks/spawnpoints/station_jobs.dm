/atom/movable/landmark/spawnpoint/job/assistant
	name = "Assistant"
	icon_state = "Assistant"
	job_path = /datum/job/assistant

/atom/movable/landmark/spawnpoint/job/assistant/override
	spawns_left = INFINITY
	latejoin = TRUE
	priority = 5

/atom/movable/landmark/spawnpoint/job/prisoner
	name = "Prisoner"
	icon_state = "Prisoner"
	job_path = /datum/job/prisoner

/atom/movable/landmark/spawnpoint/job/janitor
	name = "Janitor"
	icon_state = "Janitor"
	job_path = /datum/job/janitor

/atom/movable/landmark/spawnpoint/job/cargo_technician
	name = "Cargo Technician"
	icon_state = "Cargo Technician"
	job_path = /datum/job/cargo_tech

/atom/movable/landmark/spawnpoint/job/bartender
	name = "Bartender"
	icon_state = "Bartender"
	job_path = /datum/job/bartender

/atom/movable/landmark/spawnpoint/job/clown
	name = "Clown"
	icon_state = "Clown"
	job_path = /datum/job/clown

/atom/movable/landmark/spawnpoint/job/mime
	name = "Mime"
	icon_state = "Mime"
	job_path = /datum/job/mime

/atom/movable/landmark/spawnpoint/job/quartermaster
	name = "Quartermaster"
	icon_state = "Quartermaster"
	job_path = /datum/job/qm

/atom/movable/landmark/spawnpoint/job/atmospheric_technician
	name = "Atmospheric Technician"
	icon_state = "Atmospheric Technician"
	job_path = /datum/job/atmos

/atom/movable/landmark/spawnpoint/job/cook
	name = "Cook"
	icon_state = "Cook"
	job_path = /datum/job/cook

/atom/movable/landmark/spawnpoint/job/shaft_miner
	name = "Shaft Miner"
	icon_state = "Shaft Miner"
	job_path = /datum/job/mining

/atom/movable/landmark/spawnpoint/job/security_officer
	name = "Security Officer"
	icon_state = "Security Officer"
	job_path = /datum/job/officer

/atom/movable/landmark/spawnpoint/job/botanist
	name = "Botanist"
	icon_state = "Botanist"
	job_path = /datum/job/hydro

/atom/movable/landmark/spawnpoint/job/head_of_security
	name = "Head of Security"
	icon_state = "Head of Security"
	job_path = /datum/job/hos

/atom/movable/landmark/spawnpoint/job/captain
	name = "Captain"
	icon_state = "Captain"
	job_path = /datum/job/captain

/atom/movable/landmark/spawnpoint/job/detective
	name = "Detective"
	icon_state = "Detective"
	job_path = /datum/job/detective

/atom/movable/landmark/spawnpoint/job/warden
	name = "Warden"
	icon_state = "Warden"
	job_path = /datum/job/warden

/atom/movable/landmark/spawnpoint/job/chief_engineer
	name = "Chief Engineer"
	icon_state = "Chief Engineer"
	job_path = /datum/job/chief_engineer

/atom/movable/landmark/spawnpoint/job/head_of_personnel
	name = "Head of Personnel"
	icon_state = "Head of Personnel"
	job_path = /datum/job/hop

/atom/movable/landmark/spawnpoint/job/librarian
	name = "Curator"
	icon_state = "Curator"
	job_path = /datum/job/curator

/atom/movable/landmark/spawnpoint/job/lawyer
	name = "Lawyer"
	icon_state = "Lawyer"
	job_path = /datum/job/lawyer

/atom/movable/landmark/spawnpoint/job/station_engineer
	name = "Station Engineer"
	icon_state = "Station Engineer"
	job_path = /datum/job/engineer

/atom/movable/landmark/spawnpoint/job/medical_doctor
	name = "Medical Doctor"
	icon_state = "Medical Doctor"
	job_path = /datum/job/doctor

/atom/movable/landmark/spawnpoint/job/paramedic
	name = "Paramedic"
	icon_state = "Paramedic"
	job_path = /datum/job/paramedic

/atom/movable/landmark/spawnpoint/job/scientist
	name = "Scientist"
	icon_state = "Scientist"
	job_path = /datum/job/scientist

/atom/movable/landmark/spawnpoint/job/chemist
	name = "Chemist"
	icon_state = "Chemist"
	job_path = /datum/job/chemist

/atom/movable/landmark/spawnpoint/job/roboticist
	name = "Roboticist"
	icon_state = "Roboticist"
	job_path = /datum/job/roboticist

/atom/movable/landmark/spawnpoint/job/research_director
	name = "Research Director"
	icon_state = "Research Director"
	job_path = /datum/job/rd

/atom/movable/landmark/spawnpoint/job/geneticist
	name = "Geneticist"
	icon_state = "Geneticist"
	job_path = /datum/job/geneticist

/atom/movable/landmark/spawnpoint/job/chief_medical_officer
	name = "Chief Medical Officer"
	icon_state = "Chief Medical Officer"
	job_path = /datum/job/cmo

/atom/movable/landmark/spawnpoint/job/virologist
	name = "Virologist"
	icon_state = "Virologist"
	job_path = /datum/job/virologist

/atom/movable/landmark/spawnpoint/job/chaplain
	name = "Chaplain"
	icon_state = "Chaplain"
	job_path = /datum/job/chaplain

/atom/movable/landmark/spawnpoint/job/cyborg
	name = "Cyborg"
	icon_state = "Cyborg"
	job_path = /datum/job/cyborg

/atom/movable/landmark/spawnpoint/job/ai
	name = "AI"
	icon_state = "AI"
	delete_after_roundstart = TRUE
	job_path = /datum/job/ai
	var/primary_ai = TRUE
	var/latejoin_active = TRUE

/atom/movable/landmark/spawnpoint/job/ai/OnRoundstart()
	. = ..()
	if(latejoin_active && !spawned)
		new /obj/structure/AIcore/latejoin_inactive(loc)

/atom/movable/landmark/spawnpoint/job/ai/secondary
	icon = 'icons/effects/landmarks_static.dmi'
	icon_state = "ai_spawn"
	primary_ai = FALSE
	latejoin_active = FALSE

//Department Security spawns

/atom/movable/landmark/spawnpoint/depsec
	name = "department_sec"
	icon_state = "Security Officer"

/atom/movable/landmark/spawnpoint/depsec/Register()
	. = ..()
	GLOB.department_security_spawns += src

/atom/movable/landmark/spawnpoint/depsec/Unregister()
	. = ..()
	GLOB.department_security_spawns -= src

/atom/movable/landmark/spawnpoint/depsec/supply
	name = "supply_sec"

/atom/movable/landmark/spawnpoint/depsec/medical
	name = "medical_sec"

/atom/movable/landmark/spawnpoint/depsec/engineering
	name = "engineering_sec"

/atom/movable/landmark/spawnpoint/depsec/science
	name = "science_sec"
