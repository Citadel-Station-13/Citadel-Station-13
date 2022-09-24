
/client
		//////////////////////
		//BLACK MAGIC THINGS//
		//////////////////////
	parent_type = /datum

		///////////////
		// Rendering //
		///////////////

	/// Click catcher
	var/atom/movable/screen/click_catcher/click_catcher
	/// Parallax holder
	var/datum/parallax_holder/parallax_holder

		////////////////
		//ADMIN THINGS//
		////////////////
	/// hides the byond verb panel as we use our own custom version
	show_verb_panel = FALSE
	///Contains admin info. Null if client is not an admin.
	var/datum/admins/holder = null
	var/datum/click_intercept = null // Needs to implement InterceptClickOn(user,params,atom) proc
	///Time when the click was intercepted
	var/click_intercept_time = 0
	var/AI_Interact		= 0

	var/jobbancache = null //Used to cache this client's jobbans to save on DB queries
	var/last_message	= "" //Contains the last message sent by this client - used to protect against copy-paste spamming.
	var/last_message_count = 0 //contins a number of how many times a message identical to last_message was sent.
	///How many messages sent in the last 10 seconds
	var/total_message_count = 0
	///Next tick to reset the total message counter
	var/total_count_reset = 0
	var/ircreplyamount = 0
	/// last time they tried to do an autobunker auth
	var/autobunker_last_try = 0

		/////////
		//OTHER//
		/////////
	var/datum/preferences/prefs = null
	var/last_turn = 0
	var/move_delay = 0
	var/last_move = 0
	var/area			= null

	/// Timers are now handled by clients, not by doing a mess on the item and multiple people overwriting a single timer on the object, have fun.
	var/tip_timer = null

	/// Last time we Click()ed. No clicking twice in one tick!
	var/last_click = 0

		///////////////
		//SOUND STUFF//
		///////////////
	var/ambience_playing= null
	var/played			= 0
		////////////
		//SECURITY//
		////////////
	// comment out the line below when debugging locally to enable the options & messages menu
	control_freak = 1

		////////////////////////////////////
		//things that require the database//
		////////////////////////////////////
	var/player_age = -1	//Used to determine how old the account is - in days.
	var/player_join_date = null //Date that this account was first seen in the server
	var/related_accounts_ip = "Requires database"	//So admins know why it isn't working - Used to determine what other accounts previously logged in from this ip
	var/related_accounts_cid = "Requires database"	//So admins know why it isn't working - Used to determine what other accounts previously logged in from this computer id
	var/account_join_date = null	//Date of byond account creation in ISO 8601 format
	var/account_age = -1	//Age of byond account in days

	preload_rsc = PRELOAD_RSC

	var/atom/movable/screen/click_catcher/void

	//These two vars are used to make a special mouse cursor, with a unique icon for clicking
	var/mouse_up_icon = null
	var/mouse_down_icon = null
	///used to override the mouse cursor so it doesnt get reset
	var/mouse_override_icon = null

	var/ip_intel = "Disabled"

	//datum that controls the displaying and hiding of tooltips
	var/datum/tooltip/tooltips

	var/lastping = 0
	var/avgping = 0
	var/connection_time //world.time they connected
	var/connection_realtime //world.realtime they connected
	var/connection_timeofday //world.timeofday they connected

	var/inprefs = FALSE
	var/list/topiclimiter

	///Used for limiting the rate of clicks sends by the client to avoid abuse
	var/list/clicklimiter

	///lazy list of all credit object bound to this client
	var/list/credits

	var/datum/player_details/player_details //these persist between logins/logouts during the same round.

	var/list/char_render_holders			//Should only be a key-value list of north/south/east/west = atom/movable/screen.

	/// Last time they used fix macros
	var/last_macro_fix = 0
	/// Keys currently held
	var/list/keys_held = list()
	/// These next two vars are to apply movement for keypresses and releases made while move delayed.
	/// Because discarding that input makes the game less responsive.
 	/// On next move, add this dir to the move that would otherwise be done
	var/next_move_dir_add
 	/// On next move, subtract this dir from the move that would otherwise be done
	var/next_move_dir_sub
	/// Amount of keydowns in the last keysend checking interval
	var/client_keysend_amount = 0
	/// World tick time where client_keysend_amount will reset
	var/next_keysend_reset = 0
	/// World tick time where keysend_tripped will reset back to false
	var/next_keysend_trip_reset = 0
	/// When set to true, user will be autokicked if they trip the keysends in a second limit again
	var/keysend_tripped = FALSE
	/// custom movement keys for this client
	var/list/movement_keys = list()

	///Autoclick list of two elements, first being the clicked thing, second being the parameters.
	var/list/atom/selected_target[2]
	///Autoclick variable referencing the associated item.
	var/obj/item/active_mousedown_item = null
	///Used in MouseDrag to preserve the original mouse click parameters
	var/mouseParams = ""
	///Used in MouseDrag to preserve the last mouse-entered location.
	var/mouseLocation = null
	///Used in MouseDrag to preserve the last mouse-entered object.
	var/mouseObject = null
	var/mouseControlObject = null

	/// Messages currently seen by this client
	var/list/seen_messages
	/// viewsize datum for holding our view size
	var/datum/viewData/view_size

	/// our current tab
	var/stat_tab

	/// whether our browser is ready or not yet
	var/statbrowser_ready = FALSE

	/// list of all tabs
	var/list/panel_tabs = list()

	/// list of tabs containing spells and abilities
	var/list/spell_tabs = list()
	/// list of tabs containing verbs
	var/list/verb_tabs = list()
	///A lazy list of atoms we've examined in the last EXAMINE_MORE_TIME (default 1.5) seconds, so that we will call [atom/proc/examine_more()] instead of [atom/proc/examine()] on them when examining
	var/list/recent_examines
	///When was the last time we warned them about not cryoing without an ahelp, set to -5 minutes so that rounstart cryo still warns
	var/cryo_warned = -5 MINUTES

	/**
	 * Assoc list with all the active maps - when a screen obj is added to
	 * a map, it's put in here as well.
	 *
	 * Format: list(<mapname> = list(/atom/movable/screen))
	 */
	var/list/screen_maps = list()

	// List of all asset filenames sent to this client by the asset cache, along with their assoicated md5s
	var/list/sent_assets = list()
	/// List of all completed blocking send jobs awaiting acknowledgement by send_asset
	var/list/completed_asset_jobs = list()
	/// Last asset send job id.
	var/last_asset_job = 0
	var/last_completed_asset_job = 0

	//world.time of when the crew manifest can be accessed
	var/crew_manifest_delay

	/// Should go in persistent round player data sometime. This tracks what items have already warned the user on pickup that they can block/parry.
	var/list/block_parry_hinted = list()
	/// moused over objects, currently capped at 7. this is awful, and should be replaced with a component to track it using signals for parrying at some point.
	var/list/moused_over_objects = list()

	/// AFK tracking
	var/last_activity = 0
