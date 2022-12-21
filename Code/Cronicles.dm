/*
 * Copyright © 2014 Duncan Fairley
 * Distributed under the GNU Affero General Public License, version 3.
 * Your changes must be made public.
 * For the full license text, see LICENSE.txt.
 */
mob/var/ror=0

var/WorldData/worldData

WorldData
	var
		list
			vault/globalvaults
			customMap/customMaps


var/list/mob/Player/Players = list()
turf/var/flyblock=0
turf/var/phaseblock=0


turf
	Enter(atom/movable/O)
		if(ismob(O))
			if(flyblock==2)
				for(var/atom/A in src)
					if(A.density) return 0
				return ..()
			if(phaseblock==1)
				return 0
				return ..()
			if(!density) return ..()
			if(O:Gm && !O:flying) return ..()
			if(!O:key) return ..()
			else if(density&&flyblock)
				return 0
		return ..()
proc/str_count(haystack, needle)
	. = 0
	var/i = 1
	for(i; i <= length(haystack); i++)
		if(copytext(haystack, i, i + length(needle)) == needle)	.++

client
	mouse_pointer_icon='pointer.dmi'
#include <deadron/basecamp>
#define DEBUG 1
#define BASE_MENU_CREATE_CHARACTER	"Create New Character"
#define BASE_MENU_DELETE_CHARACTER	"Delete Character"
#define BASE_MENU_CANCEL			"Cancel"
#define BASE_MENU_QUIT				"Quit"
world/cache_lifespan = 0

mob/Player/var/lastreadDP
var/dplastupdate
var/lastusedAFKCheck = 0

mob/GM/verb/Complete_Duel_Season()
	skill_rating = list()
	usr<<"Cleared Duel Scores"

proc
	Load_World()
		var/savefile/X = new ("players/World.sav")
		//var/list/objs=list()
		X["worldData"] >> worldData
		if(!worldData) worldData = new
		if(!worldData.globalvaults) worldData.globalvaults = list()
		X["DP"] >> DP
		X["allowGifts"] >> allowGifts
		X["housepoints"] >> housepointsGSRH
		X["dplastupdate"] >> dplastupdate
		X["worlday"]>>world_day
		X["clan_addr"] >> _clan_admin
		X["shop_addr"] >> _Event_Shop
		if(X["DPEditors"]) X["DPEditors"] >> dp_editors
		if(X["Stories"]) X["Stories"] >> stories
	//	X["ministrybanlist"] >> ministrybanlist
		X["housecupwinner"] >> housecupwinner
		//if(!ministrybanlist)
		//	ministrybanlist = new/list()
		X["ministrybox"] >> ministrybox
		X["ministrypw"] >> ministrypw
		X["ministrybank"] >> ministrybank
		X["taxrate"] >> taxrate
		X["lastusedAFKCheck"] >> lastusedAFKCheck
		X["magicEyesLeft"] >> magicEyesLeft
		//X["promicons"] >> promicons
		if(!promicons) promicons = list()

		X["customMaps"] >> customMaps
		if(!customMaps) customMaps = list()

		if(magicEyesLeft == null)
			magicEyesLeft = 1
		if(ministrybox)
			ministrybox.loc = locate(ministrybox.lastx,ministrybox.lasty,ministrybox.lastz)
		//X["objs"] >> objs

		/*for(var/obj/O in objs)
			O.loc = locate(O.lastx, O.lasty, O.lastz)
			if(istype(O,/obj/Hogwarts_Door))
				var/obj/Hogwarts_Door/A = O
				for(var/obj/Hogwarts_Door/H in locate(A.lastx, A.lasty, A.lastz))
					H.pass = A.pass
					H.bumpable = A.bumpable
					H.door = A.door
					del A*/
		if(!DP)
			DP = new/list()
		if(!housepointsGSRH)
			housepointsGSRH = new/list(6)
			housepointsGSRH[1] = 0
			housepointsGSRH[2] = 0
			housepointsGSRH[3] = 0
			housepointsGSRH[4] = 0
			housepointsGSRH[5] = 0
			housepointsGSRH[6] = 0

		var/list/cw
		X["ClanWars"] >> cw
		if(cw && cw.len)
			spawn()
				for(var/c in cw)
					if(!(c in clanwars_schedule))
						var/list/l = split(c, " - ")
						add_clan_wars(l[1], l[2])

		X["skill_rating"] >> skill_rating
		if(!skill_rating) skill_rating = list()

		X["competitiveBans"] >> competitiveBans
		X["prizeItems"] >> prizeItems

	Save_World()
		fdel("players/World.sav")
		var/savefile/X = new("players/World.sav")
		//var/list/objs=list()
		X["worldData"] << worldData
		X["clan_addr"] << _clan_admin
		X["shop_addr"] << _Event_Shop
		var/list/cw = list()
		for(var/e in clanwars_schedule)
			cw += e
		X["worlday"]<<world_day
		X["competitiveBans"] << competitiveBans
		X["prizeItems"] << prizeItems
		X["skill_rating"] << skill_rating
		X["ClanWars"] << cw

		X["DPEditors"] << dp_editors
		X["Stories"] << stories
		X["DP"] << DP
		X["housepoints"] << housepointsGSRH
		X["dplastupdate"] << dplastupdate
		X["housecupwinner"] << housecupwinner
	//	X["ministrybanlist"] << ministrybanlist
		X["ministrypw"] << ministrypw
		X["ministrybank"] << ministrybank
		X["magicEyesLeft"] << magicEyesLeft
		X["taxrate"] << taxrate
		X["allowGifts"] << allowGifts
		X["lastusedAFKCheck"] << lastusedAFKCheck
		//X["promicons"] << promicons

		X["customMaps"] << customMaps
		if(ministrybox)
			ministrybox.lastx = ministrybox.x
			ministrybox.lasty = ministrybox.y
			ministrybox.lastz = ministrybox.z
			X["ministrybox"] << ministrybox
		/*for(var/obj/O in world)
			if(istype(O,/obj/Hogwarts_Door))
				if(O:pass)
					O.lastx = O.x
					O.lasty = O.y
					O.lastz = O.z
					objs.Add(O)
			else if(O.dontsave)
				continue
			else if(O.z==21 || O.z==19)
				O.lastx = O.x
				O.lasty = O.y
				O.lastz = O.z
				objs.Add(O)
		X["objs"] << objs*/
