//Security levels
#define SEC_LEVEL_GREEN	1
#define SEC_LEVEL_BLUE	2
#define SEC_LEVEL_AMBER 3
#define SEC_LEVEL_RED	4
#define SEC_LEVEL_DELTA	5

//Macro helpers.
#define SECLEVEL2NUM(text)	(GLOB.all_security_levels.Find(text))
#define NUM2SECLEVEL(num)	(ISINRANGE(num, 1, length(GLOB.all_security_levels)) ? GLOB.all_security_levels[num] : null)
