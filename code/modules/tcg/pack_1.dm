/datum/tcg_card/pack_1
	pack = 'icons/obj/tcg/pack_1.dmi'

//COMMAND

/datum/tcg_card/pack_1/captain
	name = "Captain"
	desc = "Nanotrasen hires a captain for every station. However, most of the time they just drink wishkey and secure the disk."
	rules = "Human. Tap this card for 1 mana: inflict -1/-1 to an opposing creature card."
	icon_state = "captain"

	mana_cost = 7
	attack = 5
	health = 5

	faction = "Command"
	rarity = "Epic"
	card_type = "Unit"

/datum/tcg_card/pack_1/captain_hardsuit
	name = "Apadyne Technologies Mk.2 R.I.O.T. Suit (Captain's Version)"
	desc = "A heavily customised Apadyne Technologies Mk.2 R.I.O.T. Suit, rebuilt and refitted to Nanotrasen's highest standards for issue to Station Captains."
	rules = "On equip: Equipped unit gains +1/+1 for one turn"
	icon_state = "captain_hardsuit"

	mana_cost = 3
	attack = -1
	health = 5

	faction = "Command"
	rarity = "Legendary"
	card_type = "Equipment"

/datum/tcg_card/pack_1/hop
	name = "Head of Personnel"
	desc = "The head of the Cargo and Service Departments, guardian of all access, and Ian's lovable, yet dumb, sidekick."
	rules = "Human. Blocker. Once per turn: A friendly card of your choice attacks twice."
	icon_state = "hop"

	mana_cost = 7
	attack = 4
	health = 3

	faction = "Command"
	rarity = "Rare"
	card_type = "Unit"

/datum/tcg_card/pack_1/ian_hop
	name = "Head of Ians"
	desc = "What can be better than a corgi? A corgi with all access and HoP's hat!"
	rules = "On summon: Summon a Command unit for free."
	icon_state = "hop_ian"

	mana_cost = 5
	attack = 0
	health = 4

	faction = "Command"
	rarity = "Epic"
	card_type = "Unit"

/datum/tcg_card/pack_1/cmo
	name = "Chief Medical Officer"
	desc = "Head of the medical department, the CMO is expected to maintain the standards of his underlings."
	rules = "Human. Whenever a Medical unit gains power, it gains +1 more."
	icon_state = "cmo"

	mana_cost = 5
	attack = 4
	health = 4

	faction = "Command"
	rarity = "Common"
	card_type = "Unit"

/datum/tcg_card/pack_1/cmo_suit
	name = "DeForest Medical Corporation 'Lifesaver' Carapace"
	desc = "An advanced voidsuit designed for emergency medical personnel. Features include a built-in medical HUD and advanced medical gauntlets."
	rules = "Tap this card: Re-equip 'DeForest Medical Corporation 'Lifesaver' Carapace' on a different friendly creature"
	icon_state = "cmo_hardsuit"

	mana_cost = 3
	attack = 1
	health = 3

	faction = "Command"
	rarity = "Rare"
	card_type = "Equipment"

/datum/tcg_card/pack_1/hos
	name = "Head of Security"
	desc = "Nanotrasen hires most heads of staff based on their qualifications as being amicable, good at conflict resolution, ability to handle high-stakes situations, humanity, and desire to learn. Heads of Security only need a highschool degree."
	rules = "Human. All opponent's cards cost 1 more until Head Of Security is removed from the battlefield."
	icon_state = "hos"

	mana_cost = 7
	attack = 4
	health = 4

	faction = "Command"
	rarity = "Rare"
	card_type = "Unit"

/datum/tcg_card/pack_1/hos_suit
	name = "Apadyne Technologies 'Tyrant' Class Hardshell"
	desc = "The distinctive shape of the Tyrant Class Hardshell is caused, in part, by the large amount of kevlar reinforcement and the ablative armour layer. Perhaps more importantly, it also looks rad."
	rules = "Grant the equipped card Fury."
	icon_state = "hos_hardsuit"

	mana_cost = 6
	attack = 4
	health = 2

	faction = "Command"
	rarity = "Epic"
	card_type = "Equipment"

/datum/tcg_card/pack_1/ce
	name = "Chief Engineer"
	desc = "The Chief Engineer is in charge of keeping the station powered and intact. Most of CE's usually fail this task."
	rules = "Human. Protect a friendly card from one spell."
	icon_state = "ce"

	mana_cost = 6
	attack = 3
	health = 6

	faction = "Command"
	rarity = "Rare"
	card_type = "Unit"

/datum/tcg_card/pack_1/ce_suit
	name = "Nakamura Engineering R.I.G.Suit (Advanced)"
	desc = "An updated version of Nakamura Engineering's R.I.G.Suit fitted with advanced radiation shielding and extra armour."
	rules = "On equip: Equipped creature is protected from one spell."
	icon_state = "ce_hardsuit"

	mana_cost = 3
	attack = 0
	health = 3

	faction = "Command"
	rarity = "Rare"
	card_type = "Equipment"

/datum/tcg_card/pack_1/rd
	name = "Research Director"
	desc = "The Research Director is the head of the Science Division and is responsible for shockingly directing research."
	rules = "Human. All Science card activate their effects twice."
	icon_state = "rd"

	mana_cost = 7
	attack = 2
	health = 5

	faction = "Command"
	rarity = "Common"
	card_type = "Unit"

/datum/tcg_card/pack_1/rd_suit
	name = "Nakamura Engineering B.O.M.B.Suit"
	desc = "The Nakamura Engineering B.O.M.B.Suit is an innovative combination of a R.I.G.Suit and a bomb suit perfect for toxins research."
	rules = "Reduces all incoming damage for 1. Does not work if damage is lethal."
	icon_state = "rd_hardsuit"

	mana_cost = 3
	attack = 0
	health = 0

	faction = "Command"
	rarity = "Rare"
	card_type = "Equipment"


