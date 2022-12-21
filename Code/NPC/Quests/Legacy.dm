obj/items/freds_key
	name = "Fred's key"
	icon = 'key.dmi'
	destroyable = 1
	dropable = 0
	Destroy()
		var/mob/Player/user = usr
		var/questPointer/pointer = user.questPointers["On House Arrest"]
		if(pointer.stage == 1)
			user << errormsg("You still need to take this key to Gringott's Bank.")
		else
			..()

mob
	var
		palmer
		quests
		talktotom
		ratquest

mob/TalkNPC
	professor_palmer
		icon_state="palmer"
		name="Professor Palmer"
		Immortal=1
		Gm=1

		Talk()
			set src in oview(1)
			usr<< npcsay("<font color = red><b>Palmer </font></b>:Looking for something?")
/*			if(locate(/obj/items/questbook) in usr)
				usr << npcsay("<font color = red><b>Palmer </font></b>: Have a good day.")
			else
				usr << "<font color = red><b>Palmer </font></b>: Hello there young student. I am a former professor at Hogwarts. My name is Professor Palmer."
				sleep(20)
				usr << "<br><font color = red><b>Palmer </font></b>: I was asked by the Headmaster to teach you about quests and the quest book. Oh, and to give you this."
				alert("Professor Palmer hands you a small black book")
				new/obj/items/questbook(usr)
				usr << "<br><font color = red><b>Palmer </font></b>: This is your quest book, inside you keep track of all your accomplished quests."
				sleep(50)
				usr << "<br><font color = red><b>Palmer </font></b>: If you lose your quest book, you can come back here and get a new one."
				sleep(30)
				usr << "<br><font color = red><b>Palmer </font></b>: How would you like to put something in that book?"
				sleep(30)
				usr << "<br><font color = red><b>Palmer </font></b>: If you're interested, I have a friend who could use your help. Tom the Barman in Diagon Alley could use your help, go check it out."
*/
mob/var/talkedtogirl
mob/var/babyquest
mob/var/babyfound
mob/var/foundlord
mob/var/talkedtofred


mob/TalkNPC
	Fred
		icon_state="fred"
		density=1
		Immortal=1

		Talk()
			set src in oview(3)
			var/mob/Player/p = usr
			if("On House Arrest" in p.questPointers)
				var/questPointer/pointer = p.questPointers["On House Arrest"]

				if(pointer.stage == 1)
					usr << "<font color=red>Fred</font> </b>:<font color=white> Quickly now, go get my wand from the deposit box in Gringott's bank."
					sleep(30)
					switch(input("Fred: Quickly now","Fred")in list("Where is Gringott's again?","I'm on my way"))
						if("Where is Gringott's again?")
							usr << "<b><font color=red>Fred</font> </b>:<font color=white> Gringott's Bank is found in Diagon Alley. You can find Diagon Alley near the Train Station here in Hogsmeade."
				else if(pointer.stage == 2)
					alert("You show Fred the wand")
					usr << "<b><font color=red>Fred</font> </b>:<font color=white> YES! You got it!"
					sleep(30)
					usr << "<b><font color=red>Fred</font> </b>:<font color=white> Quickly! Use the wand to get me out of here!"
					sleep(20)
					alert("You point the wand at the barriers")
					usr << "<b><font color=red>[usr]</font> </b>:<font color=aqua><font size=2> <b>Finite Incantum!</b></font>"
					usr << "<b><font color=red>Fred</font> </b>:<font color=white> Finally! I'm free!!!"
					alert("Fred jumps up and down")
					usr << "<b><font color=red>Fred</font> </b>:<font color=white> Thank you so much! You can keep that wand if you'd like."
					p.checkQuestProgress("Fred")
					p.Its()
				else
					p.Its()
					usr << "<b><font color=red>Fred</font> </b>:<font color=white> Thanks again!"
			else
				alert("Fred waves his hands in the air")
				usr << "<b><font color=red>Fred</font> </b>:<font color=white> Help! Help!"
				switch(input("Fred: HELP HELP!","Fred")in list("What happened?","Shh keep it down","*Ignore Fred*"))
					if("What happened?")
						usr << "<b><font color=red>Fred</font> </b>:<font color=white> Some strange man did this to me!"
						sleep(30)
						switch(input("Your response","Fred")in list("Why?","What did he look like?","Which way did he go","Let's get you out of there"))
							if("Why?")
								usr << "<b><font color=red>Fred</font> </b>:<font color=white> Well, he was walking past my house carrying this large sack.."
								sleep(20)
								usr << "<b><font color=red>Fred</font> </b>:<font color=white> It looked like there was a person inside! So, I confronted him and asked him what was inside."
								sleep(30)
								usr << "<b><font color=red>Fred</font> </b>:<font color=white> I don't think he liked me asking questions, so he cast a spell on me which locked me in here!"
								alert("Fred frowns")
								return
							if("What did he look like?")
								usr << "<b><font color=red>Fred</font> </b>:<font color=white> I couldn't tell exactly."
								sleep(20)
								usr << "<b><font color=red>Fred</font> </b>:<font color=white> He was wearing a dark green cloak..OH! And he had an eye patch!"
							if("Which way did he go")
								usr << "<b><font color=red>Fred</font> </b>:<font color=white> I'm not sure, his spell must have knocked me because when I woke up I was locked in here."
							if("Let's get you out of there")
								usr << "<b><font color=red>Fred</font> </b>:<font color=white> Oh thank you!"
								sleep(30)
								usr << "<b><font color=red>[usr]</font> </b>:<font color=white> Now, how will we get you out?"
								sleep(30)
								usr << "<b><font color=red>Fred</font> </b>:<font color=white> I have a wand that could help! It's in my deposit box at Gringotts. Here's the key."
								alert("Fred tosses the key to you")
								new/obj/items/freds_key(usr)
								usr << "<b> <font color=red>Fred</font> </b>:<font color=white> Quickly! Go to Gringotts and get me out of here!"
								alert("You nod")

								p.startQuest("On House Arrest")
								p.Resort_Stacking_Inv()


