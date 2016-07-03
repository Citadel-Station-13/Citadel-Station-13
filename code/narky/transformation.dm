/datum/vore_transform_datum
	var/tf_path
	var/tf_species
	var/tf_gender=NEUTER
	var/tf_egg=0
	proc/apply_transform(var/mob/living/targ)
		var/old_name=targ.real_name
		var/new_gender=tf_gender==NEUTER ? targ.gender : tf_gender
		var/transformation_happened=new_gender==targ.gender ? 0 : 1
		var/new_path= tf_egg ? /mob/living/egg : tf_path
		var/datum/dna/tmp_dna=targ.has_dna()
		if(tmp_dna)
			targ.last_working_dna=tmp_dna

		if(tf_egg&&!tf_path)tf_path=targ.type

		if(new_path&&!istype(targ,new_path))//Transform path?
			targ.vore_contents_drop(targ.get_last_organ_in())
			var/mob/living/new_mob = new new_path(targ.loc)
			if(istype(new_mob))
				new_mob.a_intent = "harm"
				//new_mob.universal_speak = 1
				new_mob.languages |= HUMAN
				new_mob.vore_banned_methods=targ.vore_banned_methods
				new_mob.vore_ability=targ.vore_ability
				if(targ.mind)
					targ.mind.transfer_to(new_mob)
				else
					new_mob.key = targ.key
				if(targ.last_working_dna)
					new_mob.last_working_dna=targ.last_working_dna
				if(targ.get_last_organ_in())
					targ.last_organ_in.add(new_mob)
					new_mob.vore_transform_index=-200
				qdel(targ)
				targ=new_mob
				transformation_happened=1

		if(istype(targ,/mob/living/carbon)) //handle species and/or dna
			var/mob/living/carbon/C=targ
			C.has_dna()
			if(C.last_working_dna&&C.dna)
				C.dna=C.last_working_dna
			if(tf_species)
				C.real_name=old_name
				C.vore_dna_mod(tf_species)
				if(transformation_happened)
					C.dna.cock=list("has"=C.gender==MALE,"type"="human","color"="900")//TEMP FIX!
					C.dna.vagina=C.gender==FEMALE
				transformation_happened=1

		if(istype(targ,/mob/living/egg)) //handle egg
			var/mob/living/egg/E=targ
			src.tf_egg=0
			E.hatch_tf=src
			if(!E.get_last_organ_in())
				E.incubate()

		targ.gender=new_gender
		targ.real_name=old_name
		targ.name=old_name

		if(transformation_happened&&targ.get_last_organ_in())
			targ.vore_transform_index=-200
			//targ.last_organ_in.owner<<"You feel a stir. An occupant has changed."
			targ.last_organ_in.flavour_text(targ.last_organ_in.FLAVOUR_TRANSFORM)








/mob/living/proc/vore_dna_mod(var/new_dna)
	if(!has_dna(src))return
	if(!new_dna)return
	var/mob/living/carbon/C=src
	if(istype(new_dna,/datum/dna))
		var/old_name=C.real_name
		var/datum/dna/change_dna=new_dna
		C.dna.struc_enzymes=change_dna.struc_enzymes
		//C.dna.unique_enzymes=change_dna.unique_enzymes
		C.dna.uni_identity=change_dna.uni_identity
		C.set_mutantrace(change_dna.species.id)
		C.dna.mutanttail=change_dna.mutanttail
		C.dna.mutantwing=change_dna.mutantwing
		C.dna.special_color=change_dna.special_color
		C.dna.special_color=change_dna.special_color
		C.updateappearance()
		C.real_name=old_name
		C.name=old_name
	else
		//C.dna.mutantrace=new_dna
		C.set_mutantrace(new_dna)





