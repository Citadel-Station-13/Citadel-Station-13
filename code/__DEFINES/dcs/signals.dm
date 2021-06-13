// All signals. Format:
// When the signal is called: (signal arguments)
// All signals send the source datum of the signal as the first argument

// global signals
// These are signals which can be listened to by any component on any parent
// start global signals with "!", this used to be necessary but now it's just a formatting choice
/// from base of datum/controller/subsystem/mapping/proc/add_new_zlevel(): (list/args)
#define COMSIG_GLOB_NEW_Z "!new_z"
/// called after a successful var edit somewhere in the world: (list/args)
#define COMSIG_GLOB_VAR_EDIT "!var_edit"
/// called after an explosion happened : (epicenter, devastation_range, heavy_impact_range, light_impact_range, took, orig_dev_range, orig_heavy_range, orig_light_range)
#define COMSIG_GLOB_EXPLOSION "!explosion"
/// mob was created somewhere : (mob)
#define COMSIG_GLOB_MOB_CREATED "!mob_created"
/// mob died somewhere : (mob , gibbed)
#define COMSIG_GLOB_MOB_DEATH "!mob_death"
/// global living say plug - use sparingly: (mob/speaker , message)
#define COMSIG_GLOB_LIVING_SAY_SPECIAL "!say_special"
/// called by datum/cinematic/play() : (datum/cinematic/new_cinematic)
#define COMSIG_GLOB_PLAY_CINEMATIC "!play_cinematic"
	#define COMPONENT_GLOB_BLOCK_CINEMATIC 1

// signals from globally accessible objects
/// from SSsun when the sun changes position : (primary_sun, suns)
#define COMSIG_SUN_MOVED "sun_moved"

/// from SSactivity for things that add threat but aren't "global" (e.g. phylacteries)
#define COMSIG_THREAT_CALC "threat_calculation"

//////////////////////////////////////////////////////////////////

// /datum signals
/// when a component is added to a datum: (/datum/component)
#define COMSIG_COMPONENT_ADDED "component_added"
/// before a component is removed from a datum because of RemoveComponent: (/datum/component)
#define COMSIG_COMPONENT_REMOVING "component_removing"
/// before a datum's Destroy() is called: (force), returning a nonzero value will cancel the qdel operation
#define COMSIG_PARENT_PREQDELETED "parent_preqdeleted"
/// just before a datum's Destroy() is called: (force), at this point none of the other components chose to interrupt qdel and Destroy will be called
#define COMSIG_PARENT_QDELETING "parent_qdeleting"
/// generic topic handler (usr, href_list)
#define COMSIG_TOPIC "handle_topic"

/// fires on the target datum when an element is attached to it (/datum/element)
#define COMSIG_ELEMENT_ATTACH "element_attach"
/// fires on the target datum when an element is attached to it  (/datum/element)
#define COMSIG_ELEMENT_DETACH "element_detach"

/// sent to the component itself when unregistered from a parent
#define COMSIG_COMPONENT_UNREGISTER_PARENT "component_unregister_parent"
/// sent to the component itself when registered to a parent
#define COMSIG_COMPONENT_REGISTER_PARENT "component_register_parent"

/// Trait signals
#define COMPONENT_ADD_TRAIT (1<<0)
#define COMPONENT_REMOVE_TRAIT (1<<1)

// /atom signals
//from base of atom/proc/Initialize(): sent any time a new atom is created
#define COMSIG_ATOM_CREATED "atom_created"
//from SSatoms InitAtom - Only if the  atom was not deleted or failed initialization
#define COMSIG_ATOM_AFTER_SUCCESSFUL_INITIALIZE "atom_init_success"
#define COMSIG_PARENT_ATTACKBY "atom_attackby"			        //from base of atom/attackby(): (/obj/item, /mob/living, params)
	#define COMPONENT_NO_AFTERATTACK 1								//Return this in response if you don't want afterattack to be called
#define COMSIG_ATOM_HULK_ATTACK "hulk_attack"					//from base of atom/attack_hulk(): (/mob/living/carbon/human)
#define COMSIG_ATOM_ATTACK_ANIMAL "attack_animal"				//from base of atom/animal_attack(): (/mob/user)
#define COMSIG_PARENT_EXAMINE "atom_examine"                    //from base of atom/examine(): (/mob, list/examine_return_text)
///from base of atom/get_examine_name(): (/mob, list/overrides)
#define COMSIG_ATOM_GET_EXAMINE_NAME "atom_examine_name"
#define COMSIG_PARENT_EXAMINE_MORE "atom_examine_more"                    ///from base of atom/examine_more(): (/mob)
	//Positions for overrides list
	#define EXAMINE_POSITION_ARTICLE (1<<0)
	#define EXAMINE_POSITION_BEFORE (1<<1)
	//End positions
	#define COMPONENT_EXNAME_CHANGED (1<<0)
#define COMSIG_ATOM_UPDATE_ICON "atom_update_icon"				//from base of atom/update_icon(): ()
	#define COMSIG_ATOM_NO_UPDATE_ICON_STATE 1
	#define COMSIG_ATOM_NO_UPDATE_OVERLAYS		2
#define COMSIG_ATOM_UPDATE_OVERLAYS "atom_update_overlays"		//from base of atom/update_overlays(): (list/new_overlays)
#define COMSIG_ATOM_UPDATED_ICON "atom_updated_icon"			//from base of atom/update_icon(): (signalOut, did_anything)
#define COMSIG_ATOM_ENTERED "atom_entered"                      //from base of atom/Entered(): (atom/movable/entering, /atom)
#define COMSIG_ATOM_EXIT "atom_exit"							//from base of atom/Exit(): (/atom/movable/exiting, /atom/newloc)
	#define COMPONENT_ATOM_BLOCK_EXIT 1
