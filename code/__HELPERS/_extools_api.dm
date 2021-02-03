//#define EXTOOLS_LOGGING // rust_g is used as a fallback if this is undefined

/proc/extools_log_write()

/proc/extools_finalize_logging()

/proc/auxtools_stack_trace(msg)
	CRASH(msg)

GLOBAL_LIST_EMPTY(auxtools_initialized)

#define AUXTOOLS_CHECK(LIB)\
	if (!GLOB.auxtools_initialized[LIB] && fexists(LIB)) {\
		var/status = call(LIB,"auxtools_init")();\
		if(findtext(status,"SUCCESS")) {\
			GLOB.auxtools_initialized[LIB] = TRUE;}\
		else {\
			auxtools_stack_trace("Auxtools failed with status [status]");};\
};

#define AUXTOOLS_SHUTDOWN(LIB)\
	if (GLOB.auxtools_initialized[LIB] && fexists(LIB))\
		call(LIB,"auxtools_shutdown")();\
		GLOB.auxtools_initialized[LIB] = FALSE;\
