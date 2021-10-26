#define MINESWEEPER_GAME_MAIN_MENU	0
#define MINESWEEPER_GAME_PLAYING	1
#define MINESWEEPER_GAME_LOST		2
#define MINESWEEPER_GAME_WON		3
#define MINESWEEPERIMG(what) {"<img style='border:0' <span class="minesweeper16x16 [#what]"></span>"} //Basically bypassing asset.icon_tag()

/obj/machinery/computer/arcade/minesweeper
	name = "Minesweeper"
	desc = "An arcade machine that generates grids. It seems that the machine sparks and screeches when a grid is generated, as if it cannot cope with the intensity of generating the grid."
	icon_state = "arcade"
	circuit = /obj/item/circuitboard/computer/arcade/minesweeper
	var/area
	var/difficulty = ""	//To show what difficulty you are playing
	var/flag_text = ""
	var/flagging = FALSE
	var/game_status = MINESWEEPER_GAME_MAIN_MENU
	var/mine_limit = 0
	var/mine_placed = 0
	var/mine_sound = TRUE	//So it doesn't get repeated when multiple mines are exposed
	var/randomcolour = 1
	var/randomnumber = 1	//Random emagged game iteration number to be displayed, put here so it is persistent across one individual arcade machine
	var/safe_squares_revealed
	var/saved_web = ""	//To display the web if you click on the arcade
	var/win_condition
	var/rows = 1
	var/columns = 1
	var/table[31][51]	//Make the board boys, 30x50 board
	var/spark_spam = FALSE

/obj/machinery/computer/arcade/minesweeper/interact(mob/user)
	var/emagged = CHECK_BITFIELD(obj_flags, EMAGGED)
	var/dat
	if(game_status == MINESWEEPER_GAME_MAIN_MENU)
		dat += "<head><title>Minesweeper</title></head><div align='center'><b>Minesweeper[emagged ? " <font color='red'>EXTREME EDITION</font>: Iteration <font color='[randomcolour]'>#[randomnumber]</font>" : ""]</b><br>"	//Different colour mix for every random number made
		dat += "<font size='2'> [emagged ? "Explode in the game, explode in real life" : "Reveal all the squares without hitting a mine"]!<br>What difficulty do you want to play?<br><br><br><br><b><a href='byond://?src=[REF(src)];Easy=1'><font color='#cc66ff'>Easy (9x9 board, 10 mines)</font></a><br><a href='byond://?src=[REF(src)];Intermediate=1'><font color='#cc66ff'>Intermediate (16x16 board, 40 mines)</font></a><br><a href='byond://?src=[REF(src)];Hard=1'><font color='#cc66ff'>Hard (16x30 board, 99 mines)</font></a><br><a href='byond://?src=[REF(src)];Custom=1'><font color='#cc66ff'>Custom</font>"
	else
		dat = saved_web
	user = usr

	var/datum/asset/assets = get_asset_datum(/datum/asset/spritesheet/simple/minesweeper)
	assets.send(user)

	user << browse(dat,"window=minesweeper,size=400x500")
	add_fingerprint(user)

	. = ..()

/obj/machinery/computer/arcade/minesweeper/proc/reset_spark_spam()
	spark_spam = FALSE

