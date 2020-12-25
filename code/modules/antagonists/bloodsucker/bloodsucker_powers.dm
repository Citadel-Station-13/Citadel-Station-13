/datum/action/bloodsucker
	name = "Vampiric Gift"
	desc = "A vampiric gift."
	button_icon = 'icons/mob/actions/bloodsucker.dmi'	//This is the file for the BACKGROUND icon
	background_icon_state = "vamp_power_off"		//And this is the state for the background icon
	var/background_icon_state_on = "vamp_power_on"		// FULP: Our "ON" icon alternative.
	var/background_icon_state_off = "vamp_power_off"	// FULP: Our "OFF" icon alternative.
	icon_icon = 'icons/mob/actions/bloodsucker.dmi'		//This is the file for the ACTION icon
	button_icon_state = "power_feed" 				//And this is the state for the action icon
	buttontooltipstyle = "cult"

	// Action-Related
	//var/amPassive = FALSE		// REMOVED: Just made it its own kind. // Am I just "on" at all times? (aka NO ICON)
	var/amTargetted = FALSE		// Am I asked to choose a target when enabled? (Shows as toggled ON when armed)
	var/amToggle = FALSE		// Can I be actively turned on and off?
	var/amSingleUse = FALSE		// Am I removed after a single use?
	var/active = FALSE
	var/cooldown = 20 		// 10 ticks, 1 second.
	var/cooldownUntil = 0 //  From action.dm:  	next_use_time = world.time + cooldown_time
	// Power-Related
	var/level_current = 0		// Can increase to yield new abilities. Each power goes up in strength each Rank.
	//var/level_max = 1			//
	var/bloodcost = 10
	var/needs_button = TRUE 			// Taken from Changeling - for passive abilities that dont need a button
	var/bloodsucker_can_buy = FALSE 	// Must be a bloodsucker to use this power.
	var/warn_constant_cost = FALSE		// Some powers charge you for staying on. Masquerade, Cloak, Veil, etc.
	var/can_use_in_torpor = FALSE		// Most powers don't function if you're in torpor.
	var/must_be_capacitated = FALSE		// Some powers require you to be standing and ready.
	var/can_be_immobilized = FALSE		// Brawn can be used when incapacitated/laying if it's because you're being immobilized. NOTE: If must_be_capacitated is FALSE, this is irrelevant.
	var/can_be_staked = FALSE			// Only Feed can happen with a stake in you.
	var/cooldown_static = FALSE			// Feed, Masquerade, and One-Shot powers don't improve their cooldown.
	//var/not_bloodsucker = FALSE		// This goes to Vassals or Hunters, but NOT bloodsuckers.
	var/must_be_concious = TRUE			//Can't use this ability while unconcious.

/datum/action/bloodsucker/New()
	if(bloodcost > 0)
		desc += "<br><br><b>COST:</b> [bloodcost] Blood"	// Modify description to add cost.
	if(warn_constant_cost)
		desc += "<br><br><i>Your over-time blood consumption increases while [name] is active.</i>"
	if(amSingleUse)
		desc += "<br><br><i>Useable once per night.</i>"
	..()

//							NOTES
//
// 	click.dm <--- Where we can take over mouse clicks
//	spells.dm  /add_ranged_ability()  <--- How we take over the mouse click to use a power on a target.

/datum/action/bloodsucker/Trigger()
	// Active? DEACTIVATE AND END!
	if(active && CheckCanDeactivate(TRUE))
		DeactivatePower()
		return
	if(!CheckCanPayCost(TRUE) || !CheckCanUse(TRUE))
		return
	PayCost()
	if(amToggle)
		active = !active
		UpdateButtonIcon()
	if(!amToggle || !active)
		StartCooldown() // Must come AFTER UpdateButton(), otherwise icon will revert.
	ActivatePower()  // NOTE: ActivatePower() freezes this power in place until it ends.
	if(active) // Did we not manually disable? Handle it here.
		DeactivatePower()
	if(amSingleUse)
		RemoveAfterUse()

/datum/action/bloodsucker/proc/CheckCanPayCost(display_error)
	if(!owner || !owner.mind)
		return FALSE
	// Cooldown?
	if(cooldownUntil > world.time)
		if(display_error)
			to_chat(owner, "[src] is unavailable. Wait [(cooldownUntil - world.time) / 10] seconds.")
		return FALSE
	// Have enough blood?
	var/mob/living/L = owner
	if(L.blood_volume < bloodcost)
		if(display_error)
			to_chat(owner, "<span class='warning'>You need at least [bloodcost] blood to activate [name]</span>")
		return FALSE
	return TRUE

