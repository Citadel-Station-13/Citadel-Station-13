datum
	reagents
		proc
			get_reagent_data(var/reagent)
				for(var/A in reagent_list)
					var/datum/reagent/R = A
					if (R.id == reagent)
						return R.data

				return 0














datum
	reagent
		semen
			data = list("adjective"=null, "type"=null, "digested"=null, "digested_DNA"=null, "digested_type"=null, "donor_DNA"=null)
			name = "Semen"
			id = "semen"
			description = "A clear-ish white-ish liquid produced by the... sexual parts of mammals."
			reagent_state = LIQUID
			color = "#DFDFDF" // rgb: 223, 223, 223

			on_mob_life(var/mob/living/M as mob)
				if(!M) M = holder.my_atom
				if(M.getBruteLoss() && prob(20)) M.heal_organ_damage(1,0)
				if(holder.has_reagent("capsaicin"))
					holder.remove_reagent("capsaicin", 2)
				M.nutrition++
				..()
				return

			reaction_turf(var/turf/simulated/T, var/volume)
				if(!istype(T)) return
				//var/datum/reagent/semen/self = src
				src = null
				if(!(volume >= 3)) return
				var/obj/effect/decal/cleanable/sex/sex_prop = locate() in T
				if(!sex_prop)
					sex_prop = new/obj/effect/decal/cleanable/sex/semen(T)

			on_merge(var/list/new_data)
				if(data&&new_data)
					for(var/I in new_data)
						if(data[I]==null)
							data[I]=new_data[I]

		femjuice
			data = list("adjective"=null, "type"=null, "digested"=null, "digested_DNA"=null, "digested_type"=null, "donor_DNA"=null)
			name = "Female Ejaculate"
			id = "femjuice"
			description = "It's really just urine."
			reagent_state = LIQUID
			color = "#AFAFAF"

			on_mob_life(var/mob/living/M as mob)
				if(!M) M = holder.my_atom
				if(M.getBruteLoss() && prob(20)) M.heal_organ_damage(1,0)
				if(holder.has_reagent("capsaicin"))
					holder.remove_reagent("capsaicin", 2)
				M.nutrition++
				..()
				return

			reaction_turf(var/turf/simulated/T, var/volume)
				if(!istype(T)) return
				//var/datum/reagent/femjuice/self = src
				src = null
				if(!(volume >= 3)) return
				var/obj/effect/decal/cleanable/sex/sex_prop = locate() in T
				if(!sex_prop)
					sex_prop = new/obj/effect/decal/cleanable/sex/femjuice(T)

			on_merge(var/list/new_data)
				if(data&&new_data)
					for(var/I in new_data)
						if(data[I]==null)
							data[I]=new_data[I]

		milk
			data = list("adjective"=null, "type"=null, "digested"=null, "digested_DNA"=null, "digested_type"=null, "donor_DNA"=null)
			reaction_turf(var/turf/simulated/T, var/volume)
				if(!istype(T)) return
				//var/datum/reagent/milk/self = src
				src = null
				if(!(volume >= 3)) return
				var/obj/effect/decal/cleanable/sex/sex_prop = locate() in T
				if(!sex_prop)
					sex_prop = new/obj/effect/decal/cleanable/sex/milk(T)

			on_merge(var/list/new_data)
				if(data&&new_data)
					for(var/I in new_data)
						if(data[I]==null)
							data[I]=new_data[I]

		shrinkchem
			name = "Shrink Chemical"
			id = "shrinkchem"
			description = "Shrinks people. Eaten by larger chemicals."
			reagent_state = LIQUID
			color = "#C8A5FF" // rgb: 200, 165, 220

			var/cnt_digested=0
			var/original_size=-1

			on_mob_life(var/mob/living/M as mob)
				if(original_size==-1)
					original_size=M.sizeplay_size
				if(M.stat == 2.0)
					return
				if(!M) M = holder.my_atom
				//if(volume%10==5)
				//	if(!holder.has_reagent("growchem"))
				//		M.sizeplay_shrink()
				//		M<<"You shrink."
				if(volume>=1)
					cnt_digested++
				if(cnt_digested==5&&volume>1)
					if(!holder.has_reagent("growchem"))
						M.sizeplay_shrink()
						M<<"You shrink."
				if(cnt_digested==20)
					cnt_digested=0
					original_size=M.sizeplay_size
				if(volume<=1&&volume>0&&original_size>M.sizeplay_size)
					M<<"You grow back a little."
					M.sizeplay_grow()
				holder.remove_reagent(src.id, 1)
				return

		growchem
			name = "Grow Chemical"
			id = "growchem"
			description = "Enlarges people. Eats smaller chemicals."
			reagent_state = LIQUID
			color = "#FFA5DC" // rgb: 200, 165, 220

			var/cnt_digested=0
			var/original_size=-1

			on_mob_life(var/mob/living/M as mob)
				if(original_size==-1)
					original_size=M.sizeplay_size
				if(M.stat == 2.0)
					return
				if(!M) M = holder.my_atom
				if(holder.has_reagent("shrinkchem"))
					holder.remove_reagent("shrinkchem",holder.get_reagent_amount("shrinkchem")-0.1)
				//if(volume%10==5)
				//	M.sizeplay_grow()
				//	M<<"You grow."
				if(volume>=1)
					cnt_digested++
				if(cnt_digested==5&&volume>1)
					M.sizeplay_grow()
					M<<"You grow."
				if(cnt_digested==20)
					cnt_digested=0
					original_size=M.sizeplay_size
				if(volume<=1&&volume>0&&original_size<M.sizeplay_size)
					M<<"You shrink back a little."
					M.sizeplay_shrink()
				holder.remove_reagent(src.id, 1)
				return

		cockchem
			name = "Wundbonite+"
			id = "cockchem"
			description = "Type C growth chemical."
			reagent_state = LIQUID
			color = "#FFDFDF"

			var/cnt_digested=0

			on_mob_life(var/mob/living/M as mob)
				if(M.stat == 2.0)
					return
				if(!M) M = holder.my_atom
				if(holder.has_reagent("decockchem"))
					holder.remove_reagent("decockchem",holder.get_reagent_amount("decockchem"))
				if(volume>=1)
					cnt_digested++
				if(istype(M,/mob/living/carbon)&&M.has_dna())
					var/mob/living/carbon/humz=M
					var/bonersize=humz.dna.cock["has"]
					if(cnt_digested==20&&bonersize==humz.dna.COCK_NONE)
						cnt_digested=0
						humz.dna.cock["has"]=humz.dna.COCK_NORMAL
						M<<"You grow a cock."
						M.set_cock_block()
						humz.updateappearance()
					if(cnt_digested==10&&bonersize==humz.dna.COCK_NORMAL)
						cnt_digested=0
						humz.dna.cock["has"]=humz.dna.COCK_HYPER
						M<<"Your cock is now huge."
						M.set_cock_block()
						humz.updateappearance()
					if(bonersize!=humz.dna.COCK_NORMAL&&bonersize!=humz.dna.COCK_NONE)
						cnt_digested=min(1,cnt_digested)
				else
					cnt_digested=min(1,cnt_digested)
				holder.remove_reagent(src.id, 1)
				return

		decockchem
			name = "Wundbonite-"
			id = "decockchem"
			description = "Type C shrink chemical."
			reagent_state = LIQUID
			color = "#DFDFFF"

			var/cnt_digested=0

			on_mob_life(var/mob/living/M as mob)
				if(M.stat == 2.0)
					return
				if(!M) M = holder.my_atom
				if(volume>=1)
					cnt_digested++
				if(istype(M,/mob/living/carbon)&&M.has_dna()&&!holder.has_reagent("cockchem"))
					var/mob/living/carbon/humz=M
					var/bonersize=humz.dna.cock["has"]
					if(cnt_digested==20&&bonersize==humz.dna.COCK_NORMAL)
						cnt_digested=0
						humz.dna.cock["has"]=humz.dna.COCK_NONE
						M<<"You no longer have a cock."
						M.set_cock_block()
						humz.updateappearance()
					if(cnt_digested==10&&bonersize==humz.dna.COCK_HYPER)
						cnt_digested=0
						humz.dna.cock["has"]=humz.dna.COCK_NORMAL
						M<<"Your cock shrinks."
						M.set_cock_block()
						humz.updateappearance()
					if(cnt_digested==10&&bonersize==humz.dna.COCK_DOUBLE)
						cnt_digested=0
						humz.dna.cock["has"]=humz.dna.COCK_NORMAL
						M<<"You no longer have two cocks."
						M.set_cock_block()
						humz.updateappearance()
					if(bonersize!=humz.dna.COCK_NORMAL&&bonersize!=humz.dna.COCK_HYPER&&bonersize!=humz.dna.COCK_DOUBLE)
						cnt_digested=min(1,cnt_digested)
				else
					cnt_digested=min(1,cnt_digested)
				holder.remove_reagent(src.id, 1)
				return

		vagchem
			name = "Fisbonite+"
			id = "vagchem"
			description = "Type V growth chemical."
			reagent_state = LIQUID
			color = "#FFDFDF"

			var/cnt_digested=0

			on_mob_life(var/mob/living/M as mob)
				if(M.stat == 2.0)
					return
				if(!M) M = holder.my_atom
				if(holder.has_reagent("devagchem"))
					holder.remove_reagent("devagchem",holder.get_reagent_amount("devagchem"))
				if(volume>=1)
					cnt_digested++
				if(istype(M,/mob/living/carbon)&&M.has_dna())
					var/mob/living/carbon/humz=M
					var/vaghas=humz.dna.vagina
					if(vaghas)
						cnt_digested=min(1,cnt_digested)
					else
						if(cnt_digested==20)
							cnt_digested=0
							humz.dna.vagina=1
							M<<"A slit forms between your legs. You have a vaigna, now."
							M.set_cock_block()
				else
					cnt_digested=min(1,cnt_digested)
				holder.remove_reagent(src.id, 1)
				return

		devagchem
			name = "Fisbonite-"
			id = "devagchem"
			description = "Type V shrink chemical."
			reagent_state = LIQUID
			color = "#DFDFFF"

			var/cnt_digested=0

			on_mob_life(var/mob/living/M as mob)
				if(M.stat == 2.0)
					return
				if(!M) M = holder.my_atom
				if(volume>=1)
					cnt_digested++
				if(istype(M,/mob/living/carbon)&&M.has_dna()&&!holder.has_reagent("vagchem"))
					var/mob/living/carbon/humz=M
					var/vaghas=humz.dna.vagina
					if(!vaghas)
						cnt_digested=min(1,cnt_digested)
					else
						if(cnt_digested==20)
							cnt_digested=0
							humz.dna.vagina=0
							M<<"You no longer have a vagina."
							M.set_cock_block()
				else
					cnt_digested=min(1,cnt_digested)
				holder.remove_reagent(src.id, 1)
				return

		boobchem
			name = "Lactoverbrinitemosidine+"
			id = "boobchem"
			description = "Type B growth chemical."
			reagent_state = LIQUID
			color = "#FFEEEE"

			var/cnt_digested=0

			on_mob_life(var/mob/living/M as mob)
				if(M.stat == 2.0)
					return
				if(!M) M = holder.my_atom
				if(holder.has_reagent("deboobchem"))
					holder.remove_reagent("deboobchem",holder.get_reagent_amount("deboobchem"))
				if(volume>=1)
					cnt_digested++
				if(istype(M,/mob/living/carbon)&&M.has_dna())
					//var/mob/living/carbon/humz=M
					var/boobhas=M.gender==FEMALE
					if(boobhas)
						cnt_digested=min(1,cnt_digested)
					else
						if(cnt_digested==20)
							cnt_digested=0
							M.gender=FEMALE
							if(M.has_dna())
								var/datum/dna/Mdna=M.has_dna()
								Mdna.uni_identity = setblock(Mdna.uni_identity, DNA_GENDER_BLOCK, construct_block((M.gender!=MALE)+1, 2))
							M<<"You now have boobs."
							//M.updateappearance()
				else
					cnt_digested=min(1,cnt_digested)
				holder.remove_reagent(src.id, 1)
				return

		deboobchem
			name = "Lactoverbrinitemosidine-"
			id = "deboobchem"
			description = "Type V shrink chemical."
			reagent_state = LIQUID
			color = "#EEEEFF"

			var/cnt_digested=0

			on_mob_life(var/mob/living/M as mob)
				if(M.stat == 2.0)
					return
				if(!M) M = holder.my_atom
				if(volume>=1)
					cnt_digested++
				if(istype(M,/mob/living/carbon)&&M.has_dna()&&!holder.has_reagent("boobchem"))
					//var/mob/living/carbon/humz=M
					var/boobhas=M.gender==FEMALE
					if(!boobhas)
						cnt_digested=min(1,cnt_digested)
					else
						if(cnt_digested==20)
							cnt_digested=0
							M.gender=MALE
							if(M.has_dna())
								var/datum/dna/Mdna=M.has_dna()
								Mdna.uni_identity = setblock(Mdna.uni_identity, DNA_GENDER_BLOCK, construct_block((M.gender!=MALE)+1, 2))
							M<<"You no longer have boobs."
							//M.updateappearance()
				else
					cnt_digested=min(1,cnt_digested)
				holder.remove_reagent(src.id, 1)
				return

		stomexchem
			name = "Bio-Expansion Chemical"
			id = "stomexchem"
			description = "Enlarges belly by reacting directly with the digestive acids. May react oddly to other bodily fluids."
			reagent_state = LIQUID
			color = "#C8FFDC" // rgb: 200, 255, 220

			var/cnt_digested=0

			on_mob_life(var/mob/living/M as mob)
				if(M.stat == 2.0)
					return
				if(!M) M = holder.my_atom
				if(volume>=1)
					cnt_digested++
				//if(volume%10==5)
				if(cnt_digested==10)
					cnt_digested=0
					if(M.vore_ability[num2text(VORE_METHOD_ORAL)]<VORE_SIZEDIFF_ANY)
						M.vore_ability[num2text(VORE_METHOD_ORAL)]+=1
						M<<"Your stomach feels funny."
				holder.remove_reagent(src.id, 1)
				return

		healnomchem
			name = "Haelnome"
			id="healnomchem"
			description = "An odd drug that reverses digestion."
			reagent_state = LIQUID
			color = "#BBEEFF"

			var/cnt_digested=0

			on_mob_life(var/mob/living/M as mob)
				if(M.stat == 2.0)
					return
				if(!M) M = holder.my_atom
				if(holder.has_reagent("hurtnomchem"))
					var/rmv_cnt=holder.remove_reagent("hurtnomchem", 1)
					holder.remove_reagent(src.id, rmv_cnt)
					return
				if(volume>=1)
					cnt_digested++
				//if(volume%10==5)
				if(cnt_digested==10)
					cnt_digested=0
					if(M.vore_stomach_datum.factor_offset>-1)
						M.vore_stomach_datum.factor_offset=max(M.vore_stomach_datum.factor_offset-1,-1)
						if(M.vore_stomach_datum.factor_offset<0)
							M<<"Your stomach feels backwards."
							for(var/datum/vore_organ/VD in M.vore_organ_list())
								if(!VD.exterior&&VD.digestion_factor>VORE_DIGESTION_SPEED_SLOW)	//I should add a "max_factor()" and "min_factor()", as well as "cap_factor()"
									VD.digestion_factor=VORE_DIGESTION_SPEED_SLOW				//But, that will have to wait until each organ has its own cap.
						else
							M<<"Your stomach feels calmer."
							for(var/datum/vore_organ/VD in M.vore_organ_list())
								if(!VD.exterior&&VD.digestion_factor>VORE_DIGESTION_SPEED_FAST)
									VD.digestion_factor=VORE_DIGESTION_SPEED_FAST
				holder.remove_reagent(src.id, 1)
				return

		hurtnomchem
			name = "Hahrname"
			id="hurtnomchem"
			description = "A highly voracious acid that only eats through things when it wants to."
			reagent_state = LIQUID
			color = "#FFEEBB"

			var/cnt_digested=0

			on_mob_life(var/mob/living/M as mob)
				if(M.stat == 2.0)
					return
				if(!M) M = holder.my_atom
				if(holder.has_reagent("healnomchem"))
					var/rmv_cnt=holder.remove_reagent("healnomchem", 1)
					holder.remove_reagent(src.id, rmv_cnt)
					return
				if(volume>=1)
					cnt_digested++
				//if(volume%10==5)
				if(cnt_digested==10)
					cnt_digested=0
					if(M.vore_stomach_datum.factor_offset<1)
						M.vore_stomach_datum.factor_offset=min(M.vore_stomach_datum.factor_offset+1,1)
						if(M.vore_stomach_datum.factor_offset>0)
							M<<"You feel a burning in your chest."
							for(var/datum/vore_organ/VD in M.vore_organ_list())
								if(!VD.exterior&&VD.healing_factor)
									VD.healing_factor=0
								if(!VD.exterior&&VD.digestion_factor<VORE_DIGESTION_SPEED_SLOW)
									VD.digestion_factor=VORE_DIGESTION_SPEED_SLOW
						else
							M<<"Your stomach feels correct."
							for(var/datum/vore_organ/VD in M.vore_organ_list())
								if(!VD.exterior&&VD.healing_factor)
									VD.healing_factor=0
				holder.remove_reagent(src.id, 1)
				return

		antacid
			name = "Antacid"
			id="antacid"
			description = "Quells your stomach."
			reagent_state = LIQUID
			color = "#FFDD99"

			var/cnt_digested=0

			on_mob_life(var/mob/living/M as mob)
				if(M.stat == DEAD)
					return
				if(!M) M = holder.my_atom

				if(holder.has_reagent("noantacid"))
					var/rmv_cnt=holder.remove_reagent("noantacid", 0.5)
					holder.remove_reagent(src.id, rmv_cnt)
					return

				if(volume>=1)
					cnt_digested++
				//if(volume%10==5)
				if(cnt_digested==10)
					cnt_digested=0
					var/dig_changed=0
					for(var/datum/vore_organ/VD in M.vore_organ_list())
						if(VD.healing_factor)
							VD.healing_factor=0
							dig_changed=1
						if(VD.digestion_factor_down())
							dig_changed=1
					if(dig_changed)
						M << "<span class='notice'>Your body calms down from antacid.</span>"
				holder.remove_reagent(src.id, 0.5)
				return

		noantacid
			name = "Anti-antacid"
			id="noantacid"
			description = "Burns your stomach."
			reagent_state = LIQUID
			color = "#FFDD99"

			var/cnt_digested=0

			on_mob_life(var/mob/living/M as mob)
				if(M.stat == DEAD)
					return
				if(!M) M = holder.my_atom

				if(holder.has_reagent("noantacid"))
					var/rmv_cnt=holder.remove_reagent("noantacid", 0.5)
					holder.remove_reagent(src.id, rmv_cnt)
					return

				if(volume>=1)
					cnt_digested++
				//if(volume%10==5)
				if(cnt_digested==10)
					cnt_digested=0
					var/dig_changed=0
					for(var/datum/vore_organ/VD in M.vore_organ_list())
						if(VD.healing_factor)
							VD.healing_factor=0
							dig_changed=1
						if(VD.digestion_factor_up())
							dig_changed=1
					if(dig_changed)
						M << "<span class='warning'>Your chest burns from anti-antacid!</span>"
				holder.remove_reagent(src.id, 0.5)
				return

		vorechem
			name = "Vorarium"
			id = "vorechem"
			description = "Can be used to do an assortment of things."
			color = "#FF55A0" //I dunno =D

		narkychem
			name = "Narkanian Honey"
			id = "narkychem"
			description = "This lets you see lots of colours."
			color = "#CCAAFF"
			data = list("active"=0,"count"=1,"adjective"=null,"type"=null,"digested"=null, "digested_DNA"=null, "digested_type"=null, "donor_DNA"=null)

			on_mob_life(var/mob/living/M as mob)
				if(!M) M = holder.my_atom
				if(data)
					M.druggy = max(M.druggy, 30)
					switch(data["count"])
						if(1 to 5)
							if(prob(5)) M.emote("giggle")
							else if(prob(10))
								if(prob(50))M.emote("dance")
								for(var/i in list(1,2,4,8,4,2,1,2,4,8,4,2))
									M.dir = i
									sleep(1)
						if(5 to 10)
							M.druggy = max(M.druggy, 35)
							if(prob(5)) M.emote("giggle")
							else if(prob(20))
								if(prob(30))M.emote("dance")
								for(var/i in list(1,2,4,8,4,2,1,2,4,8,4,2))
									M.dir = i
									sleep(1)
						if (10 to INFINITY)
							M.druggy = max(M.druggy, 40)
							if(prob(5)) M.emote("giggle")
							else if(prob(30))
								if(prob(20))M.emote("dance")
								for(var/i in list(1,2,4,8,4,2,1,2,4,8,4,2))
									M.dir = i
									sleep(1)
					data["count"]++
				holder.remove_reagent(src.id, 0.5)
				//..()
				return
			on_merge(var/list/new_data)
				if(data&&new_data)
					for(var/I in new_data)
						if(data[I]==null)
							data[I]=new_data[I]

		vomitchem
			name = "Emetic"
			id = "vomitchem"
			description = "Makes you vomit."
			color = "#FFDD99"
			data = list("count"=1)

			on_mob_life(var/mob/living/M as mob)
				if(!M) M = holder.my_atom
				if(data)
					switch(data["count"])
						if(6,8)
							M.emote("choke")
						if (10 to INFINITY)
							M.Stun(rand(1,2))
							M.visible_message("<span class='danger'>[M] throws up!</span>", \
														"<span class='userdanger'>[M] throws up!</span>")
							playsound(M.loc, 'sound/effects/splat.ogg', 50, 1)
							var/turf/location = M.loc
							if(istype(location, /turf/simulated))
								location.add_vomit_floor(M)
							M.nutrition -= 50
							M.adjustToxLoss(-1)
							if(M.vore_stomach_datum.contents.len)
								M.vore_stomach_datum.release(M.vore_stomach_datum.FLAVOUR_SILENT)
							if(M.vore_tail_datum.contents.len)
								M.vore_tail_datum.release(M.vore_tail_datum.FLAVOUR_HURL)
							if(M.vore_breast_datum.contents.len) //ADD THIS TO LACTATE LATER
								M.vore_breast_datum.release(M.vore_breast_datum.FLAVOUR_SILENT)
							data["count"]=0
							holder.remove_any(holder.total_volume)

					if(!holder.has_reagent("novomitchem"))
						data["count"]++
				holder.remove_reagent(src.id, 0.5)
				//..()
				return

		novomitchem
			name = "Antiemetic"
			id = "novomitchem"
			description = "Makes you not vomit."
			color = "#FFDD99"
			data = list("count"=1)

			on_mob_life(var/mob/living/M as mob)
				if(!M) M = holder.my_atom
				holder.remove_reagent(src.id, 0.5)
				//..()
				return

		hornychem
			name = "Aphrodisiac"
			id = "hornychem"
			description = "You so horny."
			color = "#FF9999"
			data = list("count"=1)

			on_mob_life(var/mob/living/M as mob)
				if(!M) M = holder.my_atom
				if(data)
					switch(data["count"])
						if(1 to 30)
							if(prob(9)) M.emote("blush")
						if (30 to INFINITY)
							if(prob(3)) M.emote("blush")
							if(prob(5)) M.emote("moan")
							if(prob(3))
								if(M.vore_cock_datum.check_exist()&&M.vore_womb_datum.check_exist())
									if(prob(50)) M.vore_cock_datum.release(M.vore_cock_datum.FLAVOUR_HURL) 	//I forgot how to make this less stupid.
									else M.vore_womb_datum.release(M.vore_womb_datum.FLAVOUR_HURL)			//I knew it before, I swear!
								else if(M.vore_cock_datum.check_exist())
									M.vore_cock_datum.release(M.vore_cock_datum.FLAVOUR_HURL)
								else if(M.vore_womb_datum.check_exist())
									M.vore_womb_datum.release(M.vore_womb_datum.FLAVOUR_HURL)
					data["count"]++
				holder.remove_reagent(src.id, 0.5)
				//..()
				return