/obj/machinery/computer/arcade/minesweeper/Topic(href, href_list)
	. = ..()
	if(.)
		return

	var/exploding_hell = FALSE	//For emagged failures
	var/reset_board = FALSE
	var/mob/living/user = usr	//To identify who the hell is using this window, this should also make things like aliens and monkeys able to use the machine!!
	var/web_difficulty_menu = "<font size='2'> Reveal all the squares without hitting a mine!<br>What difficulty do you want to play?<br><br><br><br><b><a href='byond://?src=[REF(src)];Easy=1'><font color='#cc66ff'>Easy (9x9 board, 10 mines)</font></a><br><a href='byond://?src=[REF(src)];Intermediate=1'><font color='#cc66ff'>Intermediate (16x16 board, 40 mines)</font></a><br><a href='byond://?src=[REF(src)];Hard=1'><font color='#cc66ff'>Hard (16x30 board, 99 mines)</font></a><br><a href='byond://?src=[REF(src)];Custom=1'><font color='#cc66ff'>Custom</font>"
	var/web = "<head><title>Minesweeper</title></head><div align='center'><b>Minesweeper</b><br>"
	var/static_web = "<head><title>Minesweeper</title></head><div align='center'><b>Minesweeper</b><br>"	//When we need to revert to the main menu we set web as this
	web = static_web

	if(CHECK_BITFIELD(obj_flags, EMAGGED))
		web = "<head><title>Minesweeper</title></head><body><div align='center'><b>Minesweeper <font color='red'>EXTREME EDITION</font>: Iteration <font color='[randomcolour]'>#[randomnumber]</font></b><br>"	//Different colour mix for every random number made
		if(!spark_spam)
			do_sparks(5, 1, src)
			spark_spam = TRUE
			addtimer(CALLBACK(src, .proc/reset_spark_spam), 30)


	var/startup_sound = CHECK_BITFIELD(obj_flags, EMAGGED) ? 'sound/arcade/minesweeper_emag2.ogg' : 'sound/arcade/minesweeper_startup.ogg'

	if(href_list["Main_Menu"])
		game_status = MINESWEEPER_GAME_MAIN_MENU
		mine_limit = 0
		rows = 0
		columns = 0
		mine_placed = 0
	if(href_list["Easy"])
		playsound(loc, startup_sound, 50, FALSE, extrarange = -3)
		flag_text = "OFF"
		game_status = MINESWEEPER_GAME_PLAYING
		reset_board = TRUE
		difficulty = "Easy"
		rows = 10	//9x9 board
		columns = 10
		mine_limit = 10
	if(href_list["Intermediate"])
		playsound(loc, startup_sound, 50, FALSE, extrarange = -3)
		flag_text = "OFF"
		game_status = MINESWEEPER_GAME_PLAYING
		reset_board = TRUE
		difficulty = "Intermediate"
		rows = 17	//16x16 board
		columns = 17
		mine_limit = 40
	if(href_list["Hard"])
		playsound(loc, startup_sound, 50, FALSE, extrarange = -3)
		flag_text = "OFF"
		game_status = MINESWEEPER_GAME_PLAYING
		reset_board = TRUE
		difficulty = "Hard"
		rows = 17	//16x30 board
		columns = 31
		mine_limit = 99
	if(href_list["Custom"])
		if(custom_generation(usr))
			flag_text = "OFF"
			game_status = MINESWEEPER_GAME_PLAYING
			reset_board = TRUE
			difficulty = "Custom"
			playsound(loc, startup_sound, 50, FALSE, extrarange = -3)
	if(href_list["Flag"])
		playsound(loc, 'sound/arcade/minesweeper_boardpress.ogg', 50, FALSE, extrarange = -3)
		if(!flagging)
			flagging = TRUE
			flag_text = "ON"
		else
			flagging = FALSE
			flag_text = "OFF"

	if(game_status == MINESWEEPER_GAME_MAIN_MENU)
		if(CHECK_BITFIELD(obj_flags, EMAGGED))
			playsound(loc, 'sound/arcade/minesweeper_emag2.ogg', 50, FALSE, extrarange = -3)
			web += "<font size='2'>Explode in the game, explode in real life!<br>What difficulty do you want to play?<br><br><br><br><b><a href='byond://?src=[REF(src)];Easy=1'><font color='#cc66ff'>Easy (9x9 board, 10 mines)</font></a><br><a href='byond://?src=[REF(src)];Intermediate=1'><font color='#cc66ff'>Intermediate (16x16 board, 40 mines)</font></a><br><a href='byond://?src=[REF(src)];Hard=1'><font color='#cc66ff'>Hard (16x30 board, 99 mines)</font></a><br><a href='byond://?src=[REF(src)];Custom=1'><font color='#cc66ff'>Custom</font>"
		else
			playsound(loc, 'sound/arcade/minesweeper_startup.ogg', 50, FALSE, extrarange = -3)
			web += web_difficulty_menu

	if(game_status == MINESWEEPER_GAME_PLAYING)
		mine_sound = TRUE

	area = (rows-1)*(columns-1)

	if(reset_board)
		mine_placed = 0
		var/reset_everything = TRUE
		make_mines(reset_everything)

	safe_squares_revealed = 0
	win_condition = area-mine_placed

	if(game_status != MINESWEEPER_GAME_MAIN_MENU)
		for(var/y1=1;y1<rows;y1++)
			for(var/x1=1;x1<columns;x1++)
				var/coordinates
				coordinates = (y1*100)+x1
				if(href_list["[coordinates]"])
					if(game_status == MINESWEEPER_GAME_PLAYING)	//Don't do anything if we won or something
						if(!flagging)
							if(table[y1][x1] < 10 && table[y1][x1] >= 0)	//Check that it's not already revealed, and stop flag removal if we're out of flag mode
								table[y1][x1] += 10
								if(table[y1][x1] != 10)
									playsound(loc, 'sound/arcade/minesweeper_boardpress.ogg', 50, FALSE, extrarange = -3)
								else
									if(game_status != MINESWEEPER_GAME_LOST && game_status != MINESWEEPER_GAME_WON)
										game_status = MINESWEEPER_GAME_LOST
										if(CHECK_BITFIELD(obj_flags, EMAGGED) && !exploding_hell)
											exploding_hell  = TRUE
											explode_EVERYTHING()
											if(QDELETED(src))
												return
										if(mine_sound)
											switch(rand(1,3))	//Play every time a mine is hit
												if(1)
													playsound(loc, 'sound/arcade/minesweeper_explosion1.ogg', 50, FALSE, extrarange = -3)
												if(2)
													playsound(loc, 'sound/arcade/minesweeper_explosion2.ogg', 50, FALSE, extrarange = -3)
												if(3)
													playsound(loc, 'sound/arcade/minesweeper_explosion3.ogg', 50, FALSE, extrarange = -3)
											mine_sound = FALSE
						else
							playsound(loc, 'sound/arcade/minesweeper_boardpress.ogg', 50, FALSE, extrarange = -3)
							if(table[y1][x1] >= 0)	//Check that it's not already flagged
								table[y1][x1] -= 10
							else if(table[y1][x1] < 0)	//If flagged, remove the flag
								table[y1][x1] += 10
				if(href_list["same_board"])	//Reset the board... kinda
					if(game_status != MINESWEEPER_GAME_PLAYING)
						mine_sound = TRUE
						game_status = MINESWEEPER_GAME_PLAYING
					if(table[y1][x1] >= 10)	//If revealed, become unrevealed!
						if(mine_sound)
							playsound(loc, 'sound/arcade/minesweeper_menuselect.ogg', 50, FALSE, extrarange = -3)
							mine_sound = FALSE
						table[y1][x1] -= 10
				if(table[y1][x1] > 10 && !reset_board)
					safe_squares_revealed += 1
				var/y2 = y1
				var/x2 = x1
				work_squares(y2, x2)	//Work squares while in this loop so there's less load
				reset_board = FALSE

		web += "<table>"	//Start setting up the html table
		web += "<tbody>"
		for(var/y1=1;y1<rows;y1++)
			web += "<tr>"
			for(var/x1=1;x1<columns;x1++)
				var/coordinates
				coordinates = (y1*100)+x1
				switch(table[y1][x1])
					if(-10 to -1)
						if(game_status != MINESWEEPER_GAME_PLAYING)
							web += "<td>[MINESWEEPERIMG(flag)]</td>"
						else
							web += "<td><a href='byond://?src=[REF(src)];[coordinates]=1'>[MINESWEEPERIMG(flag)]</a></td>"
					if(0)
						if(game_status != MINESWEEPER_GAME_PLAYING)
							web += "<td>[MINESWEEPERIMG(mine)]</td>"
						else
							web += "<td><a href='byond://?src=[REF(src)];[coordinates]=1'>[MINESWEEPERIMG(hidden)]</a></td>"	//Make unique hrefs for every square
					if(1 to 9)
						if(game_status != MINESWEEPER_GAME_PLAYING)
							web += "<td>[MINESWEEPERIMG(hidden)]</td>"
						else
							web += "<td><a href='byond://?src=[REF(src)];[coordinates]=1'>[MINESWEEPERIMG(hidden)]</a></td>"	//Make unique hrefs for every square
					if(10)
						web += "<td>[MINESWEEPERIMG(minehit)]</td>"
					if(11)
						web += "<td>[MINESWEEPERIMG(empty)]</td>"
					if(12)
						web += "<td>[MINESWEEPERIMG(1)]</td>"
					if(13)
						web += "<td>[MINESWEEPERIMG(2)]</td>"
					if(14)
						web += "<td>[MINESWEEPERIMG(3)]</td>"
					if(15)
						web += "<td>[MINESWEEPERIMG(4)]</td>"
					if(16)
						web += "<td>[MINESWEEPERIMG(5)]</td>"
					if(17)
						web += "<td>[MINESWEEPERIMG(6)]</td>"
					if(18)
						web += "<td>[MINESWEEPERIMG(7)]</td>"
					if(19)
						web += "<td>[MINESWEEPERIMG(8)]</td>"
			web += "</tr>"
		web += "</table>"
		web += "</tbody>"
	web += "<br>"

	if(safe_squares_revealed >= win_condition && game_status == MINESWEEPER_GAME_PLAYING)
		game_status = MINESWEEPER_GAME_WON
		if(rows < 10 || columns < 10)	//If less than easy difficulty
			playsound(loc, 'sound/arcade/minesweeper_winfail.ogg', 50, FALSE, extrarange = -3)
			say("You cleared the board of all mines, but you picked too small of a board! Try again with at least a 9x9 board!")
		else
			playsound(loc, 'sound/arcade/minesweeper_win.ogg', 50, FALSE, extrarange = -3)
			say("You cleared the board of all mines! Congratulations!")
			if(CHECK_BITFIELD(obj_flags, EMAGGED))
				var/itemname
				switch(rand(1,3))
					if(1)
						itemname = "a syndicate bomb beacon"
						new /obj/item/sbeacondrop/bomb(loc)
					if(2)
						itemname = "a rocket launcher"
						new /obj/item/gun/ballistic/rocketlauncher/unrestricted(loc)
						new /obj/item/ammo_casing/caseless/rocket(loc)
						new /obj/item/ammo_casing/caseless/rocket(loc)
						new /obj/item/ammo_casing/caseless/rocket(loc)
					if(3)
						itemname = "two bags of c4"
						new /obj/item/storage/backpack/duffelbag/syndie/c4(loc)
						new /obj/item/storage/backpack/duffelbag/syndie/x4(loc)
				message_admins("[key_name_admin(user)] won emagged Minesweeper and got [itemname]!")
				visible_message("<span class='notice'>[src] dispenses [itemname]!</span>", "<span class='notice'>You hear a chime and a clunk.</span>")
				DISABLE_BITFIELD(obj_flags, EMAGGED)
			else
				var/dope_prizes = (area >= 480) ? 6 : (area >= 256) ? 4 : 2
				prizevend(user, dope_prizes)

	if(game_status == MINESWEEPER_GAME_WON)
		web += "[(rows < 10 || columns < 10) ? "<font size='4'>You won, but your board was too small! Pick a bigger board next time!" : "<font size='6'>Congratulations, you have won!"]<br><font size='3'>Want to play again?<br><b><a href='byond://?src=[REF(src)];Easy=1'><font color='#cc66ff'>Easy (9x9 board, 10 mines)</font></a><br><a href='byond://?src=[REF(src)];Intermediate=1'><font color='#cc66ff'>Intermediate (16x16 board, 40 mines)</font></a><br><a href='byond://?src=[REF(src)];Hard=1'><font color='#cc66ff'>Hard (16x30 board, 99 mines)</font></a><br><a href='byond://?src=[REF(src)];Custom=1'><font color='#cc66ff'>Custom</font></a></b><br><a href='byond://?src=[REF(src)];same_board=1'><font color='#cc66ff'>Play on the same board</font></a><br><a href='byond://?src=[REF(src)];Main_Menu=1'><font color='#cc66ff'>Return to Main Menu</font></a></b><br>"

	if(game_status == MINESWEEPER_GAME_LOST)
		web += "<font size='6'>You have lost!<br><font size='3'>Try again?<br><b><a href='byond://?src=[REF(src)];Easy=1'><font color='#cc66ff'>Easy (9x9 board, 10 mines)</font></a><br><a href='byond://?src=[REF(src)];Intermediate=1'><font color='#cc66ff'>Intermediate (16x16 board, 40 mines)</font></a><br><a href='byond://?src=[REF(src)];Hard=1'><font color='#cc66ff'>Hard (16x30 board, 99 mines)</font></a><br><a href='byond://?src=[REF(src)];Custom=1'><font color='#cc66ff'>Custom</font></a></b><br><a href='byond://?src=[REF(src)];same_board=1'><font color='#cc66ff'>Play on the same board</font></a><br><a href='byond://?src=[REF(src)];Main_Menu=1'><font color='#cc66ff'>Return to Main Menu</font></a></b><br>"

	if(game_status == MINESWEEPER_GAME_PLAYING)
		web += "<a href='byond://?src=[REF(src)];Main_Menu=1'><font color='#cc66ff'>Return to Main Menu</font></a><br>"
		web += "<div align='right'>Difficulty: [difficulty]<br>Mines: [mine_placed]<br>Rows: [rows-1]<br>Columns: [columns-1]<br><a href='byond://?src=[REF(src)];Flag=1'><font color='#cc66ff'>Flagging mode: [flag_text]</font></a></div>"

	web += "</div>"
	var/datum/asset/spritesheet/sheet = get_asset_datum(/datum/asset/spritesheet/simple/minesweeper)
	saved_web = sheet.css_tag()
	saved_web += web
	updateDialog()
	return