/*
/mob/living/proc/vore_transform(var/transformpath=null, var/transform_species=null, var/transform_gender=NEUTER, var/datum/vore_organ/new_cont=null)
	var/old_name=src.real_name
	var/datum/dna/tmp_dna=check_dna_integrity(src)
	if(tmp_dna)
		last_working_dna=tmp_dna
	if(!transformpath)transformpath=src.type
	if(src.type==transformpath)
		if(istype(src,/mob/living/carbon))
			var/mob/living/carbon/humz=src
			var/race = humz.dna ? humz.dna.mutantrace : null
			if((transform_species&&race==transform_species)&&(gender==transform_gender||transform_gender==NEUTER))
				return 0
			else
				if(humz.dna)
					humz.vore_dna_mod(transform_species)
				if(transform_gender!=NEUTER)
					humz.gender=transform_gender
				if(istype(humz,/mob/living/carbon/human))
					var/mob/living/carbon/human/H=humz
					H.update_body()
				if(new_cont)
					humz.vore_transform_index=-200
					new_cont.owner<<"Your belly stirs. A transformation is complete."
				return 1
		else
			if(transform_gender!=NEUTER&&gender!=transform_gender)
				gender=transform_gender
				if(new_cont)
					vore_transform_index=-200
					new_cont.owner<<"Your belly stirs. A transformation is complete."
				return 1
			return 0
	src.vore_contents_drop(new_cont)
	var/mob/living/new_mob = new transformpath(src.loc)
	if(istype(new_mob))
		check_dna_integrity(new_mob)
		new_mob.a_intent = "harm"
		new_mob.universal_speak = 1
		//new_mob.universal_understand = 1
		if(src.mind)
			src.mind.transfer_to(new_mob)
		if(last_working_dna)
			new_mob.last_working_dna=last_working_dna
		else
			new_mob.key = src
		if(new_cont)
			new_cont.contents.Add(new_mob)
			new_cont.owner.stomach_contents.Add(new_mob)
			new_mob.vore_transform_index=-200
			new_cont.owner<<"Your belly stirs. A transformation is complete."
		if(istype(new_mob,/mob/living/carbon))
			var/mob/living/carbon/humz=new_mob
			humz.dna=humz.last_working_dna
			if(transform_species)
				humz.vore_dna_mod(transform_species)
			if(transform_gender!=NEUTER)
				new_mob.gender=transform_gender
			if(istype(humz,/mob/living/carbon/human))
				var/mob/living/carbon/human/H=humz
				H.update_body()
		if(transform_gender!=NEUTER)
			new_mob.gender=transform_gender
		new_mob.real_name=old_name
		new_mob.name=old_name
	qdel(src)
	return 1
*/











/mob/living/egg
	name = "egg"
	icon = 'icons/mob/animal.dmi'
	icon_state = "egg"
	health = 50
	//max_health = 50

	status_flags = CANPUSH

	//universal_speak = 1
	languages = HUMAN

	canmove = 0

	var/datum/vore_transform_datum/hatch_tf = null
	var/hatch_prog = 0
	var/targ_hatch = 80
	var/incubating=0

	proc/incubate()
		incubating=1

	update_canmove()
		canmove=0
		return canmove

	New()
		..()
		icon_state="egg[rand(0,2)]"

	Life()
		vore_transform_index=-200
		if(incubating)
			if(get_last_organ_in())
				hatch_prog+=2
			else
				hatch_prog+=1
			if(hatch_prog>=targ_hatch&&hatch_tf)
				src.visible_message("<span class='notice'>[src]'s egg hatches!</span>")
				hatch_tf.apply_transform(src)

	attack_hand(mob/living/carbon/human/M as mob)
		..()

		switch(M.a_intent)

			if("help")
				if (health > 0)
					for(var/mob/O in viewers(src, null))
						if ((O.client && !( O.eye_blind )))
							O.show_message("\blue [M] hugs [src]'s egg.")

			if("grab")
				if (M == src || anchored)
					return
				if (!(status_flags & CANPUSH))
					return

				var/obj/item/weapon/grab/G = new /obj/item/weapon/grab(M, src )

				M.put_in_active_hand(G)

				G.synch()

				LAssailant = M

				for(var/mob/O in viewers(src, null))
					if ((O.client && !( O.eye_blind )))
						O.show_message(text("\red [] has grabbed [] passively!", M, src), 1)

			if("harm", "disarm")
				for(var/mob/O in viewers(src, null))
					if ((O.client && !( O.eye_blind )))
						O.show_message("\red [M] taps [src]'s eggshell!")

		return