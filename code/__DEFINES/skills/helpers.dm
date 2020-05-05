/**
  *Generic delay calculation macro for various delayed actions.
  *The skill to check must be an instance, not a path or list.
  */
#define SKILL_MODIFIER(to_check, holder, target, threshold) \
	var/___value;\
	switch(to_check.progression_type){\
		if(SKILL_PROGRESSION_LEVEL){\
			___value = LAZYACCESS(holder.skill_levels, to_check.type)\
		} else {\
			___value = LAZYACCESS(holder.skills, to_check.type)\
		}\
	}\
	target /= (1+(___value-to_check.competency_thresholds[threshold])*to_check.competency_mults[threshold])

/// This is the one that accepts typepaths and lists.
#define LIST_SKILL_MODIFIER(to_check, holder, target, threshold) \
	if(!islist(to_check)){\
		SKILL_MODIFIER(GLOB.skill_datums[to_check], holder, target, threshold)\
	} else {\
		var/___sum = 0;\
		var/list/___L = to_check;\
		for(var/_S in ___L){\
			var/___value;\
			var/datum/skill/___S = GLOB.skill_datums[_S];\
			switch(___S.progression_type){\
				if(SKILL_PROGRESSION_LEVEL){\
					___value = LAZYACCESS(holder.skill_levels, ___S.type)\
				} else {\
					___value = LAZYACCESS(holder.skills, ___S.type)\
				}\
			}\
			___sum += (1+(___value - ___S.competency_thresholds[threshold])*___S.competency_mults[threshold])\
		}\
		target /= (___sum/length(___L))\
	}

//How experience levels are calculated.
#define XP_LEVEL(std, multi, lvl) (std*((multi**lvl)/(multi-1))-std/(multi-1)) //don't use 1 as multi, you'll get division by zero errors
#define DORF_XP_LEVEL(std, extra, lvl) (std*lvl+extra*(lvl*(lvl/2+0.5)))

//More experience value getter macros
#define GET_STANDARD_LVL(lvl) XP_LEVEL(STD_XP_LVL_UP, STD_XP_LVL_MULTI, lvl)
#define GET_DORF_LVL(lvl) DORF_XP_LEVEL(DORF_XP_LVL_UP, DORF_XP_LVL_MULTI, lvl)
