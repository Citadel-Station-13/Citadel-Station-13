/// Used to trigger signals and call procs registered for that signal
/// The datum hosting the signal is automaticaly added as the first argument
/// Returns a bitfield gathered from all registered procs
/// Arguments given here are packaged in a list and given to _SendSignal
#define SEND_SIGNAL(target, sigtype, arguments...) ( !target.comp_lookup || !target.comp_lookup[sigtype] ? NONE : target._SendSignal(sigtype, list(target, ##arguments)) )

#define SEND_GLOBAL_SIGNAL(sigtype, arguments...) ( SEND_SIGNAL(SSdcs, sigtype, ##arguments) )

/// Get comsig for an alarm trigger
#define ALARM_TRIGGER_COMSIG(network)		"!alarm_trigger_[network]"
/// Get comsig for an alarm clear
#define ALARM_CLEAR_COMSIG(network)			"!alarm_clear_[network]"

/// Register for an alarm on a network. Check SSalarms, signal is sent with (area/A, alarm_types (as bitflag, will not retrigger for ones already active), datum/source)
#define RegisterAlarmTrigger(network, proc)		RegisterSignal(SSalarms, ALARM_TRIGGER_COMSIG(network), proc)
/// Ditto but for clear [REGISTER_ALARM_TRIGGER]
#define RegisterAlarmClear(network, proc)			RegisterSignal(SSalarms, ALARM_CLEAR_COMSIG(network), proc)

/// Ditto for these two
#define UNREGISTER_ALARM_TRIGGER(network)			UnregisterSignal(SSalarms, ALARM_TRIGGER_COMSIG(network))
/// Same
#define UNREGISTER_ALARM_CLEAR(network)				UnregisterSignal(SSalarms, ALARM_CLEAR_COMSIG(network))

/// A wrapper for _AddElement that allows us to pretend we're using normal named arguments
#define AddElement(arguments...) _AddElement(list(##arguments))

/// A wrapper for _RemoveElement that allows us to pretend we're using normal named arguments
#define RemoveElement(arguments...) _RemoveElement(list(##arguments))

/// A wrapper for _AddComponent that allows us to pretend we're using normal named arguments
#define AddComponent(arguments...) _AddComponent(list(##arguments))