mob/TalkNPC
	Girl
		icon_state="girl"
		density=1
		Immortal=1

		verb
			Examine()
				set src in oview(3)
				usr << "A local townsgirl."

		Talk()
			set src in oview(3)
			var/mob/Player/p = usr
			if("Stolen by the Lord" in p.questPointers)
				var/questPointer/pointer = p.questPointers["Stolen by the Lord"]
				if(pointer.stage)
					usr << "The girl looks up at you quickly"
					usr << "<b><font color=red>Girl</font> </b>:<font color=white> Did you find him yet?!?"

					if(pointer.stage == 2)
						usr << "<b><font color=red>[usr]</font> </b>:<font color=white> Yep, I found him. Here you are."
						usr << "You hand the little baby boy to the girl"
						usr << "The girl craddles the baby in her arms and places him down in his cot. She runs towards you with arms open wide"
						usr << "<b><font color=red>Girl</font> </b>:<font color=white> THANK YOU THANK YOU THANK YOU!"
						usr << "You find yourself smiling slightly"
						usr << "<b><font color=red>Girl</font> </b>:<font color=white> Here, this is my allowance that I saved up, you can have it."
						usr << "The girl hands you a hand full of gold."
						p.checkQuestProgress("Girl")
					else
						usr << "<b><font color=red>[usr]</font> </b>:<font color=white> Not yet, sorry."
						usr << "The girl frowns."
				else
					usr << "<b><font color=red>Girl</font> </b>:<font color=white> Thanks again!"
					sleep(10)
					usr << "The girl smiles bigger than any smile you've ever seen."

			else
				usr << "<b><font color=red>Girl</font> </b>:<font color=white> Help! Help!"
				alert("The girl waves her arms in distress")
				sleep(30)
				switch(input("Girl: Are you here to help me?","Help?")in list("Yes","No"))
					if("Yes")
						usr << "<b><font color=red>Girl</font> </b>:<font color=white> Oh, THANK YOU!"
						sleep(20)
						usr << "<b><font color=red>Girl</font> </b>:<font color=white> My mom left to go to the store, and told me to watch my little brother."
						sleep(30)
						usr << "<b><font color=red>Girl</font> </b>:<font color=white> I literaly turned my back for one second and my little brother was gone!"
						alert("The girl bursts into tears")
						usr << "<b><font color=red>[usr]</font> </b>:<font color=white> Okay, calm down. Do you remember anything that could help?"
						alert("The girl scratches her head")
						usr << "<b><font color=red>Girl</font> </b>:<font color=white> Uhm, I'm not sure. Actually, come to think of it, I heard some shouting not long after he went missing. Sounded like someone casting a spell or something.."
						sleep(30)
						usr << "<b><font color=red>[usr]</font> </b>:<font color=white> Hmm, maybe I'll ask around town to see if anyone else saw or heard anything."
						alert("The girl nods somberly")
						p.startQuest("Stolen by the Lord")
					if("No")
						alert("The girl frowns")






