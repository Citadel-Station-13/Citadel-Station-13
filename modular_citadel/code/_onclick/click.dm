/mob/living/carbon/changeNext_move(num)
	next_move = world.time + (((num+next_move_adjust)*next_move_modifier)*((staminaloss*0.01)+1))
