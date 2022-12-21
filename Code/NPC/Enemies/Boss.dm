mob
	NPC
		Enemies
			Rotem
				icon_state = "Rotem"
				level = 5000
				HPmodifier  = 100
				DMGmodifier = 9.5
				MoveDelay   = 1
				AttackDelay = 0.5
				var/tmp/fired = 0
				Range = 18
				respawnTime = 3000
				Death(mob/Player/killer)
					..(killer)


				Attack()
					if(!target || !target.loc || target.loc.loc != loc.loc || !(target in ohearers(src,10)))
						target = null
						ShouldIBeActive()
						return

					if(prob(30))
						ChangeTarget()

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

					if(prob(15) && !fired)
						fired = 1
						spawn(100) fired = 0
						var/list/dirs = list(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST)
						var/tmp_d = dir
						var/dmg = round(Dmg * 0.75) + rand(-4,8)
						for(var/d in dirs)
							dir = d
							castproj(0, 'attacks.dmi', "fireball", dmg, "Incindia", 0, 1)
						dir = tmp_d
					else
						dir=get_dir(src, target)
						if(AttackDelay)	sleep(AttackDelay)
						castproj(0, 'attacks.dmi', "rotemball", Dmg + rand(-4,8), "Glacius")

				Blocked()
					density = 0
					var/turf/t = get_step_to(src, target, 1)
					if(t)
						Move(t)
					else
						..()
					HP+=round(MHP/5)
					dir=get_dir(src, target)
					density = 1

			Stickman
				icon_state = "stickman"
				level = 2200
				HPmodifier  = 35
				DMGmodifier = 3

				MoveDelay   = 2
				AttackDelay = 0

				var/tmp/fired = 0

				Range = 16
				respawnTime = 3000

				New()
					..()
					transform *= 2

				drops = list("20"   = list(/obj/items/crystal/soul,
				                           /obj/items/wearable/title/Surf),
							 "30"   = list(/obj/items/artifact,
							               /obj/items/crystal/magic),
							 "40"   = list(/obj/items/DarknessPowder,
								 		   /obj/items/Whoopie_Cushion,
										   /obj/items/U_No_Poo,
							 			   /obj/items/Smoke_Pellet,
							 			   /obj/items/Tube_of_fun,
							 			   /obj/items/Swamp))

				Attack()
					if(!target || !target.loc || target.loc.loc != loc.loc || !(target in ohearers(src,10)))
						target = null
						ShouldIBeActive()
						return

					if(prob(30))
						ChangeTarget()

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

					if(prob(15) && !fired)
						fired = 1
						spawn(100) fired = 0
						var/list/dirs = list(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST)
						var/tmp_d = dir
						var/dmg = round(Dmg * 0.75) + rand(-4,8)
						for(var/d in dirs)
							dir = d
							castproj(0, 'attacks.dmi', "fireball", dmg, "Incindia", 0, 1)
						dir = tmp_d
					else
						dir=get_dir(src, target)
						if(AttackDelay)	sleep(AttackDelay)
						castproj(0, 'attacks.dmi', "gum", Dmg + rand(-4,8), "Waddiwasi")

				Blocked()
					density = 0
					var/turf/t = get_step_to(src, target, 1)
					if(t)
						Move(t)
					else
						..()
					density = 1

				Death(mob/Player/killer)
					..(killer)

					var/obj/Hogwarts_Door/gate/door = locate("CoSBoss2LockDoor")
					if(door)
						door.door = 1

						var/obj/teleport/portkey/t = new (loc)
						t.dest = "@Hogwarts"

						spawn(respawnTime)
							door.door = 0
							t.loc = null

						spawn(2)
							t.density = 1
							step_rand(t)
							t.density = 0
			Basilisk
				icon_state = "basilisk"
				level = 2000
				HPmodifier = 20
				DMGmodifier = 5
				MoveDelay = 3
				Range = 16
				respawnTime = 3000

				New()
					..()
					transform *= 2

				drops = list("10"   = list(/obj/items/artifact,
										   /obj/items/wearable/title/Petrified,
										   /obj/items/crystal/soul,
										   /obj/items/crystal/magic,
						     			   /obj/items/crystal/strong_luck),
							 "15"   = list(/obj/items/artifact,
										   /obj/items/crystal/damage,
										   /obj/items/crystal/defense,
						     			   /obj/items/crystal/luck),
							 "30"   = list(/obj/items/DarknessPowder,
								 		   /obj/items/Whoopie_Cushion,
										   /obj/items/U_No_Poo,
							 			   /obj/items/Smoke_Pellet,
							 			   /obj/items/Tube_of_fun,
							 			   /obj/items/Swamp))

				var/tmp/fired = 0

				Blocked()
					density = 0
					var/turf/t = get_step_to(src, target, 1)
					if(t)
						Move(t)
					else
						..()
					density = 1

				Attack()
					..()

					if(!fired && target)
						var/d = get_dir(src, target)
						if(!(d & (d - 1)))

							fired = 1
							spawn(rand(50,150)) fired = 0

							var/mob/M = target
							M.movable    = 1
							M.icon_state = "stone"
							M.overlays = null
							spawn(rand(10,30))
								if(M && M.movable)
									M.movable    = 0
									M.icon_state = ""
									M:ApplyOverlays()

				Death(mob/Player/killer)
					..(killer)

					var/obj/Hogwarts_Door/gate/door = locate("CoSLockDoor")
					if(door)
						door.door = 1

						var/obj/teleport/portkey/t = new (loc)
						t.dest = "CoSFloor2"

						spawn(respawnTime)
							door.door = 0
							t.loc = null

						spawn(2)
							t.density = 1
							step_rand(t)
							t.density = 0
			Summoned
				Boss

					Attack()
						..()

					Search()
						Wander()
						for(var/mob/Player/M in ohearers(src, Range))
							if(M.loc.loc != src.loc.loc) continue

							target = M
							state  = HOSTILE

							spawn()
								var/time = 5
								while(src && state == HOSTILE && M == target && time > 0)
									sleep(30)
									time--

								if(M == target && state == HOSTILE)
									target = null
									state = SEARCH

							break


					Blocked()
						density = 0
						var/turf/t = get_step_to(src, target, 1)
						if(t)
							Move(t)
						else
							..()
						density = 1

					Basilisk
						icon_state = "basilisk"
						HPmodifier = 20
						DMGmodifier = 5
						MoveDelay = 3
						level = 2000

						Death()
						New()
							..()
							transform *= 1.5
					Wisp
						icon_state = "wisp"
						name = "Willy the Whisp"
						HPmodifier = 8
						DMGmodifier = 2
						layer = 5
						MoveDelay = 2
						AttackDelay = 1
						Range = 15
						level = 1200
						var/tmp/fired = 0
						var/list/proj = list("gum","gum-old")
						canBleed = FALSE

						drops = list("100" = list(/obj/items/wearable/title/Ghost,
												  /obj/items/lamps/triple_drop_rate_lamp,
												  /obj/items/lamps/triple_gold_lamp,
												  /obj/items/wearable/afk/heart_ring))


						New()
							..()
							alpha = rand(190,240)

							var/color1 = rgb(rand(20, 255), rand(20, 255), rand(20, 255))
							var/color2 = rgb(rand(20, 255), rand(20, 255), rand(20, 255))
							var/color3 = rgb(rand(20, 255), rand(20, 255), rand(20, 255))

							animate(src, color = color1, time = 10, loop = -1)
							animate(color = color2, time = 10)
							animate(color = color3, time = 10)

							transform *= 3 + (rand(-10, 10) / 10)

							spawn()
								while(src.loc)
									proj = pick(list("gum", "quake", "iceball","fireball", "gum-old", "fireball-old", "iceball-old", "quake-old", "", "black") - proj)
									switch(proj)
										if("gum-old")
											animate(src, color = "#fa8bd8", time = 10, loop = -1)
											animate(color = "#c811f1", time = 10)
											animate(color = "#ec06a3", time = 10)
										if("quake-old")
											animate(src, color = "#aa8d84", time = 10, loop = -1)
											animate(color = "#767309", time = 10)
											animate(color = "#a4903d", time = 10)
										if("iceball-old")
											animate(src, color = "#24e3f3", time = 10, loop = -1)
											animate(color = "#a4bcd3", time = 10)
											animate(color = "#4a9ee0", time = 10)
										if("fireball-old")
											animate(src, color = "#dd6103", time = 10, loop = -1)
											animate(color = "#b21039", time = 10)
											animate(color = "#b81114", time = 10)
										if("gum")
											animate(src, color = "#fa8bd8", time = 10, loop = -1)
											animate(color = "#c811f1", time = 10)
											animate(color = "#ec06a3", time = 10)
										if("quake")
											animate(src, color = "#aa8d84", time = 10, loop = -1)
											animate(color = "#767309", time = 10)
											animate(color = "#a4903d", time = 10)
										if("iceball")
											animate(src, color = "#24e3f3", time = 10, loop = -1)
											animate(color = "#a4bcd3", time = 10)
											animate(color = "#4a9ee0", time = 10)
										if("fireball")
											animate(src, color = "#dd6103", time = 10, loop = -1)
											animate(color = "#b21039", time = 10)
											animate(color = "#b81114", time = 10)
										if("black")
											animate(src, color = "#000000", time = 10, loop = -1)
											animate(color = "#ffffff", time = 10)
										if("")
											animate(src, color = "#0e3492", time = 10, loop = -1)
											animate(color = "#2a32fb", time = 10)
											animate(color = "#cdf0e3", time = 10)
									sleep(200)

						Attack(mob/M)
							..()
							if(!fired && target && state == HOSTILE)
								fired = 1
								spawn(rand(30,50)) fired = 0

								for(var/obj/redroses/S in oview(3, src))
									flick("burning", S)
									spawn(8) S.loc = null

								if(prob(80))
									var/list/dirs = list(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST)
									var/tmp_d = dir
									for(var/d in dirs)
										dir = d
										castproj(0, 'attacks.dmi', "fireball-old", Dmg + rand(-4,8), "fire ball", 0, 1)
									dir = tmp_d
									sleep(AttackDelay)

						Attacked(projname, damage)
							if(proj in projname && prob(99))
								emit(loc    = src,
									 ptype  = /obj/particle/red,
								     amount = 2,
								     angle  = new /Random(1, 359),
								     speed  = 2,
								     life   = new /Random(15,20))
							else
								HP+=round(damage/2)

								emit(loc    = src,
									 ptype  = /obj/particle/green,
								     amount = 2,
								     angle  = new /Random(1, 359),
								     speed  = 2,
								     life   = new /Random(15,20))

					Snowman
						icon = 'Snowman.dmi'
						name = "The Evil Snowman"
						HPmodifier = 10
						DMGmodifier = 0.5
						layer = 5
						MoveDelay = 3
						AttackDelay = 2
						Range = 15
						level = 1000
						var/tmp/fired = 0
						extraDmg = 400

						drops = list("100" = list(/obj/items/wearable/title/Snowflakes,
												  /obj/items/lamps/triple_drop_rate_lamp,
												  /obj/items/lamps/triple_gold_lamp,
												  /obj/items/wearable/afk/hot_chocolate))

						Attack(mob/M)
							..()
							if(!fired && target && state == HOSTILE)
								if(prob(40))
									fired = 1
									spawn(rand(30,50)) fired = 0

									var/list/dirs = list(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST)
									var/tmp_d = dir
									var/dmg = round((Dmg+extraDmg) * 1.5 + rand(-4,8))
									for(var/d in dirs)
										dir = d
										castproj(0, 'attacks.dmi', "snowball", dmg, "snowball", 0, 1)
									dir = tmp_d
									sleep(AttackDelay)
						Attacked()
							..()
							if(HP > 0)
								var/percent = MHP / HP
								var/matrix/M = matrix()*percent
								transform = M

								extraDmg = percent * 400

								if(percent >= 5)
									MoveDelay = 1
								else if(percent >= 3)
									AttackDelay = 1
								else if(percent >= 2)
									MoveDelay = 2

					Stickman
						icon_state = "stickman"
						level = 3000
						HPmodifier  = 30
						DMGmodifier = 1.25

						MoveDelay   = 3
						AttackDelay = 4

						var/tmp/fired = 0

						Attack()
							if(!target || !target.loc || target.loc.loc != loc.loc || !(target in ohearers(src,10)))
								target = null
								ShouldIBeActive()
								return

							if(prob(30))
								ChangeTarget()

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

							if(prob(15) && !fired)
								fired = 1
								spawn(100) fired = 0
								var/list/dirs = list(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST)
								var/tmp_d = dir
								var/dmg = round(Dmg * 0.75) + rand(-4,8)
								for(var/d in dirs)
									dir = d
									castproj(0, 'attacks.dmi', "fireball", dmg, "Incindia", 0, 1)
								dir = tmp_d
							else
								dir=get_dir(src, target)
								if(AttackDelay)	sleep(AttackDelay)
								castproj(0, 'attacks.dmi', "gum", Dmg + rand(-4,8), "Waddiwasi")
					Rotem
						icon_state = "Rotem"
						level = 4000
						HPmodifier  = 55
						DMGmodifier = 3.5

						MoveDelay   = 0.5
						AttackDelay = 0.5

						var/tmp/fired = 0

						Death(mob/Player/killer)
							..(killer)

						New()
							..()
							spawn(1)GenerateNameOverlay(255,102,255)
							..()
						Attack()
							if(!target || !target.loc || target.loc.loc != loc.loc || !(target in ohearers(src,10)))
								target = null
								ShouldIBeActive()
								return

							if(prob(30))
								ChangeTarget()

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

							if(prob(15) && !fired)
								fired = 1
								spawn(100) fired = 0
								var/list/dirs = list(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST)
								var/tmp_d = dir
								var/dmg = round(Dmg * 0.75) + rand(-4,8)
								for(var/d in dirs)
									dir = d
									castproj(0, 'attacks.dmi', "fireball", dmg, "Incindia", 0, 1)
								dir = tmp_d
							else if(prob(5))
								HP+=round(MHP/5)
								dir=get_dir(src, target)
								if(AttackDelay)	sleep(AttackDelay)
								castproj(0, 'attacks.dmi', "rotemball", Dmg + rand(-4,8), "Glacius")
							else
								dir=get_dir(src, target)
								if(AttackDelay)	sleep(AttackDelay)
								castproj(0, 'attacks.dmi', "rotemball", Dmg + rand(-4,8), "Glacius")


