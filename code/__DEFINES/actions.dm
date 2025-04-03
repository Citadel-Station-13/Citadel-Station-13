///Action button checks if user is restrained
#define AB_CHECK_RESTRAINED (1<<0)
///Action button checks if user is stunned
#define AB_CHECK_STUN (1<<1)
///Action button checks if user is resting
#define AB_CHECK_LYING (1<<2)
///Action button checks if user is conscious
#define AB_CHECK_CONSCIOUS (1<<3)

/*
DEFINE_BITFIELD(check_flags, list(
	"CHECK IF RESTRAINED" = AB_CHECK_RESTRAINED,
	"CHECK IF STUNNED" = AB_CHECK_STUN,
	"CHECK IF LYING DOWN" = AB_CHECK_LYING,
	"CHECK IF CONSCIOUS" = AB_CHECK_CONSCIOUS,
)) */

///Action button triggered with right click
#define TRIGGER_SECONDARY_ACTION (1<<0)
///Action triggered to ignore any availability checks
#define TRIGGER_FORCE_AVAILABLE (1<<1)

#define ACTION_BUTTON_DEFAULT_BACKGROUND "_use_ui_default_background"

#define UPDATE_BUTTON_NAME (1<<0)
#define UPDATE_BUTTON_ICON (1<<1)
#define UPDATE_BUTTON_BACKGROUND (1<<2)
#define UPDATE_BUTTON_OVERLAY (1<<3)
#define UPDATE_BUTTON_STATUS (1<<4)

/// Takes in a typepath of a `/datum/action` and adds it to `src`.
/// Only useful if you want to add the action and never desire to reference it again ever.
#define GRANT_ACTION(typepath) do {\
	var/datum/action/_ability = new typepath(src);\
	_ability.Grant(src);\
} while (FALSE)