/datum/reagent/sodiumbicarbonate
	name = "Sodium Bicarbonate"
	id = "sodiumbicarbonate"
	description = "A salt made of sodium bicarbonate."
	reagent_state = SOLID
	color = "#FFFFFF" // rgb: 255,255,255








/datum/chemical_reaction/sodiumbicarbonate
	name = "Sodiumbicarbonate"
	id = "sodiumbicarbonate"
	result = "sodiumbicarbonate"
	required_reagents = list("sodiumchloride" = 1, "ammonia" = 1, "carbon" = 1, "oxygen" = 2)
	result_amount = 5



/datum/chemical_reaction/antacid
	name = "antacid"
	id = "antacid"
	result = "antacid"
	required_reagents = list("sodiumbicarbonate" = 1, "vorechem" = 1)
	result_amount = 2
/datum/chemical_reaction/noantacid
	name = "Noantacid"
	id = "noantacid"
	result = "noantacid"
	required_reagents = list("sodiumchloride" = 1, "vorechem" = 1)
	result_amount = 2

/datum/chemical_reaction/growchem
	name = "Growchem"
	id = "growchem"
	result = "growchem"
	required_reagents = list("hydrogen" = 1, "vorechem" = 1)
	result_amount = 2
/datum/chemical_reaction/shrinkchem
	name = "Shrinkchem"
	id = "shrinkchem"
	result = "shrinkchem"
	required_reagents = list("sodium" = 1, "vorechem" = 1)
	result_amount = 2

