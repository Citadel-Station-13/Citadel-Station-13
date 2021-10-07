



// Rig piece applying effects
/// Apply armor
#define RIG_PIECE_APPLY_ARMOR			(1<<0)
/// Apply thermal shielding
#define RIG_PIECE_APPLY_THERMALS		(1<<1)
/// Apply pressure shielding/thickmaterial/similar
#define RIG_PIECE_APPLY_PRESSURE		(1<<2)

// Flags for starting_components
/// Unremovable, but does not go towards any weight/slot/etc limits. Ignores conflicts.
#define RIG_INITIAL_MODULE_INBUILT			(1<<0)

// Component types
/// Generic default
#define RIG_COMPONENT_GENERIC					0
/// Item holder components - primarily just deploys items to the user's hands
#define RIG_COMPONENT_ITEM_HOLDER				1
/// Item components - Directly passes either a click, melee attack chain/afterattack/ranged attack chain, or uses an item on a clicked target
#define RIG_COMPONENT_ITEM_DIRECT				2
/// Passive components - No UI or hotbinds possible
#define RIG_COMPONENT_PASSIVE					3
/// Active toggled components
#define RIG_COMPONENT_TOGGLED					4
/// Activate-once components - basically a button. For UI purposes, this can be a list of buttons.
#define RIG_COMPONENT_TRIGGER					5
/// Components that directly receive the next click action
#define RIG_COMPONENT_INTERCEPT_NEXT_CLICK		5
/// Components that hook the rig's action click bind. Middle mouse, ctrl and alt click, etc.
#define RIG_COMPONENT_MOUSE_TRIGGER_HOOK		6

// Component UI types
/// Invisible to UI. Yes, client security is a sham, but we can cross that bridge when we need to.
#define RIG_COMPONENT_UI_HIDDEN					0
/// UI gives name and description. Every other UI option but hidden implies this.
#define RIG_COMPONENT_UI_NONE					1
/// UI that gives a list of buttons, toggles, and selectors.
#define RIG_COMPONENT_UI_GENERIC				2

// Hotbinds
/// Max rig hotbinds
#define RIG_MAX_HOTBINDS						10

// Component conflict types - bitfield.


// List names for component conflict types.
GLOBAL_LIST_INIT(rig_component_conflict_names, list(

))

