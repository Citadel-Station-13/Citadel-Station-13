// Bodytypes - these are flags but in some cases like equip procs/icon gen procs should only be one at a time.
/// normal
#define BODYTYPE_HUMAN						(1<<0)
/// muzzle - sensical for headgear, etc
#define BODYTYPE_MUZZLE						(1<<1)
///




#warn oh god..

/**
 * the file considering ALL THE AWFULNESS around
 *
 * bodytypes
 * taurs
 * digitgrade defines
 * etc
 */

//flags for alternate styles: These are hard sprited so don't set this if you didn't put the effort in
#define NORMAL_STYLE		0
#define ALT_STYLE			1

//flags for female outfits: How much the game can safely "take off" the uniform without it looking weird
#define NO_FEMALE_UNIFORM			0
#define FEMALE_UNIFORM_FULL			1
#define FEMALE_UNIFORM_TOP			2

//flags for outfits that have mutant race variants: Most of these require additional sprites to work.
#define STYLE_DIGITIGRADE		(1<<0) //jumpsuits, suits and shoes
#define STYLE_MUZZLE			(1<<1) //hats or masks
#define STYLE_SNEK_TAURIC		(1<<2) //taur-friendly suits
#define STYLE_PAW_TAURIC		(1<<3)
#define STYLE_HOOF_TAURIC		(1<<4)
#define STYLE_ALL_TAURIC		(STYLE_SNEK_TAURIC|STYLE_PAW_TAURIC|STYLE_HOOF_TAURIC)
#define STYLE_NO_ANTHRO_ICON	(1<<5) //When digis fit the default sprite fine and need no copypasted states. This is the case of skirts and winter coats, for example.
#define USE_SNEK_CLIP_MASK		(1<<6)
#define USE_QUADRUPED_CLIP_MASK	(1<<7)
#define USE_TAUR_CLIP_MASK		(USE_SNEK_CLIP_MASK|USE_QUADRUPED_CLIP_MASK)

//digitigrade legs settings.
#define NOT_DIGITIGRADE				0
#define FULL_DIGITIGRADE			1
#define SQUISHED_DIGITIGRADE		2
