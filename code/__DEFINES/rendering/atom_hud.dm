// for secHUDs and medHUDs and variants. The number is the location of the image on the list hud_list
// note: if you add more HUDs, even for non-human atoms, make sure to use unique numbers for the defines!
// /datum/atom_hud expects these to be unique
// these need to be strings in order to make them associative lists

/// Dead, alive, sick, health status
#define HEALTH_HUD "1"
/// A simple line rounding the mob's number health
#define STATUS_HUD "2"
/// The job asigned to your ID
#define ID_HUD "3"
/// Wanted, released, parroled, security status
#define WANTED_HUD "4"
/// Loyality implant
#define IMPLOYAL_HUD "5"
/// Chemical implant
#define IMPCHEM_HUD "6"
/// Tracking implant
#define IMPTRACK_HUD "7"
/// Silicon/Mech/Circuit Status
#define DIAG_STAT_HUD "8"
/// Silicon health bar
#define DIAG_HUD "9"
/// Borg/Mech/Circutry power meter
#define DIAG_BATT_HUD "10"
/// Mech health bar
#define DIAG_MECH_HUD "11"
/// Bot HUDs
#define DIAG_BOT_HUD "12"
/// Circuit assembly health bar
#define DIAG_CIRCUIT_HUD "13"
/// Mech/Silicon tracking beacon, Circutry long range icon
#define DIAG_TRACK_HUD "14"
/// Airlock shock overlay
#define DIAG_AIRLOCK_HUD "15"
/// Bot path indicators
#define DIAG_PATH_HUD "16"
/// Gland indicators for abductors
#define GLAND_HUD "17"
#define SENTIENT_DISEASE_HUD "18"
#define AI_DETECT_HUD "19"
#define NANITE_HUD "20"
#define DIAG_NANITE_FULL_HUD "21"
/// Radation alerts for medical huds
#define RAD_HUD "22"
/// Displays launchpads' targeting reticle
#define DIAG_LAUNCHPAD_HUD "23"
/// Displays damage numbers, NOT USED BY THE ATOM TAKING DAMAGE, BUT RATHER AN EFFECT CREATED ON THEIR LOCATION
#define DAMAGE_INDICATOR_HUD "24"
/// For antag huds. these are used at the /mob level
#define ANTAG_HUD "25"

//by default everything in the hud_list of an atom is an image
//a value in hud_list with one of these will change that behavior
#define HUD_LIST_LIST 1

//data HUD (medhud, sechud) defines
//Don't forget to update human/New() if you change these!
#define DATA_HUD_SECURITY_BASIC 1
#define DATA_HUD_SECURITY_ADVANCED 2
#define DATA_HUD_MEDICAL_BASIC 3
#define DATA_HUD_MEDICAL_ADVANCED 4
#define DATA_HUD_DIAGNOSTIC_BASIC 5
#define DATA_HUD_DIAGNOSTIC_ADVANCED 6
#define DATA_HUD_ABDUCTOR 7
#define DATA_HUD_DAMAGE_INDICATOR 8
#define DATA_HUD_SENTIENT_DISEASE 9
#define DATA_HUD_AI_DETECT 10

//antag HUD defines
#define ANTAG_HUD_CULT 11
#define ANTAG_HUD_REV 12
#define ANTAG_HUD_OPS 13
#define ANTAG_HUD_WIZ 14
#define ANTAG_HUD_SHADOW     15
#define ANTAG_HUD_TRAITOR  16
#define ANTAG_HUD_NINJA  17
#define ANTAG_HUD_CHANGELING  18
#define ANTAG_HUD_ABDUCTOR  19
#define ANTAG_HUD_DEVIL 20
#define ANTAG_HUD_SINTOUCHED 21
#define ANTAG_HUD_SOULLESS 22
#define ANTAG_HUD_CLOCKWORK 23
#define ANTAG_HUD_BROTHER 24
#define ANTAG_HUD_BLOODSUCKER   25
#define ANTAG_HUD_FUGITIVE 26
#define ANTAG_HUD_HERETIC     27
#define ANTAG_HUD_SPACECOP 28
#define ANTAG_HUD_GANGSTER 29

/// Cooldown for being shown the images for any particular data hud
#define ADD_HUD_TO_COOLDOWN 20