//COMMAND END

//SILICONS

/datum/tcg_card/pack_1/ai
	name = "AI"
	desc = "The latest generation of NT's top secret artificial intelligence project this time with actual human brains in a jar! Don't tell the press though."
	rules = "Asimov. All silicon cards gain +1/0 while this creature is alive."
	icon_state = "ai"

	mana_cost = 5
	attack = 3
	health = 6

	faction = "Silicon"
	rarity = "Epic"
	card_type = "Unit"

/datum/tcg_card/pack_1/pai
	name = "Personal AI Device"
	desc = "Personal AI Devices are able to take the form of many household pets to provide a homely sense of comfort and companionship to their owners."
	rules = "Asimov. Taunt."
	icon_state = "pai"

	mana_cost = 2
	attack = 1
	health = 1

	faction = "Silicon"
	rarity = "Common"
	card_type = "Unit"

/datum/tcg_card/pack_1/cyborg
	name = "Cyborg"
	desc = "Created as part of humanity's first foray into artificial intelligence the original cyborg models used organic parts in lieu of sophisticated artificial brains."
	rules = "Asimov."
	icon_state = "borg_basic"

	mana_cost = 2
	attack = 3
	health = 3

	faction = "Silicon"
	rarity = "Common"
	card_type = "Unit"

/datum/tcg_card/pack_1/cyborg_clown
	name = "Cyborg (Clown Shell)"
	desc = "The clown shell is a new development in cyborg technology designed to capture the joyous hijinks of the station clown in a notably more macabre and disturbing fashion."
	rules = "Asimov. Taunt."
	icon_state = "borg_clown"

	mana_cost = 2
	attack = 2
	health = 4

	faction = "Silicon"
	rarity = "Common"
	card_type = "Unit"

/datum/tcg_card/pack_1/cyborg_engi
	name = "Cyborg (Engineering Shell)"
	desc = "A common sight on Nanotrasen Stations Engineering Shells maintain critical station systems in hazardous conditions."
	rules = "Asimov."
	icon_state = "borg_engi"

	mana_cost = 2
	attack = 4
	health = 2

	faction = "Silicon"
	rarity = "Rare"
	card_type = "Unit"

/datum/tcg_card/pack_1/cyborg_sec
	name = "Cyborg (Security Shell)"
	desc = "Following an incident in 2554 the Security Cyborg Shell was unilaterally phased out and replaced by the Peacekeeper. Nonetheless many units remain in service with various other organisations such as private militaries."
	rules = "Asimov. Can attack humans, but deals only 1 damage."
	icon_state = "borg_sec"

	mana_cost = 6
	attack = 4
	health = 2

	faction = "Silicon"
	rarity = "Rare"
	card_type = "Unit"

/datum/tcg_card/pack_1/cyborg_sec
	name = "Cyborg (Peacekeeper Shell)"
	desc = "After the unilateral phasing out of Security Shells in 2554 following mass reports of cyborg-on-human violence the Peacekeeper Shell was introduced as a stopgap solution until the problems could be resolved."
	rules = "Asimov. Tap this card: Restore 2 health for a friendly creature."
	icon_state = "borg_peace"

	mana_cost = 2
	attack = 4
	health = 3

	faction = "Silicon"
	rarity = "Common"
	card_type = "Unit"

/datum/tcg_card/pack_1/cyborg_med
	name = "Cyborg (Medical Shell)"
	desc = "A state of the art medical shell for when biological life just can't take care of itself. Comes equipped with built-in surgical equipment and all the medicated lollipops you could ever want."
	rules = "Asimov. Loses 1 power for every Human on opponent's field."
	icon_state = "borg_med"

	mana_cost = 2
	attack = 4
	health = 3

	faction = "Silicon"
	rarity = "Common"
	card_type = "Unit"

/datum/tcg_card/pack_1/cyborg_service
	name = "Cyborg (Service Shell)"
	desc = "Sometimes a cyborg just needs to show a bit of flamboyance you know?"
	rules = "Asimov. Gains +2/+2 when it's the only card on your field."
	icon_state = "borg_service"

	mana_cost = 1
	attack = 0
	health = 1

	faction = "Silicon"
	rarity = "Common"
	card_type = "Unit"

/datum/tcg_card/pack_1/cyborg_janitor
	name = "Cyborg (Custodial Shell)"
	desc = "A powerful state of the act cleaning machine. They exist to eradicate stains snag garbage and replace lights forever. We are legally obligated by the Janitor's Union to state that these machines are no replacement for a flesh-and-blood janitor."
	rules = "Asimov. After tapping this card, tap an opponent's Human card as well."
	icon_state = "borg_janitor"

	mana_cost = 2
	attack = 1
	health = 3

	faction = "Silicon"
	rarity = "Common"
	card_type = "Unit"

/datum/tcg_card/pack_1/cyborg_miner
	name = "Cyborg (Mining Shell)"
	desc = "Fitted with a drill and tracks the Mining Shell is designed to hold up to the rigours of mining be that on the hellish surface of Indecipheres or in the silent vacuum of the asteroid belt."
	rules = "Asimov. Gain 1 additional mana every turn."
	icon_state = "borg_miner"

	mana_cost = 2
	attack = 3
	health = 1

	faction = "Silicon"
	rarity = "Rare"
	card_type = "Unit"

//SILICONS END

//CIVILIANS

/datum/tcg_card/pack_1/assistant
	name = "Assistant"
	desc = "The lowest ladder on the Nanotrasen Employment Ladder, Assistants are employed to help out with tasks deemed 'too menial for robots'."
	rules = "Greytide."
	icon_state = "assistant"

	mana_cost = 1
	attack = 1
	health = 1

	faction = "Civilian"
	rarity = "Common"
	card_type = "Unit"

