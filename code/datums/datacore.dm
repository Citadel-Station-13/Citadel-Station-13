//TODO: someone please get rid of this shit
/datum/datacore
	var/list/medical = list()
	var/medicalPrintCount = 0
	var/list/general = list()
	var/list/security = list()
	var/securityPrintCount = 0
	var/securityCrimeCounter = 0
	///This list tracks characters spawned in the world and cannot be modified in-game. Currently referenced by respawn_character().
	var/list/locked = list()

/datum/data
	var/name = "data"

/datum/data/record
	name = "record"
	var/list/fields = list()

/datum/data/record/Destroy()
	if(src in GLOB.data_core.medical)
		GLOB.data_core.medical -= src
	if(src in GLOB.data_core.security)
		GLOB.data_core.security -= src
	if(src in GLOB.data_core.general)
		GLOB.data_core.general -= src
	if(src in GLOB.data_core.locked)
		GLOB.data_core.locked -= src
	. = ..()

/datum/data/crime
	name = "crime"
	var/crimeName = ""
	var/crimeDetails = ""
	var/author = ""
	var/time = ""
	var/dataId = 0

/datum/datacore/proc/createCrimeEntry(cname = "", cdetails = "", author = "", time = "")
	var/datum/data/crime/c = new /datum/data/crime
	c.crimeName = cname
	c.crimeDetails = cdetails
	c.author = author
	c.time = time
	c.dataId = ++securityCrimeCounter
	return c

/datum/datacore/proc/addMinorCrime(id = "", datum/data/crime/crime)
	for(var/datum/data/record/R in security)
		if(R.fields["id"] == id)
			var/list/crimes = R.fields["mi_crim"]
			crimes |= crime
			return

/datum/datacore/proc/removeMinorCrime(id, cDataId)
	for(var/datum/data/record/R in security)
		if(R.fields["id"] == id)
			var/list/crimes = R.fields["mi_crim"]
			for(var/datum/data/crime/crime in crimes)
				if(crime.dataId == text2num(cDataId))
					crimes -= crime
					return

/datum/datacore/proc/removeMajorCrime(id, cDataId)
	for(var/datum/data/record/R in security)
		if(R.fields["id"] == id)
			var/list/crimes = R.fields["ma_crim"]
			for(var/datum/data/crime/crime in crimes)
				if(crime.dataId == text2num(cDataId))
					crimes -= crime
					return

/datum/datacore/proc/addMajorCrime(id = "", datum/data/crime/crime)
	for(var/datum/data/record/R in security)
		if(R.fields["id"] == id)
			var/list/crimes = R.fields["ma_crim"]
			crimes |= crime
			return

/datum/datacore/proc/manifest()
	for(var/mob/dead/new_player/N in GLOB.player_list)
		if(!N?.client)
			continue
		if(N.new_character)
			log_manifest(N.ckey,N.new_character.mind,N.new_character)
		if(ishuman(N.new_character))
			manifest_inject(N.new_character, N.client, N.client.prefs)
		CHECK_TICK

/datum/datacore/proc/manifest_modify(name, assignment)
	var/datum/data/record/foundrecord = find_record("name", name, GLOB.data_core.general)
	if(foundrecord)
		foundrecord.fields["rank"] = assignment

/datum/datacore/proc/get_manifest_tg() //copypasted from tg, renamed to avoid namespace conflicts
	var/list/manifest_out = list()
	for(var/datum/data/record/t in GLOB.data_core.general)
		var/name = t.fields["name"]
		var/rank = t.fields["rank"]
		var/datum/job/J = SSjob.GetJobName(rank)
		var/datum/department/D = J?.GetPrimaryDepartment()
		if(D)
			if(D.unlisted)
				continue
			if(!manifest_out[D.name])
				manifest_out[D.name] = list()
			manifest_out[D.name] += list(list(
				"name" = name,
				"rank" = rank
			))
		else
			if(!manifest_out["ERROR"])
				manifest_out["ERROR"] = list()
			manifest_out["ERROR"] += list(list(
				"name" = name,
				"rank" = rank
			))
	return manifest_out

