
var/list/quest_list

proc
	init_quests()
		quest_list = list()
		for(var/t in typesof(/quest/) - /quest)
			var/quest/c = new t
			if(c.sbu==0)
				var/quest/q = new t(1)
				quest_list[q.name] = q


obj/Glacius_book
	name="frozen arts"
	icon='HUD.dmi'
	icon_state="frozen"
	Click()
		if(src in usr)
			usr<<"<b><font color=red><font size=3>You learned Glacius"
			usr.learnspell(/mob/Spells/verb/Glacius)
			src.loc=null
			usr:Resort_Stacking_Inv()
			del(src)
		else
			..()

obj/Stone_heart
	icon='Stone_heart.dmi'
	verb
		Touch()
			set src in oview(2)
			var/mob/Player/m = usr
			if("Lost: A lucky heart has been lost" in m.questPointers)
				var/questPointer/pointer = m.questPointers["Lost: A lucky heart has been lost"]
				if(pointer.stage == 1)
					m:checkQuestProgress("lost heart")
					usr<<"<i>Faint Sound in distance</i> : Thank you"
				else
					usr<<"It feels cold to the touch."
			else
				usr<<"It feels cold to the touch."

quest
	var/name
	var/list/stages
	var/desc
	var/sbu=0
	var/list/reqs
	var/questReward/reward
	var/start_quest=""

	Heart_of_stone
		name = "Lost: A lucky heart has been lost"
		desc = "To whoever is reading this. I've lost my lucky heart somewhere on hogwarts grounds."
		reward = /questReward/coldheart

		Reward
			sbu=1
			desc = "Lost lucky heart"
			reqs = list("lost heart" = 1)

	Extermination
		name   = "Pest Extermination \[Daily]"
		desc   = "The hunter wants you to help him exterminate monsters."
		reward = /questReward/Artifact

		Kill
			sbu=1
			desc = "Kill 50 of each monster."
			reqs = list("Kill Rat"             = 50,
			            "Kill Demon Rat"       = 50,
			            "Kill Pixie"           = 50,
			            "Kill Dog"             = 50,
			            "Kill Snake"           = 50,
			            "Kill Wolf"            = 50,
			            "Kill Troll"           = 50,
			            "Kill Fire Bat"        = 50,
			            "Kill Fire Golem"      = 50,
			            "Kill Archangel"       = 50,
			            "Kill Water Elemental" = 50,
			            "Kill Fire Elemental"  = 50,
			            "Kill Wyvern"          = 50)
		Reward
			sbu=1
			desc = "Go back to the hunter to get your reward!"
			reqs = list("Hunter" = 1)

	Basilisk
		name   = "To kill a Boss \[Daily]"
		desc   = "The basilisk is found within the Chamber of Secrets, kill the Basilisk and any demon rats that get in your way!"
		reward = /questReward/Artifact

		Kill
			sbu=1
			desc = "Kill 1 basilisk and 50 demon rats."
			reqs = list("Kill Basilisk"        = 1,
			            "Kill Demon Rat"       = 50)
		Reward
			sbu=1
			desc = "Go back to Saratri to get your reward!"
			reqs = list("Saratri" = 1)


	Eyes
		name   = "The Eyes in the Sand \[Daily]"
		desc   = "The desert is a mysterious area filled with strange creatures called floating eyes, I wonder if they bleed..."
		reward = /questReward/Artifact

		Kill
			sbu=1
			desc = "Kill 60 floating eyes."
			reqs = list("Kill Floating Eye" = 60)
		Reward
			sbu=1
			desc = "Go back to the Mysterious Wizard to get your reward!"
			reqs = list("Mysterious Wizard" = 1)

	Wisps
		name   = "Will of the Wisp \[Daily]"
		desc   = "The vengeful wisp wants you to execute revenge, you must kill wisps!"
		reward = /questReward/Artifact

		Kill
			sbu=1
			desc = "Kill 80 wisps."
			reqs = list("Kill Wisp" = 80)

		Reward
			sbu=1
			desc = "Go back to Vengeful Wisp to get your reward!"
			reqs = list("Vengeful Wisp" = 1)

	Rats
		name   = "Pest Extermination: Rat"
		desc   = "The hunter wants you to help him exterminate rats from the forest."
		reward = /questReward/Mon1

		Kill
			sbu=1
			desc = "Kill 50 rats."
			reqs = list("Kill Rat" = 50)
		Reward
			sbu=1
			desc = "Go back to the hunter to get your reward!"
			reqs = list("Hunter" = 1)
	DemonRats
		name   = "Pest Extermination: Demon Rat"
		desc   = "The hunter wants you to help him exterminate demon rats from the Chamber of Secrets."
		reward = /questReward/Mon2

		Kill
			sbu=1
			desc = "Kill 50 demon rats."
			reqs = list("Kill Demon Rat" = 50)
		Reward
			sbu=1
			desc = "Go back to the hunter to get your reward!"
			reqs = list("Hunter" = 1)
	Pixie
		name   = "Pest Extermination: Pixie"
		desc   = "The hunter wants you to help him exterminate pixies from the pixie pit."
		reward = /questReward/Mon3

		Kill
			sbu=1
			desc = "Kill 50 pixies."
			reqs = list("Kill Pixie" = 50)
		Reward
			sbu=1
			desc = "Go back to the hunter to get your reward!"
			reqs = list("Hunter" = 1)
	Dog
		name   = "Pest Extermination: Dog"
		desc   = "The hunter wants you to help him exterminate dogs from the forest."
		reward = /questReward/Mon4

		Kill
			sbu=1
			desc = "Kill 50 dogs."
			reqs = list("Kill Dog" = 50)
		Reward
			sbu=1
			desc = "Go back to the hunter to get your reward!"
			reqs = list("Hunter" = 1)
	Snake
		name   = "Pest Extermination: Snake"
		desc   = "The hunter wants you to help him exterminate snakes from the graveyard."
		reward = /questReward/Mon5

		Kill
			sbu=1
			desc = "Kill 50 snakes."
			reqs = list("Kill Snake" = 50)
		Reward
			sbu=1
			desc = "Go back to the hunter to get your reward!"
			reqs = list("Hunter" = 1)
	Wolf
		name   = "Pest Extermination: Wolf"
		desc   = "The hunter wants you to help him exterminate wolves from the forest."
		reward = /questReward/Mon6

		Kill
			sbu=1
			desc = "Kill 50 wolves."
			reqs = list("Kill Wolf" = 50)
		Reward
			sbu=1
			desc = "Go back to the hunter to get your reward!"
			reqs = list("Hunter" = 1)
	Troll
		name   = "Pest Extermination: Troll"
		desc   = "The hunter wants you to help him exterminate trolls from the forest."
		reward = /questReward/Mon7

		Kill
			sbu=1
			desc = "Kill 50 trolls."
			reqs = list("Kill Troll" = 50)
		Reward
			sbu=1
			desc = "Go back to the hunter to get your reward!"
			reqs = list("Hunter" = 1)
	FireBats
		name   = "Pest Extermination: Fire Bat"
		desc   = "The hunter wants you to help him exterminate fire bats from Silverblood Grounds."
		reward = /questReward/Mon8

		Kill
			sbu=1
			desc = "Kill 50 fire bats."
			reqs = list("Kill Fire Bat" = 50)
		Reward
			sbu=1
			desc = "Go back to the hunter to get your reward!"
			reqs = list("Hunter" = 1)
	FireGolem
		name   = "Pest Extermination: Fire Golem"
		desc   = "The hunter wants you to help him exterminate fire golems from the Silverblood Grounds."
		reward = /questReward/Mon9

		Kill
			sbu=1
			desc = "Kill 50 fire golems."
			reqs = list("Kill Fire Golem" = 50)
		Reward
			sbu=1
			desc = "Go back to the hunter to get your reward!"
			reqs = list("Hunter" = 1)
	Archangel
		name   = "Pest Extermination: Archangel"
		desc   = "The hunter wants you to help him exterminate Archangel from the Silverblood Castle."
		reward = /questReward/Mon10

		Kill
			sbu=1
			desc = "Kill 50 archangels."
			reqs = list("Kill Archangel" = 50)
		Reward
			sbu=1
			desc = "Go back to the hunter to get your reward!"
			reqs = list("Hunter" = 1)
	WaterElemental
		name   = "Pest Extermination: Water Elemental"
		desc   = "The hunter wants you to help him exterminate fire water elementals from Silverblood Castle."
		reward = /questReward/Mon11

		Kill
			sbu=1
			desc = "Kill 50 water elementals."
			reqs = list("Kill Water Elemental" = 50)
		Reward
			sbu=1
			desc = "Go back to the hunter to get your reward!"
			reqs = list("Hunter" = 1)
	FireElemental
		name   = "Pest Extermination: Fire Elemental"
		desc   = "The hunter wants you to help him exterminate fire golems from the Silverblood Castle."
		reward = /questReward/Mon12

		Kill
			sbu=1
			desc = "Kill 50 fire elementals."
			reqs = list("Kill Fire Elemental" = 50)
		Reward
			sbu=1
			desc = "Go back to the hunter to get your reward!"
			reqs = list("Hunter" = 1)
	Wyvern
		name   = "Pest Extermination: Wyvern"
		desc   = "The hunter wants you to help him exterminate wyverns from the Silverblood Castle."
		reward = /questReward/Mon13

		Kill
			sbu=1
			desc = "Kill 50 Wyverns."
			reqs = list("Kill Wyvern" = 50)
		Reward
			sbu=1
			desc = "Go back to the hunter to get your reward!"
			reqs = list("Hunter" = 1)

	Tom
		name   = "Rats in the Cellar"
		reward = /questReward/Gold

		Clear
			sbu=1
			desc = "Tom wants you to clear his cellar of rats, kill 35 rats and pull the level at the end of the cellar."
			reqs = list("Lever" = 1, "Kill Rat" = 35)
		Reward
			sbu=1
			desc = "Go back to Tom to get your reward!"
			reqs = list("Tom" = 1)


	Lord
		name = "Stolen by the Lord"
		reward = /questReward/Gold

		FindLord
			sbu=1
			desc = "Girl wants you to find and rescue her baby from Lord, you heard a rumour he's at a place called Silverblood, maybe you can get there from the forest."
			reqs = list("Lord" = 1)

		Reward
			sbu=1
			desc = "Return the baby back to Girl and get your reward!"
			reqs = list("Girl" = 1)

	Alyssa
		name = "Make a Potion"
		reward = /questReward/RoyaleShoes

		FindHerbs
			sbu=1
			desc = "Alyssa wants you to help her procure an immortality potions, go find Onion Root, Indigo Seeds, Silver Spider Legs and Salamander Drop."
			reqs = list("Onion Root" = 1, "Indigo Seeds" = 1, "Silver Spider Legs" = 1, "Salamander Drop" = 1)

		Reward
			sbu=1
			desc = "You have all the ingredients go back to Alyssa."
			reqs = list("Alyssa" = 1)


	MakeAFortune
		name = "Make a Fortune"
		reward = /questReward/RoyaleScarf

		Kill
			sbu=1
			desc = "Cassandra wants you to help her procure a peice of the rarest monsters in the land, of course that requires you to kill some nasty beasts."
			reqs = list("Kill Wyvern"           = 50,
			            "Kill Floating Eye"     = 50,
			            "Kill Wisp"             = 50,
			            "Kill Basilisk"         = 1,
			            "Kill Willy the Whisp"  = 1,
			            "Kill The Evil Snowman" = 1,
			            "Kill Tamed Dog"        = 1,
			            "Kill Player"           = 30)
		Reward
			sbu=1
			desc = "You have all the monster essences go back to Cassandra."
			reqs = list("Cassandra" = 1)


	Fred
		name = "On House Arrest"
		reward = /questReward/Gold

		GetWand
			sbu=1
			desc = "Fred wants you to go withdraw a special wand from his vault at Gringotts, one of the bank goblins will help you."
			reqs = list("Fred's Wand" = 1)

		Reward
			sbu=1
			desc = "Use the wand to free Fred."
			reqs = list("Fred" = 1)

	Bob
		name = "Soul"
		reward = /questReward/SoulSt

		Kill
			sbu=1
			desc = "Bob wants you to clear out Rotem's Mansion."
			reqs = list("Kill Demon Pixie" = 50,
						"Kill Demon Bat"   = 50,
						"Kill Zombie"  	   = 50)
		Reward
			sbu=1
			desc = "Talk to Bob."
			reqs = list("Bob" = 1)


	//Pixie
	PixiesDaily
		name = "Mischief making problem"
		reward = /questReward/DailyPixies

		Kill
			sbu=1
			desc = "Exterminate Pixies from the Pixie Pit."
			reqs = list("Kill Pixie" = 30)

	//Pixie2
	PixiesDaily2
		name = "Mischievous creatures"
		reward = /questReward/DailyPixie2

		Kill
			sbu=1
			desc = "Exterminate Pixies from the Pixie Pit."
			reqs = list("Kill Pixie" = 60)

	//Angels Low
	AngelsDaily
		name = "Rogue angels eradication"
		reward = /questReward/DailyLow

		Kill
			sbu=1
			desc = "Exterminate Archangels from Silverblood Castle."
			reqs = list("Kill Archangel" = 20)

	//Angels High
	AngelsDaily2
		name = "Villainous angels extermination"
		reward = /questReward/DailyHigh

		Kill
			sbu=1
			desc = "Exterminate Archangels from Silverblood Castle."
			reqs = list("Kill Archangel" = 50)

	//water Low
	WaterDaily
		name = "Dripping guardians extermination"
		reward = /questReward/DailyLow

		Kill
			sbu=1
			desc = "Exterminate Water Elementals from Silverblood Castle."
			reqs = list("Kill Water Elemental" = 20)

	//Water High
	WaterDaily2
		name = "Dripping guardians annihilation"
		reward = /questReward/DailyHigh

		Kill
			sbu=1
			desc = "Exterminate Water Elementals from Silverblood Castle."
			reqs = list("Kill Water Elemental" = 50)


	//Fire Low
	FireDaily
		name = "Elemental fire extinguishing"
		reward = /questReward/DailyLow

		Kill
			sbu=1
			desc = "Exterminate Fire Elementals from Silverblood Castle."
			reqs = list("Kill Fire Elemental" = 20)

	//Fire High
	FireDaily2
		name = "Fire elemental extermination"
		reward = /questReward/DailyHigh

		Kill
			sbu=1
			desc = "Exterminate Fire Elementals from Silverblood Castle."
			reqs = list("Kill Fire Elemental" = 50)

	DemonPixieDaily
		name = "Demonic Incarnation"
		reward = /questReward/DemPixies

		Kill
			sbu=1
			desc = "Eliminate the reincarnated Demon Pixies from Rotem's Mansion."
			reqs = list("Kill Demon Pixie" = 30)

	ZombieDaily
		name = "The Walking Dead"
		reward = /questReward/DemPixies

		Kill
			sbu=1
			desc = "Eliminate the Zombies that reside in Rotem's Mansion."
			reqs = list("Kill Zombie" = 25)


	WerewolfDaily
		name = "Wild Wolves"
		reward = /questReward/DemPixies

		Kill
			sbu=1
			desc = "Exterminate the Werewolves from inside Rotem's Mansion."
			reqs = list("Kill Werewolf" = 25)

	DesDaily
		name = "Rogue Deatheater Extermination"
		reward = /questReward/DesDaily

		Kill
			sbu=1
			desc = "Take out the Deatheaters who live inside Rotem's Mansion."
			reqs = list("Kill Deatheather" = 25)
	DeProblem
		name = "Rogue Deatheater Extermination II"
		reward = /questReward/DesDaily

		Kill
			sbu=1
			desc = "Once again, take out the Deatheaters who live inside Rotem's Mansion."
			reqs = list("Kill Deatheather" = 125)
	DemonBatsDaily
		name = "Flying Problem"
		reward = /questReward/DemPixies

		Kill
			sbu=1
			desc = "Exterminate the Demon Bats from inside Rotem's Mansion."
			reqs = list("Kill Demon Bat" = 25)

	GetAWand
		name = "Acquire wand from Ollivander"
		reward = /questReward/GetAWand

		Reward
			sbu=1
			desc = "Navigate to Ollivanders store and purchase one of his wands."
			reqs = list("Acquire wand" = 1)

	QuestBoard
		name = "Check out the Quest Board"
		reward = /questReward/dailies

		Reward
			sbu=1
			desc = "Enter the Hogwarts and check out what Quest Board has for you."
			reqs = list("QuestBoard" = 1)

	HogwartsVisit
		name = "Hogwarts arrival"
		reward = /questReward/HogwartsVisit

		Reward
			sbu=1
			desc = "Enter the Great Hall."
			reqs = list("Enter Great Hall" = 1)


	New(var/isQuest = 0)
		..(isQuest)

		if(isQuest)
			stages = list()
			for(var/t in typesof(type) - type)
				var/quest/z = new t
				stages += z

			if(reward) reward = new reward