/datum/tcg_card/pack_1/greytider
	name = "Greytider"
	desc = "The lowest ladder on the Nanotrasen Employment Ladder, Assistants are employed to help out with tasks deemed 'too menial for robots'."
	rules = "Greytide. Instead of getting +1/+1 on the first turn, get it permanently."
	icon_state = "greytider"

	mana_cost = 1
	attack = 2
	health = 1

	faction = "Civilian"
	rarity = "Rare"
	card_type = "Unit"

/datum/tcg_card/pack_1/bartender
	name = "Bartender"
	desc = "Prior to the introduction of on-station psychologists the Bartender served to alleviate many employees' woes and fears. Remember always drink responsibly."
	rules = ""
	icon_state = "bartender"

	mana_cost = 3
	attack = 3
	health = 2

	faction = "Civilian"
	rarity = "Common"
	card_type = "Unit"

/datum/tcg_card/pack_1/botanist
	name = "Botanist"
	desc = "The Botanist is in charge of keeping the station's food supply happy healthy and preferably not laced with hallucinogens."
	rules = ""
	icon_state = "botanist"

	mana_cost = 1
	attack = 1
	health = 4

	faction = "Civilian"
	rarity = "Common"
	card_type = "Unit"

/datum/tcg_card/pack_1/botanist
	name = "Botanist"
	desc = "The Botanist is in charge of keeping the station's food supply happy healthy and preferably not laced with hallucinogens."
	rules = ""
	icon_state = "botanist"

	mana_cost = 1
	attack = 1
	health = 4

	faction = "Civilian"
	rarity = "Common"
	card_type = "Unit"

/datum/tcg_card/pack_1/chaplain
	name = "Chaplain"
	desc = "Every station should have it's own chaplain for religious purposes. Keyword is 'Should'."
	rules = "Holy"
	icon_state = "chaplain"

	mana_cost = 2
	attack = 2
	health = 3

	faction = "Civilian"
	rarity = "Common"
	card_type = "Unit"

/datum/tcg_card/pack_1/inquisitor
	name = "Inquisitor's Hardsuit"
	desc = "Nanotrasen officially doesn't believe in ghosts magic or anything that can't be solved with science. When you see someone show up in one of these let that remind you of that fact."
	rules = "Holy. First Strike."
	icon_state = "inquisitor"

	mana_cost = 4
	attack = 2
	health = 2

	faction = "Civilian"
	rarity = "Epic"
	card_type = "Equipment"

/datum/tcg_card/pack_1/janitor
	name = "Janitor"
	desc = "A true testament to futility they clean and they clean and they clean knowing that there's no way they can clean it all. Yet they perservere knowing that without them the crew would simply give in to their base animalistic nature."
	rules = "Taunt"
	icon_state = "janitor"

	mana_cost = 1
	attack = 1
	health = 1

	faction = "Civilian"
	rarity = "Common"
	card_type = "Unit"

/datum/tcg_card/pack_1/lawyer
	name = "Lawyer"
	desc = "Nanotrasen knows the value of a good lawyer. That's why they're all working hard at our home offices defending us from frivolous labor suits from lazy no-good employees who should be working hard instead of slacking off reading trading cards."
	rules = "When an opponent attacks with a creature with 3 or more power this card gains Taunt."
	icon_state = "lawyer"

	mana_cost = 2
	attack = 0
	health = 4

	faction = "Civilian"
	rarity = "Common"
	card_type = "Unit"

/datum/tcg_card/pack_1/clown
	name = "Clown"
	desc = "Every Nanotrasen station has a clown on board as high command believes that a source of entertainment will reduce instances of murder-suicide on board Spinward Stations. The results of this hypothesis are as of yet unproven."
	rules = "Taunt. When killed, attacking creature dies as well"
	icon_state = "clown"

	mana_cost = 3
	attack = 2
	health = 4

	faction = "Civilian"
	rarity = "Rare"
	card_type = "Unit"

/datum/tcg_card/pack_1/clown_hardsuit
	name = "HONK Ltd. Entertainment Voidsuit"
	desc = "The most advanced clown suit produced by HONK Ltd. the Entertainment Voidsuit is designed to withstand extreme conditions while still maintaining the aesthetic expected of clowns."
	rules = "Give the equipped unit Taunt."
	icon_state = "clown_hardsuit"

	mana_cost = 2
	attack = 1
	health = 5

	faction = "Civilian"
	rarity = "Legendary"
	card_type = "Equipment"

/datum/tcg_card/pack_1/mime
	name = "Mime"
	desc = "Si vous regardez attentivement dans les yeux d'un mime vous pouvez voir le tourment sans fin derrière leur façade silencieuse. C'est vraiment tragique."
	rules = "Tap this card: Pick an opponent's card and nullify it's effect until it leaves play."
	icon_state = "mime"

	mana_cost = 1
	attack = 2
	health = 1

	faction = "Civilian"
	rarity = "Rare"
	card_type = "Unit"

/datum/tcg_card/pack_1/cook
	name = "Cook"
	desc = "Every Nanotrasen chef is trained in 3 cuisines of their choosing upon being hired alongside the closely guarded secret of Close Quarters Cooking."
	rules = "First Strike. When attacked, gain +1/0."
	icon_state = "cook"

	mana_cost = 3
	attack = 3
	health = 2

	faction = "Civilian"
	rarity = "Common"
	card_type = "Unit"

/datum/tcg_card/pack_1/curator
	name = "Curator"
	desc = "In Nanotrasen polls the Curator has ranked as the most pointless job on station much to the ire of the Curator's union. Thankfully we don't have to listen to them."
	rules = "On Summon: Draw a card. If it's a spell, discard it."
	icon_state = "curator"

	mana_cost = 2
	attack = 1
	health = 1

	faction = "Civilian"
	rarity = "Common"
	card_type = "Unit"

