mob/proc/Death_Check(mob/killer = src)
	killer.updateHPMP()
	src.updateHPMP()
	if(src.HP<1)
		if(src.player)
			Check_Death_Drop()
			for(var/turf/duelsystemcenter/T in duelsystems)
				if(T.D)
					if(T.D.player1 == src)
						range(8,T) << "<i>[T.D.player1] has lost the duel. [T.D.player2] is the winner!</i>"
						del T.D
					else if(T.D.player2 == src)
						range(8,T) << "<i>[T.D.player2] has lost the duel. [T.D.player1] is the winner!</i>"
						del T.D
			for(var/obj/items/portduelsystem/T in duelsystems)
				if(T.D)
					if(T.D.player1 == src)
						range(8,T) << "<i>[T.D.player1] has lost the duel. [T.D.player2] is the winner!</i>"
						del T.D
					else if(T.D.player2 == src)
						range(8,T) << "<i>[T.D.player2] has lost the duel. [T.D.player1] is the winner!</i>"
						del T.D
			if(src.arcessoing == 1)
				hearers() << "[src] stops waiting for a partner."
				src.arcessoing = 0
			else if(ismob(arcessoing))
				hearers() << "[src] pulls out of the spell."
				stop_arcesso()
			if(src.Detention)
				sleep(1)
				flick('teleboom.dmi',src)
				return
				//src<<"<b><font color=red>Advice:</b></font> You can't kill yourself to get out of detention. Attempt to do it again and all of your spells will be erased from your memory."
			if(src.Immortal==1)
				src<<"[killer] tried to knock you out, but you are immortal."
				killer<<"<font color=blue><b>[src] is immortal and cannot die.</b></font>"
				return
			if(src.monster==1)
				del src
				return
			if(istype(src.loc.loc,/area/hogwarts/Duel_Arenas))
				src.HP=src.MHP+src.extraMHP
				src.MP=src.MMP+src.extraMMP
				src.updateHPMP()
				flick('mist.dmi',src)
				var/mob/Player/p = src
				switch(src.loc.loc.type)
					if(/area/hogwarts/Duel_Arenas/CustomArena)
						p.Transfer(locate(src.loc.loc.name))
					if(/area/hogwarts/Duel_Arenas/CustomArena2)
						p.Transfer(locate(src.loc.loc.name))
					if(/area/hogwarts/Duel_Arenas/CustomArena3)
						p.Transfer(locate(src.loc.loc.name))
					if(/area/hogwarts/Duel_Arenas/Main_Arena_Bottom)
						p.Transfer(locate(26,6,22))
					if(/area/hogwarts/Duel_Arenas/Matchmaking/Main_Arena_Top)
						var/obj/o = pick(duel_chairs)
						p.Transfer(o.loc)
					if(/area/hogwarts/Duel_Arenas/Slytherin)
						p.Transfer(locate(48,93,21))
					if(/area/hogwarts/Duel_Arenas/Gryffindor)
						p.Transfer(locate(9,47,21))
					if(/area/hogwarts/Duel_Arenas/Ravenclaw)
						p.Transfer(locate(53,68,21))
					if(/area/hogwarts/Duel_Arenas/Hufflepuff)
						p.Transfer(locate(78,60,21))
					if(/area/hogwarts/Duel_Arenas/Matchmaking/Duel_Class)
						p.Transfer(locate(22,23,23))
					if(/area/hogwarts/Duel_Arenas/Defence_Against_the_Dark_Arts)
						p.Transfer(locate(74,38,21))
					if(/area/hogwarts/Duel_Arenas/Main_Arena_Lobby)
						var/obj/Bed/B = pick(Beds)
						p.Transfer(B.loc)
						src.dir = SOUTH
				flick('dlo.dmi',src)
				src<<"<i>You were knocked out by <b>[killer]</b>!</i>"
				if(src.removeoMob) spawn()src:Permoveo()
				src.sight &= ~BLIND
				return
			if(src.loc.loc.type == /area/hogwarts/Hospital_Wing)
				src.HP=src.MHP+src.extraMHP
				src.updateHPMP()
				return
			if(src.loc.loc.type == /area/Underwater)
				src.followplayer=0
				src.HP=src.MHP+src.extraMHP
				src.MP=src.MMP+src.extraMMP
				src.updateHPMP()
				flick('mist.dmi',src)
				src.loc=locate(8,8,9)
				flick('dlo.dmi',src)
				src<<"<i>You were knocked out by <b>[killer]</b>!</i>"
				if(src.removeoMob) spawn()src:Permoveo()
				src.sight &= ~BLIND
				return

			if(src.loc.loc.type in typesof(/area/arenas/MapThree/WaitingArea))
				killer << "Do not attack in the waiting area.."
				src.HP = src.MHP+extraMHP
				return
			if(src.loc.loc.type in typesof(/area/arenas/MapThree/PlayArea))
				if(currentArena)
					var/list/players = range(8,currentArena.speaker)|currentArena.players
					if(killer != src)
						players << "<b>Arena</b>: [killer] killed [src]."
					else
						players << "<b>Arena</b>: [killer] killed themself."
					currentArena.players.Remove(src)
					src.HP=src.MHP+extraMHP
					src.MP=src.MMP+extraMMP
					src.updateHPMP()
					if(currentArena.players.len == 1)
						var/mob/winner
						for(var/mob/M in currentArena.players)
							winner = M
						players << "<b>Arena</b>: [winner] wins the round!"
						var/turf/T = pick(MapThreeWaitingAreaTurfs)
						winner.loc = T
						winner.density = 1
						for(var/mob/Z in view(8,currentArena.speaker))
							Z << "<b>You can leave at any time when a round hasn't started by <a href=\"byond://?src=\ref[Z];action=arena_leave\">clicking here.</a></b>"
						del(currentArena)
					else if(currentArena.players.len == 0)
						var/mob/winner
						winner = src
						players << "<b>Arena</b>: [winner] wins the round!"
						var/turf/T = pick(MapThreeWaitingAreaTurfs)
						winner.loc = T
						winner.density = 1
						for(var/mob/Z in view(8,currentArena.speaker))
							Z << "<b>You can leave at any time when a round hasn't started by <a href=\"byond://?src=\ref[Z];action=arena_leave\">clicking here.</a></b>"
						del(currentArena)
					var/turf/T = pick(MapThreeWaitingAreaTurfs)
					src.loc = T
					density = 1
					return
				else
					killer << "Do not attack before a round has started."
					src.HP = src.MHP+extraMHP
					return
			if(clanwars)
			//world clanwars
				if(killer.aurorrobe && src.DeathEater)
					src << "You were killed by [killer] of the Aurors."
					housepointsGSRH[5] += 1
					clanwars_event.add_auror(1)

					if(clanevent1_pointsgivenforkill)
						housepointsGSRH[5] += clanevent1_pointsgivenforkill
						clanwars_event.add_auror(clanevent1_pointsgivenforkill)
				else if(killer.derobe && src.Auror)
					src << "You were killed by a [killer]."
					housepointsGSRH[6] += 1
					clanwars_event.add_de(1)

					if(clanevent1_pointsgivenforkill)
						housepointsGSRH[6] += clanevent1_pointsgivenforkill
						clanwars_event.add_de(clanevent1_pointsgivenforkill)
			if(src.loc.loc.type in typesof(/area/arenas/MapTwo))
			/////CLAN WARS//////
				if(!(src.derobe && killer.derobe)&&!(src.aurorrobe && killer.aurorrobe))
					if(currentArena)
						if (currentArena.roundtype == CLAN_WARS)
							if(killer.aurorrobe)
								currentArena.Add_Point("Aurors",1)
								src << "You were killed by [killer] of the Aurors"
								killer << "You killed [src]"
							else if(killer.derobe)
								currentArena.Add_Point("Deatheaters",1)
								src << "You were killed by [killer]."
								killer << "You killed [src] of the Aurors"
				else if(src == killer)
					src << "You killed yourself!"
				else
					src << "You were killed by [killer], from your own team!"
					killer << "You killed [src] of your own team!"
				if(currentArena)
					if(currentArena.plyrSpawnTime > 0)
						src << "<i>You must wait [currentArena.plyrSpawnTime] seconds until you respawn.</i>"
				var/obj/Bed/B
				if(derobe)
					B = pick(Map2DEbeds)
				else if(aurorrobe)
					B = pick(Map2Aurorbeds)
				src.loc = B.loc
				src.dir = SOUTH
				if(currentArena)
					src.GMFrozen = 1
					spawn()currentArena.handleSpawnDelay(src)
				src.HP=src.MHP+extraMHP
				src.MP=src.MMP+extraMMP
				src.updateHPMP()
				return
			/////HOUSE WARS/////
			if(src.loc.loc.type in typesof(/area/arenas/MapOne))
				if(src.House != killer.House)
					if(currentArena)
						if(currentArena.roundtype == HOUSE_WARS && currentArena.started)
							currentArena.Add_Point(killer.House,1)
							src << "You were killed by [killer] of [killer.House]"
							killer << "You killed [src] of [src.House]"
				else if(src == killer)
					src << "You killed yourself!"
				else
					src << "You were killed by [killer], from your own team!"
					killer << "You killed [src] of your own team!"
				if(currentArena)
					if(currentArena.plyrSpawnTime > 0)
						src << "<i>You must wait [currentArena.plyrSpawnTime] seconds until you respawn.</i>"
				var/obj/Bed/B
				switch(House)
					if("Gryffindor")
						B = pick(Map1Gbeds)
					if("Hufflepuff")
						B = pick(Map1Hbeds)
					if("Slytherin")
						B = pick(Map1Sbeds)
					if("Ravenclaw")
						B = pick(Map1Rbeds)
				src.loc = B.loc
				src.dir = SOUTH
				if(currentArena)
					src.GMFrozen = 1
					spawn()currentArena.handleSpawnDelay(src)
				src.HP=src.MHP+extraMHP
				src.MP=src.MMP+extraMMP
				src.updateHPMP()
				return
			var/obj/Bed/B
			if(src.derobe)
				B = pick(DEBeds)
			else if(src.aurorrobe)
				B = pick(AurorBeds)
			else if(src.z==17||src.z==19)
				B= pick(Mansionbeds)
			else
				B = pick(Beds)
			if(!src.Detention)
				if(killer != src && !src:rankedArena)
					if(killer.client && src.client && killer.loc.loc.name != "outside")
						if(killer.name == "Deatheater")
							if(src.name == "Deatheater")
								file("Logs/kill_log.html") << "[time2text(world.realtime,"MMM DD - hh:mm:ss")]: [killer.prevname](DE robed) killed [src.prevname](DE robed): [src.loc.loc](<a href='?action=teleport;x=[src.x];y=[src.y];z=[src.z]'>Teleport</a>)<br>"
							else
								file("Logs/kill_log.html") << "[time2text(world.realtime,"MMM DD - hh:mm:ss")]: [killer.prevname](DE robed) killed [src]: [src.loc.loc](<a href='?action=teleport;x=[src.x];y=[src.y];z=[src.z]'>Teleport</a>)<br>"
						else
							if(src.name == "Deatheater")
								file("Logs/kill_log.html") << "[time2text(world.realtime,"MMM DD - hh:mm:ss")]: [killer] killed [src.prevname](DE robed): [src.loc.loc](<a href='?action=teleport;x=[src.x];y=[src.y];z=[src.z]'>Teleport</a>)<br>"
							else
								file("Logs/kill_log.html") << "[time2text(world.realtime,"MMM DD - hh:mm:ss")]: [killer] killed [src]: [src.loc.loc](<a href='?action=teleport;x=[src.x];y=[src.y];z=[src.z]'>Teleport</a>)<br>"
					if(killer.client && get_dist(src, killer) == 1 && get_dir(src, killer) == turn(src.dir,180))
						src << "<i>You were knocked out by <b>someone from behind</b> and sent to the Hospital Wing!</i>"
					else
						src << "<i>You were knocked out by <b>[killer]</b> and sent to the Hospital Wing!</i>"

				src:nofly()
				if(src.removeoMob) spawn()src:Permoveo()

				src.followplayer=0
				Zitt = 0
				src.status=""
				src.HP=src.MHP+extraMHP
				src.MP=src.MMP+extraMMP
				src.updateHPMP()
				src.gold = round(src.gold / 2)
				if(src.level < lvlcap)
					src.Exp = round(src.Exp / 2)
				src.sight &= ~BLIND
				flick('mist.dmi',src)
				if(!src:rankedArena)
					src:Transfer(B.loc)
					src.dir = SOUTH
				flick('dlo.dmi',src)

			if(killer.player)
				src.pdeaths+=1
				if(src:rankedArena)
					src:rankedArena.death(src)
				if(killer != src)
					killer.pkills+=1

					killer:checkQuestProgress("Kill Player")

					var/rndexp = round(src.level * 1.2) + rand(-200,200)
					if(rndexp < 0) rndexp = rand(20,30)

					if(killer.House == housecupwinner)
						rndexp *= 1.25
						rndexp = round(rndexp)

					if(killer.level < lvlcap)
						killer.Exp+=rndexp
						killer<<infomsg("You knocked [src] out and gained [rndexp] exp.")
						killer.LvlCheck()
					else
						if(!killer.findStatusEffect(/StatusEffect/KilledPlayer)) // prevents spam killing people for gold in short time
							rndexp = rndexp * rand(2,5)
							new /StatusEffect/KilledPlayer (killer, 30)
						else
							rndexp = round(rndexp * 0.4)
						killer.gold += rndexp
						killer<<infomsg("You knocked [src] out and gained [rndexp] gold.")

				else
					src<<"You knocked yourself out!"
			else
				src.edeaths+=1


		else
			if(killer.client)
				if(istype(src, /mob/NPC/Enemies))
					if(!istype(src, /mob/NPC/Enemies/Summoned))
						killer.AddKill(src.name)
					killer:checkQuestProgress("Kill [src.name]")
					if(killer.party!="")
						for(var/mob/expee in world)
							if(expee.party==killer.party&&killer.name!=expee.name && expee.z == killer.z)
								expee.AddKill(src.name)
								expee:checkQuestProgress("Kill [src.name]")
				if(killer.MonsterMessages)killer<<"<i><small>You knocked [src] out!</small></i>"

				killer.ekills+=1
				var/gold2give = (rand(14,17)/10)*gold
				var/exp2give  = round(0.55*Expg)

			/*	if(killer.level > src.level && !killer.findStatusEffect(/StatusEffect/Lamps/Farming))
					gold2give -= gold2give * ((killer.level-src.level)/150)
					exp2give  -= exp2give  * ((killer.level-src.level)/150)
*/
				if(killer.House == housecupwinner)
					gold2give *= 1.25
					exp2give  *= 1.25

				var/StatusEffect/Lamps/Gold/gold_rate = killer.findStatusEffect(/StatusEffect/Lamps/Gold)
				var/StatusEffect/Lamps/Exp/exp_rate   = killer.findStatusEffect(/StatusEffect/Lamps/Exp)

				if(gold_rate) gold2give *= gold_rate.rate
				if(exp_rate)  exp2give  *= exp_rate.rate

				gold2give = round(gold2give)
				exp2give = round(exp2give)


				if(killer.party!="")
					for(var/mob/expee in world)
						if(expee.party==killer.party&&killer.name!=expee.name && expee.z == killer.z)
							if(expee.level < lvlcap)
								if(round(exp2give/5)>0)
									expee.Exp+=round(exp2give/4)
									if(expee.PartyMonsterMessages==1)expee<<infomsg("You gained [round(exp2give/5)] exp shared in party.")
								if(round(gold2give/5)>0)
									var/goldgiven = round(gold2give/4)
									expee.gold+=goldgiven
									if(expee.PartyMonsterMessages==1)expee<<infomsg("You gained [goldgiven] gold shared in party.")
								expee.LvlCheck()
							else
								var/goldgiven = round(gold2give/4)
								if(goldgiven>0)
									expee.gold+=goldgiven
									if(expee.PartyMonsterMessages==1)expee<<infomsg("You gained [goldgiven] gold shared in party.")

				if(killer.level >= lvlcap) exp2give = 0

				if(killer.MonsterMessages)

					if(exp2give > 0)
						killer<<"<i><small>You gained [exp2give] exp[gold2give > 0 ? " and [gold2give] gold" : ""].</small></i>"
					else if(gold2give > 0)
						killer<<"<i><small>You gained [gold2give] gold.</small></i>"

				if(gold2give > 0)
					killer.gold+=gold2give
					killer.gold = round(killer.gold)
				if(killer.level < lvlcap && exp2give > 0)
					killer.Exp+=exp2give
					killer.addReferralXP(Exp)
					killer.Exp = round(killer.Exp)
					killer.LvlCheck()
				killer.Texp+=src.Expg


			if(src.type == /mob/Slug)
				del src
				return ..()
			else //Statpoints for monster killz.
				if(killer.Counter_Sp<500)
					var/StatusEffect/Lamps/Statpoint/sp_rate = killer.findStatusEffect(/StatusEffect/Lamps/Statpoint)
					if(sp_rate)
						if(rand(1,sp_rate.rate)==1 && killer.client)
							killer.verbs.Add(/mob/Player/verb/Use_Statpoints)
							killer<<"You've earned a statpoint"
							killer.StatPoints++
							killer.Counter_Sp++
							killer.LvlCheck()
					else
						if(rand(1,Monsterpoints)==1 && killer.client)
							killer.verbs.Add(/mob/Player/verb/Use_Statpoints)
							killer<<"You've earned a statpoint"
							killer.StatPoints++
							killer.Counter_Sp++
							killer.LvlCheck()
			if(istype(src, /mob/NPC/Enemies))
				src:Death(killer)
			src.loc=locate(0,0,0)
			Respawn(src)

mob/var/Counter_Sp=0

var/Monsterpoints = 65
mob/GM/verb/Statpoint_Monster_Controll(var/t as num)
	set name="Monster Control Rate"
	set category="Server"
	Monsterpoints = t
	usr<< "Statpoint drop from monster edited to 1/[t]"