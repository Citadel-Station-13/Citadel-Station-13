// timed_action_flags parameter for `/proc/do_after`
/// Can do the action even if target is not added to doafters
#define IGNORE_TARGET_IN_DOAFTERS (1<<0)
/// Can do the action even if mob moves location
#define IGNORE_USER_LOC_CHANGE (1<<1)
/// Can do the action even if the target moves location
#define IGNORE_TARGET_LOC_CHANGE (1<<2)
/// Can do the action even if the item is no longer being held
#define IGNORE_HELD_ITEM (1<<3)
/// Can do the action even if the mob is incapacitated (ex. handcuffed)
#define IGNORE_INCAPACITATED (1<<4)
