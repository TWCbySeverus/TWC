/*
 * Copyright � 2014 Duncan Fairley
 * Distributed under the GNU Affero General Public License, version 3.
 * Your changes must be made public.
 * For the full license text, see LICENSE.txt.
 */

area/var/safezoneoverride = 0
obj/statues
	icon = 'statues.dmi'
	density = 1
	acromantula/icon_state = "acromantula"
	firebat/icon_state = "firebat"
	fire_golem/icon_state = "firegolem"
	bird/icon_state = "bird"
	demon_rat/icon_state = "demon rat"
	troll/icon_state = "troll"
	dementor/icon_state = "dementor"
	pixie/icon_state = "pixie"
	wyvern/icon_state = "wyvern"
	fire_elemental/icon_state = "fire elemental"
	water_elemental/icon_state = "water elemental"
	basilisk/icon_state = "basilisk"
	floating_eye/icon_state = "eye"
	archangel/icon_state = "archangel"
	snake/icon_state = "snake"
	house_elf/icon_state = "houseelf"
	dragon/icon_state = "dragon"
	wolf/icon_state = "wolf"
	skeleton/icon_state = "skeleton"
	bat/icon_state = "bat"
	werewolf/icon_state = "werewolf"
	rat/icon_state = "rat"
	black_cat/icon_state = "blackcat"
	white_cat/icon_state = "whitecat"
	dog/icon_state = "dog"
	frog/icon_state = "frog"
	rabbit/icon_state = "rabbit"
	turkey/icon_state = "turkey"

proc
	isPathBlocked(mob/source, mob/target, dist=1, dense_override=0, dist_limit=10)
		if(!(source && source.loc)) return 1
		if(!(target && target.loc)) return 1
		if(!source.density && !dense_override) return 0

		var/obj/o = new (source.loc)
		o.density = 1

		var/const/STEPS_LIMIT = 10

		var/turf/t = get_step_to(o, target, dist)
		var/distance = get_dist(o, target)

		for(var/steps = 0 to STEPS_LIMIT)
			if(!t) break
			if(distance <= dist_limit) break

			o.loc    = t
			t        = get_step_to(o, target, dist)
			distance = get_dist(o, target)

		if(!t && get_dist(o, target) > dist)
			o.loc = null
			return 1
		o.loc = null
		if(distance > dist_limit)
			return 1
		return 0
var/day=1
area
	newareas
		var/tmp/active = 0
		outside
			Forbidden_ForestNE
			Forbidden_ForestNW
			Forbidden_ForestSE
			Forbidden_ForestSW
			Pixie_Pit
			Desert1
			Desert2
			Desert3
			Silverblood_Bats
			Silverblood_Golems
			Graveyard
			Hogsmeade
			var	// determines if the area is lit or dark.
				obj/weather/Weather	// what type of weather the area is having
	/*		proc
				daycycle()
					lit = 1 - lit	// toggle lit between 1 and 0
					if(lit)
						day=1
					//	for(var/mob/Player/M in world)
						//	M.Move(M.loc)
						//overlays -= 'black50.dmi' // remove the 50% dither
						//if(type == /area/outside)
							//world<<"<b>Event: <font color=blue>The sun rises over the forest. A new day begins."	// remove the dither
					else
						day=0
					//	overlays += 'black50.dmi'	// add the 50% dither
					spawn(9000) daycycle()*/
		inside
			Silverblood_Maze
				antiTeleport = TRUE
				antiFly      = TRUE
			Ratcellar
				antiTeleport = TRUE
				antiFly      = TRUE
			Chamber_of_Secrets
				antiTeleport = TRUE
				antiFly      = TRUE
				Floor1
				Floor1_Boss
				Floor2
				Floor2_Boss
			Rotem_Mansion
				darkarea
					luminosity=0
					Pixie_Domain
				Restaurant
				Bats_Domain
				Rouge_Deatheaters_Domain
				Werewolf_Domain
				Zombie_Domain
				Rotem
			Graveyard_Underground
				antiTeleport = TRUE
				antiFly      = TRUE
		Enter(atom/movable/O)
			. = ..()
			if(isplayer(O))
				active = 1
				for(var/mob/NPC/Enemies/M in src)
					if(M.state == M.WANDER)
						M.state = M.SEARCH

		Entered(atom/movable/O)
			. = ..()
			if(isplayer(O))
				active = 1
				for(var/mob/NPC/Enemies/M in src)
					if(M.state == M.WANDER)
						M.state = M.SEARCH


		Exit(atom/movable/O)
			.=..()
			if(istype(O, /mob/NPC) && !O:removeoMob) return 0

		Exited(atom/movable/O)
			. = ..()
			if(isplayer(O))
				var/isempty = 1
				for(var/mob/Player/M in src)
					if(M != O)
						isempty = 0
						break
				if(isempty)
					active = 0
					for(var/mob/NPC/Enemies/M in src)
						M.state = M.WANDER

