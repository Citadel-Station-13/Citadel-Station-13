/// Return this from `/datum/component/Initialize` or `datum/component/OnTransfer` to have the component be deleted if it's applied to an incorrect type.
/// `parent` must not be modified if this is to be returned.
/// This will be noted in the runtime logs
#define COMPONENT_INCOMPATIBLE 1
/// Returned in PostTransfer to prevent transfer, similar to `COMPONENT_INCOMPATIBLE`
#define COMPONENT_NOTRANSFER 2

/// Return value to cancel attaching
#define ELEMENT_INCOMPATIBLE 1

// /datum/element flags
/// Causes the detach proc to be called when the host object is being deleted
#define ELEMENT_DETACH		(1 << 0)
/**
  * Only elements created with the same arguments given after `id_arg_index` share an element instance
  * The arguments are the same when the text and number values are the same and all other values have the same ref
  */
#define ELEMENT_BESPOKE		(1 << 1)

// How multiple components of the exact same type are handled in the same datum
/// old component is deleted (default)
#define COMPONENT_DUPE_HIGHLANDER		0
/// duplicates allowed
#define COMPONENT_DUPE_ALLOWED			1
/// new component is deleted
#define COMPONENT_DUPE_UNIQUE			2
/// old component is given the initialization args of the new
#define COMPONENT_DUPE_UNIQUE_PASSARGS	4
/// each component of the same type is consulted as to whether the duplicate should be allowed
#define COMPONENT_DUPE_SELECTIVE		5

//Redirection component init flags
#define REDIRECT_TRANSFER_WITH_TURF 1

//Arch
#define ARCH_PROB "probability"					//Probability for each item
#define ARCH_MAXDROP "max_drop_amount"				//each item's max drop amount

//Ouch my toes!
#define CALTROP_BYPASS_SHOES 1
#define CALTROP_IGNORE_WALKERS 2

// Spellcasting
#define SPELL_SKIP_ALL_REQS		(1<<0)
#define SPELL_SKIP_CENTCOM		(1<<1)
#define SPELL_SKIP_STAT			(1<<2)
#define SPELL_SKIP_CLOTHES		(1<<3)
#define SPELL_SKIP_ANTIMAGIC	(1<<4)
#define SPELL_SKIP_VOCAL		(1<<5)
#define SPELL_SKIP_MOBTYPE		(1<<6)
#define SPELL_WIZARD_HAT		(1<<7)
#define SPELL_WIZARD_ROBE		(1<<8)
#define SPELL_CULT_HELMET		(1<<9)
#define SPELL_CULT_ARMOR		(1<<10)
#define SPELL_WIZARD_GARB		(SPELL_WIZARD_HAT|SPELL_WIZARD_ROBE)
#define SPELL_CULT_GARB			(SPELL_CULT_HELMET|SPELL_CULT_ARMOR)

//// Identification ////
// /datum/component/identification/identification_flags
/// Delete on successful broad identification (so the main way we "uncover" how an object works, since this won't be on it to obfuscate it)
#define ID_COMPONENT_DEL_ON_IDENTIFY						(1<<0)
/// We've already been successfully deepscanned by a deconstructive analyzer
#define ID_COMPONENT_DECONSTRUCTOR_DEEPSCANNED				(1<<1)

// /datum/component/identification/identification_effect_flags
/// Block user from getting actions if they don't know how to use this. Triggered on equip.
#define ID_COMPONENT_EFFECT_NO_ACTIONS						(1<<0)

// /datum/component/identification/identification_method_flags
/// Can be identified in a deconstructive analyzer
#define ID_COMPONENT_IDENTIFY_WITH_DECONSTRUCTOR			(1<<0)

// Return values for /datum/component/deitnfication/check_knowledge()
/// Has no knowledge, default
#define ID_COMPONENT_KNOWLEDGE_NONE			0
/// Has full knowledge
#define ID_COMPONENT_KNOWLEDGE_FULL				1
