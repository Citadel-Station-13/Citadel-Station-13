/proc/SQLDatetimeToList(DT)
	var/list/split1 = splittext(DT, " ")
	var/date = split1[1]
	var/time = split1[2]
	var/list/split2 = splittext(date, "-")
	var/list/split3 = splittext(time, ":")
	var/year = text2num(split2[1])
	var/month = text2num(split2[2])
	var/day = text2num(split2[3])
	var/hour = text2num(split3[1])
	var/minute = text2num(split3[2])
	var/second = text2num(split3[3])
	return list(year, month, day, hour, minute, second)

/proc/SQLDatetimeListDecrementDays(list/L, days)
	var/current = L[3]
	if(days < current)
		L[3] -= days
		return
	L[3] = 31
	days -= current
	var/months = round(days, 31) + 1
	SQLDatetimeListDecrementMonths(L, months)
	SQLDatetimeListDecrementDays(L, MODULUS(days, 31))
	return L

/proc/SQLDatetimeListDecrementMonths(list/L, months)
	var/current = L[2]
	if(months < current)
		L[2] -= months
		return
	L[2] = 12
	months -= current
	var/years = round(months / 12) + 1
	SQLDatetimeListDecrementYears(L, years)
	SQLDatetimeListDecrementMonths(L, MODULUS(months, 12))
	return L

/proc/SQLDatetimeListDecrementYears(list/L, years)
	L[1] = CLAMP(L[1] - years, 1000, 9999)
	return L

/proc/SQLListToDatetime(list/L)
	return SQLMakeDatetime(L[1], L[2], L[3], L[4], L[5], L[6])

/proc/SQLMakeDatetime(year, month, day, hour, minute, second)
	if(!isnum(year))
		year = text2num(year)
	if(!isnum(month))
		month = text2num(month)
	if(!isnum(day))
		day = text2num(day)
	if(!isnum(hour))
		hour = text2num(hour)
	if(!isnum(minute))
		minute = text2num(minute)
	if(!isnum(second))
		second = text2num(second)
	hour = CLAMP(hour, 0, 24)
	minute = CLAMP(minute, 0, 60)
	second = CLAMP(second, 0, 60)
	year = CLAMP(year, 1000, 9999)
	month = CLAMP(month, 1, 12)
	day = CLAMP(day, 1, 31)
	//Reee special treatment!
	month = "[month]"
	day = "[day]"
	if(length(month) == 1)
		month = "0[month]"
	if(length(day) == 1)
		day = "0[day]"
	return "[year]-[month]-[day] [hour]:[minute]:[second]"
