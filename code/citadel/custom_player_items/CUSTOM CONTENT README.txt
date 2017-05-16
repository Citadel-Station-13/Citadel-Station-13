In order to designate a specific player to spawn with specific items, make a .txt file with the title being in the format of [player ckey].
In the file, the items should be declared in the format of [Character Name]:[Job]:[itempath]. If you would like the item to spawn for all jobs, set the [Job] to All.
Multiple-job items can be designated with the format [Job]/[Job]/[Job]:[itempath].
Multiple items must be seperated by a 

An example is given below, for a player who would like to spawn with `obj/item/weapon/karlarma` and `obj/item/clothing/under/karlvest`, as well as `obj/item/stunstickreskin` when Security Officer:

[Filename:] unknown_person

Karl:All:obj/item/weapon/karlarma
Karl:All:obj/item/clothing/under/karlvest
Karl:Security Officer:obj/item/stunstickreskin

After this, add the ckey of the user to player_keys.txt on a new line.
