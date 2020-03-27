/datum/minimap
	var/name
	var/icon/map_icon
	var/icon/meta_icon
	var/icon/overlay_icon
	var/list/color_area_names = list()
	var/minx
	var/maxx
	var/miny
	var/maxy
	var/z_level
	var/id = 0
	var/static/next_id = 0

/datum/minimap/New(z, x1 = 1, y1 = 1, x2 = world.maxx, y2 = world.maxy, name)
	src.name = name
	id = ++next_id
	z_level = z

	var/crop_x1 = x2
	var/crop_x2 = x1
	var/crop_y1 = y2
	var/crop_y2 = y1

	// do the generating
	map_icon = new('html/blank.png')
	meta_icon = new('html/blank.png')
	map_icon.Scale(x2-x1+1, y2-y1+1) // arrays start at 1
	meta_icon.Scale(x2-x1+1, y2-y1+1)
	var/list/area_to_color = list()
	for(var/turf/T in block(locate(x1,y1,z),locate(x2,y2,z)))
		var/area/A = T.loc
		var/img_x = T.x - x1 + 1 // arrays start at 1
		var/img_y = T.y - y1 + 1
		if(!istype(A, /area/space) || istype(T, /turf/closed/wall))
			crop_x1 = min(crop_x1, T.x)
			crop_x2 = max(crop_x2, T.x)
			crop_y1 = min(crop_y1, T.y)
			crop_y2 = max(crop_y2, T.y)
		var/meta_color = area_to_color[A]
		if(!meta_color)
			meta_color = rgb(rand(0,255),rand(0,255),rand(0,255)) // technically conflicts could happen but it's like very unlikely and it's not that big of a deal if one happens
			area_to_color[A] = meta_color
			color_area_names[meta_color] = A.name
		meta_icon.DrawBox(meta_color, img_x, img_y)
		if(istype(T, /turf/closed/wall))
			map_icon.DrawBox("#000000", img_x, img_y)
		else if(!istype(A, /area/space))
			var/color = A.minimap_color || "#FF00FF"
			if(locate(/obj/machinery/power/solar) in T)
				color = "#02026a"
			if((locate(/obj/effect/spawner/structure/window) in T) || (locate(/obj/structure/grille) in T))
				color = BlendRGB(color, "#000000", 0.5)
			map_icon.DrawBox(color, img_x, img_y)
	map_icon.Crop(crop_x1, crop_y1, crop_x2, crop_y2)
	meta_icon.Crop(crop_x1, crop_y1, crop_x2, crop_y2)
	minx = crop_x1
	maxx = crop_x2
	miny = crop_y1
	maxy = crop_y2
	overlay_icon = new(map_icon)
	overlay_icon.Scale(16, 16)

/datum/minimap/proc/send(mob/user)
	register_asset("minimap-[id].png", map_icon)
	register_asset("minimap-[id]-meta.png", meta_icon)
	send_asset_list(user, list("minimap-[id].png" = map_icon, "minimap-[id]-meta.png" = meta_icon), verify=FALSE)

/datum/minimap_group
	var/list/minimaps
	var/static/next_id = 0
	var/id
	var/name

/datum/minimap_group/New(list/maps, name)
	id = ++next_id
	src.name = name
	minimaps = maps || list()

/datum/minimap_group/proc/show(mob/user)
	if(!length(minimaps))
		to_chat(user, "<span class='boldwarning'>ERROR: Attempted to access an empty datum/minimap_group. This should probably not happen.</span>")
		return
	var/list/datas = list()
	var/list/info = list()
	var/datum/minimap/first_map = minimaps[1]
	for(var/i in 1 to length(minimaps))
		var/datum/minimap/M = minimaps[i]
		M.send(user)
		info += "<img src='minimap-[M.id].png' id='map-[i]'><img src='minimap-[M.id]-meta.png' style='display: none' id='map-[i]-meta'><div id='label-[i]'></div>"
		datas += json_encode(M.color_area_names);
	info = info.Join()

	var/html = {"
<!DOCTYPE html>
<HTML>
<HEAD>
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<script>
function hexify(num) {
	if(!num) num = 0;
	num = num.toString(16);
	if(num.length == 1) num = "0" + num;
	return num;
}
window.onload = function() {
	var datas = \[[jointext(datas, ",")]]
	if(window.HTMLCanvasElement) {
		for(var i = 0; i < [minimaps.len]; i++) {
			(function() {
				var data = datas\[i];
				var img = document.getElementById("map-" + (i+1));
				if(!img) return;
				var canvas = document.createElement("canvas");
				canvas.width = img.width * 2;
				canvas.height = img.height * 2;
				var ctx = canvas.getContext('2d');
				ctx.msImageSmoothingEnabled = false;
				ctx.drawImage(img, 0, 0, canvas.width, canvas.height);
				img.parentNode.replaceChild(canvas, img);
				ctx = document.createElement("canvas").getContext('2d');
				ctx.canvas.width = img.width;
				ctx.canvas.height = img.height;
				ctx.drawImage(document.getElementById("map-" + (i+1) + "-meta"), 0, 0);
				var imagedata = ctx.getImageData(0, 0, img.width, img.height);
				var label = document.getElementById("label-" + (i+1));
				canvas.onmousemove = function(e) {
					var rect = canvas.getBoundingClientRect();
					var x = Math.floor(e.offsetX * img.width / rect.width);
					var y = Math.floor(e.offsetY * img.height / rect.height);
					var color_idx = x * 4 + (y * 4 * imagedata.width);
					var color = "#" + hexify(imagedata.data\[color_idx]) + hexify(imagedata.data\[color_idx+1]) + hexify(imagedata.data\[color_idx+2]);
					label.textContent = data\[color];
					canvas.title = data\[color];
				}
				canvas.onmouseout = function(e) {
					label.textContent = "";
					canvas.title = "";
				}
			})();
		}
	}
}
</script>
<STYLE>
	img, canvas {
		width: 100%
	}
</STYLE>
<TITLE>[name]</TITLE>
</HEAD>
<BODY>[info]</BODY>
</HTML>"}

	user << browse(html, "window=minimap_[id];size=768x[round(768 / first_map.map_icon.Width() * first_map.map_icon.Height() + 50)]")