#define COMSIG_ATOM_EXITED "atom_exited"						//from base of atom/Exited(): (atom/movable/exiting, atom/newloc)
/// From base of atom/wave_ex_act(): (datum/wave_explosion/explosion, args)
#define COMSIG_ATOM_WAVE_EX_ACT "atom_wave_ex_act"
///from base of atom/ex_act(): (severity, target)
#define COMSIG_ATOM_EX_ACT "atom_ex_act"
///from base of atom/emp_act(): (severity)
#define COMSIG_ATOM_EMP_ACT "atom_emp_act"
///from base of atom/fire_act(): (exposed_temperature, exposed_volume)
#define COMSIG_ATOM_FIRE_ACT "atom_fire_act"
///from base of atom/bullet_act(): (/obj/item/projectile, def_zone)
#define COMSIG_ATOM_BULLET_ACT "atom_bullet_act"
///from base of atom/blob_act(): (/obj/structure/blob)
#define COMSIG_ATOM_BLOB_ACT "atom_blob_act"
///from base of atom/acid_act(): (acidpwr, acid_volume)
#define COMSIG_ATOM_ACID_ACT "atom_acid_act"
///from base of atom/emag_act(): (/mob/user)
#define COMSIG_ATOM_EMAG_ACT "atom_emag_act"
///from base of atom/rad_act(intensity)
#define COMSIG_ATOM_RAD_ACT "atom_rad_act"
///from base of atom/narsie_act(): ()
#define COMSIG_ATOM_NARSIE_ACT "atom_narsie_act"
///from base of atom/ratvar_act(): ()
#define COMSIG_ATOM_RATVAR_ACT "atom_ratvar_act"
///from base of atom/rcd_act(): (/mob, /obj/item/construction/rcd, passed_mode)
#define COMSIG_ATOM_RCD_ACT "atom_rcd_act"
///from base of atom/singularity_pull(): (S, current_size)
#define COMSIG_ATOM_SING_PULL "atom_sing_pull"
///from obj/machinery/bsa/full/proc/fire(): ()
#define COMSIG_ATOM_BSA_BEAM "atom_bsa_beam_pass"
	#define COMSIG_ATOM_BLOCKS_BSA_BEAM (1<<0)
///from base of atom/set_light(): (l_range, l_power, l_color)
#define COMSIG_ATOM_SET_LIGHT "atom_set_light"
///from base of atom/setDir(): (old_dir, new_dir). Called before the direction changes.
#define COMSIG_ATOM_DIR_CHANGE "atom_dir_change"
///from base of atom/handle_atom_del(): (atom/deleted)
#define COMSIG_ATOM_CONTENTS_DEL "atom_contents_del"
///from base of atom/has_gravity(): (turf/location, list/forced_gravities)
#define COMSIG_ATOM_HAS_GRAVITY "atom_has_gravity"
///from proc/get_rad_contents(): ()
#define COMSIG_ATOM_RAD_PROBE "atom_rad_probe"
	#define COMPONENT_BLOCK_RADIATION (1<<0)
///from base of datum/radiation_wave/radiate(): (strength)
#define COMSIG_ATOM_RAD_CONTAMINATING "atom_rad_contam"
	#define COMPONENT_BLOCK_CONTAMINATION (1<<0)
///from base of datum/radiation_wave/check_obstructions(): (datum/radiation_wave, width)
#define COMSIG_ATOM_RAD_WAVE_PASSING "atom_rad_wave_pass"
  #define COMPONENT_RAD_WAVE_HANDLED (1<<0)
///from internal loop in atom/movable/proc/CanReach(): (list/next)
#define COMSIG_ATOM_CANREACH "atom_can_reach"
	#define COMPONENT_BLOCK_REACH (1<<0)

#define COMSIG_ATOM_SCREWDRIVER_ACT "atom_screwdriver_act"		//from base of atom/screwdriver_act(): (mob/living/user, obj/item/I)
#define COMSIG_ATOM_INTERCEPT_TELEPORT "intercept_teleport"		//called when teleporting into a protected turf: (channel, turf/origin, turf/destination)
	#define COMPONENT_BLOCK_TELEPORT 1
#define COMSIG_ATOM_HEARER_IN_VIEW "atom_hearer_in_view"		//called when an atom with HEAR_1 is added to the hearers on /proc/get_hearers_in_view(): (list/processing_list, list/hearers)
/////////////////
#define COMSIG_ATOM_ATTACK_GHOST "atom_attack_ghost"			//from base of atom/attack_ghost(): (mob/dead/observer/ghost)
#define COMSIG_ATOM_ATTACK_HAND "atom_attack_hand"				//from base of atom/attack_hand(): (mob/user)
#define COMSIG_ATOM_ATTACK_PAW "atom_attack_paw"				//from base of atom/attack_paw(): (mob/user)
	#define COMPONENT_NO_ATTACK_HAND 1							//works on all 3.
/////////////////

//This signal return value bitflags can be found in __DEFINES/misc.dm
#define COMSIG_ATOM_INTERCEPT_Z_FALL "movable_intercept_z_impact"	//called for each movable in a turf contents on /turf/zImpact(): (atom/movable/A, levels)

/// Called from orbit component: (atom/movable/orbiter, radius, clockwise, rotation_speed, rotation_segments, pre_rotation)
#define COMSIG_ATOM_ORBIT_BEGIN "atom_orbit_begin"
/// Called from orbit component: (atom/movable/orbiter, refreshing)
#define COMSIG_ATOM_ORBIT_END "atom_orbit_end"

#define COMSIG_ENTER_AREA "enter_area" 						//from base of area/Entered(): (/area)
#define COMSIG_EXIT_AREA "exit_area" 							//from base of area/Exited(): (/area)

#define COMSIG_CLICK "atom_click"								//from base of atom/Click(): (location, control, params, mob/user)
#define COMSIG_CLICK_SHIFT "shift_click"						//from base of atom/ShiftClick(): (/mob), return flags also used by other signals.
	#define COMPONENT_ALLOW_EXAMINATE 1
	#define COMPONENT_DENY_EXAMINATE 2 //Higher priority compared to the above one

#define COMSIG_CLICK_CTRL "ctrl_click"							//from base of atom/CtrlClickOn(): (/mob)
#define COMSIG_CLICK_ALT "alt_click"							//from base of atom/AltClick(): (/mob)
#define COMSIG_CLICK_CTRL_SHIFT "ctrl_shift_click"				//from base of atom/CtrlShiftClick(/mob)
#define COMSIG_MOUSEDROP_ONTO "mousedrop_onto"					//from base of atom/MouseDrop(): (/atom/over, /mob/user)
	#define COMPONENT_NO_MOUSEDROP 1
#define COMSIG_MOUSEDROPPED_ONTO "mousedropped_onto"			//from base of atom/MouseDrop_T: (/atom/from, /mob/user)

// /area signals
#define COMSIG_AREA_ENTERED "area_entered" 						//from base of area/Entered(): (atom/movable/M)
#define COMSIG_AREA_EXITED "area_exited" 							//from base of area/Exited(): (atom/movable/M)

// /turf signals

///from base of turf/ChangeTurf(): (path, list/new_baseturfs, flags, list/transferring_comps)
#define COMSIG_TURF_CHANGE "turf_change"
///from base of atom/has_gravity(): (atom/asker, list/forced_gravities)
#define COMSIG_TURF_HAS_GRAVITY "turf_has_gravity"
///from base of turf/multiz_turf_del(): (turf/source, direction)
#define COMSIG_TURF_MULTIZ_DEL "turf_multiz_del"
///from base of turf/multiz_turf_new: (turf/source, direction)
#define COMSIG_TURF_MULTIZ_NEW "turf_multiz_new"