/datum/chemical_reaction/stomexchem
	name = "Stomexchem"
	id = "stomexchem"
	result = "stomexchem"
	required_reagents = list("radium" = 1, "vorechem" = 1)
	result_amount = 2

/datum/chemical_reaction/vomitchem
	name = "Vomitchem"
	id = "vomitchem"
	result = "vomitchem"
	required_reagents = list("chlorine" = 1, "vorechem" = 1)
	result_amount = 2

/datum/chemical_reaction/novomitchem
	name = "Novomitchem"
	id = "novomitchem"
	result = "novomitchem"
	required_reagents = list("nitrogen" = 1, "vorechem" = 1)
	result_amount = 2

/datum/chemical_reaction/hornychem
	name = "Hornychem"
	id = "hornychem"
	result = "hornychem"
	required_reagents = list("lithium" = 1, "vorechem" = 1)
	result_amount = 2

/datum/chemical_reaction/healnomchem
	name = "HealNomchem"
	id = "healnomchem"
	result = "healnomchem"
	required_reagents = list("omnizine" = 2, "vorechem" = 1)
	result_amount = 1

/datum/chemical_reaction/hurtnomchem
	name = "HurtNomchem"
	id = "hurtnomchem"
	result = "hurtnomchem"
	required_reagents = list("facid" = 1, "vorechem" = 1)
	result_amount = 2


