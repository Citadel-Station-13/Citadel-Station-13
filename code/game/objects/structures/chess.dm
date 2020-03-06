/obj/structure/chess
	anchored = FALSE
	density = FALSE
	icon = 'icons/obj/chess.dmi'
	icon_state = "singularity_s1"
	name = "Singularity"
	desc = "You've just been pranked by the Syndicate Chess Grandmaster! Report this to CentCom."
	max_integrity = 100

/obj/structure/chess/wrench_act(mob/user, obj/item/tool)
	to_chat(user, "<span class='notice'>You take apart the chess piece.</span>")
	var/obj/item/stack/sheet/metal/M = new (drop_location(), 2)
	M.add_fingerprint(user)
	tool.play_tool_sound(src)
	qdel(src)
	return TRUE

/obj/structure/chess/whitepawn
	name = "\improper White Pawn"
	desc = "A white pawn chess piece. Get accused of cheating when executing a sick En Passant."
	icon_state = "white_pawn"

/obj/structure/chess/whiterook
	name = "\improper White Rook"
	desc = "A white rook chess piece. Also known as a castle. Can move any number of tiles in a straight line. It has a special move called castling."
	icon_state = "white_rook"

/obj/structure/chess/whiteknight
	name = "\improper White Knight"
	desc = "A white knight chess piece. Hah. It can hop over other pieces, moving in L shapes."
	icon_state = "white_knight"

/obj/structure/chess/whitebishop
	name = "\improper White Bishop"
	desc = "A white bishop chess piece. It can move any number of tiles in a diagonal line."
	icon_state = "white_bishop"

/obj/structure/chess/whitequeen
	name = "\improper White Queen"
	desc = "A white queen chess piece. It can move any number of tiles in diagonal and straight lines."
	icon_state = "white_queen"

/obj/structure/chess/whiteking
	name = "\improper White King"
	desc = "A white king chess piece. It can move any tile in one direction."
	icon_state = "white_king"

/obj/structure/chess/blackpawn
	name = "\improper Black Pawn"
	desc = "A black pawn chess piece. Get accused of cheating when executing a sick En Passant."
	icon_state = "black_pawn"

/obj/structure/chess/blackrook
	name = "\improper Black Rook"
	desc = "A black rook chess piece. Also known as a castle. Can move any number of tiles in a straight line. It has a special move called castling."
	icon_state = "black_rook"

/obj/structure/chess/blackknight
	name = "\improper Black Knight"
	desc = "A black knight chess piece. It can hop over other pieces, moving in L shapes."
	icon_state = "black_knight"

/obj/structure/chess/blackbishop
	name = "\improper Black Bishop"
	desc = "A black bishop chess piece. It can move any number of tiles in a diagonal line."
	icon_state = "black_bishop"

/obj/structure/chess/blackqueen
	name = "\improper Black Queen"
	desc = "A black queen chess piece. It can move any number of tiles in diagonal and straight lines."
	icon_state = "black_queen"

/obj/structure/chess/blackking
	name = "\improper Black King"
	desc = "A black king chess piece. It can move one tile in any direction."
	icon_state = "black_king"