// /atom/movable signals
#define COMSIG_MOVABLE_PRE_MOVE "movable_pre_move"					///from base of atom/movable/Moved(): (/atom)
	#define COMPONENT_MOVABLE_BLOCK_PRE_MOVE 1
#define COMSIG_MOVABLE_MOVED "movable_moved"					//from base of atom/movable/Moved(): (/atom, dir)
#define COMSIG_MOVABLE_CROSS "movable_cross"					//from base of atom/movable/Cross(): (/atom/movable)
#define COMSIG_MOVABLE_CROSSED "movable_crossed"                //from base of atom/movable/Crossed(): (/atom/movable)
#define COMSIG_MOVABLE_UNCROSS "movable_uncross"				//from base of atom/movable/Uncross(): (/atom/movable)
	#define COMPONENT_MOVABLE_BLOCK_UNCROSS 1
#define COMSIG_MOVABLE_UNCROSSED "movable_uncrossed"            //from base of atom/movable/Uncrossed(): (/atom/movable)
#define COMSIG_MOVABLE_BUMP "movable_bump"						//from base of atom/movable/Bump(): (/atom)
#define COMSIG_MOVABLE_IMPACT "movable_impact"					//from base of atom/movable/throw_impact(): (/atom/hit_atom, /datum/thrownthing/throwingdatum)
	#define COMPONENT_MOVABLE_IMPACT_FLIP_HITPUSH 1			///if true, flip if the impact will push what it hits
	#define COMPONENT_MOVABLE_IMPACT_NEVERMIND 2			///return true if you destroyed whatever it was you're impacting and there won't be anything for hitby() to run on
#define COMSIG_MOVABLE_IMPACT_ZONE "item_impact_zone"			//from base of mob/living/hitby(): (mob/living/target, hit_zone)
#define COMSIG_MOVABLE_BUCKLE "buckle"							//from base of atom/movable/buckle_mob(): (mob, force)
#define COMSIG_MOVABLE_UNBUCKLE "unbuckle"						//from base of atom/movable/unbuckle_mob(): (mob, force)
#define COMSIG_MOVABLE_PRE_THROW "movable_pre_throw"			//from base of atom/movable/throw_at(): (list/args)
	#define COMPONENT_CANCEL_THROW 1
#define COMSIG_MOVABLE_POST_THROW "movable_post_throw"			//from base of atom/movable/throw_at(): (datum/thrownthing, spin)
#define COMSIG_MOVABLE_Z_CHANGED "movable_ztransit" 			//from base of atom/movable/onTransitZ(): (old_z, new_z)
#define COMSIG_MOVABLE_SECLUDED_LOCATION "movable_secluded" 	//called when the movable is placed in an unaccessible area, used for stationloving: ()
#define COMSIG_MOVABLE_HEAR "movable_hear"						//from base of atom/movable/Hear(): (message, atom/movable/speaker, message_language, raw_message, radio_freq, list/spans, message_mode, atom/movable/source)
	#define HEARING_MESSAGE 1
	#define HEARING_SPEAKER 2
//	#define HEARING_LANGUAGE 3
	#define HEARING_RAW_MESSAGE 4
//	 #define HEARING_RADIO_FREQ 5
//	#define HEARING_SPANS 6
	#define HEARING_MESSAGE_MODE 7
//	#define HEARING_SOURCE 8
#define COMSIG_MOVABLE_DISPOSING "movable_disposing"			//called when the movable is added to a disposal holder object for disposal movement: (obj/structure/disposalholder/holder, obj/machinery/disposal/source)
#define COMSIG_MOVABLE_TELEPORTED "movable_teleported"			//from base of do_teleport(): (channel, turf/origin, turf/destination)
#define COMSIG_MOVABLE_CHASM_DROP "movable_chasm_drop"			//from base of /datum/component/chasm/drop() (/datum/component/chasm)

// /mind signals
#define  COMSIG_PRE_MIND_TRANSFER "pre_mind_transfer"			//from base of mind/transfer_to() before it's done: (new_character, old_character)
	#define COMPONENT_STOP_MIND_TRANSFER 1						//stops the mind transfer from happening.
#define COMSIG_MIND_TRANSFER "mind_transfer"					//from base of mind/transfer_to() when it's done: (new_character, old_character)

// /mob signals
#define COMSIG_MOB_CLICKED_SHIFT_ON "mob_shift_click_on"		//from base of /atom/ShiftClick(): (atom/A), for return values, see COMSIG_CLICK_SHIFT
#define COMSIG_MOB_FOV_VIEW "mob_visible_atoms"					//from base of /mob/fov_view(): (list/visible_atoms)
#define COMSIG_MOB_POINTED "mob_pointed"						//from base of /mob/verb/pointed(): (atom/A)
#define COMSIG_MOB_EXAMINATE "mob_examinate"					//from base of /mob/verb/examinate(): (atom/A), for return values, see COMSIG_CLICK_SHIFT
	#define COMPONENT_EXAMINATE_BLIND 3 //outputs the "something is there but you can't see it" message.
#define COMSIG_MOB_DEATH "mob_death"							//from base of mob/death(): (gibbed)
	#define COMPONENT_BLOCK_DEATH_BROADCAST 1					//stops the death from being broadcasted in deadchat.
#define COMSIG_MOB_CLICKON "mob_clickon"						//from base of mob/clickon(): (atom/A, params)
	#define COMSIG_MOB_CANCEL_CLICKON 1
#define COMSIG_MOB_GHOSTIZE "mob_ghostize"						//from base of mob/Ghostize(): (can_reenter_corpse, special, penalize)
	#define COMPONENT_BLOCK_GHOSTING (1<<0)
	#define COMPONENT_DO_NOT_PENALIZE_GHOSTING (1<<1)
	#define COMPONENT_FREE_GHOSTING (1<<2)
#define COMSIG_MOB_ALLOWED "mob_allowed"						//from base of obj/allowed(mob/M): (/obj) returns bool, if TRUE the mob has id access to the obj
#define COMSIG_MOB_RECEIVE_MAGIC "mob_receive_magic"			//from base of mob/anti_magic_check(): (mob/user, magic, holy, tinfoil, chargecost, self, protection_sources)
	#define COMPONENT_BLOCK_MAGIC 1
#define COMSIG_MOB_HUD_CREATED "mob_hud_created"				//from base of mob/create_mob_hud(): ()
#define COMSIG_MOB_ATTACK_HAND "mob_attack_hand"				//from base of
#define COMSIG_MOB_ITEM_ATTACK "mob_item_attack"				//from base of /obj/item/attack(): (mob/M, mob/user)
	#define COMPONENT_ITEM_NO_ATTACK 1
