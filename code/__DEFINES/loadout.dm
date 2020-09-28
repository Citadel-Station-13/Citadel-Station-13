//defines for loadout categories
//no category defines
#define LOADOUT_CATEGORY_NONE			"ERROR"
#define LOADOUT_SUBCATEGORY_NONE		"Miscellaneous"
#define LOADOUT_SUBCATEGORIES_NONE		list("Miscellaneous")

//backpack
#define LOADOUT_CATEGORY_BACKPACK 				"In backpack"
#define LOADOUT_SUBCATEGORY_BACKPACK_GENERAL 	"General" //basically anything that there's not enough of to have its own subcategory
#define LOADOUT_SUBCATEGORY_BACKPACK_TOYS 		"Toys"
//neck
#define LOADOUT_CATEGORY_NECK "Neck"
#define LOADOUT_SUBCATEGORY_NECK_GENERAL 	"General"
#define LOADOUT_SUBCATEGORY_NECK_TIE 		"Ties"
#define LOADOUT_SUBCATEGORY_NECK_SCARVES 	"Scarves"

//mask
#define LOADOUT_CATEGORY_MASK "Mask"

//hands
#define LOADOUT_CATEGORY_HANDS 				"Hands"

//uniform
#define LOADOUT_CATEGORY_UNIFORM 			"Uniform" //there's so many types of uniform it's best to have lots of categories
#define LOADOUT_SUBCATEGORY_UNIFORM_GENERAL "General"
#define LOADOUT_SUBCATEGORY_UNIFORM_JOBS 	"Jobs"
#define LOADOUT_SUBCATEGORY_UNIFORM_SUITS	"Suits"
#define LOADOUT_SUBCATEGORY_UNIFORM_SKIRTS	"Skirts"
#define LOADOUT_SUBCATEGORY_UNIFORM_DRESSES	"Dresses"
#define LOADOUT_SUBCATEGORY_UNIFORM_SWEATERS	"Sweaters"
#define LOADOUT_SUBCATEGORY_UNIFORM_PANTS	"Pants"
#define LOADOUT_SUBCATEGORY_UNIFORM_SHORTS	"Shorts"

//suit
#define LOADOUT_CATEGORY_SUIT 				"Suit"
#define LOADOUT_SUBCATEGORY_SUIT_GENERAL 	"General"
#define LOADOUT_SUBCATEGORY_SUIT_COATS 		"Coats"
#define LOADOUT_SUBCATEGORY_SUIT_JACKETS 	"Jackets"
#define LOADOUT_SUBCATEGORY_SUIT_JOBS 		"Jobs"

//head
#define LOADOUT_CATEGORY_HEAD 				"Head"
#define LOADOUT_SUBCATEGORY_HEAD_GENERAL 	"General"
#define LOADOUT_SUBCATEGORY_HEAD_JOBS 		"Jobs"

//shoes
#define LOADOUT_CATEGORY_SHOES 		"Shoes"

//gloves
#define LOADOUT_CATEGORY_GLOVES		"Gloves"

//glasses
#define LOADOUT_CATEGORY_GLASSES	"Glasses"

//donator items
#define LOADOUT_CATEGORY_DONATOR	"Donator"

//how many prosthetics can we have
#define MAXIMUM_LOADOUT_PROSTHETICS	2

//what limbs can be amputated or be prosthetic
#define LOADOUT_ALLOWED_LIMB_TARGETS	list(BODY_ZONE_L_ARM,BODY_ZONE_R_ARM,BODY_ZONE_L_LEG,BODY_ZONE_R_LEG)

//options for modifiying limbs
#define LOADOUT_LIMB_NORMAL			"Normal"
#define LOADOUT_LIMB_PROSTHETIC		"Prosthetic"
#define LOADOUT_LIMB_AMPUTATED		"Amputated"

#define LOADOUT_LIMBS		 		list(LOADOUT_LIMB_NORMAL,LOADOUT_LIMB_PROSTHETIC,LOADOUT_LIMB_AMPUTATED) //you can amputate your legs/arms though

//Special thing that i had to make it myself because skyrat uses old loadout
//Underwear Sandcode changes
#define LOADOUT_CATEGORY_GENERAL_UNDER			"General Underwear"
#define LOADOUT_SUBCATEGORY_UNDERWEAR		"Underwear"
#define LOADOUT_SUBCATEGORY_SHIRT		"Shirt"
#define LOADOUT_SUBCATEGORY_SOCKS		"Socks"
//

//And wrists!
#define LOADOUT_CATEGORY_WRISTS			"Wrists"
#define LOADOUT_SUBCATEGORY_WATCHES		"Watches"
