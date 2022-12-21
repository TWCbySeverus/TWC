
var/list
	GotWallyPrize[300]
area/
	GMroom

obj
	Level_Scroll
		name="Advanced Graduation Scroll"
		icon='Level_Scroll.dmi'
		Click()
			if(src in usr.contents)
				Read_Level_Scroll()
		verb
			Read_Level_Scroll()
				set name = "Read"
				var/lvls=300
				while(lvls>0)
					usr.Exp = usr.Mexp
					usr.LvlCheck(1)
					lvls--
				del src
				usr:Resort_Stacking_Inv()


mob
	Wally
		icon='Wally.dmi'
		NPC = 1
		Gm = 1
		player=1
		Immortal=1
		density=1
		var
			gift=0
			cash=0
			Gift_Path
		New()
			..
			src.GenerateNameOverlay(255,255,255)
		Click()
			set src in oview(3)
			Talk()
		verb
			Talk()
				set src in oview(3)
				if(usr.client.perspective!=usr.client.perspective)return 0
				var/key = ckey(usr.ckey)
				if(key in GotWallyPrize)
					usr<<"<font size=2><font color=red><b><font color=red>Wally</font></font> : You've already got your prize!"
				else
					if(src.gift==1)
						var/O = new Gift_Path(usr)
						usr<<"<font size=2><font color=red><b><font color=red>Wally</font></font> : Hey! You found me."
						usr<<"Wally gave you [O]"
						usr<<"<font size=2><font color=red><b><font color=red>Wally</font></font> : Don't tell anyone where I am, that would be no fun!"
						GotWallyPrize.Add(key)
						usr:Resort_Stacking_Inv()
					else if(src.gift==2)
						usr.gold+=cash
						usr<<"<font size=2><font color=red><b><font color=red>Wally</font></font> : Hey! You found me."
						usr<<"Wally gave you [src.cash] gold."
						usr<<"<font size=2><font color=red><b><font color=red>Wally</font></font> : Don't tell anyone where I am, that would be no fun!"
						GotWallyPrize.Add(key)
					else if(gift==3)
						var/O = new Gift_Path(usr)
						usr.gold+=cash
						usr<<"<font size=2><font color=red><b><font color=red>Wally</font></font> : Hey! You found me."
						usr<<"Wally gave you [O] and [src.cash] gold."
						usr<<"<font size=2><font color=red><b><font color=red>Wally</font></font> : Don't tell anyone where I am, that would be no fun!"
						GotWallyPrize.Add(key)
						usr:Resort_Stacking_Inv()
					else
						usr<<"WALLY ERROR:!@#@!"
mob/HGM/verb
	Give_Wally(mob/M in Players)
		set name="Give Event Verbs"
		set category="Events"
		M.verbs+=/mob/HGM/verb/Clear_Wally_List
		M.verbs+=/mob/HGM/verb/Spawn_Wally
	//	M.verbs+=/mob/GM/verb/Event_Points
		M.verbs+=/mob/GM/verb/Wally_Announce
	Take_Wally(mob/M in Players)
		set name="Take Event Verbs"
		set category="Events"
		M.verbs-=/mob/HGM/verb/Clear_Wally_List
		M.verbs-=/mob/HGM/verb/Spawn_Wally
	//	M.verbs-=/mob/GM/verb/Event_Points
		M.verbs-=/mob/GM/verb/Wally_Announce
	Clear_Wally_List()
		set category="Events"
		GotWallyPrize = null
		GotWallyPrize = new/list(300)
		usr<<"You've Cleared Wally List"
	Spawn_Wally()
		set category="Events"
		var/mob/Wally/W = new /mob/Wally
		var/WallyGift = input("Choose Prize Type from Wally")  as null|anything in list("Item","Gold","GoldItem","Level Scroll","Exit")
		switch(WallyGift)
			if("Item")
				var/T = input("Choose Prize") as anything in typesof(/obj/items/wearable/)
				W.gift=1
				W.Gift_Path=T
			if("Gold")
				var/Cashinput = input("Type Cash Amount") as num
				if(Cashinput>1000000)
					Cashinput=Cashinput/10
				W.cash=Cashinput
				W.gift=2
			if("GoldItem")
				var/T = input("Choose Prize") as anything in typesof(/obj/items)
				var/Cashinput = input("Type Cash Amount") as num
				if(Cashinput>1000000)
					Cashinput=Cashinput/10
				W.cash=Cashinput
				W.Gift_Path=T
				W.gift=3
			if("Level Scroll")
				var/T = /obj/Level_Scroll
				W.gift=1
				W.Gift_Path=T
			if("Exit")
				return 0
		W.loc = usr.loc
		usr<<"You Spawned [W]"