/datum/tcg_card/pack_1/ian
	name = "Ian"
	desc = "This adorable corgi has become the defacto mascot of the Spinward Stations to many. He comes in many forms many sizes and many shapes but he's still just as lovable. Hand wash only."
	rules = "Holy. Taunt."
	icon_state = "ian"

	mana_cost = 3
	attack = 0
	health = 2

	faction = "Civilian"
	rarity = "Rare"
	card_type = "Unit"

//CIVILIAN END

//SECURITY

/datum/tcg_card/pack_1/sec_officer
	name = "Security Officer"
	desc = "Nanotrasen would like to remind all employees to support their station security team; remember the boys in red keep you safe!"
	rules = "Squad Tactics."
	icon_state = "officer"

	mana_cost = 3
	attack = 2
	health = 2

	faction = "Security"
	rarity = "Common"
	card_type = "Unit"

/datum/tcg_card/pack_1/warden
	name = "Warden"
	desc = "The Warden is tasked with the herculean (and futile) feat of defending the armory and brig and never leaving his post no matter the situation."
	rules = "Squad Tactics. Blocker."
	icon_state = "warden"

	mana_cost = 4
	attack = 2
	health = 4

	faction = "Security"
	rarity = "Rare"
	card_type = "Unit"

/datum/tcg_card/pack_1/detective
	name = "Security Officer"
	desc = "Nanotrasen hires nothing but the best detectives to investigate crime on our stations. A penchant for cigarettes and outdated fashion isn't mandatory but is appreciated."
	rules = "Deadeye."
	icon_state = "detective"

	mana_cost = 5
	attack = 3
	health = 2

	faction = "Security"
	rarity = "Common"
	card_type = "Unit"

/datum/tcg_card/pack_1/officer_ethereal
	name = "Security Officer(Ethereal)"
	desc = "A trained officer with BlueShift equipment. Wait, is he a red boy or a blue boy?"
	rules = "Squad Tactics. On summon: This character can't be attacked for the first turn."
	icon_state = "officer_ethereal"

	mana_cost = 6
	attack = 4
	health = 4

	faction = "Security"
	rarity = "Rare"
	card_type = "Unit"

//SECURITY END

//RESEARCH AND DEVELOPMENT

/datum/tcg_card/pack_1/scientist
	name = "Scientist"
	desc = "Rumours that Nanotrasen hires 'mad scientists' are greatly exaggerated. Scientists are regularly screened to ensure that their insanity remains within acceptable limits."
	rules = "When this card is targeted by an opponent's single target spell you gain 1 lifeshard."
	icon_state = "scientist"

	mana_cost = 4
	attack = 1
	health = 2

	faction = "Research"
	rarity = "Common"
	card_type = "Unit"

/datum/tcg_card/pack_1/scientist_moth
	name = "Scientist(Moth)"
	desc = "Moths are a common sight in Nanotrasen research departments acting as integral ideas guys for new clothing designs and lighting innovations."
	rules = ""
	icon_state = "scientist_moth"

	mana_cost = 1
	attack = 2
	health = 2

	faction = "Research"
	rarity = "Common"
	card_type = "Unit"

/datum/tcg_card/pack_1/roboticist
	name = "Roboticist"
	desc = "The roboticist's work is as close as Nanotrasen legally allows its employees to come to necromancy."
	rules = "If a Asimov card on your side of the field is destroyed you may pay 2 mana and tap this card: Return that card to your hand."
	icon_state = "roboticist"

	mana_cost = 3
	attack = 2
	health = 2

	faction = "Research"
	rarity = "Rare"
	card_type = "Unit"

/datum/tcg_card/pack_1/monkey
	name = "Monkey"
	desc = "Nanotrasen seeks to phase out animal testing by 2570 in accordance with new TerraGov legislation. This will be replaced with more ethical solutions such as computer simulations or experimentation on Assistants."
	rules = "Greytide. This card is considered Human with a Geneticist on your side of the field."
	icon_state = "monkey"

	mana_cost = 1
	attack = 1
	health = 1

	faction = "Research"
	rarity = "Common"
	card_type = "Unit"

/datum/tcg_card/pack_1/geneticist
	name = "Geneticist"
	desc = "Geneticists are tasked with manipulating human DNA to produce special effects. Nanotrasen maintains a strict 'no superhero' policy for mutations following the Superhero Civil War of 2150."
	rules = "Tap this card and pay 3 mana: Give a friendly creature Human until this card leaves the field."
	icon_state = "geneticist"

	mana_cost = 3
	attack = 3
	health = 4

	faction = "Research"
	rarity = "Common"
	card_type = "Unit"

/datum/tcg_card/pack_1/borgi
	name = "Borgi Ian"
	desc = "While Ian's cyborg costume is very convincing we at the NTED would like to remind all employees that Ian has not been experimented on."
	rules = "Asimov. You may sacrifice this card in play: Summon a Silicon type card from your hand worth up to double this card's cost."
	icon_state = "ian_robot"

	mana_cost = 2
	attack = 0
	health = 3

	faction = "Research"
	rarity = "Rare"
	card_type = "Unit"

//SCIENCE END

//MEDICAL

/datum/tcg_card/pack_1/doctor
	name = "Medical Doctor"
	desc = "Nanotrasen's doctors are well known for their ability to treat almost any ailment known to mankind... as well as causing a fair few in the process."
	rules = "Tap this card: Select a card that has less attack than this card from your graveyard and summon it to your side of the field."
	icon_state = "doctor"

	mana_cost = 3
	attack = 2
	health = 3

	faction = "Medical"
	rarity = "Common"
	card_type = "Unit"

/datum/tcg_card/pack_1/runtime
	name = "Runtime"
	desc = "Runtime is the CMO's personal feline companion and is well known for her laziness. It's said that opening a tin of tuna anywhere on the station will bring her running."
	rules = "You may sacrifice this card: reduce the cost of summoning a Medical card this turn by 2 mana."
	icon_state = "runtime"

	mana_cost = 3
	attack = 0
	health = 1

	faction = "Medical"
	rarity = "Rare"
	card_type = "Unit"

