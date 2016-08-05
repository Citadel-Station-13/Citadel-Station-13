var/const/COLOUR_LIST_SIZE=4

proc/sanitize_colour_list(var/list/lst=null)
	if(!lst||!lst.len)
		lst=new/list(COLOUR_LIST_SIZE)
	if(lst.len!=COLOUR_LIST_SIZE)
		var/new_lst[COLOUR_LIST_SIZE]
		for(var/x=1,x<=COLOUR_LIST_SIZE,x++)
			new_lst[x]=lst[x]
		lst=new_lst
	return lst

proc/generate_colour_icon(var/fil_chk=null,var/state=null,var/list/lst=null,var/add_layer=0,var/offset_x=0,var/offset_y=0,var/overlay_only=0,var/human=0)
	if(!fil_chk||!state)return null
	lst=sanitize_colour_list(lst)
	var/icon/chk=new/icon(fil_chk)
	var/list/available_states=chk.IconStates()
	var/list/rtn_lst = list()
	if(!overlay_only&&available_states.Find("[state]"))
		rtn_lst += image("icon"=fil_chk, "icon_state"="[state]", "pixel_y"=offset_y, "pixel_x"=offset_x, "layer"=add_layer)
	var/chk_len=human ? 1 : lst.len
	for(var/x=1,x<=chk_len,x++)
		if(!lst[x]&&!human)continue
		var/state_check="[state]_[x]"
		if(x==1)
			if(human)
				state_check="[state]_h"
			else
				if(!available_states.Find("[state_check]"))
					state_check="[state]_h"
		if(available_states.Find("[state_check]"))
			var/image/colourized = image("icon"=fil_chk, "icon_state"="[state_check]", "pixel_y"=offset_y, "pixel_x"=offset_x, "layer"=add_layer)
			var/new_color = "#" + "[human ? human : lst[x]]"
			colourized.color = new_color
			rtn_lst += colourized
	return rtn_lst

/mob/living/carbon/human/var/heterochromia=0

/datum/dna
	var/mutanttail	//Narky code~
	var/mutantwing
	var/wingcolor="FFF"
	var/special_color[COLOUR_LIST_SIZE]
	var/global/const/COCK_NONE=0
	var/global/const/COCK_NORMAL=1
	var/global/const/COCK_HYPER=2
	var/global/const/COCK_DOUBLE=3
	var/list/cock=list("has"=COCK_NONE,"type"="human","color"="900")
	var/vagina=0
	var/datum/special_mutant/special
	var/taur=0 //TEMP!
	var/mob/living/simple_animal/naga_segment/naga=null //ALSO TEMP!
/*	proc/generateExtraData()
		var/list/EDL=list(
		"race"=mutantrace,
		"tail"=mutanttail,
		"sc"=special_color,
		"cock"=cock,
		"vagina"=vagina)
		return EDL
	proc/addExtraData(var/list/EDL, var/setit=0)
		if(EDL["race"]||setit)
			mutantrace=EDL["race"]
		if(EDL["tail"]||setit)
			mutanttail=EDL["tail"]
		if(EDL["sc"]||setit)
			special_color=EDL["sc"]
		if(EDL["cock"]||setit)
			cock=EDL["cock"]
		if(!isnull(EDL["vagina"])||setit)
			vagina=EDL["vagina"]*

	proc/setExtraData(var/list/EDL)*/







/datum/special_mutant
	proc/generate_overlay()
		return 0
	proc/generate_underlay()
		return 0


/datum/dna/proc/mutantrace() //Easy legacy support!
	if(species)
		return species.id
	else
		return "human"

/datum/dna/proc/generate_race_block()
	var/block_gen="fff"
	if(species_list[mutantrace()])
		//block_gen = construct_block(species_list.Find(mutantrace), species_list.len+1)
		block_gen = construct_block(species_list.Find(species.id), species_list.len+1)
	else
		block_gen = construct_block(species_list.len+1, species_list.len+1)
	return block_gen

/mob/living/proc/set_mutantrace(var/new_mutantrace=null)
	new_mutantrace=kpcode_race_san(new_mutantrace)
	var/datum/dna/dna=has_dna(src)
	if(!dna)return
	if(new_mutantrace)
		//dna.mutantrace=new_mutantrace
		if(species_list.Find(new_mutantrace))
			//var/typ=species_list[species_list.Find(dna.species.id)]
			//dna.species=new typ()
			dna.species=kpcode_race_get(new_mutantrace)
	dna.uni_identity = setblock(dna.uni_identity, DNA_MUTANTRACE_BLOCK, dna.generate_race_block())
	regenerate_icons()


/datum/dna/proc/generate_cock_block()
	var/cock_block=0
	if(cock["has"])
		cock_block+=1
	if(vagina)
		cock_block+=2
	return construct_block(cock_block+1, 4)

/mob/living/proc/set_cock_block()
	var/datum/dna/dna=has_dna(src)
	if(!dna)return
	dna.uni_identity = setblock(dna.uni_identity, DNA_COCK_BLOCK, dna.generate_cock_block())


/mob/living/proc/is_taur()
	if(istype(src,/mob/living/carbon/human)&&src:dna&&src:dna:taur)
		if(src:dna:species&&kpcode_cantaur(src:dna:species))
			return 1
	return 0