#define COMSIG_MOB_ITEM_AFTERATTACK "mob_item_afterattack"		//from base of obj/item/afterattack(): (atom/target, mob/user, proximity_flag, click_parameters)
#define COMSIG_MOB_ATTACK_RANGED "mob_attack_ranged"			//from base of mob/RangedAttack(): (atom/A, params)
#define COMSIG_MOB_THROW "mob_throw"							//from base of /mob/throw_item(): (atom/target)
#define COMSIG_MOB_KEY_CHANGE "mob_key_change"					//from base of /mob/transfer_ckey(): (new_character, old_character)
#define COMSIG_MOB_PRE_PLAYER_CHANGE "mob_pre_player_change"	//sent to the target mob from base of /mob/transfer_ckey() and /mind/transfer_to(): (our_character, their_character)
///from /mob/living/handle_eye_contact(): (mob/living/other_mob)
#define COMSIG_MOB_EYECONTACT "mob_eyecontact"
	/// return this if you want to block printing this message to this person, if you want to print your own (does not affect the other person's message)
	#define COMSIG_BLOCK_EYECONTACT (1<<0)
//	#define COMPONENT_STOP_MIND_TRANSFER 1
#define COMSIG_MOB_UPDATE_SIGHT "mob_update_sight"				//from base of /mob/update_sight(): ()
#define COMSIG_MOB_ON_NEW_MIND "mob_on_new_mind"			//called when a new mind is assigned to a mob: ()
#define COMSIG_MOB_SAY "mob_say" // from /mob/living/say(): (proc args list)
	#define COMPONENT_UPPERCASE_SPEECH 1
	// used to access COMSIG_MOB_SAY argslist
	#define SPEECH_MESSAGE 1
	// #define SPEECH_BUBBLE_TYPE 2
	#define SPEECH_SPANS 3
//	#define SPEECH_SANITIZE 4
	#define SPEECH_LANGUAGE 5
//	#define SPEECH_IGNORE_SPAM 6
//	#define SPEECH_FORCED 7
#define COMSIG_MOB_FOV_VIEWER "mob_is_viewer"					//from base of /fov_viewers(): (atom/center, depth, viewers_list)
#define COMSIG_MOB_GET_VISIBLE_MESSAGE "mob_get_visible_message" //from base of atom/visible_message(): (atom/A, msg, range, ignored_mobs)
	#define COMPONENT_NO_VISIBLE_MESSAGE 1 //exactly what's said on the tin.
#define COMSIG_MOB_ANTAG_ON_GAIN "mob_antag_on_gain"			//from base of /datum/antagonist/on_gain(): (antag_datum)
#define COMSIG_MOB_APPLY_DAMAGE	"mob_apply_damage"				//from base of /mob/living/proc/apply_damage(): (damage, damagetype, def_zone, wound_bonus, bare_wound_bonus, sharpness)

#define COMSIG_MOB_SPELL_CAN_CAST "mob_spell_can_cast"			//from base of /obj/effect/proc_holder/spell/can_cast(): (spell)
#define COMSIG_MOB_SWAP_HANDS "mob_swap_hands"					//from base of mob/swap_hand(): (obj/item)
	#define COMPONENT_BLOCK_SWAP 1

#define COMSIG_PROCESS_BORGCHARGER_OCCUPANT "living_charge"
///from base of mob/AltClickOn(): (atom/A)
#define COMSIG_MOB_ALTCLICKON "mob_altclickon"

// /client signals
#define COMSIG_MOB_CLIENT_LOGIN "mob_client_login"					//sent when a mob/login() finishes: (client)
#define COMSIG_MOB_CLIENT_LOGOUT "mob_client_logout"				//sent when a mob/logout() starts: (client)
#define COMSIG_MOB_CLIENT_MOVE "mob_client_move"					//sent when client/Move() finishes with no early returns: (client, direction, n, oldloc)
#define COMSIG_MOB_CLIENT_CHANGE_VIEW "mob_client_change_view"		//from base of /client/change_view(): (client, old_view, view)
#define COMSIG_MOB_CLIENT_MOUSEMOVE "mob_client_mousemove"			//from base of /client/MouseMove(): (object, location, control, params)

// /mob/living signals
#define COMSIG_LIVING_REGENERATE_LIMBS "living_regenerate_limbs"	//from base of /mob/living/regenerate_limbs(): (noheal, excluded_limbs)
#define COMSIG_LIVING_RESIST "living_resist"					//from base of mob/living/resist() (/mob/living)
#define COMSIG_LIVING_IGNITED "living_ignite"					//from base of mob/living/IgniteMob() (/mob/living)
#define COMSIG_LIVING_EXTINGUISHED "living_extinguished"		//from base of mob/living/ExtinguishMob() (/mob/living)
#define COMSIG_LIVING_ELECTROCUTE_ACT "living_electrocute_act"		//from base of mob/living/electrocute_act(): (shock_damage, source, siemens_coeff, flags)
#define COMSIG_LIVING_SHOCK_PREVENTED "living_shock_prevented"  //sent when items with siemen coeff. of 0 block a shock: (power_source, source, siemens_coeff, dist_check)
#define COMSIG_LIVING_MINOR_SHOCK "living_minor_shock"			//sent by stuff like stunbatons and tasers: ()
#define COMSIG_LIVING_REVIVE "living_revive"					//from base of mob/living/revive() (full_heal, admin_revive)

#define COMSIG_MOB_RESET_PERSPECTIVE "mob_reset_perspective"		//from base of /mob/reset_perspective(): (atom/target)
#define COMSIG_LIVING_GUN_PROCESS_FIRE "living_gun_process_fire"	//from base of /obj/item/gun/proc/process_fire(): (atom/target, params, zone_override)
// This returns flags as defined for block in __DEFINES/combat.dm!
#define COMSIG_LIVING_RUN_BLOCK "living_do_run_block"				//from base of mob/living/do_run_block(): (real_attack, atom/object, damage, attack_text, attack_type, armour_penetration, mob/attacker, def_zone)
#define COMSIG_LIVING_GET_BLOCKING_ITEMS "get_blocking_items"	//from base of mob/living/get_blocking_items(): (list/items)

#define COMSIG_LIVING_ACTIVE_BLOCK_START "active_block_start"			//from base of mob/living/keybind_start_active_blocking(): (obj/item/blocking_item, list/backup_items)
	#define COMPONENT_PREVENT_BLOCK_START 1
#define COMSIG_LIVING_ACTIVE_PARRY_START "active_parry_start"			//from base of mob/living/initiate_parry_sequence(): (parrying_method, datum/parrying_item_mob_or_art, list/backup_items, list/override)
	#define COMPONENT_PREVENT_PARRY_START 1