/datum/chemical_reaction/cockchem
	name = "Cockchem"
	id = "cockchem"
	result = "cockchem"
	required_reagents = list("growchem" = 2, "semen" = 3, "vorechem" = 1)
	result_amount = 6
/datum/chemical_reaction/decockchem
	name = "Decockchem"
	id = "decockchem"
	result = "decockchem"
	required_reagents = list("shrinkchem" = 2, "semen" = 3, "vorechem" = 1)
	result_amount = 6

/datum/chemical_reaction/vagchem
	name = "Vagchem"
	id = "vagchem"
	result = "vagchem"
	required_reagents = list("growchem" = 2, "femjuice" = 3, "vorechem" = 1)
	result_amount = 6
/datum/chemical_reaction/devagchem
	name = "Devagchem"
	id = "devagchem"
	result = "devagchem"
	required_reagents = list("shrinkchem" = 2, "femjuice" = 3, "vorechem" = 1)
	result_amount = 6

/datum/chemical_reaction/boobchem
	name = "Boobchem"
	id = "boobchem"
	result = "boobchem"
	required_reagents = list("growchem" = 2, "milk" = 3, "vorechem" = 1)
	result_amount = 6
/datum/chemical_reaction/deboobchem
	name = "Deboobchem"
	id = "deboobchem"
	result = "deboobchem"
	required_reagents = list("shrinkchem" = 2, "milk" = 3, "vorechem" = 1)
	result_amount = 6

