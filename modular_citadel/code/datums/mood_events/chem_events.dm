/datum/mood_event/eigenstate
  mood_change = -3
  description = "<span class='warning'>Where the hell am I? Is this an alternative dimension ?</span>\n"

/datum/mood_event/enthrall
   mood_change = 5

/datum/mood_event/enthrall/add_effects(message)
   description = "<span class='nicegreen'>[message]</span>\n"

/datum/mood_event/enthrallpraise
	mood_change = 10
	timeout = 1 MINUTES

/datum/mood_event/enthrallpraise/add_effects(message)
   description = "<span class='nicegreen'>[message]</span>\n"

/datum/mood_event/enthrallscold
   mood_change = -10
   timeout = 1 MINUTES

/datum/mood_event/enthrallscold/add_effects(message)
	description = "<span class='warning'>[message]</span>\n"//aaa I'm not kinky enough for this

/datum/mood_event/enthrallmissing1
   mood_change = -5

/datum/mood_event/enthrallmissing1/add_effects(message)
   description = "<span class='warning'>[message]</span>\n"

/datum/mood_event/enthrallmissing2
   mood_change = -10

/datum/mood_event/enthrallmissing2/add_effects(message)
	description = "<span class='warning'>[message]</span>\n"

/datum/mood_event/enthrallmissing3
   mood_change = -15

/datum/mood_event/enthrallmissing3/add_effects(message)
	description = "<span class='warning'>[message]</span>\n"

/datum/mood_event/enthrallmissing4
   mood_change = -25

/datum/mood_event/enthrallmissing4/add_effects(message)
	description = "<span class='warning'>[message]</span>\n"

/datum/mood_event/InLove
   mood_change = 10

/datum/mood_event/InLove/add_effects(message)
    description = "<span class='nicegreen'>[message]</span>\n"

/datum/mood_event/MissingLove
   mood_change = -10

/datum/mood_event/MissingLove/add_effects(message)
    description = "<span class='warning'>[message]</span>\n"
