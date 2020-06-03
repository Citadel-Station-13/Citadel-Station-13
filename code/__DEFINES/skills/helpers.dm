
//How experience levels are calculated.
#define XP_LEVEL(std, multi, lvl) (std*((multi**lvl)/(multi-1))-std/(multi-1)) //don't use 1 as multi, you'll get division by zero errors
#define DORF_XP_LEVEL(std, extra, lvl) (std*lvl+extra*(lvl*(lvl/2+0.5)))

//More experience value getter macros
#define GET_STANDARD_LVL(lvl) XP_LEVEL(STD_XP_LVL_UP, STD_XP_LVL_MULTI, lvl)
#define GET_DORF_LVL(lvl) DORF_XP_LEVEL(DORF_XP_LVL_UP, DORF_XP_LVL_MULTI, lvl)

#define IS_SKILL_VALUE_GREATER(path, existing, new_value) GLOB.skill_datums[path].is_value_greater(existing, new_value)

#define SANITIZE_SKILL_VALUE(path, value) GLOB.skill_datums[path].sanitize_value(value)

///Doesn't automatically round the value.
#define SANITIZE_SKILL_LEVEL(path, lvl) clamp(lvl, 0, GLOB.skill_datums[path].max_levels)

/// Simple generic identifier macro.
#define GET_SKILL_MOD_ID(path, id) (id ? "[path]&[id]" : path)

/**
  * A simple universal comsig for body bound skill modifiers.
  * Technically they are still bound to the mind, but other signal procs will take care of adding and removing the modifier
  * from/to new/old minds.
  */
#define ADD_SKILL_MODIFIER_BODY(path, id, body, prototype) \
	prototype = GLOB.skill_modifiers[GET_SKILL_MOD_ID(path, id)] || new path(id, TRUE);\
	if(body.mind){\
		body.mind.add_skill_modifier(prototype.identifier)\
	} else {\
		prototype.RegisterSignal(body, COMSIG_MOB_ON_NEW_MIND, /datum/skill_modifier.proc/on_mob_new_mind, TRUE)\
	}

/// Same as above but to remove the skill modifier.
#define REMOVE_SKILL_MODIFIER_BODY(path, id, body) \
	if(GLOB.skill_modifiers[GET_SKILL_MOD_ID(path, id)]){\
		if(body.mind){\
			body.mind.remove_skill_modifier(GET_SKILL_MOD_ID(path, id))\
		} else {\
			GLOB.skill_modifiers[GET_SKILL_MOD_ID(path, id)].UnregisterSignal(body, COMSIG_MOB_ON_NEW_MIND)\
		}\
	}

///Macro used when adding generic singleton skill modifiers.
#define ADD_SINGLETON_SKILL_MODIFIER(mind, path, id) \
	if(!GLOB.skill_modifiers[GET_SKILL_MOD_ID(path, id)]){\
		new path(id, TRUE)\
	};\
	mind.add_skill_modifier(GET_SKILL_MOD_ID(path, id))
