GLOBAL_VAR_INIT(EXTOOLS_REFERENCE_TRACKING, FALSE)
GLOBAL_PROTECT(EXTOOLS_REFERENCE_TRACKING)
/world/proc/enable_reference_tracking()
	if (fexists(EXTOOLS))
		call(EXTOOLS, "ref_tracking_initialize")()
		GLOB.EXTOOLS_REFERENCE_TRACKING = TRUE

/proc/get_back_references(datum/D)
	CRASH("/proc/get_back_references not hooked by extools, reference tracking will not function!")

/proc/get_forward_references(datum/D)
	CRASH("/proc/get_forward_references not hooked by extools, reference tracking will not function!")

/proc/clear_references(datum/D)
	return

/client/proc/view_refs(atom/D) //it actually supports datums as well but byond no likey
	set category = "Debug"
	set name = "View References"

	if(!check_rights(R_DEBUG))
		return

	var/list/backrefs = get_back_references(D)
	if(isnull(backrefs))
		usr << browse("Reference tracking not enabled", "window=ref_view")
		return
	var/list/frontrefs = get_forward_references(D)
	var/list/dat = list()
	dat += "<h1>References of \ref[D] - [D]</h1><br><a href='?_src_=vars;[HrefToken()];[VV_HK_VIEW_REFERENCES]=TRUE;[VV_HK_TARGET]=[REF(D)]'>\[Refresh\]</a><hr>"
	dat += "<h3>Back references - these things hold references to this object.</h3>"
	dat += "<table>"
	dat += "<tr><th>Ref</th><th>Type</th><th>Variable Name</th><th>Follow</th>"
	for(var/ref in backrefs)
		var/datum/R = ref
		dat += "<tr><td><a href='?_src_=vars;[HrefToken()];Vars=[REF(R)]'>[REF(R)]</td><td>[R.type]</td><td>[backrefs[R]]</td><td><a href='?_src_=vars;[HrefToken()];[VV_HK_VIEW_REFERENCES]=TRUE;[VV_HK_TARGET]=[REF(R)]'>\[Follow\]</a></td></tr>"
	dat += "</table><hr>"
	dat += "<h3>Forward references - this object is referencing those things.</h3>"
	dat += "<table>"
	dat += "<tr><th>Variable name</th><th>Ref</th><th>Type</th><th>Follow</th>"
	for(var/ref in frontrefs)
		var/datum/R = frontrefs[ref]
		dat += "<tr><td>[ref]</td><td><a href='?_src_=vars;[HrefToken()];Vars=[REF(R)]'>[REF(R)]</a></td><td>[R.type]</td><td><a href='?_src_=vars;[HrefToken()];[VV_HK_VIEW_REFERENCES]=TRUE;[VV_HK_TARGET]=[REF(R)]'>\[Follow\]</a></td></tr>"
	dat += "</table><hr>"
	dat = dat.Join()

	usr << browse(dat, "window=ref_view") //Done this way rather than tgui to facilitate porting to other codebases or even byond games

/// called on gc failure
/proc/get_reference_logstring(datum/D)
	. = list("[REF(D)] - [D]: Forward references: \[")
	for(var/F in get_forward_references(D))
		. += "[REF(F)] - [F], "
	. += "\] Back References: \["
	for(var/B in get_back_references(D))
		if(islist(B))
			var/list/owned = get_back_references(D)		// only one recursion level, if it's a multi-layer list it's usually very obvious what's doing it by just knowing that.
			. += "List owned by \["
			for(var/O in owned)
				. += "[REF(O)] - [O]"
			. += "\]"
		else
			. += "[REF(B)] - [B], "
	. += "\]"
	return jointext(., "")
