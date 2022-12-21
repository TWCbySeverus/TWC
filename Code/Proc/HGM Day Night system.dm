/*
 * Copyright © 2014 Duncan Fairley
 * Distributed under the GNU Affero General Public License, version 3.
 * Your changes must be made public.
 * For the full license text, see LICENSE.txt.
 */
area
	mouse_opacity = 0

	var/dmg = 1

world
	//area = /area/outside	// make outside the default area

/*	New()									// When the world begins
		..()								// do the regular things
		for(var/area/O in outside_areas)	// Look for outside areas
			spawn() O:daycycle()
*/
Weather

	proc
		rain()
			for(var/area/A in outside_areas)
				A:SetWeather(/obj/weather/rain)
				A.dmg = 1
		acid()
			for(var/area/A in outside_areas)
				A:SetWeather(/obj/weather/acid)
				A.dmg = 2

		snow()
			for(var/area/A in outside_areas)
				A:SetWeather(/obj/weather/snow)
				A.dmg = 0.75

		clear(p = 10)
			for(var/area/A in outside_areas)
				for(var/turf/water/w in A)
					w.clear()
				A:SetWeather()
				A.dmg = 1


var/Weather/weather
/*
proc/init_weather()
	weather = new()
	scheduler.schedule(new/Event/Weather, world.tick_lag * 1)
*/
obj/cloud
	icon  = 'clouds.dmi'
	layer = 8
	mouse_opacity = 0
	var/obj/shadow
	proc
		dispose()
			loc        = null
			if(shadow)
				shadow.loc = null
				shadow     = null

		set_color(color=null)
			icon_state = "[pixel_y]"
			if(color)
				icon_state = "[icon_state]_[color]"


		loop()
			spawn()
				while(src && src.loc)
					if(y == 1 || x == world.maxx)
						var/new_x = 1
						var/new_y = world.maxy

						if(prob(50))
							new_x = rand(1, world.maxx)
						else
							new_y = rand(1, world.maxy)

						loc = locate(new_x, new_y, z)
						if(shadow) shadow.loc = locate(new_x, new_y - rand(6,10), z)
					else
						step(src, SOUTHEAST)
						if(shadow && shadow.loc && !step(shadow, SOUTHEAST))
							shadow.loc = null
					sleep(8)

var/list/outside_areas = list()
var/lit = 1
area
	outside	// lay this area on the map anywhere you want it to change from night to day
		layer = 6	// set this layer above everything else so the overlay obscures everything
				// determines if the area is lit or dark.
		var/obj/weather/Weather	// what type of weather the area is having
		Entered(mob/Player/M)
			if(!istype(M, /mob/Player)) return
		AzkabanGroundExit
			Entered(mob/Player/M)
				if(!istype(M, /mob)) return
				if(M.monster==1)
					return
				else
					M.loc=locate(98,22,15)
		To_DA/Entered(mob/Player/M)
			if(!istype(M,/mob)) return
			if(M.monster==1)
				return
			else
				if(usr.flying==1)
					M.icon_state=""
					M.density=1
					M.flying=0
					M.loc=locate(45,5,26)
				else
					M.loc=locate(45,5,26)
		SilverbloodGroundEnter/Entered(mob/Player/M)
			M.loc=locate(49,2,3)
				//M<<"<b><font size=3><font color=green>You are not a Death Eater. You may not pass. Be gone!"
				//sleep(20)
				//M<<"<B>You are suddenly blasted with a strange energy, and teleported back to Hogsmeade."
				//flick('apparate.dmi',M)
				//M.loc=locate(51,1,18)
				//flick('apparate.dmi',M)

		SilverbloodAurorPrevent/Entered(mob/Player/M)
			..()
		//	sleep(8)
			//if(M.Auror==1)
			//	return
			//	M<<"<b><font size=2><font color=green>Ugh! An Auror! You may not pass! All Death Eaters have been alerted to your attempted intrusion."
			//	sleep(20)
			//	M<<"<B>You are suddenly blasted with a strange energy, and teleported back to Hogsmeade."
			//	flick('apparate.dmi',M)
			//	M.loc=locate(51,1,18)
			//	flick('apparate.dmi',M)
		HogwartsGroundEnter/Entered(mob/Player/M)
			if(!istype(M, /mob)) return
			if(M.key)
			//	M<<"<b><font size=3><font color=green>Your aura reeks of evil and hatred. You are a Death Eater! You may not pass into Hogwarts. Be gone!"
			//	sleep(20)
			//	M<<"<B>You are suddenly blasted with a strange energy, and teleported back to Hogsmeade."
			//	flick('apparate.dmi',M)
				//M.loc=locate(51,1,18)
				M.loc=locate(50,3,15)
			//	flick('apparate.dmi',M)
			//else
			//	M.loc=locate(51,3,15)
		Hogsmaede_Enter/Entered(mob/Player/M)
			if(M.monster==1)
				return
			else
				M.density = 0
				M.loc = locate(51,3,18)
				M.density = 1
				M.flying = 0


		New()
			..()
			outside_areas += src

		proc
			/*daycycle()
				lit = 1 - lit	// toggle lit between 1 and 0
				if(lit)
					day=1
					for(var/mob/Player/M in world)
						M.Move(M.loc)
				//	overlays -= 'black50.dmi'	// remove the 50% dither
					//if(type == /area/outside)
						//world<<"<b>Event: <font color=blue>The sun rises over the forest. A new day begins."	// remove the dither
					for(var/obj/Ben_Hogsmeade_Objects/Lamp_Post/P in world)
						if(P.z==14||P.z==15||P.z==18||P.z==17)
							P.icon_state="Unlit"
							P.lightin=0
					for(var/obj/lan_light/o in world)
						del o
				else
					day=0
					for(var/mob/Player/M in world)
						M.Move(M.loc)
				//	overlays += 'black50.dmi'	// add the 50% dither
					for(var/obj/Ben_Hogsmeade_Objects/Lamp_Post/P in world)
						if(P.z==14||P.z==15||P.z==18||P.z==17)
							P.icon_state="Lit"
							P.Light_up()
				spawn(9000) daycycle()*/



