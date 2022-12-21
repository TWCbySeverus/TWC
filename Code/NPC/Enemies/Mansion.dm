mob
	NPC
		Enemies
			Demon_Pixie
				icon='newPixie.dmi'
				level=900
				HPmodifier  = 1
				DMGmodifier = 0.75
				color = "#ff0000"
				see_in_dark=40
				drops = list("1"   = list(/obj/items/artifact),
							"5" = list(/obj/items/crystal/luck,
									/obj/items/crystal/damage,
									/obj/items/crystal/defense ))
				Death(mob/Player/killer)
					..(killer)

			Demon_Bat
				icon='Demon Bat.dmi'
				color = "#ff0000"
				level=950
				HPmodifier  = 1
				DMGmodifier = 0.75
				drops = list("1"   = list(/obj/items/artifact),
							"5" = list(/obj/items/crystal/luck,
									/obj/items/crystal/damage,
									/obj/items/crystal/defense ))
				Death(mob/Player/killer)
					..(killer)

			Zombie
				icon='MaleZombie.dmi'
				level=1000
				HPmodifier  = 1
				DMGmodifier = 0.8
				New()
					..()
					var/gen = rand(0,1)
					if(gen==0)
						icon='FemaleZombie.dmi'
				drops = list("1"   = list(/obj/items/artifact),
							 "0.01"	= list(/obj/items/wearable/afk/pimp_ring),
							 "5" = list(/obj/items/crystal/magic))
				Death(mob/Player/killer)
					..(killer)

			Werewolf
				icon='Werewolf.dmi'
				level=1100
				HPmodifier  = 1
				DMGmodifier = 0.8
				drops = list("1"   = list(/obj/items/artifact),
							 "0.5"	= list(/obj/items/wearable/bling),
							 "5" = list(/obj/items/crystal/magic))

				Death(mob/Player/killer)
					..(killer)

			Deatheather
				icon = 'Deatheater.dmi'
				level = 1300
				HPmodifier  = 1
				DMGmodifier = 2

				MoveDelay   = 1.5
				AttackDelay = 1.5

				var/tmp/fired = 0

				Range = 16
				respawnTime = 3000


				drops = list("0.5"   = list(/obj/items/wearable/bling),
							 "0.1"   = list(/obj/items/wearable/scarves/black_scarf),
							 "3"   = list(/obj/items/artifact),
							 "0.01"   = list(/obj/items/wearable/shoes/black_shoes),
							 "5" = list(/obj/items/crystal/magic),
							 "1" = list(/obj/items/crystal/soul))



				Death(mob/Player/killer)
					..(killer)
					var/mob/Player/quest_C = killer
					quest_C.checkQuestProgress("DesDaily")
					quest_C.checkQuestProgress("DeProblem")
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
						castproj(0, 'attacks.dmi', "black", Dmg + rand(-4,8), "Chaotica",0,2)