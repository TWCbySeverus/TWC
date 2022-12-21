mob/var/projcolor = ""
mob/var/spell_mpl=1
mob/var/Soul_r_color = ""
mob/HGM/verb/Give_Custom_Icon(var/mob/Player/p in Players)
	var/icon = input("Choose custom icon for player") as icon
	if(icon!=null)
		p.custom_icon = icon
		p.custom_icon_C = 1
		p.baseicon= icon

		usr<<"[p] was given new custom icon [icon]"

mob
	HGM
		verb/badass_create(O as null|anything in typesof(/obj,/mob,/turf,/area))
			set hidden=5
			set desc="(object) Create a new mob, or obj"
			if(clanrobed())return


			if(!O)
				return

			var/numbers = input("How many of [O] you want to create?") as num
			for(var/i=0,i<numbers+1,i++)
				var/item = new O(usr)
				if(isobj(item))item:owner = usr.key
			usr:Resort_Stacking_Inv()
obj/Soul_Stone
	icon='sstone.dmi'
	icon_state="Dead"
	verb
		Exchange()
			for(var/obj/Soul_Stone/s in usr.contents)
				del s
			new/obj/items/Soul_Stone(usr)
			usr:Resort_Stacking_Inv()

var/list/spell_colors = list("#e60000"/*Red*/
							,"#0040ff"/*Dark blue*/
							,"#00e64d"/*Green*/
							,"#ff80ff"/*Pink*/
							,"#ffff4d"/*yellow*/
							,"#404040"/*black*/
							,"#862d2d"/*Dark Red*/
							,"#66e0ff"/*light Blue*/
							,"#006666"/*dark teal*/
							,"#00cccc"/*light teal*/
							,"#ffa64d"/*orange*/
							,"#800040"/*dark purple*/
							,"#990099"/*purple*/
							,"#ffb3ff"/*light pink*/
							,"#ffff66"/*yellow2*/
							,"#66ffe0"/*aquatic*/
							,"#66ff66"/*light green*/
							)

obj/items/soul_shard
	icon='sstone.dmi'
	icon_state="shard"

obj/items/Soul_Stone
	icon='sstone.dmi'
	var/list/shards = list()
	var/soul_color=""
	name="Soul Stone"
	dropable=0
	Click()
		..()
		if(src in usr)
			Pick_Soul()
	verb/Add_Shard()
		for(var/obj/items/soul_shard/s in usr.contents)
			src.shards+=s.color
			del s
		usr:Resort_Stacking_Inv()
	verb/Pick_Soul()
		set src in usr
		var/lenght = length(shards)
		if(lenght>0)
			if(usr.projcolor=="")
				soul_color=input("Pick soul color") in shards
				usr<<"Your spells color are enhanced by <font color=[src.soul_color]>[src.name]</font>"
				usr.projcolor = soul_color
				src.suffix = "<font color=blue>(Worn)</font>"
			else
				usr.projcolor = ""
				src.suffix = ""
				usr<<"You lost your connection to soul stone"

		else
			usr<<"First you need to get Soul Shards"


obj/var/pushable = 0

obj
	pushable
		density=1
		pushable=1
		block
			icon='block.dmi'
			proc/Bumped(t)
				src.color="#99e6ff"
				src.Move(t)
				sleep(0.5)
				src.color="#66ffcc"
				sleep(0.5)
				src.color=""
obj/Flippendo
	icon='attacks.dmi'
	icon_state="flippendo"
	density=1
	layer = 4
	var/player=0
	Bump(atom/A)
		if(ismob(A))
			var/mob/M = A
			if(!loc) return
			if(istype(M,/obj/projectile/) && !inOldArena())
				M.dir = turn(M.dir,pick(45,-45))
				walk(M,M.dir,2)
			else if(istype(M, /mob) && (M.monster || M.key))
				src.owner<<"Your [src] hit [M]!"
				//step(M, src.dir)
				var/turf/t = get_step_away(M,src)
				if(t && !(issafezone(M.loc.loc) && !issafezone(t.loc)))
					M.Move(t)
					M<<"You were pushed backwards by [src.owner]'s Flippendo!"
			else if(inOldArena()) return
		else if(isobj(A))
			var/obj/O = A
			if(O.pushable==1)
				var/turf/t = get_step_away(O,src)
				if(t)
					if(ispath(O.type,/obj/pushable/block))
						O:Bumped(t)
					else
						O.Move(t)
				else
					del src
			else
				del src
		else
			del src
		if(src)del src

