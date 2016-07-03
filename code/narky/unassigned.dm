//TO DO:
// Vore plushies
// Vore bots
// Animal HUDs
// BATMAN --mostly done
// Vore transfers
// On that note, rewrite code so objects transfer right.
// Remains --mostly done
// Log vore in attacks
// A little button for error reports
// FIX THE THING ABOUT GETTING VORED WHILE BUCKLED - probs fixed fo' nao.
// Allow for completion of vore objective while they're in people in you.
//koshidumb
//koshidumb


//Constants
var/const/VORE_METHOD_FAIL=0
var/const/VORE_METHOD_ORAL=1
var/const/VORE_METHOD_ANAL=2
var/const/VORE_METHOD_COCK=4
var/const/VORE_METHOD_UNBIRTH=8
var/const/VORE_METHOD_BREAST=16
var/const/VORE_METHOD_TAIL=32
var/const/VORE_METHOD_INSOLE=64
var/const/VORE_METHOD_ABSORB=128
var/const/VORE_METHOD_INSUIT=256

var/const/VORE_EXTRA_FULLTOUR=1
var/const/VORE_EXTRA_REMAINS=2

var/const/VORE_REMAINS_NONE=0
var/const/VORE_REMAINS_GENERIC=1
var/const/VORE_REMAINS_NAMED=2
var/const/VORE_REMAINS_MAX=2 //If ever we need more.

var/const/VORE_MODE_EAT=1
var/const/VORE_MODE_FEED=2

//var/const/PC_SIZE_MICRO=2
//var/const/PC_SIZE_NORMAL=4
//var/const/PC_SIZE_MACRO=8

var/const/VORE_DIGESTION_SPEED_NONE=0
var/const/VORE_DIGESTION_SPEED_SLOW=1
var/const/VORE_DIGESTION_SPEED_FAST=2
var/const/VORE_DIGESTION_SPEED_ABNORMAL=4
var/const/VORE_TRANSFORM_SPEED_NONE=0
var/const/VORE_TRANSFORM_SPEED_SLOW=2
var/const/VORE_TRANSFORM_SPEED_FAST=4
var/const/VORE_TRANSFER_SPEED_NONE=0
var/const/VORE_TRANSFER_SPEED_SLOW=6
var/const/VORE_TRANSFER_SPEED_FAST=9

var/const/VORE_SIZEDIFF_DISABLED=0
var/const/VORE_SIZEDIFF_TINY=1
var/const/VORE_SIZEDIFF_SMALLER=2
var/const/VORE_SIZEDIFF_SAMESIZE=3
var/const/VORE_SIZEDIFF_DOUBLE=4
var/const/VORE_SIZEDIFF_ANY=5

//Extra vars
/mob/living
	var/vore_transform_index=0
	var/vore_transfer_index=0
	var/vore_mode=VORE_MODE_EAT
	var/vore_head_first=1
	var/vore_current_method=VORE_METHOD_ORAL
	var/vore_banned_methods=0
	var/vore_extra_bans=0
	var/vore_last_relay=0
	var/test_var_to_remove=0
	var/vore_remains_mode=VORE_REMAINS_NONE

	//var/vore_size_difference=VORE_SIZEDIFF_DOUBLE
	/*var/list/vore_ability=list(
	VORE_METHOD_ORAL=VORE_SIZEDIFF_SMALLER,
	VORE_METHOD_ANAL=VORE_SIZEDIFF_DISABLED,
	VORE_METHOD_COCK=VORE_SIZEDIFF_DISABLED,
	VORE_METHOD_UNBIRTH=VORE_SIZEDIFF_DISABLED,
	VORE_METHOD_BREAST=VORE_SIZEDIFF_DISABLED,
	VORE_METHOD_TAIL=VORE_SIZEDIFF_DISABLED,
	VORE_METHOD_INSOLE=VORE_SIZEDIFF_TINY,
	VORE_METHOD_ABSORB=VORE_SIZEDIFF_DISABLED)*/

	var/list/vore_ability=list( // This list is the initial list of what size differences people can vore at.
	"1"=2, // Oral starts at one-size smaller.
	"2"=0, // Anal starts disabled.
	"4"=0, // Cock starts disabled.
	"8"=0, // Unbirth starts disabled.
	"16"=0, // Breast starts disabled.
	"32"=0, // Tail starts disabled.
	"64"=1, // Insole is 2 size differences.
	"128"=0, // Absorption... isn't a thing.
	"256"=2) // Insuit is 1 size difference. Previous comment = BAAAAD way to do this.

	var/vore_datums_initialized=0
	var/datum/vore_organ/stomach/vore_stomach_datum=new()
	var/datum/vore_organ/cock/vore_cock_datum=new()
	var/datum/vore_organ/balls/vore_balls_datum=new()
	var/datum/vore_organ/womb/vore_womb_datum=new()
	var/datum/vore_organ/breast/vore_breast_datum=new()
	var/datum/vore_organ/insole/vore_insole_datum=new()
	var/datum/vore_organ/insuit/vore_insuit_datum=new()
	var/datum/vore_organ/tail/vore_tail_datum=new()

	var/datum/vore_organ/last_organ_in
	var/datum/dna/last_working_dna

/mob/living/carbon/human
	var/underwear_active=1

/datum/mind
	var/list/digested_by=new()
	var/list/people_digested=new()