/obj/machinery/computer/arcade/minesweeper/emag_act(mob/user)
	. = ..()
	if(CHECK_BITFIELD(obj_flags, EMAGGED))
		return
	desc = "An arcade machine that generates grids. It's clunking and sparking everywhere, almost as if threatening to explode at any moment!"
	do_sparks(5, 1, src)
	randomnumber = rand(1,255)
	randomcolour = rgb(randomnumber,randomnumber/2,randomnumber/3)
	ENABLE_BITFIELD(obj_flags, EMAGGED)
	if(game_status == MINESWEEPER_GAME_MAIN_MENU)
		to_chat(user, "<span class='warning'>An ominous tune plays from the arcade's speakers!</span>")
		playsound(user, 'sound/arcade/minesweeper_emag1.ogg', 100, FALSE, extrarange = 3)
	else	//Can't let you do that, star fox!
		to_chat(user, "<span class='warning'>The machine buzzes and sparks... the game has been reset!</span>")
		playsound(user, 'sound/machines/buzz-sigh.ogg', 100, FALSE, extrarange = 3)	//Loud buzz
		game_status = MINESWEEPER_GAME_MAIN_MENU
	return TRUE

/obj/machinery/computer/arcade/minesweeper/proc/custom_generation(mob/user)
	playsound(loc, 'sound/arcade/minesweeper_menuselect.ogg', 50, FALSE, extrarange = -3)	//Entered into the menu so ping sound
	var/new_rows = input(user, "How many rows do you want? (Minimum: 4, Maximum: 30)", "Minesweeper Rows") as null|num
	if(!new_rows || !user.canUseTopic(src, !hasSiliconAccessInArea(user)))
		return FALSE
	new_rows = clamp(new_rows + 1, 4, 20)
	playsound(loc, 'sound/arcade/minesweeper_menuselect.ogg', 50, FALSE, extrarange = -3)
	var/new_columns = input(user, "How many columns do you want? (Minimum: 4, Maximum: 50)", "Minesweeper Squares") as null|num
	if(!new_columns || !user.canUseTopic(src, !hasSiliconAccessInArea(user)))
		return FALSE
	new_columns = clamp(new_columns + 1, 4, 30)
	playsound(loc, 'sound/arcade/minesweeper_menuselect.ogg', 50, FALSE, extrarange = -3)
	var/grid_area = (new_rows - 1) * (new_columns - 1)
	var/lower_limit = round(grid_area*0.156)
	var/upper_limit = round(grid_area*0.85)
	var/new_mine_limit = input(user, "How many mines do you want? (Minimum: [lower_limit], Maximum: [upper_limit])", "Minesweeper Mines") as null|num
	if(!new_mine_limit || !user.canUseTopic(src, !hasSiliconAccessInArea(user)))
		return FALSE
	playsound(loc, 'sound/arcade/minesweeper_menuselect.ogg', 50, FALSE, extrarange = -3)
	rows = new_rows
	columns = new_columns
	mine_limit = clamp(new_mine_limit, lower_limit, upper_limit)
	return TRUE

