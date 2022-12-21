
mob/TalkNPC

	Vengeful_Wisp
		icon = 'Mobs.dmi'
		icon_state="wisp"

		New()
			..()
			alpha = rand(190,255)

			var/color1 = rgb(rand(20, 255), rand(20, 255), rand(20, 255))
			var/color2 = rgb(rand(20, 255), rand(20, 255), rand(20, 255))
			var/color3 = rgb(rand(20, 255), rand(20, 255), rand(20, 255))

			animate(src, color = color1, time = 10, loop = -1)
			animate(color = color2, time = 10)
			animate(color = color3, time = 10)

		Talk()
			set src in oview(3)
			var/mob/Player/p = usr
			var/questPointer/pointer = p.questPointers["Will of the Wisp \[Daily]"]
			if(pointer)
				if(pointer.stage)
					if(p.checkQuestProgress("Vengeful Wisp"))
						p << npcsay("<font color = red><b>Vengeful Wisp </font></b>: I love the irony in sending you to kill dead creatures. May they rest in pea-- I will send you to kill them again tomorrow.")
					else
						p << npcsay("<font color = red><b>Vengeful Wisp </font></b>: Don't waste time talking to me, actions speak louder than words!")
						return
				else if(time2text(world.realtime, "DD") != time2text(pointer.time, "DD"))
					p.questPointers -= pointer
					pointer = null

			if(!pointer)
				p << npcsay("<font color = red><b>Vengeful Wisp </font></b>: You, human! I want you to help me express my rage, kill every wisp you face, vengeance shall be mine! Mawhahahaha!!!")
				p.startQuest("Will of the Wisp \[Daily]")
			else
				p << npcsay("<font color = red><b>Vengeful Wisp </font></b>: Pity the living!")

	Mysterious_Wizard
		icon_state="wizard"

		Talk()
			set src in oview(3)
			var/mob/Player/p = usr
			var/questPointer/pointer = p.questPointers["The Eyes in the Sand \[Daily]"]
			if(pointer)
				if(pointer.stage)
					if(p.checkQuestProgress("Mysterious Wizard"))
						p << npcsay("<font color = red><b>Mysterious Wizard </font></b>: Floating eyes, the gods of the desert can bleed after all, how amusing!")
					else
						p << npcsay("<font color = red><b>Mysterious Wizard </font></b>: Not enough, go back there and check if they all bleed!")
					return
				else if(time2text(world.realtime, "DD") != time2text(pointer.time, "DD"))
					p.questPointers -= pointer
					pointer = null

			if(!pointer)
				p << npcsay("<font color = red><b>Mysterious Wizard </font></b>: Beyond this hole in the wall lies the desert, oh so mysterious... There are strange creatures there called floating eyes, check if they bleed for me!")
				p.startQuest("The Eyes in the Sand \[Daily]")
			else
				p << npcsay("<font color = red><b>Mysterious Wizard </font></b>: So even the gods of the desert can bleed... Interesting!")

	Saratri
		icon_state="lord"

		Talk()
			set src in oview(3)
			var/mob/Player/p = usr
			var/questPointer/pointer = p.questPointers["To kill a Boss \[Daily]"]
			if(pointer)
				if(pointer.stage)
					if(p.checkQuestProgress("Saratri"))
						p << npcsay("<font color = red><b>Saratri </font></b>: Good job! I can't believe you pulled it off!")
					else
						p << npcsay("<font color = red><b>Saratri </font></b>: Go kill the Basilisk!")
					return
				else if(time2text(world.realtime, "DD") != time2text(pointer.time, "DD"))
					p.questPointers -= pointer
					pointer = null

			if(!pointer)
				p << npcsay("<font color = red><b>Saratri </font></b>: Hey there... Did you know there's a terrible monster here called the Basilisk? I'll reward you if you kill it...")
				p.startQuest("To kill a Boss \[Daily]")
			else
				p << npcsay("<font color = red><b>Saratri </font></b>: Wow! I can't believe you killed the Basilisk!")

	Hunter
		icon_state="lord"

		Talk()
			set src in oview(3)
			var/mob/Player/p = usr

			var/list/tiers = list("Rat", "Demon Rat", "Pixie", "Dog", "Snake", "Wolf", "Troll", "Fire Bat", "Fire Golem", "Archangel", "Water Elemental", "Fire Elemental", "Wyvern")
			for(var/tier in tiers)
				var/questPointer/pointer = p.questPointers["Pest Extermination: [tier]"]
				if(pointer && !pointer.stage) continue

				if(!pointer)
					p << npcsay("<font color = red><b>Hunter </font></b>: Hey there, maybe you can help me, I want to exterminate a few pests from our lives.")
					p.startQuest("Pest Extermination: [tier]")
				else
					p << npcsay("<font color = red><b>Hunter </font></b>: Did you kill the monsters I requested yet?")
					if(p.checkQuestProgress("Hunter"))
						p << npcsay("<font color = red><b>Hunter </font></b>: Good job!")
					else
						p << npcsay("<font color = red><b>Hunter </font></b>: Go back out there and exterminate some pests!")
				return

			var/questPointer/pointer = p.questPointers["Pest Extermination \[Daily]"]
			if(pointer)
				if(pointer.stage)
					if(p.checkQuestProgress("Hunter"))
						p << npcsay("<font color = red><b>Hunter </font></b>: Good job!")
					else
						p << npcsay("<font color = red><b>Hunter </font></b>: Go back out there and exterminate some pests!")
					return
				else if(time2text(world.realtime, "DD") != time2text(pointer.time, "DD"))
					p.questPointers -= pointer
					pointer = null

			if(!pointer)
				p << npcsay("<font color = red><b>Hunter </font></b>: Those monsters you've exterminated returned, go there and exterminate them again.")
				p.startQuest("Pest Extermination \[Daily]")
			else
				p << npcsay("<font color = red><b>Hunter </font></b>: You've done a really good job exterminating all those monsters.")


	Zerf
		icon_state = "stat"

		Talk()
			set src in oview(3)
			var/mob/Player/p = usr
			var/questPointer/pointer = p.questPointers["PvP Introduction"]
			if(pointer)
				if(pointer.stage)
					if(p.checkQuestProgress("Zerf"))
						p << npcsay("<font color = red><b>Zerf </font></b>: Good job! You should try fighting people in the ranked arena by joining the matchmaking queue once you're at level cap.")
					else
						p << npcsay("<font color = red><b>Zerf </font></b>: You aren't going to get any better by not fighting!")
					return
				else
					p << npcsay("<font color = red><b>Zerf </font></b>: You should try fighting people in the ranked arena by joining the matchmaking queue once you're at level cap.")

			else
				p << npcsay("<font color = red><b>Zerf </font></b>: Your skin looks so young and fresh, you haven't done much fighting eh? Why don't you try to fight a bunch of players?")
				p.startQuest("PvP Introduction")
	Cassandra
		icon_state="alyssa"

		Talk()
			set src in oview(3)
			var/mob/Player/p = usr
			var/questPointer/pointer = p.questPointers["Make a Potion"]
			if(pointer && !pointer.stage)

				if(level >= lvlcap)
					p << npcsay("<font color = red><b>Cassandra </font></b>: Look at you, such a weakling can not possibly help me.")
					return

				pointer = p.questPointers["Make a Fortune"]
				if(!pointer)
					p << npcsay("<font color = red><b>Cassandra </font></b>: Hey there, do you wish to make a fortune?! Well, you've come to the right place, I have a task for you, go out there to the world and collect a peice of the rarest monsters to be found, their fine essence will be sold for millions!")
					p.startQuest("Make a Fortune")
				else if(pointer.stage)
					if(p.checkQuestProgress("Cassandra"))
						p << npcsay("<font color = red><b>Cassandra </font></b>: Hmmph! I could've done it myself but I'm a lady, here you can have this scarf, I don't need it anymore...")
						p << errormsg("Cassandra takes the monster essences you've collected, she's going to make a fortune while you can warm yourself up with her old scarf.")
					else
						p << npcsay("<font color = red><b>Cassandra </font></b>: Maybe I was wrong about you, maybe you aren't capable of defeating such rare monsters.")
					return
				else
					p << npcsay("<font color = red><b>Cassandra </font></b>: Come back later, I might have more tasks for the likes of you later \[To be continued in a later update].")

			else
				p << npcsay("<font color = red><b>Cassandra </font></b>: You should try helping my twin sister Alyssa, she's sitting at Three Broom Sticks, I hear she seeks an immortality potion.")