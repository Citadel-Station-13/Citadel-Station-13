/obj/item/organ/heart/gland
	name = "fleshy mass"
	desc = "A nausea-inducing hunk of twisting flesh and metal."
	icon = 'icons/obj/abductor.dmi'
	icon_state = "gland"
	status = ORGAN_ROBOTIC
	origin_tech = "materials=4;biotech=7;abductor=3"
	beating = TRUE
	var/cooldown_low = 300
	var/cooldown_high = 300
	var/next_activation = 0
	var/uses // -1 For inifinite
	var/human_only = 0
	var/active = 0

/obj/item/organ/heart/gland/proc/ownerCheck()
	if(ishuman(owner))
		return 1
	if(!human_only && iscarbon(owner))
		return 1
	return 0

/obj/item/organ/heart/gland/proc/Start()
	active = 1
	next_activation = world.time + rand(cooldown_low,cooldown_high)


/obj/item/organ/heart/gland/Remove(var/mob/living/carbon/M, special = 0)
	active = 0
	if(initial(uses) == 1)
		uses = initial(uses)
	..()

/obj/item/organ/heart/gland/Insert(var/mob/living/carbon/M, special = 0)
	..()
	if(special != 2 && uses) // Special 2 means abductor surgery
		Start()

/obj/item/organ/heart/gland/on_life()
	if(!beating)
		// alien glands are immune to stopping.
		beating = TRUE
	if(!active)
		return
	if(!ownerCheck())
		active = 0
		return
	if(next_activation <= world.time)
		activate()
		uses--
		next_activation  = world.time + rand(cooldown_low,cooldown_high)
	if(!uses)
		active = 0

/obj/item/organ/heart/gland/proc/activate()
	return

/obj/item/organ/heart/gland/heals
	cooldown_low = 200
	cooldown_high = 400
	uses = -1
	icon_state = "health"

/obj/item/organ/heart/gland/heals/activate()
	to_chat(owner, "<span class='notice'>You feel curiously revitalized.</span>")
	owner.adjustBruteLoss(-20)
	owner.adjustOxyLoss(-20)
	owner.adjustFireLoss(-20)

/obj/item/organ/heart/gland/slime
	cooldown_low = 600
	cooldown_high = 1200
	uses = -1
	icon_state = "slime"

/obj/item/organ/heart/gland/slime/activate()
	to_chat(owner, "<span class='warning'>You feel nauseous!</span>")
	owner.vomit(20)

	var/mob/living/simple_animal/slime/Slime
	Slime = new(get_turf(owner), "grey")
	Slime.Friends = list(owner)
	Slime.Leader = owner

/obj/item/organ/heart/gland/mindshock
	origin_tech = "materials=4;biotech=4;magnets=6;abductor=3"
	cooldown_low = 300
	cooldown_high = 300
	uses = -1
	icon_state = "mindshock"

/obj/item/organ/heart/gland/mindshock/activate()
	to_chat(owner, "<span class='notice'>You get a headache.</span>")

	var/turf/T = get_turf(owner)
	for(var/mob/living/carbon/H in orange(4,T))
		if(H == owner)
			continue
		to_chat(H, "<span class='alien'>You hear a buzz in your head.</span>")
		H.confused += 20

/obj/item/organ/heart/gland/pop
	cooldown_low = 900
	cooldown_high = 1800
	uses = -1
	human_only = 1
	icon_state = "species"

/obj/item/organ/heart/gland/pop/activate()
	to_chat(owner, "<span class='notice'>You feel unlike yourself.</span>")
	var/species = pick(list(/datum/species/lizard, /datum/species/jelly/slime, /datum/species/pod, /datum/species/fly, /datum/species/jelly))
	owner.set_species(species)

/obj/item/organ/heart/gland/ventcrawling
	origin_tech = "materials=4;biotech=5;bluespace=4;abductor=3"
	cooldown_low = 1800
	cooldown_high = 2400
	uses = 1
	icon_state = "vent"

/obj/item/organ/heart/gland/ventcrawling/activate()
	to_chat(owner, "<span class='notice'>You feel very stretchy.</span>")
	owner.ventcrawler = VENTCRAWLER_ALWAYS


/obj/item/organ/heart/gland/viral
	cooldown_low = 1800
	cooldown_high = 2400
	uses = 1
	icon_state = "viral"

/obj/item/organ/heart/gland/viral/activate()
	to_chat(owner, "<span class='warning'>You feel sick.</span>")
	var/virus_type = pick(/datum/disease/beesease, /datum/disease/brainrot, /datum/disease/magnitis)
	var/datum/disease/D = new virus_type()
	D.carrier = TRUE
	owner.viruses += D
	D.affected_mob = owner
	owner.med_hud_set_status()


