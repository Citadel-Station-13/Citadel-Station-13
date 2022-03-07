/datum/job
	/// The name of the job , used for preferences, bans and more. Make sure you know what you're doing before changing this.
	var/title = "NOPE"
	/// Description of the job
	var/desc = "No description provided."
	/// Abstract type
	var/abstract_type = /datum/job
	/// Alt titles - typepaths. Properly instantiated after the job is made.
	var/list/alt_titles = list()
	/// Departments we're in - generated at runtime. List of typepaths, not references.
	var/list/departments
	/// Departments we supervise - generated at runtime. List of typepaths, not referneces.
	var/list/departments_supervised
	/// Determines if this job can be spawned into by players
	var/join_types = JOB_ROUNDSTART | JOB_LATEJOIN
	/// HUD icon state
	var/hud_icon_state = "DEFAULT_TO_TITLE"

	// !!Stateful variables!! - If Recover() is ever implemented, these need to be carried over.
	/// How many players have this job
	var/current_positions = 0
	/// How many players can be this job
	var/total_positions = 0
	/// How many players can spawn in as this job
	var/roundstart_positions = 0
	/// Should this job be allowed to be picked for the bureaucratic error event?
	var/allow_bureaucratic_error = TRUE

	//Job access. The use of minimal_access or access is determined by a config setting: config.jobs_have_minimal_access
	var/list/minimal_access = list()		//Useful for servers which prefer to only have access given to the places a job absolutely needs (Larger server population)
	var/list/access = list()				//Useful for servers which either have fewer players, so each person needs to fill more than one role, or servers which like to give more access, so players can't hide forever in their super secure departments (I'm looking at you, chemistry!)

	/// Faction this job is considered part of, for the future considerations of "offmap"/offstation jobs
	var/faction = JOB_FACTION_STATION

	/// Extra text shown on spawn
	var/custom_spawn_text
	/// Supervisor text override
	var/supervisor_text_override

	// These can be flags but I don't care because they're never changed
	/// Can you always join as this job even while respawning (should probably only be on for assistant)
	var/always_can_respawn_as = FALSE
	/// Is this job considered a combat role for respawning? (usually sec/command)
	var/considered_combat_role = FALSE

	/// Starting skill modifiers.
	var/list/starting_modifiers

	//Sellection screen color
	var/selection_color = "#ffffff"

	//If this is set to 1, a text is printed to the player when jobs are assigned, telling him that he should let admins know that he has to disconnect.
	var/req_admin_notify

	//If you have the use_age_restriction_for_jobs config option enabled and the database set up, this option will add a requirement for players to be at least minimal_player_age days old. (meaning they first signed in at least that many days before.)
	var/minimal_player_age = 0

	var/outfit = null
	var/plasma_outfit = null //the outfit given to plasmamen

	var/exp_requirements = 0

	var/exp_type = ""
	var/exp_type_department = ""

	//The amount of good boy points playing this role will earn you towards a higher chance to roll antagonist next round
	//can be overridden by antag_rep.txt config
	var/antag_rep = 10

	var/paycheck = PAYCHECK_MINIMAL
	var/paycheck_department = ACCOUNT_CIV

	var/list/mind_traits // Traits added to the mind of the mob assigned this job
	var/list/blacklisted_quirks		//list of quirk typepaths blacklisted.

	//If a job complies with dresscodes, loadout items will not be equipped instead of the job's outfit, instead placing the items into the player's backpack.
	var/dresscodecompliant = TRUE
	// How much threat this job is worth in dynamic. Is subtracted if the player's not an antag, added if they are.
	var/threat = 0

/**
  * Processes map specific overrides
  * Return FALSE to prevent this job from being instantiated.
  */
/datum/job/proc/ProcessMap(datum/map_config/C)
	. = (length(C.job_whitelist)? (type in C.job_whitelist) : !(type in C.job_blacklist))
	if(!.)
		return
	if(type in C.job_override_roundstart_positions)
		roundstart_positions = C.job_override_roundstart_positions[type]
	if(type in C.job_override_total_positions)
		total_positions = C.job_override_total_positions[type]
	if(type in C.job_access_override)
		access = C.job_access_override[type]
		minimal_access = access
	else
		if(type in C.job_access_add)
			access += C.job_access_add[type]
			minimal_access += C.job_access_add[type]
		if(type in C.job_access_remove)
			access -= C.job_access_add[type]
			minimal_access -= C.job_access_remove[type]
	if(type in C.job_join_type_override)
		join_types = C.job_join_type_override[type]

/**
 * Get the name of the job
 */
/datum/job/proc/GetName()
	return title

/**
 * Get the description of the job
 */
/datum/job/proc/GetDesc()
	return desc

/**
 * Get the unique ID/type of the job
 */
/datum/job/proc/GetID()
	return type

/**
 * Get possible alt titles names, associated to their descriptions
 */
