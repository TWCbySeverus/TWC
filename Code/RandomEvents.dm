WorldData/var/tmp/list/events

proc/init_random_events()
	worldData.events = list()
	for(var/e in typesof(/RandomEvent/)-/RandomEvent)
		worldData.events += new e
	bubblesort_by_value(worldData.events, "chance")
	scheduler.schedule(new/Event/RandomEvents, rand(3000, 36000)) // 5 minutes to 1 hour


WorldData/var/tmp/list/spawners = list()

obj/spawner
	invisibility = 10
	post_init = 1

	MapInit()
		worldData.spawners += src

WorldData/var/tmp/list/currentEvents

RandomEvent
	var
		chance = 10
		name
		beepType = 1

		tmp
			endTime
			desc

	proc
		start()
			set waitfor = 0
			if(!worldData.currentEvents) worldData.currentEvents = list()

			if(name in worldData.currentEvents)
				worldData.currentEvents[src]++
			else
				worldData.currentEvents[src] = 1

			for(var/mob/Player/p in Players)
				p.beep(beepType)

		end()
			worldData.currentEvents[src]--
			if(worldData.currentEvents[src] <= 0)
				worldData.currentEvents -= src

			if(worldData.currentEvents.len == 0) worldData.currentEvents = null

			endTime = null
			desc = null

	GMClass
		name = "Special Class"
		beepType = 2
		chance = 0

		start()
			..()
			var/time = 600*10
			endTime = world.time + time
			sleep(time)
			if(!endTime) return
			if(classdest)
				classdest = null

				for(var/mob/Player/M in Players)
					if(M.classpathfinding)
						for(var/image/C in M.client.images)
							if(C.icon == 'arrows.dmi')
								M.client.images.Remove(C)
						M.classpathfinding = 0
			end()

	Tournament
		name   = "Tournament"
		chance = 4
		var/tmp/mob/Player/winner

		start()
			set waitfor = 0
			if(name in worldData.currentEvents)	return

			worldData.tournamentSummon = 1
			worldData.tournamentLobby = list()

			..()

			for(var/minutes = 5 to 1 step -1)
				for(var/mob/Player/p in Players)
					p << "<h3>An automated tournament is beginning soon. If you wish to participate, <a href=\"byond://?src=\ref[p];action=tournament\">click here.</a> It will start in [minutes] minutes.</h3>"

				sleep(600)

			worldData.tournamentPlayers = list()
			worldData.tournamentSummon = 0

			for(var/c in worldData.tournamentLobby)
				var/mob/Player/player
				for(var/mob/Player/p in Players)
					if(p.ckey == c)
						player = p
						break

				if(player)
					worldData.tournamentPlayers += player
				else
					worldData.tournamentLobby -= c

			if(worldData.tournamentLobby.len < 2)
				worldData.tournamentLobby = null
				worldData.tournamentPlayers = null
				worldData.tournamentSummon = 0
				Players << errormsg("Tournament cancelled, not enough players.")
				end()
				return

			while(worldData.tournamentLobby.len > 1)

				while(worldData.tournamentPlayers.len > 1)
					var/player1 = pick(worldData.tournamentPlayers)
					worldData.tournamentPlayers -= player1

					var/player2 = pick(worldData.tournamentPlayers)
					worldData.tournamentPlayers -= player2

					worldData.tournamentSummon--

					spawn()
						worldData.currentMatches.addArena(player1, player2)

				worldData.tournamentPlayers = list()

				while(worldData.tournamentSummon < 0)
					sleep(1)

				for(var/c in worldData.tournamentLobby)
					var/mob/Player/player
					for(var/mob/Player/p in Players)
						if(p.ckey == c)
							player = p
							break

					if(player)
						worldData.tournamentPlayers += player
					else
						worldData.tournamentLobby -= c

			if(worldData.tournamentLobby.len == 1)
				var/mob/Player/winner
				for(var/mob/Player/p in Players)
					if(p.ckey == worldData.tournamentLobby[1])
						winner = p
						break

				if(winner)
					Players << infomsg("<b>[winner] has won the duel tournament.</b>")

					var/i = pickweight(list(/obj/items/key/duel_key       = 10,
										    /obj/items/artifact           = 20,
		                        		    /obj/items/key/wizard_key     = 20,
		                        		    /obj/items/key/pentakill_key  = 20,
								   		    /obj/items/key/sunset_key     = 10,
										    /obj/items/key/winter_key     = 10))

					var/obj/items/item_prize = new i (winner)
					winner << infomsg("You recieve [item_prize.name] as prize for winning the tournament, congratulations!")

			worldData.tournamentLobby = null
			worldData.tournamentPlayers = null
			worldData.tournamentSummon = 0

			end()

	FFA
		name   = "Free For All"
		chance = 6
		var/tmp/mob/Player/winner

		start(gameMode)
			set waitfor = 0
			if(worldData.currentArena || (name in worldData.currentEvents))	return

			..()
			worldData.arenaSummon = 3

			var/rounds = rand(2,4)
			var/obj/clock/timer = locate("FFAtimer")

			if(!gameMode) gameMode = pick("Normal","One Hit Kill", "Undying", "4 Hit Kill", "Survival")

			var/area/a = locate(/area/arenas/MapThree/PlayArea)
			if(gameMode == "One Hit Kill")
				a.scaleDamage = 1
			else if(gameMode == "Undying")
				a.undead = 1
			else if(gameMode == "4 Hit Kill")
				a.scaleDamage = 4
			else if(gameMode == "Survival")
				a.friendlyFire = 0

			var/maxRounds = rounds

			for(var/mob/Player/p in Players)
				p << "<h3>An automated FFA is beginning soon. Game mode: <span  style=\"color:red\">[gameMode]</span>. If you wish to participate, <a href=\"byond://?src=\ref[p];action=arena_teleport\">click here to teleport.</a> The first round will start in 2 minutes.</h3>"

			sleep(600)
			while(rounds)
				rounds--
				desc = "Round [maxRounds-rounds]/[maxRounds]"
				worldData.arenaSummon = 3
				for(var/mob/Player/p in Players)
					p << "<h3>An automated FFA is beginning soon. Game mode: <span  style=\"color:red\">[gameMode]</span>. If you wish to participate, <a href=\"byond://?src=\ref[p];action=arena_teleport\">click here to teleport.</a> The [rounds==0 ? "last" : ""] round will start in 1 minute.</h3>"
				sleep(600)
				worldData.currentArena = new()
				worldData.arenaSummon = 0
				worldData.currentArena.roundtype = FFA_WARS
				for(var/mob/Player/M in locate(/area/arenas/MapThree/WaitingArea))
					worldData.currentArena.players.Add(M)
				if(worldData.currentArena.players.len < 2)
					worldData.currentArena.players << "There isn't enough players to start the round."

					for(var/mob/m in worldData.currentArena.players)
						m << "<b>You can leave at any time when a round hasn't started by <a href=\"byond://?src=\ref[m];action=arena_leave\">clicking here.</a></b>"
					del(worldData.currentArena)
				else
					worldData.currentArena.players << "<center><font size = 4>The arena mode is <u>Free For All</u>. Everyone is your enemy.<br>The last person standing wins!</center>"
					sleep(30)
					worldData.currentArena.players << "<h5>Round starting in 10 seconds</h5>"
					sleep(50)
					worldData.currentArena.players << "<h5>5 seconds</h5>"
					sleep(10)
					worldData.currentArena.players << "<h5>4 seconds</h5>"
					sleep(10)
					worldData.currentArena.players << "<h5>3 seconds</h5>"
					sleep(10)
					worldData.currentArena.players << "<h5>2 seconds</h5>"
					sleep(10)
					worldData.currentArena.players << "<h5>1 seconds</h5>"
					sleep(10)
					worldData.currentArena.players << "<h4>Go!</h5>"
					worldData.currentArena.started = 1

					var/count = worldData.currentArena.players.len

					var/list/rndturfs = list()
					for(var/turf/T in locate(/area/arenas/MapThree/PlayArea))
						rndturfs.Add(T)
					worldData.currentArena.speaker = pick(MapThreeWaitingAreaTurfs)

					var/highestLevel = 1
					for(var/mob/Player/M in worldData.currentArena.players)
						var/turf/T = pick(rndturfs)
						M.loc = T
						M.density = 1
						M.HP = M.MHP
						M.MP = M.MMP
						M.updateHPMP()

						if(M.level > highestLevel) highestLevel = M.level

					timer.invisibility = 0
					timer.setTime(gameMode == "Survival" ? 4 : 6)

					var/list/m = gameMode == "Survival" ? list() : null

					while(worldData.currentArena && !timer.countdown())
						if(gameMode == "Survival")
							var/turf/spawnLoc = pick(rndturfs)
							var/monsterType = pick("Slug", "Rat", "Pixie", "Dog", "Snake", "Wolf", "Troll", "Spider", "Stickman")
							var/mob/Enemies/Summoned/monster = new (spawnLoc)

							monster.DMGmodifier = 0.8
							monster.HPmodifier  = 1.2
							monster.level       = highestLevel + rand(50)
							monster.name        = monsterType
							monster.icon_state  = lowertext(monsterType)
							monster.icon        = 'Mobs.dmi'
							monster.calcStats()

							m += monster
						sleep(10)

					timer.invisibility = 2

					if(m)
						for(var/mob/Enemies/Summoned/monster in m)
							monster.Dispose()
							monster.ChangeState(monster.INACTIVE)
							m -= monster
						m = null

					if(worldData.currentArena)
						while(worldData.currentArena && worldData.currentArena.players && worldData.currentArena.players.len > 1)
							var/mob/Player/p = pick(worldData.currentArena.players)
							p.HP = 0
							p.Death_Check()

					if(winner)
						var/prize = 15000 * (count + 1)
						var/gold/g = new(bronze=prize)
						g.give(winner)
						winner << infomsg("You won [g.toString()] for winning the round.")
						goldlog << "[time2text(world.realtime,"MMM DD YYYY - hh:mm")]: (FFA) [winner.name] won [comma(prize)] gold.<br />"

			if(a)
				a.scaleDamage = 0
				a.friendlyFire = 1
				if(a.undead)
					a.undead = 0
					for(var/mob/Enemies/Summoned/Zombie/z in a)
						z.Dispose()
						z.ChangeState(z.INACTIVE)

			end()

	HouseWars
		name   = "House Wars"
		chance = 3
		var/tmp/mob/Player/winner

		start(gameMode)
			set waitfor = 0
			if(worldData.currentArena || (name in worldData.currentEvents))	return

			..()
			worldData.arenaSummon = 1

			var/obj/clock/timer = locate("HWtimer")

			if(!gameMode) gameMode = pick("Normal","One Hit Kill","4 Hit Kill")

			var/list/areas = list()

			areas += locate(/area/arenas/MapOne/Gryff)
			areas += locate(/area/arenas/MapOne/Slyth)
			areas += locate(/area/arenas/MapOne/Huffle)
			areas += locate(/area/arenas/MapOne/Raven)

			var/mob/mapName = locate("MapOne")
			areas += mapName.loc.loc

			if(gameMode == "One Hit Kill")
				for(var/area/a in areas)
					a.scaleDamage = 1
			else if(gameMode == "4 Hit Kill")
				for(var/area/a in areas)
					a.scaleDamage = 4

			for(var/mob/Player/p in Players)
				p << "<h3>An automated House Wars is beginning soon. Game mode: <span  style=\"color:red\">[gameMode]</span>. If you wish to participate, <a href=\"byond://?src=\ref[p];action=arena_teleport\">click here to teleport.</a> Starts in 2 minutes.</h3>"
			sleep(600)
			for(var/mob/Player/p in Players)
				p << "<h3>An automated House Wars is beginning soon. Game mode: <span  style=\"color:red\">[gameMode]</span>. If you wish to participate, <a href=\"byond://?src=\ref[p];action=arena_teleport\">click here to teleport.</a> Starts in 1 minute.</h3>"
			sleep(600)
			worldData.currentArena = new()
			worldData.arenaSummon = 0
			worldData.currentArena.roundtype = HOUSE_WARS

			var/list/houses = list()
			for(var/area/a in areas)
				for(var/mob/Player/p in a)
					worldData.currentArena.players.Add(p)

					if(p.House in houses)
						houses[p.House]++
					else
						houses[p.House] = 0

			if(houses.len < 2)
				worldData.currentArena.players << "There isn't enough players to start the round."

				for(var/mob/m in worldData.currentArena.players)
					m << "<b>You can leave at any time when a round hasn't started by <a href=\"byond://?src=\ref[m];action=arena_leave\">clicking here.</a></b>"
				del(worldData.currentArena)
			else
				worldData.currentArena.players << "<u>Preparing arena round...</u>"

				worldData.currentArena.goalpoints = 10
				worldData.currentArena.teampoints = list("Gryffindor" = 0, "Ravenclaw" = 0, "Slytherin" = 0,"Hufflepuff" = 0)
				worldData.currentArena.plyrSpawnTime = 5
				worldData.currentArena.amountforwin = 10
				for(var/mob/Player/M in worldData.currentArena.players)
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
					M.HP = M.MHP
					M.MP = M.MMP
					M.updateHPMP()
				worldData.currentArena.players << "<center><font size = 4>The arena mode is <u>House Wars</u>.<br>The first house to reach [worldData.currentArena.goalpoints] arena points wins [worldData.currentArena.amountforwin] house points!"
				sleep(30)
				if(!worldData.currentArena) return
				worldData.currentArena.players << "<h5>Round starting in 10 seconds</h5>"
				sleep(100)
				if(!worldData.currentArena) return
				worldData.currentArena.players << "<h4>Go!</h5>"
				worldData.currentArena.started = 1

				timer.invisibility = 0
				timer.setTime(6)

				while(worldData.currentArena && !timer.countdown())
					sleep(10)

				timer.invisibility = 2

				if(worldData.currentArena)
					var/team
					var/points = 0

					for(var/i in worldData.currentArena.teampoints)
						if(worldData.currentArena.teampoints[i] > points)
							points = worldData.currentArena.teampoints[i]
							team = i

					worldData.currentArena.players << "<h4>[team] win!</h4>"
					for(var/mob/M in worldData.currentArena.players)
						M << "<b>You can leave at any time when a round hasn't started by <a href=\"byond://?src=\ref[M];action=arena_leave\">clicking here.</a></b>"
					switch(team)
						if("Gryffindor")
							worldData.housepointsGSRH[1] += worldData.currentArena.amountforwin
						if("Slytherin")
							worldData.housepointsGSRH[2] += worldData.currentArena.amountforwin
						if("Ravenclaw")
							worldData.housepointsGSRH[3] += worldData.currentArena.amountforwin
						if("Hufflepuff")
							worldData.housepointsGSRH[4] += worldData.currentArena.amountforwin

					if(team && points != 0)
						Players << "\red[team] have earned [worldData.currentArena.amountforwin] points."
						Save_World()
					del(worldData.currentArena)

			if(gameMode == "One Hit Kill" || gameMode == "One Hit Kill")
				for(var/area/a in areas)
					a.scaleDamage = 0

			end()

	Class
		name = "Class"
		beepType = 2

		start(var/spell, var/time=30, var/subject)
			set waitfor = 0


			if(!spell)
				var/list/spells = spellList ^ list(/mob/Spells/verb/Self_To_Dragon, /mob/Spells/verb/Self_To_Human, /mob/Spells/verb/Episky, /mob/Spells/verb/Inflamari)

				if(spells.len == worldData.spellsHistory.len)
					worldData.spellsHistory = list()
				else
					spells ^= worldData.spellsHistory

				spell = pick(spells)
				worldData.spellsHistory += spell

			else if(!(spell in worldData.spellsHistory))
				worldData.spellsHistory += spell

			var/class/c

			for(var/t in typesof(/class/))
				if(ends_with("[t]", replacetext(spellList[spell], " ", "_")))
					c = new t
					break

			if(c)
				c.name      = spellList[spell]
				c.spelltype = spell
				curClass    = c.subject

				if(!subject) subject = c.subject

				classdest   = locate("[subject] Class")

				var/obj/teacher/t = new (classdest.loc)
				t.classInfo = c
				c.professor = t

				var/area/hogwarts/class/h = t.loc.loc
				if(istype(h, /area/hogwarts/class))
					h.class = c
				else
					end()
					return

				..()

				endTime = world.time + 600*5

				for(var/i = 5; i > 0; i--)
					for(var/mob/Player/p in Players)
						p << announcemsg("[c.subject] class is starting in [i] minute[i > 1 ? "s" : ""] for [c.name]. Click <a href=\"?src=\ref[p];action=class_path\">here</a> for directions.")
					sleep(600)


				c.start()

				endTime = world.time + 600*time

				sleep(600 * time)

				while(world.time - c.lastTaught <= 1200)
					sleep(1200)

				Players << announcemsg("[c.subject] class has ended.")

				if(h) h.class = null

				t.loc = null
				t.classInfo = null
				c.professor = null
				classdest = null

				for(var/mob/Player/M in Players)
					if(M.classpathfinding)
						for(var/image/C in M.client.images)
							if(C.icon == 'arrows.dmi')
								M.client.images.Remove(C)
						M.classpathfinding = 0
				end()
			else
				world.log << "TWC Error: [spell] not found in class type list (Class.dmi)"


	TheEvilSnowman
		name = "The Evil Snowman"
		start()
			set waitfor = 0
			..()
			var/minutes = rand(15,30)
			var/list/m = list()
			Players << infomsg("The Evil Snowman and his army appeared at Hogwarts grounds (behind the castle), defend yourselves until reinforcements arrive! Reinforcements will arrive in [minutes] minutes, if you manage to kill the evil snowman before then you might be able to get a nice prize!")

			var/obj/spawner/spawn_loc = pick(worldData.spawners)
			var/mob/Enemies/Summoned/Boss/monster = new /mob/Enemies/Summoned/Boss/Snowman(spawn_loc.loc)
			m += monster
			for(var/i = 1 to rand(15,40))
				spawn_loc = pick(worldData.spawners)
				monster = new (spawn_loc.loc)

				monster.DMGmodifier = 1
				monster.HPmodifier  = 1.5
				monster.MoveDelay   = 3
				monster.AttackDelay = 3
				monster.level       = 600
				monster.name        = "Snowman"
				monster.icon        = 'Snowman.dmi'
				monster.color       = rgb(rand(0, 255), rand(0, 255), rand(0, 255))
				monster.calcStats()
				m += monster

			endTime = world.time + 600*minutes
			sleep(minutes * 600)

			var/message = 0
			for(var/mob/Enemies/Summoned/mon in m)
				if(mon.loc != null) message = 1
				mon.Dispose()
				mon.ChangeState(monster.INACTIVE)
				m -= mon
			m = null

			if(message) Players << infomsg("The evil snowman and his minions have magically vanished by the powers of the ministry.")
			end()

	WillytheWhisp
		name = "Willy the Whisp"
		start()
			set waitfor = 0
			..()
			var/minutes = rand(15,30)
			var/list/m = list()
			Players << infomsg("Willy the Whisp and his army are haunting right outside at Hogwarts grounds (behind the castle), defend yourselves until ghostbus---- reinforcements arrive! Reinforcements will arrive in [minutes] minutes, if you manage to kill Willy the Whisp before then you might be able to get a nice prize!")

			var/obj/spawner/spawn_loc = pick(worldData.spawners)
			var/mob/Enemies/Summoned/Boss/monster = new /mob/Enemies/Summoned/Boss/Wisp(spawn_loc.loc)
			m += monster
			for(var/i = 1 to rand(15,40))
				spawn_loc = pick(worldData.spawners)
				monster = new (spawn_loc.loc)

				monster.DMGmodifier = 1
				monster.HPmodifier  = 1.5
				monster.MoveDelay   = 3
				monster.AttackDelay = 3
				monster.level       = 650
				monster.name        = "Wisp"
				monster.icon_state  = "wisp"
				monster.icon        = 'Mobs.dmi'
				monster.color       = rgb(rand(0, 255), rand(0, 255), rand(0, 255))
				monster.alpha       = rand(125, 240)
				monster.calcStats()
				m += monster

			endTime = world.time + 600*minutes
			sleep(minutes * 600)

			var/message = 0
			for(var/mob/Enemies/Summoned/mon in m)
				if(mon.loc != null) message = 1
				mon.Dispose()
				mon.ChangeState(monster.INACTIVE)
				m -= mon
			m = null

			if(message) Players << infomsg("Willy the Whisp and his minions have magically vanished by the powers of the ministry.")
			end()

	Haunted_Castle
		name   = "Haunted Castle"
		chance = 0

		start()
			set waitfor = 0
			..()

			var/waves = rand(3,5)
			Players << errormsg("<b>Warning:</b> Hogwarts magical defenses are being suppressed by a dark ghostly evil magic, Entrance Hall will be invaded by vengeful ghosts in 5 minutes for [waves] waves! Every wave will last 4 minutes.<br>Move to another area (The library, common room, second floor etc) if you wish to remain safe.")
			sleep(600)
			for(var/i = 4 to 1 step -1)
				Players << errormsg("<b>Warning:</b> Entrance Hall will be invaded by vengeful ghosts in [i] minute[i > 1 ? "s" : ""]!")
				sleep(600)
			Players << errormsg("<b>Warning:</b> Entrance Hall will become a kill zone and invaded in 10 seconds!") // extra 10 seconds to ensure afk sign toggles on
			sleep(100)

			var/area/entrance = locate(/area/hogwarts/Entrance_Hall)
			for(var/mob/Player/p in entrance)
				if(p.away) p.loc = locate("@GreatHall")

			var/useOverride = entrance.safezoneoverride
			var/useTime    = entrance.timedProtection

			entrance.friendlyFire     = 0
			entrance.safezoneoverride = 1
			entrance.timedProtection = 0


			var/turf/spawn_loc = locate("@Hogwarts")

			for(var/i = 1 to waves)

				Players << infomsg("Wave [i]: Ghosts are invading, defend the castle!")

				var/list/monsters = list()

				for(var/j = 1 to rand(5,10))
					monsters += new /mob/Enemies/Summoned/Boss/Ghost(spawn_loc)

				sleep(2400)

				for(var/mob/Enemies/ai in monsters)
					Respawn(ai)

			entrance.friendlyFire     = 1
			entrance.safezoneoverride = useOverride
			entrance.timedProtection = useTime

			Players << infomsg("Hogwarts magical defenses are restored. Entrance Hall is safe again.")
			end()

	Ghosts
		name = "Ghost Invasion"
		chance = 13
		start()
			set waitfor = 0
			..()
			var/minutes = rand(10,20)
			var/list/m = list()
			Players << infomsg("Vengeful ghosts are lurking outside the castle at Hogwarts grounds (behind the castle) for [minutes] minutes, chase them away!")

			for(var/i = 1 to rand(18,30))
				var/obj/spawner/spawn_loc = pick(worldData.spawners)
				m += new /mob/Enemies/Summoned/Boss/Ghost (spawn_loc.loc)

			endTime = world.time + 600*minutes
			sleep(minutes * 600)

			var/message = 0
			for(var/mob/Enemies/Summoned/mon in m)
				if(mon.loc != null) message = 1
				mon.loc = null
				mon.ChangeState(mon.INACTIVE)
				m -= mon
			m = null

			if(message) Players << infomsg("The ghosts got bored and ran off to lurk somewhere else.")
			end()

	Spider
		name = "Spiders"
		start()
			set waitfor = 0
			..()
			var/minutes = rand(15,30)
			var/list/m = list()
			Players << infomsg("Something doesn't quite smell right outside at Hogwarts grounds (behind the castle), be cautious, evil forces are crawling, defend yourselves until reinforcements arrive! Reinforcements will arrive in [minutes] minutes, if you manage to ...butcher them... before then you might be able to get a nice prize!")

			var/obj/spawner/spawn_loc = pick(worldData.spawners)
			var/mob/Enemies/Summoned/monster = new /mob/Enemies/Summoned/Boss/Acromantula(spawn_loc.loc)
			m += monster
			for(var/i = 1 to rand(10,30))
				spawn_loc = pick(worldData.spawners)
				monster = new /mob/Enemies/Summoned/Acromantula (spawn_loc.loc)

				m += monster

			endTime = world.time + 600*minutes
			sleep(minutes * 600)

			var/message = 0
			for(var/mob/Enemies/Summoned/mon in m)
				if(mon.loc != null) message = 1
				mon.Dispose()
				mon.ChangeState(monster.INACTIVE)
				m -= mon
			m = null

			if(message) Players << infomsg("The pesky spiders were exterminated. All hail the dalek--- ministry.")
			end()

	VampireLord
		name   = "Vampire Lord"
		chance = 0
		start()
			set waitfor = 0
			..()
			var/minutes = rand(15,30)
			var/list/m = list()
			Players << infomsg("A vampire lord has been lured outside of the castle at Hogwarts grounds (behind the castle) for [minutes] minutes, the vicious creature brought an army, it appears old and wealthy, maybe it carries valuables, slay it to find out!")

			var/obj/spawner/spawn_loc = pick(worldData.spawners)
			var/mob/Enemies/Summoned/monster = new /mob/Enemies/Summoned/Boss/VampireLord(spawn_loc.loc)
			m += monster
			for(var/i = 1 to rand(15, 30))
				spawn_loc = pick(worldData.spawners)
				monster = new /mob/Enemies/Summoned/Acromantula (spawn_loc.loc)

			for(var/i = 1 to rand(5, 10))
				spawn_loc = pick(worldData.spawners)
				monster = new /mob/Enemies/Summoned/Boss/Ghost (spawn_loc.loc)

				m += monster

			endTime = world.time + 600*minutes
			sleep(minutes * 600)

			var/message = 0
			for(var/mob/Enemies/Summoned/mon in m)
				if(mon.loc != null) message = 1
				mon.Dispose()
				mon.ChangeState(monster.INACTIVE)
				m -= mon
			m = null

			if(message) Players << infomsg("The vampire lord and his army vanished to darkness.")
			end()

	Zombie
		name   = "Zombie"
		chance = 1
		start()
			set waitfor = 0
			..()
			var/minutes = rand(15,30)
			var/list/m = list()
			Players << infomsg("A zombie has appeared outside (behind the castle) for [minutes] minutes, kill zombie before it infects others!")

			var/obj/spawner/spawn_loc = pick(worldData.spawners)
			var/mob/Enemies/Summoned/monster = new /mob/Enemies/Summoned/Boss/Zombie(spawn_loc.loc)
			m += monster

			for(var/i = 1 to 15)
				spawn_loc = pick(worldData.spawners)
				monster = new /mob/Enemies/Summoned/Boss/Ghost (spawn_loc.loc)

				m += monster

			var/area/a = spawn_loc.loc.loc
			a.undead = 1

			endTime = world.time + 600*minutes
			sleep(minutes * 600)

			for(var/mob/Enemies/Summoned/Zombie/z in a)
				z.Dispose()
				z.ChangeState(monster.INACTIVE)

			a.undead = 0

			var/message = 0
			for(var/mob/Enemies/Summoned/mon in m)
				if(mon.loc != null) message = 1
				mon.Dispose()
				mon.ChangeState(monster.INACTIVE)
				m -= mon
			m = null

			if(message) Players << infomsg("The zombies are gone... for now.")
			end()

	Sword
		name   = "The Black Blade"
		chance = 0
		var/swords = 0
		start()
			set waitfor = 0
			..()
			var/minutes = rand(15,30)
			var/list/m = list()
			Players << infomsg("The Black Blade has appeared outside (behind the castle) for [minutes] minutes, destroy the blade!")

			var/obj/spawner/spawn_loc = pick(worldData.spawners)
			var/mob/Enemies/Summoned/monster = new /mob/Enemies/Summoned/Boss/Sword(spawn_loc.loc)
			m += monster

			for(var/i = 1 to 5)
				spawn_loc = pick(worldData.spawners)
				monster = new /mob/Enemies/Summoned/Boss/Ghost (spawn_loc.loc)

				m += monster

			endTime = world.time + 600*minutes
			sleep(minutes * 600)

			var/area/a = spawn_loc.loc.loc
			for(var/mob/Enemies/Summoned/Sword/s in a)
				s.Dispose()
				s.ChangeState(monster.INACTIVE)

				if(s.s)
					s.s.loc = null
					s.s = null

			swords = 0

			var/message = 0
			for(var/mob/Enemies/Summoned/mon in m)
				if(mon.loc != null) message = 1
				mon.Dispose()
				mon.ChangeState(monster.INACTIVE)
				m -= mon
			m = null

			if(message) Players << infomsg("The Dark Blade disappeared.")
			end()

	Golem
		name   = "Stone Golem"
		chance = 0
		start()
			set waitfor = 0
			..()
			var/minutes = rand(15,30)
			var/list/m = list()
			Players << infomsg("The elder wand's magical force is possessing a stone construct outside (behind the castle) for [minutes] minutes, destroy the stone construct to harness the power of the broken elder wand!")

			var/obj/spawner/spawn_loc = pick(worldData.spawners)
			var/mob/Enemies/Summoned/monster = new /mob/Enemies/Summoned/Boss/Golem(spawn_loc.loc)
			m += monster

			for(var/i = 1 to rand(5, 15))
				spawn_loc = pick(worldData.spawners)
				monster = new /mob/Enemies/Summoned/Boss/Ghost (spawn_loc.loc)

				m += monster

			endTime = world.time + 600*minutes
			sleep(minutes * 600)

			var/message = 0
			for(var/mob/Enemies/Summoned/mon in m)
				if(mon.loc != null) message = 1
				mon.Dispose()
				mon.ChangeState(monster.INACTIVE)
				m -= mon
			m = null

			if(message) Players << infomsg("The stone golem's magic force vanished.")
			end()

	EntranceKillZone
		name   = "Entrance Kill Zone"
		chance = 4
		start()
			set waitfor = 0
			..()
			var/minutes = rand(10,20)
			Players << errormsg("<b>Warning:</b> Hogwarts magical defenses are being suppressed by a dark evil magic, Entrance Hall will become a kill zone in 5 minutes for [minutes] minutes!<br>Move to another area (The library, common room, second floor etc) if you wish to remain safe.")
			sleep(600)
			for(var/i = 4 to 1 step -1)
				Players << errormsg("<b>Warning:</b> Entrance Hall will become a kill zone in [i] minute[i > 1 ? "s" : ""]!")
				sleep(600)
			Players << errormsg("<b>Warning:</b> Entrance Hall will become a kill zone in 10 seconds!") // extra 10 seconds to ensure afk sign toggles on
			sleep(100)
			Players << infomsg("Entrance Hall is now a kill zone for [minutes] minutes, defend yourselves from dark wizards who can now enter or other students who feel like murdering you!")

			var/area/entrance = locate(/area/hogwarts/Entrance_Hall)
			for(var/mob/Player/p in entrance)
				if(p.away) p.loc = locate("@GreatHall")

			var/useOverride = entrance.safezoneoverride
			var/useTime    = entrance.timedProtection

			entrance.safezoneoverride = 1
			entrance.timedProtection = 0
			endTime = world.time + 600*minutes
			sleep(minutes * 600)

			for(var/mob/Enemies/ai in entrance)
				Respawn(ai)

			entrance.safezoneoverride = useOverride
			entrance.timedProtection = useTime

			Players << infomsg("Hogwarts magical defenses are restored. Entrance Hall is safe again.")
			end()

	OldSystem
		name   = "Old Dueling System"
		chance = 1
		start()
			set waitfor = 0
			..()
			var/minutes = rand(10,20)
			Players << infomsg("Old dueling system is active for [minutes] minutes outside!")

			for(var/area/A in outside_areas)
				A.oldsystem = 1
				spawn(minutes * 600) A.oldsystem = 0

			endTime = world.time + 600*minutes
			sleep(minutes * 600)

			Players << infomsg("Old dueling system event is over.")
			end()

	TreasureHunt
		name = "Treasure Hunt"
		var/list
			totalTreasures
			winners

		start()
			set waitfor = 0
			..()
			var/minutes = rand(6, 15)
			var/chests  = rand(4, 8)

			Players << infomsg("A wizard-pirate dropped [chests] chests off his ship while casually flying through the castle's restricted airspace, he might've dropped those chests because we might've fired our magic-space guns at him.<br>Find the treasure chests before other pesky looters get them! You have [minutes] minutes.<br>(Treasure is not visible, it's hidden somewhere behind the castle at Hogwarts grounds.)")

			var/list/treasures = list()
			if(!winners) winners = list()
			if(!totalTreasures) totalTreasures = list()

			var/obj/spawner/spawn_loc = pick(worldData.spawners)
			var/mapZ = spawn_loc.z

			for(var/i = 1 to chests)
				var/obj/items/treasure/t = new
				treasures += t
				totalTreasures += t

				while(!t.loc || t.loc.density)
					t.loc = locate(rand(1,82), rand(1,100), mapZ)

			endTime = world.time + 600*minutes
			sleep(minutes * 600)

			var/end = FALSE
			for(var/obj/t in treasures)
				treasures -= t
				if(!t.loc) continue
				totalTreasures -= t
				if(!totalTreasures.len)
					totalTreasures = null
					end = TRUE
				t.loc     = null

			if(end)
				end()

			treasures = null

		end()
			winners = null

			Players << infomsg("Treasure Hunt is over.")
			worldData.currentEvents -= src

			if(worldData.currentEvents.len == 0) worldData.currentEvents = null

	Snitches
		name = "Catch Snitches"
		start()
			set waitfor = 0
			..()
			var/minutes = rand(10,20)
			var/snitches = rand(15,30)
			Players << infomsg("[snitches] snitches were released outside behind Hogwarts, each snitch you catch will reward you!<br>The snitches will disappear in [minutes] minutes. To catch snitches you need to fly on a broom and walk on them.")

			var/list/s = list()
			for(var/i = 0; i < snitches; i++)
				var/obj/spawner/spawn_loc = pick(worldData.spawners)
				s += new/obj/quidditch/snitch { prize = 1 } (spawn_loc.loc)

			endTime = world.time + 600*minutes
			sleep(minutes * 600)
			var/message = 0
			for(var/obj/quidditch/snitch/sn in s)
				if(sn && sn.loc) message = 1
				s -= sn
				del sn
			s = null
			if(message) Players << infomsg("The snitches have vanished.")
			end()

	DropRate
		name   = "Drop Rate Bonus"
		chance = 10
		start()
			set waitfor = 0
			..()
			var/minutes = rand(20,40)
			var/bonus = rand(25,100)

			var/b = bonus / 100
			worldData.DropRateModifier += b
			var/tmpDropRate = worldData.DropRateModifier
			Players << infomsg("You feel a strange magic surrounding you, increasing your drop rate by [bonus]% for [minutes] minutes (This stacks on top of any other bonuses).")

			endTime = world.time + 600*minutes
			spawn(minutes * 600)
				end()
				if(worldData.DropRateModifier >= tmpDropRate)
					Players << infomsg("The drop rate bonus event is over.")
					worldData.DropRateModifier -= b

	Sale
		name   = "Crazy Sale"
		chance = 8
		start()
			set waitfor = 0
			..()
			var/minutes = rand(10,20)
			var/sale = rand(15,40)

			var/b = sale / 100
			worldData.shopPriceModifier -= b
			var/tmpShopModifier = worldData.shopPriceModifier
			Players << infomsg("There's a crazy sale going on! You should check out Marvelous Magical Mystery or wig shops, they have a [sale]% discount for the next [minutes] minutes!")

			endTime = world.time + 600*minutes
			spawn(minutes * 600)
				end()
				if(worldData.shopPriceModifier >= tmpShopModifier)
					Players << infomsg("The sale ended.")
					worldData.shopPriceModifier += b

	Exp
		name   = "Experience Bonus"
		chance = 10
		start()
			set waitfor = 0
			..()
			var/minutes = rand(20,40)
			var/bonus = rand(25,100)

			var/b = bonus / 100
			worldData.expModifier += b
			var/tmpExpModifier = worldData.expModifier
			Players << infomsg("You feel a strange magic surrounding you, increasing your experience gain rate from monsters by [bonus]% for [minutes] minutes (This stacks on top of any other bonuses).")

			endTime = world.time + 600*minutes
			spawn(minutes * 600)
				end()
				if(worldData.expModifier >= tmpExpModifier)
					Players << infomsg("The experience bonus event is over.")
					worldData.expModifier -= b

	NoCD
		name   = "No Cooldown"
		chance = 10
		start()
			set waitfor = 0
			..()
			var/minutes = rand(10,30)

			worldData.cdrModifier = 0
			Players << infomsg("You feel a strange magic surrounding you, all your cooldowns are gone for [minutes] minutes.")

			endTime = world.time + 600*minutes
			spawn(minutes * 600)
				end()
				Players << infomsg("The cooldown event is over.")
				worldData.cdrModifier = 1

	LegendaryEffect
		name   = "Legendary Effect"
		chance = 10
		start(var/passive, var/minutes)
			set waitfor = 0
			..()

			if(!minutes) minutes = rand(10,30)

			if(!passive) passive = pick(RING_WATERWALK, RING_APPARATE, RING_DISPLACEMENT, RING_LAVAWALK, RING_ALCHEMY, RING_CLOWN, RING_FAIRY, RING_NINJA, RING_NURSE, SHIELD_ALCHEMY, SHIELD_NINJA, SHIELD_NURSE, SHIELD_CLOWN, SHIELD_MPDAMAGE, SHIELD_GOLD, SWORD_ALCHEMY, SWORD_NINJA, SWORD_NURSE, SWORD_CLOWN, SWORD_EXPLODE, SWORD_FIRE, SWORD_HEALONKILL, SWORD_ANIMAGUS, SWORD_GHOST, SWORD_SNAKE)

			if(!worldData.passives) worldData.passives = list()
			worldData.passives += passive

			for(var/mob/Player/p in Players)
				if(!p.passives) p.passives = list()
				p.passives[passive] += 1

			Players << infomsg("You feel a strange magic surrounding you, granting you [passive] for [minutes] minutes.")

			endTime = world.time + 600*minutes
			spawn(minutes * 600)
				end()
				Players << infomsg("The legendary effect event is over.")

				worldData.passives -= passive
				if(!worldData.passives.len)
					worldData.passives = null

				for(var/mob/Player/p in Players)
					p.passives[passive] -= 1

					if(p.passives[passive] <= 0) p.passives -= passive

					if(!p.passives.len)
						p.passives = null

	Invasion
		name = "Monster Invasion"
		start()
			set waitfor = 0
			..()
			var/minutes = rand(10,20)
			var/monsters = rand(50,100)
			var/tier = rand(1,9)
			var/list/types = list("Slug", "Rat", "Pixie", "Dog", "Snake", "Wolf", "Troll", "Spider", "Stickman")

			Players << infomsg("[types[tier]]s are invading for [minutes] minutes, they're right outside behind Hogwarts, defend the castle!<br>(The monsters have a leader, stronger than the rest, he drops a valuable prize based on level)")

			var/list/m = list()
			for(var/i = 0; i <= monsters; i++)
				var/obj/spawner/spawn_loc = pick(worldData.spawners)
				var/mob/Enemies/Summoned/monster = new (spawn_loc.loc)

				monster.DMGmodifier = 0.8
				monster.HPmodifier  = 1.2
				monster.level       = tier * 100 + rand(0, 10)
				monster.name        = types[tier]
				monster.icon_state  = lowertext(types[tier])
				monster.icon        = 'Mobs.dmi'

				if(i == monsters)
					monster.MoveDelay = 2
					monster.AttackDelay = 1
					monster.level *= 2
					monster.name   = "[pick("Odd ", "Big ", "Giant ", "Mysteriously Big ", "Enormous ", "Magical ", "")][monster.name][pick(" King", " Queen", " Leader", "")]"
					monster.transform *= 4
					monster.DMGmodifier = 4
					monster.HPmodifier  = 10

					if(tier < 3)
						monster.drops = list(/obj/items/bagofgoodies,
						                     /obj/items/chest/basic_chest)
					else if(tier == 3)
						monster.drops = list(/obj/items/bagofgoodies,
						                     /obj/items/chest/basic_chest,
											 /obj/items/lamps/double_drop_rate_lamp,
											 /obj/items/lamps/double_exp_lamp,
											 /obj/items/lamps/double_gold_lamp,
											 /obj/items/wearable/title/Warrior)
					else if(tier == 4)
						monster.drops = list(/obj/items/artifact,
						                     /obj/items/chest/basic_chest,
											 /obj/items/lamps/double_drop_rate_lamp,
											 /obj/items/lamps/double_exp_lamp,
											 /obj/items/lamps/double_gold_lamp,
											 /obj/items/wearable/title/Warrior)
					else if(tier == 5)
						monster.drops = list(/obj/items/artifact,
						                     /obj/items/chest/basic_chest,
						                     /obj/items/chest/wizard_chest,
						                     /obj/items/chest/pentakill_chest,
											 /obj/items/lamps/double_drop_rate_lamp,
											 /obj/items/lamps/double_exp_lamp,
											 /obj/items/lamps/double_gold_lamp,
											 /obj/items/lamps/triple_drop_rate_lamp,
											 /obj/items/lamps/triple_exp_lamp,
											 /obj/items/lamps/triple_gold_lamp,
											 /obj/items/wearable/title/Warmonger)
					else if(tier == 6)
						monster.drops = list(/obj/items/artifact,
						                     /obj/items/chest/wizard_chest,
						                     /obj/items/chest/pentakill_chest,
											 /obj/items/lamps/triple_drop_rate_lamp,
											 /obj/items/lamps/triple_exp_lamp,
											 /obj/items/lamps/triple_gold_lamp,
											 /obj/items/wearable/title/Warmonger)

					else if(tier == 7)
						monster.drops = list(/obj/items/artifact,
											 /obj/items/chest/wizard_chest,
											 /obj/items/chest/pentakill_chest,
											 /obj/items/chest/sunset_chest,
											 /obj/items/chest/pet_chest,
											 /obj/items/lamps/triple_drop_rate_lamp,
											 /obj/items/lamps/triple_gold_lamp,
											 /obj/items/lamps/triple_exp_lamp,
											 /obj/items/lamps/quadaple_drop_rate_lamp,
											 /obj/items/lamps/quadaple_gold_lamp,
											 /obj/items/lamps/quadaple_exp_lamp,
											 /obj/items/wearable/title/Legionnaire)
					else if(tier == 8)
						monster.drops = list(/obj/items/artifact,
											 /obj/items/chest/sunset_chest,
											 /obj/items/chest/pet_chest,
											 /obj/items/lamps/quadaple_drop_rate_lamp,
											 /obj/items/lamps/quadaple_gold_lamp,
											 /obj/items/lamps/quadaple_exp_lamp,
											 /obj/items/wearable/title/Legionnaire)
					else if(tier == 9)
						monster.drops = list(/obj/items/artifact,
											 /obj/items/chest/sunset_chest,
											 /obj/items/chest/pet_chest,
											 /obj/items/crystal/soul,
											 /obj/items/lamps/quadaple_drop_rate_lamp,
											 /obj/items/lamps/quadaple_gold_lamp,
											 /obj/items/lamps/quadaple_exp_lamp,
											 /obj/items/wearable/title/Myrmidon)

				monster.calcStats()

				m += monster

			endTime = world.time + 600*minutes
			sleep(minutes * 600)
			end()
			var/message = 0
			for(var/mob/Enemies/Summoned/monster in m)
				if(monster.loc != null) message = 1
				monster.Dispose()
				monster.ChangeState(monster.INACTIVE)
				m -= monster
			m = null

			if(message) Players << infomsg("The monsters have been driven away.")