area/Exit(atom/movable/O, atom/newloc)
	.=..()
	if(istype(O, /mob/NPC) && O:removeoMob && !issafezone(src) && issafezone(newloc.loc)) return 0

mob
	test
		verb
			View_Error_Log()
				src << browse(file("Logs/[VERSION]-log.txt"))
			Reconnect_MySQL()
				connected = my_connection.Connect(DBI,mysql_username,mysql_password)
				src << "New connection started."


mob
	NPC
		icon = 'Mobs.dmi'
		see_invisible = 1
		var/activated = 0
		var/HPmodifier = 0.8
		var/DMGmodifier = 0.35
		var/list/drops = list()
		var/tmp/turf/origloc

		Enemies
			player = 0
			Gm = 1
			monster = 1
			NPC = 1

			drops = list("0.7" = list(/obj/items/Whoopie_Cushion,
			 			  			  /obj/items/Smoke_Pellet,
			 			  			  /obj/items/Tube_of_fun))

			var
				const
					INACTIVE   = 0
					WANDER     = 1
					SEARCH     = 2
					HOSTILE    = 4
					CONTROLLED = 8

				tmp
					state = WANDER
					list/ignore

				Range = 12
				MoveDelay = 5
				AttackDelay = 5
				respawnTime = 1200


			New()
				. = ..()
				spawn(1) // fix for monsters not setting their variables if loaded from swap maps
					calcStats()
					origloc = loc
					sleep(rand(10,60))
					state()

			proc/calcStats()
				Dmg = round(DMGmodifier * ((src.level -1) + 5))
				MHP = round(HPmodifier * (4 * (src.level - 1) + 200))
				gold = round(src.level / 2)
				Expg = round(src.level * 6)
				HP = MHP