//Datums
/datum/vore_organ
	var/mob/living/owner
	var/list/contents=new/list()
	var/list/remains=new/list()
	var/remembered_bans=0
	var/digestion_factor=0
	var/healing_factor=0
	var/factor_offset=0
	var/oxygen=1
	var/escape=1
	var/integrity=100
	var/digestion_count=0
	var/last_release=0
	var/exterior=0
	var/tf_path=null
	var/tf_species=null
	var/tf_gender=NEUTER
	var/tf_egg=0
	var/tf_factor=VORE_TRANSFORM_SPEED_NONE
	var/milk_type=null
	var/list/milk_list=new()
	var/assoc_loc="chest"
	var/assoc_fluid="none"
	var/datum/vore_organ/transfer_target=null
	var/transfer_factor=VORE_TRANSFER_SPEED_NONE
	var/global/const/FLAVOUR_SILENT=0
	var/global/const/FLAVOUR_DIGEST=1
	var/global/const/FLAVOUR_RELEASE=2
	var/global/const/FLAVOUR_HURL=3
	var/global/const/FLAVOUR_ESCAPE=4
	var/global/const/FLAVOUR_TRANSFORM=5
	var/global/const/FLAVOUR_TRANSFER=6
	proc/digest()
		if(!owner)return 0
		for(var/mob/living/carbon/M in contents)
			if(!owner.stomach_contents.Find(M))
				contents.Remove(M)
				//continue //bad in most languages
				return digest()
		if(!check_exist())
			transfer_to_other(owner.vore_stomach_datum)
			return 0
		if(owner.stat==2)return 0
		//contents.Remove(null)
		if(digestion_factor>VORE_DIGESTION_SPEED_SLOW) //Originally a temp fix. Might as well keep it.
			oxygen=0
		else
			oxygen=1+healing_factor
		if(SSair.times_fired%3==1)
			integrity=min(integrity+8,100)
		for(var/mob/living/M in contents)
			/*if(!owner.stomach_contents.Find(M))
				contents.Remove(M)
				continue //bad in most languages
			*/
			if(istype(M, /mob/living))
				if(M.stat == 2 && (M.getFireLoss()>=100||!istype(M,/mob/living/carbon/human)) && digestion_factor)
					vore_admins("[owner.real_name] has digested [M.real_name] in [type].",owner,M)
					if(M.mind&&owner.mind)
						M.mind.digested_by.Add(owner.mind)
						owner.mind.people_digested.Add(M.mind)
					remembered_bans|=M.vore_extra_bans
					/*var/list/remains_to_add[VORE_REMAINS_MAX]
					remains_to_add[VORE_REMAINS_GENERIC]=kpcode_get_generic(M)
					remains_to_add[VORE_REMAINS_NAMED]=M.real_name
					remains+=list("M.real_name[remains.len+1]"=remains_to_add)*/
					var/remains_idx=remains.len+1
					remains["[remains_idx]"]=new/list()
					remains["[remains_idx]"]["[VORE_REMAINS_GENERIC]"]=kpcode_get_generic(M)
					remains["[remains_idx]"]["[VORE_REMAINS_NAMED]"]=M.real_name
					if(milk_type)
						if(!milk_list[M.real_name])
							milk_list[M.real_name]=new/list()
						milk_list[M.real_name]["count"]=milk_list[M.real_name]["count"]+20
						var/digested_DNA=null
						if(istype(M,/mob/living/carbon))
							if(M:dna)
								digested_DNA=M:dna
						var/data = list("adjective"=null, "type"=null, "digested"=M.real_name, "digested_DNA"=digested_DNA, "digested_type"=kpcode_get_generic(M), "donor_DNA"=null)
						milk_list[M.real_name]["data"]=data
					flavour_text(FLAVOUR_DIGEST,M)
					M.ghostize()
					M.vore_contents_drop(src)
					M.death(1)
					owner.stomach_contents.Remove(M)
					contents.Remove(M)
					qdel(M)
					owner.nutrition+=400
					digestion_count+=1
					//owner.updateappearance
					owner.update_body()
					continue //hopefully won't break much
				if(oxygen)
					M.oxyloss=0//Temp fix
				if(SSair.times_fired%3==1)
					M.vore_transform_index+=tf_factor
					if(M.vore_transform_index>=100)
						M.vore_transform(tf_path,tf_species,tf_gender,tf_egg)
						continue
					M.vore_transfer_index+=transfer_factor
					if(M.vore_transfer_index>=100)
						flavour_text(FLAVOUR_TRANSFER,M)
						//contents.Remove(M)
						//transfer_target.add(M)
						//M.vore_transform_index=0
						//M.vore_transfer_index=0
						transfer_to_other(transfer_target,M)
						continue
					if(!(M.status_flags & GODMODE))
						if(digestion_factor&&M.getFireLoss()<200)
							M.adjustFireLoss(digestion_factor)
							if(owner.nutrition<600&&(owner.nutrition<400||istype(src,/datum/vore_organ/stomach)))
								owner.nutrition += digestion_factor
						if(healing_factor&&owner.nutrition>100)

							if(M.getOxyLoss() )//&& prob(60))
								M.adjustOxyLoss(-2)
								//if(prob(50))owner.nutrition-=1
							if(M.getBruteLoss() )//&& prob(60))
								M.heal_organ_damage(1,0)
								owner.nutrition-=1
							if(M.getFireLoss() )//&& prob(60))
								M.heal_organ_damage(0,1)
								owner.nutrition-=1
							if(M.getToxLoss() )//&& prob(60))
								M.adjustToxLoss(-1)
								owner.nutrition-=1

						if(oxygen)
							M.adjustOxyLoss(-1)//*oxygen)
		return 1
	proc/release(var/style=FLAVOUR_RELEASE,var/mob/living/prey=null,var/extra_info=0)
		if(owner.stat!=DEAD&&owner.reagents&&owner.reagents.has_reagent("novomitchem"))return
		if(style==FLAVOUR_RELEASE&&(last_release>SSair.times_fired-20||owner.stat==2))return
		last_release=SSair.times_fired
		flavour_text(style,prey,extra_info)
		if(prey)
			//message_admins("[owner.real_name] has released [prey.real_name] from [type]. Code [style].",owner,prey)
			place_in_next(prey)
			//updateappearance(owner)
			return 1
		//BEGIN REMAINS
		if(remains.len&&owner.vore_remains_mode&&!(remembered_bans&VORE_EXTRA_REMAINS))
			var/already_messy=0
			for(var/obj/effect/decal/cleanable/remains/vore/alreadybones in owner.loc)
				already_messy=1
				break
			if(!already_messy)
				var/list/who_is_bones=new/list()
				for(var/L in remains)
					var/name_to_bone=remains[L]["[owner.vore_remains_mode]"]
					if(name_to_bone&&!who_is_bones.Find(name_to_bone))
						who_is_bones.Add(name_to_bone)
				//Make bones
				var/obj/bones=new/obj/effect/decal/cleanable/remains/vore()
				bones.loc=owner.loc
				//Pile 'em up
				if(remains.len>1)
					bones.icon_state+="1"
				//Now, name the remains
				bones.name="remains of "
				var/counter=1
				for(var/final_name in who_is_bones)
					if(counter>1&&counter==who_is_bones.len)
						if(counter==2)
							bones.name+=" "
						bones.name+="and "
					bones.name+="[final_name]"
					if(who_is_bones.len>2&&counter!=who_is_bones.len)
						bones.name+=", "
					counter++
				if(bones.name=="remains of ")
					bones.name="remains of (KNOWN BUG DO NOT REPORT)"
		remains=new/list()
		//END REMAINS
		milk_list=new()
		digestion_count=0
		remembered_bans=0
		if(!contents.len)return 0
		/*for(var/obj/relea in contents) //somehow failed to release prey's gear.
			place_in_next(relea)
		for(var/mob/living/relea in contents)
			//message_admins("[owner.real_name] has released [relea.real_name] from [type]. Code [style].",owner,relea)
			place_in_next(relea)*/
		if(owner.stomach_contents.len)
			for(var/atom/movable/A in owner.stomach_contents)
				owner.stomach_contents.Remove(A)
				A.loc = owner.loc
				if(istype(A, /obj/item/weapon/reagent_containers/food/snacks))
					qdel(A)
		//owner.updateappearance()
		owner.update_body()
		return 1

	proc/add(var/mob/living/addit)
		var/mob/living/M
		if(istype(addit,/mob/living))
			M=addit
		if(M)
			vore_admins("[owner.real_name]'s [type] has added [M.real_name].[digestion_factor ? " Digestion at [digestion_factor]." : ""][tf_factor ? " Transformation is on." : ""][healing_factor ? " Healing is on." : ""]",owner,M)
		addit.loc = owner
		owner.stomach_contents.Add(addit)
		contents.Add(addit)
		if(M)
			M.last_organ_in=src
		//updateappearance(owner)
		owner.update_body()
	proc/flavour_text(var/source, var/mob/living/prey, var/extra_info=0)
		if(extra_info==VORE_EXTRA_FULLTOUR&&(remembered_bans&VORE_EXTRA_FULLTOUR))
			extra_info=0
		if(extra_info==VORE_EXTRA_FULLTOUR)
			var/list/ins_lst=recursive_mob_check(src,0,0,0)
			for(var/mob/living/check_em in ins_lst)
				if(check_em.vore_extra_bans&extra_info)
					extra_info=0
					break
		if(source==FLAVOUR_DIGEST)
			owner.visible_message("<span class='danger'>You hear loud gurgling from within [owner]'s stomach causing the lump to dissipate. Someone must have digested.</span>")
			prey<<"<span class='warning'>You gurgle away inside [owner]'s stomach. What you were is now just fat on the body. The process of digestion continues without any imput from you anymore.</span>"
		else if(source==FLAVOUR_RELEASE)
			var/live_people=0
			for(var/mob/living/M in contents)
				live_people=1
				break
			if(digestion_count&&!live_people)
				if(extra_info==VORE_EXTRA_FULLTOUR)
					owner.visible_message("<span class='notice'>[owner] squats down and releases the remains of those inside them.</span>")
					//I'd add something akin those barf additions here too but I'm p sure you wanna keep it clean lmao
				else
					owner.visible_message("<span class='notice'>[owner] hacks and coughs, spewing forth the remains of those inside them.</span>")
					playsound(owner.loc, 'sound/effects/splat.ogg', 50, 1)
					owner.loc.add_vomit_floor(src, 1)
			if(digestion_count&&live_people)
				if(extra_info==VORE_EXTRA_FULLTOUR)
					owner.visible_message("<span class='notice'>[owner] squats down and releases those still inside them.</span>")
				else
					owner.visible_message("<span class='notice'>[owner] hacks and coughs, spewing forth those that had still remained inside.</span>")
					playsound(owner.loc, 'sound/effects/splat.ogg', 50, 1)
					owner.loc.add_vomit_floor(src, 1)
			if(!digestion_count&&live_people)
				if(extra_info==VORE_EXTRA_FULLTOUR)
					owner.visible_message("<span class='notice'>[owner] squats down and releases those inside them.</span>")
				else
					owner.visible_message("<span class='notice'>[owner] hacks and coughs, spewing forth those inside.</span>")
		else if(source==FLAVOUR_HURL)
			var/live_people=0
			for(var/mob/living/M in contents)
				live_people=1
				break
			if(digestion_count&&!live_people)
				owner.visible_message("<span class='notice'>[owner] half-keels and gags, spewing forth the remains of those inside them.</span>")
				playsound(owner.loc, 'sound/effects/splat.ogg', 50, 1)
				owner.loc.add_vomit_floor(src, 1)
			if(digestion_count&&live_people)
				owner.visible_message("<span class='notice'>[owner] half-keels and gags, spewing forth those that had still remained inside.</span>")
				playsound(owner.loc, 'sound/effects/splat.ogg', 50, 1)
				owner.loc.add_vomit_floor(src, 1)
			if(!digestion_count&&live_people)
				owner.visible_message("<span class='notice'>[owner] half-keels and gags, spewing forth those inside.</span>")
		else if(source==FLAVOUR_ESCAPE&&prey)
			owner.visible_message("<span class='notice'>[prey] crawls out of [owner]'s mouth.</span>")
		else if(source==FLAVOUR_TRANSFORM)
			owner<<"Your belly stirs. A transformation is complete."
		else if(source==FLAVOUR_TRANSFER)
			owner.visible_message("<span class='notice'>A thousand rainbow eyes stare at [owner]. Seems like Narky found a bug. What the hell did [owner] do?</span>")



	proc/relaymove(var/mob/user, var/direction)
		var/mob/living/prey
		if(istype(user,/mob/living))
			prey=user
		else
			return
		if(prey.vore_last_relay>SSair.times_fired-2)return
		prey.vore_last_relay=SSair.times_fired
		if(prey.a_intent=="help"&&!exterior)
			owner.visible_message("<span class='notice'>Something shifts around within [owner].</span>")
		else
			if(exterior||escape||owner.stat==2)
				release(FLAVOUR_ESCAPE,prey)
			else
				integrity-=15
				owner.visible_message("<span class='warning'>Something slams against the inside of [owner].</span>")
				if(prob(40)) owner.Stun(rand(1,2))
				playsound(prey.get_top_level_mob(), 'sound/effects/attackblob.ogg', 50, 1)
				if(integrity<=0)
					release(FLAVOUR_HURL,prey)
					integrity=0
					owner.Stun(rand(2,4))

		/*if(prob(40))
			for(var/mob/M in hearers(4, src))
				if(M.client)
					M.show_message(text("\red You hear something rumbling inside [src]'s stomach..."), 2)
			var/obj/item/I = user.get_active_hand()
			if(I && I.force)
				var/d = rand(round(I.force / 4), I.force)
				if(istype(src, /mob/living/carbon/human))
					var/mob/living/carbon/human/H = src
					var/organ = H.get_organ("chest")
					if (istype(organ, /obj/item/organ/limb))
						var/obj/item/organ/limb/temp = organ
						if(temp.take_damage(d, 0))
							H.update_damage_overlays(0)
					H.updatehealth()
				else
					src.take_organ_damage(d)
				for(var/mob/M in viewers(user, null))
					if(M.client)
						M.show_message(text("\red <B>[user] attacks [src]'s stomach wall with the [I.name]!"), 2)
				playsound(user.loc, 'sound/effects/attackblob.ogg', 50, 1)

				if(prob(src.getBruteLoss() - 50))
					for(var/atom/movable/A in stomach_contents)
						A.loc = loc
						stomach_contents.Remove(A)
					src.gib()*/

	proc/has_people()
		var/pcount=0
		for(var/mob/living/M in contents)
			if(!owner.stomach_contents.Find(M))
				contents.Remove(M)
			else
				pcount++
		return pcount

	proc/transfer_to_other(var/datum/vore_organ/targ, var/mob/living/prey=null)
		if(prey)
			if(targ.owner!=owner)
				owner.stomach_contents.Remove(prey)
			organ_leave(prey)
			targ.add(prey) //Maybe make add check for other organs, and remove them from stomach_contents there?
		else
			for(var/mob/living/M in contents)
				if(M)
					transfer_to_other(targ,M)

	proc/place_in_next(var/atom/movable/prey)
		if(istype(prey,/mob/living/egg))
			var/mob/living/egg/E=prey
			E.incubate()
		owner.stomach_contents.Remove(prey)
		organ_leave(prey)
		prey.loc=owner.loc
		if(owner.get_last_organ_in())
			var/datum/vore_organ/VO=owner.get_last_organ_in()
			VO.add(prey)
		if(istype(prey,/mob))
			var/mob/M=prey
			M.cancel_camera()

	proc/organ_leave(var/atom/movable/prey)
		contents.Remove(prey)
		if(istype(prey,/mob/living))
			var/mob/living/mprey=prey
			mprey.vore_transform_index=0
			mprey.vore_transfer_index=0
		//updateappearance(owner)
		owner.update_body()

/*	proc/refresh_list()
		for(var/mob/living/M in contents)
			if(!owner.stomach_contents.Find(M))
				contents.Remove(M)
				//continue //bad in most languages
				return refresh_list() //this is better
*/
	proc/check_exist()
		return 1

	proc/digestion_factor_up()
		switch(digestion_factor)
			if(VORE_DIGESTION_SPEED_NONE)
				digestion_factor=VORE_DIGESTION_SPEED_SLOW
				return 1
			if(VORE_DIGESTION_SPEED_SLOW)
				digestion_factor=VORE_DIGESTION_SPEED_FAST
				return 1
			if(VORE_DIGESTION_SPEED_FAST)
				if(factor_offset>0)
					digestion_factor=VORE_DIGESTION_SPEED_ABNORMAL
					return 1
		return 0

	proc/digestion_factor_down()
		switch(digestion_factor)
			if(VORE_DIGESTION_SPEED_SLOW)
				if(factor_offset<1)
					digestion_factor=VORE_DIGESTION_SPEED_NONE
					return 1
			if(VORE_DIGESTION_SPEED_FAST)
				digestion_factor=VORE_DIGESTION_SPEED_SLOW
				return 1
			if(VORE_DIGESTION_SPEED_ABNORMAL)
				digestion_factor=VORE_DIGESTION_SPEED_FAST
				return 1
		return 0

/datum/vore_organ/stomach
	oxygen=1

