#define MAX_JSON_DEPTH 9
#define MAX_CONSEQUETIVE_ARRAYS 5
/proc/____json_decode(text)
	var/current = 0
	var/max = 0
	for(var/i in 1 to length(text))
		switch(text[i])
			if("\[", "{")
				current++
				max++
			if("]", "}")
				max--
			else
				current = 0
		if(current > MAX_CONSEQUETIVE_ARRAYS)
			var/error = "[current] > [MAX_CONSEQUETIVE_ARRAYS] consequetive empty arrays reached. Terminating. usr was [key_name(usr)], you may want to question and/or ban them."
			message_admins(error)
			log_admin("[error] - [text]")
			return list()
		else if(max > MAX_JSON_DEPTH)
			var/error = "[max] > [MAX_JSON_DEPTH] maximum json depth reached. Terminating. usr was [key_name(usr)], you may want to question and/or ban them."
			message_admins(error)
			log_admin("[error] - [text]")
			return list()
	return json_deocde(text)

#undef MAX_JSON_DEPTH
#undef MAX_CONSEQUETIVE_ARRAYS

#define json_decode(thing) ____json_decode(thing)