/obj/item/organ/heart/gland/emp //TODO : Replace with something more interesting
	origin_tech = "materials=4;biotech=4;magnets=6;abductor=3"
	cooldown_low = 900
	cooldown_high = 1600
	uses = 10
	icon_state = "emp"

/obj/item/organ/heart/gland/emp/activate()
	to_chat(owner, "<span class='warning'>You feel a spike of pain in your head.</span>")
	empulse(get_turf(owner), 2, 5, 1)

/obj/item/organ/heart/gland/spiderman
	cooldown_low = 450
	cooldown_high = 900
	uses = 10
	icon_state = "spider"

/obj/item/organ/heart/gland/spiderman/activate()
	to_chat(owner, "<span class='warning'>You feel something crawling in your skin.</span>")
	owner.faction |= "spiders"
	new /obj/structure/spider/spiderling(owner.loc)

/obj/item/organ/heart/gland/egg
	cooldown_low = 300
	cooldown_high = 400
	uses = -1
	icon_state = "egg"
	lefthand_file = 'icons/mob/inhands/misc/food_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/food_righthand.dmi'

/obj/item/organ/heart/gland/egg/activate()
	to_chat(owner, "<span class='boldannounce'>You lay an egg!</span>")
	var/obj/item/reagent_containers/food/snacks/egg/egg = new(owner.loc)
	egg.reagents.add_reagent("sacid",20)
	egg.desc += " It smells bad."

/obj/item/organ/heart/gland/bloody
	cooldown_low = 200
	cooldown_high = 400
	uses = -1

/obj/item/organ/heart/gland/bloody/activate()
	owner.blood_volume -= 20
	owner.visible_message("<span class='danger'>[owner]'s skin erupts with blood!</span>",\
	"<span class='userdanger'>Blood pours from your skin!</span>")

	for(var/turf/T in oview(3,owner)) //Make this respect walls and such
		owner.add_splatter_floor(T)
	for(var/mob/living/carbon/human/H in oview(3,owner)) //Blood decals for simple animals would be neat. aka Carp with blood on it.
		H.add_mob_blood(owner)


/obj/item/organ/heart/gland/bodysnatch
	cooldown_low = 600
	cooldown_high = 600
	human_only = 1
	uses = 1

/obj/item/organ/heart/gland/bodysnatch/activate()
	to_chat(owner, "<span class='warning'>You feel something moving around inside you...</span>")
	//spawn cocoon with clone greytide snpc inside
	if(ishuman(owner))
		var/obj/structure/spider/cocoon/abductor/C = new (get_turf(owner))
		C.Copy(owner)
		C.Start()
	owner.adjustBruteLoss(40)
	owner.add_splatter_floor()

/obj/structure/spider/cocoon/abductor
	name = "slimy cocoon"
	desc = "Something is moving inside."
	icon = 'icons/effects/effects.dmi'
	icon_state = "cocoon_large3"
	color = rgb(10,120,10)
	density = TRUE
	var/hatch_time = 0

/obj/structure/spider/cocoon/abductor/proc/Copy(mob/living/carbon/human/H)
	var/mob/living/carbon/human/interactive/greytide/clone = new(src)
	clone.hardset_dna(H.dna.uni_identity,H.dna.struc_enzymes,H.real_name, H.dna.blood_type, H.dna.species, H.dna.features)

/obj/structure/spider/cocoon/abductor/proc/Start()
	hatch_time = world.time + 600
	START_PROCESSING(SSobj, src)

/obj/structure/spider/cocoon/abductor/process()
	if(world.time > hatch_time)
		STOP_PROCESSING(SSobj, src)
		for(var/mob/M in contents)
			src.visible_message("<span class='warning'>[src] hatches!</span>")
			M.loc = src.loc
		qdel(src)


/obj/item/organ/heart/gland/plasma
	cooldown_low = 1200
	cooldown_high = 1800
	origin_tech = "materials=4;biotech=4;plasmatech=6;abductor=3"
	uses = -1

/obj/item/organ/heart/gland/plasma/activate()
	to_chat(owner, "<span class='warning'>You feel bloated.</span>")
	sleep(150)
	if(!owner)
		return
	to_chat(owner, "<span class='userdanger'>A massive stomachache overcomes you.</span>")
	sleep(50)
	if(!owner)
		return
	owner.visible_message("<span class='danger'>[owner] vomits a cloud of plasma!</span>")
	var/turf/open/T = get_turf(owner)
	if(istype(T))
		T.atmos_spawn_air("plasma=50;TEMP=[T20C]")
	owner.vomit()