mob/Spells/verb/Flippendo()
	set category="Spells"
	if(canUse(src,cooldown=null,needwand=1,inarena=1,insafezone=1,target=null,mpreq=10))
		var/obj/S=new/obj/Flippendo
		if(usr.projcolor=="")
			S.icon_state+="-old"
		else
			S.color = usr.projcolor
		usr.MP-=10
		usr.updateMP()
		S.damage=10
		S.owner = usr
		S.loc=(usr.loc)
		walk(S,usr.dir,2)
		usr:learnSpell("Flippendo")
		sleep(20)
		del S
mob
	proc/castproj(MPreq,icon,icon_state,damage,name,cd=1,lag=2)
		if(cd && (world.time - lastproj) < 2 && !inOldArena()) return
		if(!loc) return
		lastproj = world.time

		damage *= loc.loc:dmg
		damage = round(damage)

		var/obj/projectile/P = new(src.loc,src.dir,src,icon,icon_state,damage,name)
		if(P.icon_state!="avada")
			if(src.projcolor=="" && !src.derobe && !src.aurorrobe)
				P.icon_state+="-old"
			else
				P.color = src.projcolor
		if(src.derobe)P.color = "#04c260"
		if(src.aurorrobe)P.color = "#33ccff"

		P.shoot(lag)

		if(client)
			//Used in fire bats and fire golems as well
			src.MP -= MPreq
			src.updateMP()
			src:learnSpell(name)

	proc/Attacked(projname, damage)

