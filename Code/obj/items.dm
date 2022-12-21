/*
 * Copyright � 2014 Duncan Fairley
 * Distributed under the GNU Affero General Public License, version 3.
 * Your changes must be made public.
 * For the full license text, see LICENSE.txt.
 */
#define WORN 1
#define REMOVED 2

obj/items/food
	Click()
		if(src in usr)
			Eat()
		..()
	proc/Eat()
		del(src)
	chocolate_bar
		icon = 'chocolate_bar.dmi'
		Eat()
			viewers(usr) << infomsg("[usr] eats a deliciously nutty chocolate bar.")
			..()
	caramel_apple
		icon = 'caramel_apple.dmi'
		Eat()
			viewers(usr) << infomsg("[usr] chomps down on a caramel apple.")
			..()
	candy_corn
		icon = 'candy_corn.dmi'
		Eat()
			viewers(usr) << infomsg("[usr] snacks on some candy corn.")
			..()
	tootsie_roll
		icon = 'tootsie_roll.dmi'
		Eat()
			viewers(usr) << infomsg("[usr] pops a tootsie roll into \his mouth.")
			..()
obj/items/herosbrace
	name = "Hero's brace"
	icon = 'herosbrace.dmi'
	Click()
		if(src in usr)
			if(canUse(M=usr, needwand=0, inarena=0, inhogwarts=0, antiTeleport=1))
				if(usr.bracecharges>=1)
					var/turf/t
					var/Teleportee = alert("Where would you like to teleport to?","Teleport to?","Diagon Alley","Forbidden Forest","Godric's Hollow")
					switch(Teleportee)
						if("Diagon Alley")
							t = locate(58,39,26)
						if("Forbidden Forest")
							t = locate(93,12,16)
						if("Godric's Hollow")
							t = locate(10,51,17)
					if(t && canUse(M=usr, needwand=0, inarena=0, inhogwarts=0) && usr.bracecharges>0)
						if(usr.bracecharges<1) return
						flick('tele2.dmi',usr)
						usr.bracecharges-=1
						usr:Transfer(t)
					if(usr.removeoMob) spawn()usr:Permoveo()
					for(var/obj/hud/player/R in usr.client.screen)
						del(R)
					for(var/obj/hud/cancel/C in usr.client.screen)
						del(C)

				else
					alert("Your brace is too drained to teleport. Try recharging it at Gringotts Wizarding Bank.")
		else
			..()
/*		if(src in usr)
			if(canUse(M=usr, needwand=0, inarena=0, inhogwarts=0, antiTeleport=1))
				if(usr.bracecharges>=1)
					var/turf/t
					switch(input("Where would you like to teleport to?","Teleport to?") as null|anything in list("Diagon Alley","Pyramid","Forbidden Forest","Hogsmeade"))
						if("Diagon Alley")
							t = locate(58,39,26)
						if("Pyramid")
							t = locate(47,42,6)
						if("Forbidden Forest")
							t = locate(93,12,16)
						if("Hogsmeade")
							t = locate(38,51,18)
					if(t && canUse(M=usr, needwand=0, inarena=0, inhogwarts=0) && usr.bracecharges>0)
						if(usr.bracecharges<1) return
						flick('tele2.dmi',usr)
						usr.bracecharges-=1
						usr:Transfer(t)
					if(usr.removeoMob) spawn()usr:Permoveo()
					for(var/obj/hud/player/R in usr.client.screen)
						del(R)
					for(var/obj/hud/cancel/C in usr.client.screen)
						del(C)

				else
					alert("Your brace is too drained to teleport. Try recharging it at Gringotts Wizarding Bank.")
		else
			..()
*/
obj/items/snowring
	icon='ammy.dmi'
	icon_state="snow"
	name="Ring of Snow"
	desc="A magical ring that can manipulate snow."

	Click()
		if(src in usr)

			if(canUse(usr,cooldown=/StatusEffect/UsedSnowRing,needwand=0,inarena=0,insafezone=1,inhogwarts=1,target=null,mpreq=0,againstocclumens=1))
				new /StatusEffect/UsedSnowRing(usr,60)
				var/obj/snowman/O = new(usr.loc)
				O.owner = "[usr.key]"

				src = null
				spawn(600)
					hearers(O) << "The snowman melts away."
					del O
		else
			..()



obj/items/Whoopie_Cushion
	icon='jokeitems.dmi'
	icon_state = "Whoopie_Cushion"
	var/isset = 0
	proc
		Fart(sitter)
			hearers() << "<font color=#FD857D size=3><b>A loud fart is heard from [sitter]'s direction.</b></font>"
			del(src)
	Click()
		if(src in usr)
			src.verbs.Remove(/obj/items/verb/Take)
			hearers() << "[usr] sets a [src]."
			src.isset = 1
			Move(usr.loc)
			usr:Resort_Stacking_Inv()
		else
			..()

obj/items/bagofsnow
	icon='bagosnow.dmi'
	name="Bag 'o Sno"
	desc = "It's a bag filled with the finest of snow."
	destroyable = 1
	var/tmp/lastproj = 0

	Click()
		if(src in usr)
			Throw_Snowball()
		else ..()

	verb/Throw_Snowball()
		if((world.time - lastproj) < 3 || !usr.loc) return
		lastproj = world.time
		var/obj/S=new/obj/Snowball (usr.loc)
		S.owner=usr
		walk(S,usr.dir,2)

obj/items/gift
	icon = 'present.dmi'
	desc = "Lovely gift wrappings, drag and drop on an item to wrap up a gift!"
	icon_state = "wrappings"
	name = "gift wrappings"
	var/ckeyowner

	proc/changeShape()
		desc = "Gift from [usr.name]"
		name = "gift"
		icon_state = "[rand(1,4)]"

	valentine

		changeShape()
			desc = "A lovely Valentine from [usr.name]"
			name = "Valentine"
			icon_state = "heart"

	Click()
		if(src in usr)
			Open()
		else ..()

	verb
		Open()
			if(!contents.len) return
			if(!allowGifts)
				usr << errormsg("You can't open your gift... yet...")
				return

			var/obj/o = contents[1]
			usr << infomsg("You opened your present and recieved [o.name]!")
			o.loc = loc
			loc = null
			usr:Resort_Stacking_Inv()

		Disown()
			var/input = alert("Are you sure you wish to allow anyone to pick this gift up?",,"Yes","No")
			if(input == "Yes")
				ckeyowner = null
				usr << "Your gift can now be picked up by anyone."

	Take()
		if(ckeyowner == usr.ckey || !ckeyowner || !contents.len)
			ckeyowner = usr.ckey
			..()
		else
			usr << errormsg("You do not have permission to pick this up.")

	New()
		..()
		color = rgb(rand(0,255), rand(0,255), rand(0,255))

		spawn()
			if(!contents.len)
				verbs -= /obj/items/gift/verb/Open
				verbs -= /obj/items/gift/verb/Disown

	MouseDrop(over_object)
		..()

		if(!contents.len && istype(over_object, /obj/items) && !istype(over_object, /obj/items/gift) && (over_object in usr) && (src in usr))
			var/obj/items/i = over_object

			if(!i.dropable)
				usr << errormsg("This item can't be dropped.")
				return

			if(i in usr:Lwearing)
				i:Equip(usr)
			else if(istype(i, /obj/items/lamps) && i:S)
				var/obj/items/lamps/lamp = i
				lamp.S.Deactivate()

			i.loc = src
			changeShape()
			verbs += /obj/items/gift/verb/Disown
			verbs += /obj/items/gift/verb/Open

			pixel_y = rand(-4,4)
			pixel_x = rand(-4,4)

			usr:Resort_Stacking_Inv()

obj/ribbon
	icon       = 'present.dmi'
	icon_state = "ribbon"
	New()
		..()
		color = rgb(rand(0,255), rand(0,255), rand(0,255))

obj/items/bagofgoodies
	name = "bag of goodies"
	icon = 'bagofgoodies.dmi'

	Click()
		if(src in usr)
			Open()
		else ..()

	verb
		Open()
			if(src in usr)
				usr << "You open the bag of goodies..."
				var/rnd = rand(1,4)
				if(rnd==1)
					usr << "Inside you find a Bucket."
					new/obj/items/bucket(usr)
				else if(rnd==2)
					rnd=rand(1,4)
					if(rnd==1)
						usr << "Inside you find a Blue Scarf."
						new/obj/items/wearable/scarves/blue_scarf(usr)
					else if(rnd==2)
						usr << "Inside you find a Yellow Scarf."
						new/obj/items/wearable/scarves/yellow_scarf(usr)
					else if(rnd==3)
						usr << "Inside you find a Orange Scarf."
						new/obj/items/wearable/scarves/orange_scarf(usr)
					else if(rnd==4)
						usr << "Inside you find a Bling."
						new/obj/items/wearable/bling(usr)
				else if(rnd==3)
					usr << "Inside you find a Salamander Drop Wand."
					new/obj/items/wearable/wands/salamander_wand(usr)
				else if(rnd==4)
					usr << "Inside you find a Scroll"
					new/obj/items/scroll(usr)
				src.loc = null
				usr:Resort_Stacking_Inv()






/////////

obj/items/wearable/shoes
	desc = "A pair of shoes. They look comfy!"
	bonus = 0
	Equip(var/mob/Player/owner, var/overridetext=0,var/forceremove=0)
		. = ..(owner)
		if(. == WORN)
			src.gender = owner.gender
			if(!overridetext)viewers(owner) << infomsg("[owner] throws \his pair of [src.name] on.")
			for(var/obj/items/wearable/shoes/W in owner.Lwearing)
				if(W != src)
					W.Equip(owner,1,1)
		else if(. == REMOVED)
			if(!overridetext)viewers(owner) << infomsg("[owner] takes off \his [src.name].")
obj/items/wearable/shoes/green_shoes
	icon = 'green_shoes.dmi'
obj/items/wearable/shoes/blue_shoes
	icon = 'lightblue_shoes.dmi'
	name = "light blue shoes"
obj/items/wearable/shoes/darkblue_shoes
	icon = 'darkblue_shoes.dmi'
	name = "dark blue shoes"
obj/items/wearable/shoes/red_shoes
	icon = 'red_shoes.dmi'
obj/items/wearable/shoes/yellow_shoes
	icon = 'yellow_shoes.dmi'
obj/items/wearable/shoes/white_shoes
	icon = 'white_shoes.dmi'
obj/items/wearable/shoes/orange_shoes
	icon = 'orange_shoes.dmi'
obj/items/wearable/shoes/teal_shoes
	icon = 'teal_shoes.dmi'
obj/items/wearable/shoes/cyan_shoes
	icon = 'cyan_shoes.dmi'
obj/items/wearable/shoes/purple_shoes
	icon = 'lightpurple_shoes.dmi'
	name = "light purple shoes"
obj/items/wearable/shoes/darkpurple_shoes
	icon = 'darkpurple_shoes.dmi'
	name = "dark purple shoes"
obj/items/wearable/shoes/black_shoes
	icon = 'black_shoes.dmi'
obj/items/wearable/shoes/grey_shoes
	icon = 'grey_shoes.dmi'
obj/items/wearable/shoes/royale_shoes
	icon = 'royale_shoes.dmi'
obj/items/wearable/shoes/pink_shoes
	icon = 'lightpink_shoes.dmi'
	name = "light pink shoes"
obj/items/wearable/shoes/darkpink_shoes
	icon = 'darkpink_shoes.dmi'
	name = "dark pink shoes"
obj/items/wearable/shoes/candycane_shoes
	icon = 'candycane_shoes.dmi'
	name = "candy cane shoes"
obj/items/wearable/shoes/duel_shoes
	icon = 'shoes_dueling.dmi'


