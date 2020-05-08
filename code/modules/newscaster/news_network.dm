GLOBAL_DATUM_INIT(news_network, /datum/news_network, new)

/// Contains all the news datum of a newscaster system.
/datum/news_network
	var/list/datum/news/feed_channel/network_channels = list()
	var/datum/news/wanted_message/wanted_issue
	var/lastAction
	var/redactedText = "\[REDACTED\]"

/datum/news_network/New()
	CreateFeedChannel("Station Announcements", "SS13", 1)
	wanted_issue = new /datum/news/wanted_message

/datum/news_network/proc/CreateFeedChannel(channel_name, author, locked, adminChannel = 0)
	var/datum/news/feed_channel/newChannel = new /datum/news/feed_channel
	newChannel.channel_name = channel_name
	newChannel.author = author
	newChannel.locked = locked
	newChannel.is_admin_channel = adminChannel
	network_channels += newChannel

/datum/news_network/proc/SubmitArticle(msg, author, channel_name, datum/picture/picture, adminMessage = 0, allow_comments = 1)
	var/datum/news/feed_message/newMsg = new /datum/news/feed_message
	newMsg.author = author
	newMsg.body = msg
	newMsg.time_stamp = STATION_TIME_TIMESTAMP("hh:mm:ss", world.time)
	newMsg.is_admin_message = adminMessage
	newMsg.locked = !allow_comments
	if(picture)
		newMsg.img = picture.picture_image
		newMsg.caption = picture.caption
		newMsg.photo_file = save_photo(picture.picture_image)
	for(var/datum/news/feed_channel/FC in network_channels)
		if(FC.channel_name == channel_name)
			FC.messages += newMsg
			break
	for(var/obj/machinery/newscaster/NEWSCASTER in GLOB.allCasters)
		NEWSCASTER.newsAlert(channel_name)
	lastAction ++
	newMsg.creationTime = lastAction

/datum/news_network/proc/submitWanted(criminal, body, scanned_user, datum/picture/picture, adminMsg = 0, newMessage = 0)
	wanted_issue.active = 1
	wanted_issue.criminal = criminal
	wanted_issue.body = body
	wanted_issue.scannedUser = scanned_user
	wanted_issue.isAdminMsg = adminMsg
	if(picture)
		wanted_issue.img = picture.picture_image
		wanted_issue.photo_file = save_photo(picture.picture_image)
	if(newMessage)
		for(var/obj/machinery/newscaster/N in GLOB.allCasters)
			N.newsAlert()
			N.update_icon()

/datum/news_network/proc/deleteWanted()
	wanted_issue.active = 0
	wanted_issue.criminal = null
	wanted_issue.body = null
	wanted_issue.scannedUser = null
	wanted_issue.img = null
	for(var/obj/machinery/newscaster/NEWSCASTER in GLOB.allCasters)
		NEWSCASTER.update_icon()

/datum/news_network/proc/save_photo(icon/photo)
	var/photo_file = copytext_char(md5("\icon[photo]"), 1, 6)
	if(!fexists("[GLOB.log_directory]/photos/[photo_file].png"))
		//Clean up repeated frames
		var/icon/clean = new /icon()
		clean.Insert(photo, "", SOUTH, 1, 0)
		fcopy(clean, "[GLOB.log_directory]/photos/[photo_file].png")
	return photo_file
