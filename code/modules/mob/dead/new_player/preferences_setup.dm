
	//The mob should have a gender you want before running this proc. Will run fine without H
/datum/preferences/proc/random_character(gender_override)
	if(gender_override)
		gender = gender_override
	else
		gender = pick(MALE,FEMALE)
	skin_tone = random_skin_tone()
	hair_style = random_hair_style(gender)
	facial_hair_style = random_facial_hair_style(gender)
	hair_color = random_short_color()
	facial_hair_color = hair_color
	eye_color = random_eye_color()
	if(!pref_species)
		var/rando_race = pick(config.roundstart_races)
		pref_species = new rando_race()
	features = random_features()
	age = rand(AGE_MIN,AGE_MAX)

/datum/preferences/proc/update_preview_icon(nude = 0)
	var/wide_icon = 0
	var/stamp_x = 0
	var/stamp_y = 1
	if(features["taur"] != "None")
		wide_icon = 1
	// Silicons only need a very basic preview since there is no customization for them.
	if(job_engsec_high)
		switch(job_engsec_high)
			if(AI)
				preview_icon = icon('icons/mob/AI.dmi', "AI", SOUTH)
				preview_icon.Scale(64, 64)
				return
			if(CYBORG)
				preview_icon = icon('icons/mob/robots.dmi', "robot", SOUTH)
				preview_icon.Scale(64, 64)
				return

	// Set up the dummy for its photoshoot
	var/mob/living/carbon/human/dummy/mannequin = new()
	copy_to(mannequin)

	// Determine what job is marked as 'High' priority, and dress them up as such.
	var/datum/job/previewJob
	var/highRankFlag = job_civilian_high | job_medsci_high | job_engsec_high

	if(job_civilian_low & ASSISTANT)
		previewJob = SSjob.GetJob("Assistant")
	else if(highRankFlag)
		var/highDeptFlag
		if(job_civilian_high)
			highDeptFlag = CIVILIAN
		else if(job_medsci_high)
			highDeptFlag = MEDSCI
		else if(job_engsec_high)
			highDeptFlag = ENGSEC

		for(var/datum/job/job in SSjob.occupations)
			if(job.flag == highRankFlag && job.department_flag == highDeptFlag)
				previewJob = job
				break

	if(previewJob && !nude)
		mannequin.job = previewJob.title
		previewJob.equip(mannequin, TRUE)
	CHECK_TICK
	preview_icon = icon('icons/effects/effects.dmi', "nothing")
	preview_icon.Scale((112), (32))
	CHECK_TICK
	mannequin.setDir(NORTH)

	var/icon/stamp = getFlatIcon(mannequin)
	CHECK_TICK
	if(wide_icon)
		stamp_x = 16
	else
		stamp_x = 32
	preview_icon.Blend(stamp, ICON_OVERLAY, stamp_x, stamp_y)
	CHECK_TICK
	mannequin.setDir(WEST)
	stamp = getFlatIcon(mannequin)
	CHECK_TICK
	if(wide_icon)
		stamp_x = 48
	else
		stamp_x = 64
	preview_icon.Blend(stamp, ICON_OVERLAY, stamp_x, stamp_y)
	CHECK_TICK
	mannequin.setDir(SOUTH)
	stamp = getFlatIcon(mannequin)
	CHECK_TICK
	if(wide_icon)
		stamp_x = -15
	else
		stamp_x = 1
	preview_icon.Blend(stamp, ICON_OVERLAY, stamp_x, stamp_y)
	CHECK_TICK
	preview_icon.Scale(preview_icon.Width() * 2, preview_icon.Height() * 2) // Scaling here to prevent blurring in the browser.
	CHECK_TICK
	qdel(mannequin)
