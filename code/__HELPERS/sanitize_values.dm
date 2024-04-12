//general stuff
/proc/sanitize_integer(number, min=0, max=1, default=0)
	if(isnum(number))
		number = round(number)
		if(min <= number && number <= max)
			return number
	return default

/proc/sanitize_num_clamp(number, min=0, max=1, default=0, quantize=0)
	if(!isnum(number))
		return default
	. = clamp(number, min, max)
	if(quantize)
		. = round(number, quantize)

/proc/sanitize_text(text, default="")
	if(istext(text))
		return text
	return default

/proc/sanitize_islist(value, default)
	if(islist(value) && length(value))
		return value
	if(default)
		return default

/proc/sanitize_inlist(value, list/List, default)
	if(value in List)
		return value
	if(default)
		return default
	if(List && List.len)
		return pick(List)



//more specialised stuff
/proc/sanitize_gender(gender,neuter=0,plural=0, default="male")
	switch(gender)
		if(MALE, FEMALE)
			return gender
		if(NEUTER)
			if(neuter)
				return gender
			else
				return default
		if(PLURAL)
			if(plural)
				return gender
			else
				return default
	return default

#define RGB_FORMAT_INVALID 0
#define RGB_FORMAT_SHORT 1
#define RGB_FORMAT_LONG 2

/**
  * Sanitizes a hexadecimal color. Always outputs lowercase.
  *
  * @params
  * * color - input color, 3 or 6 characters without the #.
  * * desired_format - 3 or 6 characters without the potential #. can only put in 3 or 6 here.
  * * include_crunch - do we put a # at the start
  * * default - default color. must be 3 or 6 characters with or without #.
  * * default_replacement - what we replace broken letters with.
  */
/proc/sanitize_hexcolor(color, desired_format = 3, include_crunch = 0, default = rgb(218, 72, 255), default_replacement = "f")
	if(!istext(default) || (length(default) < 3))
		CRASH("Default should be a text string of RGB format, with or without the crunch, 3 or 6 characters. Default was instead [default]")
	if(!istext(default_replacement) || (length(default_replacement) != 1))
		CRASH("Invalid default_replacement: [default_replacement]")
	default_replacement = lowertext(default_replacement)
	switch(text2ascii(default_replacement))
		if(48 to 57)
		if(97 to 102)
		if(65 to 70)
		else		// yeah yeah i know 3 empty if's..
			CRASH("Invalid default_replacement: [default_replacement]")
	var/crunch = include_crunch ? "#" : ""
	if(!istext(color))
		color = default

	var/len = length(color)
	// get rid of crunch
	if(len && color[1] == "#")
		if(len >= 2)
			color = copytext(color, 2)
		else
			color = ""
		len = length(color)

	switch(desired_format)
		if(3)
			desired_format = RGB_FORMAT_SHORT
		if(6)
			desired_format = RGB_FORMAT_LONG
		else
			CRASH("Invalid desired_format: [desired_format]. Must be 3 or 6.")
	var/current_format = RGB_FORMAT_INVALID
	switch(length(color))
		if(3)
			current_format = RGB_FORMAT_SHORT
		if(6)
			current_format = RGB_FORMAT_LONG
		else
			current_format = RGB_FORMAT_INVALID

	if(current_format == RGB_FORMAT_INVALID)		// nah
		color = default		// process default
		if(color[1] == "#")		// we checked default was at least 3 chars long earlier
			color = copytext(color, 2)
		len = length(color)
		switch(len)
			if(3)
				current_format = RGB_FORMAT_SHORT
			if(6)
				current_format = RGB_FORMAT_LONG
			else
				CRASH("Default was not 3 or 6 RGB hexadecimal characters: [default]")

	var/sanitized = ""
	var/char = ""
	// first, sanitize hex
	for(var/i in 1 to len)
		char = color[i]
		switch(text2ascii(char))
			if(48 to 57)			// 0 to 9
				sanitized += char
			if(97 to 102)			// a to f
				sanitized += char
			if(65 to 70)			// A to F (capitalized!)
				sanitized += lowertext(char)
			else
				sanitized += default_replacement
	// do we need to convert?
	if(desired_format == current_format)
		return crunch + sanitized		// no
	// yes
	if((desired_format == RGB_FORMAT_SHORT) && (current_format == RGB_FORMAT_LONG))			// downconvert
		var/temp = ""
		// we could do some math but we're lazy and in practice floor()ing this.
		for(var/i in 1 to 6 step 2)
			temp += sanitized[i]
		sanitized = temp
	else if((desired_format == RGB_FORMAT_LONG) && (current_format == RGB_FORMAT_SHORT))		// upconvert
		var/temp = ""
		for(var/i in 1 to 3)
			temp += sanitized[i]
			temp += sanitized[i]
		sanitized = temp
	else
		CRASH("Invalid desired_format and current_format pair: [desired_format], [current_format]. Could not determine which way to convert.")
	return crunch + sanitized

#undef RGB_FORMAT_INVALID
#undef RGB_FORMAT_SHORT
#undef RGB_FORMAT_LONG

/// Makes sure the input color is text with a # at the start followed by 6 hexadecimal characters. Examples: "#ff1234", "#A38321", COLOR_GREEN_GRAY
/proc/sanitize_ooccolor(color)
	var/static/regex/color_regex = regex(@"^#[0-9a-fA-F]{6}$")
	return findtext(color, color_regex) ? color : GLOB.normal_ooc_colour
