/datum/news/feed_message
	var/body =""
	var/list/authorCensorTime = list()
	var/list/bodyCensorTime = list()
	var/is_admin_message = 0
	var/icon/img = null
	var/time_stamp = ""
	var/list/datum/news/feed_comment/comments = list()
	var/locked = FALSE
	var/caption = ""
	var/creationTime
	var/authorCensor
	var/bodyCensor
	var/photo_file

/datum/news/feed_message/proc/returnAuthor(censor)
	if(censor == -1)
		censor = authorCensor
	var/txt = "[GLOB.news_network.redactedText]"
	if(!censor)
		txt = author
	return txt

/datum/news/feed_message/proc/returnBody(censor)
	if(censor == -1)
		censor = bodyCensor
	var/txt = "[GLOB.news_network.redactedText]"
	if(!censor)
		txt = body
	return txt

/datum/news/feed_message/proc/toggleCensorAuthor()
	if(authorCensor)
		authorCensorTime.Add(GLOB.news_network.lastAction*-1)
	else
		authorCensorTime.Add(GLOB.news_network.lastAction)
	authorCensor = !authorCensor
	GLOB.news_network.lastAction ++

/datum/news/feed_message/proc/toggleCensorBody()
	if(bodyCensor)
		bodyCensorTime.Add(GLOB.news_network.lastAction*-1)
	else
		bodyCensorTime.Add(GLOB.news_network.lastAction)
	bodyCensor = !bodyCensor
	GLOB.news_network.lastAction ++
