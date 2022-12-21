obj/items/Zombie_Head
	icon='halloween.dmi'
	icon_state="head"
	desc = "The zombie's head stares at you."

	Click()
		if(src in usr)
			if(canUse(usr,cooldown=/StatusEffect/UsedTransfiguration,needwand=0,inarena=0,insafezone=1,inhogwarts=1,target=null,mpreq=100,againstocclumens=1,againstflying=0,againstcloaked=1))
				new /StatusEffect/UsedTransfiguration(usr,15)
				if(usr.CanTrans(usr))
					flick("transfigure.dmi",usr)
					hearers()<<"<b><font color=red>[usr]</font> : <b><font color=green> Personio Inter vivos.</b></font>"
					usr.trnsed = 1
					usr.overlays = null
					if(usr.away)usr.ApplyAFKOverlay()
					if(usr.Gender=="Female")
						usr.icon = 'FemaleZombie.dmi'
					else
						usr.icon = 'MaleZombie.dmi'
		else
			..()

obj/Stupid
	silver_knife
		name="Silver Knife"
		icon='halloween.dmi'
		icon_state="silver knife"
	Blessed_Torch
		icon='halloween.dmi'
		icon_state="torch"
	Holy_Grenade
		icon='halloween.dmi'
		icon_state="bomb"

obj
	ground_silver_knife
		name="Silver Knife"
		icon='halloween.dmi'
		icon_state="silver knife"
		verb
			Take()
				set src in oview(2)
				if(locate(/obj/Stupid/silver_knife) in usr.contents)
					usr << "<b>You already have a Silver Knife!</b>"
				else if(locate(/obj/items/wearable/halloween_bucket) in usr.contents)
					usr << errormsg("You've already completed this quest!")
				else
					hearers() << "<b>[usr] picks up the Silver Knife.</b>"
					new/obj/Stupid/silver_knife(usr)
					usr:Resort_Stacking_Inv()

obj
	ground_blessed_torch
		name="Blessed Torch"
		icon='halloween.dmi'
		icon_state="torch"
		verb
			Take()
				set src in oview(2)
				if(locate(/obj/Stupid/Blessed_Torch) in usr.contents)
					usr << "<b>You already have a Blessed Torch!</b>"
				else if(locate(/obj/items/wearable/halloween_bucket) in usr.contents)
					usr << errormsg("You've already completed this quest!")
				else
					hearers() << "<b>[usr] picks up the Blessed Torch.</b>"
					new/obj/Stupid/Blessed_Torch(usr)
					usr:Resort_Stacking_Inv()

obj
	ground_holy_grenade
		name="Holy Grenade"
		icon='halloween.dmi'
		icon_state="bomb"
		verb
			Take()
				set src in oview(2)
				if(locate(/obj/Stupid/Holy_Grenade) in usr.contents)
					usr << "<b>You already have a Holy Grenade!</b>"
				else if(locate(/obj/items/wearable/halloween_bucket) in usr.contents)
					usr << errormsg("You've already completed this quest!")
				else
					hearers() << "<b>[usr] picks up the Holy Grenade.</b>"
					new/obj/Stupid/Holy_Grenade(usr)
					usr:Resort_Stacking_Inv()

mob/TalkNPC
	Zombie
		NPC=1
		bumpable=0
		Immortal=1
		icon='MaleZombie.dmi'
		icon_state=""
		Gm=1

		Talk()
			set src in oview(3)
			if(usr.talkedzombie==2)
				usr << npcsay("<font color = red<b>Brian The Undead </font></b>: Thanks for helping! Those innocent people will be slain soon!")
			else
				if(usr.talkedzombie==1)
					usr << npcsay("<font color = red<b>Brian The Undead </font></b>: Did you find everything!?")
					if(locate(/obj/Stupid/silver_knife) in usr.contents)
						if(locate(/obj/Stupid/Blessed_Torch) in usr.contents)
							if(locate(/obj/Stupid/Holy_Grenade) in usr.contents)
								for(var/obj/O in usr.contents)
									if(istype(O,/obj/Stupid))
										del(O)
								usr << npcsay("<font color = red<b>Brian The Undead </font></b>: You got everything! You've done enough, leave the rest to me. Thanks!")
								usr << npcsay("<font color = red<b>Brian The Undead </font></b>: Here is your reward.")
								new/obj/items/wearable/halloween_bucket(usr)
								usr:Resort_Stacking_Inv()
								usr.talkedzombie=2
							else
								usr << npcsay("You don't have the Holy Grenade!")
						else
							usr << npcsay("You don't have the Blessed Torch!")
					else
						usr << npcsay("You don't have the Silver Knife!")
				else
					usr << npcsay("<font color = red<b>Brian The Undead </font></b>: Hello. In a fit of rage I believe I have gone and infected 7 people last night with this curse I currently have bestowed upon me. If something is not done about this, you will be looking at a rather large problem.")
					switch(input("Your response?","Make a selection")in list("Why do you want to kill other zombies?","What can I do to help?"))
						if("Why do you want to kill other zombies?")
							usr << npcsay("<font color = red<b>Brian The Undead </font></b>: Simple! I don't like competition, I'm a lazy zombie.")
							switch(input("Your response?","Make a selection")in list("What can I do to help?"))
								if("What can I do to help?")
									usr << npcsay("<font color = red<b>Brian The Undead </font></b>: There are other Zombie killers in the area, you'll need their tools. One in Diagon Alley, one in Hogwarts, and one in Hogsmeade. You will be looking for a silver knife, blessed torch, and a holy grenade. Hurry and return when you've found what we need!")
									usr.talkedzombie=1
						if("What can I do to help?")
							usr << npcsay("<font color = red<b>Brian The Undead </font></b>: There are other Zombie killers in the area, you'll need their tools. One in Diagon Alley, one in Hogwarts, and one in Hogsmeade. You will be looking for a silver knife, blessed torch, and a holy grenade. Hurry and return when you've found what we need!")
							usr.talkedzombie=1
		New()
			..()
			wander()
		proc/wander()

			while(src)
				walk_rand(src,rand(5,30))
				sleep(5)