/datum/vore_organ/cock
	milk_type="semen"
	assoc_loc="groin"
	assoc_fluid="semen"
	flavour_text(var/source, var/mob/living/prey, var/extra_info=0)
		if(source==FLAVOUR_DIGEST)
			owner.visible_message("<span class='danger'>You hear loud gurgling from between [owner]'s thighs. Someone must have digested inside their manhood.</span>")
			prey<<"<span class='warning'>You turn into [owner] [pick("spooge","cum","semen","batter","seed")].</span>"
		else if(source==FLAVOUR_RELEASE)
			digestion_count+=owner.vore_balls_datum.digestion_count
			remembered_bans|=owner.vore_balls_datum.remembered_bans
			remains += owner.vore_balls_datum.remains
			owner.vore_balls_datum.remains=new/list()
			owner.vore_balls_datum.digestion_count=0
			if(istype(owner.loc,/turf))
				var/already_messy=0
				for(var/obj/effect/decal/cleanable/sex/S in owner.loc)
					already_messy=1
					break
				if(!already_messy)
					var/obj/S=new/obj/effect/decal/cleanable/sex/semen()
					S.loc=owner.loc
			var/live_people=0
			for(var/mob/living/M in contents)
				live_people=1
				break
			for(var/mob/living/M in owner.vore_balls_datum.contents)
				live_people=1
				break
			if(digestion_count&&!live_people)
				owner.visible_message("<span class='notice'>[owner] jacks off, releasing a massive load of cum that was once people.</span>")
			else if(digestion_count&&live_people)
				owner.visible_message("<span class='notice'>[owner] jacks off, releasing people covered in a massive torrent of what used to be people.</span>")
			else if(!digestion_count&&live_people)
				owner.visible_message("<span class='notice'>[owner] jacks off, releasing the cum-soaked occupants of their cock.</span>")
			else
				owner.visible_message("<span class='notice'>[owner] jacks off, spraying a load of cum.</span>")
			owner.vore_balls_datum.release(FLAVOUR_SILENT,prey)
		else if(source==FLAVOUR_HURL)
			digestion_count+=owner.vore_balls_datum.digestion_count
			remembered_bans|=owner.vore_balls_datum.remembered_bans
			remains += owner.vore_balls_datum.remains
			owner.vore_balls_datum.remains=new/list()
			owner.vore_balls_datum.digestion_count=0
			if(istype(owner.loc,/turf))
				var/already_messy=0
				for(var/obj/effect/decal/cleanable/sex/S in owner.loc)
					already_messy=1
					break
				if(!already_messy)
					var/obj/S=new/obj/effect/decal/cleanable/sex/semen()
					S.loc=owner.loc
			var/live_people=0
			for(var/mob/living/M in contents)
				live_people=1
				break
			for(var/mob/living/M in owner.vore_balls_datum.contents)
				live_people=1
				break
			if(digestion_count&&!live_people)
				owner.visible_message("<span class='notice'>[owner] suddenly orgasms, releasing a massive load of cum that was once people.</span>")
			else if(digestion_count&&live_people)
				owner.visible_message("<span class='notice'>[owner] suddenly orgasms, releasing people covered in a massive torrent of what used to be people.</span>")
			else if(!digestion_count&&live_people)
				owner.visible_message("<span class='notice'>[owner] suddenly orgasms, releasing the cum-soaked occupants of their cock.</span>")
			else
				owner.visible_message("<span class='notice'>[owner] suddenly orgasms, spraying a load of cum.</span>")
			owner.vore_balls_datum.release(FLAVOUR_SILENT,prey)
		else if(source==FLAVOUR_ESCAPE&&prey)
			owner.visible_message("<span class='notice'>[prey] slips out of [owner]'s cock, the smell is quite interesting.</span>")
		else if(source==FLAVOUR_TRANSFORM)
			owner<<"Your cock twitches. A transformation is complete."
		else if(source==FLAVOUR_TRANSFER)
			owner << "<span class='notice'>Someone moves into your balls.Their weight settling admist the cum-filled orbs</span>"
			prey<<"<span class='notice'>You move into [owner]'s balls, squeezed out of their cock and into the musky pool of seed. You're now rocking between each other step of .</span>"
		else ..()
	check_exist()
		if(owner.has_cock())
			return 1
		return 0

/datum/vore_organ/balls
	milk_type="semen"
	assoc_loc="groin"
	assoc_fluid="semen"
	release(var/style=FLAVOUR_RELEASE,var/prey=null)
		if(style==FLAVOUR_HURL)
			owner.vore_cock_datum.release(style,prey)
		else
			return ..()
	flavour_text(var/source, var/mob/living/prey, var/extra_info=0)
		if(source==FLAVOUR_DIGEST)
			owner.visible_message("<span class='danger'>You hear loud gurgling from within [owner]'s balls. Someone must have digested.</span>")
			prey<<"<span class='warning'>You turn into [owner]'s [pick("spooge","cum","semen","seed")]. The lumps you made smoothing out as the sac contracts around your melted mass. </span>"
		else if(source==FLAVOUR_ESCAPE&&prey)
			owner.visible_message("<span class='notice'>[prey] slips out of [owner]'s cock. The smell is interesting. </span>")
		else if(source==FLAVOUR_TRANSFORM)
			owner<<"Your balls stir. A transformation is complete."
		else ..()
	check_exist()
		if(owner.has_cock())
			return 1
		return 0

/datum/vore_organ/womb
	milk_type="femjuice"
	assoc_fluid="femjuice"
	flavour_text(var/source, var/mob/living/prey, var/extra_info=0)
		if(source==FLAVOUR_DIGEST)
			owner.visible_message("<span class='danger'>You hear loud gurgling from within [owner]'s belly and a lump rounds and slowly flattens. Someone must have melted away inside [owner]'s womb.</span>")
			prey<<"<span class='warning'>You gurgle and slosh away inside [owner]'s womb. Your essence fills them out with just that bit more detail and satisfaction. The lump you made is rounded out and slowly shrinking. </span>"
		else if(source==FLAVOUR_RELEASE)
			if(istype(owner.loc,/turf))
				var/already_messy=0
				for(var/obj/effect/decal/cleanable/sex/S in owner.loc)
					already_messy=1
					break
				if(!already_messy)
					var/obj/S=new/obj/effect/decal/cleanable/sex/femjuice()
					S.loc=owner.loc
			var/live_people=0
			for(var/mob/living/M in contents)
				live_people=1
				break
			if(digestion_count&&!live_people)
				owner.visible_message("<span class='notice'>[owner] masturbates their vagina, releasing a torrent of femjuice of former prey.</span>")
			else if(live_people)
				owner.visible_message("<span class='notice'>[owner] masturbates their vagina, releasing its musk-drenched occupants..</span>")
			else
				owner.visible_message("<span class='notice'>[owner] masturbates their vagina, dripping a small amount of femjuice.</span>")
		else if(source==FLAVOUR_HURL)
			if(istype(owner.loc,/turf))
				var/already_messy=0
				for(var/obj/effect/decal/cleanable/sex/S in owner.loc)
					already_messy=1
					break
				if(!already_messy)
					var/obj/S=new/obj/effect/decal/cleanable/sex/femjuice()
					S.loc=owner.loc
			var/live_people=0
			for(var/mob/living/M in contents)
				live_people=1
				break
			if(digestion_count&&!live_people)
				owner.visible_message("<span class='notice'>[owner] suddenly orgasms, releasing a torrent of femjuice.</span>")
			else if(live_people)
				owner.visible_message("<span class='notice'>[owner] suddenly orgasms, releasing their vagina's femjuice-drenched occupants..</span>")
			else
				owner.visible_message("<span class='notice'>[owner] suddenly orgasms, dripping a small amount of femjuice.</span>")
		else if(source==FLAVOUR_ESCAPE&&prey)
			owner.visible_message("<span class='notice'>[prey] slips out of [owner]'s vagina, the smell is... interesting.</span>")
		else ..()
	check_exist()
		return owner.has_vagina() ? 1 : 0

/datum/vore_organ/breast
	milk_type="milk"
	assoc_fluid="milk"
	flavour_text(var/source, var/mob/living/prey, var/extra_info=0)
		if(source==FLAVOUR_DIGEST)
			owner.visible_message("<span class='danger'>[owner]'s breasts jiggle. Someone must have turned into milk.The lumps they've made slosh and sink into a larger cupsize</span>")
			prey<<"<span class='warning'>You turn into [owner]'s milk, the bulges of your body simply adding to their cup size in a smooth swell.</span>"
		else if(source==FLAVOUR_RELEASE)
			if(istype(owner.loc,/turf))
				var/already_messy=0
				for(var/obj/effect/decal/cleanable/sex/S in owner.loc)
					already_messy=1
					break
				if(!already_messy)
					var/obj/S=new/obj/effect/decal/cleanable/sex/milk()
					S.loc=owner.loc
			var/live_people=0
			for(var/mob/living/M in contents)
				live_people=1
				break
			if(digestion_count&&!live_people)
				owner.visible_message("<span class='notice'>[owner] milks their breasts, releasing a suspiciously large amount of milk.</span>")
			else if(live_people)
				owner.visible_message("<span class='notice'>[owner] milks their breasts, releasing milk-soaked people.</span>")
			else
				owner.visible_message("<span class='notice'>[owner] milks their breasts onto the floor.</span>")
		else if(source==FLAVOUR_HURL)
			if(istype(owner.loc,/turf))
				var/already_messy=0
				for(var/obj/effect/decal/cleanable/sex/S in owner.loc)
					already_messy=1
					break
				if(!already_messy)
					var/obj/S=new/obj/effect/decal/cleanable/sex/milk()
					S.loc=owner.loc
			var/live_people=0
			for(var/mob/living/M in contents)
				live_people=1
				break
			if(live_people)
				owner.visible_message("<span class='notice'>[owner]'s breasts suddenly lactate, releasing people covered in milk.</span>")
			else
				owner.visible_message("<span class='notice'>[owner] suddenly lactates milk onto the floor.</span>")
		else if(source==FLAVOUR_ESCAPE&&prey)
			owner.visible_message("<span class='notice'>[prey] slips out of [owner]'s nipple.</span>")
		else if(source==FLAVOUR_TRANSFORM)
			owner<<"Your breasts jiggle. A transformation is complete."
		else ..()
	check_exist()
		return owner.has_boobs() ? 1 : 0

/datum/vore_organ/insole
	exterior=1
	var/last_shoes="shoes"
	assoc_loc="leg"
	digest()
		..()
		if(owner.get_shoes())
			var/obj/O=owner.get_shoes()
			last_shoes=O.name
		else
			for(var/mob/living/M in contents)
				release()
				return
			for(var/obj/item/O in contents)
				release()
				return
	flavour_text(var/source, var/mob/living/prey, var/extra_info=0)
		if(source==FLAVOUR_RELEASE)
			owner.visible_message("<span class='notice'>[owner] takes off their [last_shoes] and dumps the contents onto the floor.</span>")
		else if(source==FLAVOUR_ESCAPE&&prey)
			owner.visible_message("<span class='notice'>[prey] crawls out and away from [owner]'s [last_shoes],, looking quite dishelved.</span>")

