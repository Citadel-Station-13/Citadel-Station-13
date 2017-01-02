//Returns the world time in english
/proc/worldtime2text()
	return gameTimestamp("hh:mm")

/proc/time_stamp(format = "hh:mm:ss")
	return time2text(world.timeofday, format)

/proc/gameTimestamp(format = "hh:mm:ss") // Get the game time in text
	return time2text(world.time - timezoneOffset + 432000, format)

/* Returns 1 if it is the selected month and day */
/proc/isDay(month, day)
	if(isnum(month) && isnum(day))
		var/MM = text2num(time2text(world.timeofday, "MM")) // get the current month
		var/DD = text2num(time2text(world.timeofday, "DD")) // get the current day
		if(month == MM && day == DD)
			return 1

		// Uncomment this out when debugging!
		//else
			//return 1

//returns timestamp in a sql and ISO 8601 friendly format
/proc/SQLtime()
	return time2text(world.realtime, "YYYY-MM-DD hh:mm:ss")