// Defines for managed input/keybinding system.
/// Max length of a keypress command before it's considered to be a forged packet/bogus command
#define MAX_KEYPRESS_COMMANDLENGTH 64
/// Maximum keys that can be bound to one button
#define MAX_COMMANDS_PER_KEY 5
/// Maximum keys per keybind
#define MAX_KEYS_PER_KEYBIND 3
/// Max amount of keypress messages per second over two seconds before client is autokicked
#define MAX_KEYPRESS_AUTOKICK 100
/// Max keys that can be held down at once by a client
#define MAX_HELD_KEYS 15

/// Macroset name of hotkeys/keybind only/modern mode
#define SKIN_MACROSET_HOTKEYS "hotkeys"
/// Macroset name of classic hotkey mode
#define SKIN_MACROSET_CLASSIC_HOTKEYS "oldhotkeys"
/// Macroset name of classic input mode
#define SKIN_MACROSET_CLASSIC_INPUT "oldinput"
