/datum/borer_chem
	var/chemname
	var/chem_desc = "This is a chemical"
	var/chem_message //Text sent to the host when injecting chemicals
	var/chemuse = 30
	var/quantity = 10

/datum/borer_chem/epinephrine
	chemname = "epinephrine"
	chem_desc = "Stabilizes critical condition and slowly restores oxygen damage. If overdosed, it will deal toxin and oxyloss damage."
	chem_message = "<span class='notice'>You feel your energy being replenished and it becomes easier to breathe!</span>"

/datum/borer_chem/leporazine
	chemname = "leporazine"
	chem_desc = "This keeps a patient's body temperature stable. High doses can allow short periods of unprotected EVA."
	chemuse = 75
	chem_message = "<span class='notice'>You no longer feel heat or cold, as leporazine floods your system.</span>"

/datum/borer_chem/mannitol
	chemname = "mannitol"
	chem_desc = "Heals brain damage."
	chem_message = "<span class='notice'>You feel your mind focus more easily, as your system is flooded with mannitol.</span>"

/datum/borer_chem/bicaridine
	chemname = "bicaridine"
	chem_desc = "Heals brute damage."
	chem_message = "<span class='notice'>A wave of flesh-knitting bicaridine flows through your bloodstream.</span>"

/datum/borer_chem/kelotane
	chemname = "kelotane"
	chem_desc = "Heals burn damage."
	chem_message = "<span class='notice'>A stream of burn-healing kelotane spreads throughout your body.</span>"

/datum/borer_chem/charcoal
	chemname = "charcoal"
	chem_desc = "Slowly heals toxin damage, will also slowly remove any other chemicals."
	chem_message = "<span class='notice'>A measure of toxin-purging charcoal cleanses your bloodstream.</span>"

/datum/borer_chem/methamphetamine
	chemname = "methamphetamine"
	chem_desc = "Reduces stun times, increases stamina and run speed while dealing brain damage. If overdosed it will deal toxin and brain damage."
	chemuse = 50
	quantity = 9
	chem_message = "<span class='notice'>Your mind races, your heartrate skyrockets as methamphetamines enters your bloodstream!</span>"

/datum/borer_chem/salbutamol
	chemname = "salbutamol"
	chem_desc = "Heals suffocation damage."
	chem_message = "<span class='notice'>Your breathing becomes lighter, as oxygen fills your lungs from the inside.</span>"

/datum/borer_chem/spacedrugs
	chemname = "space_drugs"
	chem_desc = "Get your host high as a kite."
	chemuse = 75
	chem_message = "<span class='notice'>You feel like you can taste the colours of the wind.</span>"

/*/datum/borer_chem/creagent
	chemname = "colorful_reagent"
	chem_desc = "Change the colour of your host."
	chemuse = 50
	chem_message = "<span class='notice'>Your body suddenly changes colour from the inside out.</span>"*/

/datum/borer_chem/ethanol
	chemname = "ethanol"
	chem_desc = "The most potent alcoholic 'beverage', with the fastest toxicity."
	chemuse = 50
	chem_message = "<span class='notice'>You feel like you've downed a shot of 200 proof vodka.</span>"

/datum/borer_chem/rezadone
	chemname = "rezadone"
	chem_desc = "Heals cellular damage."
	chem_message = "<span class='notice'>You feel a warmth spread throughout your body as rezadone repairs corrupted DNA.</span>"

/datum/borer_chem/crocin
	chemname = "aphro"
	chem_desc = "Increases host arousal without overdosing."
	chem_message = "<span class='notice'>You feel your pulse quicken and your body begins to feel warmer.</span>"

/datum/borer_chem/camphor
	chemname = "anaphro"
	chem_desc = "Decreases host arousal without overdosing."
	chem_message = "<span class='notice'>Your pulse calms down and you feel more focused as the fog of lust clears.</span>"