/datum/datacore/proc/get_manifest(monochrome, OOC)
	var/dat = {"
	<head><style>
		.manifest {border-collapse:collapse;}
		.manifest td, th {border:1px solid [monochrome?"black":"#DEF; background-color:white; color:black"]; padding:.25em}
		.manifest th {height: 2em; [monochrome?"border-top-width: 3px":"background-color: #48C; color:white"]}
		.manifest tr.head th { [monochrome?"border-top-width: 1px":"background-color: #488;"] }
		.manifest td:first-child {text-align:right}
		.manifest tr.alt td {[monochrome?"border-top-width: 2px":"background-color: #DEF"]}
	</style></head>
	<table class="manifest" width='350px'>
	<tr class='head'><th>Name</th><th>Rank</th></tr>
	"}
	var/even = FALSE
	var/list/data = get_manifest_tg()
	for(var/department in data)
		dat += "<tr><th colspan=3>[department]</th></tr>"
		for(var/i in data[department])
			var/list/L = i
			dat += "<tr[even ? " class='alt'" : ""]><td>[L["name"]]</td><td>[L["rank"]]</td></td>"
			even = !even

	dat += "</table>"
	dat = replacetext(dat, "\n", "")
	dat = replacetext(dat, "\t", "")
	return dat


/datum/datacore/proc/manifest_inject(mob/living/carbon/human/H, client/C, datum/preferences/prefs)
	set waitfor = FALSE
	var/static/list/show_directions = list(SOUTH, WEST)
	var/datum/job/J = SSjob.GetJobAuto(H.mind.assigned_role)
	if(!J || J.faction != JOB_FACTION_STATION)
		return			// no job, can't inject - snowflake until we Somehow Have different manifests for each faction :/
	if(H.mind && (H.mind.assigned_role != H.mind.special_role))
		var/assignment
		if(H.mind.assigned_role)
			assignment = H.mind.assigned_role
		else if(H.job)
			assignment = H.job
		else
			assignment = "Unassigned"

		var/static/record_id_num = 1001
		var/id = num2hex(record_id_num++,6)
		if(!C)
			C = H.client
		var/image = get_id_photo(H, C, show_directions)
		var/datum/picture/pf = new
		var/datum/picture/ps = new
		pf.picture_name = "[H]"
		ps.picture_name = "[H]"
		pf.picture_desc = "This is [H]."
		ps.picture_desc = "This is [H]."
		pf.picture_image = icon(image, dir = SOUTH)
		ps.picture_image = icon(image, dir = WEST)
		var/obj/item/photo/photo_front = new(null, pf)
		var/obj/item/photo/photo_side = new(null, ps)

		//These records should ~really~ be merged or something
		//General Record
		var/datum/data/record/G = new()
		G.fields["id"]			= id
		G.fields["name"]		= H.real_name
		G.fields["rank"]		= assignment
		G.fields["age"]			= H.age
		G.fields["species"]	= H.dna.species.name
		G.fields["fingerprint"]	= md5(H.dna.uni_identity)
		G.fields["p_stat"]		= "Active"
		G.fields["m_stat"]		= "Stable"
		if(H.gender == MALE)
			G.fields["gender"]  = "Male"
		else if(H.gender == FEMALE)
			G.fields["gender"]  = "Female"
		else
			G.fields["gender"]  = "Other"
		G.fields["photo_front"]	= photo_front
		G.fields["photo_side"]	= photo_side
		general += G

		//Medical Record
		var/datum/data/record/M = new()
		M.fields["id"]			= id
		M.fields["name"]		= H.real_name
		M.fields["blood_type"]	= H.dna.blood_type
		M.fields["b_dna"]		= H.dna.unique_enzymes
		M.fields["mi_dis"]		= "None"
		M.fields["mi_dis_d"]	= "No minor disabilities have been declared."
		M.fields["ma_dis"]		= "None"
		M.fields["ma_dis_d"]	= "No major disabilities have been diagnosed."
		M.fields["alg"]			= "None"
		M.fields["alg_d"]		= "No allergies have been detected in this patient."
		M.fields["cdi"]			= "None"
		M.fields["cdi_d"]		= "No diseases have been diagnosed at the moment."
		M.fields["notes"]		= "Trait information as of shift start: [H.get_trait_string(medical)]<br>[prefs.medical_records]"
		medical += M

		//Security Record
		var/datum/data/record/S = new()
		S.fields["id"]			= id
		S.fields["name"]		= H.real_name
		S.fields["criminal"]	= "None"
		S.fields["mi_crim"]		= list()
		S.fields["ma_crim"]		= list()
		S.fields["notes"]		= prefs.security_records || "No notes."
		security += S

		//Locked Record
		var/datum/data/record/L = new()
		L.fields["id"]			= md5("[H.real_name][H.mind.assigned_role]")	//surely this should just be id, like the others?
		L.fields["name"]		= H.real_name
		L.fields["rank"] 		= H.mind.assigned_role
		L.fields["age"]			= H.age
		if(H.gender == MALE)
			G.fields["gender"]  = "Male"
		else if(H.gender == FEMALE)
			G.fields["gender"]  = "Female"
		else
			G.fields["gender"]  = "Other"
		L.fields["blood_type"]	= H.dna.blood_type
		L.fields["b_dna"]		= H.dna.unique_enzymes
		L.fields["identity"]	= H.dna.uni_identity
		L.fields["species"]		= H.dna.species.type
		L.fields["features"]	= H.dna.features
		L.fields["image"]		= image
		L.fields["mindref"]		= H.mind
		locked += L
	return

/datum/datacore/proc/get_id_photo(mob/living/carbon/human/H, client/C, show_directions = list(SOUTH))
	var/datum/job/J = SSjob.GetJobName(H.mind.assigned_role)
	var/datum/preferences/P
	if(!C)
		C = H.client
	if(C)
		P = C.prefs
	return get_flat_human_icon(null, J, P, DUMMY_HUMAN_SLOT_MANIFEST, show_directions)
