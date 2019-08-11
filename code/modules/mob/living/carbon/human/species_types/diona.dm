/datum/species/dionae
	name = "Dionae"
	id = "diona"
	blacklisted = FALSE
	sexes = FALSE
	say_mod = "rustles"
	default_color = "228822"


	inherent_biotypes = list(MOB_ORGANIC, MOB_HUMANOID)
	mutant_bodyparts = list("diona_body_markings")
	default_features = list("diona_body_markings" = "Default")

	mutanttongue = /obj/item/organ/tongue/diona

	meat = /obj/item/reagent_containers/food/snacks/meat/slab/human/mutant/lizard
	skinned_type = /obj/item/stack/sheet/animalhide/lizard

	liked_food = SUGAR | RAW | MEAT
	disliked_food = TOXIC | JUNKFOOD

	exotic_blood = "radium" //R A D I O A C T I V E T R E E. WHAT COULD POSSIBLY GO WRONG? MAYBE CHLORINE AND PHOSPHORUS.

	no_equip = list(SLOT_GLOVES, SLOT_SHOES) //HOW THE FUCK ARE YOU SUPPOSED TO FIT ANYTHING OVER THOSE GIANT, ASS-GROPING TREE-TRUNK HANDS AND FEET?

	//GIMMICK RACE PART 1: IT BEGINS.
	speedmod = 8 //SUPER SLOW BECAUSE THEY'RE A TREE.
	armor = 5 //FUCK IT, LETS JUST GIVE THEM SOME BASIC BITCH BARK ARMOR.

	burnmod = 2 //THEY'RE A FUCKING TREE THAT BURNS.
	coldmod = 0.5 //PLANTS CAN RESIST COLD
	heatmod = 0.5 //SEE ABOVE
	stunmod = 2 //TIMBERRRRRRRRRRRRRRRRRRR

	punchdamagelow = 4 //HIT LIKE A GOSH DARN CLOTH GOLEM
	punchdamagehigh = 8 //THATS RIGHT. A FUCKING CLOTH GOLEM
	punchstunthreshold = 8 //BUT FUCK IT. 25% CHANCE TO STUN.

	siemens_coeff = 0.50 //TREES CAN RESIST SHOCK... RIGHT?

	//GIMMICK RACE PART 2: ELECTRIC BOOGALOO
	species_traits = list(MUTCOLORS,NOEYES,NOZOMBIE,DRINKSBLOOD) //A TREE THAT DRINKS BLOOD.

	inherent_traits = list(
		TRAIT_NOGUNS, TRAIT_CLUMSY, //THEY'RE SO FUCKING LARGE THEIR HANDS ARE FAT AND CLUMSY AS SHIT
		TRAIT_NOBREATH, TRAIT_RADIMMUNE, //THEY'RE A GOD DAMN TREE RADIOACTIVE TREE THAT DOESN'T NEED OXYGEN.
		TRAIT_EASYDISMEMBER, TRAIT_NOCLONE //REMINDER: TREE. CUT IT DOWN AND REALISE "OH FUCK I CAN'T CLONE THEM."
	)