mob
	Baby
		icon = 'NPCs.dmi'
		icon_state="baby"
		density=1
		Immortal=1
		verb
			Examine()
				set src in oview(5)
				usr << "A widdle baby."

mob/TalkNPC
	Lord
		icon_state="lord"
		density=1
		Immortal=1

		verb
			Examine()
				set src in oview(3)
				usr << "He looks like someone you wouldn't want to end up in the Leaky Cauldron with at last orders.."

		Talk()
			set src in oview(3)
			var/mob/Player/p = usr
			if("Stolen by the Lord" in p.questPointers)
				var/questPointer/pointer = p.questPointers["Stolen by the Lord"]
				if(pointer.stage == 1)
					switch(input("Lord: How did you get here!","Lord")in list("Your maze was pretty lame","Give back the girls baby"))
						if("Your maze was pretty lame")
							switch(input("Lord: WHAT! NEVER!!! I will demolish you!","Lord")in list("Bring it on!","No! I'm sorry."))
								if("Bring it on!")
									usr << "<b><font color=red>Lord</font> </b>:<font color=white> You want to... fight me? Uh, no bodys ever taken the challenge before... HERE! You win."
									p.checkQuestProgress("Lord")
								if("No! I'm sorry.")
									alert("The Lord squints his eye at you and turns his back")
						if("Give back the girls baby")
							switch(input("Lord: Never! You'll have to take it!","Lord")in list("So it shall be."))
								if("So it shall be.")
									usr << "<b><font color=red>Lord</font> </b>:<font color=white> You want to... fight me? Uh, no bodys ever taken the challenge before... HERE! You win."
									p.checkQuestProgress("Lord")
					return
				else if(pointer.stage == 2)
					usr << "You won, go back to the girl."
					return

			usr << "He looks like someone you wouldn't want to end up in the Leaky Cauldron with at last orders.. Maybe it's best not to bother him."

turf
	lever
		icon='lever.dmi'
		density=1
		verb
			Examine()
				set src in oview(3)
				alert("You see that the lever is connected to a small trapdoor in the wall")
			Pull_Lever()
				set src in oview(1)
				switch(input("Pull the lever?","Pull the lever?")in list("Yes","No"))
					if("Yes")
						alert("You pull the lever")
						alert("The trapdoor in the wall slowly creeks shut")
						var/mob/Player/p = usr
						p.checkQuestProgress("Lever")
						for(var/turf/lever/L in oview())
							flick("pull",L)
					if("No")
						return

mob/var/talkedtobunny

