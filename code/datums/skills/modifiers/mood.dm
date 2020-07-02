/datum/skill_modifier/bad_mood
	name = "Mood (Dejected)"
	modifier_flags = MODIFIER_SKILL_VALUE|MODIFIER_SKILL_LEVEL|MODIFIER_SKILL_MULT|MODIFIER_SKILL_BODYBOUND
	target_skills = list(SKILL_SANITY)

/datum/skill_modifier/great_mood
	name = "Mood (Elated)"
	modifier_flags = MODIFIER_SKILL_AFFINITY|MODIFIER_SKILL_MULT|MODIFIER_SKILL_BODYBOUND
	target_skills = list(SKILL_SANITY)
	affinity_mod = 1.2