questReward
	var/gold
	var/exp
	var/items

	none

	coldheart
		items=/obj/Glacius_book
		exp=1000
	HogwartsVisit
		exp = 250
		gold = 100

	GetAWand
		exp = 100
		gold = 100

	Gold
		exp  = 1000
		gold = 10000
	Mon1
		gold = 1000
		exp  = 10000
	Mon2
		gold = 2000
		exp  = 20000
		items = /obj/items/lamps/farmer_lamp
	Mon3
		gold = 3000
		exp  = 30000
	Mon4
		gold  = 4000
		exp   = 40000
		items = /obj/items/wearable/title/Hunter
	Mon5
		gold = 5000
		exp  = 50000
	Mon6
		gold = 6000
		exp  = 60000
		items = /obj/items/lamps/double_exp_lamp
	Mon7
		gold = 7000
		exp  = 70000
	Mon8
		gold = 8000
		exp  = 80000
	Mon9
		gold  = 9000
		exp   = 90000
		items = /obj/items/wearable/title/Pest
	Mon10
		gold = 10000
		exp  = 100000
		items = /obj/items/lamps/triple_exp_lamp
	Mon11
		gold = 11000
		exp  = 110000
	Mon12
		gold = 12000
		exp  = 120000
		items = /obj/items/lamps/quadaple_exp_lamp
	Mon13
		gold  = 13000
		exp   = 130000
		items = list(/obj/items/wearable/title/Exterminator,
				/obj/items/lamps/penta_exp_lamp)
	Artifact
		gold  = 14000
		exp   = 140000
		items = /obj/items/artifact
	RoyaleShoes
		gold  = 5000
		exp   = 10000
		items = /obj/items/wearable/shoes/royale_shoes
	RoyaleScarf
		gold  = 24000
		items = /obj/items/wearable/scarves/royale_scarf
	PVP1
		gold  = 15000
		exp   = 15000
		items = list(/obj/items/bagofgoodies,
			         /obj/items/wearable/wands/salamander_wand)
	SoulSt
		gold = 300000
		exp  = 300000
		items = /obj/items/Soul_Stone

	DailyPixies
		gold = 30000
		exp  = 50000
	DailyPixie2
		gold = 50000
		exp  = 100000
	DailyLow
		gold = 80000
		exp  = 120000
	DailyHigh
		gold = 150000
		exp  = 200000
	dailies
		gold = 100
		exp  = 1000
	DemPixies
		gold = 120000
		exp  = 250000
	DesDaily
		gold = 150000
		exp  = 250000
	HardcoreDE
		gold = 1000000
		exp  = 450000
		items = /obj/items/lamps/sextuple_exp_lamp

	proc/get(mob/Player/p)
		if(gold)
			p.gold += gold
			p << infomsg("You receive [comma(gold)] gold.")
		if(exp && p.level < lvlcap)
			p << infomsg("You receive [comma(exp)] experience.")
			var/xp2give = exp
			while(p.Exp + xp2give > p.Mexp && p.level <= lvlcap)
				xp2give -= p.Mexp - p.Exp
				p.Exp = p.Mexp
				p.LvlCheck()

			p.Exp += xp2give
			p.LvlCheck()
		if(items)
			if(islist(items))
				for(var/t in items)
					var/obj/o = new t (p)
					p << infomsg("You receive [o.name].")
			else
				var/obj/o = new items (p)
				p << infomsg("You receive [o.name].")
			p.Resort_Stacking_Inv()

