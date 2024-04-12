/datum/yelling_wavefill
	var/stop = FALSE
	var/list/atom/collected

/datum/yelling_wavefill/Destroy(force, ...)
	stop = TRUE
	collected = null		// don't cut it, something else is probably using it now!
	return ..()

/datum/yelling_wavefill/proc/run_wavefill(atom/source, dist = 50)
	collected = list()
	do_run(source, dist)
	// to_chat(world, "DEBUG: collected [english_list(collected)]")

// blatantly copied from wave explosion code
// check explosion2.dm for what this does and how it works.
/datum/yelling_wavefill/proc/do_run(atom/source, dist)
	source = get_turf(source)
	var/list/edges = list()
	edges[source] = (NORTH|SOUTH|EAST|WEST)
	collected += typecache_filter_list(source.contents, GLOB.typecache_living)
	var/list/powers = list()
	powers[source] = dist
	var/list/processed = list()
	var/turf/T
	var/turf/expanding
	var/power
	var/dir
	var/returned
#define RUN_YELL(_T, _P, _D) \
	returned = max(_P - max(_T.get_yelling_resistance(_P), 0) - 1, 0); 	\
	processed[_T] = returned;
	// _T.maptext = MAPTEXT(returned);

	var/list/turf/edges_next
	var/list/turf/powers_next
	var/list/turf/powers_returned
	var/list/turf/diagonals
	var/list/turf/diagonal_powers
	var/list/turf/diagonal_powers_max
	var/safety = 1000

#define CALCULATE_DIAGONAL_POWER(existing, adding, maximum) min(maximum, existing + adding)
#define CALCULATE_DIAGONAL_CROSS_POWER(existing, adding) max(existing, adding)
#define CARDINAL_MARK(ndir, cdir, edir) \
	if(edir & cdir) { \
		expanding = get_step(T,ndir); \
		if(expanding && (isnull(processed[expanding]) || (processed[expanding] < (power - 3)))) { \
			powers_next[expanding] = max(powers_next[expanding], returned); \
			edges_next[expanding] = (cdir | edges_next[expanding]); \
		}; \
	};

#define DIAGONAL_SUBSTEP(ndir, cdir, edir) \
	expanding = get_step(T,ndir); \
	if(expanding && (isnull(processed[expanding]) || (processed[expanding] < (power - 3)))) { \
		if(!edges_next[expanding]) { \
			diagonal_powers_max[expanding] = max(diagonal_powers_max[expanding], returned, powers[T]); \
			diagonal_powers[expanding] = CALCULATE_DIAGONAL_POWER(diagonal_powers[expanding], returned, diagonal_powers_max[expanding]); \
			diagonals[expanding] = (cdir | diagonals[expanding]); \
		}; \
		else { \
			powers_next[expanding] = CALCULATE_DIAGONAL_CROSS_POWER(powers_next[expanding], returned); \
		}; \
	};

#define DIAGONAL_MARK(ndir, cdir, edir) \
	if(edir & cdir) { \
		DIAGONAL_SUBSTEP(turn(ndir, 90), turn(cdir, 90), edir); \
		DIAGONAL_SUBSTEP(turn(ndir, -90), turn(cdir, -90), edir); \
	};

	while(edges.len)
		edges_next = list()
		powers_next = list()
		powers_returned = list()
		diagonals = list()
		diagonal_powers = list()
		diagonal_powers_max = list()
		// to_chat(world, "DEBUG: cycle start edges [english_list_assoc(edges)]")

		// process cardinals
		for(var/i in edges)
			T = i
			power = powers[T]
			dir = edges[T]
			RUN_YELL(T, power, dir)
			powers_returned[T] = returned
			if(returned >= 1)
				collected |= typecache_filter_list(T.contents, GLOB.typecache_living)
			else
				continue

			CARDINAL_MARK(NORTH, NORTH, dir)
			CARDINAL_MARK(SOUTH, SOUTH, dir)
			CARDINAL_MARK(EAST, EAST, dir)
			CARDINAL_MARK(WEST, WEST, dir)

		// to_chat(world, "DEBUG: cycle mid edges_next [english_list_assoc(edges_next)]")

		// Sweep after cardinals for diagonals
		for(var/i in edges)
			T = i
			power = powers[T]
			dir = edges[T]
			returned = powers_returned[T]
			DIAGONAL_MARK(NORTH, NORTH, dir)
			DIAGONAL_MARK(SOUTH, SOUTH, dir)
			DIAGONAL_MARK(EAST, EAST, dir)
			DIAGONAL_MARK(WEST, WEST, dir)

		// to_chat(world, "DEBUG: cycle mid diagonals [english_list_assoc(diagonals)]")

		// Process diagonals:
		for(var/i in diagonals)
			T = i
			power = diagonal_powers[T]
			dir = diagonals[T]
			RUN_YELL(T, power, dir)
			if(returned >= 1)
				collected |= typecache_filter_list(T.contents, GLOB.typecache_living)
			else
				continue
			CARDINAL_MARK(NORTH, NORTH, dir)
			CARDINAL_MARK(SOUTH, SOUTH, dir)
			CARDINAL_MARK(EAST, EAST, dir)
			CARDINAL_MARK(WEST, WEST, dir)

		// to_chat(world, "DEBUG: cycle end edges_next [english_list_assoc(edges_next)]")

		// flush lists
		edges = edges_next
		powers = powers_next

		// sleep(2.5)
		if(!--safety)
			CRASH("Yelling ran out of safety.")

#undef RUN_YELL
#undef DIAGONAL_SUBSTEP
#undef CALCULATE_DIAGONAL_POWER
#undef CALCULATE_DIAGONAL_CROSS_POWER
#undef DIAGONAL_MARK
#undef CARDINAL_MARK

/proc/yelling_wavefill(atom/source, dist = 50)
	var/datum/yelling_wavefill/Y = new
	Y.run_wavefill(source, dist)
	. = Y.collected
	qdel(Y)
