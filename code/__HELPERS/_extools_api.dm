//#define EXTOOLS_LOGGING // rust_g is used as a fallback if this is undefined

/proc/extools_log_write()

/proc/extools_finalize_logging()

/proc/auxtools_stack_trace(err)
	stack_trace(err)

GLOBAL_VAR_INIT(auxtools_initialized,FALSE)

#define AUXTOOLS_CHECK\
	if (!GLOB.auxtools_initialized && fexists(AUXTOOLS) && findtext(call(AUXTOOLS,"auxtools_init")(),"SUCCESS"))\
		GLOB.auxtools_initialized = TRUE;\
