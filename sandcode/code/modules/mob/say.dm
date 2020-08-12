/proc/animate_speechbubble(image/I, list/show_to, duration)
	var/matrix/M = matrix()
	M.Scale(0,0)
	I.transform = M
	I.alpha = 0
	for(var/client/C in show_to)
		C.images += I
	animate(I, transform = 0, alpha = 255, time = 5, easing = ELASTIC_EASING)
	spawn(duration-5)
	animate(I, alpha = 0, time = 5, easing = EASE_IN)
	spawn(20)
	for(var/client/C in show_to)
		C.images -= I 

/mob/proc/terror_spider_check()
	return FALSE
