/*
 * Copyright © 2014 Duncan Fairley
 * Distributed under the GNU Affero General Public License, version 3.
 * Your changes must be made public.
 * For the full license text, see LICENSE.txt.
 */
/*mob/verb/NewVault1()

	//THIS IS THE FUNCTION FOR CREATING ADDITIONAL VAULT TEMPLATES

	var/height = 10
	var/width = 9 //Width must be odd.
	var/midx = (width+1)/2
	var/swapmap/map = new /swapmap("vault1",width,height,1)
	map.BuildRectangle(map.LoCorner(),map.HiCorner(),/turf/roofb)
	map.BuildFilledRectangle(get_step(map.LoCorner(),NORTHEAST),get_step(map.HiCorner(),SOUTHWEST),/turf/floor)
	map.BuildFilledRectangle(locate(map.x1+1,map.y1+height-2,map.z1),locate(map.x1+width-2,map.y1+height-2,map.z1),/turf/Hogwarts_Stone_Wall)
	map.BuildFilledRectangle(locate(map.x1+midx-1,map.y1+1,map.z1),locate(map.x1+midx-1,map.y1+1,map.z1),/obj/teleport/leavevault)
	map.Save()


mob/verb/NewVaultCustom(var/height as num, var/width as num)

	if(width % 2 == 0) width--

	var/midx = (width+1)/2
	var/swapmap/map = new /swapmap("testmap",width,height,1)
	map.BuildRectangle(map.LoCorner(),map.HiCorner(),/turf/Ben_Turfs/Hogwarts_Roof)
	map.BuildFilledRectangle(get_step(map.LoCorner(),NORTHEAST),get_step(map.HiCorner(),SOUTHWEST),/turf/Ben_Turfs/Grass)
	map.BuildFilledRectangle(locate(map.x1+1,map.y1+height-2,map.z1),locate(map.x1+width-2,map.y1+height-2,map.z1),/turf/Ben_Turfs/Old_Stone_Wall_Bottom )


	map.BuildFilledRectangle(locate(map.x1+midx-1,map.y1+1,map.z1),locate(map.x1+midx-1,map.y1+1,map.z1),/obj/teleport/leavevault)
	map.Save()

*/
obj/drop_on_death
	var
		announceToWorld = 1
		showicon
		slow = 0

	verb
		Drop()
			var/dense = density
			density = 0
			Move(usr.loc)
			density = dense
			usr:Resort_Stacking_Inv()
			if(announceToWorld)
				Players<<"<b>[usr] drops \the [src].</b>"
			else
				hearers()<<"[usr] drops \the [src]."

			if(showicon == 1) usr.overlays -= icon
			else if(showicon) usr.overlays -= showicon

			if(slow) usr:slow -= slow

	proc
		take(mob/Player/M)
			if(locate(type) in M) return
			if(slow) M.slow += slow
			if(announceToWorld)
				Players << "<b>[M] takes \the [src].</b>"
			else
				hearers()<<"[M] takes \the [src]."
			var/dense = density
			density = 0
			Move(M)
			density = dense
			M:Resort_Stacking_Inv()

			if(showicon == 1) M.overlays += icon
			else if(showicon) M.overlays += showicon

mob/test/verb
	enter_vault(ckey as text)
		set category = "Vault Debug"
		var/swapmap/map = SwapMaps_Find("[ckey]")
		if(!map)
			map = SwapMaps_Load("[ckey]")
		if(!map)
			usr << "<i>Couldn't find map.</i>"
		else
			var/width = (map.x2+1) - map.x1
			usr.loc = locate(map.x1 + round((width)/2), map.y1+1, map.z1 )
	load_undroppables_into_mob(mob/M as mob in Players)
		set category = "Vault Debug"
		var/swapmap/map = SwapMaps_Find("[M.ckey]")
		if(!map)
			map = SwapMaps_Load("[M.ckey]")
		if(!map)
			usr << "<i>Couldn't find map.</i>"
		else
			for(var/turf/T in map.AllTurfs())
				for(var/obj/O in T)
					if(!(text2path("[O.type]/verb/Drop") in O.verbs) && !istype(O,/obj/items/food) && !istype(O,/obj/teleport/leavevault) )
						O.loc = M
			M:Resort_Stacking_Inv()

	Change_Vault(var/vault as text, var/mob/Player/p in Players)
		set category = "Vault Debug"
		if(fexists("[swapmaps_directory]/tmpl_vault[vault].sav"))
			p.change_vault(vault)

mob/Player/proc/change_vault(var/vault)
	var/swapmap/map = SwapMaps_Find("[ckey]")
	if(!map)
		map = SwapMaps_Load("[ckey]")
	if(map)

		for(var/obj/items/i in map)
			i.loc = src
		if(!map.InUse())
			for(var/turf/t in map.AllTurfs())
				for(var/obj/items/i in t)
					i.loc = src
			map.Unload()
			src:Resort_Stacking_Inv()
		else
			src << errormsg("Please evacuate everyone from your vault first.")
			return

	if(!islist(worldData.globalvaults))
		worldData.globalvaults = list()
	var/vault/v = new
	v.tmpl = vault
	worldData.globalvaults[src.ckey] = v
	map = SwapMaps_CreateFromTemplate("vault[vault]")
	if(!map)
		world.log << "ERROR: proc: change_vault() Could not create \"[vault]\" swap map template (vault[vault])"
		return 0
	map.SetID("[src.ckey]")
	map.Save()
	return 1

mob/Player/var/list/addToVault

mob/GM/verb/reset_allowed_list()
	set hidden=55
	for(var/counter in worldData.globalvaults)
		var/vault/V = worldData.globalvaults[counter]
		V.allowedpeople = list()