/datum/vore_organ/insuit
	exterior=1
	var/last_suit="underwear"
	digest()
		..()
		if(owner.get_suit())
			var/obj/O=owner.get_suit()
			last_suit=O.name
		else
			for(var/mob/living/M in contents)
				release()
				return
			for(var/obj/item/O in contents)
				release()
				return
	flavour_text(var/source, var/mob/living/prey, var/extra_info=0)
		if(source==FLAVOUR_RELEASE)
			owner.visible_message("<span class='notice'>[owner] takes off their [last_suit] and some things fall out.</span>")
		else if(source==FLAVOUR_ESCAPE&&prey)
			owner.visible_message("<span class='notice'>[prey] crawls out of [owner]'s [last_suit].</span>")

/datum/vore_organ/tail
	flavour_text(var/source, var/mob/living/prey, var/extra_info=0)
		if(source==FLAVOUR_DIGEST)
			owner.visible_message("<span class='danger'>[owner]'s tail gurgles and a lump on it dissipates. Someone must have digested..</span>")
			prey<<"<span class='warning'>You gurgle away inside [owner]'s tail, your form softening and adding to the tail's fluff and its owner's curves.</span>"
		else if(source==FLAVOUR_RELEASE)
			var/live_people=0
			for(var/mob/living/M in contents)
				live_people=1
				break
			if(digestion_count&&!live_people)
				owner.visible_message("<span class='notice'>[owner]'s tail hacks and coughs, spewing forth the remains of those inside it.</span>")
			if(digestion_count&&live_people)
				owner.visible_message("<span class='notice'>[owner]'s tail hacks and coughs, spewing forth those that had still remained inside.</span>")
			if(!digestion_count&&live_people)
				owner.visible_message("<span class='notice'>[owner]'s tail hacks and coughs, spewing forth those inside.</span>")
		else if(source==FLAVOUR_HURL)
			var/live_people=0
			for(var/mob/living/M in contents)
				live_people=1
				break
			if(digestion_count&&!live_people)
				owner.visible_message("<span class='notice'>[owner]'s tail thrashes in pain, spewing forth the remains of those inside it.</span>")
			if(digestion_count&&live_people)
				owner.visible_message("<span class='notice'>[owner]'s tail thrashes in pain, spewing forth those that had still remained inside.</span>")
			if(!digestion_count&&live_people)
				owner.visible_message("<span class='notice'>[owner]'s tail thrashes in pain, spewing forth those inside.</span>")
		else if(source==FLAVOUR_ESCAPE&&prey)
			owner.visible_message("<span class='notice'>[prey] crawls out of [owner]'s tailmaw, even as it snaps at their heels to reclaim them.</span>")
		else if(source==FLAVOUR_TRANSFORM)
			owner<<"Your tail twitches. A transformation is complete."
		else if(source==FLAVOUR_TRANSFER)
			owner.visible_message("<span class='notice'>A lump in [owner]'s tail moves toward the base, [owner]'s stomach sags with the added weight and a soft gurgle of moving air pockets.</span>")
			prey<<"<span class='notice'>You move into [owner]'s stomach, soaked in the saliva-like drool of the maw. Your new enviroment squeezes all around you.</span>"


//Procs handling vore.
//mob/living/simple_animal/adjustFireLoss(var/num)
//	health-=min(num,2)


/mob/living/proc/get_shoes()
	if(istype(src,/mob/living/carbon/human))
		var/mob/living/carbon/human/humz=src
		return humz.shoes
	else
		return null

/mob/living/proc/get_suit()
	if(istype(src,/mob/living/carbon/human))
		var/mob/living/carbon/human/humz=src
		if(humz.w_uniform)
			return humz.w_uniform
		else
			return humz.wear_suit
	else
		return null

/mob/proc/get_last_organ_in() //Because adding in exceptions for non-living folk was boring.
	return null

/mob/living/get_last_organ_in()
	if(last_organ_in)
		if(!last_organ_in.contents.Find(src) || !last_organ_in.owner || !last_organ_in.owner.contents.Find(src))
			last_organ_in=null
	return last_organ_in


/mob/living/proc/vore_initiate(var/mob/living/prey, var/mob/living/helper=src)
	if(prey==helper)return
	var/method=VORE_METHOD_ORAL
	if(vore_mode==VORE_MODE_FEED)//CONFUSING CODE HERE! VAR NAMES ARE WEIRD! EXCESSIVE CAUTION ADVISED!
		if(!prey.vore_pred_check())
			src << "<span class='notice'>This doesn't eat people.</span>"
			return
		if(!src.vore_prey_check(prey))
			src << "<span class='notice'>They can't eat you.</span>"
			return
		method=prey.vore_obtain_method(src,src)
		prey.vore_handle(src,method,src)
		return
	else if( helper == src ) //If the pred initiated the voring
		if(!src.vore_pred_check())
			src << "<span class='notice'>For whatever reason, you can't find it in you to eat so voraciously.</span>"
			return
		if(!prey.vore_prey_check(src))
			src << "<span class='notice'>This isn't something you can eat.</span>"
			return
		method=src.vore_obtain_method(prey)
		src.vore_handle(prey,method)
		return
	else //Pred has a helper
		if(!src.vore_pred_check())
			helper << "<span class='notice'>You're not going to be getting anything in this mouth.</span>"
			return
		if(!prey.vore_prey_check(src))
			helper << "<span class='notice'>The predator can't eat this.</span>"
			return
		method=src.vore_obtain_method(prey,helper)
		src.vore_handle(prey,method,helper)
		return




