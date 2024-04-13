/datum/asset/simple/portraits
	var/tab = "use subtypes of this please"
	assets = list()

/datum/asset/simple/portraits/New()
	if(!SSpersistence.paintings || !SSpersistence.paintings[tab] || !length(SSpersistence.paintings[tab]))
		return
	for(var/p in SSpersistence.paintings[tab])
		var/list/portrait = p
		var/png = "data/paintings/[tab]/[portrait["md5"]].png"
		if(fexists(png))
			var/asset_name = "[tab]_[portrait["md5"]]"
			assets[asset_name] = png
	..() //this is where it registers all these assets we added to the list

/datum/asset/simple/portraits/library
	tab = "library"

/datum/asset/simple/portraits/library_secure
	tab = "library_secure"

/datum/asset/simple/portraits/library_private
	tab = "library_private"