/datum/tcg_card/pack_1/chemist
	name = "Chemist"
	desc = "Chemists are encouraged to not set up illicit methamphetamine factories on the company's dime."
	rules = "Tap this card: flip a coin. If heads: a friendly Medical card gains 0/+2. If tails an opponents unit of your choice gains +2/0."
	icon_state = "chemist"

	mana_cost = 2
	attack = 0
	health = 3

	faction = "Medical"
	rarity = "Rare"
	card_type = "Unit"

/datum/tcg_card/pack_1/virologist
	name = "Virologist"
	desc = "Officially the virologist is present on station to deal with novel diseases and ailments that originate from deep space. As everyone knows this is not what the virologist actually does."
	rules = ""
	icon_state = "virologist"

	mana_cost = 3
	attack = 5
	health = 1

	faction = "Medical"
	rarity = "Common"
	card_type = "Unit"

/datum/tcg_card/pack_1/paramedic
	name = "Paramedic"
	desc = "Nanotrasen encourages all paramedics to think of others before themselves- if this means running through a plasma fire to save a colleague so be it."
	rules = "Taunt, First Strike"
	icon_state = "paramedic"

	mana_cost = 3
	attack = 2
	health = 3

	faction = "Medical"
	rarity = "Common"
	card_type = "Unit"

//MEDICAL END

//ENGINEERING

/datum/tcg_card/pack_1/engineer
	name = "Station Engineer"
	desc = "Station Engineers maintain the intricate and delicate web of machinery that keeps you and everyone else aboard your station alive. No pressure there then."
	rules = "Tap this card: Reduce the first hit taken by an ally to zero."
	icon_state = "engineer"

	mana_cost = 4
	attack = 2
	health = 2

	faction = "Engineering"
	rarity = "Common"
	card_type = "Unit"

/datum/tcg_card/pack_1/engi_hardsuit
	name = "Nakamura Engineering's R.I.G.Suit"
	desc = "Nakamura Engineering's R.I.G. is a hardsuit, specifically designed for engineers working in hostile enviroments. It features good armor and is rad-proof."
	rules = ""
	icon_state = "engineer_hardsuit"

	mana_cost = 2
	attack = 0
	health = 3

	faction = "Engineering"
	rarity = "Common"
	card_type = "Equipment"

/datum/tcg_card/pack_1/engineer_plasmaman
	name = "Station Engineer (Plasmaman)"
	desc = "The ever industrious plasmamen are well suited to engineering work due to their natural radiation resistance."
	rules = "Immune to all spells except Security and Syndicate ones."
	icon_state = "engineer_plasmeme"

	mana_cost = 5
	attack = 2
	health = 4

	faction = "Engineering"
	rarity = "Rare"
	card_type = "Unit"

/datum/tcg_card/pack_1/atmos_tech
	name = "Atmospheric Technician"
	desc = "The Atmospheric Technicians are tasked with keeping the station's air clean breathable and most importantly devoid of plasma."
	rules = "On Summon: Search your deck for an Engineering Spell card and add it to your hand. Shuffle your deck afterward."
	icon_state = "atmos_tech"

	mana_cost = 4
	attack = 2
	health = 3

	faction = "Engineering"
	rarity = "Common"
	card_type = "Unit"

/datum/tcg_card/pack_1/atmos_hardsuit
	name = "Nakamura Atmospherics's R.I.G.Suit"
	desc = "Nakamura Atmospherics's R.I.G. is just an old modified Engineering R.I.G.Suit that lacks rad-protection. Some technicans painted it blue and now it's 'fireproof'."
	rules = "Equipped creature gains immunity to engineering spells."
	icon_state = "atmos_tech_hardsuit"

	mana_cost = 2
	attack = 0
	health = 2

	faction = "Engineering"
	rarity = "Rare"
	card_type = "Equipment"

//ENGINEERING END

//CARGO

/datum/tcg_card/pack_1/cargo_tech
	name = "Cargo Technician"
	desc = "The grunts of Cargo. Any reports that Cargo Technicians are frequently overcome by revolutionary fervour are exaggerated."
	rules = "Once per turn: Give this card -1/0 and gain 1 mana."
	icon_state = "cargo_tech"

	mana_cost = 2
	attack = 3
	health = 1

	faction = "Cargo"
	rarity = "Common"
	card_type = "Unit"

/datum/tcg_card/pack_1/shaft_miner
	name = "Shaft Miner"
	desc = "When the station needs materials these are the guys who risk their lives bravely pioneering the wastes of Indecipheres to bring them in."
	rules = "Tap this card: Draw one card. If it's not a spell, discard it."
	icon_state = "miner"

	mana_cost = 6
	attack = 6
	health = 4

	faction = "Cargo"
	rarity = "Rare"
	card_type = "Unit"

/datum/tcg_card/pack_1/citrus
	name = "Citrus"
	desc = "Cargo's happy sloth pal. Known for his cute sweater and always getting in the way."
	rules = "Taunt. Tap this card: Tap an opponent's card until the start of your next turn."
	icon_state = "citrus"

	mana_cost = 2
	attack = 0
	health = 3

	faction = "Cargo"
	rarity = "Common"
	card_type = "Unit"

/datum/tcg_card/pack_1/quartermaster
	name = "Quartermaster"
	desc = "Every Nanotrasen station has a Quartermaster who controls the flow of cargo to and from the station and by extension to and from the hands of the crew. He's not given the distinction of being a head though. His job isn't hard enough."
	rules = "Permanently tap this card. All cargo cards on your side gain +2/+2 until this card leaves the play."
	icon_state = "quartermaster"

	mana_cost = 10
	attack = 4
	health = 4

	faction = "Cargo"
	rarity = "Rare"
	card_type = "Unit"