/obj/machinery/computer/arcade/minesweeper/proc/make_mines(var/reset_everything)
	if(mine_placed < mine_limit)
		for(var/y1=1;y1<rows;y1++)	//Board resetting and mine building
			for(var/x1=1;x1<columns;x1++)
				if(prob(area/mine_limit) && mine_placed < mine_limit && table[y1][x1] != 0)	//Unlikely for this to happen but this has eaten mines before
					table[y1][x1] = 0
					mine_placed += 1
				else if(reset_everything)
					table[y1][x1] = 1
		reset_everything = FALSE
		make_mines()	//In case the first pass doesn't generate enough mines

/obj/machinery/computer/arcade/minesweeper/proc/work_squares(var/y2, var/x2, var/y3, var/x3)
	if(y3 > 0 && x3 > 0)
		y2 = y3
		x2 = x3
	if(table[y2][x2] == 1)
		for(y3=y2-1;y3<y2+2;y3++)
			if(y3 >= rows || y3 < 1)
				continue
			for(x3=x2-1;x3<x2+2;x3++)
				if(x3 >= columns || x3 < 1)
					continue
				if(table[y3][x3] == 0)
					table[y2][x2] += 1
	if(table[y2][x2] == 11)
		for(y3=y2-1;y3<y2+2;y3++)
			if(y3 >= rows || y3 < 1)
				continue
			for(x3=x2-1;x3<x2+2;x3++)
				if(x3 >= columns || x3 < 1)
					continue
				if(table[y3][x3] > 0 && table[y3][x3] < 10)
					table[y3][x3] += 10
					work_squares(y3, x3)	//Refresh so we check everything we might be missing