/datum/action/bloodsucker/proc/CheckCanUse(display_error)	// These checks can be scanned every frame while a ranged power is on.
	if(!owner || !owner.mind)
		return FALSE
	// Torpor?
	if(!can_use_in_torpor && HAS_TRAIT(owner, TRAIT_DEATHCOMA))
		if(display_error)
			to_chat(owner, "<span class='warning'>Not while you're in Torpor.</span>")
		return FALSE
	// Stake?
	if(!can_be_staked && owner.AmStaked())
		if(display_error)
			to_chat(owner, "<span class='warning'>You have a stake in your chest! Your powers are useless.</span>")
		return FALSE
	if(istype(owner.get_item_by_slot(SLOT_NECK), /obj/item/clothing/neck/garlic_necklace))
		if(display_error)
			to_chat(owner, "<span class='warning'The necklace on your neck is interfering with your powers!</span>")
		return FALSE
	if(owner.reagents?.has_reagent(/datum/reagent/consumable/garlic))
		if(display_error)
			to_chat(owner, "<span class='warning'>Garlic in your blood is interfering with your powers!</span>")
		return FALSE
	if(must_be_concious)
		if(owner.stat != CONSCIOUS)
			if(display_error)
				to_chat(owner, "<span class='warning'>You can't do this while you are unconcious!</span>")
			return FALSE
	// Incap?
	if(must_be_capacitated)
		var/mob/living/L = owner
		if (L.incapacitated(TRUE, TRUE) || !CHECK_MOBILITY(L, MOBILITY_STAND) && !can_be_immobilized)
			if(display_error)
				to_chat(owner, "<span class='warning'>Not while you're incapacitated!</span>")
			return FALSE
	// Constant Cost (out of blood)
	if(warn_constant_cost)
		var/mob/living/L = owner
		if(L.blood_volume <= 0)
			if(display_error)
				to_chat(owner, "<span class='warning'>You don't have the blood to upkeep [src].</span>")
			return FALSE
	return TRUE

/datum/action/bloodsucker/proc/StartCooldown()
	set waitfor = FALSE
	// Alpha Out
	button.color = rgb(128,0,0,128)
	button.alpha = 100
	// Calculate Cooldown (by power's level)
	var/this_cooldown = (cooldown_static || amSingleUse) ? cooldown : max(cooldown / 2, cooldown - (cooldown / 16 * (level_current-1)))
	// NOTE: With this formula, you'll hit half cooldown at level 8 for that power.

	// Wait for cooldown
	cooldownUntil = world.time + this_cooldown
	spawn(this_cooldown)
		// Alpha In
		button.color = rgb(255,255,255,255)
		button.alpha = 255

/datum/action/bloodsucker/proc/CheckCanDeactivate(display_error)
	return TRUE

/datum/action/bloodsucker/UpdateButtonIcon(force = FALSE)
	background_icon_state = active? background_icon_state_on : background_icon_state_off
	..()//UpdateButtonIcon()


/datum/action/bloodsucker/proc/PayCost()
	// owner for actions is the mob, not mind.
	var/mob/living/L = owner
	L.blood_volume -= bloodcost


/datum/action/bloodsucker/proc/ActivatePower()


/datum/action/bloodsucker/proc/DeactivatePower(mob/living/user = owner, mob/living/target)
	active = FALSE
	UpdateButtonIcon()
	StartCooldown()

/datum/action/bloodsucker/proc/ContinueActive(mob/living/user, mob/living/target) // Used by loops to make sure this power can stay active.
	return active && user && (!warn_constant_cost || user.blood_volume > 0)

/datum/action/bloodsucker/proc/RemoveAfterUse()
	// Un-Learn Me! (GO HOME
	var/datum/antagonist/bloodsucker/bloodsuckerdatum = owner.mind.has_antag_datum(ANTAG_DATUM_BLOODSUCKER)
	if (istype(bloodsuckerdatum))
		bloodsuckerdatum.powers -= src
	Remove(owner)

/datum/action/bloodsucker/proc/Upgrade()
	level_current ++

///////////////////////////////////  PASSIVE POWERS	///////////////////////////////////

// New Type: Passive (Always on, no button)
/datum/action/bloodsucker/passive

/datum/action/bloodsucker/passive/New()
	// REMOVED: DO NOTHBING!
	..()
	// Don't Display Button! (it doesn't do anything anyhow)
	button.screen_loc = DEFAULT_BLOODSPELLS
	button.moved = DEFAULT_BLOODSPELLS
	button.ordered = FALSE

/datum/action/bloodsucker/passive/Destroy()
	if(owner)
		Remove(owner)
	target = null
	return ..()

///////////////////////////////////  TARGETTED POWERS	///////////////////////////////////

