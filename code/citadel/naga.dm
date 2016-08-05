//Ehh, I'll copy some of the worm code. It will need a lot of changes to work right, though.

/mob/living/simple_animal/naga_segment
	pixel_x=-16
	pixel_y=-16
	icon='icons/mob/special/naga.dmi'
	icon_state="tail"
	name="naga tail"
	density = 0
	anchored=1
	layer=3

	stop_automated_movement = 1
	animate_movement = NO_STEPS

	var/mob/living/simple_animal/naga_segment/previous
	var/mob/living/simple_animal/naga_segment/next

	var/ticks_away = 0
	var/global/next_naga_id=1
	var/id=0
	var/internal_id=0
	var/mob/living/human=null

	speed = -1
	main
		animate_movement = NO_STEPS
		New(var/location, var/segments = 6)
			..()
			id=next_naga_id
			next_naga_id++

			var/mob/living/simple_animal/naga_segment/current = src

			for(var/i = 1 to segments)
				var/mob/living/simple_animal/naga_segment/newSegment = new /mob/living/simple_animal/naga_segment/(loc)
				current.Attach(newSegment)
				current = newSegment
				current.id=id
				current.internal_id=i

	Life()
		..()

		if(human&&loc!=human.loc)
			Move(human.loc)
			if(loc!=human.loc)
				loc=human.loc
				crumple(1)

		if(next && !(next in view(src,1)))
			ticks_away++
			if(ticks_away>2)
				crumple()
		else
			ticks_away=0

		if(stat == DEAD)
			if(next)
				next.previous=null
				next=null

		//move bulges and digest procs here

		update_icon()

		return

	//Delete()
	//	if(previous)
	//		previous.Detach()
	//	..()

	Move()
		var/attachementNextPosition = loc
		if(..())
			if(previous)
				previous.Move(attachementNextPosition)
			update_icon()

	proc/crumple(var/humhead=0)
		if(!humhead)
			loc=next.loc
		if(previous)
			previous.crumple()

	proc/update_icon()
		//if(stat == CONSCIOUS || stat == UNCONSCIOUS)
		if(!istype(loc,/turf/))return
		if(!next&&!previous)
			icon_state="tailSEVERED"
			return
		var/next_d=0
		if(next&&next.loc!=src.loc)
			next_d=get_dir(src,next)
		if(previous)
			var/prev_d=0
			if(previous.loc!=src.loc)
				prev_d=get_dir(src,previous)
			if(next_d==prev_d)
				icon_state="tail0-[prev_d]"
			else if(prev_d<next_d)
				icon_state="tail[prev_d]-[next_d]"
			else
				icon_state="tail[next_d]-[prev_d]"
		else
			icon_state="tail[next_d]" //if 0, blank icon

		//and now, move to top of previous parts
		var/lowest_id=-1
		for(var/mob/living/simple_animal/naga_segment/ns in loc)
			if(ns==src)continue
			if(ns.id!=src.id)continue
			if(lowest_id==-1||ns.internal_id<lowest_id)
				lowest_id=ns.internal_id
		if(internal_id<lowest_id)
			var/turf/T = src.loc
			src.loc = null
			src.loc = T
		return

	proc/Attach(var/mob/living/simple_animal/naga_segment/attachement)
		if(!attachement)
			return

		previous = attachement
		attachement.next = src

		return

	proc/Detach(die = 0)
		//var/mob/living/simple_animal/naga_segment/newHead = new /mob/living/simple_animal/naga_segment/main(loc,0)
		//var/mob/living/simple_animal/naga_segment/newHeadPrevious = previous
		if(next)
			next.previous=null
			next=null

		//newHead.Attach(newHeadPrevious)

		//if(die)
		//	newHead.Die()

		//del(src)