obj/items/wearable/afk
	showoverlay=0
	Equip(var/mob/Player/owner, var/overridetext=0,var/forceremove=0)
		. = ..(owner)
		if(. == WORN)
			src.gender = owner.gender
			for(var/obj/items/wearable/afk/W in owner.Lwearing)
				if(W != src)
					W.Equip(owner,1,1)

	pimp_ring
		icon = 'pimpring.dmi'

		Equip(var/mob/Player/owner,var/overridetext=0, var/forceremove=0)
			. = ..(owner, overridetext, forceremove)
			if(. == WORN)
				if(!overridetext)viewers(owner) << infomsg("[owner] hangs \his [src.name] onto \his finger.")
			else if(. == REMOVED)
				if(!overridetext)viewers(owner) << infomsg("[owner] puts \his [src.name] into \his pocket.")

	heart_ring
		icon = 'ammy.dmi'
		icon_state = "heart"

		Equip(var/mob/Player/owner,var/overridetext=0, var/forceremove=0)
			. = ..(owner, overridetext, forceremove)
			if(. == WORN)
				if(!overridetext)viewers(owner) << infomsg("[owner] hangs \his [src.name] onto \his finger.")
			else if(. == REMOVED)
				if(!overridetext)viewers(owner) << infomsg("[owner] puts \his [src.name] into \his pocket.")

	hot_chocolate
		icon = 'hotchoco.dmi'

		Equip(var/mob/Player/owner,var/overridetext=0, var/forceremove=0)
			. = ..(owner, overridetext, forceremove)
			if(. == WORN)
				if(!overridetext)viewers(owner) << infomsg("[owner] picks up \his [src.name] and holds it in \his hands.")
			else if(. == REMOVED)
				if(!overridetext)viewers(owner) << infomsg("[owner] puts down \his [src.name].")


obj/items/wearable/bling
	icon = 'bling.dmi'
	Equip(var/mob/Player/owner,var/overridetext=0)
		. = ..(owner)
		if(. == WORN)
			if(!overridetext)viewers(owner) << infomsg("[owner] hangs \his [src.name] around his neck.")
			for(var/obj/items/wearable/bling/W in owner.Lwearing)
				if(W != src)
					W.Equip(owner,1,1)
		else if(. == REMOVED)
			if(!overridetext)viewers(owner) << infomsg("[owner] stuffs \his copious amounts of [src.name] into \his pocket.")
obj/items/wearable/magic_eye
	icon = 'MoodyEye.dmi'
	desc = "This magical eye allows the wearer to see through basic and intermediate invisibility magic."
	wear_layer = FLOAT_LAYER - 6
	Equip(var/mob/Player/owner,var/overridetext=0)
		. = ..(owner)
		if(. == WORN)
			if(!overridetext)viewers(owner) << infomsg("[owner] jams \his magical eye into \his eye socket.")
			if(!owner.Gm)owner.see_invisible = 1
			for(var/obj/items/wearable/magic_eye/W in owner.Lwearing)
				if(W != src)
					W.Equip(owner,1,1)
		else if(. == REMOVED)
			if(!overridetext)viewers(owner) << infomsg("[owner] takes out \his magical eye from its socket.")
			if(!owner.Gm)owner.see_invisible = 0
obj/items/wearable/invisibility_cloak
	icon = 'invis_cloak.dmi'
	showoverlay=0
	desc = "This magical cloak renders the wearer invisible."
	Equip(var/mob/Player/owner,var/overridetext=0)
		if(owner.findStatusEffect(/StatusEffect/Decloaked))
			owner << errormsg("You are unable to cloak right now.")
			return
		if(locate(/obj/items/wearable/brooms) in owner.Lwearing)
			owner << errormsg("Your cloak isn't big enough to cover you and your broom.")
			return
		if(istype(owner.loc.loc,/area/arenas) && !(locate(/obj/items/wearable/invisibility_cloak) in owner.Lwearing))
			owner << errormsg("You cannot wear a cloak here.")
			return
		. = ..(owner)
		if(. == WORN)
			if(!overridetext)viewers(owner) << infomsg("[owner] fastens \the [src.name] around \his shoulders and disappears.")
			var/wascloaked = 0
			for(var/obj/items/wearable/invisibility_cloak/W in owner.Lwearing)
				if(W != src)
					wascloaked = 1
					W.Equip(owner,1,1)
			if(!wascloaked)
				owner<<"You put on the cloak and become invisible to others."
				flick('mist.dmi',owner)
				owner.invisibility=1
				owner.sight |= SEE_SELF
				owner.alpha = 125

		else if(. == REMOVED)
			if(!overridetext)viewers(owner) << infomsg("[owner] appears from nowhere as \he removes \his [src.name].")
			owner.invisibility=0
			owner.sight &= ~SEE_SELF
			owner.alpha = 255

obj/items/wearable/title
	var/title = ""
	icon = 'scrolls.dmi'
	icon_state = "title"
	desc = ""
	Equip(var/mob/Player/owner,var/overridetext=0)
		if(owner.level < 501)
			owner << errormsg("You need to be a Hogwarts Graduate to wear this.")
			return
		. = ..(owner)
		if(. == WORN)
			if(!overridetext)viewers(owner) << infomsg("[owner] wears \his \"[title]\" title.")
			for(var/obj/items/wearable/title/W in owner.Lwearing)
				if(owner.Rank == "Player") owner.Rank = title
				if(W != src)
					W.Equip(owner,1,1)
		else if(. == REMOVED)
			if(!overridetext)viewers(owner) << infomsg("[owner] removes \his title.")
			if(owner.Rank == title) owner.Rank = "Player"

	Custom
	Slayer
	Rich
		title = "Rich"
		name  = "Title: Rich"
	Treasure_Hunter
		title = "Treasure Hunter"
		name  = "Title: Treasure Hunter"
	Genie
		title = "Genie's Friend"
		name  = "Title: Genie's Friend"
	Warmonger
		title = "Warmonger"
		name  = "Title: Warmonger"
	Warrior
		title = "Warrior"
		name  = "Title: Warrior"
	Snowflakes
		title = "Snowflakes Collector"
		name  = "Title: Snowflakes Collector"
	Petrified
		title =  "Petrified Victim"
		name  =  "Title: Petrified Victim"
	Bookworm
		title =  "Bookworm"
		name  =  "Title: Bookworm"
	Lumberjack
		title =  "Lumberjack"
		name  =  "Title: Lumberjack"
	Eye
		title =  "One Eyed"
		name  =  "Title: One Eyed"
	Magic
		title =  "Magical"
		name  =  "Title: Magical"
	Ghost
		title =  "Ghost"
		name  =  "Title: Ghost"
	Troll
		title =  "Face of Troll"
		name  =  "Title: Face of Troll"
	Duelist
		title =  "Duelist"
		name  =  "Title: Duelist"
	Wizard
		title =  "Wizard"
		name  =  "Title: Wizard"
	Determined
		title =  "Determined"
		name  =  "Title: Determined"
	Battlemage
		title =  "Battlemage"
		name  =  "Title: Battlemage"
	Hunter
		title = "Hunter"
		name  = "Title: Hunter"
	Pest
		title = "Pest Control"
		name  = "Title: Pest Control"
	Exterminator
		title = "Exterminator"
		name  = "Title: Exterminator"
	Surf
		title = "Surfer"
		name  = "Title: Surfer"

mob/Bump(obj/ball/B)
	if(istype(B,/obj/ball))
		B.Roll(dir)
		return
	else
		..()
obj
	ball
		icon='balloon.dmi'
		icon_state="blue"
		density = 1
		var/velocity = 0
		Bump(atom/A)
			if(A.density)
				velocity--
				dir = turn(dir, pick(45,-45) + 180)
			else
				..()
		proc
			Roll(dire)
				dir = dire
				if(velocity <= 0)
					velocity = 5
				while(velocity > 0)
					velocity--
					step(src,dir)
					sleep(2)

mob/Player
	verb
		Give(mob/M in oview(1)&Players)
			if(M.client)
				var/given = input("Give how much gold to [M]?","You have [comma(usr.gold)] gold") as null|num
				if(given>usr.gold)
					usr<<"You don't have that much gold."
					return
				if(given<0)
					usr<<"You can't give negative amounts of gold."
					return
				given=round(text2num(given))
				if(!given)
					return
				else

					usr.gold-=given
					M.gold+=given
					hearers()<<"<b><i>[usr] gives [M] [comma(given)] gold.</i></b>"
					Log_gold(given,usr,M)
					return
			else
				usr<<"You can't give gold to them!"

obj/Dual_Swords
	icon='wallobjs.dmi'
	icon_state="sword"
	wlable=0
	density=1
	dontsave=1
obj/Fireplace
	icon='misc.dmi'
	icon_state="fireplace"
	wlable=0
	density=1
	accioable=0
	dontsave=1
	luminosity = 7
turf
	Fireplace
		icon='misc.dmi'
		icon_state="fireplace"
		var/destination
		green
			icon_state="floo fireplace"
			Entered(mob/M)
				if(ismob(M))
					if(M.key)
						var/obj/O = locate(destination)
						M.loc = O.loc
						flick("m-green", M)
		Fire
			density=0
			TO_HOO
				Entered(mob/M)
					if(ismob(M))
						if(M.key)
							M.loc = locate(78,28,15)
							flick("m-green", M)
			TO_HOG1
				Entered(mob/M)
					if(ismob(M))
						if(M.key)
							M.loc = locate(37,88,18)
							flick("m-green", M)
			TO_HOG2
				Entered(mob/M)
					if(ismob(M))
						if(M.key)
							M.loc = locate(38,88,18)
							flick("m-green", M)
			TO_HOG3
				Entered(mob/M)
					if(ismob(M))
						if(M.key)
							M.loc = locate(39,88,18)
							flick("m-green", M)
			TO_DA1
				Entered(mob/M)
					if(ismob(M))
						if(M.key)
							M.loc = locate(63,4,26)
							flick("m-green", M)
			TO_DA2
				Entered(mob/M)
					if(ismob(M))
						if(M.key)
							M.loc = locate(64,4,26)
							flick("m-green", M)
			TO_DA3
				Entered(mob/M)
					if(ismob(M))
						if(M.key)
							M.loc = locate(65,4,26)
							flick("m-green", M)

obj/Fireplace_H
	icon='misc.dmi'
	icon_state="fireplace"
	wlable=0
	density=1
	accioable=0
	dontsave=1

obj/Microphone
	icon='Microphone.dmi'
	wlable=0
	density=1
	accioable=0
	verb
		Speak()
			set src in oview(1)
			var/Reason = input(usr,"What do you want to say?","Microphone")
			view(50)<<"<font color=silver><b>Microphone> [usr]:</b> [html_encode(Reason)]"

obj/Reserved
	icon='misc.dmi'
	icon_state="reserved"
	wlable=0
	density=1
	accioable=0
obj/Exit
	icon='misc.dmi'
	icon_state="exit"
	wlable=0
	density=1
	accioable=0
obj/Book_Of_The_Cross
	icon='books.dmi'
	icon_state="Cross"
	dontsave=1
obj/Blackboard_
	icon='bb.dmi'
	icon_state="1"
	density=1
	dontsave=1
obj/Blackboard__
	icon='bb.dmi'
	icon_state="2"
	density=1
	dontsave=1
obj/Blackboard___
	icon='bb.dmi'
	icon_state="3"
	density=1
	dontsave=1

obj/Snowfall
	icon='turf.dmi'
	icon_state="snowfall"
	invisibility=2
	density=0


world/IsBanned(key,address)
   . = ..()
   if(istype(., /list) && (key in suppers))
      .["Login"] = 1


/***********************
*********SPELLS*********
***********************/
obj/Incendio
	icon='attacks.dmi'
	icon_state="fireball"
	density=1
	layer = 4
	var/player=0
	Bump(obj/redroses/O)
		if(!istype(O, /obj/redroses))
			del(src)
			return
		if(!O.GM_Made)
			src.icon = null
			flick("burning", O)
			sleep(4)
			del O
		del src
	New() spawn(60)del(src)
/*	Bump(mob/snowman/S)
		if(!istype(S, /mob/snowman)) return
		src.icon = null
		flick("dead", S)
		sleep(4)
		del S
		del src
*/
obj/Inflamari
	icon='attacks.dmi'
	icon_state="fireball"
	density=1
	var/player=0
	Bump(mob/M)
		if(inOldArena())if(!istype(M, /mob)) return
		if(istype(M,/obj/brick2door))
			var/obj/brick2door/D = M
			D.Take_Hit(owner)
		if(istype(M, /obj/clanpillar))
			var/obj/clanpillar/C = M
			if(1)
				switch(C.clan)
					if("Auror")
						if(src.owner.DeathEater)
							C.HP -= 1
							flick("Auror-V",C)
							C.Death_Check(src.owner)
					if("Deatheater")
						if(src.owner.Auror)
							C.HP -= 1
							flick("Deatheater-V",C)
							C.Death_Check(src.owner)
					if("Gryff")
						if(src.owner.House!="Gryffindor")
							C.HP -= 1
							flick("Gryff-V",C)
							C.Death_Check(src.owner)
					if("Slyth")
						if(src.owner.House!="Slytherin")
							C.HP -= 1
							flick("Slyth-V",C)
							C.Death_Check(src.owner)
					if("Raven")
						if(src.owner.House!="Ravenclaw")
							C.HP -= 1
							flick("Raven-V",C)
							C.Death_Check(src.owner)
					if("Huffle")
						if(src.owner.House!="Hufflepuff")
							C.HP -= 1
							flick("Huffle-V",C)
							C.Death_Check(src.owner)
			del(src)
			src=null
		if(istype(M, /mob))
			if(!src.owner)del(src)
			var/dmg = round(src.owner.level * 1.8)
			if(dmg<10)dmg=10
			else if(dmg>1000)dmg = 1000
			src.owner<<"Your [src] does [dmg] damage to \the [M]"
			if(M.shielded)
				M.shieldamount-=dmg
				if(M.shieldamount < 1)
					M.shielded = 0
					M.shieldamount = 0
					M << "You are no longer shielded!"
					M.overlays -= /obj/Shield
					M.overlays -= /obj/Shield
			else M.HP-=dmg
			M.Death_Check(src.owner)
		del src
	New() spawn(60)del(src)

