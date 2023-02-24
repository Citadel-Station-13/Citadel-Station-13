/// Context applied to LMB actions
#define SCREENTIP_CONTEXT_LMB "LMB"

/// Context applied to RMB actions
#define SCREENTIP_CONTEXT_RMB "RMB"

/// Context applied to Shift-LMB actions
#define SCREENTIP_CONTEXT_SHIFT_LMB "Shift-LMB"

/// Context applied to Ctrl-LMB actions
#define SCREENTIP_CONTEXT_CTRL_LMB "Ctrl-LMB"

/// Context applied to Ctrl-RMB actions
#define SCREENTIP_CONTEXT_CTRL_RMB "Ctrl-RMB"

/// Context applied to Alt-LMB actions
#define SCREENTIP_CONTEXT_ALT_LMB "Alt-LMB"

/// Context applied to Alt-RMB actions
#define SCREENTIP_CONTEXT_ALT_RMB "Alt-RMB"

/// Context applied to Ctrl-Shift-LMB actions
#define SCREENTIP_CONTEXT_CTRL_SHIFT_LMB "Ctrl-Shift-LMB"

/// Screentips are always disabled
#define SCREENTIP_PREFERENCE_DISABLED "Disabled"

/// Screentips are always enabled
#define SCREENTIP_PREFERENCE_ENABLED "Enabled"

/// Screentips are only enabled when they have context
#define SCREENTIP_PREFERENCE_CONTEXT_ONLY "Only with tips"

/// Screentips enabled, no context
#define SCREENTIP_PREFERENCE_NO_CONTEXT "Enabled without tips"

/// Regardless of intent
#define INTENT_ANY "any"

GLOBAL_LIST_INIT(screentip_pref_options, list(
	SCREENTIP_PREFERENCE_DISABLED,
	SCREENTIP_PREFERENCE_ENABLED,
	SCREENTIP_PREFERENCE_CONTEXT_ONLY,
	SCREENTIP_PREFERENCE_NO_CONTEXT
))