/mob/living/proc/vore_handle(var/mob/living/prey, var/method, var/mob/living/helper=src)
	if(!src.vore_datums_initialized) src.vore_init_datums()
	if(helper==prey)
		if(method==VORE_METHOD_ORAL)
			src.visible_message("<span class='danger'>[helper] begins to force themself into the mouth of [src]! [src]'s jaws are forced open and their neck soon swells with [helper]'s head!</span>")
		else if(method==VORE_METHOD_ANAL)
			src.visible_message("<span class='danger'>[helper] presses against [src]'s backside and begins shoving!</span>")
		else if(method==VORE_METHOD_COCK)
			src.visible_message("<span class='danger'>[helper] nuzzles the tip of [src]'s cock, coaxing it to eat them. Soon starting to push themselves inside the length.</span>")
		else if(method==VORE_METHOD_UNBIRTH)
			src.visible_message("<span class='danger'>[helper] starts to nose head-first into [src]'s vagina, forcing thighs apart and the lower belly to swell as [helper] scrabbles for leverage!</span>")
		else if(method==VORE_METHOD_BREAST)
			src.visible_message("<span class='danger'>[helper] presses their nose against [src]'s nipple, giving it a lick to encourage their devourment!</span>")
		else if(method==VORE_METHOD_TAIL)
			src.visible_message("<span class='danger'>[helper] hugs [src]'s tail and tries to fit inside it! The maw opens wide and engulfs over their head and shoulders in short order, making rapid progress!</span>")
		else if(method==VORE_METHOD_INSOLE)
			var/obj/O=src.get_shoes()
			if(!O)return
			src.visible_message("<span class='danger'>[helper] begins to work their way into [O.gender==PLURAL?"one of ":""][src]'s [O.name].</span>")
		else if(method==VORE_METHOD_INSUIT)
			var/obj/O=src.get_suit()
			if(!O)return
			src.visible_message("<span class='danger'>[helper] begins to work their way into [O.gender==PLURAL?"one of ":""][src]'s [O.name].</span>")
		else
			src.visible_message("<span class='danger'>[helper] is feeding themself to [src]!</span>")
	else if(helper==src)
		if(method==VORE_METHOD_ORAL)	//Needs to be rewritten so it's based on each vore type, not each post/pre vore text.
			if(vore_head_first)
				src.visible_message("<span class='danger'>[src] begins to force [prey] into their mouth! Open jaws overtaking the prey's head and soon working over the shoulders!</span>")
			else
				src.visible_message("<span class='danger'>[src] grabs [prey]'s ankles and begins to force them into their mouth foot-first! Jaws aggressively devouring up those legs quickly!</span>")
		else if(method==VORE_METHOD_ANAL)
			src.visible_message("<span class='danger'>[src] begins to force [prey] into their anus!</span>")
		else if(method==VORE_METHOD_COCK)
			if(vore_head_first)
				src.visible_message("<span class='danger'>[src] grabs the back of [prey]'s head and presses it to the tip of their hungry cock. A quick thrust forward claims the entire face!</span>")
			else
				src.visible_message("<span class='danger'>[src] grabs [prey]'s ankles and presses the feet to the tip of their hungry cock, working themselves in a pulling motion to help [prey] down!</span>")
		else if(method==VORE_METHOD_UNBIRTH)
			if(vore_head_first)
				src.visible_message("<span class='danger'>[src] grabs [prey]'s shoulders and begins shoving them into their crotch, a leg over [prey]'s frame. It wouldn't take long for [src]'s belly to start bulging with their treat as their muscle pull strongly!</span>")
			else
				src.visible_message("<span class='danger'>[src] grabs [prey]'s ankles and begins shoving the feet into their crotch, bracing themselves as they drag in those shins and knees quickly, warmth crawling its way up!</span>")
		else if(method==VORE_METHOD_BREAST)
			src.visible_message("<span class='danger'>[src] grabs [prey] and presses them against a nipple!</span>")
		else if(method==VORE_METHOD_TAIL)
			if(vore_head_first)
				src.visible_message("<span class='danger'>[src] holds [prey] still while their tail looms overhead, salivating! It soon plunges over the head and shoulders in the first gulp, aggressively dragging [prey] into becoming a bulge within!</span>")
			else
				src.visible_message("<span class='danger'>[src] holds [prey]'s form still while their tail laps at its prey's feet. The warm, toothless maw sliding up and over the calves in a single, pulsing swallow!</span>")
		else if(method==VORE_METHOD_INSOLE)
			var/obj/O=src.get_shoes()
			if(!O)return
			src.visible_message("<span class='danger'>[src] begins to place [prey] into [O.gender==PLURAL?"one of ":""]their [O.name].</span>")
		else if(method==VORE_METHOD_INSUIT)
			var/obj/O=src.get_suit()
			if(!O)return
			src.visible_message("<span class='danger'>[src] begins to place [prey] into [O.gender==PLURAL?"one of ":""]their [O.name].</span>")
		else
			src.visible_message("<span class='danger'>[src] is attempting to devour [prey]!</span>")
	else
		if(method==VORE_METHOD_ORAL)
			src.visible_message("<span class='danger'>[helper] begins to force [prey] into the mouth of [src]! [src]'s jaws are forced open around the prey, and they swallow reflexively!</span>")
		else if(method==VORE_METHOD_ANAL)
			src.visible_message("<span class='danger'>[helper] presses [prey] against [src]'s back enterance and begins shoving!</span>")
		else if(method==VORE_METHOD_COCK)
			src.visible_message("<span class='danger'>[helper] holds [prey] to the tip of [src]'s cock, pushing their face into it, which soon vanishes inside!.</span>")
		else if(method==VORE_METHOD_UNBIRTH)
			src.visible_message("<span class='danger'>[helper] grabs [prey]'s shoulders and shoves them into [src]'s crotch! [src]'s thighs are forced to spread as they take in [prey]'s form, the head and chest soon pushed within the depths!</span>")
		else if(method==VORE_METHOD_BREAST)
			src.visible_message("<span class='danger'>[helper] grabs [prey] and presses them against [src]'s nipple!</span>")
		else if(method==VORE_METHOD_TAIL)
			src.visible_message("<span class='danger'>[helper] holds [prey] still while [src]'s tail looms overhead, salivating! The maw quickly overtakes [prey]'s head and chest, forcing [helper] to shift their grip down as to not follow their target inside!</span>")
		else if(method==VORE_METHOD_INSOLE)
			var/obj/O=src.get_shoes()
			if(!O)return
			src.visible_message("<span class='danger'>[helper] begins to place [prey] into [O.gender==PLURAL?"one of ":""][src]'s [O.name].</span>")
		else if(method==VORE_METHOD_INSUIT)
			var/obj/O=src.get_suit()
			if(!O)return
			src.visible_message("<span class='danger'>[helper] begins to place [prey] into [O.gender==PLURAL?"one of ":""][src]'s [O.name].</span>")
		else
			src.visible_message("<span class='danger'>[helper] is feeding [prey] to [src]!</span>")

	if( !do_mob(helper, prey) || !do_mob(helper,src) || !do_after(helper, src.vore_speed(prey,method) ) ) return
	if( prey.anchored ) return

	if(helper==prey)
		if(method==VORE_METHOD_ORAL)
			src.visible_message("<span class='danger'>[helper] gives a final push, and is on the non-stop road to [src]'s belly! [src]'s neck loses the bulges it gained with [helper]'s devourment, gut sagging outwards with the newfound meal.</span>")
		else if(method==VORE_METHOD_ANAL)
			src.visible_message("<span class='danger'>With a final shove, [helper] disappears into [src]'s anus!</span>")
		else if(method==VORE_METHOD_COCK)
			src.visible_message("<span class='danger'>[helper] slips the rest of the way into [src]'s shaft, pre-slicked feet vanishing with an inadvertant moan from [src].</span>")
		else if(method==VORE_METHOD_UNBIRTH)
			src.visible_message("<span class='danger'>[helper] engulfs themself in [src]'s sex, the last of them tugged from view as [src] gains a new belly bump, adjusting their stance with the weight.</span>")
		else if(method==VORE_METHOD_BREAST)
			src.visible_message("<span class='danger'>[helper] slips inside [src]'s breast, leaving it larger than it was before.</span>")
		else if(method==VORE_METHOD_TAIL)
			src.visible_message("<span class='danger'>[src]'s tail engulfs [helper]. Their eager squirming muted under the tail flesh as the bulge moves deeper and deeper!</span>")
		else if(method==VORE_METHOD_INSOLE)
			var/obj/O=src.get_shoes()
			if(!O)return
			src.visible_message("<span class='danger'>[helper] fits in nice and snug.agains't [src]'s foot</span>")
		else if(method==VORE_METHOD_INSUIT)
			var/obj/O=src.get_suit()
			if(!O)return
			src.visible_message("<span class='danger'>[helper] fits in nice and snug inside [src]'s clothing, the added lump squirming to get comfortable.</span>")
		else
			src.visible_message("<span class='danger'>[helper] has fed themself to [src]!</span>")
	else if(helper==src)
		if(method==VORE_METHOD_ORAL)
			src.visible_message("<span class='danger'>[prey] vanishes within the hungry maw of [src]! The stomach bulges with the predator's meal.</span>")
		else if(method==VORE_METHOD_ANAL)
			src.visible_message("<span class='danger'>[prey] disappears into [src]'s pucker!</span>")
		else if(method==VORE_METHOD_COCK)
			if(vore_head_first)
				src.visible_message("<span class='danger'>[prey]'s feet go past [src]'s cockslit with a noisy slurp. The shaft droops with the prey within it as they sink deep enough to not easily be reached anymore!</span>")
			else
				src.visible_message("<span class='danger'>[prey]'s head vanishes into [src]'s cockslit with a squelch, the last views of the room vanishing down the tube. A wet gush of pre splashing out as the lumps decend down the length.</span>")
		else if(method==VORE_METHOD_UNBIRTH)
			if(vore_head_first)
				src.visible_message("<span class='danger'>[src] shoves [prey]'s feet fully into their sex, belly swelling and passage oozing while their fingers linger to tease themselves, soon admiring the added bulge on their hips</span>")
			else
				src.visible_message("<span class='danger'>[src] shoves [prey]'s head fully into their sex, [prey]'s last view of the world vanishing with [src]'s fingers lingering to tease the folds and push them deeper into the greedy flower</span>")
		else if(method==VORE_METHOD_BREAST)
			src.visible_message("<span class='danger'>[src] shoves [prey] inside their breast.</span>")
		else if(method==VORE_METHOD_TAIL)
			if(vore_head_first)
				src.visible_message("<span class='danger'>[src]'s tail slurps [prey]'s feet within and turns them into a bulge, The tail now drooping with the added mass that slowly traces itself in deeper.</span>")
			else
				src.visible_message("<span class='danger'>[src]'s tail slurps [prey]'s head at last, the room framed by greedy maw as it turns them into a bulge. The tail now drooping with the added mass.</span>")
		else if(method==VORE_METHOD_INSOLE)
			if(!src.get_shoes())return
			src.visible_message("<span class='danger'>[helper] fits [prey] in nice and snug.</span>")
		else if(method==VORE_METHOD_INSUIT)
			if(!src.get_suit())return
			src.visible_message("<span class='danger'>[helper] fits [prey] in nice and snug.</span>")
		else
			src.visible_message("<span class='danger'>[src] devours [prey]!</span>")
	else
		if(method==VORE_METHOD_ORAL)
			src.visible_message("<span class='danger'>[helper] gives a final push on [prey]'s feet, the last of them vanishing into the conveyer of gullet flesh to [src]'s stomach! [src]'s gains a bulge with the added addition</span>")
		else if(method==VORE_METHOD_ANAL)
			src.visible_message("<span class='danger'>With a final shove from [helper], [prey] disappears into [src]'s anus!</span>")
		else if(method==VORE_METHOD_COCK)
			src.visible_message("<span class='danger'>[helper] pushes the last of [prey] into [src]'s slit, pulling their pre-slicked hands free just in time.</span>")
		else if(method==VORE_METHOD_UNBIRTH)
			src.visible_message("<span class='danger'>[helper] pushes [prey]'s feet firmly into [src]'s sex, going wrist-deep themself.They pull back their hand before it's tugged to the elbow and have a front row seat to the lower belly swelling with moving prey.</span>")
		else if(method==VORE_METHOD_BREAST)
			src.visible_message("<span class='danger'>[helper] shoves [prey] inside [src]'s breast.</span>")
		else if(method==VORE_METHOD_TAIL)
			src.visible_message("<span class='danger'>[src]'s tail completely engulfs over [prey]'s form, eagerly lapping over [helper]'s hand as if wanting a second helping within itself. [prey]'s bulges gradually settle into the center of the tail, awaiting their fate!</span>")
		else if(method==VORE_METHOD_INSOLE)
			if(!src.get_shoes())return
			src.visible_message("<span class='danger'>[helper] fits [prey] in [src]'s footwear, slipping it back onto their foot before [prey] could even think to escape..</span>")
		else if(method==VORE_METHOD_INSUIT)
			if(!src.get_suit())return
			src.visible_message("<span class='danger'>[helper] stuffs [prey] in through the opening of [src]'s clothing, putting it back into place before [prey] is able to wiggle free of the stuffy confines..</span>")
		else
			src.visible_message("<span class='danger'>[helper] has fed [prey] to [src]!</span>")

	for(var/obj/item/weapon/grab/G in prey.grabbed_by)
		qdel(G)

	if(helper==src)
		vore_admins("[src] has eaten [prey]. via [method].",src,prey)
	else if(helper==prey)
		vore_admins("[prey] has fed themself to [src]. via [method].",src,prey)
	else
		vore_admins("[helper] has fed [prey] to [src]. via [method].",src,prey)

	var/datum/vore_organ/destination=vore_organ_for_method(method)
	destination.add(prey)

//Procs obtaining information for vore.

/mob/living/proc/vore_ability_check(var/method,var/mob/living/prey=null)
	if(method==VORE_METHOD_TAIL&&!kpcode_mob_has_tail())
		return 0
	var/ability=vore_ability[num2text(method)]
	if(ability==VORE_SIZEDIFF_DISABLED)return 0
	if(!prey)return 1
	if(ability<VORE_SIZEDIFF_ANY)
		if(prey.sizeplay_size-src.sizeplay_size>1)
			return 0
	if(ability<VORE_SIZEDIFF_DOUBLE)
		if(prey.sizeplay_size>src.sizeplay_size)
			return 0
	if(ability<VORE_SIZEDIFF_SAMESIZE)
		if(prey.sizeplay_size>=src.sizeplay_size)
			return 0
	if(ability<VORE_SIZEDIFF_SMALLER)
		if(src.sizeplay_size-prey.sizeplay_size<2)
			return 0
	return 1

/mob/living/proc/vore_pred_check()
	if(iscarbon(src)||isalien(src)||istype(src,/mob/living/simple_animal))return 1
	return 0
/mob/living/proc/vore_prey_check(var/mob/living/pred)
	if(!pred.vore_ability_check(VORE_METHOD_ORAL,src))return 0
	if(iscarbon(src)||isalien(src)||istype(src,/mob/living/simple_animal)||istype(src,/mob/living/egg))return 1
	return 0

/mob/living/proc/vore_organ_for_method(var/chk_method)
	switch(chk_method)
		if(VORE_METHOD_COCK)
			return vore_cock_datum
		if(VORE_METHOD_UNBIRTH)
			return vore_womb_datum
		if(VORE_METHOD_TAIL)
			return vore_tail_datum
		if(VORE_METHOD_BREAST)
			return vore_breast_datum
		if(VORE_METHOD_INSOLE)
			return vore_insole_datum
		if(VORE_METHOD_INSUIT)
			return vore_insuit_datum
		else
			return vore_stomach_datum

/mob/living/proc/vore_obtain_method(var/mob/living/prey, var/mob/living/helper=src)
	if(helper!=src&&helper.vore_current_method&src.vore_banned_methods)
		return VORE_METHOD_ORAL
	if(helper.vore_current_method&prey.vore_banned_methods)
		return VORE_METHOD_ORAL
	for(var/mob/living/check in prey)
		if(helper.vore_current_method&check.vore_banned_methods)
			return VORE_METHOD_ORAL
	/*if((helper.vore_current_method&prey.vore_banned_methods)||(helper.vore_current_method&src.vore_banned_methods)) //Check for bans.
		return VORE_METHOD_ORAL*/
	//To do: Add in checks for muzzles.
	if(!vore_ability_check(helper.vore_current_method,prey)) //Is this even possible?
		return VORE_METHOD_ORAL
	else if(helper.vore_current_method==VORE_METHOD_INSOLE) //Temporary
		var/mob_count=0
		for(var/mob/M in src.vore_insole_datum.contents)
			mob_count+=1
			if(mob_count>1)
				return VORE_METHOD_ORAL
	else if(helper.vore_current_method==VORE_METHOD_INSUIT) //Temporary, too
		var/mob_count=0
		for(var/mob/M in src.vore_insuit_datum.contents)
			mob_count+=1
			if(mob_count>2)
				return VORE_METHOD_ORAL
	else if(helper.vore_current_method==VORE_METHOD_TAIL)
		if(!src.kpcode_mob_has_tail())
			return VORE_METHOD_ORAL
	return helper.vore_current_method

