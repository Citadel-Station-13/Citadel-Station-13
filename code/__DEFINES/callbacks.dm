#define GLOBAL_PROC	"some_magic_bullshit"
#define CHANGETURF_PROTOTYPE	"more_magic_bullshit" //Meant for change_turf only, new turfs are spawned after old ones are deleted.
/// A shorthand for the callback datum, [documented here](datum/callback.html)
#define CALLBACK new /datum/callback
#define INVOKE_ASYNC world.ImmediateInvokeAsync
#define CALLBACK_NEW(typepath, args) CALLBACK(GLOBAL_PROC, /proc/___callbacknew, typepath, args)
