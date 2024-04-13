// mouse signals. Format:
// When the signal is called: (signal arguments)
// All signals send the source datum of the signal as the first argument

///from base of client/Click(): (atom/target, atom/location, control, params, mob/user)
#define COMSIG_CLIENT_CLICK "atom_client_click"
///from base of atom/Click(): (atom/location, control, params, mob/user)
#define COMSIG_CLICK "atom_click"
///from base of atom/ShiftClick(): (/mob)
#define COMSIG_CLICK_SHIFT "shift_click"
	/// Allows the user to examinate regardless of client.eye.
	#define COMPONENT_ALLOW_EXAMINATE (1<<0)
	/// Higher priority compared to the above one
	#define COMPONENT_DENY_EXAMINATE (1<<1)
///from base of atom/CtrlClickOn(): (/mob)
#define COMSIG_CLICK_CTRL "ctrl_click"
///from base of atom/AltClick(): (/mob)
#define COMSIG_CLICK_ALT "alt_click"
///from base of atom/CtrlShiftClick(/mob)
#define COMSIG_CLICK_CTRL_SHIFT "ctrl_shift_click"
///from base of atom/MouseDrop(): (/atom/over, /mob/user)
#define COMSIG_MOUSEDROP_ONTO "mousedrop_onto"
	#define COMPONENT_NO_MOUSEDROP (1<<0)
///from base of atom/MouseDrop_T: (/atom/from, /mob/user)
#define COMSIG_MOUSEDROPPED_ONTO "mousedropped_onto"			//from base of atom/MouseDrop_T: (/atom/from, /mob/user)