//NEWMONSTERS

			proc/Death(mob/Player/killer)
				var/rate = 1

				if(killer.House == housecupwinner)
					rate += 0.25

				var/StatusEffect/Lamps/DropRate/d = killer.findStatusEffect(/StatusEffect/Lamps/DropRate)
				if(d)
					rate *= d.rate

				rate *= DropRateModifier

				for(var/i in drops)
					if(prob(text2num(i) * rate))
						var/obj/t = istype(drops[i], /list) ? pick(drops[i]) : drops[i]
						new t (loc)
						break
				if(name == "Rotem")
					killer.verbs+=/mob/Spells/verb/Avada_Kedavra
				if(name == initial(name) && prob(0.1))
					var/obj/items/wearable/title/Slayer/t = new (loc)
					t.title = "[name] Slayer"
					t.name  = "Title: [name] Slayer"

			proc/state()
				var/lag = 10
				while(src && src.loc)
					var/s = state
					switch(state)
						if(INACTIVE)
							lag = 50
						if(WANDER)
							Wander()
							lag = 27
						if(SEARCH)
							Search()
							lag = 15
						if(HOSTILE)
							Attack()
							lag = MoveDelay
						if(CONTROLLED)
							BlindAttack()
							lag = 12
					if(s == state)
						if(lag <= 0) lag = 1
						sleep(lag)
					else
						sleep(1)
			var/tmp/mob/target


			proc
				Search()
					Wander()
					for(var/mob/Player/M in ohearers(src, Range))
						if(M.loc.loc != src.loc.loc) continue
						if(ignore && (M in ignore)) continue

						if(!isPathBlocked(M, src, 1, src.density))
							target = M
							state  = HOSTILE
							break
						else
							Ignore(M)

				ChangeTarget()
					var/min_dist = Range
					for(var/mob/Player/M in ohearers(src, Range))
						if(M.loc.loc != src.loc.loc) continue
						if(ignore && (M in ignore)) continue

						if(!isPathBlocked(M, src, 1, src.density))
							var/dist = get_dist(src, M)
							if(min_dist > dist)
								target = M
						else
							Ignore(M)

				Wander()
					step_rand(src)
					sleep(5)

				Ignore(mob/M)
					if(!ignore) ignore = list()
					ignore += M
					spawn(100)
						if(M && ignore)
							ignore -= M
							if(ignore.len == 0)
								ignore = null
						else
							ignore = null

			proc/ReturnToStart()
				state = INACTIVE
				if(loc.loc != origloc.loc)
					if(z == origloc.z)
						density = 0
						while(loc.loc != origloc.loc)
							sleep(1)
							step_towards(src, origloc)
						density = 1
					else
						src.loc = origloc
				ShouldIBeActive()

			proc/ShouldIBeActive()
				if(!loc)
					state = INACTIVE
					return 0

				if(istype(loc.loc, /area/newareas) && loc.loc:active)
					state = SEARCH
					return 1

				state = WANDER
				return 0


			proc/BlindAttack()//removeoMob
				var/mob/Player/M = locate() in ohearers(1, src)
				if(M)
					var/dmg = Dmg+extraDmg+rand(0,4)
					if(dmg<1)
						//view(M)<<"<SPAN STYLE='color: blue'>[src]'s attack doesn't even faze [M]</SPAN>"
					else
						M.HP -= dmg
						hearers(M)<<"<SPAN STYLE='color: red'>[src] attacks [M] and causes [dmg] damage!</SPAN>"
						if(src.removeoMob)
							spawn() M.Death_Check(src.removeoMob)
						else
							spawn() M.Death_Check(src)

			proc/Blocked()
				target = null
				ShouldIBeActive()

			proc/Attack()

				if(prob(20))
					step_rand(src)
					sleep(2)

				if(state != HOSTILE) return

				var/distance = get_dist(src, target)
				if(!target || !target.loc || target.loc.loc != loc.loc || distance > Range)
					target = null
					ChangeTarget()
					if(!target)
						ShouldIBeActive()
						return

				if(distance > 1)
					if(prob(10))
						ChangeTarget()

					var/turf/t = get_step_to(src, target, 1)
					if(t)
						Move(t)
					else
						step_rand(src)
						Blocked()
				else
					var/dmg = Dmg+extraDmg+rand(0,4)

					if(target.level > level && !target.findStatusEffect(/StatusEffect/Lamps/Farming))
						dmg -= dmg * ((target.level - level)/100)
					else if(target.level < level)
						dmg += dmg * ((level - target.level)/200)
					dmg = round(dmg)

					if(dmg<1)
						//view(M)<<"<SPAN STYLE='color: blue'>[src]'s attack doesn't even faze [M]</SPAN>"
					else
						target.HP -= dmg
						hearers(target)<<"<SPAN STYLE='color: red'>[src] attacks [target] and causes [dmg] damage!</SPAN>"
						spawn()target.Death_Check(src)
					sleep(AttackDelay)