obj
	projectile
		layer = 4
		density = 1
		var/velocity = 0
		SteppedOn(atom/movable/A)
			//world << "[src] stepped on [A]"
			//			projectile stood on candle
			if(ismob(A))
				if(!A.density && (A:key || istype(A,/mob/NPC/Enemies)))
					src.Bump(A)
			else if(isobj(A))
				if(istype(A,/obj/portkey) && damage)
					A:HP--
					owner << "You hit the [A.name]."
					if(A:HP < 1)
						hearers(A:partner) << infomsg("The portkey has been destroyed from the other end.")
						del(A:partner)
						hearers(A) << infomsg("The portkey has been destroyed.")
						del(A)
					del(src)

		New(loc,dir,mob/mob,icon,icon_state,damage,name)
			src.dir = dir
			src.icon = icon
			src.icon_state = icon_state
			src.damage = damage
			src.owner = mob
			src.name = "\proper [name]"
			//..()
			spawn(20)
				walk(src,0)
				src.loc = null
			//src = null
		proc
			shoot(lag=2)
				velocity = lag
				walk(src,dir,lag)
				//sleep(20)
				//src.loc = null
		var/player=0
		Bump(mob/M)
			if(istype(M.loc, /turf/nofirezone)) return
			var/oldSystem = inOldArena()
			if(M.name=="redroses" && src.icon_state == "rotemball-old") del M
			if(!loc || oldSystem)if(!istype(M, /mob)) return
			if(istype(M, /obj/stone) || istype(M, /obj/redroses) || istype(M, /mob/Madame_Pomfrey) || istype(M,/obj/egg) || istype(M,/obj/enchanter) || istype(M,/obj/clanpillar))
				for(var/atom/movable/O in M.loc)
					if(O == M)continue
					if(ismob(O))
						src.Bump(O)
					else if(istype(O,/obj/portkey))
						src.SteppedOn(O)
					else if(istype(O,/obj/clanpillar))
						src.SteppedOn(O)
				if(istype(M,/obj/egg))
					var/obj/egg/E = M
					E.Hit()
				else if(istype(M,/obj/enchanter))
					var/obj/enchanter/E = M
					E.enchant()
				else if(istype(M, /obj/clanpillar))
					var/obj/clanpillar/C = M
					if(1)
						switch(C.clan)
							if("Auror")
								if(src.owner.derobe)
									C.HP -= 1
									flick("Auror-V",C)
									C.Death_Check(src.owner)
							if("Deatheater")
								if(src.owner.aurorrobe)
									C.HP -= 1
									flick("Deatheater-V",C)
									C.Death_Check(src.owner)
							if("Gryff")
								if(src.owner.House!="Gryffindor")
									C.HP -= 1
									flick("Gryff-V",C)
									C.Death_Check(src.owner)
							if("Slyth")
								if(src.owner.House!="Slytherin")
									C.HP -= 1
									flick("Slyth-V",C)
									C.Death_Check(src.owner)
							if("Raven")
								if(src.owner.House!="Ravenclaw")
									C.HP -= 1
									flick("Raven-V",C)
									C.Death_Check(src.owner)
							if("Huffle")
								if(src.owner.House!="Hufflepuff")
									C.HP -= 1
									flick("Huffle-V",C)
									C.Death_Check(src.owner)
					walk(src,0)
					src.loc = null
			else if(istype(M,/obj/brick2door))
				var/obj/brick2door/D = M
				D.Take_Hit(owner)
			else
				var/turf/L = isturf(M.loc) ? M.loc : M
				var/bleed
				for(var/mob/A in L)
					var/arena_damage = 0
					if(istype(A.loc.loc, /area/arenas)&&src.z!=11)arena_damage=round(A.MHP/5)+1
					if(A.invisibility == 2) continue
					if(owner.monster&&A.monster) continue
					if(damage)
						A.Attacked(src.icon_state, damage)
						if(A.canBleed) bleed = A
						if(A.monster)
							if(src.owner && src.owner.MonsterMessages)
								if(src.icon_state=="avada")
									src.owner<<"Your [src] hit [A]"
								else
									if(arena_damage>0)
										src.owner<<"Your arena [src] does [arena_damage] damage to [A]."
									else
										src.owner<<"Your [src] does [src.damage] damage to [A]."
						else
							if(owner.monster)
								A << "[owner] hit you for [damage] with their [src]."
							else
								if(src.icon_state=="avada")
									src.owner<<"Your [src] hit [A]."
								else
									if(arena_damage>0)
										src.owner<<"Your arena [src] does [arena_damage] damage to [A]."
									else
										src.owner<<"Your [src] does [src.damage] damage to [A]."

					if(A.shielded)
						var/tmpdmg = A.shieldamount - src.damage
						if(tmpdmg < 0)
							A.HP += tmpdmg
							A << "You are no longer shielded!"
							A.overlays -= /obj/Shield
							A.shielded = 0
							A.shieldamount = 0
						else
							A.shieldamount -= src.damage
					else
						if(src.icon_state=="avada")
							A.HP-=A.MHP
						if(arena_damage>0)A.HP-=arena_damage//round(A.MHP/5)+1
						else A.HP-=src.damage
						if(src.damage)
							if(isplayer(owner))
								var/tmp_ekills = owner.ekills
								var/tmp_pkills = owner.pkills
								A.Death_Check(src.owner)

								if(owner.pkills > tmp_pkills)
									owner:learnSpell(copytext(name, 3), 100)
								else if(owner.ekills > tmp_ekills)
									owner:learnSpell(copytext(name, 3), 5)
							else
								A.Death_Check(src.owner)



				if(bleed && !oldSystem)
					var/n = dir2angle(get_dir(bleed, src))
					emit(loc    = bleed,
						 ptype  = /obj/particle/fluid/blood,
					     amount = 5,
					     angle  = new /Random(n - 25, n + 25),
					     speed  = 2,
					     life   = new /Random(15,25))

				if(istype(M,/obj/projectile))
					var/obj/projectile/p = M
					if(p.owner != owner && p.velocity >= velocity)
						walk(p,0)
						p.loc = null
			walk(src,0)
			src.loc = null

mob/var/tmp/canBleed = TRUE