mob/Player
	var/playSounds = TRUE

	proc/beep(type = 0)
		if((type == 1 && EventNotifications) || (type == 2 && ClassNotifications) || !type)
			winset(src, "mainwindow", "flash=2")

			if(playSounds)
				var/sound/S
				switch(BeepType)
					if(1)
						S = sound('Alert.ogg')
					if(2)
						S = sound('Alert.mp3')
					if(3)
						S = sound('TWC_Alert_2.ogg')
				src << S

obj/items/treasure
	var/event = "Treasure Hunt"
	max_stack = 1

	New()
		set waitfor = 0
		..()

		sleep(150)
		while(loc)
			var/turf/t = locate(x + rand(-4, 4), y + rand(-4, 4), z)
			if(t)
				emit(loc    = t,
				 	 ptype  = /obj/particle/star,
				 	 amount = 3,
				 	 angle  = new /Random(0, 360),
				 	 speed  = 5,
				 	 life   = new /Random(4,8))

			sleep(rand(150, 450))

	Take()
		set src in oview(1)
		set category = null

		if(event == "Treasure Hunt")
			var/RandomEvent/TreasureHunt/e = locate() in worldData.events
			if(e && (usr.ckey in e.winners))
				usr << errormsg("You already found a chest!")
				return

		loc = null

		var/t = pickweight(list(/obj/items/chest/basic_chest          = 20,
		                        /obj/items/chest/wizard_chest         = 20,
		                        /obj/items/chest/pentakill_chest      = 20,
								/obj/items/chest/winter_chest         = 15,
								/obj/items/chest/pet_chest            = 15,
		                        /obj/items/chest/sunset_chest         = 10,
		                        /obj/items/chest/wigs/basic_wig_chest = 5,
		                        /obj/items/chest/wigs/chess_chest     = 3,
		                        /obj/items/chest/wigs/demon_chest     = 3,
		                        /obj/items/chest/wigs/sunset_wig_chest= 3,
		                        /obj/items/wearable/title/Pirate      = 1))

		var/obj/items/i = new t (usr)

		Players << infomsg("<b>[event]:</b> [usr] found a [i.name]!")

		if(event == "Treasure Hunt")
			var/RandomEvent/TreasureHunt/e = locate() in worldData.events
			if(e && e.totalTreasures && (src in e.totalTreasures))
				e.totalTreasures -= src

				e.winners += usr.ckey

				if(!e.totalTreasures.len)
					e.totalTreasures = null
					e.end()

