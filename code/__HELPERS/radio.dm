<<<<<<< HEAD
// Ensure the frequency is within bounds of what it should be sending/recieving at
/proc/sanitize_frequency(frequency, free = FALSE)
	. = round(frequency)
	if(free)
		. = Clamp(frequency, MIN_FREE_FREQ, MAX_FREE_FREQ)
	else
		. = Clamp(frequency, MIN_FREQ, MAX_FREQ)
	if(!(. % 2)) // Ensure the last digit is an odd number
		. += 1

// Format frequency by moving the decimal.
/proc/format_frequency(frequency)
	frequency = text2num(frequency)
	return "[round(frequency / 10)].[frequency % 10]"
=======
// Ensure the frequency is within bounds of what it should be sending/recieving at
/proc/sanitize_frequency(frequency, free = FALSE)
	. = round(frequency)
	if(free)
		. = CLAMP(frequency, MIN_FREE_FREQ, MAX_FREE_FREQ)
	else
		. = CLAMP(frequency, MIN_FREQ, MAX_FREQ)
	if(!(. % 2)) // Ensure the last digit is an odd number
		. += 1

// Format frequency by moving the decimal.
/proc/format_frequency(frequency)
	frequency = text2num(frequency)
	return "[round(frequency / 10)].[frequency % 10]"
>>>>>>> f6881d3... Merge pull request #32925 from ninjanomnom/maths