questPointer
	var/stage
	var/list/reqs
	var/time
	var/track = TRUE

	proc/setReqs(var/list/L)
		reqs = L.Copy()
/*
mob/verb/clear_quest()
	var/mob/Player/p = usr
	for(var/questname in p.questPointers)
		usr<<"pointer named [questname]"
		p.questPointers-=questname

	var/questPointer/pointer = p.questPointers["Soul"]
	p.questPointers-=pointer
	*/

mob/Player
	var/list/questPointers = list()
	var/tmp/showQuestType = 0 // 0 - active, 1 - complete, 2 - all

	verb
		Abandon_Quest(var/z in src.questPointers)
			set hidden = 1
			usr<<z

	verb
		showQuestType()
			set hidden = 1
			set name = ".showQuestType"

			switch(++showQuestType)
				if(1)
					winset(src, "Quests.buttonQuestDisplay", "text=\"Completed Quests\"")
				if(2)
					winset(src, "Quests.buttonQuestDisplay", "text=\"All Quests\"")
				if(3)
					showQuestType = 0
					winset(src, "Quests.buttonQuestDisplay", "text=\"Active Quests\"")
			buildQuestBook()

	proc
		buildQuestBook()
			src << output(null, "Quests.outputQuests")
			var/i = 0
			for(var/questName in questPointers)
				var/questPointer/pointer = questPointers[questName]

				if((showQuestType == 0 && pointer.stage) || (showQuestType == 1 && !pointer.stage) || showQuestType == 2)
					i++
					src << output("<a href=\"?src=\ref[src];action=selectQuest;questName=[questName]\">[questName]</a>", "Quests.gridQuests:1,[i]")
					if(pointer.stage) src << output("<a href=\"?src=\ref[src];action=trackQuest;questName=[questName]\">Toggle</a>", "Quests.gridQuests:2,[i]")
					else src << output(null, "Quests.gridQuests:2,[i]")
					if(i == 1)
						displayQuest(questName)
			winset(src, "Quests.gridQuests", "cells=2x[i]")

			winshow(src, "Quests", 1)

		displayQuest(var/questName)

			src << output(null, "Quests.outputQuests")

			var/questPointer/pointer = questPointers[questName]
			var/quest/q              = quest_list[questName]

			src << output("<b><u>[q.name]</u></b><br>", "Quests.outputQuests")
			src << output("[q.desc]<br>", "Quests.outputQuests")

			for(var/i = 1 to q.stages.len)
				if(pointer.stage && pointer.stage < i) break
				var/quest/stage = q.stages[i]
				src << output({"[stage.desc]<br>"}, "Quests.outputQuests")
			if(!pointer.time)
				src << output({"<a href=\"?src=\ref[src];action=Abandon;questName=[questName]\">Abandon</a>"}, "Quests.outputQuests")
			if(pointer.time)
				src << output("Completed on: <b>[time2text(pointer.time, "DD Month")]</b><br>", "Quests.outputQuests")
		startQuest(questName)
			if(questName in quest_list)
				var/quest/q = quest_list[questName]
				var/quest/stage = q.stages[1]
				var/questPointer/pointer = new
				pointer.setReqs(stage.reqs)
				pointer.stage = 1

				questPointers[questName] = pointer

				Interface.Update()
				src << infomsg(q.desc)
				src << infomsg(stage.desc)

