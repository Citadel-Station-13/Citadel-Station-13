//Human Overlays Indexes/////////
//LOTS OF CIT CHANGES HERE. BE CAREFUL WHEN UPSTREAM ADDS MORE LAYERS
#define MUTATIONS_LAYER			34		//mutations. Tk headglows, cold resistance glow, etc
#define ANTAG_LAYER 			33		//stuff for things like cultism indicators (clock cult glow, cultist red halos, whatever else new that comes up)
#define GENITALS_BEHIND_LAYER	32		//Some genitalia needs to be behind everything, such as with taurs (Taurs use body_behind_layer
#define BODY_BEHIND_LAYER		31		//certain mutantrace features (tail when looking south) that must appear behind the body parts
#define BODYPARTS_LAYER			30		//Initially "AUGMENTS", this was repurposed to be a catch-all bodyparts flag
#define MARKING_LAYER			29		//Matrixed body markings because clashing with snouts?
#define BODY_ADJ_LAYER			28		//certain mutantrace features (snout, body markings) that must appear above the body parts
#define GENITALS_FRONT_LAYER	27		//Draws some genitalia above clothes and the TAUR body if need be.
#define BODY_LAYER				26		//underwear, undershirts, socks, eyes, lips(makeup)
#define BODY_ADJ_UPPER_LAYER	25
#define FRONT_MUTATIONS_LAYER	24		//mutations that should appear above body, body_adj and bodyparts layer (e.g. laser eyes)
#define DAMAGE_LAYER			23		//damage indicators (cuts and burns)
#define UNIFORM_LAYER			22
#define ID_LAYER				21
#define HANDS_PART_LAYER		20
#define SHOES_LAYER				19
#define GLOVES_LAYER			18
#define EARS_LAYER				17
#define SUIT_LAYER				16
#define GENITALS_EXPOSED_LAYER	15
#define GLASSES_LAYER			14
#define BELT_LAYER				13		//Possible make this an overlay of somethign required to wear a belt?
#define SUIT_STORE_LAYER		12
#define NECK_LAYER				11
#define BACK_LAYER				10
#define HAIR_LAYER				9		//TODO: make part of head layer?
#define HORNS_LAYER				8
#define FACEMASK_LAYER			7
#define HEAD_LAYER				6
#define HANDCUFF_LAYER			5
#define LEGCUFF_LAYER			4
#define HANDS_LAYER				3
#define BODY_FRONT_LAYER		2
#define FIRE_LAYER				1		//If you're on fire
#define TOTAL_LAYERS			34		//KEEP THIS UP-TO-DATE OR SHIT WILL BREAK ;_;

//Human Overlay Index Shortcuts for alternate_worn_layer, layers
//Because I *KNOW* somebody will think layer+1 means "above"
//IT DOESN'T OK, IT MEANS "UNDER"
#define UNDER_SUIT_LAYER			(SUIT_LAYER+1)
#define UNDER_HEAD_LAYER			(HEAD_LAYER+1)

//AND -1 MEANS "ABOVE", OK?, OK!?!
#define ABOVE_SHOES_LAYER			(SHOES_LAYER-1)
#define ABOVE_BODY_FRONT_LAYER		(BODY_FRONT_LAYER-1)