//////Monsters///////

			Summoned
				state = SEARCH
				New()
					calcStats()
					spawn(1)
						state()

				ShouldIBeActive()
					if(!loc)
						state = INACTIVE
						return 0

					state = SEARCH
					return 1

				ReturnToStart()
					ShouldIBeActive()

				Dementor
					icon_state = "dementor"
					level = 2000
					HPmodifier  = 1
					DMGmodifier = 2
					Attack()
						if(prob(20))
							step_rand(src)
							sleep(2)

						if(state != HOSTILE) return

						var/distance = get_dist(src, target)
						if(!target || !target.loc || target.loc.loc != loc.loc || distance > Range)
							target = null
							ChangeTarget()
							if(!target)
								ShouldIBeActive()
								return
						if(distance > 1)
							if(prob(10))
								ChangeTarget()

							var/turf/t = get_step_to(src, target, 1)
							if(t)
								Move(t)
							else
								step_rand(src)
								Blocked()
						else
							var/dmg = Dmg+extraDmg+rand(0,4)

							if(target.level > level && !target.findStatusEffect(/StatusEffect/Lamps/Farming))
								dmg -= dmg * ((target.level - level)/100)
							else if(target.level < level)
								dmg += dmg * ((level - target.level)/200)
							dmg = round(dmg)

							if(dmg<1)
									//view(M)<<"<SPAN STYLE='color: blue'>[src]'s attack doesn't even faze [M]</SPAN>"
							else
								if(rand(1,30)!=1 && target.findStatusEffect(/StatusEffect/Patronus))
								//	target<<"You're protected by your Patronus Shield"
								else
									target.HP -= dmg
									hearers(target)<<"<SPAN STYLE='color: red'>[src] attacks [target] and causes [dmg] damage!</SPAN>"
									spawn()target.Death_Check(src)
							sleep(AttackDelay)
					Death()

				Snake
					icon_state = "snake"
					level = 500

					Death()


				Phoenix
					icon_state = "bird"
					level = 6

					Search()
						Wander()
						sleep(3)
						Heal()

					proc
						Heal()
							for(var/mob/Player/M in ohearers(3, src))
								M.HP += round((M.MHP/20)+rand(0,50))
								if(M.HP > M.MHP) M.HP = M.MHP
								M.updateHPMP()
					BlindAttack()//removeoMob
						Heal()

					New()
						light(src, 3, 600, "orange")
						..()

			Demon_Rat
				icon_state = "demon rat"
				level = 50
			Pixie
				icon_state = "pixie"
				level = 150
			Snake
				icon_state = "snake"
				level = 400
			Acromantula
				icon_state = "spider"
				level = 550
			Snowman
				icon = 'Snowman.dmi'
				level = 600
				HPmodifier  = 3
				DMGmodifier = 1
				MoveDelay = 4
				AttackDelay = 3
				drops = list("0.01" = /obj/items/artifact,
							 "5"    = list(/obj/items/DarknessPowder,
								 		   /obj/items/Whoopie_Cushion,
										   /obj/items/U_No_Poo,
							 			   /obj/items/Smoke_Pellet,
							 			   /obj/items/Tube_of_fun,
							 			   /obj/items/Swamp),
							 "30"   = /obj/items/gift)
			Wisp
				icon_state = "wisp"
				level = 700

				HPmodifier  = 3
				DMGmodifier = 1.2
				MoveDelay = 3
				canBleed = FALSE
				var/tmp/fired = 0

				drops = list("3"    = /obj/items/crystal/luck,
						     "0.8"  = list(/obj/items/crystal/defense,
							 			   /obj/items/crystal/damage),
						     "0.1" = /obj/items/artifact,
							 "0.3" = list(/obj/items/wearable/title/Magic,
							 			   /obj/items/crystal/magic,
						     			   /obj/items/crystal/strong_luck,
						     			   /obj/items/crystal/soul),
							 "5"    = list(/obj/items/DarknessPowder,
							 			   /obj/items/Smoke_Pellet,
							 			   /obj/items/Tube_of_fun))


				Attack(mob/M)
					..()
					if(!fired && target && state == HOSTILE)
						fired = 1
						spawn(rand(50,150)) fired = 0

						for(var/obj/redroses/S in oview(3, src))
							flick("burning", S)
							spawn(8) S.loc = null

						if(prob(80))
							dir=get_dir(src, target)
							castproj(0, 'attacks.dmi', "fireball", Dmg + rand(-4,8), "fire ball")
							sleep(AttackDelay)

				Attacked(projname, damage)
					if(projname == "gum"||projname == "gum-old" && prob(95)||projname=="fireball"||projname=="quake"||projname=="iceball"||projname=="black")
						emit(loc    = src,
							 ptype  = /obj/particle/red,
						     amount = 2,
						     angle  = new /Random(1, 359),
						     speed  = 2,
						     life   = new /Random(15,20))
					else
						HP+=damage

						emit(loc    = src,
							 ptype  = /obj/particle/green,
						     amount = 2,
						     angle  = new /Random(1, 359),
						     speed  = 2,
						     life   = new /Random(15,20))

				New()
					..()
					alpha = rand(190,255)

					var/color1 = rgb(rand(20, 255), rand(20, 255), rand(20, 255))
					var/color2 = rgb(rand(20, 255), rand(20, 255), rand(20, 255))
					var/color3 = rgb(rand(20, 255), rand(20, 255), rand(20, 255))

					animate(src, color = color1, time = 10, loop = -1)
					animate(color = color2, time = 10)
					animate(color = color3, time = 10)

					if(prob(70)) transform *= 1 + (rand(-5,15) / 50) // -10% to +30% size change

			Floating_Eye
				icon_state = "eye1"
				level = 900
				HPmodifier  = 3
				DMGmodifier = 1.2
				var/tmp/fired = 0
				MoveDelay = 4
				AttackDelay = 1

				New()
					..()
					icon_state = "eye[rand(1,2)]"
					if(prob(60))
						transform *= 1 + (rand(-15,30) / 50) // -30% to +60% size change

				drops = list("0.3" = /obj/items/wearable/title/Eye,
							 "6"  = /obj/items/artifact,
							 "10"    = list(/obj/items/DarknessPowder,
								 	 	   /obj/items/Whoopie_Cushion,
									 	   /obj/items/U_No_Poo,
							 		 	   /obj/items/Smoke_Pellet,
							 		 	   /obj/items/Tube_of_fun,
							 		       /obj/items/Swamp))

				Search()
					Wander()
					for(var/mob/Player/M in ohearers(src, Range))
						if(M.loc.loc == src.loc.loc)
							target = M
							state  = HOSTILE
							break

				Blocked()
					density = 0
					var/turf/t = get_step_to(src, target, 1)
					if(t)
						Move(t)
					else
						..()
					density = 1

				Attack(mob/M)
					..()
					if(!fired && target && state == HOSTILE)
						var/fire = 0
						if(prob(40))
							fire = 1
						else if(prob(10))
							fire = 2
						if(fire)
							fired = 1
							spawn(rand(30,50)) fired = 0

							var/list/dirs = list(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST)
							if(fire == 1)
								var/tmp_d = dir
								var/dmg = round(Dmg * 1.5 + rand(-4,8))
								for(var/d in dirs)
									dir = d
									castproj(0, 'attacks.dmi', "crucio2", dmg, "death ball", 0, 1)
								dir = tmp_d
							else
								for(var/d in dirs)
									var/obj/Flippendo/S = new (src.loc)
									S.owner = src
									walk(S, d, 2)
									spawn(20) if(S) del S
							sleep(AttackDelay)

			Troll
				icon_state = "troll"
				level = 550
				HPmodifier  = 4
				DMGmodifier = 1.2
				MoveDelay   = 4
				AttackDelay = 4

				drops = list("0.9" = list(/obj/items/Whoopie_Cushion,
			 				  			  /obj/items/Smoke_Pellet,
			 			  				  /obj/items/Tube_of_fun),
			 			  	 "0.7" = list(/obj/items/wearable/bling,
			 			  	 			  /obj/items/bucket,
			 			  	 			  /obj/items/scroll,
			 			  	 			  /obj/items/wearable/title/Troll))

				New()
					..()
					transform *= rand(10,20) / 10

				Attack()
					var/tmpdmg = extraDmg
					var/tmplvl = level
					if(prob(5))
						extraDmg = 600
						level    = 1000
					..()
					extraDmg = tmpdmg
					level    = tmplvl
			House_Elf
				icon_state = "houseelf"
				level = 5
			/*Stone_Golem
				icon = 'Mobs.dmi'
				icon_state="stonegolem"
				level = 6*/
			Dementor
				icon_state = "dementor"
				level = 2000
				Attack()
					if(prob(20))
						step_rand(src)
						sleep(2)

					if(state != HOSTILE) return

					var/distance = get_dist(src, target)
					if(!target || !target.loc || target.loc.loc != loc.loc || distance > Range)
						target = null
						ChangeTarget()
						if(!target)
							ShouldIBeActive()
							return
					if(distance > 1)
						if(prob(10))
							ChangeTarget()

						var/turf/t = get_step_to(src, target, 1)
						if(t)
							Move(t)
						else
							step_rand(src)
							Blocked()
					else
						var/dmg = Dmg+extraDmg+rand(0,4)

						if(target.level > level && !target.findStatusEffect(/StatusEffect/Lamps/Farming))
							dmg -= dmg * ((target.level - level)/100)
						else if(target.level < level)
							dmg += dmg * ((level - target.level)/200)
						dmg = round(dmg)

						if(dmg<1)
								//view(M)<<"<SPAN STYLE='color: blue'>[src]'s attack doesn't even faze [M]</SPAN>"
						else
							if(rand(1,30)==1 && target.findStatusEffect(/StatusEffect/Patronus))
							//	target<<"You're protected by your Patronus Shield"
							else
								target.HP -= dmg
								hearers(target)<<"<SPAN STYLE='color: red'>[src] attacks [target] and causes [dmg] damage!</SPAN>"
								spawn()target.Death_Check(src)
						sleep(AttackDelay)
					Death()
			Dementor_ /////SUMMONED/////
				icon_state = "dementor"
				level = 2000
			//	HPmodifier  = 700
			//	DMGmodifier = 500

			Stickman_ ///SUMMONED///
				icon_state = "stickman"
				level = 2000
			Bird_    ///SUMMONED///
				icon_state = "bird"
				level = 6
			Fire_Bat
				icon_state = "firebat"
				level = 450
				var/tmp/fired = 0
				AttackDelay = 3
				Attack()
					if(!target || !target.loc || target.loc.loc != loc.loc || !(target in ohearers(src,10)))
						target = null
						ShouldIBeActive()
						return

					if(!fired && prob(80))
						fired = 1
						dir=get_dir(src, target)
						castproj(0, 'attacks.dmi', "fireball", Dmg + rand(-4,8), "fire ball")
						spawn(rand(15,30)) fired = 0
						sleep(AttackDelay)

					var/distance = get_dist(src, target)
					if(distance > 5)
						var/turf/t = get_step_to(src, target, 1)
						if(t)
							Move(t)
						else
							target = null
							ShouldIBeActive()
					else if(distance <= 3)
						step_away(src, target)
					else if(distance > 3)
						step_rand(src)
						sleep(2)
			Fire_Dragon
				icon_state = "Dragon"
				level = 1550
				var/tmp/fired = 0
				AttackDelay = 2
				Attack()
					if(!target || !target.loc || target.loc.loc != loc.loc || !(target in ohearers(src,10)))
						target = null
						ShouldIBeActive()
						return

					if(!fired && prob(80))
						fired = 1
						dir=get_dir(src, target)
						castproj(0, 'attacks.dmi', "lavaball", Dmg + rand(-4,8), "lava ball")
						spawn(rand(15,30)) fired = 0
						sleep(AttackDelay)

					var/distance = get_dist(src, target)
					if(distance > 5)
						var/turf/t = get_step_to(src, target, 1)
						if(t)
							Move(t)
						else
							target = null
							ShouldIBeActive()
					else if(distance <= 3)
						step_away(src, target)
					else if(distance > 3)
						step_rand(src)
						sleep(2)
			Fire_Golem
				icon_state = "firegolem"
				level = 500
				AttackDelay = 3
				var/tmp/fired = 0
				Attack()
					if(!target || !target.loc || target.loc.loc != loc.loc || !(target in ohearers(src,10)))
						target = null
						ShouldIBeActive()
						return

					if(!fired && prob(80))
						fired = 1
						dir=get_dir(src, target)
						castproj(0, 'attacks.dmi', "fireball", Dmg + rand(-4,8), "fire ball")
						spawn(rand(15,30)) fired = 0
						sleep(AttackDelay)

					var/distance = get_dist(src, target)
					if(distance > 5)
						var/turf/t = get_step_to(src, target, 1)
						if(t)
							Move(t)
						else
							target = null
							ShouldIBeActive()
					else if(distance < 3)
						step_away(src, target)
					else if(distance >= 3)
						step_rand(src)
						sleep(2)

			Slug
				icon_state = "slug"
				monster=1
				player=0
				New()
					move()
				proc/move()
					spawn(5)
						while(src)
							walk_rand(src,15)
							sleep(100)
							del src
			Archangel
				icon_state = "archangel"
				level = 650
			Water_Elemental
				icon_state = "water elemental"
				level = 700
				canBleed = FALSE
			Fire_Elemental
				icon_state = "fire elemental"
				level = 750
				canBleed = FALSE
			Wyvern
				icon_state = "wyvern"
				level = 850
			Shadow_Monster
				icon = 'Shadow.dmi'
				level = 1250
				canBleed = FALSE