/mob/living/proc/vore_speed(var/mob/living/prey, var/method)
	return 60+((prey.sizeplay_size-sizeplay_size)*10)

/mob/living/proc/vore_organ_list()
	var/list/return_lst=new/list()
	return_lst.Add(src.vore_stomach_datum, src.vore_cock_datum, src.vore_balls_datum, src.vore_womb_datum, src.vore_breast_datum, src.vore_tail_datum, src.vore_insole_datum, src.vore_insuit_datum)
	return return_lst

/mob/living/proc/vore_init_datums()
	for(var/datum/vore_organ/vo in src.vore_organ_list())
		vo.owner=src
		if(!istype(src,/mob/living/carbon/human)&&!client)//If not human, and not player-controlled...
			vo.digestion_factor=VORE_DIGESTION_SPEED_SLOW
	vore_datums_initialized=1


/mob/living/proc/vore_transform(var/transformpath=null, var/transform_species=null, var/transform_gender=NEUTER, var/egg_tf=0)
	var/datum/vore_transform_datum/VTD=new()
	VTD.tf_path=transformpath
	VTD.tf_species=transform_species
	VTD.tf_gender=transform_gender
	VTD.tf_egg=egg_tf
	VTD.apply_transform(src)
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

/mob/living/proc/vore_dna_mod(var/new_dna)
	if(!check_dna_integrity(src))return
	if(!new_dna)return
	var/mob/living/carbon/C=src
	if(istype(new_dna,/datum/dna))
		var/old_name=C.real_name
		var/datum/dna/change_dna=new_dna
		C.dna.struc_enzymes=change_dna.struc_enzymes
		C.dna.unique_enzymes=change_dna.unique_enzymes
		C.dna.uni_identity=change_dna.uni_identity
		C.dna.mutantrace=change_dna.mutantrace
		updateappearance(C)
		C.real_name=old_name
		C.name=old_name
	else
		C.dna.mutantrace=new_dna
*/




/mob/living/proc/vore_contents_drop(var/datum/vore_organ/conta=null)
	if(!conta)conta=src.get_last_organ_in()
	if(!conta)return
	for(var/mob/living/M in src.stomach_contents)
		src.stomach_contents.Remove(M)
		src.contents.Remove(M)
		conta.add(M)
	for(var/obj/item/W in src)
		if(istype(W, /obj/item/weapon/implant || /obj/item/weapon/disk/nuclear || /obj/item/weapon/reagent_containers/food))
			qdel(W)
			continue
		W.layer = initial(W.layer)
		W.loc = src.loc
		W.dropped(src)
		W.loc = src.loc//Once more to make sure!
		if(conta)
			conta.contents.Add(W)
			conta.owner.stomach_contents.Add(W)


/mob/living/relaymove(var/mob/user, direction)
	if(!istype(user,/mob/living))
		return ..()
	var/mob/living/prey=user
	if(prey in src.stomach_contents)
		var/datum/vore_organ/VO=prey.get_last_organ_in()
		if(VO)
			VO.relaymove(prey,direction)






//objects
/obj/effect/decal/cleanable/sex/semen
	name = "semen"
	desc = "A puddle of hot, sticky spooge."
	gender = PLURAL
	density = 0
	anchored = 1
	layer = 2
	icon = 'icons/effects/blood.dmi'
	icon_state = "semen1"
	random_icon_states = list("semen1", "semen2", "semen3")

/obj/effect/decal/cleanable/sex/femjuice
	name = "femjuice"
	desc = "A puddle of warm fem-cum. Someone got excited."
	gender = PLURAL
	density = 0
	anchored = 1
	layer = 2
	icon = 'icons/effects/blood.dmi'
	icon_state = "fem1"
	random_icon_states = list("fem1", "fem2", "fem3")

/obj/effect/decal/cleanable/sex/milk
	name = "breast milk"
	desc = "A puddle of warm breast-milk."
	gender = PLURAL
	density = 0
	anchored = 1
	layer = 2
	icon = 'icons/effects/blood.dmi'
	icon_state = "milk1"
	random_icon_states = list("milk1", "milk2", "milk3")



/obj/effect/decal/cleanable/lemonjuice
	name = "lemon juice"
	desc = "A puddle of lemon juice."
	gender = PLURAL
	density = 0
	anchored = 1
	layer = 2
	icon = 'icons/effects/blood.dmi'
	icon_state = "lemon1"
	random_icon_states = list("lemon1", "lemon2", "lemon3")



//Clothes!
/obj/item/clothing/under/notnude
	name = "emperor finery"
	desc = "Only apex predators can see this."
	icon_state = "notnude"
	item_state = "notnude"
	item_color = "notnude"
	body_parts_covered = 0
	fitted = 0

/obj/item/clothing/under/maid
	name = "maid uniform"
	desc = "Clean and do laundry."
	icon_state = "maid"
	item_state = "maid"
	item_color = "maid"
	body_parts_covered = CHEST|GROIN|ARMS
	fitted = 0

/obj/item/clothing/under/maid/narky
	name = "narky outfit"
	desc = "How cute~"
	icon_state = "narkymaid"
	item_state = "narkymaid"
	item_color = "narkymaid"

/obj/item/clothing/under/diaper
	name = "space diaper"
	desc = "Oh, my."
	icon_state = "diaper"
	item_state = "diaper"
	item_color = "diaper"
	body_parts_covered = GROIN
	fitted = 0

/obj/item/clothing/under/schoolgirl/red
	icon_state = "schoolgirlred"
	item_state = "schoolgirlred"
	item_color = "schoolgirlred"

/obj/item/clothing/under/schoolgirl/lav
	icon_state = "schoolgirllav"
	item_state = "schoolgirllav"
	item_color = "schoolgirllav"

/obj/item/clothing/under/rank/mailman/poojie
	name = "poojie jumpsuit"
	desc = "Foxcom Special Edition"
	icon_state = "pooj"
	item_state = "p_suit"
	item_color = "pooj"

/obj/item/clothing/head/mailman/poojie
	name = "poojie hat"
	desc = "Foxcom Special Edition"
	icon_state = "pooj"

/obj/item/clothing/shoes/sandal/pavi
	desc = "A pair of rather amazing, purple sandals"
	name = "pavi sandals"
	icon_state = "pavi"

/obj/item/clothing/suit/narkycuff
	name = "cuffs"
	desc = "For when a Narky feels stylish or kinky."
	icon_state = "narkycuff"
	item_state = "narkycuff"
	gender=PLURAL
	body_parts_covered = ARMS
	allowed = list(/obj/item/weapon/gun/energy/laser/sizeray)

/obj/item/clothing/shoes/narkyanklet
	name = "anklets"
	desc = "For when a Narky wants to tie people to his paws without string."
	icon_state = "narkyanklet"
	item_state = "narkyanklet"
	body_parts_covered = LEGS

/obj/item/weapon/storage/backpack/kittypack
	name = "kitty backpack"
	desc = "Mr. Noodles!"
	icon_state = "kittypack"
	item_state = "kittypack"


//Sppoky stuffs!
/obj/item/clothing/suit/costume/spooky_spook
	name = "spooky ghost costume"
	desc = "It's a g-g-gg-ggg-g-g-g-BEDSHEET!"
	icon_state = "spooky_spook"
	item_state = "spooky_spook"

/obj/item/clothing/suit/costume/narky_fursuit
	name = "\improper Narky fursuit"
	desc = "Dress up like a Narky! Narky is terrified of these."
	icon_state = "narky_fursuit"
	item_state = "narky_fursuit"
	allowed = list(/obj/item/weapon/gun/energy/laser/sizeray)

/obj/item/clothing/head/costume/narky_fursuit
	name = "\improper Narky fursuit head"
	desc = "Dress up like a Narky! Narky is terrified of these."
	icon_state = "narky_fursuit"

/obj/item/clothing/suit/costume/clone
	name = "sharpshooter costume"
	desc = "Best shot at the academy!"
	icon_state = "clone"
	item_state = "clone"

/obj/item/clothing/head/costume/clone
	name = "sharpshooter helmet"
	desc = "Best shot at the academy!"
	icon_state = "clone"

/obj/item/clothing/suit/costume/batman
	name = "\improper Dark West costume"
	desc = "You're not safe, and neither is this bomb."
	icon_state = "batman"
	item_state = "batman"

/obj/item/clothing/head/costume/batman
	name = "\improper Dark West mask"
	desc = "You're not safe, and neither is this bomb."
	icon_state = "batman"

/obj/item/clothing/under/costume/spiderman
	name = "\improper Human Spider costume"
	desc = "Does whatever he does."
	icon_state = "spiderman"
	item_state = "spiderman"
	item_color = "spiderman"

/obj/item/clothing/mask/costume/spiderman
	name = "\improper Human Spider mask"
	desc = "Does whatever he does."
	icon_state = "spiderman"
	item_state = "spiderman"

/obj/item/clothing/under/costume/zeerust
	name = "zeerust captain costume"
	desc = "In a game of chess, you must never let your opponent see your pieces."
	icon_state = "zeerust"
	item_state = "zeerust"
	item_color = "zeerust"


/obj/structure/sign/portrait
	name = "portrait"
	desc = "A pretty picture."
	icon_state = "portrait"
	var/image_path='icons/ss13_64.png'
	var/image_name="SS13"
	var/image_link=null
	examine()
		//set src in oview(7)
		if(is_blind(usr))	return
		if(!is_whitelisted(usr.ckey))return

		//if(in_range(usr, src))
		show(usr)
		usr << desc
		//else
		//	usr << "<span class='notice'>It is too far away.</span>"
	proc/show(mob/user)
		user << browse_rsc(image_path, "tmp_photo.png")
		user << browse("<html><head><title>[image_name]</title></head>" \
			+ "<body style='overflow:hidden;margin:0;text-align:center'>" \
			+ "<img src='tmp_photo.png' width='512' style='-ms-interpolation-mode:nearest-neighbor' />" \
			+ "</body></html>", "window=book;size=512x512")
		onclose(user, "[name]")

/obj/item/toy/toaster
	name="poorly-drawn toaster"
	icon = 'icons/obj/toy.dmi'
	icon_state = "toaster"
	desc = "You've seen better."
	attack_self(mob/user)
		user << "<span class='notice'>You try to make toast with [src]. It doesn't have an animation for that.</span>"
	attackby(obj/item/weapon/W as obj, mob/user as mob)
		if(istype(W,/obj/item/toy/crayon)||istype(W,/obj/item/weapon/pen))
			if(icon_state=="toaster")
				user << "<span class='notice'>You try to make [src] look better.</span>"
				user.loc.audible_message("<B>[user]</B> scribbles on [src]. \"Huzzah!\"")
				icon_state="toaster_cs"
			else
				user << "<span class='notice'>You don't think it gets much better than this.</span>"
			return
		return ..()

/obj/item/toy/toaster/cs
	icon_state="toaster_cs"





datum/objective/vore_digest
	var/target_role_type=0
	dangerrating = 10

datum/objective/vore_digest/find_target_by_role(role, role_type=0)
	target_role_type = role_type
	..(role, role_type)
	return target

datum/objective/vore_digest/check_completion()
	if(target && target.current)
		if(target.current.stat == DEAD || issilicon(target.current) || isbrain(target.current) || target.current.z > 6 || !target.current.ckey || target.current.loc==owner.current) //Borgs/brains/AIs count as dead for traitor objectives. --NeoFite
			return 1
		var/list/ins_lst=recursive_mob_check(src,0,0,0)
		if(ins_lst.Find(target.current))
			return 1
		return 0
	return 1