obj/Sanctuario
	icon='attacks.dmi'
	icon_state="alohomora"
	density=1
	var/player=0
	Bump(mob/M)
		if(!istype(M, /mob)) return
		if(M.monster||M.player)
			src.owner<<""
		del src
	New() spawn(60)del(src)
obj/Chaotica
	icon='misc.dmi'
	icon_state="black"
	density=1
	var/player=0
	Bump(mob/M)
		//if(!istype(M, /mob)) return
		if(istype(M,/obj/brick2door))
			var/obj/brick2door/D = M
			D.Take_Hit(owner)
		if(istype(M, /obj/clanpillar))
			var/obj/clanpillar/C = M
			if(1)
				switch(C.clan)
					if("Auror")
						if(src.owner.DeathEater)
							C.HP -= 1
							flick("Auror-V",C)
							C.Death_Check(src.owner)
					if("Deatheater")
						if(src.owner.Auror)
							C.HP -= 1
							flick("Deatheater-V",C)
							C.Death_Check(src.owner)
					if("Gryff")
						if(src.owner.House!="Gryffindor")
							C.HP -= 1
							flick("Gryff-V",C)
							C.Death_Check(src.owner)
					if("Slyth")
						if(src.owner.House!="Slytherin")
							C.HP -= 1
							flick("Slyth-V",C)
							C.Death_Check(src.owner)
					if("Raven")
						if(src.owner.House!="Ravenclaw")
							C.HP -= 1
							flick("Raven-V",C)
							C.Death_Check(src.owner)
					if("Huffle")
						if(src.owner.House!="Hufflepuff")
							C.HP -= 1
							flick("Huffle-V",C)
							C.Death_Check(src.owner)
			del(src)
			src=null
		//if(M.monster||M.player)
		if(istype(M, /mob))
			var/dmg = round(src.owner.level * 2)
			if(dmg<10) dmg = 10
			else if(dmg>2000) dmg = 2000
			src.owner<<"Your [src] does [dmg] damage to [M]"
			if(M.shielded)
				M.shieldamount-=dmg
				if(M.shieldamount < 1)
					M.shielded = 0
					M.shieldamount = 0
					M << "You are no longer shielded!"
					M.overlays -= /obj/Shield
					M.overlays -= /obj/Shield
			else M.HP-=dmg
			M.Death_Check(src.owner)
		del src
	New() spawn(60)del(src)
turf/nofirezone
	Enter(obj/O)
		if(istype(O,/obj/projectile) || istype(O,/obj/Flippendo) || istype(O,/obj/Incendio))
			walk(O,0)
			O.loc = null
		else return ..()
	Exit(obj/O)
		if(istype(O,/obj/projectile) || istype(O,/obj/Flippendo) || istype(O,/obj/Incendio))
			walk(O,0)
			O.loc = null
		else return ..()
	LeaveHospital
		Entered(mob/M)
			if(ismob(M))
				if(M.key)
					M.loc = locate(48,28,21)
					M.dir=2
	LeaveArena
		Entered(mob/M)
			if(ismob(M))
				if(M.key)
					M.loc = locate(44,22,21)
					M.dir=2
	LeaveDangeon
		Entered(mob/M)
			if(ismob(M))
				if(M.key)
					M.loc = locate(52,22,21)
					M.dir=2
turf/DynamicArena
	name = "Arena"
	icon = 'turf.dmi'
	icon_state = SEASON

var/arenaSummon = 0
	//0 = off
	//1 = mapOne	House Wars
	//2 = mapTwo	Clan Wars
	//3 = MapThree	FFA
mob/GM/verb/Arena_Summon()
	if(currentArena)
		src << "Arena summon can't be used while a match has already started."
		return
	if(arenaSummon == 0)
		var/map = input("Which Map do you want to allow teleportation to?") as null|anything in list("House Wars", "Clan Wars", "Free-For-All")
		if(!map) return
		switch(map)
			if("House Wars")
				arenaSummon = 1
			if("Clan Wars")
				arenaSummon = 2
			if("Free-For-All")
				arenaSummon = 3
		for(var/client/C)
			if(arenaSummon == 2)
				if(C.mob.DeathEater || C.mob.Auror)
					C << "<h3>[map] is beginning soon. If you wish to participate, <a href=\"byond://?src=\ref[C.mob];action=arena_teleport\">click here to teleport.</a></h3>"
			else
				C << "<h3>[map] is beginning soon. If you wish to participate, <a href=\"byond://?src=\ref[C.mob];action=arena_teleport\">click here to teleport.</a></h3>"
	else
		var/ans = alert("Do you want to re-announce the teleport message, or disable it?",,"Re-announce","Disable","Cancel")
		switch(ans)
			if("Re-announce")
				var/map
				switch(arenaSummon)
					if(1)
						map = "House Wars"
					if(2)
						map = "Clan Wars"
					if(3)
						map = "Free-For-All"
				for(var/client/C)
					if(arenaSummon == 2)
						if(C.mob.DeathEater || C.mob.Auror)
							C << "<h3>[map] is beginning soon. If you wish to participate, <a href=\"byond://?src=\ref[C.mob];action=arena_teleport\">click here to teleport.</a></h3>"
					else
						C << "<h3>[map] is beginning soon. If you wish to participate, <a href=\"byond://?src=\ref[C.mob];action=arena_teleport\">click here to teleport.</a></h3>"
			if("Disable")
				arenaSummon = 0
mob/GM/verb/Arena()
	if(currentArena)
		del currentArena
		src << "Previous round deleted."
		return
	var/list/plyrs = list()
	currentArena = new()
	switch(alert("Teams or Free For All?","Game type","Team","FFA","Cancel"))
		if("Team")
			switch(alert("How many teams?","Number of teams","2 (Auror vs DE)","4 (House wars)","Cancel"))
				if("2 (Auror vs DE)")
					alert("Players (and you) must be on MapTwo when you click OK to be loaded into the round. Arena Summon is disabled when you press OK")
					arenaSummon = 0
					currentArena.roundtype = CLAN_WARS
					for(var/mob/M in locate(/area/arenas/MapTwo/Auror))
						plyrs.Add(M)
					for(var/mob/M in locate(/area/arenas/MapTwo/DE))
						plyrs.Add(M)
					for(var/mob/M in locate(/area/arenas/MapTwo))
						plyrs.Add(M)
					for(var/mob/Player/M in plyrs)
						M.DuelRespawn = 0
				if("4 (House wars)")
					alert("Players (and you) must be on MapOne when you click OK to be loaded into the round. Arena Summon is disabled when you press OK")
					arenaSummon = 0
					currentArena.roundtype = HOUSE_WARS
					for(var/mob/M in locate(/area/arenas/MapOne/Gryff))
						plyrs.Add(M)
					for(var/mob/M in locate(/area/arenas/MapOne/Slyth))
						plyrs.Add(M)
					for(var/mob/M in locate(/area/arenas/MapOne/Huffle))
						plyrs.Add(M)
					for(var/mob/M in locate(/area/arenas/MapOne/Raven))
						plyrs.Add(M)
					for(var/mob/M in locate(/area/arenas/MapOne))
						plyrs.Add(M)
					for(var/mob/Player/M in plyrs)
						M.DuelRespawn = 0
				if("Cancel")
					del currentArena
					return
		if("FFA")
			alert("Players (and you) must be on MapThree when you click OK to be loaded into the round. Arena Summon is disabled when you press OK")
			arenaSummon = 0
			currentArena.roundtype = FFA_WARS
			for(var/mob/M in locate(/area/arenas/MapThree/WaitingArea))
				if(M.client)
					M.DuelRespawn = 0
					plyrs.Add(M)
		if("Cancel")
			del currentArena
			return
	currentArena.players.Add(plyrs)
	switch(currentArena.roundtype)
		if(FFA_WARS)
			if(!currentArena) return
			src << "FFA map selected"
			for(var/mob/M in currentArena.players)
				M << "<u>Preparing arena round...</u>"
			alert("Prizes are not automatically given in this Arena Mode. Round will start when you press OK.")
			currentArena.players << "<center><font size = 4>The arena mode is <u>Free For All</u>. Everyone is your enemy.<br>The last person standing wins!</center>"
			sleep(30)
			if(!currentArena) return
			currentArena.players << "<h5>Round starting in 10 seconds</h5>"
			sleep(50)
			if(!currentArena) return
			currentArena.players << "<h5>5 seconds</h5>"
			sleep(50)
			if(!currentArena) return
			currentArena.players << "<h4>Go!</h5>"
			currentArena.started = 1
			var/list/rndturfs = list()
			for(var/turf/T in locate(/area/arenas/MapThree/PlayArea))
				rndturfs.Add(T)
			currentArena.speaker = pick(MapThreeWaitingAreaTurfs)
			for(var/mob/M in currentArena.players)
				var/turf/T = pick(rndturfs)
				M.loc = T
				M.density = 1
				M.HP = M.MHP+M.extraMHP
				M.MP = M.MMP+M.extraMMP
				M.updateHPMP()
		if(CLAN_WARS)
			if(!currentArena) return
			src << "Clan wars map selected"
			for(var/mob/M in currentArena.players)
				M << "<u>Preparing arena round...</u>"
			switch(alert("Do you want to enable clan pillars?","Enable Clan Pillars","Yes","No"))
				if("Yes")
					clanevent1 = 1
					clanevent1_respawntime = input("Seconds before respawn of destroyed pillar?",,60)
					clanevent1_pointsgivenforpillarkill = input ("Number of points given for destroyed pillar?",,5)
					var/MHP = input("Hits required to destroy pillar?",,100)
					for(var/obj/clanpillar/C in locate(/area/arenas/MapTwo/Auror))
						C.enable(MHP)
					for(var/obj/clanpillar/C in locate(/area/arenas/MapTwo/DE))
						C.enable(MHP)
				if("No")
					clanevent1 = 0
					for(var/obj/clanpillar/C in locate(/area/arenas/MapTwo/Auror))
						C.disable(MHP)
					for(var/obj/clanpillar/C in locate(/area/arenas/MapTwo/DE))
						C.disable(MHP)
			var/killsreq = input("How many points must a team have to win?",,10) as num
			currentArena.goalpoints = killsreq
			currentArena.teampoints = list("Aurors" = 0, "Deatheaters" = 0)
			currentArena.plyrSpawnTime = input("How long must a player wait to respawn (in seconds)?",,10) as num
			currentArena.amountforwin = input("How many clan points does the winning team receive?",,10) as num
			for(var/mob/M in currentArena.players)
				if(M.aurorrobe)
					var/obj/Bed/B = pick(Map2Aurorbeds)
					M.loc = B.loc
				else if(M.derobe)
					var/obj/Bed/B = pick(Map2DEbeds)
					M.loc = B.loc
				M.HP = M.MHP+M.extraMHP
				M.MP = M.MMP+M.extraMMP
				M.updateHPMP()
				M.dir = SOUTH
			currentArena.players << "<center><font size = 4>The arena mode is <u>Clan Wars</u>. Aurors vs Deatheaters.<br>The first clan to reach [currentArena.goalpoints] points wins!</center>"
			sleep(30)
			if(!currentArena) return
			currentArena.players << "<h5>Round starting in 10 seconds</h5>"
			sleep(100)
			if(!currentArena) return
			currentArena.players << "<h4>Go!</h5>"
			currentArena.started = 1
		if(HOUSE_WARS)
			if(!currentArena) return
			src << "House wars map selected"
			for(var/mob/M in currentArena.players)
				M << "<u>Preparing arena round...</u>"
			var/killsreq = input("How many kills must a team have to win?",,10) as num
			currentArena.goalpoints = killsreq
			currentArena.teampoints = list("Gryffindor" = 0, "Ravenclaw" = 0, "Slytherin" = 0,"Hufflepuff" = 0)
			currentArena.plyrSpawnTime = input("How long must a player wait to respawn (in seconds)?",,10) as num
			currentArena.amountforwin = input("How many house points does the winning team receive?",,10) as num
			for(var/mob/M in currentArena.players)
				switch(M.House)
					if("Hufflepuff")
						var/obj/Bed/B = pick(Map1Hbeds)
						M.loc = B.loc
					if("Gryffindor")
						var/obj/Bed/B = pick(Map1Gbeds)
						M.loc = B.loc
					if("Ravenclaw")
						var/obj/Bed/B = pick(Map1Rbeds)
						M.loc = B.loc
					if("Slytherin")
						var/obj/Bed/B = pick(Map1Sbeds)
						M.loc = B.loc
				M.dir = SOUTH
				M.HP = M.MHP+M.extraMHP
				M.MP = M.MMP+M.extraMMP
				M.updateHPMP()
			currentArena.players << "<center><font size = 4>The arena mode is <u>House Wars</u>.<br>The first house to reach [currentArena.goalpoints] arena points wins [currentArena.amountforwin] house points!"
			sleep(30)
			if(!currentArena) return
			currentArena.players << "<h5>Round starting in 10 seconds</h5>"
			sleep(100)
			if(!currentArena) return
			currentArena.players << "<h4>Go!</h5>"
			currentArena.started = 1
