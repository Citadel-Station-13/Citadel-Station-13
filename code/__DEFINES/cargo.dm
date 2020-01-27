#define STYLE_STANDARD 1
#define STYLE_BLUESPACE 2
#define STYLE_CENTCOM 3
#define STYLE_SYNDICATE 4
#define STYLE_BLUE 5
#define STYLE_CULT 6
#define STYLE_MISSILE 7
#define STYLE_RED_MISSILE 8
#define STYLE_BOX 9
#define STYLE_HONK 10
#define STYLE_FRUIT 11
#define STYLE_INVISIBLE 12
#define STYLE_GONDOLA 13
#define STYLE_SEETHROUGH 14

#define POD_ICON_STATE 1
#define POD_NAME 2
#define POD_DESC 3

#define POD_STYLES list(\
	list("supplypod", "supply pod", "A Nanotrasen supply drop pod."),\
	list("bluespacepod", "bluespace supply pod" , "A Nanotrasen Bluespace supply pod. Teleports back to CentCom after delivery."),\
	list("centcompod", "\improper Centcom supply pod", "A Nanotrasen supply pod, this one has been marked with Central Command's designations. Teleports back to Centcom after delivery."),\
	list("syndiepod", "blood-red supply pod", "A dark, intimidating supply pod, covered in the blood-red markings of the Syndicate. It's probably best to stand back from this."),\
	list("squadpod", "\improper MK. II supply pod", "A Nanotrasen supply pod. This one has been marked the markings of some sort of elite strike team."),\
	list("cultpod", "bloody supply pod", "A Nanotrasen supply pod covered in scratch-marks, blood, and strange runes."),\
	list("missilepod", "cruise missile", "A big ass missile that didn't seem to fully detonate. It was likely launched from some far-off deep space missile silo. There appears to be an auxillery payload hatch on the side, though manually opening it is likely impossible."),\
	list("smissilepod", "\improper Syndicate cruise missile", "A big ass, blood-red missile that didn't seem to fully detonate. It was likely launched from some deep space Syndicate missile silo. There appears to be an auxillery payload hatch on the side, though manually opening it is likely impossible."),\
	list("boxpod", "\improper Aussec supply crate", "An incredibly sturdy supply crate, designed to withstand orbital re-entry. Has 'Aussec Armory - 2532' engraved on the side."),\
	list("honkpod", "\improper HONK pod", "A brightly-colored supply pod. It likely originated from the Clown Federation."),\
	list("fruitpod", "\improper Orange", "An angry orange."),\
	list("", "\improper S.T.E.A.L.T.H. pod MKVII", "A supply pod that, under normal circumstances, is completely invisible to conventional methods of detection. How are you even seeing this?"),\
    list("gondolapod", "gondola", "The silent walker. This one seems to be part of a delivery agency."),\
    list("", "", "")\
)

//cargo groups defines
//Keep in mind they are displayed in the UI, thus shouldn't have underscores and be properly capitalized.
#define CARGO_GROUP_ARMORY "Armory"
#define CARGO_GROUP_TOYS "Costumes & Toys"
#define CARGO_GROUP_EMERGENCY "Emergency"
#define CARGO_GROUP_ENGINE "Engine Construction"
#define CARGO_GROUP_ENGINEERING "Engineering"
#define CARGO_GROUP_CRITTER "Livestock"
#define CARGO_GROUP_MATERIALS "Canisters & Materials"
#define CARGO_GROUP_MEDICAL "Medical"
#define CARGO_GROUP_MISC "Miscellaneous Supplies"
#define CARGO_GROUP_ORGANIC "Food & Hydroponics"
#define CARGO_GROUP_SCIENCE "Science"
#define CARGO_GROUP_SECURITY "Security"
#define CARGO_GROUP_SERVICE "Service"

//Defines for extra cargo groups. These can have underscores and the like.
#define CARGO_GROUP_DISCO_INFERNO "disco_inferno" //spend lot of credits in this group (or science) to unlock that shuttle.
#define CARGO_GROUP_CONTRABAND "contraband"
#define CARGO_GROUP_EMAG "emag"
