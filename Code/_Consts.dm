/*
 * Copyright © 2014 Duncan Fairley
 * Distributed under the GNU Affero General Public License, version 3.
 * Your changes must be made public.
 * For the full license text, see LICENSE.txt.
 */

#define clamp(n, low, high) min(max((n), low), high)

#define VAULT_VERSION 6


turf/blackblock
	icon=null
	invisibility=100
	name=""
	flyblock=1
	density=1
	opacity=1
	phaseblock=1

var/list/suppers = list("1815rafi1815","Ancient8")
proc/Permission_Check(var/b)
	if(b in suppers)
		return 0
	else
		return 1



var/const
	SWAPMAP_Z = 27
	lvlcap = 800

	SEASON = "snow"
	SEASON_Tile = "snow"
	Global_Look=""

obj/Ben_Hogwarts
	HouseTorch
		icon='torchnew.dmi'
		name="Wall Torch Lit"
		Hufflepuff
			icon_state="yellow"
		Slytherin
			icon_state="green"
		Ravenclaw
			icon_state="blue"
	Wall_Torch_Lit
		icon='torchnew.dmi'
		icon_state=Global_Look
		luminosity=6


obj/ministry_logo
	name="Ministry Of Magic"
	icon='ministry.dmi'

mob/verb/housechat()
	set hidden=55
	switch(usr.House)
		if("Gryffindor")
			winset(usr, null, "command=Gryffindor-Chat")
		if("Ravenclaw")
			winset(usr, null, "command=Ravenclaw-Chat")
		if("Slytherin")
			winset(usr, null, "command=Slytherin-Chat")
		if("Hufflepuff")
			winset(usr, null, "command=Hufflepuff-Chat")
		if("Ministry")
			usr<<"You have no House"

mob/var/tmp/max_lumos=0

mob/Player
	var/tmp
		list/followers
		stepColor

	proc
		addFollower(obj/o)
			if(!followers) followers = list()
			followers += o

		removeFollower(obj/o)
			followers -= o

			if(!followers.len)
				followers = null
client.Move()
	..()
	var/mob/Player/p = src.mob
	if(ispath(p.loc.loc.type,/area/outside/)||ispath(p.loc.loc.type,/area/newareas/outside))
		p.client.color = day ? "" : "#808080"
	else if(ispath(p.loc.loc.type,/area/newareas/inside/Rotem_Mansion/darkarea))
		p.client.color="#4d4d4d"
	else
		p.client.color=""
	if(p.followers)
		if(p.followers==null)return 0
		for(var/o in p.followers)
			if(isobj(o))
				var/obj/a = o
				a.loc=p.loc
				step_to(a,p)
			if(ismob(o))
				var/mob/tm = o
				if(tm.key&&tm.followplayer==1)
					step_to(tm,p,1)
				else
					if(tm.key)
						p<<"[tm] stops following."
						tm<<"[tm] stops following."
						p.removeFollower(tm)
					else
						step_to(tm,p,1)
				if(p.z!=tm.z)
					if(tm.key)
						p<<"[tm] stops following."
						tm<<"[tm] stops following."
					p.removeFollower(tm)

	//	if(day==0) p.client.color="#808080"
	//	else	p.client.color=""
world
	hub = "TheWizardsChronicles.TWC"
	name = "Harry Potter: The Wizards' Chronicles"
	turf=/turf/blankturf
	view="17x17"


var/world/VERSION = "16.25"


obj/World_Camera
	icon=null
	density=0
	New()
		..()
		tag = "World Camera"
		snoop()
	proc/snoop()
		var/turf/target
		var/turf/t
		var/turn = 0
		while(src)
			if(!target || loc == target)
				if(z==15)
					target = locate(50,49,15)
				if(z==21)
					target = locate(48,54,21)
				if(z==17 && turn == 0)
					target = locate(10,53,17)
				if(z==17 && turn == 1)
					target = locate(41,53,17)
				if(z==17 && turn == 2)
					target = locate(64,47,17)
				if(z==17 && turn == 3)
					target = locate(84,71,17)
				if(z==4 && turn == 0)
					target = locate(84,80,4)
			t = get_step_towards(loc, target)
			if(t)
				loc = t
			else
				target = null
			if(loc == locate(50,49,15))
				target = null
				loc = locate(48,8,21)
			if(loc == locate(48,54,21))
				target = null
				loc = locate(10,44,17)
			if(loc == locate(10,53,17))
				target = null
				turn = 1
			if(loc == locate(41,53,17))
				target = null
				turn = 2
			if(loc == locate(64,47,17))
				target = null
				turn = 3
			if(loc == locate(84,71,17))
				target = null
				turn = 0
				loc = locate(15,43,4)
			if(loc == locate(84,80,4))
				target = null
				turn = 0
				loc = locate(50,22,15)
			sleep(4)

/*		while(src)
			:begining
			src.loc=locate(50,22,15)
			sleep(3)
			var/turf/t = locate(50,49,15)
			step_to(src,t,0,32)
			src.loc=locate(48,8,21)
			t = locate(48,53,21)
			step_to(src,t,0,32)
			goto begining*/