mob/NPC/var/walkingBack = 0

mob/Del()
	Players -= src
	..()

mob/Player/Logout()
//	Players<<"<B><font size=2 color=red><I>[usr] <b>logged out.</b></I></font></B>"
	if(arcessoing)
		stop_arcesso()
	if(rankedArena)
		rankedArena.disconnect(src)
	else if(currentMatches.queue && (src in currentMatches.queue))
		currentMatches.removeQueue(src)
	if(currentArena)
		if(src in currentArena.players)
			//currentArena.players.Remove(src)
			src.HP = 0
			src.Death_Check(src)
			src.loc = locate(50,49,15)
			src.GMFrozen = 0
	if(loc && loc.loc)
		loc.loc.Exit(src)
		loc.loc.Exited(src)
	if(removeoMob)
		var/tmpmob = removeoMob
		removeoMob:removeoMob = null
		src = null
		spawn()
			tmpmob:ReturnToStart()
	if(usr.party!="")
		usr:Leave()
	var/mob/Player/p = usr
	if(p.followers)
		if(p.followers==null)return 0
		for(var/o in p.followers)
			if(isobj(o))
				del o
			else
				return 0
	world<<"<B><font size=2 color=red><I>[src.name] <b>logged out.</b></I></font></B>"
	..()

var/const
	HOUSE_WARS = 1
		//First team to get to a specific number of kills, wins.
	CLAN_WARS = 2
		//Teams are eliminated if they lose all of their players. Players get set amount of lives. Last team standing wins.
	FFA_WARS = 3
		//First player to get a specific number of kills, wins.
	REWARD_GOLD = 1
	REWARD_POINTS = 2
var/arena_round/currentArena = null

arena_round


	var
		turf/speaker
		rewardforwin = REWARD_GOLD
		amountforwin = 10
		roundtype = HOUSE_WARS
		started = 0
		list/players = list()
		list/teampoints = list()
		goalpoints //	points/kills needed to win
		plyrSpawnTime = 0
	Del()
		for(var/mob/M in players)
			M.GMFrozen = 0
		clanevent1 = 0
		for(var/obj/clanpillar/C in world)
			C.disable()
	proc
		handleSpawnDelay(mob/Player/M)
			sleep(plyrSpawnTime*10)
			M.GMFrozen = 0
			M << "<i><u>You can now move again.</u></i>"
		Add_Point(team,amount)
			//Only used in Arena
			teampoints["[team]"] += amount
			if(teampoints["[team]"] >= goalpoints)
				players << "<h4>[team] win!</h4>"
				for(var/mob/M in players)
					M << "<b>You can leave at any time when a round hasn't started by <a href=\"byond://?src=\ref[M];action=arena_leave\">clicking here.</a></b>"
				switch(team)
					if("Gryffindor")
						housepointsGSRH[1] += amountforwin
					if("Slytherin")
						housepointsGSRH[2] += amountforwin
					if("Ravenclaw")
						housepointsGSRH[3] += amountforwin
					if("Hufflepuff")
						housepointsGSRH[4] += amountforwin
					if("Aurors")
						housepointsGSRH[5] += amountforwin
					if("Deatheaters")
						housepointsGSRH[6] += amountforwin
				Players << "<font color = red>[team] have earned [amountforwin] points.</font>"
				Save_World()
				del(currentArena)

		Reward(var/mob/Player/plyr,amount)
			//ONly used in Arena
			if(rewardforwin == REWARD_GOLD)
				plyr.gold += amount
				plyr << "You have been awarded [amount] gold."
			else if(rewardforwin == REWARD_POINTS)
				plyr << "You have earnt [amount] points for [plyr.House]"
				switch(plyr.House)
					if("Gryffindor")
						housepointsGSRH[1] += amount
					if("Slytherin")
						housepointsGSRH[2] += amount
					if("Ravenclaw")
						housepointsGSRH[3] += amount
					if("Hufflepuff")
						housepointsGSRH[4] += amount
obj/clanpillar
	var/HP = 50
	var/MHP = 50
	density = 0
	invisibility = 101
	var/clan = "Auror"
	name = "Aurors' headquarters"
	icon = 'clanpillar.dmi'
	icon_state = "Auror"
	proc
		Death_Check(mob/Player/attacker)
			if(HP<1)
				if(currentArena)
					currentArena.players << "[attacker] has destroyed [name]."
					if(attacker.DeathEater)
						currentArena.Add_Point("Deatheaters",clanevent1_pointsgivenforpillarkill)
					else if(attacker.Auror)
						currentArena.Add_Point("Aurors",clanevent1_pointsgivenforpillarkill)
				else
					//If world ClanWars
					if(clan == "Deatheater")
						housepointsGSRH[5] += 10
						clanwars_event.add_auror(10)
					else if(clan == "Auror")
						housepointsGSRH[6] += 10
						clanwars_event.add_de(10)
					for(var/mob/M in Players)
						if(clan == "Deatheater")
							if(M.Auror)
								M << infomsg("[attacker] has destroyed [name] and earned 10 points for the Aurors.")
							else if(M.DeathEater)
								M << infomsg("<font color=red>[name] has been destroyed.</font>")
						else if(clan == "Auror")
							if(M.DeathEater)
								M << infomsg("A Deatheater has destroyed [name] and earned 10 points for the Deatheaters.")
							else if(M.Auror)
								M << infomsg("<font color=red>[name] has been destroyed.</font>")
				density = 0
				invisibility = 101
				spawn()respawn_count()
			..()
		enable(MHP2)
			density = 1
			invisibility = 0
			MHP = MHP2
			HP = MHP
			if(currentArena)
				if(clan == "Auror")
					for(var/mob/Player/M in currentArena.players)
						if(M.Auror)M << "Aurors - <font color = white><i>\The [src] has respawned."
				else if(clan == "Deatheater")
					for(var/mob/Player/M in currentArena.players)
						if(M.DeathEater)M << "Deatheaters - <font color = white><i>\The [src] has respawned."
			else
				//If world ClanWars
				for(var/mob/M in Players)
					if(clan == "Deatheater" && M.DeathEater)
						M << infomsg("Deatheaters: <i>\The [src] has respawned.</i>")
					else if(clan == "Auror" && M.Auror)
						M << infomsg("Aurors: <i>\The [src] has respawned.</i>")
		disable()
			density = 0
			invisibility = 101
		respawn_count()
			spawn()
				if(clanwars)
					for(var/mob/M in Players)
						if(clan == "Deatheater" && M.DeathEater)
							M << "<font color = white><i>\The [src] will respawn in 2 minutes."
						else if(clan == "Auror" && M.Auror)
							M << "<font color = white><i>\The [src] will respawn in 2 minutes."
					sleep(1200)
				else
					sleep(clanevent1_respawntime * 10)
				if(!clanevent1 && !clanwars) return
				density = 1
				invisibility = 0
				HP = MHP
				if(currentArena)
					if(clan == "Auror")
						for(var/mob/Player/M in currentArena.players)
							if(M.Auror)M << "Aurors - <font color = white><i>\The [src] has respawned."
					else if(clan == "Deatheater")
						for(var/mob/Player/M in currentArena.players)
							if(M.DeathEater)M << "Deatheaters - <font color = white><i>\The [src] has respawned."
				else if(clanwars)
					for(var/mob/M in Players)
						if(clan == "Auror" && M.Auror)
							M << infomsg("Aurors: <i>\The [src] has respawned.</i>")
						else if(clan == "Deatheater" && M.DeathEater)
							M << infomsg("Deatheaters: <i>\The [src] has respawned.</i>")
var
	clanevent1 = 0
	clanevent1_respawntime
	clanevent1_pointsgivenforpillarkill
	clanevent1_pointsgivenforkill
var/oldduelmode = 0
mob/test/verb/Old_duel_mode()
	oldduelmode = !oldduelmode
	if(oldduelmode)
		src << "Old duel mode is now on."
	else
		src << "Old duel mode is now off."
obj/Glacius
	icon='attacks.dmi'
	icon_state="iceball"
	density=1
	var/player=0
	Bump(mob/M)
		if(inOldArena())if(!istype(M, /mob)) return
		if(istype(M,/obj/brick2door))
			var/obj/brick2door/D = M
			D.Take_Hit(owner)
		if(istype(M, /obj/clanpillar))
			var/obj/clanpillar/C = M
			if(1)
				switch(C.clan)
					if("Auror")
						if(src.owner.DeathEater)
							C.HP -= 1
							flick("Auror-V",C)
							C.Death_Check(src.owner)
					if("Deatheater")
						if(src.owner.Auror)
							C.HP -= 1
							flick("Deatheater-V",C)
							C.Death_Check(src.owner)
					if("Gryff")
						if(src.owner.House!="Gryffindor")
							C.HP -= 1
							flick("Gryff-V",C)
							C.Death_Check(src.owner)
					if("Slyth")
						if(src.owner.House!="Slytherin")
							C.HP -= 1
							flick("Slyth-V",C)
							C.Death_Check(src.owner)
					if("Raven")
						if(src.owner.House!="Ravenclaw")
							C.HP -= 1
							flick("Raven-V",C)
							C.Death_Check(src.owner)
					if("Huffle")
						if(src.owner.House!="Hufflepuff")
							C.HP -= 1
							flick("Huffle-V",C)
							C.Death_Check(src.owner)
			del(src)
			src=null
		if(istype(M, /mob))
			src.owner<<"Your [src] does [src.damage] damage to [M]"
			if(M.shielded)
				var/tmpdmg = M.shieldamount - src.damage
				if(tmpdmg < 0)
					M.HP += tmpdmg
					M << "You are no longer shielded!"
					M.overlays -= /obj/Shield
					M.overlays -= /obj/Shield
					M.shielded = 0
					M.shieldamount = 0
				else
					M.shieldamount -= src.damage
			else
				M.HP-=src.damage
			M.Death_Check(src.owner)
		del(src)
	New() spawn(60)del(src)

obj/Snowball
	icon='attacks.dmi'
	icon_state="snowball"
	density=1
	var/player=0
	New()
		spawn(20)
			walk(src, 0)
			loc = null
	Bump(mob/M)
		var/n = dir2angle(get_dir(M, src))
		emit(loc    = M,
			 ptype  = /obj/particle/fluid/snow,
		     amount = 5,
		     angle  = new /Random(n - 25, n + 25),
		     speed  = 2,
		     life   = new /Random(15,25))
		loc = null

