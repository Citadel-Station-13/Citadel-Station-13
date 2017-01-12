//Helper procs for converting units.

//Length:
//Inches -> X
/proc/inToCm(inches)
	if(isnum(inches))
		return inches * 2.540

/proc/inToFt(inches)
	if(isnum(inches))
		return inches / 12

//Centimeters -> X
/proc/cmToIn(centimeters)
	if(isnum(centimeters))
		return centimeters / 0.393701

/proc/cmToFt(centimeters)
	if(isnum(centimeters))
		return centimeters / 0.0328084

/proc/cmToM(centimeters)
	if(isnum(centimeters))
		return centimeters / 100

/proc/cmToKm(centimeters)
	if(isnum(centimeters))
		return centimeters / 100000

//Feet -> X
/proc/ftToCm(feet)
	if(isnum(feet))
		return feet * 30.48

/proc/ftToIn(feet)
	if(isnum(feet))
		return feet * 12

/proc/ftToYd(feet)
	if(isnum(feet))
		return feet / 0.333333

/proc/ftToM(feet)
	if(isnum(feet))
		return feet / 0.3048
