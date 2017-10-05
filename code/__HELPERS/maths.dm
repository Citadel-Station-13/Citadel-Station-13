// Credits to Nickr5 for the useful procs I've taken from his library resource.

GLOBAL_VAR_INIT(E, 2.71828183)
GLOBAL_VAR_INIT(Sqrt2, 1.41421356)

// List of square roots for the numbers 1-100.
GLOBAL_LIST_INIT(sqrtTable, list(1, 1, 1, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 3, 4, 4, 4, 4, 4, 4, 4, 4, 4, 5,
                          5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 7, 7,
                          7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8,
                          8, 8, 8, 8, 8, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 10))

/proc/sign(x)
	return x!=0?x/abs(x):0

/proc/Atan2(x, y)
	if(!x && !y)
		return 0
	var/a = arccos(x / sqrt(x*x + y*y))
	return y >= 0 ? a : -a

/proc/Ceiling(x, y=1)
	return -round(-x / y) * y

/proc/Floor(x, y=1)
	return round(x / y) * y

#define Clamp(CLVALUE,CLMIN,CLMAX) ( max( (CLMIN), min((CLVALUE), (CLMAX)) ) )

// cotangent
/proc/Cot(x)
	return 1 / Tan(x)

// cosecant
/proc/Csc(x)
	return 1 / sin(x)

/proc/Default(a, b)
	return a ? a : b

// Greatest Common Divisor - Euclid's algorithm
/proc/Gcd(a, b)
	return b ? Gcd(b, a % b) : a

/proc/Inverse(x)
	return 1 / x

/proc/IsAboutEqual(a, b, deviation = 0.1)
	return abs(a - b) <= deviation

/proc/IsEven(x)
	return x % 2 == 0

// Returns true if val is from min to max, inclusive.
/proc/IsInRange(val, min, max)
	return min <= val && val <= max

/proc/IsInteger(x)
	return round(x) == x

/proc/IsOdd(x)
	return !IsEven(x)

/proc/IsMultiple(x, y)
	return x % y == 0

// Least Common Multiple
/proc/Lcm(a, b)
	return abs(a) / Gcd(a, b) * abs(b)

// Performs a linear interpolation between a and b.
// Note that amount=0 returns a, amount=1 returns b, and
// amount=0.5 returns the mean of a and b.
/proc/Lerp(a, b, amount = 0.5)
	return a + (b - a) * amount

//Calculates the sum of a list of numbers.
/proc/Sum(var/list/data)
	. = 0
	for(var/val in data)
		.+= val

//Calculates the mean of a list of numbers.
/proc/Mean(var/list/data)
	. = Sum(data) / (data.len)


// Returns the nth root of x.
/proc/Root(n, x)
	return x ** (1 / n)

// secant
/proc/Sec(x)
	return 1 / cos(x)

// The quadratic formula. Returns a list with the solutions, or an empty list
// if they are imaginary.
/proc/SolveQuadratic(a, b, c)
	ASSERT(a)
	. = list()
	var/d		= b*b - 4 * a * c
	var/bottom  = 2 * a
	if(d < 0)
		return
	var/root = sqrt(d)
	. += (-b + root) / bottom
	if(!d)
		return
	. += (-b - root) / bottom

// tangent
/proc/Tan(x)
	return sin(x) / cos(x)

/proc/ToDegrees(radians)
				  // 180 / Pi
	return radians * 57.2957795

/proc/ToRadians(degrees)
				  // Pi / 180
	return degrees * 0.0174532925

// Will filter out extra rotations and negative rotations
// E.g: 540 becomes 180. -180 becomes 180.
/proc/SimplifyDegrees(degrees)
	degrees = degrees % 360
	if(degrees < 0)
		degrees += 360
	return degrees

// min is inclusive, max is exclusive
/proc/Wrap(val, min, max)
	var/d = max - min
	var/t = round((val - min) / d)
	return val - (t * d)

#define NORM_ROT(rot) ((((rot % 360) + (rot - round(rot, 1))) > 0) ? ((rot % 360) + (rot - round(rot, 1))) : (((rot % 360) + (rot - round(rot, 1))) + 360))