obj/teleport
	var/dest = ""
	var/pass
	invisibility = 2
	portkey
		icon='portal.dmi'
		icon_state="portkey"
		name = "Port key"
		invisibility = 0
	proc/Teleport(mob/M)
		if(dest)
			if(pass && pass != "")
				var/pw = input(M, "You feel this spot was enchanted with a password protected teleporting spell","Teleport","") as null|text
				if(!pw || M.loc != src.loc) return
				if(pw == pass)
					M << infomsg("Authorization Confirmed.")
				else
					M << errormsg("Authorization Denied.")
					return

			var/atom/A = locate(dest)
			if(A)
				if(isobj(A))
					A = A.loc
				M:Transfer(A)
				M.Move(A)
				M.lastproj = world.time + 10
				if(M.classpathfinding)
					M.Class_Path_to()
				return 1
	entervault
		var/onlySelf = 1
		Teleport(mob/Player/M)
			var/list/accessible_vaults =  list()
			var/list/resolve = list()
			for(var/counter in worldData.globalvaults)
				var/vault/V = worldData.globalvaults[counter]
				if(M.ckey in V.allowedpeople)
					accessible_vaults += counter
					resolve+=sql_get_name_from(counter)
			var/hasownvault = 	fexists("[swapmaps_directory]/map_[M.ckey].sav")
			if(hasownvault)
				var/chosenvault
				var/response
				if(accessible_vaults.len>0)
					response = input("Which vault do you wish to enter?") as null|anything in resolve + "My own"
					if(response == "My own")
						chosenvault = M.ckey
				else if(hasownvault)
					chosenvault = M.ckey
				if(M.loc != src.loc) return
				if(chosenvault == M.ckey)
					M << npcsay("Vault Master: Welcome back to your vault, [M].[pick(" Remember good security! If you let someone inside and they steal something, there's not much you can do about it!!"," Only let people into your vault if you completely trust them!","")]")
				else
					if(!response) return
					M << npcsay("Vault Master: Welcome to [response]'s vault, [M].")

					chosenvault = sql_get_ckey_from(response)
				var/swapmap/map = SwapMaps_Find("[chosenvault]")
				if(!map)
					map = SwapMaps_Load("[chosenvault]")
				var/width = (map.x2+1) - map.x1

				M.loc = locate(map.x1 + round((width)/2), map.y1+1, map.z1 )

				if(chosenvault == M.ckey && M.addToVault)
					var/turf/t = locate(M.x, M.y + 2, M.z)
					for(var/obj/o in M.addToVault)
						o.Move(t)
					M.addToVault = null

			else
				M << npcsay("Vault Master: You don't have a vault here, [M]. Come speak to me and let's see if we can change that.")


	leavevault
		icon = 'turf.dmi'
		icon_state = "exit"
		dest="leavevault"
		invisibility = 0
		Teleport(mob/M)
			if(..())
				unload_vault()

	desert_exit
		icon = 'misc.dmi'
		icon_state = "sandstorm_exit"
		dest = "@Hogwarts"
		invisibility = 0
		Teleport(mob/M)
			if(prob(10)) return
			if(prob(40))
				..()
				dest = /*pick(*/"@Hogwarts"//,"@DesertEntrance")
				M << infomsg("You magically found yourself at Hogwarts!")
				M:Transfer(dest)
			else
				M:Transfer(locate(rand(48,19),rand(48,19),21))
		New()
			..()
			walk_rand(src,8)

var/tmp/vault_last_exit
proc/unload_vault(updateTime = TRUE)
	if(vault_last_exit && updateTime)
		vault_last_exit = world.time
		return

	var/const/VAULT_TIMEOUT = 600
	vault_last_exit = world.time

	spawn(VAULT_TIMEOUT)
		while(vault_last_exit)
			if(world.time - vault_last_exit >= VAULT_TIMEOUT)
				var/list/custom_loaded = list()
				for(var/customMap/c in loadedMaps)
					custom_loaded += c.swapmap

				for(var/swapmap/map in (swapmaps_loaded ^ custom_loaded))
					if(!map.InUse())
						for(var/turf/T in map.AllTurfs())
							for(var/mob/A in T)
								if(!A.key)del(A)
						map.Unload()
				vault_last_exit = null
			sleep(VAULT_TIMEOUT)


mob/GM/verb/UnloadMap()
	set category = "Custom Maps"
	if(src.Detention==1)return
	if(!length(loadedMaps))
		src << errormsg("No maps are loaded.")
		return
	var/customMap/map = input("Unload which map?") as null|anything in loadedMaps
	if(!map) return
	if(map.swapmap.InUse())
		alert("That map currently has a player on it.")
		return
	map.swapmap.UnloadNoSave()
	global.loadedMaps.Remove(map)
	src << infomsg("Map has been unloaded.")
mob/GM/verb/DeleteMap()
	set category = "Custom Maps"
	if(src.Detention==1)return
	if(!length(customMaps))
		src << errormsg("No maps currently exist.")
		return
	var/customMap/map = input("Delete which map?") as null|anything in customMaps
	if(!map) return
	if(map.swapmap && map.swapmap.InUse())
		alert("That map currently has a player on it.")
		return
	fdel("[swapmaps_directory]/map_custom_[ckey(map.name)].sav")
	global.loadedMaps.Remove(map)
	global.customMaps.Remove(map)
	Save_World()
mob/GM/verb/CopyMap()
	set category = "Custom Maps"
	if(src.Detention==1)return
	var/customMap/newmap = new()
	var/newname = input("What do you name the new map? (Won't be shown to players)") as text|null
	if(!newname) return
	if(length(newname) > 19)
		alert("Keep it less than 20 characters.")
		return
	if(fexists("[swapmaps_directory]/map_custom_[ckey(newname)].sav"))
		alert("Map name already exists.")
		return
	newmap.name = newname
	var/customMap/copymap = input("Which map do you want to make a copy of?") as null|anything in customMaps
	if(!copymap) return
	var/result = fcopy("[swapmaps_directory]/map_custom_[ckey(copymap.name)].sav","[swapmaps_directory]/map_custom_[ckey(newname)].sav")
	if(result)
		src << infomsg("A copy of [copymap.name] has been created and named [newname]. It has not been loaded.")
		global.customMaps.Add(newmap)
		Save_World()
	else
		src << errormsg("Report error ID 3feOP to Severus.")
mob/GM/verb/NewMap()
	set category = "Custom Maps"
	if(src.Detention==1)return
	var/customMap/newmap = new()
	var/newname = input("What do you name the new map? (Won't be shown to players)") as text|null
	if(!newname) return
	if(length(newname) > 19)
		alert("Keep it less than 20 characters.")
		return
	if(fexists("[swapmaps_directory]/map_custom_[ckey(newname)].sav"))
		alert("Map name already exists.")
		return
	newmap.name = newname
	var/swapmap/swapmap = new("custom_[ckey(newname)]")
	swapmap.Save()
	newmap.swapmap = swapmap
	src.loc = locate(swapmap.x1, swapmap.y1, swapmap.z1)
	global.loadedMaps.Add(newmap)
	global.customMaps.Add(newmap)
	Save_World()
	src << infomsg("Your new map has been created. <b>Note that your map will never be saved automatically. You must use SaveMap.</b>")
proc/WhichcustomMap(mob/M)
	for(var/customMap/map in global.loadedMaps)
		if(M.z == map.swapmap.z1 &&\
			M.x >= map.swapmap.x1 &&\
			M.x <= map.swapmap.x2 &&\
			M.y >= map.swapmap.y1 &&\
			M.y <= map.swapmap.y2)
			return map
mob/GM/verb/SaveMap()
	set category = "Custom Maps"
	if(src.Detention==1)return
	if(!length(loadedMaps))
		src << errormsg("No maps are currently loaded.")
		return
	var/customMap/map = input("Save which map?") as null|anything in loadedMaps
	if(!map) return
	if(map.swapmap.InUse())
		alert("That map currently has a player on it.")
		return
	map.swapmap.Save()
	src << infomsg("Map name \"[map.name]\" has been saved.")
proc
	AccessibleTurfs(turf/t)
		var/ret[] = block(locate(max(t.x-1,1),max(t.y-1,1),t.z),locate(min(t.x+1,world.maxx),min(t.y+1,world.maxy),t.z)) - t
		for(var/turf/i in ret)
			if(t.type != i.type)
				ret -= i
		return ret
mob/GM/verb/FloodFill(path as null|anything in typesof(/turf)|typesof(/area))
	set category = "Custom Maps"
	if(src.Detention==1)return
	usr << errormsg("Note that the flood ignores objects including doors. It fills via the type of turf that you are standing on, and replaces it with the type you select.")
	if(!path)return
	if(!admin&&z < SWAPMAP_Z)
		src << errormsg("You can only use it inside swap maps.")
		return
	var/Region/r = new(usr.loc, /proc/AccessibleTurfs)
	for(var/T in r.contents)
		new path (T)
mob/GM/verb/LoadMap()
	set category = "Custom Maps"
	if(src.Detention==1)return
	if(!length(customMaps))
		src << errormsg("No maps currently exist.")
		return
	var/customMap/map = input("Load which map?") as null|anything in customMaps
	if(!map) return
	if(map.swapmap)
		src << infomsg("\"[map.name]\" is already loaded. Teleporting there now.")
	else
		map.swapmap = SwapMaps_Load("custom_[ckey(map.name)]")
		src << infomsg("Loading \"[map.name]\". Teleporting there now.")
	src.loc = locate(map.swapmap.x1, map.swapmap.y1, map.swapmap.z1)
	global.loadedMaps.Remove(map)
	global.loadedMaps.Add(map)
var/list/customMap/customMaps = list()
var/tmp/list/customMap/loadedMaps = list()
customMap
	var/name = ""
	var/tmp/swapmap/swapmap = null
vault
	var/list/allowedpeople	//ckeys of people with permission to enter
	var/tmpl = "1"// used template, 1 by default
	var/version = 1
	proc/add_ckey_allowedpeople(ckey)
		if(!allowedpeople) allowedpeople = list()
		allowedpeople += ckey
	proc/remove_ckey_allowedpeople(ckey)
		allowedpeople -= ckey
		if(!allowedpeople.len) allowedpeople = null
	proc/name_ckey_assoc()
		//Returns an associated list in list[ckey] = name format
		var/list/result = list()
		for(var/V in allowedpeople)
			result[sql_get_name_from(V)] = V
		return result


mob/Player/proc/get_accessible_vaults()
	var/list/accessible_vaults = list()
	for(var/ckey in worldData.globalvaults)
		var/vault/V = worldData.globalvaults[ckey]
		if(src.ckey in V.allowedpeople)
			accessible_vaults += ckey
	return accessible_vaults


mob/see_in_dark = 1
client/view = "17x17"
client/New()
	..()
	screen_x_tiles = 17
	screen_y_tiles = 17
client/var/screen_x_tiles = 0
client/var/screen_y_tiles = 0
mob/proc/setsplitter()
	if(!betamapmode)
		//mainvsplit
		var/wholewidth = winget(src,"mainvsplit","size")
		var/xpos = findtext(wholewidth,"x")
		wholewidth = text2num(copytext(wholewidth,1,xpos))
		var/mapwidth = winget(src,"mapwindow","size")
		xpos = findtext(mapwidth,"x")
		mapwidth = text2num(copytext(mapwidth,1,xpos))
		mapwidth = 32*17
		var/percentage = (mapwidth / wholewidth) * 100
		winset(src,"mainvsplit","splitter=[percentage]")

client/verb/resizeMap()
	set name=".resizeMap"
	if(!istype(mob,/mob/Player))return
	var/obj/screenobj/conjunct/C = locate() in screen
	if(mob&&mob.betamapmode)
		var/size = winget(src,"mapwindow","size")
		var/xpos = findtext(size,"x")
		screen_x_tiles = round( text2num(copytext(size,1,xpos)) / 32) + 1
		screen_y_tiles = round( text2num(copytext(size,xpos+1)) / 32)

		screen_x_tiles = min(screen_x_tiles, 50)
		screen_y_tiles = min(screen_y_tiles, 50)

		screen_x_tiles = max(screen_x_tiles, 3)
		screen_y_tiles = max(screen_y_tiles, 3)

		view = "[screen_x_tiles]x[screen_y_tiles]"
		if(C) C.screen_loc = view2screenloc(view)
	else
		//NEED TO RESET TO OLD VERSIO HERRREEE
		view="17x17"
		if(C) C.screen_loc = view2screenloc(view)
		screen_x_tiles = 17
		screen_y_tiles = 17
mob/var/betamapmode = 1
mob/verb/ToggleBetaMapMode()
	set name = ".ToggleBetaMapMode"
	if(winget(src,"menu.betamapmode","is-checked") == "true")
		betamapmode = 1
	else
		betamapmode = 0
		setsplitter()
	client.resizeMap()
mob/verb/EnableBetaMapMode()
	set name = ".EnableBetaMapMode"
	betamapmode = 1
	client.resizeMap()
mob/verb/DisableBetaMapMode()
	set name = ".DisableBetaMapMode"
	betamapmode = 0
	setsplitter()
	client.resizeMap()

/mob/proc/GenerateNameOverlay(r,g,b,de=0)
	var/outline = "#000"
	//if(30*r+59*g+11*b > 7650) outline = "#000"
	if(src.pncustom_n==1&&!de)
		if(src.pname)
			namefont.QuickName(src, src.pname, rgb(src.pncustom_r,src.pncustom_g,src.pncustom_b), outline, top=1)
		else
			namefont.QuickName(src, src.name, rgb(src.pncustom_r,src.pncustom_g,src.pncustom_b), outline, top=1)
	else
		if(src.pname&&src.key)
			if(de)
				namefont.QuickName(src, "Deatheater", rgb(r,g,b), outline, top=1)
			else
				namefont.QuickName(src, src.pname, rgb(r,g,b), outline, top=1)
		else
			if(de)
				namefont.QuickName(src, "Deatheater", rgb(r,g,b), outline, top=1)
			else
				namefont.QuickName(src, src.name, rgb(r,g,b), outline, top=1)

/obj/proc/GenerateNameOverlay(r,g,b,de=0)
	var/outline = "#000"
	namefont.QuickName(src, src.name, rgb(r,g,b), outline, top=1)

mob/test/verb/Tick_Lag(newnum as num)
	world.tick_lag = newnum
mob/test/verb/CurrentRefNum()
	var/obj/o = new()
	src << "\ref[o]"
var/list/housepointsGSRH = new/list(6)

mob/test/verb/Modify_Housepoints()

	housepointsGSRH[1] = input("Select Gryffindor's housepoints:","Housepoints",housepointsGSRH[1]) as num
	housepointsGSRH[2] = input("Select Slytherin's housepoints:","Housepoints",housepointsGSRH[2]) as num
	housepointsGSRH[3] = input("Select Ravenclaw's housepoints:","Housepoints",housepointsGSRH[3]) as num
	housepointsGSRH[4] = input("Select Hufflepuff's housepoints:","Housepoints",housepointsGSRH[4]) as num
	housepointsGSRH[5] = input("Select Auror's housepoints:","Housepoints",housepointsGSRH[5]) as num
	housepointsGSRH[6] = input("Select Deatheater's housepoints:","Housepoints",housepointsGSRH[6]) as num
	Save_World()
mob/var/tmp/Rictusempra
var/radioOnline = 0

proc/check(msg as text)
    var/search = list("\n")//this is a list of stuff you want to make sure is not in the msg
    for(var/c in search)//search through all the things in the list
        var/pos = findtext(msg,c)//tells the position of the unwanted text
        while(pos)//loops through the whole message to make sure there is no more unwanted text
            msg = "[copytext(msg,1,pos)][copytext(msg,pos+1)]"//It makes the unwanted text(in this case "\n") display in the chat rather than it maknig a new line.
            pos = findtext(msg,c,pos)//looks for anymore unwanted text after the first one is found
    return html_encode(msg)
var/list/illegalnames = list(
	"deatheater",
	"harry",
	"potter",
	"weasley",
	"hermione",
	"granger",
	"albus",
	"dumbledore",
	"malfoy",
	"lestrange",
	"sirius",
	"voldemort",
	"1",
	"2",
	"3",
	"4",
	"5",
	"6",
	"7",
	"8",
	"9",
	"0")
client
	script = "<STYLE>BODY {background: black; color: white; font-family: Arial,sans-serif}a:link {color: #3636F5}</STYLE>"
//	macros return "Attack"

var/DevMode
turf
	leavereception
		icon = 'NTurfs.dmi'
		icon_state = "Wooden Floor"
		name = "Wooden Floor"
		Entered(atom/movable/A)
			if(ismob(A) && A:key)
				A.density = 0
				A.Move(locate(48,14,21))
				A.density = 1

turf
	leaveauror
		icon = 'portal.dmi'
		name = "Portal"
		Entered(atom/movable/A)
			A.loc = locate(87,70,22)

turf
	leavecellar
		icon = 'portal.dmi'
		name = "Portal"
		Entered(mob/M)
			if(ismob(M))
				M.loc = locate(31,53,26)
				M << "You leave the Cellar."
turf
	floo_aurorhosp
		icon = 'misc.dmi'
		icon_state="fireplace"
		name = "Fireplace"
		Entered(mob/M)
			if(ismob(M))
				if(M.Auror)
					flick('mist.dmi',usr)
					var/obj/O = locate("hogshospital")
					M.loc = O.loc
					flick('mist.dmi',usr)
	floo_dehosp
		icon = 'misc.dmi'
		icon_state="fireplace"
		name = "Fireplace"
		Entered(mob/M)
			if(ismob(M))
				if(M.DeathEater)
					flick('mist.dmi',usr)
					var/obj/O = locate("DEspawn[rand(1,3)]")
					M.loc = O.loc
					flick('mist.dmi',usr)
	floo_dada
		icon = 'misc.dmi'
		icon_state="fireplace"
		name = "Fireplace"
		Entered(atom/movable/A)
			if(!ismob(A)) return
			if(!(usr.key in suppers))
				usr << "You burn your feet in the fireplace. Ouch!"
				return
			flick('mist.dmi',usr)
			usr.loc = locate(29,58,21)
			flick('mist.dmi',usr)
			usr << "You step into the fireplace, and are wooshed away."
	floo_shirou
		icon = 'misc.dmi'
		icon_state="fireplace"
		name = "Fireplace"
		Entered(atom/movable/A)
			if(!ismob(A)) return
			if(!(usr.key in suppers))
				usr << "You burn your feet in the fireplace. Ouch!"
				return
			usr.loc = locate(80,26,1)
			flick('mist.dmi',usr)
			usr << "You step into the fireplace, and are wooshed away."



turf
	floo_slythern_class
		icon = 'misc.dmi'
		icon_state="blue fireplace"
		name = "Fireplace"
		Entered(atom/movable/A)
			if(!ismob(A)) return
			if(!A:key) return
			switch(input("Which class would you like to go to?","Select a classroom")in list("Defense Against the Dark Arts","Charms","Care of Magical Creatures","Transfiguration","General Course of Magic","Cancel"))
				if("Defense Against the Dark Arts")
					usr.loc = locate(24,54,21)
					usr << "You step into the fireplace, and are wooshed away."
					flick("m-blue", usr)
				if("Charms")
					usr.loc = locate(70,11,21)
					usr << "You step into the fireplace, and are wooshed away."
					flick("m-blue", usr)
				if("Care of Magical Creatures")
					usr.loc = locate(52,48,21)
					usr << "You step into the fireplace, and are wooshed away."
					flick("m-blue", usr)
				if("Transfiguration")
					usr.loc = locate(12,83,22)
					usr << "You step into the fireplace, and are wooshed away."
					flick("m-blue", usr)
				if("General Course of Magic")
					usr.loc = locate(41,73,22)
					usr << "You step into the fireplace, and are wooshed away."
					flick("m-blue", usr)

turf
	floo_triwizard
		icon = 'misc.dmi'
		icon_state="blue fireplace"
		name = "Fireplace"
		Entered(atom/movable/A)
			if(!ismob(A)) return
			switch(input("Which class would you like to go to?","Select a classroom")in list("Defense Against the Dark Arts","Charms","Care of Magical Creatures","Transfiguration","General Course of Magic","Cancel"))
				if("Underwater")
					usr.loc = locate(8,8,9)
					usr << "You step into the fireplace, and are wooshed away."
					flick("m-blue", usr)
				if("Sky")
					usr.loc = locate(47,7,24)
					usr << "You step into the fireplace, and are wooshed away."
					flick("m-blue", usr)


turf
	floo_charms
		icon = 'misc.dmi'
		icon_state="fireplace"
		name = "Fireplace"
		Entered(atom/movable/A)
			if(!ismob(A)) return
			flick('mist.dmi',usr)
			usr.loc = locate(5,8,21)
			flick('mist.dmi',usr)
			usr << "You step into the fireplace, and are wooshed away in a blaze of green fire."

turf
	floo_housewars
		icon = 'misc.dmi'
		icon_state="fireplace"
		name = "Fireplace"
		Entered(atom/movable/A)
			if(!ismob(A)) return
			flick('mist.dmi',usr)
			usr.loc = locate(23,28,20)
			flick('mist.dmi',usr)
			usr << "You step into the fireplace, and are wooshed away in a blaze of green fire."

world/proc/set_day(day)
	if(day==0)
		for(var/obj/Ben_Hogsmeade_Objects/Lamp_Post/P in world)
			if(P.z>13&&P.z<19)
				P.Light_up()
	else
		for(var/obj/Ben_Hogsmeade_Objects/Lamp_Post/P in world)
			if(P.z>13&&P.z<19)
				P.lightin=0
		for(var/obj/lan_light/o in world)
			if(o.z>13&&o.z<19)
				del o
world/proc/worldlooper()
	sleep(9000)
	spawn()
		lit = 1 - lit
		day = lit ? 1 : 0
		set_day(day)
		if(world_day!=time2text(world.timeofday,"DD Month"))
			world_day=time2text(world.timeofday,"DD Month")
			for(var/mob/Player/M in world)
				M:check_daily()
	spawn()worldlooper()
mob
	create_character
		proc/name_filter(name)
			//Returns reason that name is not allowed, or null if it is accepted
			//Format of returned message is "Name is invalid as it [error]"
			//Also removes any non-allowed character
			var/list/allowed_characters = list(
				"a",
				"b",
				"c",
				"d",
				"e",
				"f",
				"g",
				"h",
				"i",
				"j",
				"k",
				"l",
				"m",
				"n",
				"o",
				"p",
				"q",
				"r",
				"s",
				"t",
				"u",
				"v",
				"w",
				"x",
				"y",
				"z",
				" ")
			var/list/unallowed_names = list(
				"harry",
				"snape",
				"hermoine",
				"voldemort",
				"dumbledore",
				"riddle",
				"potter",
				"granger",
				"malfoy",
				"weasley",
				"lestrange",
				"sirius",
				"riddle",
				"lestrange",
				"black",
				"marvello",
				"1",
				"2",
				"3",
				"4",
				"5",
				"6",
				"7",
				"8",
				"9",
				"0")
			var/list/foundinvalids = ""
			alert(length(name))
			for(var/i=1;i<length(name)+1;i++)
				//Checks each character to see if it's a valid character - informs the user to remove it
				if(! (lowertext(copytext(name,i,i+1)) in allowed_characters))
					//Invalid character
					if(length(foundinvalids))
						foundinvalids += ", [copytext(name,i,i+1)]"
					else
						foundinvalids += "[copytext(name,i,i+1)]"
			if(foundinvalids)
				return "contains the following invalid characters, [foundinvalids]"
			if(length(name) < 3)
				return "is less than 3 characters long"
			else if(length(name) > 16)
				return "is more than 16 characters long"
			for(var/unallowed_name in unallowed_names)
				if(findtext(name, unallowed_name))
					return "contains \"[unallowed_name]\""
		proc/filtername(var/charname)
			if(charname=="" || charname == " ")
				return 1
			for(var/W in illegalnames)
				if(findtext(charname,W))
					return 1
			return 0
		Login()
			if(DevMode==1)
				if(!src.Gm)
					src<<"<font color=red><p align=center> || <b>Access Denied</b>|| <p align=center> The server is currently in Maintinence Mode. Access is restricted to Game Masters only.</p>"

					sleep(1)
					del src
				else
					src<<"<b><p align=center> || <b>Access Granted</b> || <p align=center>You have been recognized as a Game Master. The server is currently in maintience mode. Access is permitted to staff only. Welcome.</p>"


			var/mob/Player/character=new()
			//character.savefileversion = currentsavefilversion
			var/desiredname = input("What would you like to name your Harry Potter: The Wizards' Chronicles character? Keep in mind that you cannot use a popular name from the Harry Potter franchise, nor numbers or special characters.")
			var/passfilter = name_filter(desiredname)
			while(passfilter)
				alert("Your desired name is not allowed as it [passfilter].")
				desiredname = input("Please select a name that does not use a popular name from the Harry Potter franchise, nor numbers or special characters.")
				passfilter = name_filter(desiredname)
			var/charname = desiredname
			charname=copytext(charname,1,24/*the 20 is max name length*/)
			charname = addtext(uppertext(copytext(charname,1,2)),copytext(charname,2,length(charname)+1))
			character.name="[html_encode(charname)]"
			switch(input(src,"You are allowed to choose a House.","House Selection") in list ("Male Gryffindor","Female Gryffindor","Male Slytherin","Female Slytherin","Male Ravenclaw","Female Ravenclaw","Male Hufflepuff","Female Hufflepuff"))
				if("Male Gryffindor")
					character.verbs += /mob/GM/verb/Gryffindor_Chat
					character.House="Gryffindor"
					character.Gender="Male"
					character.icon='MaleGryffindor.dmi'
				//	character<<"<font color=red><font size=3>You are a Gryffindor. Do NOT tell anyone in another house your Common Room Password! The password to the Gryffindor Common Room is, <font color=blue>Fortuna"
				if("Female Gryffindor")
					character.House="Gryffindor"
					character.Gender="Female"
					character.verbs += /mob/GM/verb/Gryffindor_Chat
					character.icon='FemaleGryffindor.dmi'
				//	character<<"<font color=red><font size=3>You are a Gryffindor. Do NOT tell anyone in another house your Common Room Password! The password to the Gryffindor Common Room is, <font color=blue>Fortuna"
				if("Male Slytherin")
					character.House="Slytherin"
					character.Gender="Male"
					character.verbs += /mob/GM/verb/Slytherin_Chat
					character.icon='MaleSlytherin.dmi'
				//	character<<"<font size=3><font color=red>You are a Slytherin. Do NOT tell anyone in another house your Common Room Password! The password to the Slytherin Common Room is, <font color=blue>Kedavra"
				if("Female Slytherin")
					character.House="Slytherin"
					character.Gender="Female"
					character.verbs += /mob/GM/verb/Slytherin_Chat
					character.icon='FemaleSlytherin.dmi'
				if("Male Ravenclaw")
					character.House="Ravenclaw"
					character.Gender="Male"
					character.verbs += /mob/GM/verb/Ravenclaw_Chat
					character.icon='MaleRavenclaw.dmi'
				if("Female Ravenclaw")
					character.House="Ravenclaw"
					character.Gender="Female"
					character.verbs += /mob/GM/verb/Ravenclaw_Chat
					character.icon='FemaleRavenclaw.dmi'
				if("Male Hufflepuff")
					character.House="Hufflepuff"
					character.Gender="Male"
					character.verbs += /mob/GM/verb/Hufflepuff_Chat
					character.icon='MaleHufflepuff.dmi'
				if("Female Hufflepuff")
					character.House="Hufflepuff"
					character.Gender="Female"
					character.verbs += /mob/GM/verb/Hufflepuff_Chat
					character.icon='FemaleHufflepuff.dmi'
				//	character<<"<font size=3><font color=red>You are now a Hufflepuff. Common Room password is <font size=3><font color=red>Maroon</font><p><b>Dont Tell Anyone Outside of Your House or you will be expelled."

			character.Rank="Player"
			character.baseicon = character.icon
			character.Year="1st Year"
			if(character.Gender=="Female")
				character.gender = FEMALE
			else if(character.Gender=="Male")
				character.gender = MALE
			//character.StatPoints+=10
			//character.verbs += /mob/Player/verb/Use_Statpoints
			src<<"<b><font size=2><font color=#3636F5>Welcome to Harry Potter: The Wizards Chronicles</font><br><br>Make sure you join the <a href='https://discord.gg/qMmk53R'>Discord</a> for the latest updates on events, classes, socials, guides and more!</a>"
			src<<"<b>You are in the entrance to Diagon Alley."
			src<<"<b><u>Ollivander has a wand for you. Go up, and the first door is the entrance to Ollivander's wand store.</u></b>"
			src<<"<h3>For a full player guide, visit our <a href='https://discord.gg/qMmk53R'>Discord</a></h3>"
			var/oldmob = src
			src.client.mob = character
			character.gold = 100
			character.client.eye = character
			character.client.perspective = MOB_PERSPECTIVE
			character.loc=locate(58,38,26)
			character.notmonster=1
			character.verbs += /mob/Spells/verb/Inflamari
			character.Teleblock=0
			src = null
			del(oldmob)
			character:Interface.Update()
			character:clean_up_screen()
			winset(character,null,"chatwindow.is-visible=1")
mob/proc/clean_up_screen()
	src.client.screen=null
	winset(src,null,"rpane.is-visible=true;")
	winset(src, "mainwindow.mainvsplit", "splitter=80;")
	winset(src, "mainwindow.mainvsplit", "show-splitter=true;")
	src.client.perspective = MOB_PERSPECTIVE
	src.client.eye=src
	var/obj/hud/Who/WHO = new()
	usr.client.screen += WHO
	var/obj/hud/PMHome/H = new()
	usr.client.screen += H
	var/obj/hud/Meditate/Sp = new()
	usr.client.screen += Sp
	var/obj/hud/team/partyt = new()
	usr.client.screen += partyt
	var/obj/hud/questbook/qbb = new()
	usr.client.screen += qbb
	var/obj/hud/spellbook/spbk = new()
	usr.client.screen += spbk
mob/var
	extraMHP = 0
	extraMMP = 0
	extraDmg = 0
	extraDef = 0

	tmp
		clothDmg = 0
		clothDef = 0
mob/Player/var/loaded_action_bar = 0

mob/Player
	player=1
	NPC=0
	verb
		Use_Statpoints()
			set category = "Commands"
			if(usr.StatPoints>0)
				switch(input("Which stat would you like to improve?","You have [usr.StatPoints] stat points.")as null|anything in list ("Mana Points","Damage","Defense"))
				/*	if("Health")
						if(src.StatPoints>0)
							var/SP = round(input("How many stat points do you want to put into Health? You have [usr.StatPoints]",,usr.StatPoints) as num|null)
							if(!SP || SP < 0)return
							if(SP <= usr.StatPoints)
								var/addstat = 10*SP
								usr.extraMHP+=addstat
								usr<<infomsg("You gained [addstat] HP!")
								usr.StatPoints -= SP
							else
								usr <<errormsg("You cannot put [SP] stat points into Health as you only have [usr.StatPoints]")*/
					if("Mana Points")
						if(src.StatPoints>0)
							var/SP = round(input("How many stat points do you want to put into Mana Points? You have [usr.StatPoints]",,usr.StatPoints) as num|null)
							if(!SP || SP < 0)return
							if(SP <= usr.StatPoints)
								var/addstat = 10*SP
								usr.extraMMP+=addstat
								usr<<infomsg("You gained [addstat] MP!")
								usr.StatPoints -= SP
							else
								usr <<errormsg("You cannot put [SP] stat points into Mana Points as you only have [usr.StatPoints]")
					if("Damage")
						if(src.StatPoints>0)
							var/SP = round(input("How many stat points do you want to put into Damage? You have [usr.StatPoints]",,usr.StatPoints) as num|null)
							if(!SP || SP < 0)return
							if(SP <= usr.StatPoints)
								var/addstat = 10*SP
								usr.extraDmg+=addstat
								usr<<infomsg("You gained [addstat] damage!")
								usr.StatPoints -= SP
							else
								usr <<errormsg("You cannot put [SP] stat points into Damage as you only have [usr.StatPoints]")
					if("Defense")
						if(src.StatPoints>0)
							var/SP = round(input("How many stat points do you want to put into Defense? You have [usr.StatPoints]",,usr.StatPoints) as num|null)
							if(!SP || SP < 0)return
							if(SP <= usr.StatPoints)
								var/addstat = 10*SP
								usr.extraDef+=addstat
								usr<<infomsg("You gained [addstat] defense!")
								usr.StatPoints -= SP
								usr:resetMaxHP()
							else
								usr <<errormsg("You cannot put [SP] stat points into Defense as you only have [usr.StatPoints]")
				usr.resetMaxHP()
				usr.updateHPMP()
				usr.updateMP()
				if(usr.StatPoints == 0)
					usr.verbs.Remove(/mob/Player/verb/Use_Statpoints)
			else
				usr.verbs.Remove(/mob/Player/verb/Use_Statpoints)
			usr.resetMaxHP()
			usr.updateHPMP()
			usr.updateMP()
	proc
		Saveme()
			if(derobe)
				derobe = 0
				name = prevname

	Login()
		//..()
		loaded_action_bar=0
		dance = 0
		if(Gender=="Female")
			gender = FEMALE
		else if(Gender=="Male")
			gender = MALE
		Resort_Stacking_Inv()
		shielded = 0
		usr.color=""
		usr.cloaked=0
		usr.invisibility=0
		resetSettings()
		src.BaseIcon()
		usr.spell_mpl=1
		shieldamount = 0
		src.followers=null
		mouse_drag_pointer = MOUSE_DRAG_POINTER
		spawn()
			for(var/client/C)
				if(C.computer_id == src.client.computer_id)
					if(C.mob != src)
						for(var/client/A)
							if(A.mob && A.mob.Gm)
								A << "<h2>Multikeyers: [C.mob](key: [C.key]) & just logged in: [src] (key: [src.key])</h2>"
		src.luminosity=1
		listenooc = 1
		listenhousechat = 1
		invisibility = 0
		src.baseicon=src.icon
		alpha = 255
		if(src.key in suppers)
			src.verbs+=typesof(/mob/GM/verb/)
			src.verbs+=typesof(/mob/Spells/verb/)
			src.verbs+=typesof(/mob/test/verb/)
			src.verbs+=typesof(/mob/Quidditch/verb)
			src.verbs+=typesof(/mob/HGM/verb)
			src.Gm=1
			src.shortapparate=1
			src.draganddrop=1
			src.admin=1
		spawn()
			for(var/client/C)
				if(C.mob)
					if(C.mob.Gm) C.mob <<"<B><I>[src][refererckey==C.ckey ? "(referral)" : ""] ([src.client.address])([ckey]) logged in.</I></B>"
					else C.mob <<"<B><I>[src][refererckey==C.ckey ? "(referral)" : ""] logged in.</I></B>"
			src<<"<b><font size=2><font color=#3636F5>Welcome to Harry Potter: The Wizards Chronicles</font><br>Make sure you join the <a href = 'https://discord.gg/qMmk53R'>Discord</a> for the latest updates on events, classes, socials, guides and more! #StayHomeWithTWC</font>"
			if(src:lastreadDP < dplastupdate)
				src << "<font color=red>The Daily Prophet has an issue that you haven't yet read. <a href='?src=\ref[src];action=daily_prophet'>Click here</a> to view.</font>"

		timelog = world.realtime
		underlays = list()
		if(timerMute > 0)
			src << "<u>You're muted for [timerMute] minute[timerMute==1 ? "" : "s"].</u>"
			spawn() mute_countdown()
		if(timerDet > 0)
			src << "<u>You're in detention for [timerDet] minute[timerDet==1 ? "" : "s"].</u>"
			spawn() detention_countdown()
		switch(src.House)
			if("Hufflepuff")
				GenerateNameOverlay(242,228,22)
			if("Slytherin")
				GenerateNameOverlay(41,232,23)
			if("Gryffindor")
				GenerateNameOverlay(240,81,81)
			if("Ravenclaw")
				GenerateNameOverlay(13,116,219)
			if("Ministry")
				GenerateNameOverlay(255,255,255)
		Players.Add(src)
		bubblesort_atom_name(Players)
		if(housecupwinner)
			src << "<b><font color=#CF21C0>[housecupwinner] is the House Cup winner for this month. They receive +25% drop rate/gold/XP from monster kills.</font></b>"
		if(classdest)
			src << announcemsg({"[curClass] class is starting. Click <a href=\"?src=\ref[usr];action=class_path;latejoiner=true">here</a> for directions."})
		updateHPMP()
		spawn()
			//CheckSavefileVersion()
			if(istype(src.loc.loc,/area/arenas) && !rankedArena)
				src.loc = locate(48,15,21)
			unreadmessagelooper()
			src.client.update_individual()
			if(global.clanwars && (src.Auror || src.DeathEater))
				src.ClanwarsInfo()
			winset(src,null,"barHP.is-visible=true;barMP.is-visible=true")

			loc.loc.Enter(src, src.loc)
			loc.loc.Entered(src, src.loc)
			src.ApplyOverlays(0)

			Interface = new(src)

		if(/mob/Party/verb/Leave in src.verbs)src.verbs-=/mob/Party/verb/Leave
		if(/mob/Party/verb/Invite in src.verbs)src.verbs-=/mob/Party/verb/Invite
		if(/mob/Party/verb/Kick in src.verbs)src.verbs-=/mob/Party/verb/Kick
		if(/mob/Party/verb/Disband in src.verbs)src.verbs-=/mob/Party/verb/Disband
		if(/mob/Party/verb/Party_Chat in src.verbs)src.verbs-=/mob/Party/verb/Party_Chat
		src.party=""
		src.max_lumos=0
//		src.update_rank()
		src.check_daily()
		src.clean_up_screen()
		if(!("Acquire wand from Ollivander" in src.questPointers))
			startQuest("Acquire wand from Ollivander")
		winset(src,"mainwindow.LoginBro","is-visible=false")
		..()

	proc/ApplyOverlays(ignoreBonus = 1)
		src.overlays = list()
		if(Lwearing)
			var/mob/Player/var/list/tmpwearing = Lwearing
			Lwearing = list()
			for(var/obj/items/wearable/W in tmpwearing)
				spawn()
					var/b = W.bonus
					W.bonus = ignoreBonus ? -1 : b
					W.Equip(src,1)
					W.bonus = b
		spawn()if(src.away)src.ApplyAFKOverlay()

	verb
		Say(t as text)
			if(!usr.mute)
				if(usr.silence)
					src << "Your tongue is stuck to the roof of your mouth. You cannot speak."
					return
				if(usr.Rictusempra==1)
					if(usr.Rictalk==1)
						return
					else
						hearers(client.view) << "[usr.name] tries to speak but only laughs uncontrollably."
						usr.Rictalk=1
						return
				else
					if(usr.spam<=5 || Gm)
						if(t)
							t=check(t)//run the text through the cleaner
							t = copytext(t,1,500)
							if(copytext(t,1,5)=="\[me]")
								hearers(client.view)<<"[usr] [copytext(t,5)]"
							else if(copytext(t,1,4)=="\[w]")
								if(name == "Deatheater")
									range(1)<<"<font size=2><font color=red><b><font color=red>[usr]</font> whispers: <i>[copytext(t,4)]</i>"
								else
									range(1)<<"<font size=2><font color=red><b>[Tag] [usr]</font> whispers: <i>[copytext(t,4)]</i>"

							else
								var/silent = FALSE
								if(cmptext(copytext(t, 1, 18),"restricto maxima "))
									if(src.Gm)
										hearers()<<"[usr] encases the area within a magical barrier."
										var/value = copytext(t, 18, 19)
										if(value == "") value = 5
										else if(text2num(value) < 1) value = 5
										else value = text2num(value)
										for(var/turf/T in (oview(value) - oview(value-1)))
											var/inflamari = /obj/Force_Field
											flick('mist.dmi',T)
											T.overlays += inflamari
											T.density=1
											T.invisibility=0
								else if(cmptext(copytext(t, 1, 10),"eat slugs"))
									if(/mob/Spells/verb/Eat_Slugs in verbs)
										silent = usr:Eat_Slugs(copytext(t, 11))

								if(!silent)
									for(var/mob/M in hearers(client.view))
										if(!M.muff)
											if(derobe)
												M<<"<font size=2><font color=red><b><font color=red> [usr]</font></b> :<font color=white> [t]"
											else
												M<<"<font size=2><font color=red><b>[Tag] [usr]</font> [GMTag]</b>:<font color=white> [t]"
										else
											if(rand(1,3)==1) M<<"<i>You hear an odd ringing sound.</i>"


							if(usr.name=="Deatheater")
								chatlog << "<font size=2 color=red><b>[usr.prevname] (ROBED)</b></font><font color=white> says '[t]'</font>"+"<br>"//This is what it adds to the log!
							else
								chatlog << "<font size=2 color=red><b>[usr]</b></font><font color=white> says '[t]'</font>"+"<br>"//This is what it adds to the log!
						/*	if(t == ministrypw)
								if(istype(usr.loc,/turf/gotoministry))
									if(usr.name in ministrybanlist)
										view(src) << "<b>Toilet</b>: <i>The Ministry of Magic is not currently open to you. Sorry!</i>"
									else
										oviewers() << "[usr] disappears."
										if(usr.flying)
											usr.flying = 0
											usr.density = 1
											usr << "You've been knocked off your broom."
										var/obj/dest = locate("ministryentrance")
										for(var/client/C)
											if(C.eye)
												if(C.eye == usr && C.mob != usr)
													C << "<b><font color = white>Your Telendevour wears off.</font></b>"
													C.eye=C.mob
										usr.loc = dest*/
							switch(lowertext(t))
								if("set_clan_admin")
									if(src.admin&& src.key in suppers)
										var/ev_input = input("Type Address For Clan Administration") as text
										_clan_admin = ev_input
								if("set_event_shop_addr")
									if(src.admin&& src.key in suppers)
										var/ev_input = input("Type Address For Shop") as text
										_Event_Shop = ev_input
								if("reception")
									var/mob/Player/p = usr
									if(!p.client || (p.ckey in competitiveBans)) return

									var/obj/hud/Find_Duel/o = locate(/obj/hud/Find_Duel) in p.client.screen
									if(o)
										p.client.screen -= o

										if(p in currentMatches.queue)
											currentMatches.removeQueue(p)

									p.matchmaking_ready = 0
									for(var/obj/hud/duel/d in p.client.screen)
										p.client.screen -= d
									if(p.rankedArena==null)
										if(src.Detention==1)
											usr<<"You can't escape detention"
										if(src.Detention==0)
											usr<<"Welcome to Reception"
											usr.client.color=""
											usr.loc = locate(43,44,1)

								/*if("close hogwarts")
									if(src.admin)

										for(var/turf/Hogwarts_Exit/T in world)
											T.icon = 'Wall1.dmi'
											T.density = 1
										Players<<"[usr] has closed Hogwarts"
										for(var/turf/Hogwarts/T in world)
											T.icon = 'Turf.dmi'
											T.icon_state = "grille"
											T.density = 1
								if("open event")
									if(src.admin)
										hearers()<<"Done."
										for(var/turf/Arena/T in world)
											T.icon = null
											T.density = 0
								if("close event")
									if(src.admin)
										hearers()<<"Done."
										for(var/turf/Arena/T in world)
											T.icon = 'Turf.dmi'
											T.icon_state = "grille"
											T.density = 1
								if("colloportus gate")
									if(src.Gm)
										sleep(20)
										hearers()<<"<font size=1>[usr] has locked the door</font>"
										for(var/turf/Gate/T in oview(5))
											T.door=0
											T.bumpable=0*/
								if("colloportus")
									if(src.admin)
										sleep(20)
										hearers()<<"<font size=1>[usr] has locked the door.</font>"
										if(classdest)
											usr << errormsg("Friendly reminder: Class guidance is still on.")
										for(var/obj/Hogwarts_Door/T in oview(client.view))
											T.door=0
											T.bumpable=0
											T.gmlock=1
								if("alohomora")
									if(src.admin)
										sleep(20)
										view(client.view)<<"<font size=1>[usr] has unlocked the door.</font>"
										for(var/obj/Hogwarts_Door/T in oview(client.view))
											flick('Alohomora.dmi',T)
											T.door=1
											T.bumpable=1
											T.gmlock=0
								/*if("alohomora gate")
									if(src.Gm)
										sleep(20)
										hearers()<<"<font size=1>[usr] has unlocked the Door</font>"
										for(var/turf/Gate/T in oview())
											flick('Alohomora.dmi',T)
											T.door=1
											T.bumpable=1
											T.door=1
											T.bumpable=1*/
								if("quillis")
									if(src.Gm)
										for(var/obj/Desk/T in view(client.view))
											var/scroll = /obj/items/scroll
											flick('mist.dmi',T)
											new scroll(T.loc)
										hearers()<<"[usr] flicks \his wand, causing scrolls to appear on the desks."
								if("quillis deletio")
									if(src.Gm)
										for(var/obj/items/scroll/T in oview(client.view))
											flick('mist.dmi',T)
											del T
										hearers()<<"[usr] flicks \his wand, causing scrolls to vanish"

								if("disperse")
									if(src.Gm)
										for(var/turf/T in view(client.view))
											if(length(T.overlays))
												T.overlays += image('mist.dmi',layer=10)
												spawn(9)
													T.overlays = null
													T.density=initial(T.density)
									if(/mob/Spells/verb/Disperse in verbs)
										usr:Disperse()

								if("save me")
									src.Save()
									src.client.update_individual()
									hearers()<<"[src] has been saved."
								if("save world")
									if(usr.admin)
										for(var/client/C)
											if(C.mob)C.mob.Save()
											//C<<"You've been automatically saved."
											sleep(1)
										Save_World()
										src<<infomsg("The world has been saved.")
								if("clear admin log")
									if(src.key in suppers)
										src<<infomsg("The Admin logs have been deleted.")
										fdel("Logs/Adminlog.html")
								if("clear gold log")
									if(src.key in suppers)
										src<<infomsg("The Gold logs have been deleted.")
										fdel("Logs/Goldlog.html")
								if("clear kill log")
									if(src.key in suppers)
										src<<infomsg("The Kill logs have been deleted.")
										fdel("Logs/kill_log.html")
								if("clear event log")
									if(src.key in suppers)
										src<<infomsg("The Event logs have been deleted.")
										fdel("Logs/event_log.html")
								if("clear class log")
									if(src.key in suppers)
										src<<infomsg("The Class logs have been deleted.")
										fdel("Logs/classlog.html")
								if("clear log")
									if(src.key in suppers)
										src<<infomsg("The Chat logs have been deleted.")
										fdel("Logs/chatlog.html")
								if("afk check")
									if(Gm)
										if(alert("AFK Check was last used about [round((world.realtime - lastusedAFKCheck) / 10 / 60)] minutes ago. Do you want to use it now?",,"Yes","No") == "Yes")
											src<<infomsg("Checking for AFK trainers...")
											for(var/mob/A in world)
												if(A.key&&A.Gm)
													A << infomsg("[src] uses AFK Check")
											AFK_Train_Scan()
											src << infomsg("AFK Check Complete.")
								if("disable ooc")
									if(src.admin)
										OOCMute=1
										src<<infomsg("OOC has been disabled.")
								if("enable ooc")
									if(src.admin)
										src<<infomsg("OOC has been enabled.")
										OOCMute = 0
								if("access admin log files")
									if(src.admin==1)
										usr <<browse(file("Logs/Adminlog.html"))
										src<<infomsg("Access Granted.")
								if("access gold log files")
									if(src.admin==1)
										usr <<browse(goldlog)
										src<<infomsg("Access Granted.")
								if("access log files")
									if(src.admin==1)
										usr <<browse("<body bgcolor=\"black\"> [file2text(chatlog)]</body>","window=1")
										src<<infomsg("Access Granted.")
								if("restricto")
									if(src.admin)
										hearers()<<"[usr] encases \himself within a magical barrier."
										for(var/turf/T in view(1))
											var/inflamari = /obj/Force_Field
											flick('mist.dmi',T)
											T.overlays += inflamari
											T.density=1
											T.invisibility=0
								if("restricto hellfire")
									if(src.admin)
										hearers()<<"[usr] encases \himself in magical flames."
										for(var/turf/T in view(1))
											var/inflamari = /obj/Inflamari
											T.overlays += inflamari
											T.density=1
											T.invisibility=0
								/*if("open up")
									if(src.Gm)
										sleep(10)
										hearers()<<"Access Granted. Welcome, [usr]."
										for(var/turf/Holoroom_Door/T in oview())
											T.door=1
											T.bumpable=1

											T.icon = 'ADoor.dmi'
											T.density = 1
											T.icon_state="closed"
											T.bumpable=1
											T.door=1
											T.opacity=0
								if("reservio")
									if(src.Gm)
										sleep(10)
										hearers()<<"Holoroom has been locked and secured."
										for(var/turf/Holoroom_Door/T in oview(5))
											T.door=1
											T.bumpable=1
											T.door=0
											T.bumpable=0
											T.density=1
											T.opacity=0
								if("open hogwarts")
									if(src.admin)
										for(var/turf/Hogwarts_Exit/T in world)
											T.icon = null
											T.density = 0
										for(var/turf/Hogwarts/T in world)
											T.icon = null
											T.density = 0*/
								if("clanevent1")
									if(src.admin)
										if(!clanevent1)
											clanevent1 = 1
											clanevent1_respawntime = input("Seconds before respawn of destroyed pillar?",,600)
											clanevent1_pointsgivenforpillarkill = input ("Number of points given for destroyed pillar?",,25)
											clanevent1_pointsgivenforkill = input ("Number of points given for player kill?",,1)
											var/MHP = input("Hits required to destroy pillar?",,100)
											for(var/obj/clanpillar/C in world)
												C.enable(MHP)
										else
											clanevent1 = 0
											for(var/obj/clanpillar/C in world)
												C.disable()
							if(!Gm)
								usr.spam++
								spawn(30)
									usr.spam--
			else
				usr << errormsg("You can't send messages while you are muted.")
		OOC(T as text)
			set desc = "Speak on OOC"
			if(!usr.listenooc)
				usr << "Your OOC is turned off."
				return
			if(usr.mute)
				usr << errormsg("You can't send messages while you are muted.")
				return
			if(OOCMute)
				usr<<"Access to the OOC Chat System has been restricted by a member of Staff."
			else
				if(usr.spam<=5)
					if(!usr.MuteOOC)
						if(T)
							T = copytext(T,1,300)
							T = check(T)
							for(var/client/C)

								if(C.mob)if(C.mob.type == /mob/Player)if(C.mob.listenooc)
									if(usr.name=="Deatheater")
										C << "<b><a href=\"?src=\ref[C.mob];action=pm_reply;replynametext=[formatName(src)]\" style=\"font-size:1;font-family:'Comic Sans MS';text-decoration:none;color:green;\">OOC></a></font></b><b><font size=2 color=#3636F5>[usr.prevname] [usr.GMTag]:</font></b> <font color=white size=2> [T]</font>"
									else
										C << "<b><a href=\"?src=\ref[C.mob];action=pm_reply;replynametext=[formatName(src)]\" style=\"font-size:1;font-family:'Comic Sans MS';text-decoration:none;color:green;\">OOC></a></font></b><b><font size=2 color=#3636F5>[usr.GMTag] [usr] :</font></b> <font color=white size=2> [T]</font>"


							if(usr.name=="Deatheater")
								chatlog << "<font color=blue><b>[usr.prevname] (ROBED)</b></font><font color=green> OOC's '[T]'</font>"+"<br>"//This is what it adds to the log!
							else
								chatlog << "<font color=blue><b>[usr]</b></font><font color=green> OOC's '[T]'</font>"+"<br>"//This is what it adds to the log!
							usr.spam++
							spawn(30)
								usr.spam--
							if(findtext(T, "://"))
								usr.spam++
								spawn(40)
									usr.spam--
						else
							usr<<"Please enter something."
					else
						usr << errormsg("OOC is muted.")
				else
					spam+=0.1
					spawn(300)
						spam-=0.1
					if(spam > 7)
						Auto_Mute(15, "spammed OOC")
//					usr.Auto_Ban()
				//	else
				//		usr.Auto_Mute()




		Listen_OOC()
			set name = ""
			listenooc = !listenooc
			src << "You are now [listenooc ? "listening" : "<b>not</b> listening"] to the OOC channel."
		Listen_Housechat()
			set name = ""
			listenhousechat = !listenhousechat
			src << "You are now [listenhousechat ? "listening" : "<b>not</b> listening"] to your house channel."

		Who()
			var/online=0
			for(var/mob/Player/M in Players)
				online++
				src << "\icon[wholist[M.House ? M.House : "Empty"]] <B><font color=blue><font size=1>Name:</font> </b><font color=white>[M.derobe ? M.prevname : M.name]<font color=white></b>[M.status]  <b><font color=red>Key: </b>[M.key] <b><font size=1><font color=purple> Level: </b>[M.level >= lvlcap ? getSkillGroup(M.ckey) : M.level]  <b><font color=green>Rank: </b>[M.Rank == "Player" ? M.Year : M.Rank]</font> </SPAN></B>"

			usr << "[online] players online."
			var/logginginmobs = ""
			for(var/client/C)
				if(C.mob && !(C.mob in Players))
					if(logginginmobs == "")
						logginginmobs += "[C.key]"
					else
						logginginmobs += ", [C.key]"
			if(logginginmobs != "")
				usr << "Logging in: [logginginmobs]."


		AFK()
			if(!usr.away)
				usr.away = 1
				usr.here=usr.status
				usr.status=" (AFK)"
				Players<<"~ <font color=red>[usr]</font> is <u>AFK</u> ~"
				ApplyAFKOverlay()
			else
				usr.away = 0
				usr.status=usr.here
				usr.overlays-=image('AFK.dmi',icon_state="AFK2")
				usr.overlays-=image('AFK.dmi',icon_state="AFK3")
				usr.overlays-=image('AFK.dmi',icon_state="AFK4")
				usr.overlays-='AFK.dmi'
				Players<<"<font color=red>[usr]</font> is no longer AFK."
mob
	proc/ApplyAFKOverlay()
		src.overlays-=image('AFK.dmi',icon_state="AFK2")
		src.overlays-=image('AFK.dmi',icon_state="AFK3")
		src.overlays-=image('AFK.dmi',icon_state="AFK4")
		src.overlays-=image('AFK.dmi')
		var/mob/Player/user = src
		if(locate(/obj/items/wearable/afk/pimp_ring) in user.Lwearing)
			src.overlays+=image('AFK.dmi',icon_state="AFK2")
		else if(locate(/obj/items/wearable/afk/hot_chocolate) in user.Lwearing)
			src.overlays+=image('AFK.dmi',icon_state="AFK3")
		else if(locate(/obj/items/wearable/afk/heart_ring) in user.Lwearing)
			src.overlays+=image('AFK.dmi',icon_state="AFK4")
		else
			src.overlays+='AFK.dmi'
mob/Player
	Stat()
		if(statpanel("Stats"))
			stat("Name:",src.name)
			stat("Year:",src.Year)
			stat("Gold:",comma(src.gold))
			stat("Level:",src.level)
			stat("HP:","[src.HP]/[src.MHP+src.extraMHP]")
			stat("MP:","[round(src.MP)]/[src.MMP+src.extraMMP] ([src.extraMMP/10])")
			if (src.level>500)
				stat("Damage:","[src.Dmg+src.extraDmg] ([src.extraDmg])")
				stat("Defense:","[src.Def+src.extraDef] ([round(src.extraDef/3)])")
			stat("House:",src.House)
			stat("EXP:","[comma(src.Exp)]/[comma(src.Mexp)]")
			stat("Stat points:",src.StatPoints)
			stat("Earned Statpoints:",src.Counter_Sp)
			stat("Spell points:",src.spellpoints)
			stat("Server Time :",time2text(world.timeofday,"hh:mm"))
			if(learning)
				stat("Learning:", learning.name)
				stat("Uses required:", learning.uses)
			if(admin)
				stat("CPU:",world.cpu)
			stat("---House points---")
			stat("Gryffindor",housepointsGSRH[1])
			stat("Slytherin",housepointsGSRH[2])
			stat("Ravenclaw",housepointsGSRH[3])
			stat("Hufflepuff",housepointsGSRH[4])
			if(src.Auror)
				stat("---Clan points---")
				stat("-Aurors-",housepointsGSRH[5])
			if(src.DeathEater)
				stat("---Clan points---")
				stat("-Deatheaters-",housepointsGSRH[6])
			stat("","")
			if(currentEvents)
				stat("Current Events:","")
				for(var/key in currentEvents)
					stat("", key)
			if(currentArena)
				if(currentArena.roundtype == HOUSE_WARS)
					stat("Arena:")
					stat("Gryffindor",currentArena.teampoints["Gryffindor"])
					stat("Slytherin",currentArena.teampoints["Slytherin"])
					stat("Hufflepuff",currentArena.teampoints["Hufflepuff"])
					stat("Ravenclaw",currentArena.teampoints["Ravenclaw"])
				else if(currentArena.roundtype == CLAN_WARS)
					stat("Arena:")
					stat("Aurors",currentArena.teampoints["Aurors"])
					stat("Deatheaters",currentArena.teampoints["Deatheaters"])
				else if(currentArena.roundtype == FFA_WARS)
					stat("Arena: (Players Alive)")
					for(var/mob/M in currentArena.players)
						stat("-",M.name)
			if(currentMatches.arenas)
				stat("Matchmaking:", "(Click to spectate. Click again to stop.)")
				for(var/arena/a in currentMatches.arenas)
					stat(a.spectateObj)

		if(usr.party!="")
			if(statpanel("Party"))
				var/party/Party/pp=check_party(usr.party)
				stat(pp.name,"[pp.members.len]/4")
				stat(pp.members)
		if(statpanel("Items"))
			for(var/obj/stackobj/S in contents)
				stat("Click to expand stacked items.")
				break
			for(var/obj/O in src.contents)
				if(istype(O,/obj/stackobj))
					stat("+",O)
					if(O:isopen)
						for(var/obj/B in O:contains)
							stat("-",B)
					//	stat(O:contains)//Display all the objects inside the stack obj
				else
					if(istype(src,/mob/Player))
						if(!src:stackobjects || !(src:stackobjects.Find(O.type))) //If there's NOT a stack object for this obj type, print it
							stat(O)
obj
	stackobj
		var/isopen=0
		var/containstype
		var/list/obj/contains = list()
		mouse_over_pointer = MOUSE_HAND_POINTER
		Click()
			if(src in usr)
				isopen = !isopen
		verb
			Drop_All()
				set category = null
				//var/tmpname = ""
				//var/isscroll=0
				for(var/obj/items/O in contains)
					var/founddrop = 0
					for(var/V in O.verbs)
						if(V:name == "Drop")
							founddrop =1
							break
					if(!founddrop)
						usr << errormsg("This type of item can't be dropped.")
						return
					//tmpname = O.name
					//if(istype(O,/obj/items/scroll))
				//		isscroll = 1
					//O.Move(usr.loc)
					O.Drop()
				/*if(isscroll)
					hearers(usr) << "[usr] drops all of \his scrolls."
				else
					switch(copytext(tmpname,length(tmpname)))//Check last letter for pluralizness
						if("f")
							hearers(usr) << "[usr] drops all of \his [copytext(tmpname,1,length(tmpname))]ves."
						if("s")
							hearers(usr) << "[usr] drops all of \his [tmpname]."
						else
							hearers(usr) << "[usr] drops all of \his [tmpname]s."
				*/
				del(src)


mob/Player/var/tmp/list/obj/stackobj/stackobjects
mob/proc/Update_Bag()
	var/count = 1
//	winshow(usr,"bagw")
	var/grid_update=1
	for(var/obj/I in contents)grid_update++
	winset(src,"Bag","cells=1,[grid_update]")
	winset(src,"Bag","cells=2,[grid_update]")
	usr<<output("<b> Items </b>","Bag:1,1")
	usr<<output("<b> Status </b>","Bag:2,1")
	for(var/obj/I in contents)
		usr << output(I, "Bag:1,[++count]")
		usr << output(I.suffix, "Bag:2,[count]")
mob/proc/Resort_Stacking_Inv()
	usr:Update_Bag()
	if(!istype(src,/mob/Player))
		world.log << "[src] is of the wrong type ([src.type]) in /mob/proc/Resort_Stacking_Inv()"
		return
	var/list/counts = list()

	for(var/obj/O in contents)
		//if(istype(O,/Spell)) continue
		if(istype(O,/obj/stackobj))
			O.loc = null
		else
			if(!istype(O,/obj/items/Soul_Stone))counts[O.type]++
	if(length(counts))
		var/list/obj/stackobj/tmpstackobjects = list()
		for(var/V in counts)
			if(counts[V] > 1)
				var/obj/stackobj/stack = new()
				var/obj/tmpV = new V()
				stack.containstype = V
				if(src:stackobjects)
					if(src:stackobjects[V])
						var/obj/stackobj/tmpstack = src:stackobjects[V]
						stack.isopen = tmpstack.isopen
				stack.icon = tmpV.icon
				stack.icon_state = tmpV.icon_state
				stack.name = tmpV.name
				stack.suffix = "<font color=red>(x[counts[V]])</font>"
				contents += stack
				for(var/obj/O in contents)
					if(istype(O,stack.containstype))
						stack.contains += O
				tmpstackobjects[V] = stack
		src:stackobjects = tmpstackobjects
	else
		src:stackobjects = null
mob/proc/Check_Death_Drop()
	usr=src
	for(var/obj/drop_on_death/O in src)
		O.Drop()



mob/Player/proc/Auto_Mute(timer=15, reason="spammed")
	if(mute==0)
		mute=1
		Players << "\red <b>[src] has been silenced.</b>"

		if(reason)
			src << "<b>You've been muted because you [reason].</b>"

		if(timer==0)
			Log_admin("[src] has been muted automatically.")
		else
			Log_admin("[src] has been muted automatically for [timer] minutes.")
			timerMute = timer
			if(timer != 0)
				src << "<u>You've been muted for [timer] minute[timer==1 ? "" : "s"].</u>"
			spawn()mute_countdown()

		spawn()sql_add_plyr_log(ckey,"si",reason,timer)

/*
		Auto_Ban()
			world<<"<B><Font face='Comic Sans MS'>HGM Security: <Font color=green><Font face='Comic Sans MS'>[src] has been automatically banned for Spamming on the main chat channel."
			usr.client.FullBan(usr.key,usr.client.address)
*/

	//	damageblock()
	//		src.HP-=(src.HP/8)


mob/proc/resetStatPoints()
	src.StatPoints = src.level - 1 + src.Counter_Sp
	src.extraMHP = 0
	src.extraMMP = 0
	src.extraDmg = 0
	src.extraDef = 0
	src.Dmg = (src.level - 1) + 5
	src.Def = (src.level - 1) + 5
	resetMaxHP()
	src.verbs.Add(/mob/Player/verb/Use_Statpoints)
	src.incindia_level  = 1
	src.glacius_level   = 1
	src.tremorio_level  = 1
	src.waddiwasi_level = 1
	src.aqua_level      = 1
mob/proc/resetMaxHP()
	src.MHP = 4 * (src.level - 1) + 200 + src.extraDef + 2 * (src.Def + src.clothDef)
	if(HP > MHP)
		HP = MHP
mob
	proc
		LvlCheck(var/fakelevels=0)
			if(level >= lvlcap)
				Exp = 0
				return
			if(src.Exp>=src.Mexp)
				src.level++
				src.MMP = level * 6
				src.MP=src.MMP+extraMMP
				src.Dmg+=1
				src.Def+=1
				src.resetMaxHP()
				src.HP=src.MHP+extraMHP
				src.updateHPMP()
				//src.Expg=src.Texp
				src.Exp-=src.Mexp
				src.verbs.Remove(/mob/Player/verb/Use_Statpoints)
				src.verbs.Add(/mob/Player/verb/Use_Statpoints)
				src.StatPoints++
				if(src.Mexp<2000)
					src.Mexp*=1.5
				else if(src.Mexp>2000&&src.Mexp<318000)
					src.Mexp+=500
				else
					src.Mexp+=1000
				Mexp = round(Mexp)
				if(!fakelevels)
					src<<"<b><font color=blue>You are now level [src.level]!</font></b>"
				//	src<<"HP increased by [HPplus]."
				//	src<<"MP increased by [MPplus]."
				//	src<<"Damage increased by [Dmgplus]."
				//	src<<"Defense increased by [Defplus]."
					src<<"You have gained a statpoint."
				var/theiryear = (src.Year == "Hogwarts Graduate" ? 8 : text2num(copytext(src.Year, 1, 2)))
				if(src.level>1 && src.level < 16)
					src.Year="1st Year"
				if(src.level>15 && theiryear < 2)
					src.Year="2nd Year"
					src<<"<b>Congratulations, you are now on your Second Year at Hogwarts.</b>"
					src<<infomsg("You learned how to cancel transfigurations!")
					src.verbs += /mob/Spells/verb/Self_To_Human
				if(src.level>15 && !(/mob/Spells/verb/Self_To_Human in verbs))
					src<<infomsg("You learned how to cancel transfigurations!")
					src.verbs += /mob/Spells/verb/Self_To_Human
				if(src.level>50 && theiryear < 3)
					src.Year="3rd Year"
					src<<"<b>Congratulations on attaining your 3rd Year rank promotion!</b>"
					src.verbs += /mob/Spells/verb/Episky
					src<<"<b><font color=green><font size=3>You learned Episkey."
				if(src.level>100 && theiryear < 4)
					src.Year="4th Year"
					src<<"<b>Congratulations to [src]. You are now a 4th Year."
					src.verbs += /mob/Spells/verb/Self_To_Dragon
					src<<"<b><font color=green><font size=3>You learned how to Transfigure yourself into a fearsome Dragon!"
				if(src.level>200 && theiryear < 5)
					src.Year="5th Year"
					src<<"<b>Congratulations to [src]. You are now a 5th Year."
				if(src.level>300 && theiryear < 6)
					src.Year="6th Year"
					src<<"<b>Congratulations to [src]. You are now a 6th Year."
				if(src.level>400 && theiryear < 7)
					src.Year="7th Year"
					src<<"<b>Congratulations to [src]. You are now a 7th Year."
				if(src.level>500 && theiryear < 8)
					src.Year="Hogwarts Graduate"
					src<<"Congratulations, [src]! You have graduated from Hogwarts and attained the rank of Hogwarts Graduate."
					src<<infomsg("You can now view your damage & defense stats in the stats tab.")
					if(!(locate(/obj/items/wearable/jackets/Slytherin_Robe) in src)  && src.House=="Slytherin")
						new/obj/items/wearable/jackets/Slytherin_Robe(src)
					if(!(locate(/obj/items/wearable/jackets/Ravenclaw_Robe) in src)  && src.House=="Ravenclaw")
						new/obj/items/wearable/jackets/Ravenclaw_Robe(src)
					if(!(locate(/obj/items/wearable/jackets/Hufflepuff_Robe) in src)  && src.House=="Hufflepuff")
						new/obj/items/wearable/jackets/Hufflepuff_Robe(src)
					if(!(locate(/obj/items/wearable/jackets/Gryffindor_Robe) in src)  && src.House=="Gryffindor")
						new/obj/items/wearable/jackets/Gryffindor_Robe(src)
					src.BaseIcon()
					src.baseicon=src.icon
				src.LvlCheck()
			if(!src.derobe)src.client.update_individual()
//			src.update_rank()
obj/Banker
	icon = 'NPCs.dmi'
	density=1
	mouse_over_pointer = MOUSE_HAND_POINTER
	New()
		..()
		spawn(1) icon_state = "goblin[rand(1,3)]"
		src.GenerateNameOverlay(255,255,153)
	Click()
		..()
		if(src in oview(3))
			Talk()
		else
			usr << errormsg("You need to be closer.")

	verb
		Examine()
			set src in oview(3)
			usr << "He looks like a trustworthy person to hold my money."
		Talk()
			set src in oview(3)

			var/mob/Player/p = usr
			var/list/choices = list("Deposit","Withdraw","Balance")

			if("On House Arrest" in p.questPointers)
				var/questPointer/pointer = p.questPointers["On House Arrest"]
				if(pointer.stage == 1) choices += "I'd like to withdraw something from Fred's vault"

			switch(input("How may I help you?","Banker") in choices)
				if("I'd like to withdraw something from Fred's vault")
					alert("You hand the banker the key")
					switch(input("And what would you like to withdraw?","Banker")in list("Wand of Interuption","Cancel"))
						if("Wand of Interuption")
							alert("The banker takes the key and unlocks a small compartment under his desk.")
							alert("He pulls out a box, and removes the wand from it")
							alert("The banker hands you the wand")
							new/obj/items/wearable/wands/interruption_wand(usr)

							var/obj/items/freds_key/k = locate() in usr
							if(k)
								k.loc = null

							p.Resort_Stacking_Inv()
							p.checkQuestProgress("Fred's Wand")
				if("Deposit")
					var/heh = input("You have [comma(usr.gold)] gold. How much do you wish to deposit?","Deposit",usr.gold) as null|num
					if(heh==null)return
					if (heh < 0)
						alert("Don't try cheating me!","Bank Keeper")
						return()
					if (heh > usr.gold)
						alert("You don't have that much!", "Deposit")
						return()
					if(get_dist(usr,src)>4)return
					usr << "You deposit [comma(heh)] gold."
					usr.gold -= heh
					usr.goldinbank += heh
					usr << "You now have [comma(usr.goldinbank)] gold in the bank."
				if("Withdraw")
					var/heh = input("You have [comma(usr.goldinbank)] gold in the bank. How much do you wish to withdraw?","Withdraw",usr.goldinbank) as null|num
					if(heh==null)return
					if (heh < 0)
						alert("Don't try cheating me!","Bank Keeper")
						return()
					if (heh > usr.goldinbank)
						alert("You don't have that much in your bank account!", "Bank Keeper")
						return()
					if(get_dist(usr,src)>4)return
					usr << "You withdraw [comma(heh)] gold."
					usr.gold += heh
					usr.goldinbank -= heh
					usr << "You now have [comma(usr.goldinbank)] gold in the bank."
				if("Balance")
					usr << "You have [comma(usr.goldinbank)] gold in the bank."


obj
	Bank
		Vault
			icon = 'vault.dmi'
			density=1
			accioable=0
			dontsave = 1
			verb
				Examine()
					set src in oview(3)
					usr << "I wonder how everything I have fits into this vault..."
				Bank()
					set src in oview(3)

					if(!usr.bank)
						usr.bank = new/BankClass
					switch(alert("Would you like to deposit or withdraw an item?","Banking", "Deposit", "Withdraw"))

						if("Deposit")
							var/list/obj/inventory = list()
							for(var/obj/O in usr.contents)
								if(!istype(O,/obj/stackobj))
									inventory += O
							var/obj/O = input("Which item would you like to deposit?") as null|obj in inventory
							if(O)
								if(get_dist(usr,src)>4)return
								if(!(O in usr))return
								usr.bank.DepositItem(O)
								usr << "You have deposited [O.name]!"
								usr:Resort_Stacking_Inv()
						else if("Withdraw")
							var/obj/O = input("Which item would you like to withdraw?") as null|obj in usr.bank.GetItems()
							if(O)
								if(get_dist(usr,src)>4)return
								usr.bank.WithdrawItem(O)
								usr << "You have withdrawn [O.name]!"
								usr:Resort_Stacking_Inv()

BankClass
	var
		balance = 0
		list/items = list()
	proc
		GetBalance()
			return src.balance

		DepositMoney(var/num)
			src.balance += num
			return num

		WithdrawMoney(var/num)
			balance -= num
			return num

		DepositItem(var/obj/O)
			src.items.Add(O)
			usr.contents.Remove(O)

		WithdrawItem(var/obj/O)
			src.items.Remove(O)
			usr.contents.Add(O)

		GetItems()
			return src.items


mob
	var
		BankClass/bank = null

obj/Bed
	icon='Hogwarts 32x32.dmi'
	icon_state="Bed"
	density=0
	dontsave=1
	verb
		Sleep()
			set src in oview(1)
			switch(input("Recover?","Bed")in list("Yes","No"))
				if("Yes")
					if(get_dist(src,usr)>1)return
					usr<<"You go to sleep."
					usr.sight = 1
					usr.HP=usr.MHP+usr.extraMHP
					usr.MP=usr.MMP+usr.extraMMP
					usr.updateHPMP()
					sleep(100)
					if(usr)
						usr.sight = 0
						usr<<"You feel much better."

//VARS
//appearance
mob/var/Detention=0
mob/var/Rank=""
mob/var/Immortal=0
mob/var/Disperse
mob/var/Aero
obj/var/accioable=0
obj/var/clothes
mob/var/DeathEater=0

mob/var/MuteOOC=0

mob/var/Year=""
mob/var/Teleblock=0
mob/var/House
mob/var/Auror=0
mob/var/DE=0
mob/var/Tag=null
mob/var/GMTag=null
mob/var/HA
mob/var/HDE=0

obj/var/dontsave=0
//others
mob/var/base_num_characters_allowed=0
mob/var/level=1
mob/var/Dmg=5
mob/var/Def=5
mob/var/HP=200
mob/var/MHP=200
mob/var/MP=10
mob/var/MMP=10

mob/var/Mexp=5
mob/var/Exp=0
mob/var/Expg=1
mob/var/draganddrop=0
mob/var/picon=null
mob/var/Texp=0
mob/var/NPC=1
mob/var/mute=0
mob/var/listenooc=1
mob/var/listenhousechat=1
mob/var/player=1
mob/var/gold=0
mob/var/goldg=1
mob/var/goldinbank=100

mob/var/monster=0
mob/var/follow=0
mob/var/attack=0
mob/var/wander=0
mob/var/tmp/away=0
mob/var/followplayer=0
mob/var/rank=0
mob/var/description="No extra information provided."
//mob/var/summonable=0
mob/var/skills=0
mob/var/item=0
mob/var/location
mob/var/turf
mob/var/tmp/status=""
mob/var/here=""
mob/var/potion=0
mob/var/ether=0
mob/var/notmonster=1
mob/var/edeaths=0
mob/var/ekills=0
mob/var/pdeaths=0
mob/var/pkills=0
mob/var/carry=0
mob/var/Gm=0

mob/var/StatPoints=0



var/mob/HA=0
obj/var/picon=null
obj/var/value=0
obj/var/lastx
obj/var/lasty
obj/var/lastz

mob/var/damage=0

obj/var/damage=0
obj/var/tmp/mob/owner

var/autoheal=0
//playerhouses

var
	Flash = 0
	System = 0

mob/var/tmp
	spam=0
//layers
var/const
	clothes=MOB_LAYER+1
	Mail=MOB_LAYER+2
	head=MOB_LAYER+3
	ears=MOB_LAYER+4
	cape=MOB_LAYER+5
	weapon=MOB_LAYER+6


obj/Table
	icon = 'desk.dmi'
	icon_state="S1"
	density=1
	dontsave=1
	verb
		Examine()
			set src in oview(1)
			switch(input("What would you like to do?","Table")in list("Examine","Search"))
				if("Examine")
					usr<<"Just an old table."
				if("Search")
					usr<<"You dont find anything useful."
obj
	chairleft
		icon='turf.dmi'
		icon_state="cleft"
		density=0

	chairright
		icon='turf.dmi'
		icon_state="cright"
		density=0

	chairback
		icon='turf.dmi'
		icon_state="cback"
		density=0
		layer = MOB_LAYER +1
	chairfront
		icon='turf.dmi'
		icon_state="cfront"
		density=0

obj/Gate
	icon = 'turf.dmi'
	icon_state="gate"
	density=1
obj/BFrontChair
	icon='Chairs.dmi'
	icon_state="front"

proc
	textcheck(t as text)
	// Returns the text string with all potential html tags (anything \
		between < and >) removed.
		t="[html_encode(t)]"
		var/open = findtext(t,"\<")
		while(open)
			var/close = findtext(t,"&gt;",open)
			if(close)
				if(close < length(t))
					t = copytext(t,1,open)+copytext(t,close+4)//+copytext(t,close+1)
				else
					t = copytext(t,1,open)
				open = findtext(t,"\<")
			else
				open = 0
		return t
	Respawn(mob/NPC/Enemies/E)
		if(!E)return
		if(E.removeoMob)
			var/tmpmob = E.removeoMob
			E.removeoMob = null
			spawn()tmpmob:Permoveo()
		if(!istype(E,/mob/NPC/Enemies))
			E.loc = null
		else
			E.state = E.INACTIVE
			if(E.origloc)
				spawn(E.respawnTime)// + rand(-50,100))////1200
					if(E)
						E.loc = E.origloc
						E.HP = E.MHP
						E.ShouldIBeActive()
						E.state()
			else
				E.loc = null



turf
	walltorch_housewars
		name = "walltorch"
		icon='turf.dmi'
		icon_state="w2"
		density=1
		verb
			Pull()
				set src in oview(1)
				switch(input("Pull the Torch?","Pull the Torch?")in list("Yes","No"))
					if("Yes")
						alert("You pull the torch and a secret door opens")
						for(var/turf/secretdoor/T in world)
							flick("opening",T)
							T.icon_state = "open"
							density = 0
							T.bumpable = 1
							opacity = 0
							sleep(70)
							flick("closing",T)
							T.icon_state = "closed"
							density = 1
							opacity = 1
							T.bumpable=0
					if("No")
						return

obj
	fence
		icon='turf.dmi'
		icon_state="hpfence"
		density=1
	downfence
		icon='turf.dmi'
		icon_state = "post"
		density = 1

	curtains
		icon='turf.dmi'
		density = 0
		layer = 5
		c1
			icon_state="c1"
		c2
			icon_state="c2"
		c3
			icon_state="c3"
		c4
			icon_state="c4"

//TURFS
turf
	layer=TURF_LAYER
	icon='turf.dmi'
	grass
		name = SEASON_Tile
		icon_state=SEASON
		density=0

		edges
			icon='GrassEdge.dmi'
			north
				dir = NORTH
			west
				dir = WEST
			east
				dir = EAST
			south
				dir = SOUTH
			northeast
				dir = NORTHEAST
			northwest
				dir = NORTHWEST
			southeast
				dir = SOUTHEAST
			southwest
				dir = SOUTHWEST


	woodenfloorblack
		icon_state = "wood - halloween"
		density = 0
		New()
			..()
			icon_state = "wood[rand(2,8)] - halloween"

	woodenfloor
		icon_state = "wood"
		density=0
		New()
			..()
			icon_state = "wood[rand(2,8)]"


	longtable1
		icon='longtables.dmi'
		icon_state="x"
		density=1
	longtable2
		icon='longtables.dmi'
		icon_state="y"
		density=1
	longtable3
		icon='longtables.dmi'
		icon_state="z"
		density=1
	water/ice
		isice = 1
	water
		icon='Water.dmi'
		icon_state="water"
		name = "water"
		density=0
		layer=4
		var
			tmp/obj/rain
			isice = 0 // Edit to 1 for winter

		New()
			..()
			if(isice) ice()

		Enter(atom/movable/O, atom/oldloc)
			if(icon_state == "water")
				if(isplayer(O) && O.density) return 0
				if(istype(O, /obj/projectile) && O.icon_state == "iceball"||istype(O, /obj/projectile) && O.icon_state == "iceball-old")
					if(prob(20))
						for(var/turf/water/w in range(prob(10) ? 2 : 1,O))
							w.ice()
						walk(O,0)
						O.loc = null
					else
						ice()
						O:damage -= round(O:damage / 10)
					if(O:damage <= 0)
						walk(O,0)
						O.loc = null
			else if(icon_state == "ice")
				if(istype(O, /obj/projectile) && O.icon_state == "fireball"||istype(O, /obj/projectile) && O.icon_state == "fireball-old")
					water()
			return ..()

		proc
			ice()
				if(icon_state == "ice") return
				name       = "ice"
				icon_state = "ice"
				layer      = 2
				if(rain)
					rain.layer = 0
				if(!isice)
					spawn()
						var/time = rand(40,120)
						while(time > 0 && icon_state == "ice")
							time--
							sleep(10)
						if(istype(src, /turf/water)) water()
			water()
				if(icon_state == "water") return
				name       = "water"
				icon_state = "water"
				layer      = 4
				if(rain)
					rain.layer = 4
				if(isice)
					spawn()
						var/time = rand(40,120)
						while(time > 0 && icon_state == "water")
							time--
							sleep(10)
						if(istype(src, /turf/water)) ice()
			rain()
				if(rain) return
				rain = new (src)

				spawn(rand(1,150))
					if(rain)
						rain.icon = 'water_drop.dmi'
						rain.layer = name == "ice" ? 0 : 4
						rain.icon_state = pick(icon_states(rain.icon))
						rain.pixel_x = rand(-12,12)
						rain.pixel_y = rand(-13,14)
			clear()
				if(rain)
					rain.loc = null
					rain = null

	lava
		icon_state="hplava"
		density = 0

		Enter(atom/movable/O, atom/oldloc)
			if(isplayer(O) && O.density) return 0
			return ..()

	roofb
		icon       = 'StoneRoof.dmi'
		icon_state = "roof-0"
		density    = 1
		opacity    = 1
		flyblock   = 1

		New()
			..()

			if(icon_state == "roof-0")
				var/n = autojoin("name", "roofb")
				icon_state = "roof-[n]"

	roofa
		icon_state = "broof"
		density=1
		opacity=1
		flyblock=1

	diamondt
		icon_state="tf2"
		density=0
	blackfloor
		icon_state="blackfloor"
		density=0
	blankturf
		icon_state="black"
		density=0
	blankturf/edge
		icon       = null
		icon_state = null
		density    = 1
		flyblock   = 1
		opacity    = 1
		phaseblock = 1
	Art_Tree
		icon='Decoration.dmi'
		icon_state="tree top"
		density=1
		opacity=0
	Art_Tree2
		icon='Decoration.dmi'
		icon_state="tree"
		density=1
		opacity=0
	road
		icon_state="road"
		density=0
	wfloor
		icon_state="wfloor"
		density=0
	stairsnormal
		icon_state="gmstair"
	painting2
		icon_state="p2"
		density=0
		opacity=0
	painting3
		icon_state="p3"
		density=0
	Art
		icon='Decoration.dmi'
		icon_state="royal top1"
		density=1
		opacity=0
	Art1
		icon='Decoration.dmi'
		icon_state="royal1"
		density=1
		opacity=0
	Art_Man
		icon='Decoration.dmi'
		icon_state="royal top"
		density=1
		opacity=0
	Art_Man2
		icon='Decoration.dmi'
		icon_state="royal"
		density=1
		opacity=0
	painting4
		icon_state="p4"
		density=0
	painting1
		icon_state="p1"
		density=0
		opacity=0
	wall
		icon='wall1.dmi'
		density=1
	black
		icon_state="black"
		density=0
	tree
		icon='ragtree.dmi'
		icon_state="summer" //winter in winter
		density=1
		opacity=0
	snowtopright
		icon_state="topsnowright"
		density=0
	snowtop
		icon_state="topsnow"
		density=0
	snowtopup
		icon_state="topsnowup"
		density=0
	snowtopleft
		icon_state="topsnowleft"
		density=0
	floor
		icon_state="brick"
		density=0
	brick
		icon='hogwartsbrick.dmi'
		icon_state="brick2"
		density=1
	redroses
		icon_state="redplant"
		density=1
	bush
		icon_state="bush"
		density=0
		layer=MOB_LAYER+1
	flower
		icon_state="flower"
		density=1
		layer=MOB_LAYER+1
	sign
		icon='statues.dmi'
		icon_state="sign"
		density=1
	ice
		icon_state="ice"
		density=0
	dirt
		icon_state="dirt"
		density=0
	sand
		icon_state="sand"
		density=0
	walltorch
		icon_state="w2"
		density=1
		flyblock=1
		luminosity = 6
	bigchair
		icon_state="bc"
		density=1
	redchair
		icon_state="rc"
		density=1

proc/ServerAD()
	Players<<"<b><Font color=silver>Server:</b> <font size=1><font color=silver>Thanks for playing The Wizards' Chronicles. Forums: http://www.wizardschronicles.com"
	sleep(3000)
	ServerAD()

proc/SugAD()
	Players<<"<b><Font color=silver>Server:</b> <font size=1><font color=green>TWC is currently looking for loads more content to add! Got a suggestion? Post it on the suggestions board at http://www.wizardschronicles.com <br>The only bad suggestion is the one not shared!"
	sleep(9000)
	SugAD()


proc/ServerRW()
	Players<<"<b><Font color=silver>Server:</b> <font size=1><font color=red> The server is currently in Developer Mode. This means that the game is currently being coded and updated - Reboots may be frequent."
	sleep(3000)
	ServerRW()

obj
	tabletop
		icon='turf.dmi'
		icon_state="t1"
		density=1
		layer=2
	tableleft
		icon='turf.dmi'
		icon_state="t2"
		density=1
		layer=2
	tablemiddle2
		icon='turf.dmi'
		icon_state="mid2"
		density=1
		layer=2
	tablemiddle
		icon='turf.dmi'
		icon_state="middle"
		density=1
		layer=2
	tablecornerL
		icon='turf.dmi'
		icon_state="t2"
		density=1
		layer=2
	tablecornerR
		icon='turf.dmi'
		icon_state="t3"
		density=1
		layer=2
	tableright
		icon='turf.dmi'
		icon_state="bottomright"
		density=1
		layer=2
	tableleft
		icon='turf.dmi'
		icon_state="bottom1"
		density=1
		layer=2
	tablebottom
		icon='turf.dmi'
		icon_state="bottom"
		density=1
		layer=2
	tablemid3
		icon='turf.dmi'
		icon_state="mid3"
		density=1
		layer=2
obj
	guard_statue
		icon='Mobs.dmi'
		icon_state="guard"
		New()
			..()
			var/turf/T = src.loc
			if(T)T.flyblock=1

	snowman
		icon='snowman.dmi'
		name="Snow Man"
		verb
			Examine()
				set src in oview(3)
				usr << "So creative!"



turf/proc/autojoin(var_name, var_value = 1)
	var/n = 0
	var/turf/t
	t = locate(x, y + 1, z)
	if(t && t.vars[var_name] == var_value) n |= 1
	t = locate(x + 1, y, z)
	if(t && t.vars[var_name] == var_value) n |= 2
	t = locate(x, y - 1, z)
	if(t && t.vars[var_name] == var_value) n |= 4
	t = locate(x - 1, y, z)
	if(t && t.vars[var_name] == var_value) n |= 8

	return n