/obj/item/weapon/reagent_containers/pill/shrink
	name = "shrink pill"
	desc = "Used to shrink people."
	icon_state = "pill18"
	New()
		..()
		reagents.add_reagent("shrinkchem", 10)

/obj/item/weapon/reagent_containers/pill/grow
	name = "grow pill"
	desc = "Used to make people larger."
	icon_state = "pill19"
	New()
		..()
		reagents.add_reagent("growchem", 10)

/obj/item/weapon/reagent_containers/pill/stomex
	name = "stomEx pill"
	desc = "Used to make the subject more able in the field of vore."
	icon_state = "pill9"
	New()
		..()
		reagents.add_reagent("stomexchem", 10)

/datum/chemical_reaction/narkychem
	name = "Narkychem"
	id = "narkychem"
	result = "narkychem"
	required_reagents = list("vorechem" = 1, "spacemountainwind" = 1, "femjuice" = 2)
	//required_catalysts = list("femjuice" = 2)
	result_amount=4

/datum/chemical_reaction/narkychem/on_reaction(var/datum/reagents/holder, var/created_volume, var/data_send)

	//var/datum/reagent/femjuice/F = locate(/datum/reagent/femjuice) in holder.reagent_list
	var/list/F=null
	if(data_send)
		F=data_send["femjuice"]
	var/datum/reagent/narkychem/A = locate(/datum/reagent/narkychem) in holder.reagent_list
	if(F)
		A.on_merge(F)
		/*if(F["digested"]!=null)
			if(F["digested"]=="Narky Sawtooth")
				if(A&&A.data)
					A.data["active"]|=2
		if(F["donor_DNA"]!=null)
			var/datum/dna/check_DNA=F["donor_DNA"]
			if(check_DNA.mutantrace&&check_DNA.mutantrace=="narky")
				if(A&&A.data)
					A.data["active"]|=1*/
	//holder.remove_reagent("femjuice",created_volume)

