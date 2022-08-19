#define AUXMOS (world.system_type == MS_WINDOWS ? "auxmos.dll" : __detect_auxmos())

/proc/__detect_auxmos()
	var/static/known_auxmos_var
	if(!known_auxmos_var)
		if (fexists("./libauxmos.so"))
			known_auxmos_var = "./libauxmos.so"
		else if (fexists("[world.GetConfig("env", "HOME")]/.byond/bin/libauxmos.so"))
			known_auxmos_var = "[world.GetConfig("env", "HOME")]/.byond/bin/libauxmos.so"
		else
			CRASH("Could not find libauxmos.so")
	return known_auxmos_var