#define COMSIG_LIVING_ATTACKER_SET "living_attacker_set"			// from base of /mob/living/set_last_attacker(): (attacker)

#define COMSIG_LIVING_SET_AS_ATTACKER "living_set_as_attacker"		// from base of /mob/living/set_last_attacker(): (target)

//ALL OF THESE DO NOT TAKE INTO ACCOUNT WHETHER AMOUNT IS 0 OR LOWER AND ARE SENT REGARDLESS!
#define COMSIG_LIVING_STATUS_STUN "living_stun"					//from base of mob/living/Stun() (amount, update, ignore)
#define COMSIG_LIVING_STATUS_KNOCKDOWN "living_knockdown"		//from base of mob/living/Knockdown() (amount, update, ignore)
#define COMSIG_LIVING_STATUS_PARALYZE "living_paralyze"			//from base of mob/living/Paralyze() (amount, update, ignore)
#define COMSIG_LIVING_STATUS_IMMOBILIZE "living_immobilize"		//from base of mob/living/Immobilize() (amount, update, ignore)
#define COMSIG_LIVING_STATUS_UNCONSCIOUS "living_unconscious"	//from base of mob/living/Unconscious() (amount, update, ignore)
#define COMSIG_LIVING_STATUS_SLEEP "living_sleeping"			//from base of mob/living/Sleeping() (amount, update, ignore)
#define COMSIG_LIVING_STATUS_DAZE "living_daze"					//from base of mob/living/Daze() (amount, update, ignore)
#define COMSIG_LIVING_STATUS_STAGGER "living_stagger"			//from base of mob/living/Stagger() (amount, update, ignore)
	#define COMPONENT_NO_STUN 1			//For all of them

#define COMSIG_LIVING_LIFE "life_tick"							//from base of mob/living/Life() (seconds, times_fired)
	#define COMPONENT_INTERRUPT_LIFE_BIOLOGICAL 1		// interrupt biological processes
	#define COMPONENT_INTERRUPT_LIFE_PHYSICAL 2			// interrupt physical handling

#define COMSIG_LIVING_BIOLOGICAL_LIFE "biological_life"			//from base of mob/living/BiologicalLife() (seconds, times_fired)

#define COMSIG_LIVING_PHYSICAL_LIFE "physical_life"				//from base of mob/living/PhysicalLife() (seconds, times_fired)

// /mob/living/carbon physiology signals
#define COMSIG_CARBON_GAIN_WOUND "carbon_gain_wound"				//from /datum/wound/proc/apply_wound() (/mob/living/carbon/C, /datum/wound/W, /obj/item/bodypart/L)
#define COMSIG_CARBON_LOSE_WOUND "carbon_lose_wound"				//from /datum/wound/proc/remove_wound() (/mob/living/carbon/C, /datum/wound/W, /obj/item/bodypart/L)
///from base of /obj/item/bodypart/proc/attach_limb(): (new_limb, special) allows you to fail limb attachment
#define COMSIG_CARBON_ATTACH_LIMB "carbon_attach_limb"
	#define COMPONENT_NO_ATTACH (1<<0)
#define COMSIG_CARBON_REMOVE_LIMB "carbon_remove_limb"			//from base of /obj/item/bodypart/proc/drop_limb(special, dismembered)

#define COMSIG_CARBON_SOUNDBANG "carbon_soundbang"					//from base of mob/living/carbon/soundbang_act(): (list(intensity))
#define COMSIG_CARBON_IDENTITY_TRANSFERRED_TO "carbon_id_transferred_to" //from datum/dna/transfer_identity(): (datum/dna, transfer_SE)
#define COMSIG_CARBON_TACKLED "carbon_tackled"						//sends from tackle.dm on tackle completion
#define COMSIG_CARBON_EMBED_RIP "item_embed_start_rip"						// defined twice, in carbon and human's topics, fired when interacting with a valid embedded_object to pull it out (mob/living/carbon/target, /obj/item, /obj/item/bodypart/L)
#define COMSIG_CARBON_EMBED_REMOVAL "item_embed_remove_safe"		// called when removing a given item from a mob, from mob/living/carbon/remove_embedded_object(mob/living/carbon/target, /obj/item)

// /mob/living/silicon signals
#define COMSIG_ROBOT_UPDATE_ICONS "robot_update_icons"			//from base of robot/update_icons(): ()

// /mob/living/simple_animal/hostile signals
#define COMSIG_HOSTILE_ATTACKINGTARGET "hostile_attackingtarget"
	#define COMPONENT_HOSTILE_NO_ATTACK 1

// /obj signals
#define COMSIG_OBJ_DECONSTRUCT 	"obj_deconstruct"				//from base of obj/deconstruct(): (disassembled)
#define COMSIG_OBJ_BREAK		"obj_break"						//from base of /obj/obj_break(): (damage_flag)
#define COMSIG_OBJ_SETANCHORED 	"obj_setanchored"				//called in /obj/structure/setAnchored(): (value)
#define COMSIG_OBJ_DEFAULT_UNFASTEN_WRENCH	"obj_default_unfasten_wrench" //called exclusively in plumbing, for now
#define COMSIG_OBJ_ATTACK_GENERIC "obj_attack_generic"			//from base of atom/animal_attack(): (/mob/user)
	#define COMPONENT_STOP_GENERIC_ATTACK 1


// /machinery signals
#define COMSIG_MACHINE_EJECT_OCCUPANT "eject_occupant"			//from base of obj/machinery/dropContents() (occupant)

// /obj/item signals
#define COMSIG_ITEM_ATTACK "item_attack"						//from base of obj/item/attack(): (/mob/living/target, /mob/living/user)
#define COMSIG_ITEM_ATTACK_SELF "item_attack_self"				//from base of obj/item/attack_self(): (/mob)
	#define COMPONENT_NO_INTERACT 1
#define COMSIG_ITEM_ATTACK_OBJ "item_attack_obj"				//from base of obj/item/attack_obj(): (/obj, /mob)
	#define COMPONENT_NO_ATTACK_OBJ 1
#define COMSIG_ITEM_PRE_ATTACK "item_pre_attack"				//from base of obj/item/pre_attack(): (atom/target, mob/user, params)
	#define COMPONENT_NO_ATTACK 1
#define COMSIG_ITEM_AFTERATTACK "item_afterattack"				//from base of obj/item/afterattack(): (atom/target, mob/user, params)
#define COMSIG_ITEM_ALT_AFTERATTACK "item_alt_afterattack"		//from base of obj/item/altafterattack(): (atom/target, mob/user, proximity, params)
#define COMSIG_ITEM_EQUIPPED "item_equip"						//from base of obj/item/equipped(): (/mob/equipper, slot)
	// Do not grant actions on equip.
	#define COMPONENT_NO_GRANT_ACTIONS		1