/obj/item/weapon/storage/box/pillbottles/vore
	name = "box of vore pill bottles"
	desc = "It has pictures of pill bottles on its front."
	icon_state = "pillbox"
	New()
		..()
		for(var/obj/item/weapon/storage/pill_bottle/PB in src)
			qdel(PB)
		new /obj/item/weapon/storage/pill_bottle/shrinkpills( src )
		new /obj/item/weapon/storage/pill_bottle/shrinkpills( src )
		new /obj/item/weapon/storage/pill_bottle/shrinkpills( src )
		new /obj/item/weapon/storage/pill_bottle/growpills( src )
		new /obj/item/weapon/storage/pill_bottle/growpills( src )
		new /obj/item/weapon/storage/pill_bottle/growpills( src )
		new /obj/item/weapon/storage/pill_bottle/stomexpills( src )

/obj/item/weapon/storage/pill_bottle/shrinkpills
	name = "bottle of shrink pills"
	desc = "Contains pills used to shirnk people."

	New()
		..()
		new /obj/item/weapon/reagent_containers/pill/shrink( src )
		new /obj/item/weapon/reagent_containers/pill/shrink( src )
		new /obj/item/weapon/reagent_containers/pill/shrink( src )
		new /obj/item/weapon/reagent_containers/pill/shrink( src )
		new /obj/item/weapon/reagent_containers/pill/shrink( src )
		new /obj/item/weapon/reagent_containers/pill/shrink( src )
		new /obj/item/weapon/reagent_containers/pill/shrink( src )