/datum/tcg_card/pack_1/explorer
	name = "Explorer"
	desc = "The Nanotrasen Explorers Corps boldly goes where humanity has never gone before. Or would if they weren't buried under mounds of bureaucracy."
	rules = "Tap this card: Flip a coin if heads gain 4 mana this turn, if tails tap this card for 2 turns."
	icon_state = "explorer"

	mana_cost = 2
	attack = 3
	health = 3

	faction = "Cargo"
	rarity = "Legendary"
	card_type = "Unit"

//CARGO END

//CENTCOM

/datum/tcg_card/pack_1/intern
	name = "Intern"
	desc = "All Nanotrasen interns come with 3 things: A resume a desire to learn and vague promises that they're getting paid at some point. So don't be too rough on them."
	rules = "First Strike. Greytide."
	icon_state = "intern"

	mana_cost = 1
	attack = 1
	health = 1

	faction = "Centcom"
	rarity = "Common"
	card_type = "Unit"

/datum/tcg_card/pack_1/ert_command
	name = "NT P.A.V. Suit (Command)"
	desc = "Issued to members of Emergency Response Teams the P.A.V. Suit gives superior protection from any threat the galaxy can throw at it. This particular model is outfitted with a sidearm holster and a sleek blue finish."
	rules = "While equipped give the equipped unit Squad Tactics and First Strike."
	icon_state = "ert_command"

	mana_cost = 2
	attack = 2
	health = 2

	faction = "Centcom"
	rarity = "Epic"
	card_type = "Equipment"

/datum/tcg_card/pack_1/ert_sec
	name = "NT P.A.V. Suit (Security)"
	desc = "Issued to members of Emergency Response Teams the P.A.V. Suit gives superior protection from any threat the galaxy can throw at it. This particular model is outfitted with bulletproof padding and an intimidating red finish."
	rules = "While equipped give the equipped unit Squad Tactics."
	icon_state = "ert_sec"

	mana_cost = 2
	attack = 2
	health = 1

	faction = "Centcom"
	rarity = "Rare"
	card_type = "Equipment"

/datum/tcg_card/pack_1/ert_med
	name = "NT P.A.V. Suit (Medical)"
	desc = "Issued to members of Emergency Response Teams the P.A.V. Suit gives superior protection from any threat the galaxy can throw at it. This particular model is outfitted with a sterile coating and a calming white finish."
	rules = "While equipped give the equipped unit Squad Tactics."
	icon_state = "ert_med"

	mana_cost = 2
	attack = 1
	health = 2

	faction = "Centcom"
	rarity = "Common"
	card_type = "Equipment"

/datum/tcg_card/pack_1/ert_engi
	name = "NT P.A.V. Suit (Engineering)"
	desc = "Issued to members of Emergency Response Teams the P.A.V. Suit gives superior protection from any threat the galaxy can throw at it. This particular model is outfitted with a welding screen and a flashy yellow finish."
	rules = "While equipped give the equipped unit Squad Tactics."
	icon_state = "ert_engi"

	mana_cost = 1
	attack = 1
	health = 2

	faction = "Centcom"
	rarity = "Common"
	card_type = "Equipment"

/datum/tcg_card/pack_1/deathsquad
	name = "Deathsquad Officer"
	desc = "There were rumors about 'Deathsquads' killing station where something horrible happened, but we remind you that's it's just a lie."
	rules = "Taunt. First Strike."
	icon_state = "deathsquad"

	mana_cost = 8
	attack = 8
	health = 6

	faction = "Centcom"
	rarity = "Epic"
	card_type = "Unit"

//CENTCOM END

//ANTAGONISTS

/datum/tcg_card/pack_1/changeling
	name = "Armored Changeling"
	desc = "The strange creatures known as changelings have been known to develop natural armour as a defense mechanism when in combat."
	rules = "Changeling."
	icon_state = "changeling"

	mana_cost = 6
	attack = 2
	health = 8

	faction = "Syndicate"
	rarity = "Rare"
	card_type = "Unit"

/datum/tcg_card/pack_1/chrono_legionare
	name = "Chrono Legionare"
	desc = "Currently in the earliest stages of development the Chrono Legionnaire project is expected to weaponise time itself."
	rules = "If this card is destroyed or discarded flip 3 coins. If the result has 2 or more heads add this card back to your hand. Otherwise send it to your graveyard."
	icon_state = "chrono_legionare"

	mana_cost = 4
	attack = 6
	health = 2

	faction = "Syndicate"
	rarity = "Epic"
	card_type = "Unit"

/datum/tcg_card/pack_1/abductor_armor
	name = "Combat Abductor Armor"
	desc = "Recovered from the strange alien species known as the Abductors this armour is made from an extremely tough yet flexible material that has been dubbed as Alien Alloy by researchers."
	rules = "Give equipped unit immunity to spells for 3 turns. Unequipped after 3 turns."
	icon_state = "abductor"

	mana_cost = 6
	attack = 1
	health = 2

	faction = "Syndicate"
	rarity = "Common"
	card_type = "Equipment"

/datum/tcg_card/pack_1/wizard
	name = "Wizard"
	desc = "A strange men(or golem) wearing blue robes. For some reason, he looks like a total nerd."
	rules = "Flip a coin every turn. If tails, deal 2 damage to any enemy unit except Holy ones. If heads, deal 2 damage to self."
	icon_state = "wizard"

	mana_cost = 8
	attack = 6
	health = 4

	faction = "Syndicate"
	rarity = "Rare"
	card_type = "Unit"

/datum/tcg_card/pack_1/abductor_armor
	name = "Wizard Federation Standard Issue Hardsuit"
	desc = "Seemingly reverse engineered from captured engineering hardsuits the iconic Wizard Federation Hardsuit is a spectacular melding of technology and magic."
	rules = "On Equip: The equipped creature cannot attack targets with Holy."
	icon_state = "wizard_hardsuit"

	mana_cost = 1
	attack = 3
	health = 1

	faction = "Syndicate"
	rarity = "Rare"
	card_type = "Equipment"