mob
	Stickman_
		icon = 'Mobs.dmi'
		icon_state = "stickman"
		gold = 0
		HP = 50
		MHP = 50
		Def=0
		player = 0
		Dmg = 50
		see_invisible = 1
		Expg = 10
		level = 2
		monster = 1
		NPC = 0
		New()
			. = ..()
			spawn(rand(5,10))
				Wander()
		proc/Wander()
			walk_rand(src,6)
			while(1)
				sleep(10)
				for(var/mob/M in oview(src)) if(M.client)
					walk(src,0)
					spawn()Attack(M)
					return
		proc/Attack(mob/Player/M)
			if(!M)
				spawn()Wander()
				return
			var/dmg = Dmg+rand(0,20)-M.Def
			while(get_dist(src,M)>1)
				sleep(4)
				if(!(M in oview(src)))
					spawn()Wander()
					return
				step_to(src,M)
			if(dmg<1)
				//hearers()<<"<SPAN STYLE='color: blue'>[src]'s sticky stick-ness doesn't even faze [M]</SPAN>"
			else
				M.HP -= dmg
				hearers()<<"<SPAN STYLE='color: red'>[src] sticks [M] with a stick and causes [dmg] damage!</SPAN>"
				spawn()M.Death_Check(src)
			spawn(10)Attack(M)

	Slug
		icon='Mobs.dmi'
		icon_state="slug"
		monster=1
		see_invisible = 1
		HP=25
		gold=0
		player=0
		New()
			move()
			..()
		proc/move()
			spawn(5)
				while(src)
					walk_rand(src,15)
					sleep(100)
					del src
			..()