datum/objective/vore_digest/update_explanation_text()
	..()
	if(target && target.current)
		explanation_text = "Eat [target.current.real_name], the [!target_role_type ? target.assigned_role : target.special_role], and keep them. This order is dead or alive, so digest or otherwise kill them if they are too much trouble."
	else
		explanation_text = "Free Objective (Go eat some people! Digestion optional if they allow it!)"


datum/objective/digest
	var/target_role_type=0
	dangerrating = 10

datum/objective/digest/find_target_by_role(role, role_type=0)
	target_role_type = role_type
	..(role, role_type)
	return target

datum/objective/digest/check_completion()
	if(target&&owner.people_digested.Find(target))
		return 1
	else if(!target&&owner.people_digested.len)
		return 1
	return 0

datum/objective/digest/update_explanation_text()
	..()
	if(target && target.current)
		explanation_text = "Eat [target.current.real_name], the [!target_role_type ? target.assigned_role : target.special_role], and digest them. They do not need to stay dead."
	else
		explanation_text = "Digest one person."


datum/objective/get_digested
	var/target_role_type=0
	dangerrating = 10

datum/objective/get_digested/find_target_by_role(role, role_type=0)
	target_role_type = role_type
	..(role, role_type)
	return target

datum/objective/get_digested/check_completion()
	if(target&&owner.digested_by.Find(target))
		return 1
	else if(!target&&owner.digested_by.len)
		return 1
	return 0

datum/objective/get_digested/update_explanation_text()
	..()
	if(target && target.current)
		explanation_text = "Get digested by [target.current.real_name], the [!target_role_type ? target.assigned_role : target.special_role], to spread a supervirus. All of your cloned bodies will contain this supervirus."
	else
		explanation_text = "Get digested to spread a supervirus."


datum/objective/vore
	var/target_role_type=0
	var/failsafe=0
	dangerrating = 10

datum/objective/vore/find_target_by_role(role, role_type=0)
	target_role_type = role_type
	..(role, role_type)
	return target

datum/objective/vore/check_completion()
	if(failsafe)return 1 //Should hopefully only trigger on free objective.
	if(target && target.current)
		if(target.current.loc==owner.current)
			return 1
		var/list/ins_lst=recursive_mob_check(src,0,0,0)
		if(ins_lst.Find(target.current))
			return 1
		return 0
	return 0 //As a failsafe, this is usually "return 1." This objective requires they be not exploded, so... Return 0.

datum/objective/vore/update_explanation_text()
	..()
	if(target && target.current)
		explanation_text = "Eat [target.current.real_name], the [!target_role_type ? target.assigned_role : target.special_role], and keep them. We need them alive, do not let them die."
	else
		explanation_text = "Free Objective (Go eat some people!)"
		failsafe=1

datum/objective/vore_opt_escape
	explanation_text = "Escape on the shuttle or an escape pod alive. For optional security, be smuggled aboard while inside someone. Do not arrive in the brig."
	dangerrating = 5

/*datum/objective/vore_opt_escape/check_completion()
	if(issilicon(owner.current))
		return 0
	if(isbrain(owner.current))
		return 0
	if(emergency_shuttle.location<2)
		return 0
	if(!owner.current || owner.current.stat ==2)
		return 0
	var/turf/location = get_turf(get_top_level_mob(owner.current))
	if(!location)
		return 0

	if(istype(location, /turf/simulated/shuttle/floor4)) // Fails traitors if they are in the shuttle brig
		return 0

	var/area/check_area = location.loc
	if(istype(check_area, /area/centcom/evac))
		return 1
	if(istype(check_area, /area/centcom/evac))
		return 1
	if(istype(check_area, /area/centcom/evac))
		return 1
	if(istype(check_area, /area/centcom/evac))
		return 1
	if(istype(check_area, /area/centcom/evac))
		return 1
	else
		return 0*/

datum/objective/vore_escape
	explanation_text = "Escape on the shuttle or an escape pod alive. They are hunting for you and checking containers, so you will need to be inside someone to escape. They will perform full searches in the brig, so avoid it."
	dangerrating = 5

/*datum/objective/vore_escape/check_completion()
	if(issilicon(owner.current))
		return 0
	if(isbrain(owner.current))
		return 0
	if(emergency_shuttle.location<2)
		return 0
	if(!owner.current || owner.current.stat ==2)
		return 0
	if(get_top_level_mob(owner.current)==owner.current) return 0
	var/turf/location = get_turf(get_top_level_mob(owner.current))
	if(!location)
		return 0

	if(istype(location, /turf/simulated/shuttle/floor4)) // Fails traitors if they are in the shuttle brig
		return 0

	var/area/check_area = location.loc
	if(istype(check_area, /area/centcom/evac))
		return 1
	if(istype(check_area, /area/centcom/evac))
		return 1
	if(istype(check_area, /area/centcom/evac))
		return 1
	if(istype(check_area, /area/centcom/evac))
		return 1
	if(istype(check_area, /area/centcom/evac))
		return 1
	else
		return 0*/



//Makeshift vore toggles
/*
/mob/living/proc/set_vore_abil()
	set name = "Enable Vore Ability"
	set category = "Vore"
	var/selection = input("People will be able to feed you, and it will be an option to you on other menus.") in list("Cancel", "Anal", "Cock", "Unbirth")
	if(selection=="Cancel")return
	if(selection=="Anal")
		vore_possible_methods |= VORE_METHOD_ANAL
	if(selection=="Cock")
		vore_possible_methods |= VORE_METHOD_COCK
	if(selection=="Unbirth")
		vore_possible_methods |= VORE_METHOD_UNBIRTH
	src << "[selection] added."

/mob/living/proc/set_vore_debil()
	set name = "Disable Vore Ability"
	set category = "Vore"
	var/selection = input("Will prevent you from devouring people this way.") in list("Cancel", "Anal", "Cock", "Unbirth")
	if(selection=="Cancel")return
	if(selection=="Anal")
		vore_possible_methods &= ~VORE_METHOD_ANAL
	if(selection=="Cock")
		vore_possible_methods &= ~VORE_METHOD_COCK
	if(selection=="Unbirth")
		vore_possible_methods &= ~VORE_METHOD_UNBIRTH
	src << "[selection] removed."



/mob/living/proc/set_vore_mode()
	set name = "Change Vore Mode"
	set category = "Vore"
	var/selection = input("Set the type of vore used when eating or feeding others.") in list("Oral", "Anal", "Cock", "Unbirth", "Put in Shoe")
	if(selection=="Oral")
		vore_current_method = VORE_METHOD_ORAL
	if(selection=="Anal")
		vore_current_method = VORE_METHOD_ANAL
	if(selection=="Cock")
		vore_current_method = VORE_METHOD_COCK
	if(selection=="Unbirth")
		vore_current_method = VORE_METHOD_UNBIRTH
	if(selection=="Put in Shoe")
		vore_current_method = VORE_METHOD_INSOLE
		src << "(Not really much of a vore method, but, gotta put it in the debug panel.)"
	src << "[selection] is your current vore type."
	if(!(src.vore_possible_methods&vore_current_method))
		src<<"Note: You do not have this vore type enabled for yourself. This will only work when feeding people."


/mob/living/proc/set_vore_ban()
	set name = "Ban Vore Type"
	set category = "Vore"
	var/selection = input("People will not be able to engage you in this type, and will instead orally vore.") in list("Cancel", "Anal", "Cock", "Unbirth")
	if(selection=="Anal")
		vore_banned_methods |= VORE_METHOD_ANAL
	if(selection=="Cock")
		vore_banned_methods |= VORE_METHOD_COCK
	if(selection=="Unbirth")
		vore_banned_methods |= VORE_METHOD_UNBIRTH
	src << "[selection] banned."

/mob/living/proc/set_vore_unban()
	set name = "Unban Vore Type"
	set category = "Vore"
	if(!src.vore_banned_methods)
		src<<"No banned vore methods."
		if(src.ckey=="kingpygmy") //Gonna put this here for now.
			src.verbs += /mob/living/proc/test_macro_stuffs
			src.verbs += /mob/living/proc/test_micro_stuffs
		return
	var/selection = input("People will be able to engage you in this type of vore again.") in list("Cancel", "Anal", "Cock", "Unbirth")
	if(selection=="Anal")
		vore_banned_methods &= ~VORE_METHOD_ANAL
	if(selection=="Cock")
		vore_banned_methods &= ~VORE_METHOD_COCK
	if(selection=="Unbirth")
		vore_banned_methods &= ~VORE_METHOD_UNBIRTH
	src << "[selection] unbanned."*/






var/list/traitor_test_list = null
/client/proc/set_traitor_test()
	set category = "Debug"
	set name = "Traitor Test"
	if(!holder)	return
	var/inpt=input("Who do you want to add?","Add Key","[usr.ckey]")
	if(!inpt)return
	inpt=ckey(inpt)
	if(!traitor_test_list)
		traitor_test_list=list("[inpt]")
	else
		traitor_test_list.Add("[inpt]")
	log_admin("[key_name(usr)] has set [inpt] to be a traitor this round.")
	vore_admins("[key_name(usr)] has set [inpt] to be a traitor this round.")
	feedback_add_details("admin_verb","TRAITTEST") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!





/mob/living/proc/set_vore_transform(var/datum/vore_organ/VO=null)
	set name = "Set Transformation"
	set category = "Vore"
	if(!VO)
		VO=vore_womb_datum
	if(!src.vore_datums_initialized) src.vore_init_datums()
	has_dna(src)
	src<<"WARNING: Transformation is currently heavily bugged. Expect odd behaviour until it is fully integrated with the vore panel."
	var/selection = alert("Transform people with [istype(VO,/datum/vore_organ/cock) ? "cockvore" : "unbirth"]?","Vore","Yes","No")
	if(selection=="No")
		src << "Will not transform people."
		VO.tf_factor=VORE_TRANSFORM_SPEED_NONE
		return
	selection = input("What do you want to turn people into?") in list("No Change", "Human", "Monkey", "Cat", "Chicken", "Cow", "Lizard", "Mouse", "Crab", "Fox")
	switch(selection)
		if("Human")VO.tf_path=/mob/living/carbon/human
		if("Monkey")VO.tf_path=/mob/living/carbon/monkey
		//if("Corgi")VO.tf_path=/mob/living/simple_animal/pet/corgi //abused for the traitor objective too many times, right? ^removed from the list above
		if("Cat")VO.tf_path=/mob/living/simple_animal/pet/cat
		if("Chiken")VO.tf_path=/mob/living/simple_animal/chicken
		if("Cow")VO.tf_path=/mob/living/simple_animal/cow
		if("Lizard")VO.tf_path=/mob/living/simple_animal/lizard
		if("Mouse")VO.tf_path=/mob/living/simple_animal/mouse
		//if("Pug")VO.tf_path=/mob/living/simple_animal/pet/pug
		if("Crab")VO.tf_path=/mob/living/simple_animal/crab
		if("Fox")VO.tf_path=/mob/living/simple_animal/pet/fox
		else VO.tf_path=null
	VO.tf_species=null
	if(VO.tf_path==/mob/living/carbon/human)
		selection=input("What species?") in list("No Change","Turn Into Me")+kpcode_race_getlist(ckey)
		if(selection!="No Change"&&selection!="Turn Into Me")
			VO.tf_species=selection
		else if(selection=="Turn Into Me")
			VO.tf_species=has_dna(src)
	selection = alert("What gender?","Vore","No Change","Male","Female")
	switch(selection)
		if("Male") VO.tf_gender=MALE
		if("Female") VO.tf_gender=FEMALE
		else VO.tf_gender=NEUTER
	selection = alert("Give them a nice, eggy package?","Vore","Egg!","No.")
	VO.tf_egg = selection=="Egg!" ? 1 : 0
	if(VO.has_people()&&!VO.tf_factor)
		vore_admins("[VO.owner]'s [VO.type] set to transform.",VO.owner)
	VO.tf_factor=VORE_TRANSFORM_SPEED_FAST
	VO.digestion_factor=VORE_DIGESTION_SPEED_NONE
	VO.healing_factor=0
	src<<"Transform enabled. Digestion automatically disabled for this vore type and it will take time to complete."




