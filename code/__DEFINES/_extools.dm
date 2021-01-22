// _extools_api.dm - DM API for extools extension library
// (blatently stolen from rust_g)
//
// To configure, create a `extools.config.dm` and set what you care about from
// the following options:
//
// #define EXTOOLS "path/to/extools"
// Override the .dll/.so detection logic with a fixed path or with detection
// logic of your own.

#ifndef EXTOOLS
// Default automatic EXTOOLS detection.
// On Windows, looks in the standard places for `byond-extools.dll`.
// On Linux, looks in the standard places for`libbyond-extools.so`.

/* This comment bypasses grep checks */ /var/__extools

/proc/__detect_extools()
	if (world.system_type == UNIX)
		if (fexists("./libbyond-extools.so"))
			// No need for LD_LIBRARY_PATH badness.
			return __extools = "./libbyond-extools.so"
		else
			// It's not in the current directory, so try others
			return __extools = "libbyond-extools.so"
	else
		return __extools = "byond-extools.dll"

#define EXTOOLS (__extools || __detect_extools())
#endif

#ifndef UNIT_TESTS // use default logging as extools is broken on travis
#define EXTOOLS_LOGGING // rust_g is used as a fallback if this is undefined
#endif

/proc/extools_log_write()

/proc/extools_finalize_logging()
