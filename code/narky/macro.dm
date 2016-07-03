var/const/SIZEPLAY_TINY=1
var/const/SIZEPLAY_MICRO=2
var/const/SIZEPLAY_NORMAL=3
var/const/SIZEPLAY_MACRO=4
var/const/SIZEPLAY_HUGE=5

/mob/living
	var/sizeplay_size=SIZEPLAY_NORMAL

	proc
		sizeplay_set(var/newsize)
			if(!istype(src,/mob/living/carbon))
				if(newsize<initial(src.sizeplay_size) || newsize>initial(src.sizeplay_size)+1)
					return
				if(newsize==initial(src.sizeplay_size))
					//src.transform=get_matrix_norm()
					//src.pixel_y=0
					stable_matrix(get_matrix_norm(),0)
					src.sizeplay_size=newsize
					return
				else if(newsize>initial(src.sizeplay_size))
					//src.transform=get_matrix_large()
					//src.pixel_y=16
					stable_matrix(get_matrix_large(),8)
					src.sizeplay_size=newsize
					return
				return //Paranoid returns

			else if(newsize==SIZEPLAY_TINY)
				//src.transform=get_matrix_smallest()
				//src.pixel_y=-8
				stable_matrix(get_matrix_smallest(),-8)
				src.sizeplay_size=newsize
			else if(newsize==SIZEPLAY_MICRO)
				//src.transform=get_matrix_small()
				//src.pixel_y=-8
				stable_matrix(get_matrix_small(),-4)
				src.sizeplay_size=newsize
			else if(newsize==SIZEPLAY_MACRO)
				//src.transform=get_matrix_large()
				//src.pixel_y=16
				stable_matrix(get_matrix_large(),8)
				src.sizeplay_size=newsize
			else if(newsize==SIZEPLAY_HUGE) // Huge should be the largest size
				// removed these comments
				// not being used anyway
				stable_matrix(get_matrix_largest(),16)
				src.sizeplay_size=newsize
			else
				//src.transform=get_matrix_norm()
				//src.pixel_y=0
				stable_matrix(get_matrix_norm(),0)
				src.sizeplay_size=SIZEPLAY_NORMAL
		//	src.updateappearance
		sizeplay_shrink()
			//if(!istype(src,/mob/living/carbon))
			//	return
			if(sizeplay_size>SIZEPLAY_TINY)
				src.sizeplay_set(sizeplay_size-1)
				for(var/mob/living/M in src.stomach_contents)
					M.sizeplay_shrink()
		sizeplay_grow()
			//if(!istype(src,/mob/living/carbon))
			//	return
			if(sizeplay_size<SIZEPLAY_HUGE)
				src.sizeplay_set(sizeplay_size+1)
				for(var/mob/living/M in src.stomach_contents)
					M.sizeplay_grow()

		stable_matrix(var/matrix/sze,var/pixel_en)
			sze.TurnTo(0,lying)
			animate(src, transform = sze, time = 4, pixel_y = pixel_en, easing = EASE_IN|EASE_OUT)




/mob/living/simple_animal/lizard/sizeplay_size=SIZEPLAY_MICRO
/mob/living/simple_animal/mouse/sizeplay_size=SIZEPLAY_MICRO




//var/matrix/transform_small=new().Scale(0.5)
//var/matrix/transform_norm=new()
//var/matrix/transform_large=new().Scale(2)
/proc/get_matrix_largest()
	var/matrix/mtrx=new()
	return mtrx.Scale(2)
/proc/get_matrix_large()
	var/matrix/mtrx=new()
	return mtrx.Scale(1.5)
/proc/get_matrix_norm()
	var/matrix/mtrx=new()
	return mtrx
/proc/get_matrix_small()
	var/matrix/mtrx=new()
	return mtrx.Scale(0.7)
/proc/get_matrix_smallest()
	var/matrix/mtrx=new()
	return mtrx.Scale(0.5)


/obj/item/projectile/sizeray
	name = "mystery beam"
	icon_state = "omnilaser"
	hitsound = null
	damage = 0
	damage_type = STAMINA
	flag = "laser"
	pass_flags = PASSTABLE | PASSGLASS | PASSGRILLE

/obj/item/projectile/sizeray/shrinkray/icon_state="bluelaser"
/obj/item/projectile/sizeray/growthray/icon_state="laser"

/obj/item/ammo_casing/energy/laser/growthray
	projectile_type = /obj/item/projectile/sizeray/growthray
	select_name = "redray"

/obj/item/ammo_casing/energy/laser/shrinkray
	projectile_type = /obj/item/projectile/sizeray/shrinkray
	select_name = "blueray"

/obj/item/projectile/sizeray/shrinkray/on_hit(var/atom/target, var/blocked = 0)
	if(istype(target, /mob/living))
		var/mob/living/M=target
		M.sizeplay_shrink()
	return 1

/obj/item/projectile/sizeray/growthray/on_hit(var/atom/target, var/blocked = 0)
	if(istype(target, /mob/living))
		var/mob/living/M=target
		M.sizeplay_grow()
	return 1




//Gun here
/obj/item/weapon/gun/energy/laser/sizeray
	name = "mystery raygun"
	icon_state = "bluetag"
	desc = "This will be fun!"
	ammo_type = list(/obj/item/ammo_casing/energy/laser/shrinkray)
	origin_tech = "combat=1;magnets=2"
	clumsy_check = 0
	var/charge_tick = 0

	//special_check(var/mob/living/carbon/human/M)
		//return 1

	New()
		..()
		SSobj.processing |= src


	Destroy()
		SSobj.processing.Remove(src)
		..()


	process()
		charge_tick++
		if(charge_tick < 4) return 0
		charge_tick = 0
		if(!power_supply) return 0
		power_supply.give(100)
		update_icon()
		return 1

	attackby(obj/item/W, mob/user)
		if(W==src)
			if(icon_state=="bluetag")
				icon_state="redtag"
				ammo_type = list(/obj/item/ammo_casing/energy/laser/growthray)
			else
				icon_state="bluetag"
				ammo_type = list(/obj/item/ammo_casing/energy/laser/shrinkray)
		return ..()


/obj/item/weapon/gun/energy/laser/sizeray/one
	name="shrink ray"
/obj/item/weapon/gun/energy/laser/sizeray/two
	name="growth ray"
	icon_state = "redtag"
	ammo_type = list(/obj/item/ammo_casing/energy/laser/growthray)


///////////////////////
//PIXEL_Y UPDATE PROC//
///////////////////////
/*
/mob/update_pixel_y(mob/living/user)
	..()
	var/final_pixel_y = null
	var/matrix/mtrx=new()
	if(mtrx.Scale(0.5))
		pixel_y = -8
		final_pixel_y = -8
		return
	if(mtrx.Scale(0.7))
		pixel_y = -4
		final_pixel_y = -4
		return
	if(mtrx.Scale(1))
		pixel_y = 0
		final_pixel_y = 0
		return
	if(mtrx.Scale(1.5))
		pixel_y = 8
		final_pixel_y = 8
		return
	if(mtrx.Scale(2))
		pixel_y = 16
		final_pixel_y = 16
		return
	else
		pixel_y = 0 //just in case you somehow ended up with some other size we'll put you back to normal
		return
*/