/datum/tcg_card/pack_1/swarmer
	name = "Swarmer"
	desc = "Leading researchers theorise that Swarmers were designed as some kind of vanguard for an alien invasion force which seemingly has never materialised."
	rules = "Greytide."
	icon_state = "swarmer"

	mana_cost = 1
	attack = 1
	health = 1

	faction = "Syndicate"
	rarity = "Common"
	card_type = "Unit"

/datum/tcg_card/pack_1/swarmer_beacon
	name = "Swarmer Beacon"
	desc = "A strange device that can construct swarmers."
	rules = "Every turn: Draw a card. If it's a Swarmer, play it for free. Else, discard it."
	icon_state = "swarmer_beacon"

	mana_cost = 4
	attack = 0
	health = 1

	faction = "Syndicate"
	rarity = "Epic"
	card_type = "Unit"

/datum/tcg_card/pack_1/nukie
	name = "Nuclear Operative"
	desc = "The frontline grunts of the syndicate army Nuclear Operatives are typically well trained and equipped for their grim duty."
	rules = "Squad Tactics."
	icon_state = "nukie"

	mana_cost = 4
	attack = 4
	health = 2

	faction = "Syndicate"
	rarity = "Rare"
	card_type = "Unit"

/datum/tcg_card/pack_1/nukie_elite
	name = "Elite Syndicate Nuclear Stormtrooper"
	desc = "The best of the best of the syndicate troops elite stormtroopers can be distinguished by their black armour. Shoot on sight ask questions later!"
	rules = "Squad Tactics. Fury."
	icon_state = "nukie_elite"

	mana_cost = 7
	attack = 5
	health = 5

	faction = "Syndicate"
	rarity = "Epic"
	card_type = "Unit"

/datum/tcg_card/pack_1/clockwork_cultist
	name = "Ratvarian Clockwork Cuirass"
	desc = "Fashioned from paranormally reinforced brass the Ratvar Cult's clockwork armour is as beautiful as it is heretical."
	rules = "While equipped give the equipped unit Clockwork."
	icon_state = "clockwork_cultist"

	mana_cost = 4
	attack = 2
	health = 2

	faction = "Syndicate"
	rarity = "Rare"
	card_type = "Equipment"

/datum/tcg_card/pack_1/revenant
	name = "Revenant"
	desc = "The revenant is a spirit of pure hatred kept alive by drawing the life force of its enemies."
	rules = "When a unit on dies Revenant gains 1/0."
	icon_state = "revenant"

	mana_cost = 3
	attack = 2
	health = 3

	faction = "Syndicate"
	rarity = "Common"
	card_type = "Unit"

/datum/tcg_card/pack_1/angry_slime
	name = "Crazy Slime"
	desc = "An agressive slime who seeks blood. You totally should extinguish him."
	rules = "When attacking, search your deck for Crazy Slime and add it to your hand. Shuffle your deck afterwards."
	icon_state = "angry_slime"

	mana_cost = 2
	attack = 1
	health = 1

	faction = "Syndicate"
	rarity = "Common"
	card_type = "Unit"

//ANTAGONISTS END

//SPELLS

/datum/tcg_card/pack_1/adrenals
	name = "Adrenals"
	desc = "A potent mixture of stimulants designed to enhance a soldier's ability in the field. Technically illegal in Terragov territory but since when has that stopped anyone?"
	rules = "Grant +2/+1 to a friendly unit."
	icon_state = "adrenals"

	mana_cost = 1

	faction = "Medical"
	rarity = "Common"
	card_type = "Spell"

/datum/tcg_card/pack_1/defib
	name = "Defibrillator"
	desc = "A device that allows to re-start hearts using electricity. It also can be used as a weapon!"
	rules = "Resurrect a friendly unit with 1 HP."
	icon_state = "defib"

	mana_cost = 4

	faction = "Medical"
	rarity = "Rare"
	card_type = "Spell"

/datum/tcg_card/pack_1/morphine
	name = "Morphine"
	desc = "A sedative chemical that puts everyone who uses it into sleep."
	rules = "Tap an enemy card without activating it's effect for 1 turn."
	icon_state = "morphine"

	mana_cost = 2

	faction = "Medical"
	rarity = "Common"
	card_type = "Spell"

/datum/tcg_card/pack_1/bluespace
	name = "Bluespace Flux"
	desc = "Despite being a revolutionary new technology bluespace still has some... kinks that need sorted out."
	rules = "Active for 3 turns. Every player can pay 2 mana to draw an additional card from their deck."
	icon_state = "bluespace"

	mana_cost = 5

	faction = "Research"
	rarity = "Common"
	card_type = "Spell"

/datum/tcg_card/pack_1/bag_of_holding
	name = "Bag Of Greed"
	desc = "BAG OF GREED ALLOWS ME TO DRAW TWO MORE CARDS. I WILL START MY TURN BY PLAYING BAG OF GREED WHICH ALLOWS ME TO DRAW TWO MORE CARDS. I WILL PLAY THE EVENT CARD BAG OF GREED WHICH ALLOWS ME TO DRAW TWO NEW CARDS."
	rules = "Draw 2 cards from your deck."
	icon_state = "bag_of_holding"

	mana_cost = 3

	faction = "Research"
	rarity = "Common"
	card_type = "Spell"

/datum/tcg_card/pack_1/malfunction
	name = "Glitch in the System"
	desc = "Even a meticulously maintained AI system will eventually develop errors. Many are benign but some may cause unforeseen problems..."
	rules = "Remove Asimov from one of your cards."
	icon_state = "malfunction"

	mana_cost = 1

	faction = "Research"
	rarity = "Common"
	card_type = "Spell"

