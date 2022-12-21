mob/TalkNPC/Bob
	icon='Bob.dmi'
	density=1
	Immortal=1
	New()
		..()
		GenerateNameOverlay(115,115,115)
	Talk()
		set src in oview(2)
		var/mob/Player/p = usr
		if("Soul" in p.questPointers)
			var/questPointer/pointer = p.questPointers["Soul"]
			if(pointer.stage == 1)
				usr<<npcsay("<font color = red><b>Bob</b></font> : Couldn't finish it?")
			else if(pointer.stage == 2)
				usr<<npcsay("<font color = red><b>Bob </b></font>: Thanks, now to the business.")
				sleep(1)
				p.checkQuestProgress("Bob")
				usr<<npcsay("<font color = red><b>Bob </font></b>: Here is my eternal gift to you.")
			else
				usr<<npcsay("<font color = red><b>Bob </font></b>: Thanks you for clearing out those filthy monsters.")
		else
			usr<<npcsay("<font color = red><b>Bob </font></b>: If you are able to stop the evil from haunting Godric's Hollow and provide us with life again, in turn I will give you my soul stone.")
			switch(input("Head to the mysterious manor over the lake. ","Soul Quest") in list("Yes","No"))
				if("Yes")
					p.startQuest("Soul")
					usr.Resort_Stacking_Inv()
mob/TalkNPC/Clothing_Designer
	icon='ClothDesigner.dmi'
	Immortal=1
	Gm=1
	New()
		..()
		GenerateNameOverlay(255,153,204)
	Talk()
		set src in oview(2)
		var/icon/chosen
		var/icon/fix = new('c_move.dmi')
		var/obj/N
		usr << npcsay("<font color = red><b>Clothing Designer </font></b>: Hello there. How can I help you today?")
		if(usr.level>500)
			switch(input("What would you like?") as null|anything in list("Shirt (3 000 000 gold)","Trousers (3 000 000 gold)","Jacket (4 000 000 gold)","Magic Feather (1 000 000 gold)"))
				if("Shirt (3 000 000 gold)")
					if(usr.gold>=3000000)
						chosen = new('shirt.dmi')
						usr.gold-=3000000
						N = new/obj/items/wearable/shirts/shirt(usr)
					else
						usr << npcsay("<font color = red><b>Clothing Designer </b></font>: Get some money kiddo then come back.")
						return 0
				if("Trousers (3 000 000 gold)")
					if(usr.gold>=3000000)
						chosen = new('trousers.dmi')
						usr.gold-=3000000
						N = new/obj/items/wearable/trousers/trousers(usr)
					else
						usr << npcsay("<font color = red><b>Clothing Designer </font></b>: Get some money kiddo then come back.")
						return 0
				if("Jacket (4 000 000 gold)")
					if(usr.gold>=4000000)
						chosen = new('jacket.dmi')
						usr.gold-=4000000
						N = new/obj/items/wearable/jackets/jacket(usr)
					else
						usr << npcsay("<font color = red><b>Clothing Designer </font></b>: Get some money kiddo then come back.")
						return 0
				if("Magic Feather (1 000 000 gold)")
					if(usr.gold>=1000000)
						new/obj/items/Magic_Feather(usr)
						usr.gold-=1000000
						usr << npcsay("<font color = red><b>Clothing Designer </font></b>: It has properties to recolor your clothing, don't waste it.")
						return 0
					else
						usr << npcsay("<font color = red><b>Clothing Designer </font></b>: Get some money kiddo then come back.")
						return 0
			if(!N)return
			var/input = input("Choose color") as color
			chosen.Blend(rgb(GetRedPart(input),GetGreenPart(input),GetBluePart(input)),ICON_MULTIPLY)
			fix.Blend(chosen,ICON_OVERLAY)
			N.icon = fix
			usr:Resort_Stacking_Inv()
		else
			usr << npcsay("<font color = red><b>Clothing Designer </font></b>: I'm sorry honey but you're not old enough to shop here yet.")

