var/list/daily_quests = list("Mischief making problem","Mischievous creatures","Rogue angels eradication","Villainous angels extermination","Dripping guardians extermination","Villainous angels extermination","Elemental fire extinguishing","Fire elemental extermination")
var/list/godrics_daily = list("Demon Incarnation","Flying Problem", "The Walking Dead", "Wild Wolves","Rogue Deatheater Extermination","Rogue Deatheater Extermination II")

mob/proc/check_daily()
	var/mob/Player/questmob = src
	if(questmob.level>20)
		if("Check out the Quest Board" in questmob.questPointers)
			if(time2text(questmob.questPointers["Check out the Quest Board"].time, "DD Month")!=time2text(world.timeofday,"DD Month"))
				questmob.questPointers-="Check out the Quest Board"
				questmob:check_daily()
		else
			questmob.startQuest("Check out the Quest Board")

var/world_day=""

obj/QuestBoard
	icon='Quest_board.dmi'

	Hogwarts
		name="QuestBoard"
		Click()
			..()
			Check_Board()
		verb/Check_Board()
			set src in view(1)
			var/mob/Player/p = usr
			p:checkQuestProgress("QuestBoard")
			p:check_daily()
			var/list/quests = list()
			for(var/Daily in daily_quests)
				if(!(Daily in p.questPointers))
					quests+=Daily
				else
					if(time2text(p.questPointers[Daily].time, "DD Month")!=time2text(world.timeofday,"DD Month"))
						p.questPointers-=Daily
						quests+=Daily
			if(!("Lost: A lucky heart has been lost" in p.questPointers))
				quests+="Lost: A lucky heart has been lost"
			if(length(quests)>0)
				var/quest_io = input("Choose Quests to embark upon.","Daily Quests") in quests+list("Exit")
				if(quest_io=="Exit")return 0
				if(!(quest_io in p.questPointers))
					p:startQuest("[quest_io]")
				else
					p<<"Quest already taken."
			else
				p<<"There are no more quests available today."
	Godrics
		Click()
			..()
			Check_Board()
		verb/Check_Board()
			set src in view(1)
			var/mob/Player/p = usr
			p:check_daily()
			p:checkQuestProgress("QuestBoard")
			var/list/quests = list()
			for(var/Daily in godrics_daily)
				if(!(Daily in p.questPointers))
					quests+=Daily
				else
					if(time2text(p.questPointers[Daily].time, "DD Month")!=time2text(world.timeofday,"DD Month"))
						p.questPointers-=Daily
						quests+=Daily
			if(length(quests)>0)
				var/quest_io = input("Choose Quests to embark upon.") in quests+list("Exit")
				if(quest_io=="Exit")return 0
				if(!(quest_io in p.questPointers))
					p.startQuest("[quest_io]")
				else
					usr<<"Quest already taken."
			else
				usr<<"There are no more quests available today."