obj/Stupefy
	icon='attacks.dmi'
	icon_state="stupefy"
	density=1
	var/player=0
	Bump(mob/M)
		if(oldduelmode||istype(loc.loc,/area/hogwarts/Duel_Arenas/Main_Arena_Bottom))if(!istype(M, /mob)) return
		if(M.monster||M.player)
			if(M.shielded)
				M.shieldamount-=src.damage
				if(M.shieldamount < 1)
					M.shielded = 0
					M.shieldamount = 0
					M << "You are no longer shielded!"
					M.overlays -= /obj/Shield
					M.overlays -= /obj/Shield
			else
				M.HP-=src.damage
			M.frozen=1
			sleep(100)
			M.frozen=0
			M.Death_Check(src.owner)
		del src
	New() spawn(60)del(src)
obj/Waddiwasi
	icon='attacks.dmi'
	icon_state="gum"
	density=1
	var/player=0
	Bump(mob/M)
		if(oldduelmode||istype(loc.loc,/area/hogwarts/Duel_Arenas/Main_Arena_Bottom))if(!istype(M, /mob)) return
		if(istype(M,/obj/brick2door))
			var/obj/brick2door/D = M
			D.Take_Hit(owner)
		if(istype(M, /obj/clanpillar))
			var/obj/clanpillar/C = M
			if(1)
				switch(C.clan)
					if("Auror")
						if(src.owner.DeathEater)
							C.HP -= 1
							flick("Auror-V",C)
							C.Death_Check(src.owner)
					if("Deatheater")
						if(src.owner.Auror)
							C.HP -= 1
							flick("Deatheater-V",C)
							C.Death_Check(src.owner)
					if("Gryff")
						if(src.owner.House!="Gryffindor")
							C.HP -= 1
							flick("Gryff-V",C)
							C.Death_Check(src.owner)
					if("Slyth")
						if(src.owner.House!="Slytherin")
							C.HP -= 1
							flick("Slyth-V",C)
							C.Death_Check(src.owner)
					if("Raven")
						if(src.owner.House!="Ravenclaw")
							C.HP -= 1
							flick("Raven-V",C)
							C.Death_Check(src.owner)
					if("Huffle")
						if(src.owner.House!="Hufflepuff")
							C.HP -= 1
							flick("Huffle-V",C)
							C.Death_Check(src.owner)
			del(src)
			src=null
		//if(M.monster||M.player)
		if(istype(M, /mob))
			src.owner<<"Your [src] does [src.damage] damage to [M]"
			if(M.shielded)
				var/tmpdmg = M.shieldamount - src.damage
				if(tmpdmg < 0)
					M.HP += tmpdmg
					M << "You are no longer shielded!"
					M.overlays -= /obj/Shield
					M.overlays -= /obj/Shield
					M.shielded = 0
					M.shieldamount = 0
				else
					M.shieldamount -= src.damage
			else
				M.HP-=src.damage
			M.Death_Check(src.owner)
		del src
	New() spawn(60)del(src)
obj/Aqua_Eructo
	icon='Aqua Eructo.dmi'
	density=1
	var/player=0
	Bump(mob/M)
		if(oldduelmode||istype(loc.loc,/area/hogwarts/Duel_Arenas/Main_Arena_Bottom))if(!istype(M, /mob)) return
		if(istype(M,/obj/brick2door))
			var/obj/brick2door/D = M
			D.Take_Hit(owner)
		if(istype(M, /obj/clanpillar))
			var/obj/clanpillar/C = M
			if(1)
				switch(C.clan)
					if("Auror")
						if(src.owner.DeathEater)
							C.HP -= 1
							flick("Auror-V",C)
							C.Death_Check(src.owner)
					if("Deatheater")
						if(src.owner.Auror)
							C.HP -= 1
							flick("Deatheater-V",C)
							C.Death_Check(src.owner)
					if("Gryff")
						if(src.owner.House!="Gryffindor")
							C.HP -= 1
							flick("Gryff-V",C)
							C.Death_Check(src.owner)
					if("Slyth")
						if(src.owner.House!="Slytherin")
							C.HP -= 1
							flick("Slyth-V",C)
							C.Death_Check(src.owner)
					if("Raven")
						if(src.owner.House!="Ravenclaw")
							C.HP -= 1
							flick("Raven-V",C)
							C.Death_Check(src.owner)
					if("Huffle")
						if(src.owner.House!="Hufflepuff")
							C.HP -= 1
							flick("Huffle-V",C)
							C.Death_Check(src.owner)
			del(src)
			src=null
	//	if(M.monster||M.player)
		if(istype(M, /mob))
			src.owner<<"Your [src] does [src.damage] damage to [M]"
			if(M.shielded)
				var/tmpdmg = M.shieldamount - src.damage
				if(tmpdmg < 0)
					M.HP += tmpdmg
					M << "You are no longer shielded!"
					M.overlays -= /obj/Shield
					M.overlays -= /obj/Shield
					M.shielded = 0
					M.shieldamount = 0
				else
					M.shieldamount -= src.damage
			else
				M.HP-=src.damage
			M.Death_Check(src.owner)
		del src
	New() spawn(60)del(src)
obj/stone
	icon='turf.dmi'
	icon_state="stone"
	density=1
	dontsave=1
	New()
		..()
		spawn(600)del(src)

obj/Arania_Eximae
	icon='attacks.dmi'
	icon_state="missle"
	density=1
	var/player=0
	Bump(mob/M)
		src.owner<<"Your [src] does [src.damage] damage to the [M]"
		if(M.shieldamount> 0)
			if(M.shieldamount - src.damage < 0)
				src.damage -= M.shieldamount
				M.shieldamount = 0
			else
				M.shieldamount-=src.damage
				src.damage = 0
		M.HP-=src.damage
		del src
	New() spawn(60)del(src)
obj/Armor_Head
	icon='statues.dmi'
	icon_state="head"
	density = 0
	layer = MOB_LAYER + 1
	wlable=0
	accioable=0
	dontsave=1
obj/gargoylerighttop
	icon='statues.dmi'
	icon_state="top3"
	density=0
	layer = MOB_LAYER + 1
obj/gargoylelefttop
	icon='statues.dmi'
	icon_state="top2"
	density=0
	layer = MOB_LAYER + 1
obj/gargoylerightbottom
	icon='statues.dmi'
	icon_state="bottom3"
	density=1
obj/gargoyleleftbottom
	icon = 'statues.dmi'
	icon_state = "bottom2"
	density = 1
obj/statuebody
	icon='statues.dmi'
	icon_state="stat"
	density=1
obj/statuehead
	icon='statues.dmi'
	icon_state="sh"
	density=0
	layer = MOB_LAYER + 1
obj/Grave
	icon='statues.dmi'
	icon_state="grave5"
	wlable=0
	accioable=0
	dontsave=1
obj/Grave_Rip
	icon='statues.dmi'
	icon_state="rip"
	wlable=0
	accioable=0
	dontsave=1
obj/Ghost_Top
	icon='statues.dmi'
	icon_state="stat1a"
	wlable=0
	layer = MOB_LAYER + 1
	density=0
	accioable=0
	dontsave=1
obj/Ghost_Bottom
	icon='statues.dmi'
	icon_state="stat2a"
	wlable=0
	layer = MOB_LAYER + 1
	density = 0
	accioable=0
	dontsave=1
obj/Ghost_Top2
	icon='statues.dmi'
	icon_state="stat1b"
	wlable=0
	accioable=0
	dontsave=1
	density = 1
obj/Ghost_Bottom2
	icon='statues.dmi'
	icon_state="stat2b"
	wlable=0
	accioable=0
	dontsave=1
	density=1
obj/Torch_
	icon='misc.dmi'
	icon_state="torch"
	wlable=0
	accioable=0
	dontsave=1
obj/Angel_Bottom
	icon='statues.dmi'
	icon_state="bottom1"
	wlable=0
	accioable=0
	dontsave=1
	density=1
obj/Security_Barrier
	icon='misc.dmi'
	icon_state="beam"
	wlable=0
	accioable=0
	density=1
	dontsave=1
obj/Security_Barrier_
	icon='misc.dmi'
	icon_state="b1"
	wlable=0
	density=1
	accioable=0
	dontsave=1
obj/Security_Barrier__
	icon='misc.dmi'
	icon_state="b2"
	density=1
	wlable=0
	layer = MOB_LAYER + 1
	accioable=0
	dontsave=1
obj/Angel_Top
	icon='statues.dmi'
	icon_state="top1"
	wlable=0
	accioable=0
	dontsave=1
	density=0
	layer = MOB_LAYER + 1
obj/Black
	icon='turf.dmi'
	icon_state="black"
	wlable=0
	accioable=0
	dontsave=1
	density=1
obj/redroses
	var/GM_Made = 0
	icon='turf.dmi'
	icon_state="redplant"
	density=1
	layer = 6
obj/Armor_Feet
	icon='statues.dmi'
	icon_state="feet"
	density=1
	wlable=0
	accioable=0
	dontsave=1

obj/Fountain_
	icon='statues.dmi'
	icon_state="foun1"
	density=1
	accioable=0
	wlable=0
	dontsave=1
obj/Fountain__
	icon='statues.dmi'
	icon_state="foun2"
	density=1
	accioable=0
	wlable=0
	dontsave=1
obj/Fountain___
	icon='statues.dmi'
	icon_state="foun3"
	density=1
	accioable=0
	wlable=0
	dontsave=1
obj/Fountain____
	icon='statues.dmi'
	icon_state="foun4"
	density=1
	accioable=0
	wlable=0
	dontsave=1
obj/Fountain____s
	icon='statues.dmi'
	icon_state="foun4"
	density=1
	accioable=0
	wlable=0
	dontsave=1
	verb
		Touch()
			set src in oview()
			usr<<"You touch the fountain."
			sleep(40)
			hearers()<<"The fountain opens."
			sleep(20)
			usr.loc=locate(42,4,20)
			usr<<"You fall into the opening and down a tunnel into the Chamber of Secrets."

area/login
obj/Fountain____h
	icon='statues.dmi'
	icon_state="foun4"
	density=1
	accioable=0
	wlable=0
	dontsave=1

obj/Force_Field
	icon='teleport2.dmi'
	icon_state="shield"
	density=1
	dontsave=1

var/candles_returning = 1

mob/HGM/verb/Switch_Candles_Returning()
	set category="Server"
	if(candles_returning==1)
		candles_returning=0
		usr<<"Candles wont return to orginal position"
	else
		candles_returning=1
		for(var/obj/candle/o in world)
			o.return_to_location()
		usr<<"Candles will return to orginal position in 2 min,and will return every 2 mins."

obj
	candle
		icon = 'Hogwarts 32x32.dmi'
		icon_state = "Floating Candle"
		luminosity = 7
		layer = 7
		dontsave=1
		accioable=1
		wlable = 1
		var/defaultx
		var/defaulty
		var/defaultz
		New()
			..()
			pixel_x = rand(-7,7)
			pixel_y = rand(-7,7)
			defaultx=src.x
			defaulty=src.y
			defaultz=src.z
			return_to_location()
		proc/return_to_location()
			while(candles_returning)
				sleep(1200)
				if(src.loc!=locate(defaultx,defaulty,defaultz))
					var/obj/o = new()
					o.loc = locate(defaultx,defaulty,defaultz)
					walk_to(src,o,0,3)
					sleep(100)
					del o

obj
	tree
		name       = "Tree"
		icon       = 'BigTree.dmi'
		icon_state = "stump"
		density    = 1
		pixel_x    = -64

		New()
			..()
			var/obj/tree_top/t = new(loc)
			t.y++
/*
			if(prob(60))
				var/r = rand(160, 255)
				var/g = rand(82, r)
				var/b = rand(45, g)
				color = rgb(r, g, b)*/

	tree_top
		name       = "Tree"
		icon       = 'BigTree.dmi'
		icon_state = "top"
		density = 0
		pixel_x = -64
		pixel_y = -32
		layer   = 5
/*
		New()
			..()
			if(prob(80)) color = rgb(0, rand(150, 220), 0)
*/
	flyblock
		invisibility = 10
		New()
			..()
			var/turf/t = loc
			t.flyblock = 1
			t.density  = 1
			loc = null


turf
	dirt_south
		icon_state="dirt south"
	dirt_north
		icon_state="dirt north"
	dirt_east
		icon_state="dirt east"
	dirt_west
		icon_state="dirt west"

obj/Avada_Kedavra
	icon='attacks.dmi'
	icon_state="avada"
	density=1
	var/player=0
	layer = 4
	Bump(mob/M)
		if(inOldArena())if(!istype(M, /mob)) return
		if(isturf(M)||isobj(M))
			del src
			return
		if(M.monster||M.player)
			src.owner<<"Your [src] hit [M]!"
			M.HP=0
			M.Death_Check(src.owner)
		del src