mob/TalkNPC
	easterbunny
		icon_state = "easter"
		name= "Easter Bunny"
		density=1
		Immortal=1

		verb
			Examine()
				set src in oview(3)
				usr << "The friendly Easter Bunny!!"

		Talk()
			set src in oview(3)
			if(usr.talkedtobunny==1)
				usr << "\n<font size=2><font color=red><b> <font color=#FF3399>Easter Bunny</font> </b>:<font color=white> Did you find the chocolate yet!!?!"
				sleep(30)
				usr << "\n<font size=2><font color=red><b> <font color=Red>[usr]</font> </b>:<font color=white> No, not yet. Sorry."
				sleep(20)
				alert("The Easter Bunny frowns")
				sleep(20)
				usr << "\n<font size=2><font color=red><b> <font color=#FF3399>Easter Bunny</font> </b>:<font color=white> Oh...okay."

			if(usr.talkedtobunny==2)
				alert("You throw the bag of chocolates to the Easter Bunny.")
				sleep(20)
				usr << "\n<font size=2><font color=red><b> <font color=#FF3399>Easter Bunny</font> </b>:<font color=white> OH THANK YOU THANK YOU THANK YOU!!!"
				sleep(30)
				usr << "\n<font size=2><font color=red><b> <font color=#FF3399>Easter Bunny</font> </b>:<font color=white> Oh! Now Easter can continue! THANK YOU!!!"
				sleep(30)
				usr << "\n<font size=2><font color=red><b> <font color=#FF3399>Easter Bunny</font> </b>:<font color=white> I don't have much to give you. Although I can give you this!"
				alert("The Easter Bunny hands you an Easter Wand")
				new/obj/items/wearable/wands/maple_wand(usr)
				sleep(20)
				usr.talkedtobunny=3
				usr << "\n<font size=2><font color=red><b> <font color=#FF3399>Easter Bunny</font> </b>:<font color=white> ENJOY!"
			if(usr.talkedtobunny==3)
				usr << "\n<font size=2><font color=red><b> <font color=#FF3399>Easter Bunny</font> </b>:<font color=white> THANKS AGAIN!"

			else
				alert("The Easter Bunny frowns")
				switch(input("Your response","Respond")in list("What's wrong","*Walk away slowly*"))
					if("What's wrong")
						usr << "\n<font size=2><font color=red><b> <font color=#FF3399>Easter Bunny</font> </b>:<font color=white> It's just that, I made these brand new chocolates, that are a MILLION! times better than ordinary chocolate. And they seem to have went missing."
						alert("The Easter Bunny frowns")
						switch(input("Your Response","Respond")in list("Do you have any idea who did this?","Well quit talking to me and get to finding them!"))
							if("Do you have any idea who did this?")
								usr << "\n<font size=2><font color=red><b> <font color=#FF3399>Easter Bunny</font> </b>:<font color=white> No...I have no idea at all. I mean, who would want to hurt Easter!"
								sleep(30)
								switch(input("Easter Bunny: It's sad","Easter Bunny")in list("Don't worry, i'll find them for you","Oh well, good luck!"))
									if("Don't worry, i'll find them for you")
										usr << "\n<font size=2><font color=red><b> <font color=#FF3399>Easter Bunny</font> </b>:<font color=white> Oh, Thank you so much! I will be here waiting. Oh please hurry!"
										usr.talkedtobunny=1
									if("Oh well, good luck!")
										return

							if("Well quit talking to me and get to finding them!")
								alert("The Easter Bunny looks away")
								return

					if("*Walk away slowly*")
						alert("You back away slowly")
						usr.x = usr:x
						usr.y = usr:y-1
						usr.z = usr:z

mob/var/talkedzombie=0

obj
	chocolatebar
		name="Chocolate Bar"
		icon='chocolate_bar.dmi'
		icon_state="1"
		verb
			Take()
				set src in oview(0)
				hearers()<<"[usr] takes \the [src]."
				Move(usr)
				usr:Resort_Stacking_Inv()
		verb
			Drop()
				Move(usr.loc)
				usr:Resort_Stacking_Inv()
				hearers()<<"[usr] drops \his [src]."

	tootsieroll
		name="Tootsie Roll"
		icon='tootsie_roll.dmi'
		icon_state="2"
		verb
			Take()
				set src in oview(0)
				hearers()<<"[usr] takes \the [src]."
				Move(usr)
				usr:Resort_Stacking_Inv()
		verb
			Drop()
				Move(usr.loc)
				usr:Resort_Stacking_Inv()
				hearers()<<"[usr] drops \his [src]."

	candycorn
		name="Candy Corn"
		icon='candy_corn.dmi'
		icon_state="3"
		verb
			Take()
				set src in oview(0)
				hearers()<<"[usr] takes \the [src]."
				Move(usr)
				usr:Resort_Stacking_Inv()
		verb
			Drop()
				Move(usr.loc)
				usr:Resort_Stacking_Inv()
				hearers()<<"[usr] drops \his [src]."

	caramelapple
		name="Caramel Apple"
		icon='caramel_apple.dmi'
		icon_state="4"
		verb
			Take()
				set src in oview(0)
				hearers()<<"[usr] takes \the [src]."
				Move(usr)
				usr:Resort_Stacking_Inv()
		verb
			Drop()
				Move(usr.loc)
				usr:Resort_Stacking_Inv()
				hearers()<<"[usr] drops \his [src]."