/*		startQuest(questName)
			if(questName in quest_list)
				var/questPointer/pointer = new
				pointer.setReqs(quest_list[questName].reqs)
				pointer.stage = 1
				questPointers[questName] = pointer
				bubblesort(questPointers)

				Interface.Update()
*/
		trackQuest(var/questName)
			var/questPointer/pointer = questPointers[questName]

			if(pointer.track)
				src << infomsg("[questName] will no longer be tracked on screen.")
				pointer.track = FALSE
			else
				src << infomsg("[questName] will be tracked on screen.")
				pointer.track = TRUE

			Interface.Update()


		checkQuestProgress(args)
			var/found = FALSE
			for(var/questName in questPointers)
				if(!(questName in quest_list)) continue
				var/questPointer/pointer = questPointers[questName]
				if(!pointer.stage) continue
				var/quest/q = quest_list[questName]

				if((args in pointer.reqs) && pointer.reqs[args] > 0)
					pointer.reqs[args]--
					found = TRUE

					if(pointer.reqs[args] <= 0)
						pointer.reqs -= args

				if(!pointer.reqs.len)
					pointer.stage++
					if(pointer.stage <= q.stages.len)
						var/quest/stage = q.stages[pointer.stage]
						src << infomsg(stage.desc)
						pointer.setReqs(stage.reqs)
					else // quest completed
						if(q.reward) q.reward.get(src)
						if(q.start_quest!="")
							startQuest(q.start_quest)
						pointer.reqs  = null
						pointer.stage = null
						pointer.time = world.realtime

				if(found) break

			if(found) Interface.Update()

			return found



