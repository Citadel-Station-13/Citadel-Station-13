//Readds quotes and apostrophes to HTML-encoded strings
/proc/readd_quotes(var/t)
	var/list/repl_chars = list("&#34;" = "\"","&#39;" = "'")
	for(var/char in repl_chars)
		var/index = findtext(t, char)
		while(index)
			t = copytext(t, 1, index) + repl_chars[char] + copytext(t, index+5)
			index = findtext(t, char)
	return t

proc/TextPreview(var/string,var/len=40)
	if(lentext(string) <= len)
		if(!lentext(string))
			return "\[...\]"
		else
			return string
	else
		return "[copytext(string, 1, 37)]..."

var/list/mentor_log = list (  )
//var/list/admintickets = list()
var/global/list/whitelisted_species_list[0]
/proc/log_mentor(text)
		mentor_log.Add(text)
		diary << "\[[time_stamp()]]MENTOR: [text]"