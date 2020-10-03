// Gang datums go here. If you want to create a new gang, you must be sure to edit:
// name
// color (must be a hex, "blue" isn't acceptable due to how spraycans are handled)
// inner_outfits (must be a list() with typepaths of the clothes in it. One is fine, but there is support for multiple: one will be picked at random when bought)
// outer_outfits (same as above)
// You also need to make a gang graffiti, that will go in crayondecal.dmi inside our icons, with the same name of the gang it's assigned to. Nothing else,just the icon.
// Those are all required. If one is missed, stuff could break.

/datum/team/gang/clandestine
	name = "Clandestine"
	color = "#FF0000"
	inner_outfits = list(/obj/item/clothing/under/syndicate/combat)
	outer_outfits = list(/obj/item/clothing/suit/jacket)

/datum/team/gang/prima
	name = "Prima"
	color = "#FFFF00"
	inner_outfits = list(/obj/item/clothing/under/color/yellow)
	outer_outfits = list(/obj/item/clothing/suit/hastur)

/datum/team/gang/zerog
	name = "Zero-G"
	color = "#C0C0C0"
	inner_outfits = list(/obj/item/clothing/under/suit/white)
	outer_outfits = list(/obj/item/clothing/suit/hooded/wintercoat)

/datum/team/gang/max
	name = "Max"
	color = "#800000"
	inner_outfits = list(/obj/item/clothing/under/color/maroon)
	outer_outfits = list(/obj/item/clothing/suit/poncho/red)

/datum/team/gang/blasto
	name = "Blasto"
	color = "#000080"
	inner_outfits = list(/obj/item/clothing/under/suit/navy)
	outer_outfits = list(/obj/item/clothing/suit/jacket/miljacket)

/datum/team/gang/waffle
	name = "Waffle"
	color = "#808000" //shared color with cyber, but they can keep brown cause waffles.
	inner_outfits = list(/obj/item/clothing/under/suit/green)
	outer_outfits = list(/obj/item/clothing/suit/poncho)

/datum/team/gang/north
	name = "North"
	color = "#00FF00"
	inner_outfits = list(/obj/item/clothing/under/color/green)
	outer_outfits = list(/obj/item/clothing/suit/poncho/green)

/datum/team/gang/omni
	name = "Omni"
	color = "#008080"
	inner_outfits = list(/obj/item/clothing/under/color/teal)
	outer_outfits = list(/obj/item/clothing/suit/chaplain/studentuni)

/datum/team/gang/newton
	name = "Newton"
	color = "#A52A2A"
	inner_outfits = list(/obj/item/clothing/under/color/brown)
	outer_outfits = list(/obj/item/clothing/suit/toggle/owlwings)

/datum/team/gang/cyber
	name = "Cyber"
	color = "#00f904" //Cyber and waffle shared colors, I made these guys green and made weed darker green.
	inner_outfits = list(/obj/item/clothing/under/color/lightbrown)
	outer_outfits = list(/obj/item/clothing/suit/chaplain/pharaoh)

/datum/team/gang/donk
	name = "Donk"
	color = "#0000FF"
	inner_outfits = list(/obj/item/clothing/under/color/darkblue)
	outer_outfits = list(/obj/item/clothing/suit/apron/overalls)

/datum/team/gang/gene
	name = "Gene"
	color = "#00FFFF"
	inner_outfits = list(/obj/item/clothing/under/color/blue)
	outer_outfits = list(/obj/item/clothing/suit/apron)

/datum/team/gang/gib
	name = "Gib"
	color = "#636060" //Applying black to grayscale... Zero-G is already grey too. oh well.
	inner_outfits = list(/obj/item/clothing/under/color/black)
	outer_outfits = list(/obj/item/clothing/suit/jacket/leather/overcoat)

/datum/team/gang/tunnel
	name = "Tunnel"
	color = "#FF00FF" //Gave the leather jacket to the tunnel gang over diablo.
	inner_outfits = list(/obj/item/clothing/under/costume/villain)
	outer_outfits = list(/obj/item/clothing/suit/jacket/leather)

/datum/team/gang/diablo
	name = "Diablo"
	color = "#FF0000"   //literal early 90s skinhead regalia.
	inner_outfits = list(/obj/item/clothing/under/pants/classicjeans)
	outer_outfits = list(/obj/item/clothing/suit/suspenders)

/datum/team/gang/psyke
	name = "Psyke"
	color = "#808080"
	inner_outfits = list(/obj/item/clothing/under/color/grey)
	outer_outfits = list(/obj/item/clothing/suit/toggle/owlwings/griffinwings)

/datum/team/gang/osiron
	name = "Osiron"
	color = "#FFFFFF"
	inner_outfits = list(/obj/item/clothing/under/color/white)
	outer_outfits = list(/obj/item/clothing/suit/toggle/labcoat)

/datum/team/gang/sirius
	name = "Sirius"
	color = "#FFC0CB"
	inner_outfits = list(/obj/item/clothing/under/color/pink)
	outer_outfits = list(/obj/item/clothing/suit/jacket/puffer/vest)

/datum/team/gang/sleepingcarp
	name = "Sleeping Carp"
	color = "#800080"
	inner_outfits = list(/obj/item/clothing/under/color/lightpurple)
	outer_outfits = list(/obj/item/clothing/suit/hooded/carp_costume)

/datum/team/gang/h
	name = "H"
	color = "#993333"
	inner_outfits = list(/obj/item/clothing/under/costume/jabroni) //Why not?
	outer_outfits = list(/obj/item/clothing/suit/toggle/owlwings)

/datum/team/gang/rigatonifamily
	name = "Rigatoni family"
	color = "#cc9900" // p a s t a colored
	inner_outfits = list(/obj/item/clothing/under/rank/civilian/chef)
	outer_outfits = list(/obj/item/clothing/suit/apron/chef)

/datum/team/gang/weed
	name = "Weed"
	color = "#6cd648"
	inner_outfits = list(/obj/item/clothing/under/color/darkgreen)
	outer_outfits = list(/obj/item/clothing/suit/vapeshirt)