mob/Player/Topic(href, href_list[])
	..()
	switch(href_list["action"])
		if("selectQuest")
			var/questName = href_list["questName"]
			displayQuest(questName)
		if("trackQuest")
			var/questName = href_list["questName"]
			trackQuest(questName)
		if("Abandon")
			var/questName = href_list["questName"]
			var/mob/Player/p = usr
			switch(input("Confirmation","Would you like to Abandon [questName] quest?") in list("Yes","No"))
				if("Yes")
					p.questPointers-=questName
					Interface.Update()
					buildQuestBook()

mob/Player
	var/tmp/interface/Interface

client/New()
	..()

interface
	var/obj/hud/screentext/quest/quest
	var/mob/Player/parent

	New(mob/Player/p)
		..()
		parent = p

		Update()

	proc/Update()
		if(parent.HideQuestTracker && quest)
			parent.client.screen -= quest
			quest = null
		else if(!parent.HideQuestTracker && !quest)
			quest = new
			parent.client.screen += quest

		if(quest)
			quest.update(parent)


mob/Player
	var/mapTextColor = "#ffffff"
	verb
		setInterfaceColor(c as color)
			set hidden=1
			set name = ".setInterfaceColor"
			if(!c) return

			mapTextColor = "[c]"
			Interface.Update()