/datum/job/proc/GetTitles()
	. = list()
	.[GetName()] = GetDesc()
	for(var/path in alt_titles)
		var/datum/alt_title/T = path
		if(ispath(T))
			if(.[initial(T.name)])
				continue
			.[initial(T.name)] = initial(T.desc) || GetDesc()
		if(istype(T))
			if(.[T.name])
				continue
			.[T.name] = T.desc || GetDesc()

/**
 * Get "Help" blurb" used in prefs
 */
/datum/job/proc/GetHelpText()
	. = list()
	var/list/info = GetTitles()
	for(var/title in info)
		. += "<b>[title]</b>: [desc]<br>"
	. = jointext(., "")

/**
 * Get deparments supervised
 */
/datum/job/proc/GetSupervisedDepartments()
	RETURN_TYPE(/list)
	. = list()
	for(var/id in departments_supervised)
		return SSjob.GetDepartmentType(id)

/**
 * Get primary department supervised (only sensical for some jobs!)
 */
/datum/job/proc/GetPrimarySupervisedDepartment()
	return LAZYLEN(departments_supervised) && SSjob.GetDepartmentType(departments_supervised[1])

/**
 * Get departments
 */
/datum/job/proc/GetDepartments()
	RETURN_TYPE(/list)
	. = list()
	for(var/id in departments)
		return SSjob.GetDepartmentType(id)

/**
 * Get primary department
 */
/datum/job/proc/GetPrimaryDepartment()
	RETURN_TYPE(/datum/department)
	return LAZYLEN(departments) && SSjob.GetDepartmentType(departments[1])

/**
 * Get subordinate datums
 */
/datum/job/proc/GetSubordinates()
	RETURN_TYPE(/list)
	. = list()
	for(var/id in departments_supervised)
		. |= SSjob.GetDepartmentJobDatums(id)

/**
 * Get subordinate names
 */
/datum/job/proc/GetSubordinateNames()	// seriously screw byond, where's my .filter((dep) => dep.name)
	RETURN_TYPE(/list)
	. = list()
	for(var/id in departments_supervised)
		. |= SSjob.GetDepartmentJobNames(id)

/**
 * Get subordinate IDs
 */
/datum/job/proc/GetSubordinateIDs()
	RETURN_TYPE(/list)
	. = list()
	for(var/id in departments_supervised)
		. |= SSjob.GetDepartmentJobIDs(id)

/**
 * Get head datums
 */
/datum/job/proc/GetHeads()
	RETURN_TYPE(/list)
	. = list()
	for(var/id in departments)
		. |= SSjob.GetJobType(SSjob.GetDepartmentType(id).supervisor)

/**
 * Get head names
 */
/datum/job/proc/GetHeadNames()
	RETURN_TYPE(/list)
	. = list()
	for(var/id in departments)
		. |= SSjob.GetJobType(SSjob.GetDepartmentType(id).supervisor).GetName()

/**
 * Get head IDs
 */
/datum/job/proc/GetHeadIDs()
	RETURN_TYPE(/list)
	. = list()
	for(var/id in departments)
		. |= SSjob.GetDepartmentType(id).supervisor

/**
 * Get minds
 */
/datum/job/proc/GetMinds()
	RETURN_TYPE(/datum/mind)
	return SSjob.GetJobMinds(src)

/**
 * Get living minds
 */
/datum/job/proc/GetLivingMinds()
	RETURN_TYPE(/datum/mind)
	return SSjob.GetLivingJobMinds(src)

/**
 * Do we supervise a department? Only works after SSjob init.
 */
/datum/job/proc/IsDepartmentSupervisor(id)
	if(SSjob.initialized)
		CRASH("SSjob not initialized.")
	return id in departments_supervised

/**
 * Are we in a department? Only works after SSjob init.
 */
/datum/job/proc/IsInDepartment(id)
	if(SSjob.initialized)
		CRASH("SSjob not initialized.")
	return id in departments

/**
 * joins remaining
 */
/datum/job/proc/SlotsRemaining()
	return max(0, total_positions - current_positions)

/**
 * Get spawntext for supervisors
 */
/datum/job/proc/GetSupervisorText()
	return supervisor_text_override || english_list(GetHeadNames())

//Only override this proc
//H is usually a human unless an /equip override transformed it
/datum/job/proc/after_spawn(mob/M, latejoin, client/C)
	//do actions on H but send messages to M as the key may not have been transferred_yet
	if(mind_traits)
		for(var/t in mind_traits)
			ADD_TRAIT(M.mind, t, JOB_TRAIT)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(/datum/quirk/paraplegic in blacklisted_quirks)
			H.regenerate_limbs() //if you can't be a paraplegic, attempt to regenerate limbs to stop amputated limb selection
			H.set_resting(FALSE, TRUE) //they probably shouldn't be on the floor because they had no legs then suddenly had legs

