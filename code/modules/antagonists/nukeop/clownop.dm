
/datum/antagonist/nukeop/clownop
	name = "Clown Operative"
	roundend_category = "clown operatives"
	antagpanel_category = "ClownOp"
	threat = 7
	nukeop_outfit = /datum/outfit/syndicate/clownop

/datum/antagonist/nukeop/clownop/on_gain()
	. = ..()
	ADD_TRAIT(owner, TRAIT_CLOWN_MENTALITY, CLOWNOP_TRAIT)

/datum/antagonist/nukeop/clownop/on_removal()
	REMOVE_TRAIT(owner, TRAIT_CLOWN_MENTALITY, CLOWNOP_TRAIT)
	return ..()

/datum/antagonist/nukeop/leader/clownop
	name = "Clown Operative Leader"
	roundend_category = "clown operatives"
	antagpanel_category = "ClownOp"
	nukeop_outfit = /datum/outfit/syndicate/clownop/leader

/datum/antagonist/nukeop/leader/clownop/give_alias()
	title = pick("Head Honker", "Slipmaster", "Clown King", "Honkbearer")
	if(nuke_team && nuke_team.syndicate_name)
		owner.current.real_name = "[nuke_team.syndicate_name] [title]"
	else
		owner.current.real_name = "Syndicate [title]"

/datum/antagonist/nukeop/clownop/admin_add(datum/mind/new_owner,mob/admin)
	new_owner.assigned_role = "Clown Operative"
	new_owner.add_antag_datum(src)
	message_admins("[key_name_admin(admin)] has clown op'ed [new_owner.current].")
	log_admin("[key_name(admin)] has clown op'ed [new_owner.current].")
