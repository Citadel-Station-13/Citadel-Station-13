#define TIME_BLOODSUCKER_DAY_WARN	90 		// 1.5 minutes
#define TIME_BLOODSUCKER_DAY_FINAL_WARN	25 	// 25 sec
#define TIME_BLOODSUCKER_DAY	60 			// 1.5 minutes // 10 is a second, 600 is a minute.
#define TIME_BLOODSUCKER_BURN_INTERVAL	40 	// 4 sec


// Over Time, tick down toward a "Solar Flare" of UV buffeting the station. This period is harmful to vamps.
/obj/effect/sunlight
	//var/amDay = FALSE
	var/amDay = FALSE
	var/time_til_cycle = 0
	var/nighttime_duration = 900 //15 Minutes
	var/issued_XP = FALSE

/obj/effect/sunlight/Initialize()
	. = ..()

/obj/effect/sunlight/proc/start_countdown()
	START_PROCESSING(SSweather, src) //it counts as weather right
	time_til_cycle = nighttime_duration

/obj/effect/sunlight/process()
	// Update all Bloodsucker sunlight huds
	for(var/datum/mind/M in SSticker.mode.bloodsuckers)
		if(!istype(M) || !istype(M.current))
			continue
		var/datum/antagonist/bloodsucker/bloodsuckerdatum = M.has_antag_datum(ANTAG_DATUM_BLOODSUCKER)
		if(istype(bloodsuckerdatum))
			bloodsuckerdatum.update_sunlight(max(0, time_til_cycle), amDay) // This pings all HUDs
	time_til_cycle--
	if(amDay)
		if(time_til_cycle > 0 && time_til_cycle % 4 == 0)
			punish_vamps()
			if(!issued_XP && time_til_cycle <= 5)
				issued_XP = TRUE
				// Cycle through all vamp antags and check if they're inside a closet.
				for(var/datum/mind/M in SSticker.mode.bloodsuckers)
					if(!istype(M) || !istype(M.current))
						continue
					var/datum/antagonist/bloodsucker/bloodsuckerdatum = M.has_antag_datum(ANTAG_DATUM_BLOODSUCKER)
					if(istype(bloodsuckerdatum))
						bloodsuckerdatum.RankUp()	// Rank up! Must still be in a coffin to level!

		warn_daylight(5,"<span class = 'announce'>The solar flare has ended, and the daylight danger has passed...for now.</span>",\
				  	  "<span class = 'announce'>The solar flare has ended, and the daylight danger has passed...for now.</span>")
		amDay = FALSE
		issued_XP = FALSE
		for(var/datum/mind/M in SSticker.mode.bloodsuckers)
			if(!istype(M) || !istype(M.current))
				continue
			var/datum/antagonist/bloodsucker/bloodsuckerdatum = M.has_antag_datum(ANTAG_DATUM_BLOODSUCKER)
			if(!istype(bloodsuckerdatum))
				continue
			// Reset Warnings
			bloodsuckerdatum.warn_sun_locker = FALSE
			bloodsuckerdatum.warn_sun_burn = FALSE
			// Remove Dawn Powers
			for(var/datum/action/bloodsucker/P in bloodsuckerdatum.powers)
				if(istype(P, /datum/action/bloodsucker/gohome))
					bloodsuckerdatum.powers -= P
					P.Remove(M.current)
		nighttime_duration += 100 //Each day makes the night a minute longer.
		time_til_cycle = nighttime_duration
		message_admins("BLOODSUCKER NOTICE: Daylight Ended. Resetting to Night (Lasts for [nighttime_duration / 60] minutes.)")
	else
		switch(time_til_cycle)
			if(TIME_BLOODSUCKER_DAY_WARN)
				//sleep(TIME_BLOODSUCKER_NIGHT - TIME_BLOODSUCKER_DAY_WARN)
				warn_daylight(1,"<span class = 'danger'>Solar Flares will bombard the station with dangerous UV in [TIME_BLOODSUCKER_DAY_WARN / 60] minutes. <b>Prepare to seek cover in a coffin or closet.</b></span>")  // time2text <-- use Help On
				give_home_power() // Give VANISHING ACT power to all vamps with a lair!
			if(TIME_BLOODSUCKER_DAY_FINAL_WARN)
				message_admins("BLOODSUCKER NOTICE: Daylight beginning in [TIME_BLOODSUCKER_DAY_FINAL_WARN] seconds.)")
				warn_daylight(2,"<span class = 'userdanger'>Solar Flares are about to bombard the station! You have [TIME_BLOODSUCKER_DAY_FINAL_WARN] seconds to find cover!</span>",\
							"<span class = 'danger'>In [TIME_BLOODSUCKER_DAY_FINAL_WARN / 10], your master will be at risk of a Solar Flare. Make sure they find cover!</span>")
			if(5)
				warn_daylight(3,"<span class = 'userdanger'>Seek cover, for Sol rises!</span>")
			if(0)
				warn_daylight(4,"<span class = 'userdanger'>Solar flares bombard the station with deadly UV light!</span><br><span class = ''>Stay in cover for the next [TIME_BLOODSUCKER_DAY / 60] minutes or risk Final Death!</span>",\
				"<span class = 'danger'>Solar flares bombard the station with UV light!</span>")
				amDay = TRUE
				message_admins("BLOODSUCKER NOTICE: Daylight Beginning (Lasts for [TIME_BLOODSUCKER_DAY / 60] minutes.)")
				time_til_cycle = TIME_BLOODSUCKER_DAY

