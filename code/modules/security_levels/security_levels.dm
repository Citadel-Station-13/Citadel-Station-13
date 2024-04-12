GLOBAL_VAR_INIT(security_level, SEC_LEVEL_GREEN)
//SEC_LEVEL_GREEN = code green
//SEC_LEVEL_BLUE = code blue
//SEC_LEVEL_AMBER = code amber
//SEC_LEVEL_RED = code red
//SEC_LEVEL_DELTA = code delta

 /*
  * All security levels, per ascending alert. Nothing too fancy, really.
  * Their positions should also match their numerical values.
  */
GLOBAL_LIST_INIT(all_security_levels, list("green", "blue", "amber", "red", "delta"))

//config.alert_desc_blue_downto

/proc/set_security_level(level)
	SSsecurity_level.set_level(level)