/proc/get_angle_of_incidence(face_angle, angle_in, auto_normalize = TRUE)

	var/angle_in_s = NORM_ROT(angle_in)
	var/face_angle_s = NORM_ROT(face_angle)
	var/incidence = face_angle_s - angle_in_s
	var/incidence_s = incidence
	while(incidence_s < -90)
		incidence_s += 180
	while(incidence_s > 90)
		incidence_s -= 180
	if(auto_normalize)
		return incidence_s
	else
		return incidence

//A logarithm that converts an integer to a number scaled between 0 and 1 (can be tweaked to be higher).
//Currently, this is used for hydroponics-produce sprite transforming, but could be useful for other transform functions.
/proc/TransformUsingVariable(input, inputmaximum, scaling_modifier = 0)

		var/inputToDegrees = (input/inputmaximum)*180 //Converting from a 0 -> 100 scale to a 0 -> 180 scale. The 0 -> 180 scale corresponds to degrees
		var/size_factor = ((-cos(inputToDegrees) +1) /2) //returns a value from 0 to 1

		return size_factor + scaling_modifier //scale mod of 0 results in a number from 0 to 1. A scale modifier of +0.5 returns 0.5 to 1.5

//converts a uniform distributed random number into a normal distributed one
//since this method produces two random numbers, one is saved for subsequent calls
//(making the cost negligble for every second call)
//This will return +/- decimals, situated about mean with standard deviation stddev
//68% chance that the number is within 1stddev
//95% chance that the number is within 2stddev
//98% chance that the number is within 3stddev...etc
#define ACCURACY 10000
/proc/gaussian(mean, stddev)
	var/static/gaussian_next
	var/R1;var/R2;var/working
	if(gaussian_next != null)
		R1 = gaussian_next
		gaussian_next = null
	else
		do
			R1 = rand(-ACCURACY,ACCURACY)/ACCURACY
			R2 = rand(-ACCURACY,ACCURACY)/ACCURACY
			working = R1*R1 + R2*R2
		while(working >= 1 || working==0)
		working = sqrt(-2 * log(working) / working)
		R1 *= working
		gaussian_next = R2 * working
	return (mean + stddev * R1)
#undef ACCURACY

/proc/mouse_angle_from_client(client/client)
	var/list/mouse_control = params2list(client.mouseParams)
	if(mouse_control["screen-loc"])
		var/list/screen_loc_params = splittext(mouse_control["screen-loc"], ",")
		var/list/screen_loc_X = splittext(screen_loc_params[1],":")
		var/list/screen_loc_Y = splittext(screen_loc_params[2],":")
		var/x = (text2num(screen_loc_X[1]) * 32 + text2num(screen_loc_X[2]) - 32)
		var/y = (text2num(screen_loc_Y[1]) * 32 + text2num(screen_loc_Y[2]) - 32)
		var/screenview = (client.view * 2 + 1) * world.icon_size //Refer to http://www.byond.com/docs/ref/info.html#/client/var/view for mad maths
		var/ox = round(screenview/2) - client.pixel_x //"origin" x
		var/oy = round(screenview/2) - client.pixel_y //"origin" y
		var/angle = NORM_ROT(Atan2(y - oy, x - ox))
		return angle

/proc/get_turf_in_angle(angle, turf/starting, increments)
	var/pixel_x = 0
	var/pixel_y = 0
	for(var/i in 1 to increments)
		pixel_x += sin(angle)+16*sin(angle)*2
		pixel_y += cos(angle)+16*cos(angle)*2
	var/new_x = starting.x
	var/new_y = starting.y
	while(pixel_x > 16)
		pixel_x -= 32
		new_x++
	while(pixel_x < -16)
		pixel_x += 32
		new_x--
	while(pixel_y > 16)
		pixel_y -= 32
		new_y++
	while(pixel_y < -16)
		pixel_y += 32
		new_y--
	new_x = Clamp(new_x, 0, world.maxx)
	new_y = Clamp(new_y, 0, world.maxy)
	return locate(new_x, new_y, starting.z)

/proc/round_down(num)
	if(round(num) != num)
		return round(num--)
	else return num