/obj/effect/sunlight/proc/warn_daylight(danger_level =0, vampwarn = "", vassalwarn = "")
	for(var/datum/mind/M in SSticker.mode.bloodsuckers)
		if(!istype(M))
			continue
		to_chat(M,vampwarn)
		if(M.current)
			if(danger_level == 1)
				M.current.playsound_local(null, 'sound/chatter/griffin_3.ogg', 50 + danger_level, 1)
			else if(danger_level == 2)
				M.current.playsound_local(null, 'sound/chatter/griffin_5.ogg', 50 + danger_level, 1)
			else if(danger_level == 3)
				M.current.playsound_local(null, 'sound/effects/alert.ogg', 75, 1)
			else if(danger_level == 4)
				M.current.playsound_local(null, 'sound/ambience/ambimystery.ogg', 100, 1)
			else if(danger_level == 5)
				M.current.playsound_local(null, 'sound/spookoween/ghosty_wind.ogg', 90, 1)

	if(vassalwarn != "")
		for(var/datum/mind/M in SSticker.mode.vassals)
			if(!istype(M))
				continue
			to_chat(M,vassalwarn)


/obj/effect/sunlight/proc/punish_vamps()
	// Cycle through all vamp antags and check if they're inside a closet.
	for(var/datum/mind/M in SSticker.mode.bloodsuckers)
		if(!istype(M) || !istype(M.current))
			continue
		var/datum/antagonist/bloodsucker/bloodsuckerdatum = M.has_antag_datum(ANTAG_DATUM_BLOODSUCKER)
		if(!istype(bloodsuckerdatum))
			continue
		// Closets offer SOME protection
		if(istype(M.current.loc, /obj/structure))
			// Coffins offer the BEST protection
			if(istype(M.current.loc, /obj/structure/closet/crate/coffin))
				SEND_SIGNAL(M.current, COMSIG_ADD_MOOD_EVENT, "vampsleep", /datum/mood_event/coffinsleep)
				continue
			else
				if(!bloodsuckerdatum.warn_sun_locker)
					to_chat(M, "<span class='warning'>Your skin sizzles. The [M.current.loc] doesn't protect well against UV bombardment.</span>")
					bloodsuckerdatum.warn_sun_locker = TRUE
				M.current.adjustFireLoss(0.5 + bloodsuckerdatum.bloodsucker_level / 2) // M.current.fireloss += 0.5 + bloodsuckerdatum.bloodsucker_level / 2  //  Do DIRECT damage. Being spaced was causing this to not occur. setFireLoss(bloodsuckerdatum.bloodsucker_level)
				M.current.updatehealth()
				SEND_SIGNAL(M.current, COMSIG_ADD_MOOD_EVENT, "vampsleep", /datum/mood_event/daylight_1)
		// Out in the Open? Buh Bye
		else
			if(!bloodsuckerdatum.warn_sun_burn)
				if(bloodsuckerdatum.bloodsucker_level > 0)
					to_chat(M, "<span class='userdanger'>The solar flare sets your skin ablaze!</span>")
				else
					to_chat(M, "<span class='userdanger'>The solar flare scalds your neophyte skin!</span>")
				bloodsuckerdatum.warn_sun_burn = TRUE
			if(M.current.fire_stacks <= 0)
				M.current.fire_stacks = 0
			if(bloodsuckerdatum.bloodsucker_level > 0)
				M.current.adjust_fire_stacks(0.2 + bloodsuckerdatum.bloodsucker_level / 10)
				M.current.IgniteMob()
			M.current.adjustFireLoss(2 + bloodsuckerdatum.bloodsucker_level) // M.current.fireloss += 2 + bloodsuckerdatum.bloodsucker_level   //  Do DIRECT damage. Being spaced was causing this to not occur.  //setFireLoss(2 + bloodsuckerdatum.bloodsucker_level)
			M.current.updatehealth()
			SEND_SIGNAL(M.current, COMSIG_ADD_MOOD_EVENT, "vampsleep", /datum/mood_event/daylight_2)

/obj/effect/sunlight/proc/give_home_power()
	// It's late...! Give the "Vanishing Act" gohome power to bloodsuckers.
	for(var/datum/mind/M in SSticker.mode.bloodsuckers)
		if(!istype(M) || !istype(M.current))
			continue
		var/datum/antagonist/bloodsucker/bloodsuckerdatum = M.has_antag_datum(ANTAG_DATUM_BLOODSUCKER)
		if(istype(bloodsuckerdatum) && bloodsuckerdatum.lair && !(locate(/datum/action/bloodsucker/gohome) in bloodsuckerdatum.powers))
			bloodsuckerdatum.BuyPower(new /datum/action/bloodsucker/gohome)