/mob/living/proc/set_vore_digest() //possibly mobs?
	set name = "Digestion Toggle"
	set category = "Vore"
	if(!src.vore_datums_initialized) src.vore_init_datums()
	if(vore_stomach_datum.digestion_factor==VORE_DIGESTION_SPEED_NONE)
		vore_stomach_datum.digestion_factor=VORE_DIGESTION_SPEED_SLOW
		vore_cock_datum.digestion_factor=VORE_DIGESTION_SPEED_SLOW
		vore_womb_datum.digestion_factor=VORE_DIGESTION_SPEED_SLOW
		src << "Digesting slowly!"
		return
	if(vore_stomach_datum.digestion_factor==VORE_DIGESTION_SPEED_SLOW)
		vore_stomach_datum.digestion_factor=VORE_DIGESTION_SPEED_FAST
		vore_cock_datum.digestion_factor=VORE_DIGESTION_SPEED_FAST
		vore_womb_datum.digestion_factor=VORE_DIGESTION_SPEED_FAST
		src << "Digesting fast!"
		return
	vore_stomach_datum.digestion_factor=VORE_DIGESTION_SPEED_NONE
	vore_cock_datum.digestion_factor=VORE_DIGESTION_SPEED_NONE
	vore_womb_datum.digestion_factor=VORE_DIGESTION_SPEED_NONE
	src << "No longer digesting."


/mob/living/proc/vore_release_stomach()
	set name = "Release Stomach"
	set category = "Vore"
	if(!src.vore_stomach_datum.release())
		src << "You can't do that. Eat something, first!"

/mob/living/proc/vore_release_cock()
	set name = "Release Cock"
	set category = "Vore"
	src.vore_cock_datum.release()

/mob/living/proc/vore_release_womb()
	set name = "Release Womb"
	set category = "Vore"
	src.vore_womb_datum.release()

/mob/living/proc/vore_panel()
	set name = "Vore Panel"
	set category = "Vore"
	var/obj/vore_preferences/VP=new()
	VP.target=src
	VP.ShowChoices(src)

/mob/living/proc/underwear_toggle()
	set name = "Force Update"
	set category = "Vore"
	if(istype(src,/mob/living/carbon/human))
		var/mob/living/carbon/human/humz=src
		humz.underwear_active=!humz.underwear_active
		//updateappearance(src)
		src.update_body()
	else
		src<<"Humans only."

/*
/mob/living/proc/test_macro_stuffs()
	set name = "Macro Size"
	set category = "Debug"
	var/matrix/trnfrm=new()
	trnfrm=trnfrm.Scale(2)
	src.transform=trnfrm
	*/

/mob/living/proc/test_macro_stuffs()
	set name = "Macro Size"
	set category = "Debug"
	src.sizeplay_grow()

/mob/living/proc/test_micro_stuffs()
	set name = "Micro Size"
	set category = "Debug"
	src.sizeplay_shrink()


/mob/living/proc/kpcode_mob_has_tail()
	if(istype(src,/mob/living/carbon/human))
		var/mob/living/carbon/human/H=src
		var/race = H.dna ? H.dna.mutantrace() : null
		if(race&&kpcode_hastail(race))
			return kpcode_hastail(race)
		if(!race||race=="human")
			var/tail = H.dna ? H.dna.mutanttail : null
			if(tail&&kpcode_hastail(tail))
				return kpcode_hastail(tail)
	if(istype(src,/mob/living/carbon/monkey))
		return "monkey"
	if(istype(src,/mob/living/carbon/alien))
		return "alien"
	return 0


/mob/living/proc/has_cock()
	if(issilicon(src))return 0
	if(istype(src,/mob/living/carbon))
		var/mob/living/carbon/H=src
		var/list/cock = H.dna ? H.dna.cock : null
		if(cock&&cock["has"])
			return cock["has"]
		else
			return 0
	else if(gender==MALE)
		return 1
	return 0

/mob/living/proc/has_vagina()
	if(issilicon(src))return 0
	if(istype(src,/mob/living/carbon))
		var/mob/living/carbon/H=src
		var/vagina = H.dna ? H.dna.vagina : 0
		return vagina
	else if(gender==FEMALE)
		return 1
	return 0

/mob/living/proc/has_boobs()
	if(issilicon(src))return 0
	return gender==FEMALE


/mob/living/New() //
	//verbs += /mob/living/proc/set_vore_abil
	//verbs += /mob/living/proc/set_vore_debil
	//verbs += /mob/living/proc/set_vore_mode
	//verbs += /mob/living/proc/set_vore_ban
	//verbs += /mob/living/proc/set_vore_unban
	//verbs += /mob/living/proc/digest
	//verbs += /mob/living/proc/set_vore_transform
	//verbs += /mob/living/proc/vore_release_stomach
	//verbs += /mob/living/proc/vore_release_cock
	//verbs += /mob/living/proc/vore_release_womb
	verbs += /mob/living/proc/vore_panel
	verbs += /mob/living/proc/underwear_toggle
	if(!src.vore_datums_initialized) src.vore_init_datums()
	return ..()













/client/verb/looc(msg as text)
	set name = "LOOC"
	set desc = "Local OOC, seen only by those in view."
	set category = "OOC"

	if(say_disabled)	//This is here to try to identify lag problems
		usr << "\red Speech is currently admin-disabled."
		return

	if(!mob)	return
	if(IsGuestKey(key))
		src << "Guests may not use OOC."
		return

	msg = copytext(sanitize(msg), 1, MAX_MESSAGE_LEN)
	if(!msg)	return

	if(!(prefs.toggles & CHAT_OOC))
		src << "\red You have OOC muted."
		return

	if(!holder)
		if(!ooc_allowed)
			src << "\red OOC is globally muted"
			return
		if(!dooc_allowed && (mob.stat == DEAD))
			usr << "\red OOC for dead mobs has been turned off."
			return
		if(prefs.muted & MUTE_OOC)
			src << "\red You cannot use OOC (muted)."
			return
		if(handle_spam_prevention(msg,MUTE_OOC))
			return
		if(findtext(msg, "byond://"))
			src << "<B>Advertising other servers is not allowed.</B>"
			log_admin("[key_name(src)] has attempted to advertise in LOOC: [msg]")
			vore_admins("[key_name_admin(src)] has attempted to advertise in LOOC: [msg]")
			return

	log_ooc("(LOCAL) [mob.name]/[key] : [msg]")

	var/list/heard = get_hearers_in_view(7, get_top_level_mob(src.mob))
	for(var/mob/M in heard)
		if(!M.client)
			continue
		var/client/C = M.client
		if (C in admins)
			continue //they are handled after that

		if (istype(M,/mob/dead/observer))
			continue //Also handled later.

		if(C.prefs.toggles & CHAT_OOC)
//			var/display_name = src.key
//			if(holder)
//				if(holder.fakekey)
//					if(C.holder)
//						display_name = "[holder.fakekey]/([src.key])"
//				else
//					display_name = holder.fakekey
			C << "<font color='#6699CC'><span class='ooc'><span class='prefix'>LOOC:</span> <EM>[src.mob.name]:</EM> <span class='message'>[msg]</span></span></font>"

	for(var/client/C in admins)
		if(C.prefs.toggles & CHAT_OOC)
			var/prefix = "(R)LOOC"
			if (C.mob in heard)
				prefix = "LOOC"
			C << "<font color='#6699CC'><span class='ooc'><span class='prefix'>[prefix]:</span> <EM>[src.key]/[src.mob.name]:</EM> <span class='message'>[msg]</span></span></font>"

	for(var/mob/dead/observer/G in world)
		if(!G.client)
			continue
		var/client/C = G.client
		if (C in admins)
			continue //handled earlier.
		if(C.prefs.toggles & CHAT_OOC)
			var/prefix = "(G)LOOC"
			if (C.mob in heard)
				prefix = "LOOC"
			C << "<font color='#6699CC'><span class='ooc'><span class='prefix'>[prefix]:</span> <EM>[src.key]/[src.mob.name]:</EM> <span class='message'>[msg]</span></span></font>"



/*datum/admins/proc/panicbutton()
	set category = "Server"
	set desc="Whitelist lots of things"
	set name="Panic Button"
	if(alert("Are you sure? This will whitelist things and cannot be undone.",,"Yes","No")=="Yes")
		config.narkyjoblist=1
		config.narkypaniclist=1
		vore_admins("\blue [key_name_admin(usr)] hit the panic button.", 1)
		log_admin("[key_name(usr)] hit the panic button.")
	feedback_add_details("admin_verb","PAN") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
*/


/datum/proc/doorfixing()
	set category = "Special Verbs"
	set name = "Door Fixing"
	set desc = "Fix fire and blast doors"
	for(var/obj/machinery/door/firedoor/W in world)
		if(W.layer == 2.7)
			W.layer = 2.6
	for(var/obj/machinery/door/poddoor/X in world)
		if(X.layer == 2.7)
			X.layer = 2.5
	message_admins("[key_name_admin(usr)] activated Door fixy button")
	feedback_add_details("admin_verb","DFB")


/mob/proc/kpcode_mob_offset()
	return
/mob/proc/update_body()
	if(istype(src,/mob/living/carbon/human))
		//updateappearance(mutcolor_update=0)
		src.update_body()
	/*if(istype(src,/mob/living/carbon)) //Endless loop for nonhuman mobs. base proc is /human only so nonhumans would get stuck with this being their only option.
		//updateappearance(mutcolor_update=0)
		src.update_body()*/

/mob/living/kpcode_mob_offset()
	if(istype(src,/mob/living/carbon/human))
		var/mob/living/carbon/human/H=src
		if(H.dna&&H.dna.taur&&!anchored&&!lying)
			var/size_coeff=8
			if(sizeplay_size<SIZEPLAY_NORMAL)
				size_coeff=4
			else if(sizeplay_size<SIZEPLAY_NORMAL)
				size_coeff=16
			if(dir==EAST)
				pixel_x=size_coeff
			else if(dir==WEST)
				pixel_x=size_coeff*-1
			else
				pixel_x=0
		else
			pixel_x=0






/obj/effect/decal/cleanable/remains/vore
	desc = "Looks like someone met a horrible fate getting digested. Gosh how unpleasant. You start thinking about kittens instead." //spicee
	icon = 'icons/effects/blood.dmi'
	icon_state = "remainsvore"