/datum/tcg_card/pack_1/botanist_plant
	name = "Comitted Botanist"
	desc = "When you've grown the plants nurtured the plants and harvested the plants there's only one place to go from there... becoming the plant."
	rules = "Only usable when Botanist is on the field. This turn all service cards cost 2 mana less(but not below 1)."
	icon_state = "botanist_plant"

	mana_cost = 4

	faction = "Service"
	rarity = "Rare"
	card_type = "Spell"

/datum/tcg_card/pack_1/gaia
	name = "Ambrosia Gaia"
	desc = "If Ambrosia is the gold of Botany the rare Gaia variety is the platinum. Almost nobody has seen this illusive plant with their own eyes."
	rules = "During the draw phase you may sacrifice Ambrosia Gaia to gain 3 mana."
	icon_state = "gaia"

	mana_cost = 0

	faction = "Service"
	rarity = "Legendary"
	card_type = "Spell"

/datum/tcg_card/pack_1/deep_fryer
	name = "Deep Fryer"
	desc = "God bless the United States of Space America."
	rules = "Destroy an opponent's equipment card."
	icon_state = "deep_fryer"

	mana_cost = 2

	faction = "Service"
	rarity = "Common"
	card_type = "Spell"

/datum/tcg_card/pack_1/bepis
	name = "B.E.P.I.S."
	desc = "God bless the United States of Space America."
	rules = "Flip a coin. If heads, gain 2 mana. If tails, lose 2 mana."
	icon_state = "bepis"

	mana_cost = 0

	faction = "Cargo"
	rarity = "Common"
	card_type = "Spell"

/datum/tcg_card/pack_1/economy_crash
	name = "Economy Crash"
	desc = "So cargo sold 20 canisters of miasma and now the galactic economy is experiencing what's known as 'a catastrophic collapse'."
	rules = "All cards cost 1 more mana to play."
	icon_state = "economy_crash"

	mana_cost = 2

	faction = "Cargo"
	rarity = "Common"
	card_type = "Spell"

/datum/tcg_card/pack_1/additional_supplies
	name = "Additional Supplies"
	desc = "Well, cargonia ordered 10 crates of buckshots and slugs. Looks like we need to dispose of them quickly."
	rules = "For 3 turns, you draw an additional page every turn."
	icon_state = "additional_supplies"

	mana_cost = 3

	faction = "Cargo"
	rarity = "Rare"
	card_type = "Spell"

/datum/tcg_card/pack_1/bsa_barrage
	name = "BSA Barrage"
	desc = "The officers at Centcom are well known for their ability to hit targets extremely accurately with their bluespace artillery especially when stupid pictures show up at their fax machine."
	rules = "Destroy an opponent's unit. Deal 2 damage to all units on the field."
	icon_state = "bsa_barrage"

	mana_cost = 4

	faction = "Security"
	rarity = "Rare"
	card_type = "Spell"

/datum/tcg_card/pack_1/reeducation
	name = "Re-education"
	desc = "Nobody ever seems to return from re-education. Probably best not to question it."
	rules = "Deal 4 damage to an enemy's unit."
	icon_state = "re-education"

	mana_cost = 2

	faction = "Security"
	rarity = "Common"
	card_type = "Spell"

/datum/tcg_card/pack_1/just_losses
	name = "Justifiable Casualties"
	desc = "The beat is hell. Officers die. The strongest they live."
	rules = "Sacrifice two friendly creatures from the battlefield then summon a creature from your hand at no mana cost."
	icon_state = "just_losses"

	mana_cost = 2

	faction = "Security"
	rarity = "Common"
	card_type = "Spell"

/datum/tcg_card/pack_1/sleeping_carp
	name = "Sleeping Carp"
	desc = "Created by the long-extinct Carp Monks of Space Tibet the Sleeping Carp style has been kept alive by dedicated practitioners and even found its way into the Syndicate's training regime."
	rules = "Give a friendly unit +3/+1. Draw an additional card every turn while they are alive."
	icon_state = "sleeping_carp"

	mana_cost = 6

	faction = "Syndicate"
	rarity = "Epic"
	card_type = "Spell"

/datum/tcg_card/pack_1/tough_choices
	name = "Tough Choices"
	desc = "Every Nanotrasen employee will at some point be forced to make a tough choice. Make sure you make the right one!"
	rules = "Draw the top three cards from your deck. Summon one at no cost and discard the other two."
	icon_state = "tough_choices"

	mana_cost = 2

	faction = "Syndicate"
	rarity = "Common"
	card_type = "Spell"

/datum/tcg_card/pack_1/nuclear_explosion
	name = "Nuclear Explosion"
	desc = "The Gorlex Marauders are well known for their nuclear weapons and their nuke first second third and fourth policy with regards to deploying them."
	rules = "Kill all units on the battlefield."
	icon_state = "nuclear_explosion"

	mana_cost = 5

	faction = "Syndicate"
	rarity = "Rare"
	card_type = "Spell"

/datum/tcg_card/pack_1/inducer
	name = "Inducer"
	desc = "The inducer is a marvelous piece of tech allowing the recharging of an internal cell without opening a machine."
	rules = "Pay 3 lifeshards: Gain 3 mana this turn."
	icon_state = "inducer"

	mana_cost = 0

	faction = "Engineering"
	rarity = "Rare"
	card_type = "Spell"

/datum/tcg_card/pack_1/plasmafire
	name = "Atmospherics Incident"
	desc = "Accidents happen."
	rules = "For 3 turns, add -1/-1 to every unit."
	icon_state = "plasmafire"

	mana_cost = 3

	faction = "Engineering"
	rarity = "Rare"
	card_type = "Spell"

/datum/tcg_card/pack_1/supermatter
	name = "Supermatter"
	desc = "A glowing crystal, made of hyper-pressurised plasma, widely known for it's radiation production."
	rules = "Destroy an enemy's unit."
	icon_state = "supermatter"

	mana_cost = 4

	faction = "Engineering"
	rarity = "Rare"
	card_type = "Spell"