world/Del()
	Save_World()
	SwapMaps_Save_All()

client/var/tmp
	base_num_characters_allowed = 1
	base_autoload_character = 0
	base_autosave_character = 1
	base_autodelete_mob = 1
	base_save_verbs = 1
obj/stackobj/Write(savefile/F)
	return
mob/proc/detectStoopidBug(sourcefile, line)
	if(!Gender)
		for(var/mob/Player/M in Players)
			if(M.Gm) M << "<h4>[src] has that save bug. Tell Severus that it occured on [sourcefile] line [line]</h4>"
#define SAVEFILE_VERSION 14
mob
	var/tmp
		base_save_allowed = 1
		base_save_location = 1

	var/list/base_saved_verbs

	proc/base_InitFromSavefile()
		return


	Write(savefile/F)
		..()
		if(src.type != /mob/Player)
			return
		F["overlays"] << null
		F["icon"] << null
		F["underlays"] << null
		F["savefileversion"] << SAVEFILE_VERSION
		if (base_save_location && world.maxx)
			F["last_x"] << x
			F["last_y"] << y
			F["last_z"] << z
		detectStoopidBug(__FILE__, __LINE__)
		return

	Read(savefile/F)
		var/testtype
		F["type"] >> testtype
		if(testtype == /mob/create_character)
			F["type"] << /mob/Player
			return
		//F["key"] << null
		..()
		if(testtype != /mob/Player)
			return
		detectStoopidBug(__FILE__, __LINE__)
		if (base_save_location && world.maxx)
			var/last_x
			var/last_y
			var/last_z
			F["last_x"] >> last_x
			F["last_y"] >> last_y
			F["last_z"] >> last_z
			var/savefile_version
			F["savefileversion"] >> savefile_version
			if(!savefile_version) savefile_version = 8
			if(savefile_version < 12)
				if(src.level>500)
					if(!(locate(/obj/items/wearable/jackets/Slytherin_Robe) in src)  && src.House=="Slytherin")
						new/obj/items/wearable/jackets/Slytherin_Robe(src)
					if(!(locate(/obj/items/wearable/jackets/Ravenclaw_Robe) in src)  && src.House=="Ravenclaw")
						new/obj/items/wearable/jackets/Ravenclaw_Robe(src)
					if(!(locate(/obj/items/wearable/jackets/Hufflepuff_Robe) in src)  && src.House=="Hufflepuff")
						new/obj/items/wearable/jackets/Hufflepuff_Robe(src)
					if(!(locate(/obj/items/wearable/jackets/Gryffindor_Robe) in src)  && src.House=="Gryffindor")
						new/obj/items/wearable/jackets/Gryffindor_Robe(src)
			if(savefile_version < 14)
				var/mob/Player/quest = src
				for(var/x in quest.questPointers)
					quest.questPointers-=x
			if(savefile_version < 13)
				src.resetStatPoints()
				src << "Your statpoints have been reset."
				src.projcolor=""
				savefile_version = 13
				if(src.Counter_Sp>500)
					src.gold+=(src.Counter_Sp-500)*50000
					src.Counter_Sp=500
			var/turf/t = locate(last_x, last_y, last_z)
			if(!t || t.name == "blankturf")
				loc = locate(48,17,21)
			else if(last_z >= SWAPMAP_Z && !currentMatches.isReconnect(src)) //If player is on a swap map, move them to gringotts
				loc = locate("leavevault")
			else if(istype(t.loc, /area/DEHQ) && !DeathEater)
				loc = locate(48,17,21)
			else if(istype(t.loc, /area/AurorHQ) && !Auror)
				loc = locate(48,17,21)
			else
				loc = t

			spawn()
				if(usr.loc)
					if(usr.loc.loc)
						usr.density = 0
						usr.loc.loc.Enter(usr)
						usr.density = 1
			if(usr.ror==0)
				var/rorrand=rand(1,3)
				usr.ror=rorrand
			usr.occlumens = 0
			usr.icon_state = ""
			if(usr.Gm&&usr.custom_icon_C==0)
				if(usr.Gender == "Female")
					usr.icon = 'FemaleStaff.dmi'
				else
					usr.icon = 'MaleStaff.dmi'
			else if(usr.custom_icon_C==1)
				usr.icon=usr.custom_icon
			else
				if(usr.Gender == "Male")
					switch(usr.House)
						if("Gryffindor")
							usr.icon = 'MaleGryffindor.dmi'
							usr.verbs += /mob/GM/verb/Gryffindor_Chat
						if("Ravenclaw")
							usr.icon = 'MaleRavenclaw.dmi'
							usr.verbs += /mob/GM/verb/Ravenclaw_Chat
						if("Slytherin")
							usr.icon = 'MaleSlytherin.dmi'
							usr.verbs += /mob/GM/verb/Slytherin_Chat
						if("Hufflepuff")
							usr.icon = 'MaleHufflepuff.dmi'
							usr.verbs += /mob/GM/verb/Hufflepuff_Chat
						if("Ministry")
							usr.icon = 'suit.dmi'
				else if(usr.Gender == "Female")
					switch(usr.House)
						if("Gryffindor")
							usr.icon = 'FemaleGryffindor.dmi'
							usr.verbs += /mob/GM/verb/Gryffindor_Chat
						if("Ravenclaw")
							usr.icon = 'FemaleRavenclaw.dmi'
							usr.verbs += /mob/GM/verb/Ravenclaw_Chat
						if("Slytherin")
							usr.icon = 'FemaleSlytherin.dmi'
							usr.verbs += /mob/GM/verb/Slytherin_Chat
						if("Hufflepuff")
							usr.icon = 'FemaleHufflepuff.dmi'
							usr.verbs += /mob/GM/verb/Hufflepuff_Chat
						if("Ministry")
							usr.icon = 'suit.dmi'
			usr.baseicon = usr.icon
			if(client)
				usr.Teleblock=0
			//	usr<<browse(rules,"window=1;size=500x400")
				//if(!usr.Gm)usr.see_invisible = 0
				usr:clean_up_screen()
			/*	if(radioOnline)
					var/obj/hud/radio/Z = new()
					usr.client.screen += Z */