#define COMSIG_ITEM_DROPPED "item_drop"							//from base of obj/item/dropped(): (mob/user)
	// relocated, tell inventory procs if those called this that the item isn't available anymore.
	#define COMPONENT_DROPPED_RELOCATION 1
#define COMSIG_ITEM_PICKUP "item_pickup"						//from base of obj/item/pickup(): (/mob/taker)
#define COMSIG_ITEM_ATTACK_ZONE "item_attack_zone"				//from base of mob/living/carbon/attacked_by(): (mob/living/carbon/target, mob/living/user, hit_zone)
#define COMSIG_ITEM_IMBUE_SOUL "item_imbue_soul" 				//return a truthy value to prevent ensouling, checked in /obj/effect/proc_holder/spell/targeted/lichdom/cast(): (mob/user)
#define COMSIG_ITEM_HIT_REACT "item_hit_react"					//from base of obj/item/hit_reaction(): (list/args)
#define COMSIG_ITEM_WEARERCROSSED "wearer_crossed"				//called on item when crossed by something (): (/atom/movable)
#define COMSIG_ITEM_SHARPEN_ACT "sharpen_act"					//from base of item/sharpener/attackby(): (amount, max)
	#define COMPONENT_BLOCK_SHARPEN_APPLIED 1
	#define COMPONENT_BLOCK_SHARPEN_BLOCKED 2
	#define COMPONENT_BLOCK_SHARPEN_ALREADY 4
	#define COMPONENT_BLOCK_SHARPEN_MAXED 8
#define COMSIG_ITEM_MICROWAVE_ACT "microwave_act"                //called on item when microwaved (): (obj/machinery/microwave/M)
#define COMSIG_ITEM_WORN_OVERLAYS "item_worn_overlays"			//from base of obj/item/worn_overlays(): (isinhands, icon_file, used_state, style_flags, list/overlays)
// THE FOLLOWING TWO BLOCKS SHOULD RETURN BLOCK FLAGS AS DEFINED IN __DEFINES/combat.dm!
#define COMSIG_ITEM_CHECK_BLOCK "check_block"					//from base of obj/item/check_block(): (mob/living/owner, atom/object, damage, attack_text, attack_type, armour_penetration, mob/attacker, def_zone, final_block_chance, list/block_return)
#define COMSIG_ITEM_RUN_BLOCK "run_block"						//from base of obj/item/run_block(): (mob/living/owner, atom/object, damage, attack_text, attack_type, armour_penetration, mob/attacker, def_zone, final_block_chance, list/block_return)
// Item mouse siganls
#define COMSIG_ITEM_MOUSE_EXIT "item_mouse_exit"				//from base of obj/item/MouseExited(): (location, control, params)
#define COMSIG_ITEM_MOUSE_ENTER "item_mouse_enter"				//from base of obj/item/MouseEntered(): (location, control, params)
#define COMSIG_ITEM_DECONSTRUCTOR_DEEPSCAN "deconstructor_deepscan"			//Called by deconstructive analyzers deepscanning an item: (obj/machinery/rnd/destructive_analyzer/analyzer_machine, mob/user, list/information_list)
#define COMSIG_ITEM_DISABLE_EMBED "item_disable_embed"			///from [/obj/item/proc/disableEmbedding]:
#define COMSIG_MINE_TRIGGERED "minegoboom"						///from [/obj/effect/mine/proc/triggermine]:
	// Uncovered information
	#define COMPONENT_DEEPSCAN_UNCOVERED_INFORMATION		1
///from [/obj/structure/closet/supplypod/proc/endlaunch]:
#define COMSIG_SUPPLYPOD_LANDED "supplypodgoboom"

// /obj/item/grenade signals
#define COMSIG_GRENADE_PRIME "grenade_prime"					//called in /obj/item/gun/process_fire (user, target, params, zone_override)
#define COMSIG_GRENADE_ARMED "grenade_armed"					//called in /obj/item/gun/process_fire (user, target, params, zone_override)

// /obj/item/clothing signals
#define COMSIG_SHOES_STEP_ACTION "shoes_step_action"			//from base of obj/item/clothing/shoes/proc/step_action(): ()
#define COMSIG_SUIT_MADE_HELMET "suit_made_helmet"				//from base of obj/item/clothing/suit/MakeHelmet(): (helmet)

// /obj/item/implant signals
#define COMSIG_IMPLANT_ACTIVATED "implant_activated"			//from base of /obj/item/implant/proc/activate(): ()
#define COMSIG_IMPLANT_IMPLANTING "implant_implanting"			//from base of /obj/item/implant/proc/implant(): (list/args)
	#define COMPONENT_STOP_IMPLANTING 1
#define COMSIG_IMPLANT_OTHER "implant_other"					//called on already installed implants when a new one is being added in /obj/item/implant/proc/implant(): (list/args, obj/item/implant/new_implant)
	//#define COMPONENT_STOP_IMPLANTING 1 //The name makes sense for both
	#define COMPONENT_DELETE_NEW_IMPLANT 2
	#define COMPONENT_DELETE_OLD_IMPLANT 4
#define COMSIG_IMPLANT_EXISTING_UPLINK "implant_uplink_exists"	//called on implants being implanted into someone with an uplink implant: (datum/component/uplink)
	//This uses all return values of COMSIG_IMPLANT_OTHER
#define COMSIG_IMPLANT_REMOVING "implant_removing"				//from base of /obj/item/implant/proc/removed() (list/args)

// /obj/item/pda signals
#define COMSIG_PDA_CHANGE_RINGTONE "pda_change_ringtone"		//called on pda when the user changes the ringtone: (mob/living/user, new_ringtone)
	#define COMPONENT_STOP_RINGTONE_CHANGE 1

// /obj/item/radio signals
#define COMSIG_RADIO_NEW_FREQUENCY "radio_new_frequency"		//called from base of /obj/item/radio/proc/set_frequency(): (list/args)

// /obj/item/pen signals
#define COMSIG_PEN_ROTATED "pen_rotated"						//called after rotation in /obj/item/pen/attack_self(): (rotation, mob/living/carbon/user)

