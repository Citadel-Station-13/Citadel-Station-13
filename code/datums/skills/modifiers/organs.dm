/datum/skill_modifier/brain_damage
	name = "Brain Damage"
	target_skills = list(SKILL_INTELLIGENCE)
	modifier_flags = MODIFIER_SKILL_VALUE|MODIFIER_SKILL_AFFINITY|MODIFIER_SKILL_LEVEL|MODIFIER_SKILL_MULT|MODIFIER_SKILL_BODYBOUND
	value_mod = 0.85
	level_mod = 0.85
	affinity_mod = 0.85

/datum/skill_modifier/heavy_brain_damage
	name = "Brain Damage (Severe)"
	target_skills = list(SKILL_INTELLIGENCE)
	modifier_flags = MODIFIER_SKILL_VALUE|MODIFIER_SKILL_AFFINITY|MODIFIER_SKILL_LEVEL|MODIFIER_SKILL_BODYBOUND|MODIFIER_SKILL_HANDICAP|MODIFIER_USE_THRESHOLDS
	priority = MODIFIER_SKILL_PRIORITY_LOW
	value_mod = THRESHOLD_COMPETENT
	level_mod = THRESHOLD_COMPETENT