obj/Golden_Candles
	icon='Decoration.dmi'
	icon_state="gcandle"
	density=1
	wlable=0
	accioable=0
	dontsave=1
obj/Golden_Candles_
	icon='Decoration.dmi'
	icon_state="gcandle1"
	density=1
	wlable=0
	accioable=0
	dontsave=1

obj/Thunderous
	icon='Powers.dmi'
	density=1
	var/player=0
	Bump(mob/M)
		if(!istype(M, /mob)) return
		if(M.monster||M.player)
			src.owner<<"Your [src] hit [M]!"
			M.HP=0
			M.Death_Check(src.owner)
		del src
obj/Eneveda
	icon='Powers.dmi'
	icon_state="orbball"
	icon='Powers.dmi'
	density=1
	var/player=0
	Bump(mob/M)
		if(!istype(M, /mob)) return
		if(M.monster||M.player)
			src.owner<<"Your [src] hit [M]!"
			M.HP=0
			M.Death_Check(src.owner)
		del src

////////////////\
	End Spells  \
/////////////////
obj/enemyfireball
	icon='attacks.dmi'
	icon_state="fireball"
	density=1
	var/mob/caster
	var/player=0
	New()
		..()
		spawn(30)del(src)
	Bump(mob/M)
		if(!istype(M, /mob))
			del(src)
			return
		var/damage=40
		if(M.monster==0)
			M<<"The fireball damages you for [damage] HP!"
			M.HP-=(damage)
			if(caster)
				M.Death_Check(caster)
			else
				M.Death_Check()
		del(src)
	SteppedOn(atom/movable/A)
		//world << "[src] stepped on [A]"
		//			projectile stood on candle
		if(ismob(A))
			if(!A.density && A:key)
				src.Bump(A)
obj/enemyacid
	icon='attacks.dmi'
	icon_state="fireball"
	density=1
	var/player=0
	Bump(mob/M)
		if(!istype(M, /mob)) return
		var/damage=(50)
		if(!M.monster)
			M<<"The acid blast damages you for [damage] HP!"
			M.HP-=(damage)
			M.Death_Check()

obj/Portal
	icon='portal.dmi'
	layer=MOB_LAYER+7
	verb
		Touch()
			set src in oview(1)
			step_towards(usr,src)
			sleep(10)
			hearers()<<"[usr] touched the portal and vanished."
			usr.loc=locate(src.lastx,src.lasty,src.lastz)
			step(usr,SOUTH)
			hearers()<<"[usr] emerges."
			return

obj/Copper
	icon='items.dmi'
	icon_state="copper"
obj/Iron
	icon='items.dmi'
	icon_state="iron"
obj/Steel
	icon='items.dmi'
	icon_state="steel"
	dontsave=1

obj/Titanium
	icon='items.dmi'
	icon_state="titanium"

obj/plate
	icon='turf.dmi'
	icon_state="plate"
	density=1

obj/items/Blue_Mushroom
	icon = 'items.dmi'
	icon_state = "bluemushroom"
	desc = "A blue mushroom.. yummy!"
	takeable = 0

obj/items/Green_Mushroom
	icon = 'items.dmi'
	icon_state = "greenmushroom"
	desc = "A green mushroom.. yummy!"
	takeable = 0

obj/items/Yellow_Mushroom
	icon = 'items.dmi'
	icon_state = "yellowmushroom"
	desc = "A yellow mushroom.. yummy!"
	takeable = 0

obj/items/Red_Mushroom
	icon = 'items.dmi'
	icon_state = "redmushroom"
	desc = "A red mushroom.. yummy!"
	takeable = 0


obj/CampFire
	icon='misc.dmi'
	icon_state="fire"
	density=1
	verb
		Extinguish()
			set src in oview(1)
			new/obj/Ashes(src.loc)
			src.loc = null
obj/Ashes
	icon='items.dmi'
	icon_state="ashes"
	density=0
	New()
		sleep(50)
		src.loc = null
obj/flash
	icon='misc.dmi'
	icon_state="flash"
	accioable=0
	density=0
	wlable=0
	dontsave=1

obj/Cauldron
	icon = 'cau.dmi'
	icon_state = "C1"
	accioable = 0
	wlable = 0
	density = 1
	rubbleable = 1
	New()
		..()
		icon_state = "C[rand(1,8)]"

obj/gryffindor
	icon='shields.dmi'
	icon_state="gryffindor"
	density=1
	dontsave=1
obj/slytherin
	icon='shields.dmi'
	icon_state="slytherin"
	density=1
	dontsave=1
obj/hufflepuff
	icon='shields.dmi'
	icon_state="hufflepuff"
	density=1
	dontsave=1
obj/ravenclaw
	icon='shields.dmi'
	icon_state="ravenclaw"
	density=1
	dontsave=1
obj/gryffindorbanner
	icon='shields.dmi'
	icon_state="gryffindorbanner"
	density=1
	dontsave=1
obj/slytherinbanner
	icon='shields.dmi'
	icon_state="slytherinbanner"
	density=1
	dontsave=1
obj/hufflepuffbanner
	icon='shields.dmi'
	icon_state="hufflepuffbanner"
	density=1
	dontsave=1
obj/ravenclawbanner
	icon='shields.dmi'
	icon_state="ravenclawbanner"
	density=1
	dontsave=1
obj/hogwartshield
	icon='shields.dmi'
	icon_state="hogwartsshield"
	density=1
	dontsave=1
obj/hogwartbanner
	icon='shields.dmi'
	icon_state="hogwartsbanner"
	density=1
	dontsave=1
obj/Fountain
	icon='shields.dmi'
	icon_state="fountain"
	density=1
	dontsave=1
	accioable=1
	wlable = 1
	value=2500
	rubbleable=1
	verb
		Drink()
			set src in oview(1)
			if(src.rubble==1)
				usr << "I'm not sure you want to drink this..."
			else
				switch(input("Recover?","Fountain")in list("Yes","No"))
					if("Yes")
						if(get_dist(src,usr)>1)return
						hearers()<<"[usr] drinks from the [src]."
						usr.HP=usr.MHP+usr.extraMHP
						usr.MP=usr.MMP+usr.extraMMP
						usr.updateHPMP()
						usr<<"You feel much better."

//FURNITURE
obj/Bed_
	icon='Hogwarts 32x32.dmi'
	icon_state="Bed"
	density=1
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
					usr.sight = 0
					usr<<"You feel much better."
	verb
		Take()
			set src in oview(1)
			usr<<"You take the [src]"
			Move(usr)
			usr:Resort_Stacking_Inv()
	verb
		Drop()

			new/obj/Bed_(usr.loc)
			usr<<"You drop your [src]"
			del src
obj/Dresser
	icon='items.dmi'
	icon_state="cabinet"
	density=1
	value=2500
	dontsave=1
	rubbleable=1
	verb
		Drop()
			new/obj/Dresser(usr.loc)
			usr<<"You drop your [src]"
			del src
obj/Lamp_Table_Top
	icon='house.dmi'
	icon_state="Lamp Table Top"
	density=1
	pixel_y=-10

obj/Lamp_Table_Bottom
	icon='house.dmi'
	icon_state="Table Bottom"
	density=1
	pixel_y=-10

obj/Cabinet1
	name="Cabinet"
	icon='house.dmi'
	icon_state="dress1"
	density=1

obj/Cabinet2
	name="Cabinet"
	icon='house.dmi'
	icon_state="dress2"
	density=1

obj/Fairy_Lights
	name="Fairy Lights"
	icon='turf.dmi'
	icon_state="lights"
	density=1

obj/Christmas_Tree_Top_Left
	name="Christmas Tree"
	icon='turf.dmi'
	icon_state="xmas tree1"
	density=0
	layer=MOB_LAYER+1

obj/Christmas_Tree_Bottom_Left
	name="Christmas Tree"
	icon='turf.dmi'
	icon_state="xmas tree2"
	density=1

obj/Christmas_Tree_Bottom_Right
	name="Christmas Tree"
	icon='turf.dmi'
	icon_state="xmas tree3"
	density=1

obj/Christmas_Tree_Top_Right
	name="Christmas Tree"
	icon='turf.dmi'
	icon_state="xmas tree4"
	density=0
	layer=MOB_LAYER+1

obj/Pole_Top
	name="North Pole"
	icon='turf.dmi'
	icon_state="pole"
	density=0
	layer=MOB_LAYER+1

obj/Pole_Bottom
	name="North Pole"
	icon='turf.dmi'
	icon_state="pole bottom"
	density=1

obj/Holly_Reath
	name="Holly Reath"
	icon='turf.dmi'
	icon_state="holy reef"
	density=1

obj/Lamp1
	name="Lamp"
	icon='house.dmi'
	icon_state="lamp"
	density=1


obj/Desk
	icon='Hogsmeade Objects.dmi'
	icon_state="Desk"
	density=1
	value=2500
	dontsave=1

obj/Book_Shelf
	icon='Desk.dmi'
	icon_state="1"
	density=1
	dontsave=1
	value=2500
/*
	verb
		Search()
			set src in view(2)
			switch(input(usr,"What book would you like to Grab?","Bookshelf") in list ("Transfiguration for Dummies","Cancel"))
				if("Transfiguration for Dummies")
					new/obj/TFD(usr)
					usr<<"You grab 'Transfiguration for Dummies' from the Bookshelf."
*/
obj/Book_Shelf1
	icon='Desk.dmi'
	icon_state="2"
	density=1
	dontsave=1
	value=2500

obj/Wand_Shelf
	icon='Desk.dmi'
	icon_state="3"
	density=1
	dontsave=1
	value=2500
/*
	verb
		Search()
			set src in view(2)
			switch(input(usr,"What book would you like to Grab?","Bookshelf") in list ("Transfiguration for Dummies","Cancel"))
				if("Transfiguration for Dummies")
					new/obj/TFD(usr)
					usr<<"You grab 'Transfiguration for Dummies' from the Bookshelf."
*/
/*
obj/items/easterbook
	name="The Easter Bunnies Guide to Magic"
	icon='Books.dmi'
	icon_state="easter"
	desc = "Who would of thought the Easter bunny wrote a book..."
	Click()
		if(src in usr)
			usr.verbs += /mob/Spells/verb/Shelleh
			usr<<"<b><font color=white><font size=3>You learned Shelleh."
			loc=null
			usr:Resort_Stacking_Inv()
		else
			..()
*/
obj/items/rosesbook
	name="The Book of Roses"
	icon='Books.dmi'
	icon_state="roses"
	desc = "The cover is so pretty!"
	Click()
		if(src in usr)
			usr<<"<b><font color=red><font size=3>You learned Herbificus Maxima."
			usr.verbs += /mob/Spells/verb/Herbificus_Maxima
			loc=null
			usr:Resort_Stacking_Inv()
		else
			..()
/*
obj/items/stickbook
	name="The Crappy Artist's Guide to Stick Figures"
	icon='Books.dmi'
	icon_state="stick"
	desc = "Remind me why I bought this?"
	Click()
		if(src in usr)
			usr<<"<b><font color=white><font size=3>You learned Crapus Sticketh."
			usr.verbs += /mob/Spells/verb/Crapus_Sticketh
			loc=null
			usr:Resort_Stacking_Inv()
		else
			..()
*/
obj/items/easter_egg
	icon='Eggs.dmi'
	desc="A colored easter egg! How nice!"


	New()
		..()
		spawn(1)
			if(!icon_state) icon_state = pick(icon_states(icon))

	Click()
		if(src in usr)
			new/obj/egg(usr.loc)
			loc=null
			usr:Resort_Stacking_Inv()
		else
			..()

obj/egg
	icon='Eggs.dmi'
	icon_state="egg"
	density=1
	dontsave=1
	var/HP

	proc
		Hit()
			HP--
			if(HP <= 0)
				if(prob(10))
					new /obj/items/easter_egg(loc)
				loc=null

			pixel_y++
			spawn(1)
				pixel_y--



	New()
		..()
		HP=rand(5,10)

		flick('magic.dmi',src)

		pixel_x = rand(-6,6)
		pixel_y = rand(-6,6)

		spawn(rand(600,1200))
			loc=null

obj/items/artifact
	name = "Artifact"
	icon = 'trophies.dmi'

	New()
		..()
		spawn(1)
			if(name == "Artifact")
				name = ""
				var/time = pick("Ancient","Old","")
				var/prop = pick("Magical", "Shiny", "Mysterious", "")
				if(time) name += time + " "
				if(prop) name += prop + " "
				name += "Artifact"
			if(!icon_state) icon_state = pick(icon_states(icon))