/obj/item/weapon/storage/pill_bottle/growpills
	name = "bottle of grow pills"
	desc = "Contains pills used to enlarge people."

	New()
		..()
		new /obj/item/weapon/reagent_containers/pill/grow( src )
		new /obj/item/weapon/reagent_containers/pill/grow( src )
		new /obj/item/weapon/reagent_containers/pill/grow( src )
		new /obj/item/weapon/reagent_containers/pill/grow( src )
		new /obj/item/weapon/reagent_containers/pill/grow( src )
		new /obj/item/weapon/reagent_containers/pill/grow( src )
		new /obj/item/weapon/reagent_containers/pill/grow( src )

/obj/item/weapon/storage/pill_bottle/stomexpills
	name = "bottle of stomEx pills"
	desc = "Contains pills used to increase vore ability."

	New()
		..()
		new /obj/item/weapon/reagent_containers/pill/stomex( src )
		new /obj/item/weapon/reagent_containers/pill/stomex( src )
		new /obj/item/weapon/reagent_containers/pill/stomex( src )
		new /obj/item/weapon/reagent_containers/pill/stomex( src )








/*/obj/item/weapon/reagent_containers/food/snacks/narkypudding
	name = "Narky Pudding"
	desc = "So prettiful."
	icon_state = "spacylibertyduff"
	trash = /obj/item/trash/snack_bowl
	New()
		..()
		reagents.add_reagent("nutriment", 12)
		reagents.add_reagent("narkychem", 12)
		bitesize = 3

/datum/recipe/narkypudding
	reagents = list("vorechem" = 5, "semen" = 10)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/faggot,
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/narkypudding
	make_food(var/obj/container as obj)
		var/obj/item/weapon/reagent_containers/food/snacks/narkypudding/being_cooked = ..(container)
		var/datum/reagent/R=container.reagents.has_reagent("semen")
		var/datum/reagent/A=being_cooked.reagents.has_reagent("narkychem")
		if(!R&&A)A.data["active"]|=1 //TEMP FIX
		if(R&&R.data&&R.data["digested"]!=null)
			if(R.data["digested"]=="Narky Sawtooth")
				if(A&&A.data)
					A.data["active"]|=2
				being_cooked.name=being_cooked.name+" (With Real Narky)"
				//being_cooked.reagents.add_reagent("narkychem",12)
		if(R&&R.data&&R.data["donor_DNA"]!=null)
			var/datum/dna/check_DNA=R.data["donor_DNA"]
			if(check_DNA.mutantrace()&&check_DNA.mutantrace()=="narky")
				if(A&&A.data)
					A.data["active"]|=1
				being_cooked.name="Special "+being_cooked.name
				//being_cooked.reagents.add_reagent("narkychem",12)
		return being_cooked*/




/obj/item/weapon/reagent_containers/food/snacks/poor_toast
	name = "poorly-drawn toast"
	desc = "Filled with porrly-speld nutryents!"
	icon_state = "poor_toast"
	New()
		..()
		reagents.add_reagent("nutriment", 10)
		bitesize = 5

/obj/item/weapon/reagent_containers/food/snacks/poor_toast/burn
	name = "poorly-drawn burnt toast"
	desc = "No amount of scraping will remove the porlly-spelt burtn part! Do not feed this to Ian."
	icon_state = "poor_toast_burn"
	New()
		..()
		if(prob(20))
			reagents.remove_reagent("nutriment", 8)
			reagents.add_reagent("vomitchem", 8)

/datum/recipe/poor_toast_burn
	//reagents = list()
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/poor_toast
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/poor_toast/burn
