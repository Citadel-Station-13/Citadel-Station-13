/datum/skill_modifier/bad_mood
	modifier_flags = MODIFIER_SKILL_VALUE|MODIFIER_SKILL_LEVEL|MODIFIER_SKILL_MULT|MODIFIER_SKILL_BODYBOUND
	target_skills = list(SKILL_SANITY)

/datum/skill_modifier/great_mood
	modifier_flags = MODIFIER_SKILL_AFFINITY|MODIFIER_SKILL_MULT|MODIFIER_SKILL_BODYBOUND
	target_skills = list(SKILL_SANITY)
	affinity_mod = 1.2
