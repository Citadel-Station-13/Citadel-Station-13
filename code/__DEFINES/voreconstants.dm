// Overhauled vore system
#define DM_HOLD "Hold"
#define DM_DIGEST "Digest"
#define DM_HEAL "Heal"
#define DM_ABSORB "Absorb"
#define DM_DIGESTF "Fast Digest"

#define VORE_STRUGGLE_EMOTE_CHANCE 40

// Stance for hostile mobs to be in while devouring someone.
#define HOSTILE_STANCE_EATING	99


var/global/list/player_sizes_list = list("Macro" = RESIZE_HUGE, "Big" = RESIZE_BIG, "Normal" = RESIZE_NORMAL, "Small" = RESIZE_SMALL, "Tiny" = RESIZE_TINY)


var/global/list/digestion_sounds = list(
		'sound/vore/digest1.ogg',
		'sound/vore/digest2.ogg',
		'sound/vore/digest3.ogg',
		'sound/vore/digest4.ogg',
		'sound/vore/digest5.ogg',
		'sound/vore/digest6.ogg',
		'sound/vore/digest7.ogg',
		'sound/vore/digest8.ogg',
		'sound/vore/digest9.ogg',
		'sound/vore/digest10.ogg',
		'sound/vore/digest11.ogg',
		'sound/vore/digest12.ogg')

var/global/list/death_sounds = list(
		'sound/vore/death1.ogg',
		'sound/vore/death2.ogg',
		'sound/vore/death3.ogg',
		'sound/vore/death4.ogg',
		'sound/vore/death5.ogg',
		'sound/vore/death6.ogg',
		'sound/vore/death7.ogg',
		'sound/vore/death8.ogg',
		'sound/vore/death9.ogg',
		'sound/vore/death10.ogg')

var/global/list/vore_sounds = list(
		"Gulp" = 'sound/vore/gulp.ogg',
		"Insert" = 'sound/vore/insert.ogg',
		"Insertion1" = 'sound/vore/insertion1.ogg',
		"Insertion2" = 'sound/vore/insertion2.ogg',
		"Insertion3" = 'sound/vore/insertion3.ogg',
		"Schlorp" = 'sound/vore/schlorp.ogg',
		"Squish1" = 'sound/vore/squish1.ogg',
		"Squish2" = 'sound/vore/squish2.ogg',
		"Squish3" = 'sound/vore/squish3.ogg',
		"Squish4" = 'sound/vore/squish4.ogg')

var/global/list/struggle_sounds = list(
		"Squish1" = 'sound/vore/squish1.ogg',
		"Squish2" = 'sound/vore/squish2.ogg',
		"Squish3" = 'sound/vore/squish3.ogg',
		"Squish4" = 'sound/vore/squish4.ogg')

	//Species listing

#define iscanine(A) (is_species(A, /datum/species/canine))
#define isfeline(A) (is_species(A, /datum/species/feline))
#define isavian(A) (is_species(A, /datum/species/avian))
#define isrodent(A) (is_species(A, /datum/species/rodent))
#define isherbivorous(A) (is_species(A, /datum/species/herbivorous))
#define isexotic(A) (is_species(A, /datum/species/exotic))
/*
var/list/canine_species = list (
anubis,
corgi,
coyote,
dalmatian,
fennec,
fox,
husky,
wolf,
sheperd,
lab,
otusian
)

var/list/feline_species = list (
panther,
tajaran,
smilodon
)

var/list/avian_species = list (
corvid,
hawk
)

var/list/lizard_species = list (
crocodile,
drake,
gria,
lizard,
naga,
turtle,
shark
)

var/list/rodent_species = list (
aramdillo,
beaver,
jackalope,
leporid,
murid,
otter,
porcupine,
possum,
raccoon,
roorat,
skunk,
squirrel
)

var/list/herbivorous_species = list (
boar,
capra,
cow,
deer,
hippo,
kangaroo,
pig
)

var/list/exotic_species = list (
alien,
carp,
drider,
glowfen,
jelly,
moth,
plant,
seaslug,
slime,
)

var/list/taur = list (
panther,
tajaran,
horse,
lab,
sheperd,
fox,
cow,
husky,
naga,
wolf,
dirder,
drake,
otie
)

	//Mutant Human bits
var/global/list/tails_list_human = list()
var/global/list/animated_tails_list_human = list()
// var/global/list/ears_list = list()
var/global/list/wings_list = list()

/proc/log_debug(text)
	if (config.log_debug)
		diary << "\[[time_stamp()]]DEBUG: [text][log_end]"

	for(var/client/C in admins)
		if(C.prefs.toggles & CHAT_DEBUGLOGS)
			C << "DEBUG: [text]" */