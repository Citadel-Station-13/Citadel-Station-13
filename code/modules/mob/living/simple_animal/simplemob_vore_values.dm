//CARBON MOBS
/mob/living/carbon/alien
	devourable = TRUE
	digestable = TRUE
	feeding = TRUE

/mob/living/carbon/monkey
	devourable = TRUE
	digestable = TRUE
	feeding = TRUE


/*
	REFER TO code/modules/mob/living/simple_animal/simple_animal_vr.dm for Var information!
*/


//NUETRAL MOBS
/mob/living/simple_animal/crab
	devourable = TRUE
	digestable = TRUE
	feeding = TRUE

/mob/living/simple_animal/cow
	devourable = TRUE
	digestable = TRUE
	feeding = TRUE
	vore_active = TRUE
	isPredator = TRUE
	vore_default_mode = DM_HOLD

/mob/living/simple_animal/chick
	devourable = TRUE
	digestable = TRUE

/mob/living/simple_animal/chicken
	devourable = TRUE
	digestable = TRUE

/mob/living/simple_animal/mouse
	devourable = TRUE
	digestable = TRUE

/mob/living/simple_animal/kiwi
	devourable = TRUE
	digestable = TRUE

//STATION PETS
/mob/living/simple_animal/pet
	devourable = TRUE
	digestable = TRUE
	feeding = TRUE

/mob/living/simple_animal/pet/fox
	vore_active = TRUE
	isPredator = TRUE
	vore_default_mode = DM_HOLD

/mob/living/simple_animal/pet/cat
	vore_active = TRUE
	isPredator = TRUE
	vore_default_mode = DM_HOLD

/mob/living/simple_animal/pet/dog
	vore_active = TRUE
	isPredator = TRUE
	vore_default_mode = DM_HOLD

/mob/living/simple_animal/sloth
	devourable = TRUE
	digestable = TRUE

/mob/living/simple_animal/parrot
	devourable = TRUE
	digestable = TRUE

//HOSTILE MOBS
/mob/living/simple_animal/hostile/retaliate/goat
	devourable = TRUE
	digestable = TRUE
	feeding = TRUE
	vore_active = TRUE
	isPredator = TRUE
	vore_stomach_flavor = "You find yourself squeezed into the hollow of the goat, the smell of oats and hay thick in the tight space, all of which grinds in on you. Harmless for now..."
	vore_default_mode = DM_HOLD

/mob/living/simple_animal/hostile/lizard
	devourable = TRUE
	digestable = TRUE
	feeding = TRUE
	vore_active = TRUE
	isPredator = TRUE
	vore_default_mode = DM_DIGEST

/mob/living/simple_animal/hostile/alien
	feeding = TRUE
	vore_active = TRUE
	isPredator = TRUE
	vore_default_mode = DM_DIGEST

/mob/living/simple_animal/hostile/bear
	feeding = TRUE
	vore_active = TRUE
	isPredator = TRUE
	vore_default_mode = DM_DIGEST

/mob/living/simple_animal/hostile/poison/giant_spider
	feeding = TRUE
	vore_active = TRUE
	isPredator = TRUE
	vore_default_mode = DM_DIGEST

/mob/living/simple_animal/hostile/retaliate/poison/snake
	feeding = TRUE
	vore_active = TRUE
	isPredator = TRUE
	vore_default_mode = DM_DIGEST

/mob/living/simple_animal/hostile/gorilla
	feeding = TRUE
	vore_active = TRUE
	isPredator = TRUE
	vore_default_mode = DM_DIGEST

/mob/living/simple_animal/hostile/asteroid/goliath
	feeding = TRUE //for pet Goliaths I guess or something.
	vore_active = TRUE
	isPredator = TRUE
	vore_default_mode = DM_DIGEST

/mob/living/simple_animal/hostile/carp
	devourable = TRUE
	digestable = TRUE
	feeding = TRUE
	vore_active = TRUE
	isPredator = TRUE
	vore_default_mode = DM_DIGEST