/obj/machinery/computer/arcade/minesweeper/proc/explode_EVERYTHING()
	var/mob/living/user = usr
	to_chat(user, "<span class='boldwarning'>You feel a great sense of dread wash over you, as if you just unleashed armageddon upon yourself!</span>")
	var/row_limit = rows-1
	var/column_limit = columns-1
	var/mine_limit_v2 = mine_limit
	if(rows > 21)
		row_limit = 20
	if(columns > 21)
		column_limit = 20
	if(mine_limit > (rows*columns) * 0.25)
		mine_limit_v2 = 24
	message_admins("[key_name_admin(user)] failed an emagged Minesweeper arcade and has unleashed an explosion armageddon of size [row_limit],[column_limit] around [ADMIN_LOOKUPFLW(user.loc)]!")
	if(mine_limit_v2 < 10)
		explosion(loc, 2, 5, 10, 15)	//Thought you could survive by putting as few mines as possible, huh??
	else
		explosion(loc, 1, 3, rand(1,5), rand(1,10))
	var/list/targets = list()
	var/cur_y = y - round(row_limit * 0.5, 1)
	var/starting_row = 1
	if(cur_y < 1)
		starting_row -= cur_y - 1
		cur_y = 1
	var/start_x = x - round(column_limit * 0.5, 1)
	var/starting_column = 1
	if(start_x < 1)
		starting_column -= start_x - 1
		start_x = 1
	for(var/row in starting_row to length(table)) //translate the mines locations into actual turf coordinates.
		if(!locate(cur_y, start_x, z))
			break
		var/cur_x = start_x
		for(var/column in starting_column to length(table[row]))
			var/coord_value = table[row][column]
			if(coord_value == 10 || coord_value == 0) //there is a mine in here.
				var/turf/T = locate(cur_y, cur_x, z)
				if(!T)
					break
				targets += T
			cur_x++
		cur_y++
	var/num_explosions = 0
	for(var/T in shuffle(targets)) //Create a shitton of explosions in irl turfs if we lose, it will probably kill us
		addtimer(CALLBACK(GLOBAL_PROC, /proc/explosion, T, 0, rand(1,2),rand(1,5),rand(3,10), FALSE), 15 * ++num_explosions)
		if(num_explosions == mine_limit_v2)
			return

#undef MINESWEEPERIMG
#undef MINESWEEPER_GAME_MAIN_MENU
#undef MINESWEEPER_GAME_PLAYING
#undef MINESWEEPER_GAME_LOST
#undef MINESWEEPER_GAME_WON