// /obj/item/projectile signals (sent to the firer)
#define COMSIG_PROJECTILE_SELF_ON_HIT "projectile_self_on_hit"			///from base of /obj/item/projectile/proc/on_hit(): (atom/movable/firer, atom/target, Angle, hit_limb)
#define COMSIG_PROJECTILE_ON_HIT "projectile_on_hit"			///from base of /obj/item/projectile/proc/on_hit(): (atom/movable/firer, atom/target, Angle, hit_limb)
#define COMSIG_PROJECTILE_BEFORE_FIRE "projectile_before_fire" 			// from base of /obj/item/projectile/proc/fire(): (obj/item/projectile, atom/original_target)
#define COMSIG_PROJECTILE_FIRE "projectile_fire"				///from the base of /obj/item/projectile/proc/fire(): ()
#define COMSIG_PROJECTILE_RANGE_OUT "projectile_range_out"				// sent to targets during the process_hit proc of projectiles
#define COMSIG_EMBED_TRY_FORCE "item_try_embed"					// sent when trying to force an embed (mainly for projectiles, only used in the embed element)
#define COMSIG_PROJECTILE_PREHIT "com_proj_prehit"				///sent to targets during the process_hit proc of projectiles

#define COMSIG_PELLET_CLOUD_INIT "pellet_cloud_init"				// sent to targets during the process_hit proc of projectiles

// /mob/living/carbon/human signals
#define COMSIG_HUMAN_MELEE_UNARMED_ATTACK "human_melee_unarmed_attack"			//from mob/living/carbon/human/UnarmedAttack(): (atom/target)
#define COMSIG_HUMAN_MELEE_UNARMED_ATTACKBY "human_melee_unarmed_attackby"		//from mob/living/carbon/human/UnarmedAttack(): (mob/living/carbon/human/attacker)
#define COMSIG_HUMAN_EARLY_UNARMED_ATTACK "human_early_unarmed_attack"
#define COMSIG_HUMAN_DISARM_HIT	"human_disarm_hit"	//Hit by successful disarm attack (mob/living/carbon/human/attacker,zone_targeted)
#define COMSIG_HUMAN_PREFS_COPIED_TO "human_prefs_copied_to"					//from datum/preferences/copy_to(): (datum/preferences, icon_updates, roundstart_checks)
#define COMSIG_HUMAN_HARDSET_DNA "human_hardset_dna"							//from mob/living/carbon/human/hardset_dna(): (ui, list/mutation_index, newreal_name, newblood_type, datum/species, newfeatures)
#define COMSIG_HUMAN_ON_RANDOMIZE "humman_on_randomize"							//from base of proc/randomize_human()

// /datum/species signals
#define COMSIG_SPECIES_GAIN "species_gain"						//from datum/species/on_species_gain(): (datum/species/new_species, datum/species/old_species)
#define COMSIG_SPECIES_LOSS "species_loss"						//from datum/species/on_species_loss(): (datum/species/lost_species)

// /datum/mutation signals
#define COMSIG_HUMAN_MUTATION_LOSS "human_mutation_loss"		//from datum/mutation/human/on_losing(): (datum/mutation/human/lost_mutation)

///from base of mob/living/death(): (gibbed)
// Sent before any of the other death code has run, mob is still alive.
#define COMSIG_LIVING_PREDEATH "living_predeath"

/*******Component Specific Signals*******/
//Janitor
#define COMSIG_TURF_IS_WET "check_turf_wet"							//(): Returns bitflags of wet values.
#define COMSIG_TURF_MAKE_DRY "make_turf_try"						//(max_strength, immediate, duration_decrease = INFINITY): Returns bool.
#define COMSIG_COMPONENT_CLEAN_ACT "clean_act"					//called on an object to clean it of cleanables. Usualy with soap: (num/strength)

//Food
#define COMSIG_FOOD_EATEN "food_eaten"		//from base of obj/item/reagent_containers/food/snacks/attack(): (mob/living/eater, mob/feeder)

//Gibs
#define COMSIG_GIBS_STREAK "gibs_streak"						// from base of /obj/effect/decal/cleanable/blood/gibs/streak(): (list/directions, list/diseases)

//Mood
#define COMSIG_ADD_MOOD_EVENT "add_mood" //Called when you send a mood event from anywhere in the code.
#define COMSIG_CLEAR_MOOD_EVENT "clear_mood" //Called when you clear a mood event from anywhere in the code.
#define COMSIG_MODIFY_SANITY "modify_sanity" //Called when you want to increase or decrease sanity from anywhere in the code.

///Mask of Madness
#define COMSIG_VOID_MASK_ACT "void_mask_act"

//NTnet
#define COMSIG_COMPONENT_NTNET_RECEIVE "ntnet_receive"			//called on an object by its NTNET connection component on receive. (sending_id(number), sending_netname(text), data(datum/netdata))

//Combat mode
#define COMSIG_TOGGLE_COMBAT_MODE "toggle_combat_mode"				//safely toggles combat mode.
#define COMSIG_DISABLE_COMBAT_MODE "disable_combat_mode"			//safely disables combat mode.
#define COMSIG_ENABLE_COMBAT_MODE "enable_combat_mode"				//safely enables combat mode.
#define COMSIG_LIVING_COMBAT_ENABLED "combatmode_enabled"			//from base of datum/component/combat_mode/enable_combat_mode() (was_forced)
#define COMSIG_LIVING_COMBAT_DISABLED "combatmode_disabled"			//from base of datum/component/combat_mode/disable_combat_mode() (was_forced)
#define COMSIG_COMBAT_MODE_CHECK "combatmode_check"					//called when checking the combat mode flags (enabled/disabled/forced)

