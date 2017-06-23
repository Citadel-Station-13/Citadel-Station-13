GLOBAL_LIST(mentor_datums)

/datum/mentors
	var/client/owner	= null
	var/following		= null

/datum/mentors/New(ckey)
	if(!ckey)
		del(src)
		return
	GLOB.mentor_datums[ckey] = src

/datum/mentors/proc/associate(client/C)
	if(istype(C))
		owner = C
		GLOB.mentors |= C

/datum/mentors/proc/disassociate()
	if(owner)
		GLOB.mentors -= owner
		owner = null

/client/proc/dementor()
	var/mentor = GLOB.mentor_datums[ckey]
	GLOB.mentor_datums -= ckey
	qdel(mentor)

	return 1

/proc/check_mentor()
	if(usr && usr.client)
		var/mentor = GLOB.mentor_datums[usr.client.ckey]
		if(mentor || check_rights(R_ADMIN,0))
			return 1

	return 0

/proc/check_mentor_other(var/client/C)
	if(C)
		var/mentor = GLOB.mentor_datums[C.ckey]
		if(C.holder && C.holder.rank)
			if(C.holder.rank.rights & R_ADMIN)
				return 1
		else if(mentor)
			return 1
	return 0