<<<<<<< HEAD
/datum/admins/proc/create_turf(mob/user)
	var/static/create_turf_html
	if (!create_turf_html)
		var/turfjs = null
		turfjs = jointext(typesof(/turf), ";")
		create_turf_html = file2text('html/create_object.html')
		create_turf_html = replacetext(create_turf_html, "null /* object types */", "\"[turfjs]\"")

	user << browse(replacetext(create_turf_html, "/* ref src */", "\ref[src]"), "window=create_turf;size=425x475")
=======
/datum/admins/proc/create_turf(mob/user)
	var/static/create_turf_html
	if (!create_turf_html)
		var/turfjs = null
		turfjs = jointext(typesof(/turf), ";")
		create_turf_html = file2text('html/create_object.html')
		create_turf_html = replacetext(create_turf_html, "null /* object types */", "\"[turfjs]\"")

	user << browse(replacetext(create_turf_html, "/* ref src */", "\ref[src];[HrefToken()]"), "window=create_turf;size=425x475")
>>>>>>> 84b1e3d... [s] Adds a security token to all admin hrefs (#29839)
