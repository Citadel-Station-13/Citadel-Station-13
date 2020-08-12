/datum/component/bouncy
	dupe_mode = COMPONENT_DUPE_UNIQUE_PASSARGS
	var/bouncy_mod = 1
	var/list/bounce_signals = list(COMSIG_MOVABLE_IMPACT, COMSIG_ITEM_HIT_REACT, COMSIG_ITEM_ATTACK)

/datum/component/bouncy/Initialize(_bouncy_mod, list/_bounce_signals)
	if(!ismovable(parent))
		return COMPONENT_INCOMPATIBLE
	if(_bouncy_mod)
		bouncy_mod = _bouncy_mod
	if(_bounce_signals)
		bounce_signals = _bounce_signals

/datum/component/bouncy/InheritComponent(datum/component/bouncy/B, original, _bouncy_mod, list/_bounce_signals)
	if(_bouncy_mod)
		bouncy_mod = max(bouncy_mod, _bouncy_mod)
	if(_bounce_signals)
		var/list/diff_bounces = difflist(bounce_signals, _bounce_signals, TRUE)
		for(var/bounce in diff_bounces)
			bounce_signals += bounce
			RegisterSignal(parent, bounce, .proc/bounce_up)

/datum/component/bouncy/RegisterWithParent()
	. = ..()
	RegisterSignal(parent, bounce_signals, .proc/bounce_up)

/datum/component/bouncy/UnregisterFromParent()
	. = ..()
	UnregisterSignal(parent, bounce_signals)

/datum/component/bouncy/proc/bounce_up(datum/source)
	var/atom/movable/A = parent
	switch(rand(1, 3))
		if(1)
			A.do_jiggle(45 + rand(-10, 10) * bouncy_mod, 14)
		if(2)
			var/min_b = 0.6/bouncy_mod
			var/max_b = 1.2 * bouncy_mod
			A.do_squish(rand(min_b, max_b), rand(min_b, max_b), 14)
		if(3)
			var/pixelshift = 8 * bouncy_mod
			A.Shake(pixelshift, pixelshift, duration = 15)
