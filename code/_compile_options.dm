//#define TESTING				//By using the testing("message") proc you can create debug-feedback for people with this
								//uncommented, but not visible in the release version)

//#define DATUMVAR_DEBUGGING_MODE	//Enables the ability to cache datum vars and retrieve later for debugging which vars changed.

// Comment this out if you are debugging problems that might be obscured by custom error handling in world/Error
#ifdef DEBUG
#define USE_CUSTOM_ERROR_HANDLER

#ifdef TESTING
#define DATUMVAR_DEBUGGING_MODE

//#define GC_FAILURE_HARD_LOOKUP	//makes paths that fail to GC call find_references before del'ing.
									//implies FIND_REF_NO_CHECK_TICK

//#define FIND_REF_NO_CHECK_TICK	//Sets world.loop_checks to false and prevents find references from sleeping


//#define VISUALIZE_ACTIVE_TURFS	//Highlights atmos active turfs in green

//#define UNIT_TESTS			//Enables unit tests via TEST_RUN_PARAMETER

#ifndef PRELOAD_RSC				//set to:
#define PRELOAD_RSC	2			//	0 to allow using external resources or on-demand behaviour;
								//	2 for preloading absolutely everything;

#ifdef LOWMEMORYMODE
#define FORCE_MAP "_maps/runtimestation.json"

//Update this whenever you need to take advantage of more recent byond features
#define MIN_COMPILER_VERSION 512
//Don't forget to update this part
#error Your version of BYOND is too out-of-date to compile this project. Go to https://secure.byond.com/download and update.
#error You need version 512 or higher

//Compatability -- These procs were added in 513.1493, not 513.1490
//Which really shoulda bumped us up to 514 right then and there but instead Lummox is a dumb dumb
#define length_char(args...) length(args)
#define text2ascii_char(args...) text2ascii(args)
#define copytext_char(args...) copytext(args)
#define splittext_char(args...) splittext(args)
#define spantext_char(args...) spantext(args)
#define nonspantext_char(args...) nonspantext(args)
#define findtext_char(args...) findtext(args)
#define findtextEx_char(args...) findtextEx(args)
#define findlasttext_char(args...) findlasttext(args)
#define findlasttextEx_char(args...) findlasttextEx(args)
#define replacetext_char(args...) replacetext(args)
#define replacetextEx_char(args...) replacetextEx(args)
// /regex procs
#define Find_char(args...) Find(args)
#define Replace_char(args...) Replace(args)

//Additional code for the above flags.
#ifdef TESTING
#warn compiling in TESTING mode. testing() debug messages will be visible.

#ifdef GC_FAILURE_HARD_LOOKUP
#define FIND_REF_NO_CHECK_TICK

#ifdef TRAVISBUILDING
#define UNIT_TESTS

#ifdef TRAVISTESTING
#define TESTING