obj
	Halloween_Bucket
		icon='halloween_bucket.dmi'
		icon_state="bag1"
		verb
			Take_Out_Candy()
				hearers() << "<font color=#FFA600><b>[usr] pulls some candy out of \his halloween bucket!</b></font>"
				var/rnd=rand(1,4)
				if(rnd==1)
					var/obj/chocolatebar/p = new
					p:loc = locate(src.x,src.y-1,src.z)
					p:owner = "[usr.key]"
				if(rnd==2)
					var/obj/tootsieroll/p = new
					p:loc = locate(src.x,src.y-1,src.z)
					p:owner = "[usr.key]"
				if(rnd==3)
					var/obj/candycorn/p = new
					p:loc = locate(src.x,src.y-1,src.z)
					p:owner = "[usr.key]"
				if(rnd==4)
					var/obj/caramelapple/p = new
					p:loc = locate(src.x,src.y-1,src.z)
					p:owner = "[usr.key]"


		verb
			Use()
				hearers() << "<font color=#FFA600><b>[usr] pulls out \his halloween bucket.</b></font>"
				usr.overlays+=image('halloween-bag.dmi')

		verb
			Take_Off()
				hearers() << "<font color=#FFA600><b>[usr] puts away \his halloween bucket.</b></font>"
				usr.overlays-=image('halloween-bag.dmi')
		verb
			Take()
				set src in oview(0)
				hearers()<<"[usr] takes \the [src]."
				Move(usr)
				usr:Resort_Stacking_Inv()
		verb
			Destroy()
				switch(input("Are you sure you want to destroy this?","Destroy?")in list("Yes","No"))
					if("Yes")
						del src
						usr.overlays-=image('halloween-bag.dmi')
					if("No")
						return

			Examine()
				set src in view(3)
				usr << "<font color=#FFA600>It's a Halloween Bucket from 2011!</font>"


mob/TalkNPC
	Tim
		icon_state="tim"
		density=1
		Immortal=1

		verb
			Examine()
				set src in oview(3)
				usr << "One of the Easter Bunnies helpers."

		Talk()
			set src in oview(3)
			if(usr.talkedtobunny==1)
				switch(input("Tim: Isn't it sad what happened the Easter Bunny?","Tim")in list("Very sad.","Any idea who did it?","Not really."))
					if("Very sad.")
						alert("Tim nods somberly")
					if("Any idea who did it?")
						switch(input("Tim: It was probably that thief Zonko.","Tim")in list("Maybe I will go talk to Zonko"))
							if("Maybe I will go talk to Zonko")
								usr << "\n<font size=2><font color=red><b> <font color=red>Tim</font> </b>:<font color=white> Alright"

			if(usr.talkedtobunny==3)
				usr << "\n<font size=2><font color=red><b> <font color=red>Tim</font> </b>:<font color=white> Thanks again."


			else
				if(usr.talkedtobunny==1)
					return
				if(usr.talkedtobunny==2)
					return
				if(usr.talkedtobunny==3)
					return
				else
					usr << "\n<font size=2><font color=red><b> <font color=red>Tim</font> </b>:<font color=white> The Easter Bunny is in there."


mob/var/talkedtoalyssa


