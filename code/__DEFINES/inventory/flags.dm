// /obj/item/var/inv_flags
/// Affects pressure resistance - requires recalculation
#define INV_FLAG_PRESSURE_AFFECTING			(1<<0)
/// Affects temperature resistance - requires recalculation
#define INV_FLAG_TEMPERATURE_AFFECTING		(1<<1)
/// Affects armor - requires recalculation
#define INV_FLAG_ARMOR_AFFECTING			(1<<2)

// /obj/item/var/inv_hide - **these apply regardless of what the item's coverage zones are.** Be SMART with these.
#define HIDEGLOVES		(1<<0)
#define HIDESUITSTORAGE	(1<<1)
#define HIDEJUMPSUIT	(1<<2)	//these first four are only used in exterior suits
#define HIDESHOES		(1<<3)
#define HIDEMASK		(1<<4)	//these last six are only used in masks and headgear.
#define HIDEEARS		(1<<5)	// (ears means headsets and such)
#define HIDEEYES		(1<<6)	// Whether eyes and glasses are hidden
#define HIDEFACE		(1<<7)	// Whether we appear as unknown.
#define HIDEHAIR		(1<<8)
#define HIDEFACIALHAIR	(1<<9)
#define HIDENECK		(1<<10)
#define HIDETAUR		(1<<11) //gotta hide that snowflake
#define HIDESNOUT		(1<<12) //or do we actually hide our snoots
#define HIDEACCESSORY	(1<<13) //hides the jumpsuit accessory.

/// sensitive inv_hide flags that requires a face rerender
#define INV_HIDE_FACE_UPDATE			(HIDEEYES|HIDEHAIR|HIDEFACIALHAIR|HIDESNOUT)
/// sensitive inv_hide flags that require a lower body rerender
#define INV_HIDE_BODY_UPDATE			(HIDETAUR)
/// sensitive inv_hide flags that require an identity update
#define INV_HIDE_IDENTITY_UPDATE		(HIDEFACE)