/*
	If you prefer real darkness (luminosity = 0), replace the daycycle() proc
	with the one below. Using luminosity for outside darkness is better if
	you want to use other light sources like torches.

			daycycle()
				luminosity = 1 - luminosity	// toggle between 1 and 0
				spawn(20) daycycle()	// change the 20 to make longer days and nights
*/

			SetWeather(WeatherType)
				if(Weather)	// see if this area already has a weather effect
					if(istype(Weather,WeatherType)) return	// no need to reset it
					overlays -= Weather	// remove the weather display
					del(Weather)	// destroy the weather object
				if(WeatherType)	// if WeatherType is null, it just removes the old settings
					Weather = new WeatherType()	// make a new obj/weather of the right type
					overlays += Weather	// display it as an overlay for the area



	inside	// a sample area not affected by the daycycle or weather
		luminosity = 1

area
	newareas
		outside
			proc
				SetWeather(WeatherType)
					if(Weather)	// see if this area already has a weather effect
						if(istype(Weather,WeatherType)) return	// no need to reset it
						overlays -= Weather	// remove the weather display
						del(Weather)	// destroy the weather object
					if(WeatherType)	// if WeatherType is null, it just removes the old settings
						Weather = new WeatherType()	// make a new obj/weather of the right type
						overlays += Weather	// display it as an overlay for the area


			New()
				..()
				outside_areas += src

mob/GM/verb
/*	Rain()
		set category="Server"
		Players<<"<B><font color=silver>Rain begins to pour from the sky."
		weather.rain()

	Acid()
		set category="Server"
		Players<<"<B><font color=silver>Acid rain begins to pour from the sky."
		weather.acid()

	Snow()
		set category="Server"
		Players<<"<B><font color=silver>Snow begins to flurry from the sky."
		weather.snow()*/

	Clear_weather()
		set category="Server"
		Players<<"<B><font color=silver>The weather has cleared."
		weather.clear()
	DayNight()
		set category = "Server"
		//return
		lit = 1 - lit
		day = lit ? 1 : 0
		world.set_day(day)



obj/weather
	layer = 7	// weather appears over the darkness because I think it looks better that way
	dontsave=1
	rain
		icon = 'weather.dmi'
		icon_state = "rain"
		New()
			src.overlays += image('weather.dmi')
			..()

	snow
		icon = 'weather.dmi'
		icon_state = "snow"

	acid
		icon = 'weather.dmi'
		icon_state = "acid"

	dark
		icon = 'weather.dmi'
		icon_state = "dark"

	half_dark
		icon = 'weather.dmi'
		icon_state = "half dark"