/datum/job/proc/announce(mob/living/carbon/human/H)
	if(!GLOB.announcement_systems.len)
		return
	if(!H)
		return
	for(var/datum/department/D as anything in GetSupervisedDepartments())
		//timer because these should come after the captain announcement
		SSticker.OnRoundstart(CALLBACK(GLOBAL_PROC, .proc/_addtimer, CALLBACK(pick(GLOB.announcement_systems), /obj/machinery/announcement_system/proc/announce, "NEWHEAD", H.real_name, H.job, D.supervisor_announce_channels), 1))


/datum/job/proc/override_latejoin_spawn(mob/living/carbon/human/H)		//Return TRUE to force latejoining to not automatically place the person in latejoin shuttle/whatever.
	return FALSE

//Used for a special check of whether to allow a client to latejoin as this job.
/datum/job/proc/special_check_latejoin(client/C)
	var/joined = LAZYLEN(C.prefs?.characters_joined_as)
	if(C.prefs?.respawn_restrictions_active && (joined || CONFIG_GET(flag/respawn_penalty_includes_observe)))
		if(!CONFIG_GET(flag/allow_non_assistant_respawn) && !always_can_respawn_as)
			return FALSE
		if(!CONFIG_GET(flag/allow_combat_role_respawn) && considered_combat_role)
			return FALSE
	return TRUE

/datum/job/proc/GetAntagRep()
	. = CONFIG_GET(keyed_list/antag_rep)[ckey(title)]
	if(. == null)
		return antag_rep

/datum/job/proc/GetThreat()
	. = CONFIG_GET(keyed_list/job_threat)[ckey(title)]
	if(. == null)
		return threat

//Don't override this unless the job transforms into a non-human (Silicons do this for example)
/datum/job/proc/equip(mob/living/carbon/human/H, visualsOnly = FALSE, announce = TRUE, latejoin = FALSE, datum/outfit/outfit_override = null, datum/preferences/prefs)
	if(!H)
		return FALSE

	if(!visualsOnly)
		var/datum/bank_account/bank_account = new(H.real_name, src)
		bank_account.account_holder = H.real_name
		bank_account.account_job = src
		bank_account.account_id = rand(111111,999999)
		bank_account.payday(STARTING_PAYCHECKS, TRUE)
		H.account_id = bank_account.account_id

	if(CONFIG_GET(flag/enforce_human_authority) && (title in SSjob.GetDepartmentType(/datum/department/command).GetJobNames()))
		if(H.dna.species.id != "human")
			H.set_species(/datum/species/human)
			H.apply_pref_name("human", prefs)

	//Equip the rest of the gear
	H.dna.species.before_equip_job(src, H, visualsOnly)

	var/datum/outfit/job/O = outfit_override || outfit
	if(O)
		H.equipOutfit(O, visualsOnly, prefs) //mob doesn't have a client yet.

	H.dna.species.after_equip_job(src, H, visualsOnly)

	if(!visualsOnly && announce)
		announce(H)

/datum/job/proc/get_access()
	if(!config)	//Needed for robots.
		return src.minimal_access.Copy()

	. = list()

	if(CONFIG_GET(flag/jobs_have_minimal_access))
		. = src.minimal_access.Copy()
	else
		. = src.access.Copy()

	if(CONFIG_GET(flag/everyone_has_maint_access)) //Config has global maint access set
		. |= list(ACCESS_MAINT_TUNNELS)

//If the configuration option is set to require players to be logged as old enough to play certain jobs, then this proc checks that they are, otherwise it just returns 1
/datum/job/proc/player_old_enough(client/C)
	if(available_in_days(C) == 0)
		return TRUE	//Available in 0 days = available right now = player is old enough to play.
	return FALSE

/datum/job/proc/available_in_days(client/C)
	if(!C)
		return 0
	if(!CONFIG_GET(flag/use_age_restriction_for_jobs))
		return 0
	if(!SSdbcore.Connect())
		return 0 //Without a database connection we can't get a player's age so we'll assume they're old enough for all jobs
	if(C.prefs.db_flags & DB_FLAG_EXEMPT)
		return 0
	if(!isnum(minimal_player_age))
		return 0

	return max(0, minimal_player_age - C.player_age)

/datum/job/proc/config_check()
	return TRUE

/datum/job/proc/radio_help_message(mob/M)
	to_chat(M, "<b>Prefix your message with :h to speak on your department's radio. To see other prefixes, look closely at your headset.</b>")

/datum/job/proc/standard_assign_skills(datum/mind/M)
	if(!starting_modifiers)
		return
	for(var/mod in starting_modifiers)
		ADD_SINGLETON_SKILL_MODIFIER(M, mod, null)

//Warden and regular officers add this result to their get_access()
/datum/job/proc/check_config_for_sec_maint()
	if(CONFIG_GET(flag/security_has_maint_access))
		return list(ACCESS_MAINT_TUNNELS)
	return list()

/**
 * Alt title datums
 */
/datum/alt_title
	/// Alt title
	var/name = "Broken Alt Title"
	/// Alt outfit, if any
	var/datum/outfit/outfit
	/// Alt description - if null, defaults to job default
	var/desc