mob/Player/var/lastversion
var/rules = file("rules.html")

mob/BaseCamp
	base_save_allowed = 0
	Login()
		RemoveVerbs()
		return

	Stat()
		return

	proc/RemoveVerbs()
		for (var/my_verb in verbs)
			verbs -= my_verb

mob/BaseCamp/FirstTimePlayer
	proc/FirstTimePlayer()
		return 1

world
	mob = /mob/BaseCamp/ChoosingCharacter

var/HTML/HTML

mob/BaseCamp/ChoosingCharacter/Topic(href,href_list[])
	..()
	switch(href_list["action"])
		if("loginLoad")
			if(istype(src,/mob/BaseCamp/ChoosingCharacter))
				Choose_Character()
		if("loginNew")
			if(istype(src,/mob/BaseCamp/ChoosingCharacter))
				New_Character()


mob/proc/HTMLOutput(mob/M,page,list/href_list)
	return {"
	<!DOCTYPE html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<meta http-equiv="X-UA-Compatible" content="IE=edge">
		<script>
		function post(url, data) {
			if(!url) return;
				var http = new XMLHttpRequest;
				http.open('POST', url);
				http.setRequestHeader('Content-Type', 'application/json');
				http.send(data);
			}
			</script>
		<style>
		a{
		    font-weight: normal;
		    font-style: normal;
		}
		a:link {
		  text-decoration: none;
		  font-size:30pt;
		}
		a:link {
		  color: #FFD545;
		}

		a:visited {
		  color: #FFD545;
		}

		a:hover {
		  color: #8F1226;
		}

		a:active {
		  color: #FFD545;
		img{
			z-index: -1;
		}
		</style>
	</head>
	<body>
	<center>
	<div style="position:absolute;bottom:5%;left:10%">
	<a href='?src=\ref[src];action=loginNew'>New</a>
	</div>
	<div style="position:absolute;bottom:5%;right:15%">
	<a href='?src=\ref[src];action=loginLoad'>Load</a>
	</div>

	<img src="http://51.195.202.176/resources/Header3.png" style="width:100%;height:100%;position:absolute;left:0px;top:0px;" />
	</body>
	</html>"}

obj
	login
		plane=50
		NEWBUTTON
			icon='New.dmi'
			name="New"
			screen_loc = "CENTER-4,CENTER-6"
			Click()
				var/mob/BaseCamp/ChoosingCharacter/a = usr
				a.New_Character()
		LOADBUTTON
			icon='Load.dmi'
			name="Load"
			screen_loc = "CENTER+5,CENTER-6"
			Click()
				var/mob/BaseCamp/ChoosingCharacter/a = usr
				a.Choose_Character()
		LoginTitle
			icon='hp.dmi'
			name="Harry Potter"
			screen_loc = "CENTER-4,CENTER+2"
mob/tmpmob

/*

			followers -= o

			if(!followers.len)
				followers = null
*/

mob/BaseCamp/ChoosingCharacter
	movable=1
	Login()
		src.client.view="40x40"
	//	src<< browse(HTMLOutput(src),"window=mainwindow.LoginBro")
		//html login

		winset(src, "mainwindow.mainvsplit", "splitter=100")
		winset(src, "mainwindow.mainvsplit", "show-splitter=false;")
		winset(src,"mainwindow.LoginBro","is-visible=true")
		src<< browse(HTMLOutput(src),"window=mainwindow.LoginBro")


	// camera login
		/*
		var/obj/o = locate("World Camera")
		client.eye=o
		client.perspective = EYE_PERSPECTIVE
		winset(src,null,"mapwindow.on-size=\".resizeMap\";winSettings.is-visible=false;broLogin.is-visible=false;barHP.is-visible=false;barMP.is-visible=false;rpane.is-visible=false;")
		winset(src, "mainwindow.mainvsplit", "splitter=100")
		winset(src, "mainwindow.mainvsplit", "show-splitter=false;")
		var/obj/login/NEWBUTTON/b = new()
		var/obj/login/LOADBUTTON/l = new()
		var/obj/login/LoginTitle/LTT = new()
		src.client.screen+=LTT
		src.client.screen+=b
		src.client.screen+=l
		winset(src,"mainwindow.LoginBro","is-visible=false")
		*/
		..()

	proc/Choose_Character()
		var/list/available_char_names=client.base_CharacterNames()
		if(length(available_char_names) < 1)
			src<<errormsg("You don't have a character to load, forwarding to creation process.")
			src.sight=1
			client.base_NewMob()
			del(src)
			return
		else
			client.screen=null
			winset(src,null,"rpane.is-visible=true;")
			winset(src, "mainwindow.mainvsplit", "splitter=80;")
			winset(src, "mainwindow.mainvsplit", "show-splitter=true;")
			src.client.perspective = MOB_PERSPECTIVE
			src.client.eye=src
			client.base_LoadMob(available_char_names[1])
			del(src)
			return
	proc/New_Character()
		src.sight=1
		var/list/names=client.base_CharacterNames()
		if(length(names) < client.base_num_characters_allowed)
			client.screen=null
			winset(src,null,"rpane.is-visible=true;")
			winset(src, "mainwindow.mainvsplit", "splitter=80;")
			winset(src, "mainwindow.mainvsplit", "show-splitter=true;")
			src.client.perspective = MOB_PERSPECTIVE
			src.client.eye=src
			winset(src, null, "rpanewindow.left=infowindow")
			client.base_NewMob()
			src.sight=0
			del(src)
			return
		else
			switch(input(src,"You have the maximum amount of allowed characters. Delete one?") in list ("Yes","No"))
				if("Yes")
					DeleteCharacter()
					usr.sight=0
					return
				if("No")
					usr.sight=0
					return
	proc/ChooseCharacter()
		var/list/available_char_names = client.base_CharacterNames()
		var/list/menu = new()
		menu += available_char_names

		if (length(available_char_names) < client.base_num_characters_allowed)
			if (client.base_num_characters_allowed == 1)
				client.base_NewMob()
				del(src)
				return
			else
				menu += BASE_MENU_CREATE_CHARACTER

		if (length(available_char_names))
			menu += BASE_MENU_DELETE_CHARACTER

		menu += BASE_MENU_QUIT

		var/default = null
		var/result = input(src, "Who do you want to be today?", "Welcome to [world.name]!", default) in menu
		switch(result)
			if (0, BASE_MENU_QUIT)
				del(src)
				return

			if (BASE_MENU_CREATE_CHARACTER)
				client.base_NewMob()
				del(src)
				return

			if (BASE_MENU_DELETE_CHARACTER)
				DeleteCharacter()
				ChooseCharacter()
				return

		var/mob/Mob = client.base_LoadMob(result)
		if (Mob)
			del(src)
		else
			ChooseCharacter()

	proc/DeleteCharacter()
		var/list/available_char_names = client.base_CharacterNames()
		var/list/menu = new()
		menu += available_char_names

		menu += BASE_MENU_CANCEL
		menu += BASE_MENU_QUIT

		var/default = null
		var/result = input(src, "Which character do you want to delete?", "Deleting Character", default) in menu

		switch(result)
			if (0, BASE_MENU_QUIT)
				del(src)
				return

			if (BASE_MENU_CANCEL)
				return

		client.base_DeleteMob(result)
		sight=0
		return

var/list/mob/fakeDEs = list()
proc/cleanup_fakeDE(loggedoutKey)
	for(var/mob/fakeDE/d in fakeDEs)
		if(d.ownerkey == loggedoutKey)
			del d

client
	var/tmp/savefile/_base_player_savefile

	New()
		.=..()
		if (base_autoload_character)
			base_ChooseCharacter()
			base_Initialize()
			return
		return ..()

	Del()
		if(mob && isplayer(mob))
			if(mob:isTrading())
				mob:trade.Clean()
			var/StatusEffect/S = mob.findStatusEffect(/StatusEffect/Lamps)
			if(S) S.Deactivate()
			if(mob.derobe)
				mob.derobe = 0
				mob.name = mob.prevname
			mob.occlumens = 0
			if(!mob.Gm)
				mob.Check_Death_Drop()
			cleanup_fakeDE(key)
		if (base_autosave_character)
			base_SaveMob()
		if (base_autodelete_mob)
			del(mob)
		return ..()



	proc/base_PlayerSavefile()
		if (!_base_player_savefile)
			var/first_initial = copytext(ckey, 1, 2)
			var/filename = "players/[first_initial]/[ckey].sav"
			_base_player_savefile = new(filename)
		return _base_player_savefile


	proc/base_FirstTimePlayer()
		var/mob/BaseCamp/FirstTimePlayer/first_mob = new()
		first_mob.name = key
		first_mob.gender = gender
		mob = first_mob
		return first_mob.FirstTimePlayer()


	proc/base_ChooseCharacter()
		base_SaveMob()

		var/mob/BaseCamp/ChoosingCharacter/chooser

		var/list/names = base_CharacterNames()
		if (!length(names))
			var/result = base_FirstTimePlayer()
			if (!result)
				del(src)
				return

			chooser = new()
			mob = chooser

			return

		if (base_num_characters_allowed == 1)
			base_LoadMob(names[1])
			return

		chooser = new()
		mob = chooser
		return


	proc/base_CharacterNames()
		var/list/names = new()
		var/savefile/F = base_PlayerSavefile()

		F.cd = "/players/[ckey]/mobs/"
		var/list/characters = F.dir
		var/char_name
		for (var/entry in characters)
			F["[entry]/name"] >> char_name
			names += char_name
		return names


	proc/base_NewMob()
		base_SaveMob()
		var/mob/new_mob
		new_mob = new /mob/create_character
		new_mob.name = key
		new_mob.gender = gender
		mob = new_mob
		_base_player_savefile = null
		return new_mob


	proc/base_SaveMob()
		if (!mob || !mob.base_save_allowed)
			return

		if (base_save_verbs)
			mob.base_saved_verbs = mob.verbs
		var/first_initial = copytext(ckey, 1, 2)
		fdel("players/[first_initial]/[ckey].sav")
		var/savefile/F = base_PlayerSavefile()
		var/wasDE = 0
		if(mob.name == "Deatheater" && mob.prevname)
			wasDE = 1
			mob.name = mob.prevname
		var/mob_ckey = ckey(mob.name)

		var/directory = "/players/[ckey]/mobs/[mob_ckey]"
		F.cd = directory


		F["name"] << mob.name
		F["mob"] << mob
		if(wasDE)
			mob.name = "Deatheater"
		_base_player_savefile = null


	proc/base_LoadMob(char_name)
		var/mob/new_mob
		var/char_ckey = ckey(char_name)
		var/savefile/F = base_PlayerSavefile()
		_base_player_savefile = null

		F.cd = "/players/[ckey]/mobs/"
		var/list/characters = F.dir
		var/error = FALSE
		if (!characters.Find(char_ckey))
			world.log << "<b>[key]'s client.LoadCharacter() could not locate character [char_name].</b>"
			error = TRUE
		if(!char_ckey)
			F["mob"] >> new_mob
		else
			F["[char_ckey]/mob"] >> new_mob
		if (new_mob)
			if(istype(new_mob, /mob/create_character))
				usr << "\red <b>Your character has been absolved of the new player bug. Please reconnect and load again.</b>"
				base_DeleteMob(char_name)
				del new_mob
				return
			else if(error && !new_mob.name)
				new_mob.name = "RenameMe"

			mob = new_mob

			new_mob.base_InitFromSavefile()
			if (base_save_verbs && new_mob.base_saved_verbs)
				if(!new_mob.base_saved_verbs.len) return null
				for (var/item in new_mob.base_saved_verbs)
					new_mob.verbs += item
			return new_mob
		return null


	proc/base_DeleteMob(char_name)
		var/char_ckey = ckey(char_name)
		var/savefile/F = base_PlayerSavefile()

		F.cd = "/players/[ckey]/mobs/"
		F.dir.Remove(char_ckey)