/datum/action/bloodsucker/targeted
	// NOTE: All Targeted spells are Toggles! We just don't bother checking here.
	var/target_range = 99
	var/message_Trigger = "Select a target."
	var/obj/effect/proc_holder/bloodsucker/bs_proc_holder
	var/power_activates_immediately = TRUE	// Most powers happen the moment you click. Some, like Mesmerize, require time and shouldn't cost you if they fail.

	var/power_in_use = FALSE // Is this power LOCKED due to being used?

/datum/action/bloodsucker/targeted/New(Target)
	desc += "<br>\[<i>Targeted Power</i>\]"	// Modify description to add notice that this is aimed.
	..()
	// Create Proc Holder for intercepting clicks
	bs_proc_holder = new ()
	bs_proc_holder.linked_power = src

// Click power: Begin Aim
/datum/action/bloodsucker/targeted/Trigger()
	if(active && CheckCanDeactivate(TRUE))
		DeactivateRangedAbility()
		DeactivatePower()
		return
	if(!CheckCanPayCost(TRUE) || !CheckCanUse(TRUE))
		return
	active = !active
	UpdateButtonIcon()
	// Create & Link Targeting Proc
	var/mob/living/L = owner
	if(L.ranged_ability)
		L.ranged_ability.remove_ranged_ability()
	bs_proc_holder.add_ranged_ability(L)

	if(message_Trigger != "")
		to_chat(owner, "<span class='announce'>[message_Trigger]</span>")

/datum/action/bloodsucker/targeted/CheckCanUse(display_error)
	. = ..()
	if(!.)
		return
	if(!owner.client)	// <--- We don't allow non client usage so that using powers like mesmerize will FAIL if you try to use them as ghost. Why? because ranged_abvility in spell.dm
		return FALSE	//		doesn't let you remove powers if you're not there. So, let's just cancel the power entirely.
	return TRUE

/datum/action/bloodsucker/targeted/DeactivatePower(mob/living/user = owner, mob/living/target)
	// Don't run ..(), we don't want to engage the cooldown until we USE this power!
	active = FALSE
	UpdateButtonIcon()

/datum/action/bloodsucker/targeted/proc/DeactivateRangedAbility()
	// Only Turned off when CLICK is disabled...aka, when you successfully clicked (or
	bs_proc_holder.remove_ranged_ability()

// Check if target is VALID (wall, turf, or character?)
/datum/action/bloodsucker/targeted/proc/CheckValidTarget(atom/A)
	return FALSE // FALSE targets nothing.

// Check if valid target meets conditions
/datum/action/bloodsucker/targeted/proc/CheckCanTarget(atom/A, display_error)
	// Out of Range
	if(!(A in view(target_range, owner)))
		if(display_error && target_range > 1) // Only warn for range if it's greater than 1. Brawn doesn't need to announce itself.
			to_chat(owner, "<span class='warning'>Your target is out of range.</span>")
		return FALSE
	return istype(A)

// Click Target
/datum/action/bloodsucker/targeted/proc/ClickWithPower(atom/A)
	// CANCEL RANGED TARGET check
	if(power_in_use || !CheckValidTarget(A))
		return FALSE
	// Valid? (return true means DON'T cancel power!)
	if(!CheckCanPayCost(TRUE) || !CheckCanUse(TRUE) || !CheckCanTarget(A, TRUE))
		return TRUE
	// Skip this part so we can return TRUE right away.
	if(power_activates_immediately)
		PowerActivatedSuccessfully() // Mesmerize pays only after success.
	power_in_use = TRUE	 // Lock us into this ability until it successfully fires off. Otherwise, we pay the blood even if we fail.
	FireTargetedPower(A) // We use this instead of ActivatePower(), which has no input
	power_in_use = FALSE
	return TRUE

/datum/action/bloodsucker/targeted/proc/FireTargetedPower(atom/A)
	// Like ActivatePower, but specific to Targeted (and takes an atom input). We don't use ActivatePower for targeted.

/datum/action/bloodsucker/targeted/proc/PowerActivatedSuccessfully()
	// The power went off! We now pay the cost of the power.
	PayCost()
	DeactivateRangedAbility()
	DeactivatePower()
	StartCooldown()	// Do AFTER UpdateIcon() inside of DeactivatePower. Otherwise icon just gets wiped.

/datum/action/bloodsucker/targeted/ContinueActive(mob/living/user, mob/living/target) // Used by loops to make sure this power can stay active.
	return ..()
// Target Proc Holder
/obj/effect/proc_holder/bloodsucker
	var/datum/action/bloodsucker/targeted/linked_power

/obj/effect/proc_holder/bloodsucker/remove_ranged_ability(msg)
	..()
	linked_power.DeactivatePower()

/obj/effect/proc_holder/bloodsucker/InterceptClickOn(mob/living/caller, params, atom/A)
	return linked_power.ClickWithPower(A)
