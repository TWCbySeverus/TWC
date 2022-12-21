#define WORN 1
#define REMOVED 2

obj/items/wearable/wands
	Equip(var/mob/Player/owner,var/overridetext=0,var/forceremove=0)
		. = ..(owner)
		if(forceremove)return 0
		if(. == WORN)
			src.gender = owner.gender
			if(!overridetext)viewers(owner) << infomsg("[owner] draws \his [src.name].")
			for(var/obj/items/wearable/wands/W in owner.Lwearing)
				if(W != src)
					W.Equip(owner,1,1)
		else if(. == REMOVED)
			if(!overridetext)viewers(owner) << infomsg("[owner] puts \his [src.name] away.")
obj/items/wearable/wands/cedar_wand //Thanksgiving
	icon = 'cedar_wand.dmi'
	dropable = 0
	verb/Delicio_Maxima()
		set category = "Spells"
		if(src in usr:Lwearing)
			if(canUse(usr,cooldown=/StatusEffect/UsedTransfiguration,needwand=1,inarena=0,insafezone=1,inhogwarts=1,target=null,mpreq=0,againstocclumens=1,againstflying=0,againstcloaked=0))
				new /StatusEffect/UsedTransfiguration(usr,30)
				hearers()<<"<b><font color=red>[usr]</font>:<b><font color=white> Delicio Maxima.</b></font>"
				sleep(20)
				for(var/mob/Player/M in ohearers(usr.client.view,usr))
					if(M.flying) continue
					if((locate(/obj/items/wearable/invisibility_cloak) in M.Lwearing)) continue
					if(prob(20)) continue
					if(usr.CanTrans(M))
						flick("transfigure.dmi",M)
						M.overlays = null
						M.trnsed = 1
						if(M.away) M.ApplyAFKOverlay()
						M.icon = 'Turkey.dmi'
						M<<"<b><font color=#D6952B>Delicio Charm:</b></font> [usr] turned you into some Thanksgiving awesome-ness."
					sleep(1)
		else
			usr << errormsg("You need to be using this wand to cast this.")
obj/items/wearable/wands/maple_wand //Easter
	icon = 'maple_wand.dmi'
	dropable = 0
	verb/Carrotosi_Maxima()
		set category = "Spells"
		if(src in usr:Lwearing)
			if(canUse(usr,cooldown=/StatusEffect/UsedTransfiguration,needwand=1,inarena=0,insafezone=1,inhogwarts=1,target=null,mpreq=0,againstocclumens=1,againstflying=0,againstcloaked=0))
				new /StatusEffect/UsedTransfiguration(usr,30)
				hearers()<<"<b><font color=red>[usr]</font>:<b><font color=white> Carrotosi Maxima.</b></font>"
				sleep(20)
				for(var/mob/Player/M in ohearers(usr.client.view,usr))
					if(M.flying) continue
					if((locate(/obj/items/wearable/invisibility_cloak) in M.Lwearing)) continue
					if(prob(20)) continue
					if(usr.CanTrans(M))
						flick("transfigure.dmi",M)
						M.overlays = null
						M.trnsed = 1
						if(M.away) M.ApplyAFKOverlay()
						M.icon = 'PinkRabbit.dmi'
						M<<"<b><font color=red>Carrotosi Charm:</b></font> [usr] turned you into a Rabbit."
					sleep(1)
		else
			usr << errormsg("You need to be using this wand to cast this.")

obj/items/wearable/wands/sonic_wand
	dropable = 0
	icon = 'sonic_wand.dmi'

	verb/Sound_Wave()
		set category = "Spells"
		if(src in usr:Lwearing)
			if(!usr.loc || usr.loc.loc:disableEffects)
				usr << errormsg("You can't use this here.")
				return
			if(canUse(usr,cooldown=/StatusEffect/UsedSonic,needwand=1,inarena=1,insafezone=1,inhogwarts=1,target=null,mpreq=0,againstocclumens=1,againstflying=0,againstcloaked=0))
				new /StatusEffect/UsedSonic(usr, 30)
				spawn()
					light(usr, 0, 10, "teal")
					sleep(3)
					light(usr, 1, 12, "blue")
					sleep(3)
					light(usr, 2, 15, "purple")
				for(var/obj/Hogwarts_Door/d in oview(2))
					if(prob(20) || d.pass) continue
					usr.Bump(d)
					sleep(1)

		else
			usr << errormsg("You need to be using this wand to cast this.")

area/var/disableEffects = FALSE

obj/items/wearable/wands/interruption_wand //Fred's quest
	icon = 'interruption_wand.dmi'
obj/items/wearable/wands/salamander_wand //Bag of goodies
	icon = 'salamander_wand.dmi'
obj/items/wearable/wands/mithril_wand //GM wand
	icon = 'mithril_wand.dmi'
obj/items/wearable/wands/mulberry_wand //GM wand
	icon = 'mulberry_wand.dmi'
obj/items/wearable/wands/royale_wand //Royal event reward?
	icon = 'royale_wand.dmi'
obj/items/wearable/wands/pimp_cane //Sylar's wand thing
	icon = 'pimpcane_wand.dmi'

obj/items/wearable/wands/birch_wand
	icon = 'birch_wand.dmi'
obj/items/wearable/wands/oak_wand
	icon = 'oak_wand.dmi'
obj/items/wearable/wands/mahogany_wand
	icon = 'mahogany_wand.dmi'
obj/items/wearable/wands/elder_wand
	icon = 'elder_wand.dmi'
obj/items/wearable/wands/willow_wand
	icon = 'willow_wand.dmi'
obj/items/wearable/wands/ash_wand
	icon = 'ash_wand.dmi'
obj/items/wearable/wands/duel_wand
	icon = 'wand_dueling.dmi'

