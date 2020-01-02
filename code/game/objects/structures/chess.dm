/* I don't know how to code.
 * This is the only way I can contribute to the codebase with this shitty addition other than mapping.
 * I don't know how to literally code chess into SS13, not even coding it so you can only do so and so moves, but I don't know how to even make a table to open a menu with little draggable pictures.
 * Please forgive this shit code and the actual trash that this whole thing is, because adding something you can build in-game to have a little fun every 50-100 shifts or so is fun.
 * If you are porting this, apologies, but you should check sheet_types.dm so these can be buildable at least.
 */


/obj/structure/chess
	anchored = FALSE
	density = FALSE
	icon = 'icons/obj/chess.dmi'
	icon_state = "singularity_s1"
	name = "Singularity"
	desc = "You've just been pranked by the Syndicate Chess Grandmaster! Report this to CentCom."
	max_integrity = 100
	resistance_flags = FLAMMABLE
	var/buildstacktype = /obj/item/stack/sheet/metal
	var/buildstackamount = 2

/obj/structure/chess/wrench_act(mob/user, obj/item/tool)
	to_chat(user, "<span class='notice'>You take apart the chess piece.</span>")
	var/obj/item/stack/sheet/metal/M = new (loc, 2)
	M.add_fingerprint(user)
	playsound(src.loc, 'sound/items/deconstruct.ogg', 50, 1)
	qdel(src)
	return TRUE

/obj/structure/chess/WhitePawn
	name = "White Pawn"
	desc = "A white pawn manufactured by Kat-Kea. Get accused of cheating when executing a sick En Passant."
	icon_state = "white_pawn"

/obj/structure/chess/WhiteRook
	name = "White Rook"
	desc = "A white rook manufactured by Kat-Kea. Get accused of cheating when castling."
	icon_state = "white_rook"

/obj/structure/chess/WhiteKnight
	name = "White Knight"
	desc = "A white knight manufactured by Kat-Kea. This one weighs a lot, and has a L6 SAW and fedora inside of it, it leaps in a L-shape over people to valiantly protect women from urm, their own decisions."
	icon_state = "white_knight"

/obj/structure/chess/WhiteBishop
	name = "White Bishop"
	desc = "A white bishop manufactured by Kat-Kea. Break the system. Why be vertical, or a horizontal loser, when you can go diagonal? Fun Fact: The Bishop used to be an elephant, and had different rules all over Earth."
	icon_state = "white_bishop"

/obj/structure/chess/WhiteQueen
	name = "White Queen"
	desc = "A white queen manufactured by Kat-Kea. Gets stalked by the white knight. Imagine being beaten up by a women, hah! Fun Fact: The original Queen was the King's advisor and could only move one square diagonally."
	icon_state = "white_queen"

/obj/structure/chess/WhiteKing
	name = "White King"
	desc = "A white king manufactured by Kat-Kea. Fun Fact: The earliest chess piece found on Earth was made of ivory and later whale's teeth."
	icon_state = "white_king"

/obj/structure/chess/BlackPawn
	name = "Black Pawn"
	desc = "A black pawn manufactured by Kat-Kea. Get accused of cheating when executing a sick En Passant."
	icon_state = "black_pawn"

/obj/structure/chess/BlackRook
	name = "Black Rook"
	desc = "A white pawn manufactured by Kat-Kea. Get accused of cheating when castling."
	icon_state = "black_rook"

/obj/structure/chess/BlackKnight
	name = "Black Knight"
	desc = "A black knight. Moves in a reverse L shape, gives vivid Tetris flashbacks. Fun Fact: Their moves are the same as the original, used to just be a horse, the most consistent piece over time."
	icon_state = "black_knight"

/obj/structure/chess/BlackBishop
	name = "Black Bishop"
	desc = "A black bishop manufactured by Kat-Kea. Break the system. Why be vertical, or a horizontal loser, when you can go diagonal? Fun Fact: The Bishop used to be an elephant, and had different rules all over Earth."
	icon_state = "black_bishop"

/obj/structure/chess/BlackQueen
	name = "Black Queen"
	desc = "A black queen manufactured by Kat-Kea. Imagine being beaten up by a women, such a loser! Fun Fact: The Mongol Queen was a Dog, the dog got a significant upgrade."
	icon_state = "black_queen"

/obj/structure/chess/BlackKing
	name = "Black King"
	desc = "A black king manufactured by Kat-Kea. Fun Fact: The Mongol name for the King was Lord."
	icon_state = "black_king"