obj/items/lamps
	icon       = 'lamp.dmi'
	icon_state = "inactive"
	var
		effect
		seconds
		tmp/StatusEffect/S
	//drop
	double_drop_rate_lamp
		desc    = "Doubles your drop rate."
		effect  = /StatusEffect/Lamps/DropRate/Double
		seconds = 1800
	triple_drop_rate_lamp
		desc    = "Triples your drop rate."
		effect  = /StatusEffect/Lamps/DropRate/Triple
		seconds = 1800
	quadaple_drop_rate_lamp
		desc    = "Quadaples your drop rate."
		effect  = /StatusEffect/Lamps/DropRate/Quadaple
		seconds = 1800
	penta_drop_rate_lamp
		desc    = "Increases your drop rate x5."
		effect  = /StatusEffect/Lamps/DropRate/Penta
		seconds = 900
	sextuple_drop_rate_lamp
		desc    = "Increases your drop rate x6."
		effect  = /StatusEffect/Lamps/DropRate/Sextuple
		seconds = 600
	//exp
	double_exp_lamp
		desc    = "Doubles your exp gain rate."
		effect  = /StatusEffect/Lamps/Exp/Double
		seconds = 1800
	triple_exp_lamp
		desc    = "Triples your exp gain rate."
		effect  = /StatusEffect/Lamps/Exp/Triple
		seconds = 1800
	quadaple_exp_lamp
		desc    = "Quadaples your exp gain rate."
		effect  = /StatusEffect/Lamps/Exp/Quadaple
		seconds = 1800
	penta_exp_lamp
		desc    = "Increases your exp x5."
		effect  = /StatusEffect/Lamps/Exp/Penta
		seconds = 900
	sextuple_exp_lamp
		desc    = "Increases your exp x6."
		effect  = /StatusEffect/Lamps/Exp/Sextuple
		seconds = 600
	//gold
	double_gold_lamp
		desc    = "Doubles your gold gain rate."
		effect  = /StatusEffect/Lamps/Gold/Double
		seconds = 1800
	triple_gold_lamp
		desc    = "Triples your gold gain rate."
		effect  = /StatusEffect/Lamps/Gold/Triple
		seconds = 1800
	quadaple_gold_lamp
		desc    = "Quadaples your gold gain rate."
		effect  = /StatusEffect/Lamps/Gold/Quadaple
		seconds = 1800
	penta_gold_lamp
		desc    = "Increases your gold x5."
		effect  = /StatusEffect/Lamps/Gold/Penta
		seconds = 900
	sextuple_gold_lamp
		desc    = "Increases your gold x6."
		effect  = /StatusEffect/Lamps/Gold/Sextuple
		seconds = 600
	//statpoint
	double_statpoint_lamp
		desc    = "Doubles your statpoint gain rate."
		effect  = /StatusEffect/Lamps/Statpoint/Double
		seconds = 1800
	triple_statpoint_lamp
		desc    = "Triples your statpoint gain rate."
		effect  = /StatusEffect/Lamps/Statpoint/Triple
		seconds = 1800
	quadaple_statpoint_lamp
		desc    = "Quadaples your statpoint gain rate."
		effect  = /StatusEffect/Lamps/Statpoint/Quadaple
		seconds = 1800
	penta_statpoint_lamp
		desc    = "Increases your statpoint gain 5 times."
		effect  = /StatusEffect/Lamps/Statpoint/Penta
		seconds = 900
	sextuple_statpoint_lamp
		desc    = "Increases your statpoint gain 6 times."
		effect  = /StatusEffect/Lamps/Statpoint/Sextuple
		seconds = 600
	//damage
	damage_lamp
		desc    = "Increases your damage."
		effect  = /StatusEffect/Lamps/Damage
		seconds = 600
	defense_lamp
		desc    = "Increases your defense."
		effect  = /StatusEffect/Lamps/Defense
		seconds = 600
	power_lamp
		desc    = "Increases your overall power."
		effect  = /StatusEffect/Lamps/Power
		seconds = 300

	farmer_lamp
		desc    = "Removes damage, gold and exp level reductions allowing you to farm gold and exp from lower level monsters."
		effect  = /StatusEffect/Lamps/Farming
		seconds = 3600
	Click()
		if(src in usr)
			if(S)
				S.Deactivate()
			else
				S = new effect (usr, seconds, src)
		else
			..()
	Drop()
		if(S)
			S.Deactivate()
		..()
obj/items
	portduelsystem
		name = "Portable Duel System"
		icon = 'DuelArena.dmi'
		icon_state = "c4"
		var/tmp/Duel/D
		var/unpacked = 0
		var/ckeyowner
		var/list/obj/dueltiles = list()
		verb/Disown()
			var/input = alert("Are you sure you wish to allow anyone to pick this system up?",,"Yes","No")
			if(input == "Yes")
				ckeyowner = null
				usr << "Your Portable Duel System can now be picked up by anyone."

		Take()
			if(ckeyowner == usr.ckey)
				if(!D)
					if(!unpacked)
						usr << errormsg("System is not completely deployed yet.")
						return
					if(unpacked)Packup()
					..()
				else
					usr << errormsg("There is currently a duel taking place.")
			else if(!ckeyowner)
				ckeyowner = usr.ckey
				if(!D)
					if(unpacked)Packup()
					..()
				else
					usr << errormsg("There is currently a duel taking place.")
			else
				usr << errormsg("You do not have permission to pick this up.")
		Drop()
			..()
			if(ckeyowner)Unpack()
		proc/Packup()
			duelsystems.Remove(src)
			unpacked = 0
			var/obj/portduelsystemtiles/c1
			var/obj/portduelsystemtiles/c2
			var/obj/portduelsystemtiles/c3
			var/obj/portduelsystemtiles/c5
			var/obj/portduelsystemtiles/c6
			var/obj/portduelsystemtiles/c7
			for(var/obj/portduelsystemtiles/c1/c in dueltiles)
				c1 = c
			for(var/obj/portduelsystemtiles/c2/c in dueltiles)
				c2 = c
			for(var/obj/portduelsystemtiles/c3/c in dueltiles)
				c3 = c
			for(var/obj/portduelsystemtiles/c5/c in dueltiles)
				c5 = c
			for(var/obj/portduelsystemtiles/c6/c in dueltiles)
				c6 = c
			for(var/obj/portduelsystemtiles/c7/c in dueltiles)
				c7 = c
			for(var/obj/duelblock/t in view())
				del(t)
			spawn()step(c1,EAST)
			spawn()step(c7,WEST)
			spawn()step(c2,EAST)
			spawn()step(c6,WEST)
			spawn()step(c3,EAST)
			spawn()step(c5,WEST)
			sleep(6)
			spawn()step(c1,EAST)
			spawn()step(c7,WEST)
			spawn()step(c2,EAST)
			spawn()step(c6,WEST)
			spawn()step(c3,EAST)
			spawn()step(c5,WEST)
			sleep(6)
			del(c3)
			del(c5)
			spawn()step(c1,EAST)
			spawn()step(c7,WEST)
			spawn()step(c2,EAST)
			spawn()step(c6,WEST)
			sleep(6)
			del(c2)
			del(c6)
			spawn()step(c1,EAST)
			spawn()step(c7,WEST)
			sleep(6)
			del(c1)
			del(c7)
			dueltiles=list()
		proc/Unpack()
			duelsystems.Add(src)
			var/obj/portduelsystemtiles/c1/c1 = new(src.loc)
			var/obj/portduelsystemtiles/c7/c7 = new(src.loc)
			src.dueltiles.Add(c1)
			c1.density = 1
			src.dueltiles.Add(c7)
			c7.density = 1
			sleep(6)
			spawn()step(c1,WEST)
			spawn()step(c7,EAST)
			sleep(6)
			var/obj/portduelsystemtiles/c2/c2 = new(src.loc)
			var/obj/portduelsystemtiles/c6/c6 = new(src.loc)
			src.dueltiles.Add(c2)
			c2.density = 1
			src.dueltiles.Add(c6)
			c6.density = 1

			spawn()step(c1,WEST)
			spawn()step(c7,EAST)
			spawn()step(c2,WEST)
			spawn()step(c6,EAST)
			sleep(6)
			var/obj/portduelsystemtiles/c3/c3 = new(src.loc)
			var/obj/portduelsystemtiles/c5/c5 = new(src.loc)
			src.dueltiles.Add(c3)
			c3.density = 1
			src.dueltiles.Add(c5)
			c5.density = 1
			spawn()step(c1,WEST)
			spawn()step(c7,EAST)
			spawn()step(c2,WEST)
			spawn()step(c6,EAST)
			spawn()step(c3,WEST)
			spawn()step(c5,EAST)
			sleep(6)
			spawn()step(c1,WEST)
			spawn()step(c7,EAST)
			spawn()step(c2,WEST)
			spawn()step(c6,EAST)
			spawn()step(c3,WEST)
			spawn()step(c5,EAST)
			sleep(6)
			c1.density = 0
			c7.density = 0
			c2.density = 0
			c6.density = 0
			c3.density = 0
			c5.density = 0
			if(get_dist(c1,c7)<8)
				hearers() << "Portable Duel System: <i>ERROR</i>. Duel path must be clear of obstacles to deploy."
				Packup()
				Move(usr)
				usr:Resort_Stacking_Inv()
			else
				new/obj/duelblock (c3.loc)
				new/obj/duelblock (c5.loc)
				unpacked = 1
		Click()

			if((src in usr) && ckeyowner)
				Drop()
			else
				if(!ckeyowner)
					..()
					return

				if( !(usr in hearers(src)) )return
				if(!unpacked)
					usr << "System is not completely deployed yet."
					return
				if(D)
					if(!D.player1 && D.player2 != usr)
						var/turf/t = locate(x-3,y,z)
						if(istype(t, /turf/teleport) || (locate(/obj/teleport) in t))
							return

						D.player1 = usr
						D.player1:Transfer(t)
						D.player1.dir = EAST
						D.player1.movable = 1
						range(9) << "[usr] enters the duel."
					else if(!D.player2 && D.player1 != usr)
						var/turf/t = locate(x+3,y,z)
						if(istype(t, /turf/teleport) || (locate(/obj/teleport) in t))
							return

						D.player2 = usr
						D.player2:Transfer(t)
						D.player2.dir = WEST
						D.player2.movable = 1
						range(9) << "[usr] enters the duel."
						var/obj/duelblock/B1 = locate(/obj/duelblock) in locate(x-2,y,z)
						var/obj/duelblock/B2 = locate(/obj/duelblock) in locate(x+2,y,z)
						B1.density = 1
						B2.density = 1
						range(9) << "<i>Duelists now have 10 seconds to click on the duel control center.</i>"
						D.Pre_Duel()

					else if(D.player1 == usr)
						if(!D.player2)
							range(9) << "[usr] withdraws."
							usr.movable = 0
							del D
						else
							if(!D.ready1)
								range(9) << "<i>[usr] bows.</i>"
								usr << "You are now ready."
								D.ready1 = 1
							else
								var/input = alert("Do you wish to forfeit the duel?","Forfeit Duel","Yes","No")
								if(input == "Yes")
									usr << "Duel will end in 10 seconds."
									sleep(100)
									range(9) << "The duel has been forfeited by [usr]."
									D.player1.movable = 0
									D.player2.movable = 0
									spawn(60)
										var/obj/duelblock/B1 = locate(/obj/duelblock) in locate(x-2,y,z)
										var/obj/duelblock/B2 = locate(/obj/duelblock) in locate(x+2,y,z)
										B1.density = 0
										B2.density = 0
									del D
					else if(D.player2 == usr)
						if(!D.player1)
							range(9) << "[usr] withdraws."
							usr.movable = 0
							del D
						else
							if(!D.ready2)
								range(9) << "<i>[usr] bows.</i>"
								usr << "You are now ready."
								D.ready2 = 1
							else
								var/input = alert("Do you wish to forfeit the duel?","Forfeit Duel","Yes","No")
								if(input == "Yes")
									usr << "Duel will end in 10 seconds."
									sleep(100)
									range(9) << "The duel has been forfeited by [usr]."
									spawn(60)
										var/obj/duelblock/B1 = locate(/obj/duelblock) in locate(x-2,y,z)
										var/obj/duelblock/B2 = locate(/obj/duelblock) in locate(x+2,y,z)
										B1.density = 0
										B2.density = 0
									del D

					else
						usr << "Both player positions are already occupied."
				else
					var/turf/t = locate(x-3,y,z)
					if(istype(t, /turf/teleport) || (locate(/obj/teleport) in t))
						return

					D = new(src)
					D.countdown = 5//input("Select count-down timer, for when both players have readied. (between 3 and 10 seconds)","Count-down Timer",D.countdown) as null|num
					range(9) << "[usr] initiates a duel."
					D.player1 = usr
					D.player1:Transfer(t)
					D.player1.dir = EAST
					D.player1.movable = 1