//Nanites
#define COMSIG_HAS_NANITES "has_nanites"						//() returns TRUE if nanites are found
#define COMSIG_NANITE_IS_STEALTHY "nanite_is_stealthy"			//() returns TRUE if nanites have stealth
#define COMSIG_NANITE_DELETE "nanite_delete"					//() deletes the nanite component
#define COMSIG_NANITE_GET_PROGRAMS	"nanite_get_programs"		//(list/nanite_programs) - makes the input list a copy the nanites' program list
#define COMSIG_NANITE_GET_VOLUME "nanite_get_volume"			//(amount) Returns nanite amount
#define COMSIG_NANITE_SET_VOLUME "nanite_set_volume"			//(amount) Sets current nanite volume to the given amount
#define COMSIG_NANITE_ADJUST_VOLUME "nanite_adjust"				//(amount) Adjusts nanite volume by the given amount
#define COMSIG_NANITE_SET_MAX_VOLUME "nanite_set_max_volume"	//(amount) Sets maximum nanite volume to the given amount
#define COMSIG_NANITE_SET_CLOUD "nanite_set_cloud"				//(amount(0-100)) Sets cloud ID to the given amount
#define COMSIG_NANITE_SET_CLOUD_SYNC "nanite_set_cloud_sync"	//(method) Modify cloud sync status. Method can be toggle, enable or disable
#define COMSIG_NANITE_SET_SAFETY "nanite_set_safety"			//(amount) Sets safety threshold to the given amount
#define COMSIG_NANITE_SET_REGEN "nanite_set_regen"				//(amount) Sets regeneration rate to the given amount
#define COMSIG_NANITE_SIGNAL "nanite_signal"					//(code(1-9999)) Called when sending a nanite signal to a mob.
#define COMSIG_NANITE_COMM_SIGNAL "nanite_comm_signal"			//(comm_code(1-9999), comm_message) Called when sending a nanite comm signal to a mob.
#define COMSIG_NANITE_SCAN "nanite_scan"						//(mob/user, full_scan) - sends to chat a scan of the nanites to the user, returns TRUE if nanites are detected
#define COMSIG_NANITE_UI_DATA "nanite_ui_data"					//(list/data, scan_level) - adds nanite data to the given data list - made for ui_data procs
#define COMSIG_NANITE_ADD_PROGRAM "nanite_add_program"			//(datum/nanite_program/new_program, datum/nanite_program/source_program) Called when adding a program to a nanite component
#define COMPONENT_PROGRAM_INSTALLED		1					//Installation successful
#define COMPONENT_PROGRAM_NOT_INSTALLED		2				//Installation failed, but there are still nanites
#define COMSIG_NANITE_SYNC "nanite_sync"						//(datum/component/nanites, full_overwrite, copy_activation) Called to sync the target's nanites to a given nanite component
/// Checks if a nanite component is able to be controlled by console
#define COMSIG_NANITE_CHECK_CONSOLE_LOCK "is_console_locked"
/// Checks if a nanite component is able to be interfaced with by a host with innate nanite control
#define COMSIG_NANITE_CHECK_HOST_LOCK "is_host_locked"
/// Checks if a nanite component is able to be overwritten by viral replica
#define COMSIG_NANITE_CHECK_VIRAL_PREVENTION "is_virus_locked"
	#define NANITE_CHANGES_LOCKED 1
// Internal signals that programs register to and respond with to not require for loops
#define COMSIG_NANITE_INTERNAL_CONSOLE_LOCK_CHECK "naniteiconsolelocked"
#define COMSIG_NANITE_INTERNAL_HOST_LOCK_CHECK "naniteihostlocked"
#define COMSIG_NANITE_INTERNAL_VIRAL_PREVENTION_CHECK "naniteiviruslocked"

// /datum/component/storage signals
#define COMSIG_CONTAINS_STORAGE "is_storage"						//() - returns bool.
#define COMSIG_TRY_STORAGE_INSERT "storage_try_insert"				//(obj/item/inserting, mob/user, silent, force) - returns bool
#define COMSIG_TRY_STORAGE_SHOW "storage_show_to"					//(mob/show_to, force) - returns bool.
#define COMSIG_TRY_STORAGE_HIDE_FROM "storage_hide_from"			//(mob/hide_from) - returns bool
#define COMSIG_TRY_STORAGE_HIDE_ALL "storage_hide_all"				//returns bool
#define COMSIG_TRY_STORAGE_SET_LOCKSTATE "storage_lock_set_state"	//(newstate)
#define COMSIG_IS_STORAGE_LOCKED "storage_get_lockstate"			//() - returns bool. MUST CHECK IF STORAGE IS THERE FIRST!
#define COMSIG_TRY_STORAGE_TAKE_TYPE "storage_take_type"			//(type, atom/destination, amount = INFINITY, check_adjacent, force, mob/user, list/inserted) - returns bool - type can be a list of types.
#define COMSIG_TRY_STORAGE_FILL_TYPE "storage_fill_type"			//(type, amount = INFINITY, force = FALSE)			//don't fuck this up. Force will ignore max_items, and amount is normally clamped to max_items.
#define COMSIG_TRY_STORAGE_TAKE "storage_take_obj"					//(obj, new_loc, force = FALSE) - returns bool
#define COMSIG_TRY_STORAGE_QUICK_EMPTY "storage_quick_empty"		//(loc) - returns bool - if loc is null it will dump at parent location.
#define COMSIG_TRY_STORAGE_RETURN_INVENTORY "storage_return_inventory"	//(list/list_to_inject_results_into, recursively_search_inside_storages = TRUE)
#define COMSIG_TRY_STORAGE_CAN_INSERT "storage_can_equip"			//(obj/item/insertion_candidate, mob/user, silent) - returns bool

// /datum/component/two_handed signals
#define COMSIG_TWOHANDED_WIELD "twohanded_wield"						//from base of datum/component/two_handed/proc/wield(mob/living/carbon/user): (/mob/user)
	#define COMPONENT_TWOHANDED_BLOCK_WIELD 1
#define COMSIG_TWOHANDED_UNWIELD "twohanded_unwield"					//from base of datum/component/two_handed/proc/unwield(mob/living/carbon/user): (/mob/user)

// /datum/component/squeak signals
#define COMSIG_CROSS_SQUEAKED "cross_squeaked"							// sent when a squeak component squeaks from crossing something, to delay anything else crossing that might squeak to prevent ear hurt.

// /datum/action signals
#define COMSIG_ACTION_TRIGGER "action_trigger"						//from base of datum/action/proc/Trigger(): (datum/action)
	#define COMPONENT_ACTION_BLOCK_TRIGGER 1

//Xenobio hotkeys
#define COMSIG_XENO_SLIME_CLICK_CTRL "xeno_slime_click_ctrl"				//from slime CtrlClickOn(): (/mob)
#define COMSIG_XENO_SLIME_CLICK_ALT "xeno_slime_click_alt"					//from slime AltClickOn(): (/mob)
#define COMSIG_XENO_SLIME_CLICK_SHIFT "xeno_slime_click_shift"				//from slime ShiftClickOn(): (/mob)
#define COMSIG_XENO_TURF_CLICK_SHIFT "xeno_turf_click_shift"				//from turf ShiftClickOn(): (/mob)
#define COMSIG_XENO_TURF_CLICK_CTRL "xeno_turf_click_alt"					//from turf AltClickOn(): (/mob)
#define COMSIG_XENO_MONKEY_CLICK_CTRL "xeno_monkey_click_ctrl"				//from monkey CtrlClickOn(): (/mob)

// /datum/element/ventcrawling signals
#define COMSIG_HANDLE_VENTCRAWL "handle_ventcrawl"							//when atom with ventcrawling element attempts to ventcrawl
#define COMSIG_CHECK_VENTCRAWL "check_ventcrawl"							//to check an atom's ventcrawling element tier (if applicable)
// twitch plays
/// Returns direction: (wipe_votes)
#define COMSIG_TWITCH_PLAYS_MOVEMENT_DATA "twitch_plays_movement_data"
