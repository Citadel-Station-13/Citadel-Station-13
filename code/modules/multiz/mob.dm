// Includes things like negating gravity/being able to move up against gravity/etc, misc checks
/mob
	/// Climbing up
	var/zclimbing = FALSE

// verbs first
/mob/verb/up()
	set name = "Move Upwards"
	set category = "IC"

	if(ZMove(UP, null, TRUE))
		to_chat(src, "<span class='notice'>You move upwards.</span>")

/mob/verb/down()
	set name = "Move Down"
	set category = "IC"

	if(ZMove(DOWN, null, TRUE))
		to_chat(src, "<span class='notice'>You move down.</span>")

/mob/CanZFall(levels, fall_flags)
	. = ..()
	if(mob_overcomes_gravity())
		return . | FALL_RECOVERED
	#warn climbing/magboots

/mob/ProcessZMove(gravity, visible, silent, allow_blocking_actions, force)
	. = ..()
	#warn check: nograv. if nograv, allow just negate grav/spacemove as weell as the others.
	#warn otherwise, only allow overcome gravity and climb.
	if(dir == UP)
		return ProcessZClimb()
	#warn gravity vs nograv
	if(dir == UP)
		if(mob_overcomes_gravity())
			visible_message
		#warn climbing

/mob/proc/GetZClimbTargets()

/mob/ProcessZClimb(gravity, visible, silent, allow_blocking_actions, force)

/mob/living/TakeFallDamage(amount, levels = 1)
	take_overall_damage(amount)