obj/items/crystal
	icon = 'Crystal.dmi'

	var
		bonus      = 0 // 1 for damage, 2 for defense, 3 for both
		luck       = 0 // bonus chance
		ignoreItem = FALSE// ignores fourth item

	Click()
		if(src in usr)
			var/obj/enchanter/e = locate() in oview(2, usr)
			if(e)
				usr << errormsg("You hold [src.name] suddenly it disappears as it is absorbed within the magic circle.")
				e.applyBonus  |= bonus
				e.bonusChance += luck
				if(ignoreItem) e.ignoreItem = TRUE
				e.showBonus()
				loc = null
				usr:Resort_Stacking_Inv()
			else
				usr << errormsg("You hold [src.name] but nothing happens.")

		else
			..()
	damage
		name  = "red crystal"
		icon_state = "damage"
		bonus = 1
	defense
		name  = "green crystal"
		icon_state = "defense"
		bonus = 2
	magic
		name  = "magic crystal"
		icon_state = "magic"
		bonus = 3
		luck  = 5
	luck
		name  = "luck crystal"
		icon_state = "luck"
		luck  = 5
	strong_luck
		name  = "strong luck crystal"
		icon_state = "luck2"
		luck  = 10
	soul
		name = "soul crystal"
		icon_state = "soul"
		luck = 5
		ignoreItem = TRUE

obj/items/magic_stone
	var/tmp/inUse = FALSE

	icon = 'trophies.dmi'

	teleport
		icon = 'Crystal.dmi'
		name = "teleport stone"
		var/dest

		circle(mob/Player/p)
			if(dest)
				..(p)
			else
				var/turf/t = p.loc
				if(findtext(t.tag, "teleportPoint"))
					dest = copytext(t.tag, 14)
					name = "teleport stone \[[dest]]"
					icon_state = "teleport"
					p << infomsg("You charged your teleport stone to [dest].")
				else
					p << errormsg("You can't use it here, find a memory rune to charge this teleport stone.")

		effect(mob/Player/p)
			var/turf/t = locate("teleportPoint[dest]")
			if(t)
				hearers(p) << infomsg("[p.name] disappears in a flash of light.")
				p.Transfer(t)
				hearers(p) << infomsg("[p.name] appears in a flash of light.")

	weather
		acid
			name = "acid stone"
			icon_state = "Emerald"

			effect()
				weather.acid()

		snow
			name = "snow stone"
			icon_state = "Sapphire2"

			effect()
				weather.snow()

		rain
			name = "rain stone"
			icon_state = "Sapphire"

			effect()
				weather.rain()

		sun
			name = "sun stone"
			icon_state = "Topaz"

			effect()
				weather.clear()

	summoning
		circle(mob/Player/P)
			if(currentEvents)
				P << errormsg("You can't use this while an event is running.")
				return
			..(P)

		random
			name = "lucky coin"
			icon_state = "Coin"
			effect()
				var/random_type = pick(/RandomEvent/TheEvilSnowman, /RandomEvent/WillytheWhisp, /RandomEvent/Invasion)
				var/RandomEvent/event = locate(random_type) in events
				spawn() event.start()

		snowman
			name = "snowy coin"
			icon_state = "Coin"
			effect()
				var/RandomEvent/TheEvilSnowman/event = locate() in events
				spawn() event.start()
		willy
			name = "mysterious coin"
			icon_state = "Coin"
			effect()
				var/RandomEvent/WillytheWhisp/event = locate() in events
				spawn() event.start()

		monsters
			name = "stinky coin"
			icon_state = "Coin"
			effect()
				var/RandomEvent/Invasion/event = locate() in events
				spawn() event.start()

	Click()
		if(src in usr)
			circle(usr)
		else
			..()

	proc/effect(mob/Player/p)
	proc/circle(mob/Player/p)

		if(!canUse(p,cooldown=null,needwand=1,inarena=0,insafezone=0,inhogwarts=0,target=null,mpreq=3000,antiTeleport=1))
			return
		p.MP -= 3000

		if(!(p.loc && (istype(p.loc.loc, /area/outside) || istype(p.loc.loc, /area/newareas/outside))))
			p << errormsg("You can only use this outside.")
			return

		if(inUse) return
		inUse = TRUE

		var/obj/o = new(usr.loc)
		o.name = "magic circle"
		o.icon='Circle_magic.dmi'
		o.pixel_x = -65
		o.pixel_y = -64

		animate(o, color = rgb(rand(80,255), rand(80,255), rand(80,255)), time = 10, loop = -1)
		animate(color = rgb(rand(80,255), rand(80,255), rand(80,255)), time = 10)
		animate(color = rgb(rand(80,255), rand(80,255), rand(80,255)), time = 10)

		hearers(p) << infomsg("[p.name] holds their [name] up in the air")

		var/obj/items/magic_stone/source = src
		src=null
		spawn()
			var/tmploc = p.loc
			var/secs = 10

			while(secs > 0 && p && p.loc == tmploc)
				secs--
				sleep(10)
			if(p && source)
				if(p.loc == tmploc)
					source.effect(p)
					source.loc = null
					p.Resort_Stacking_Inv()
				else
					source.inUse = FALSE
					p << errormsg("The ritual failed.")
			o.loc = null

obj
	enchanter

		density = 1
		icon='Circle_magic.dmi'

		pixel_x = -65
		pixel_y = -64

		New()
			..()
			colors()

		var
			tmp
				inUse       = FALSE
				bonusChance = 0
				applyBonus  = 0
				ignoreItem  = FALSE
			max_upgrade = 3

		proc
			colors()
				animate(src, color = "#cc2aa2", time = 10, loop = -1)
				animate(color = "#55f933", time = 10)
				animate(color = "#0aa2df", time = 10)

			showBonus()
				if(applyBonus & 2)
					emit(loc    = src,
						 ptype  = /obj/particle/green,
					     amount = 3,
					     angle  = new /Random(1, 359),
					     speed  = 2,
					     life   = new /Random(15,25))
				if(applyBonus & 1)
					emit(loc    = src,
						 ptype  = /obj/particle/red,
					     amount = 3,
					     angle  = new /Random(1, 359),
					     speed  = 2,
					     life   = new /Random(15,25))

			bigcolor(var/c)
				animate(src, transform = matrix()*1.75, color = "[c]",   alpha = 150, time = 2,  easing = LINEAR_EASING)
				animate(transform = null,               color = "white", alpha = 255, time = 10, easing = BOUNCE_EASING)

			enchant()
				if(inUse) return
				inUse = TRUE
				spawn(13)
					inUse = FALSE
					colors()

				animate(src)
				sleep(1)

				var/const/DISTANCE = 3
				var/obj/items/artifact/i1 = locate() in locate(x+DISTANCE,y,z)
				var/obj/items/artifact/i2 = locate() in locate(x-DISTANCE,y,z)
				var/obj/items/i3 = locate() in locate(x,y+DISTANCE,z)
				var/obj/items/i4 = ignoreItem ? i3 : locate() in locate(x,y-DISTANCE,z)

				if(!i1 || !i2)
					bigcolor("red")
					return

				if(!i3 || !i4 || i3.type != i4.type)
					bigcolor("blue")
					if(i3) step_rand(i3)
					if(i4) step_rand(i4)
					return

				var/chance = 100
				var/prize

				if(istype(i3, /obj/items/scroll))
					chance -= 60
					prize = pick(/obj/items/wearable/title/Bookworm, /obj/items/wearable/title/Lumberjack)

				else if(istype(i3, /obj/items/artifact))
					chance -= 20
					prize = /obj/items/magic_stone/teleport

				else if(istype(i3, /obj/items/crystal) && applyBonus == 3)

					if(istype(i3, /obj/items/crystal/soul))
						chance -= 40
						prize = pick(/obj/items/weather/sun, /obj/items/weather/rain, /obj/items/weather/acid, /obj/items/weather/snow)
					else if(istype(i3, /obj/items/crystal/damage))
						chance -= 50
						prize = /obj/items/lamps/damage_lamp
					else if(istype(i3, /obj/items/crystal/defense))
						chance -= 50
						prize = /obj/items/lamps/defense_lamp
					else if(istype(i3, /obj/items/crystal/luck))
						chance -= 40
						prize = pick(/obj/items/lamps/double_gold_lamp, /obj/items/lamps/double_exp_lamp, /obj/items/lamps/double_drop_rate_lamp, /obj/items/crystal/strong_luck)
					else if(istype(i3, /obj/items/crystal/strong_luck))
						chance -= 50
						prize = pick(/obj/items/lamps/triple_gold_lamp, /obj/items/lamps/triple_exp_lamp, /obj/items/lamps/triple_drop_rate_lamp)
					else if(istype(i3, /obj/items/crystal/magic))
						chance -= 70
						prize = ignoreItem ? /obj/items/magic_stone/summoning/random : /obj/items/lamps/power_lamp

				else if(istype(i3, /obj/items/wearable/))

					if(istype(i3, /obj/items/wearable/title) && i3.name == i4.name)
						chance -= 40
						prize = i3.type
						i3.color = rgb(rand(80,240), rand(80,240), rand(80,240))

					else if(i3:bonus != -1 && i3:quality < max_upgrade && i3:quality == i4:quality)
						var/flags = applyBonus|i3:bonus|i4:bonus
						if(flags)
							i3:bonus = applyBonus|i3:bonus|i4:bonus
							prize = i3.type
							i3:quality++
							chance -= i3:quality * 20

				if(!prize)
					bigcolor("black")
					if(i3) step_rand(i3)
					if(i4) step_rand(i4)
					return

				i1.loc = null
				i2.loc = null
				i3.loc = null
				i4.loc = null

				bigcolor("#f84b7a")

				spawn(1)
					emit(loc    = src,
						 ptype  = /obj/particle/magic,
					     amount = 50,
					     angle  = new /Random(1, 359),
					     speed  = 2,
					     life   = new /Random(15,25))

				sleep(12)
				var/turf/t = locate(x+rand(-1,1),y+rand(-1,1),z)
				if(prob(chance + bonusChance))
					var/obj/items/o = new prize (t)
					o.owner = i3.owner

					if(istype(i3, /obj/items/wearable/title))
						o.name = i3.name
						o:title = copytext(i3.name, 8)
						o.color = i3.color
						o:title = "<font color=\"[o.color]\">" + o:title + "</font>"
					else if(istype(i3, /obj/items/wearable))
						o:quality = i3:quality
						o:bonus   = i3:bonus
						o.name += " +[o:quality]"

				else
					new /obj/items/DarknessPowder (t)

				bonusChance = 0
				applyBonus  = 0
				ignoreItem  = FALSE

obj/items/wearable/wands/practice_wand
	icon = 'oak_wand.dmi'
	var/learnSpell/spell
	dropable = 0
	destroyable = 1

	Equip(var/mob/Player/owner,var/overridetext=0,var/forceremove=0)
		. = ..(owner, overridetext, forceremove)
		var/mob/Player/p = owner
		if(. == WORN)
			p.verbs   += spell.path
			p.learning = spell

			if(!overridetext) p << infomsg("Use [spell.name] [spell.uses] time[spell.uses > 1 ? "s" : ""] to learn it!")

		else if(. == REMOVED || forceremove)
			p.verbs   -= spell.path
			p.learning = null


obj/memory_rune

	icon       = 'attacks.dmi'
	icon_state = "alohomora"

	New()
		..()

		animate(src, color = rgb(rand(80,255), rand(80,255), rand(80,255)), time = 10, loop = -1)
		animate(color = rgb(rand(80,255), rand(80,255), rand(80,255)), time = 10)
		animate(color = rgb(rand(80,255), rand(80,255), rand(80,255)), time = 10)

		loc.tag = "teleportPoint[name]"

	Silverblood
	CoSFloor1
		name = "CoS Floor 1"
	CoSFloor2
		name = "CoS Floor 2"
	Desert
		name = "Desert"
	Manor
		name = "Manor"