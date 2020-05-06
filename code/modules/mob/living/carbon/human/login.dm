/mob/living/carbon/human/Login()
	..()
	if(dna?.species?.has_field_of_vision && CONFIG_GET(flag/use_field_of_vision))
		LoadComponent(/datum/component/vision_cone, field_of_vision_type)