mob/TalkNPC/Crystal_Dealer
	icon='Crystal_Dealer.dmi'
	Immortal=1
	Gm=1
	New()
		..()
		GenerateNameOverlay(115,115,115)
	Talk()
		set src in oview(2)
		usr << npcsay("<font color = red><b>Crystal Dealer </font></b>: Hey, you!")
		sleep(2)
		usr << npcsay("Crystal Dealer inhales deeply. He sounds wheezy.")
		sleep(4)
		usr << npcsay("<font color = red><b>Crystal Dealer </font></b>: Have you come here for--")
		usr << npcsay("Crystal Dealer takes another deep breath in and splutters on the outbreath.")
		sleep(3)
		usr << npcsay("<font color = red><b>Crystal Dealer </font></b>: --crystals?!?!")
		sleep(4)
		usr << npcsay("<font color = red><b>Crystal Dealer </font></b>: 'Cause I've got some.")
		if(usr.gold>=1000000)
			switch(input("Crystal Dealer : Which one you want?","You have [comma(usr.gold)] gold") as null|anything in list("Green","Pink","Yellow","Black","Dark Blue","Red","Dark Red","Light Blue","Dark Teal","Teal","Orange","Dark Purple","Purple","Pink","Light Green","Aquatic"))
				if("Green")
					if(usr.gold>=1000000)
						var/obj/o = new/obj/items/soul_shard(usr)
						o.color="#00e64d"
						usr.gold-=1000000
					else
						usr << npcsay("<font color = red><b>Crystal Dealer </font></b>: BEGONE! Come back when you're less skint!")
				if("Pink")
					if(usr.gold>=1000000)
						var/obj/o = new/obj/items/soul_shard(usr)
						o.color="#ff80ff"
						usr.gold-=1000000
					else
						usr << npcsay("<font color = red><b>Crystal Dealer </font></b>: BEGONE! Come back when you're less skint!")
				if("Yellow")
					if(usr.gold>=1000000)
						var/obj/o = new/obj/items/soul_shard(usr)
						o.color="#ffff4d"
						usr.gold-=1000000
					else
						usr << npcsay("<font color = red><b>Crystal Dealer </font></b>: BEGONE! Come back when you're less skint!")
				if("Black")
					if(usr.gold>=1000000)
						var/obj/o = new/obj/items/soul_shard(usr)
						o.color="#404040"
						usr.gold-=1000000
					else
						usr << npcsay("<font color = red><b>Crystal Dealer </font></b>: BEGONE! Come back when you're less skint!")
				if("Dark Blue")
					if(usr.gold>=1000000)
						var/obj/o = new/obj/items/soul_shard(usr)
						o.color="#0040ff"
						usr.gold-=1000000
					else
						usr << npcsay("<font color = red><b>Crystal Dealer </font></b>: BEGONE! Come back when you're less skint!")
				if("Red")
					if(usr.gold>=1000000)
						var/obj/o = new/obj/items/soul_shard(usr)
						o.color="#e60000"
						usr.gold-=1000000
					else
						usr << npcsay("<font color = red><b>Crystal Dealer </font></b>: BEGONE! Come back when you're less skint!")
				if("Dark Red")
					if(usr.gold>=1000000)
						var/obj/o = new/obj/items/soul_shard(usr)
						o.color="#862d2d"
						usr.gold-=1000000
					else
						usr << npcsay("<font color = red><b>Crystal Dealer </font></b>: BEGONE! Come back when you're less skint!")
				if("Light Blue")
					if(usr.gold>=1000000)
						var/obj/o = new/obj/items/soul_shard(usr)
						o.color="#66e0ff"
						usr.gold-=1000000
					else
						usr << npcsay("<font color = red><b>Crystal Dealer </font></b>: BEGONE! Come back when you're less skint!")
				if("Dark Teal")
					if(usr.gold>=1000000)
						var/obj/o = new/obj/items/soul_shard(usr)
						o.color="#006666"
						usr.gold-=1000000
					else
						usr << npcsay("<font color = red><b>Crystal Dealer </font></b>: BEGONE! Come back when you're less skint!")
				if("Teal")
					if(usr.gold>=1000000)
						var/obj/o = new/obj/items/soul_shard(usr)
						o.color="#00cccc"
						usr.gold-=1000000
					else
						usr << npcsay("<font color = red><b>Crystal Dealer </font></b>: BEGONE! Come back when you're less skint!")
				if("Orange")
					if(usr.gold>=1000000)
						var/obj/o = new/obj/items/soul_shard(usr)
						o.color="#ffa64d"
						usr.gold-=1000000
					else
						usr << npcsay("<font color = red><b>Crystal Dealer </font></b>: BEGONE! Come back when you're less skint!")
				if("Dark Purple")
					if(usr.gold>=1000000)
						var/obj/o = new/obj/items/soul_shard(usr)
						o.color="#800040"
						usr.gold-=1000000
					else
						usr << npcsay("<font color = red><b>Crystal Dealer </font></b>: BEGONE! Come back when you're less skint!")
				if("Purple")
					if(usr.gold>=1000000)
						var/obj/o = new/obj/items/soul_shard(usr)
						o.color="#990099"
						usr.gold-=1000000
					else
						usr << npcsay("<font color = red><b>Crystal Dealer </font></b>: BEGONE! Come back when you're less skint!")
				if("Pink")
					if(usr.gold>=1000000)
						var/obj/o = new/obj/items/soul_shard(usr)
						o.color="#ffb3ff"
						usr.gold-=1000000
					else
						usr << npcsay("<font color = red><b>Crystal Dealer </font></b>: BEGONE! Come back when you're less skint!")
				if("Pink")
					if(usr.gold>=1000000)
						var/obj/o = new/obj/items/soul_shard(usr)
						o.color="#ffb3ff"
						usr.gold-=1000000
					else
						usr << npcsay("<font color = red><b>Crystal Dealer </font></b>: BEGONE! Come back when you're less skint!")
				if("Light Green")
					if(usr.gold>=1000000)
						var/obj/o = new/obj/items/soul_shard(usr)
						o.color="#66ff66"
						usr.gold-=1000000
					else
						usr << npcsay("<font color = red><b>Crystal Dealer </font></b>: BEGONE! Come back when you're less skint!")
				if("Aquatic")
					if(usr.gold>=1000000)
						var/obj/o = new/obj/items/soul_shard(usr)
						o.color="#66ff66"
						usr.gold-=1000000
					else
						usr << npcsay("<font color = red><b>Crystal Dealer </font></b>: BEGONE! Come back when you're less skint!")
		else
			usr << npcsay("<font color = red><b>Crystal Dealer </font></b>: Quit wasting my time!")