mob/TalkNPC
	Alyssa
		icon_state="alyssa"
		Gm=1
		Immortal=1

		Talk()
			set src in oview(3)
			var/mob/Player/p = usr
			if("Make a Potion" in p.questPointers)
				var/questPointer/pointer = p.questPointers["Make a Potion"]
				if(pointer.stage)
					usr << "<b><font color=red>Alyssa </b>: </font>Find my ingredients yet?!"
					switch(input("What is your response?","Make a selection")in list("Yes","No"))
						if("Yes")
							usr << "<b><font color=red>Alyssa </b>: </font>Well let's see them."
							if(pointer.stage == 2)
								usr << "<b><font color=red>Alyssa </b>: </font>You have it all! How wonderful!"
								sleep(25)
								usr << "<b><font color=red>Alyssa </b>: </font>Now we'll use these to brew the potion."
								sleep(20)
								usr << "<b><font color=red>Alyssa </b>: </font>Hopefully I've mixed it right! I'm ready to be immortal."
								sleep(25)
								usr << "<i>Alyssa drinks the potion</i>"
								sleep(20)
								flick("transfigure.dmi",src)
								src.icon='Frog.dmi'
								sleep(40)
								flick("transfigure.dmi",src)
								icon='NPCs.dmi'
								icon_state="alyssa"
								sleep(20)
								usr << "<b><font color=red>Alyssa </b>: </font>I guess it was too good to be true."
								sleep(20)
								usr << "<b><font color=red>Alyssa </b>: </font>Thanks for helping me anyways, you can have these as a token of my gratitude."

								for(var/obj/items/Alyssa/X in usr)
									X.loc = null
								var/obj/items/AlyssaScroll/scroll = locate() in usr
								if(scroll)
									scroll.loc = null
								p.checkQuestProgress("Alyssa")
							else
								usr << "<b><font color=red>Alyssa </b>: </font>You don't have all of the ingredients! Go back and look for them!"
						if("No")
							usr << "<b><font color=red>Alyssa </b>: </font>Better keep on looking!"
				else
					usr << "<b><font color=red>Alyssa </b>: </font>Thanks again for helping me."
			else
				usr << "<b><font color=red>Alyssa </b>: </font>Hey there! You look like someone with too much time on their hands."
				sleep(15)
				usr << "<b><font color=red>Alyssa </b>: </font>How would you like to help me out?"
				switch(input("What do you say?","Make a selection")in list("What do you need help with?","No thanks"))
					if("What do you need help with?")
						usr << "<b><font color=red>Alyssa </b>: </font>Well I've been reading this book I found! There's a recipe here for a potion that makes anyone immortal!"
						sleep(15)
						usr << "<b><font color=red>Alyssa </b>: </font>I just don't have all the ingredients I need, can you help me find some?!"
						switch(input("Will you help Alysaa find the potion ingredients?","Make a selection")in list("Certainly!","I've got better things to do"))
							if("Certainly!")
								usr << "<b><font color=red>Alyssa </b>: </font>Oh wonderful! I know people around here make potions. Maybe they have some ingredients stashed away in there houses."
								sleep(15)
								usr << "<b><font color=red>Alyssa </b>: </font>I'm not saying to steal them....Just borrow them. Indefinitely."
								sleep(15)
								usr << "<b><font color=red>Alyssa </b>: </font>There's probably some growing around too. Here's my list!"
								new/obj/items/AlyssaScroll(usr)
								alert("Alyssa hands you her list of potion ingredients")
								usr << "<b><font color=red>Alyssa </b>: </font>Thanks!"
								p.Resort_Stacking_Inv()
								p.startQuest("Make a Potion")
							if("I've got better things to do")
								return
					if("No thanks")
						return
mob/var/onionroot
mob/var/indigoseeds
mob/var/silverspiderlegs
mob/var/salamanderdrop

obj/items/Alyssa
	icon='ingred.dmi'
	dropable = 0

	Onion_Root
		icon_state="Onion Root"
		desc = "I found an onion root!"
	Salamander_Drop
		icon_state="Salamander Drop"
		desc = "What the heck is a Salamander Drop?!"
	Indigo_Seeds
		icon_state="Indigo Seeds"
		desc = "I found some Indigo Seeds!"
	Silver_Spider_Legs
		icon_state="Silver Spider Legs"
		desc = "I found some Silver Spider Legs!"



obj/AlyssaChest
	name="Chest"
	icon='turf.dmi'
	icon_state="chest"
	density=1
	mouse_over_pointer = MOUSE_HAND_POINTER

	var/r

	proc/open(mob/Player/p)
		alert(p, "You open the chest")
		if(usr.ror == r)
			return 1
		else
			alert("You find nothing.")

	verb
		Examine()
			set src in oview(3)
			usr<<"A chest! I wonder what's inside!"
	verb
		Open()
			set src in oview(1)
			open(usr)

	Click()
		..()
		if(src in oview(1))
			open(usr)
		else
			usr << errormsg("You need to be closer.")

	Onion_Root
		Ror1
			r = 1
		Ror2
			r = 2
		Ror3
			r = 3
		open(mob/Player/p)
			.=..()
			if(. && p.checkQuestProgress("Onion Root"))
				alert("You find an Onion Root!")
				new/obj/items/Alyssa/Onion_Root(usr)
				p.Resort_Stacking_Inv()

	Indigo_Seeds
		Ror1
			r = 1
		Ror2
			r = 2
		Ror3
			r = 3
		open(mob/Player/p)
			.=..()
			if(. && p.checkQuestProgress("Indigo Seeds"))
				alert("You find some Indigo Seeds!")
				new/obj/items/Alyssa/Indigo_Seeds(usr)
				p.Resort_Stacking_Inv()

	Silver_Spider
		Ror1
			r = 1
		Ror2
			r = 2
		Ror3
			r = 3
		open(mob/Player/p)
			.=..()
			if(. && p.checkQuestProgress("Silver Spider Legs"))
				alert("You find some Silver Spider Legs!")
				new/obj/items/Alyssa/Silver_Spider_Legs(usr)
				p.Resort_Stacking_Inv()

mob/var/talkedtosanta

