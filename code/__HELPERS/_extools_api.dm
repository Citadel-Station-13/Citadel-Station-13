//#define EXTOOLS_LOGGING // rust_g is used as a fallback if this is undefined

/proc/extools_log_write()

/proc/extools_finalize_logging()

/proc/auxtools_stack_trace(msg)
	CRASH(msg)

//glob doesn't exist yet at some gas new calls, imma use it anyways
GLOBAL_REAL_VAR(list/__auxtools_initialized) = list()

#define AUXTOOLS_CHECK(LIB)\
	if (!__auxtools_initialized[LIB]) {\
		if (fexists(LIB)) {\
			var/string = LIBCALL(LIB,"auxtools_init")();\
			if(findtext(string, "SUCCESS")) {\
				__auxtools_initialized[LIB] = TRUE;\
			} else {\
				CRASH(string);\
			}\
		} else {\
			CRASH("No file named [LIB] found!")\
		}\
	}\

#define AUXTOOLS_SHUTDOWN(LIB)\
	if (__auxtools_initialized[LIB] && fexists(LIB)){\
		LIBCALL(LIB,"auxtools_shutdown")();\
		__auxtools_initialized[LIB] = FALSE;\
	}\
