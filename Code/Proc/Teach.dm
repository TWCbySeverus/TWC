/*
 * Copyright � 2014 Duncan Fairley
 * Distributed under the GNU Affero General Public License, version 3.
 * Your changes must be made public.
 * For the full license text, see LICENSE.txt.
 */
mob/var/spellpoints = 0 //Earn 5, and you get to choose a spell
var/spellpointlog = file("Logs/spellpointlog.txt")
mob/proc/learnspell(path)
	if(path in verbs)
		var/StatusEffect/S = findStatusEffect(/StatusEffect/GotSpellpoint)
		if(!S)
			new/StatusEffect/GotSpellpoint(src,60) //A silent marker to prevent people from gaining multiple spell points accidently.
			spellpoints++
			src << "<b>You earnt a spell point! When you've gained at least 5, you can learn a spell with the Use Spellpoints button in Commands.</b>"
			//src << "<i>As you've learned this spell previously, you've earnt a spellpoint instead. Each time you earn 5 spellpoints, you can learn a spell of your choice.</i>"
			spellpointlog << "[time2text(world.realtime,"MMM DD - hh:mm")]: [src] earnt a spell point."
		return 0
	else
		verbs += path
		return 1

mob/GM
	verb
		Teach_Furnunculus()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Furnunculus))
				//if(M.learnspell(/mob/Mage/verb/Furnunculus
					M<<"<b><font color=green>You learned Furnunculus!"
			src<<"You've taught your class the Furnunculus spell."

mob/GM
	verb
		Teach_Langlock()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Langlock))
					M<<"<b><font color=green>You learned Langlock!"
			src<<"You've taught your class the Langlock spell."

mob/GM
	verb
		Teach_Muffliato()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Muffliato))
					M<<"<b><font color=green>You learned Muffliato!"
			src<<"You've taught your class the Muffliato spell."

mob/GM
	verb
		Teach_Flagrate()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Flagrate))
					M<<"<b><font color=green>You learned Flagrate!"
			src<<"You've taught your class the Flagrate spell."


mob/GM
	verb
		Teach_Incindia()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Incindia))
					M<<"<b><font color=green>You learned Incindia!"
			src<<"You've taught your class the Incindia spell."
mob/GM
	verb
		Teach_Replacio()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Replacio))
					M<<"<b><font color=green>You learned Replacio!"
			src<<"You've taught your class the Replacio spell."


mob/GM
	verb
		Teach_Levicorpus()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Levicorpus))
					M<<"<b><font color=green>You learned Levicorpus!"
			src<<"You've taught your class the Levicorpus spell."

mob/GM
	verb
		Teach_Obliviate()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Obliviate))
					M<<"<b><font color=green>You learned Obliviate!"
			src<<"You've taught your class the Obliviate spell."

		Teach_Occlumency()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Occlumency))
					M<<"<b><font color=green>You learned Occlumency!"
			src<<"You've taught your class the Occlumency spell."

		Teach_Antifigura()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Antifigura))
					M<<"<b><font color=green>You learned Antifigura!"
			src<<"You've taught your class the Antifigura spell."

mob/var/learnedslug

mob/GM
	verb
		Teach_Deletrius()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Deletrius))
					M<<"<b><font color=green>You learned Deletrius!"
			src<<"You've taught your class the Deletrius spell."


mob/GM
	verb
		Teach_Eat_Slugs()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Eat_Slugs))
					M<<"<b><font color=green>You learned the Slug Vomiting Curse!"
			usr<<"You've taught your class the Eat Slugs spell."

mob/GM
	verb
		Teach_Immobulus()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Immobulus))
					M<<"<b><font color=green>You learned Immobulus!"
			src<<"You've taught your class the Immobulus spell."

mob/GM
	verb
		Teach_Impedimenta()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Impedimenta))
					M<<"<b><font color=green>You learned Impedimenta!"
			src<<"You've taught your class the Impedimenta spell."
mob/GM
	verb
		Teach_Tarantallegra()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Tarantallegra))
					M<<"<b><font color=green>You learned Tarantallegra."
			src<<"You've taught your class the Tarantallegra spell."


mob/GM
	verb
		Teach_Flippendo()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Flippendo))
					M<<"<b><font color=green>You learned Flippendo!"
			src<<"You've taught your class the Flippendo spell."

mob/GM
	verb
		Teach_Reducto()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Reducto))
					M<<"<b><font color=green>You learned Reducto!"
			src<<"You've taught your class the Reducto spell."

mob/GM
	verb
		Teach_Anapneo()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Anapneo))
					M<<"<b><font color=green>You learned Anapneo!"
			src<<"You've taught your class the Anapneo spell."
mob/GM
	verb
		Teach_Arcesso()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Arcesso))
					M<<"<b><font color=green>You learned Arcesso!"
			src<<"You've taught your class the Arcesso Summoning spell."

mob/GM
	verb
		Teach_Anteoculatia()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Anteoculatia))
					M<<"<b><font color=green>You learned Anteoculatia!"
			src<<"You've taught your class the Anteoculatia spell."

mob/GM
	verb
		Teach_Crucio()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Crucio))
					M<<"<b><font color=green>You learned Crucio!"
			src<<"You've taught your class the Crucio spell."

mob/GM
	verb
		Teach_Lumos()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Lumos))
					M<<"<b><font color=green>You learned Lumos!"
			src<<"You've taught your class the Lumos spell."

mob/GM
	verb
		Teach_Alohomora()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Alohomora))
					M<<"<b><font color=green>You learned Alohomora!"
			src<<"You've taught your class the Alohomora spell."

mob/GM
	verb
		Teach_Colloportus()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Colloportus))
					M<<"<b><font color=green>You learned Colloportus!"
			src<<"You've taught your class the Colloportus spell."

mob/GM
	verb
		Teach_Lumos_Maxima()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Lumos_Maxima))
					M<<"<b><font color=green>You learned Lumos Maxima!"
			src<<"You've taught your class the Lumos Maxima spell."

mob/GM
	verb
		Teach_Nox()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Nox))
					M<<"<b><font color=green>You learned Nox"
			src<<"You've taught your class the Nox spell."

mob/GM
	verb
		Teach_Arania_Eximae()
			set category = "Teach"
			set hidden = 1
			set name = "Teach Arania Exumai"
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Arania_Eximae))
					M<<"<b><font color=green>You learned Arania Exumai."
			src<<"You've taught your class the Arania Exumai spell."
mob/GM
	verb
		Teach_Glacius()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Glacius))
					M<<"<b><font color=green>You learned Glacius."
			src<<"You've taught your class the Glacius spell."
		/*Teach_Cugeo()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Cugeo))
					M<<"<b><font color=red><font size=3>You learned Cugeo."
			src<<"You've taught your class the cugeo spell."*/
		Teach_Reddikulus()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Reddikulus))
					M<<"<b><font color=green>You learned Riddikulus."
			src<<"You've taught your class the Riddikulus spell."

		Teach_Rictusempra()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Rictusempra))
					M<<"<b><font color=green>You learned Rictusempra."
			src<<"You've taught your class the Rictusempra spell."
		Teach_Sense()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Sense))
					M<<"<b><font color=green>You learned the skill Sense."
			src<<"You've taught your class the Sense skill."

		Teach_Scan()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Scan))
					M<<"<b><font color=green>You learned the skill Scan."
			src<<"You've taught your class the Scan skill."

mob/GM
	verb
		Teach_Expelliarmus()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Expelliarmus))
					M<<"<b><font color=green>You learned Expelliarmus."
			src<<"You've taught your class the Expelliarmus spell."

mob/GM
	verb
		Teach_Melofors()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Melofors))
					M<<"<b><font color=green>You learned Melofors."
			src<<"You've taught your class the Melofors spell."

mob/GM
	verb
		Teach_Reparo()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Reparo))
					M<<"<b><font color=green>You learned Reparo."
			src<<"You've taught your class the Reparo spell."
mob/GM
	verb
		Teach_Wingardium()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Wingardium_Leviosa))
					M<<"<b><font color=green>You learned Wingardium Leviosa."
			src<<"You've taught your class Wingardium Leviosa spell."
mob/GM
	verb
		Teach_Confundus()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Confundus))
					M<<"<b><font color=green>You learned Confundus."
			src<<"You've taught your class the Confundus spell."

mob/GM
	verb
		Teach_Bombarda()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Bombarda))
					M<<"<b><font color=green>You learned Bombarda."
			src<<"You've taught your class the Bombarda spell."
mob/GM
	verb
		Teach_Chaotica()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Chaotica))
					M<<"<b><font color=green>You learned Chaotica."
			src<<"You've taught your class the Chaotica spell."


mob/GM
	verb
		Teach_Episky()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Episky))
					M<<"<b><font color=green>You learned Episkey."
			src<<"You've taught your class the Episkey spell."

mob/GM
	verb
		Teach_Protego()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Protego))
					M<<"<b><font color=green>You learned Protego!"
			src<<"You've taught your class the Protego spell."

		Teach_Incendio()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Incendio))
					M<<"<b><font color=green>You learned Incendio!"
			src<<"You've taught your class the Incendio spell."

mob/GM
	verb
		Teach_Inflamari()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Inflamari))
					M<<"<b><font color=green>You learned Inflamari!"
			src<<"You've taught your class the Inflamari spell."
mob/GM
	verb
		Teach_Serpensortia()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Serpensortia))
					M<<"<b><font color=green>You learned Serpensortia!"
			src<<"You've taught your class the Serpensortia spell."
mob/GM
	verb
		Teach_Repellium()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Repellium))
					M<<"<b><font color=green>You learned Repellium!"
			src<<"You've taught your class the Repellium spell."
mob/GM
	verb
		Teach_Tremorio()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Tremorio))
					M<<"<b><font color=green>You learned Tremorio!"
			src<<"You've taught your class the Tremorio spell."
mob/GM
	verb
		Teach_Aqua_Eructo()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Aqua_Eructo))
					M<<"<b><font color=green>You learned Aqua Eructo!"
			src<<"You've taught your class the Aqua Eructo spell."
mob/GM
	verb
		Teach_Imitatus()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Imitatus))
					M<<"<b><font color=green>You learned Imitatus!"
			src<<"You've taught your class the Imitatus spell."
mob/GM
	verb
		Teach_Depulso()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Depulso))
					M<<"<b><font color=green>You learned Depulso!"
			src<<"You've taught your class the Depulso spell."

mob/GM
	verb
		Teach_Eparo_Evanesca()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Eparo_Evanesca))
					M<<"<b><font color=green>You learned Eparo Evanesca!"
			src<<"You've taught your class the Eparo Evanesca spell."

mob/GM
	verb
		Teach_Evanesco()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Evanesco))
					M<<"<b><font color=green>You learned Evanesco!"
			src<<"You've taught your class the Evanesco spell."
mob/GM
	verb
		Teach_Transfigure_Turkey()
			set category = "Teach"
			set hidden = 1
			set name = "Teach Delicio"
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Delicio))
					M<<"<b><font color=green>You learned how to transfigure someone into a Turkey!"
			src<<"You've taught your class the Delicio spell."

		Teach_Transfigure_Crow()
			set category = "Teach"
			set hidden = 1
			set name = "Teach Avifors"
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Avifors))
					M<<"<b><font color=green>You learned how to transfigure someone else into a Crow!"
			src<<"You've taught your class the Avifors spell."
mob/GM
	verb
		Teach_Transfigure_Mushroom()
			set category = "Teach"
			set hidden = 1
			set name = "Teach Personio Mushashi"
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Self_To_Mushroom))
					M<<"<b><font color=green>You learned how to transfigure yourself into a Mushroom!"
			src<<"You've taught your class Personio Musashi spell."
mob/GM
	verb
		Teach_Transfigure_Frog()
			set category = "Teach"
			set hidden = 1
			set name = "Teach Ribbitous"
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Ribbitous))
					M<<"<b><font color=green>You learned how to transfigure someone into a Frog!"
			src<<"You've taught your class the Ribbitious spell."

mob/GM
	verb
		Teach_Transfigure_Rabbit()
			set category = "Teach"
			set hidden = 1
			set name = "Teach Carrotosi"
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Carrotosi))
					M<<"<b><font color=green>You learned how to transfigure someone into a Bunny!"
			src<<"You've taught your class the Carrotosi spell."
mob/GM
	verb
		Teach_Transfigure_Skeleton()
			set category = "Teach"
			set hidden = 1
			set name = "Teach Personio Sceletus"
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Self_To_Skeleton))
					M<<"<b><font color=green>You learned how to transfigure yourself into a Skeletal Warrior!"
			src<<"You've taught your class Personio Sceletus spell."
mob/GM
	verb
		Teach_Transfigure_Dragon()
			set category = "Teach"
			set hidden = 1
			set name = "Teach Personio Draconum"
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Self_To_Dragon))
					M<<"<b><font color=green>You learned how to transfigure yourself into a fearsome Dragon!"
			src<<"You've taught your class Personio Draconum spell."
mob/GM
	verb
		Teach_Transfigure_Human()
			set category = "Teach"
			set hidden = 1
			set name = "Teach Transfiguro Revertio"
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Other_To_Human))
					M<<"<b><font color=green>You learned how to turn someone else into a Human!"
			src<<"You've taught your class the Transfiguro Revertio spell."
mob/GM
	verb
		Teach_Transfigure_Onion()
			set category = "Teach"
			set hidden = 1
			set name = "Teach Harvesto"
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Harvesto))
					M<<"<b><font color=green>You learned how to transfigure someone into an Onion!"
			src<<"You've taught your class the Harvesto spell."

mob/GM
	verb
		Teach_Transfigure_Cat()
			set category = "Teach"
			set hidden = 1
			set name = "Teach Felinious"
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Felinious))
					M<<"<b><font color=green>You learned how to transfigure someone into a Black Cat!"
			src<<"You've taught your class the Felinious spell."
mob/GM
	verb
		Teach_Transfigure_Mouse()
			set category = "Teach"
			set hidden = 1
			set name = "Teach Scurries"
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Scurries))
					M<<"<b><font color=green>You learned how to transfigure someone into a Mouse!"
			src<<"You've taught your class the Scurries spell."
mob/GM
	verb
		Teach_Transfigure_Chair()
			set category = "Teach"
			set hidden = 1
			set name = "Teach Seatio"
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Seatio))
					M<<"<b><font color=green>You learned how to transfigure someone into a Chair!"
			src<<"You've taught your class the Seatio spell."
mob/GM
	verb
		Teach_Transfigure_Bat()
			set category = "Teach"
			set hidden = 1
			set name = "Teach Nightus"
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Nightus))
					M<<"<b><font color=green>You learned how to transfigure someone into a Bat!"
			src<<"You've taught your class the Nightus spell."
mob/GM
	verb
		Teach_Transfigure_Pixie()
			set category = "Teach"
			set hidden = 1
			set name = "Teach Peskipixie Pestermi"
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Peskipixie_Pesternomae))
					M<<"<b><font color=green>You learned how to transfigure someone into a Pixie!"
			src<<"You've taught your class the Peskipixie Pestermi spell."
mob/GM
	verb
		Teach_Petreficus_Totalus()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Petreficus_Totalus))
					M<<"<b><font color=green>You learned Petrificus Totalus!"
			src<<"You've taught your class the Petrificus Totalus spell."
mob/GM
	verb
		Teach_Telendevour()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Telendevour))
					M<<"<b><font color=green>You learned Telendevour!"
			src<<"You've taught your class the Telendevour spell."
mob/GM
	verb
		Teach_Accio()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Accio))
					M<<"<b><font color=green>You learned Accio!"
			src<<"You've taught your class the Accio spell."

mob/GM
	verb
		Teach_Densuago()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Densuago))
					M<<"<b><font color=green>You learned Densaugeo!"
			src<<"You've taught your class the Densaugeo spell."

mob/GM
	verb
		Teach_Ferula()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Ferula))
					M<<"<b><font color=green>You learned Ferula!"
			src<<"You've taught your class the Ferula spell."


mob/GM
	verb
		Teach_Expecto_Patronum()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Expecto_Patronum))
					M<<"<b><font color=green>You learned Expecto Patronum!"
			src<<"You've taught your class the Expecto Patronum spell."

mob/GM
	verb
		Teach_Dementia()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Dementia))
					M<<"<b><font color=green>You learned how to summon Dementors!"
			src<<"You've taught your class the Dementia spell."

		Teach_Avis()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Avis))
					M<<"<b><font color=green>You learned the spell, Avis!"
			src<<"You've taught your class the Avis spell."
mob/GM
	verb
		Teach_Portus()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Portus))
					M<<"<b><font color=green>You learned Portus!"
			src<<"You've taught your class the Portus spell."
		Teach_Valorus()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Valorus))
					M<<"<b><font color=green>You learned Valorus!"
			src<<"You've taught your class the Valorus spell."
		Teach_Permoveo()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Permoveo))
					M<<"<b><font color=green>You learned Permoveo!"
			src<<"You've taught your class the Permoveo spell."
mob/GM
	verb
		Teach_Conjunctivis()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Conjunctivis))
					M<<"<b><font color=green>You learned Conjunctivis!"
			src<<"You've taught your class the Conjunctivis spell."

mob/GM
	verb
		Teach_Waddiwasi()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Waddiwasi))
					M<<"<b><font color=green>You learned Waddiwasi!"
			src<<"You've taught your class the Waddiwasi spell."


mob/GM
	verb
		Teach_Transfigure_Self_Human()
			set category = "Teach"
			set hidden = 1
			set name = "Teach Self to Human"
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Self_To_Human))
					M<<"<b><font color=green>You learned how to transform yourself back into a Human!"
			src<<"You've taught your class how to transform back into a Human."



mob/GM
	verb
		Teach_Incarcerous()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Incarcerous))
					M<<"<b><font color=green>You learned Incarcerous!"
			src << "You've taught your class the Incarcerous spell."

mob/GM
	verb
		Teach_Aero()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				M.Aero=1
				M<<"<b><font color=green>You learned Aero!"
			src<<"You've taught your class the Aero spell."

mob/GM
	verb
		Teach_Disperse()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Disperse))
					M<<"<b><font color=green>You learned Disperse!"
			src<<"You've taught your class the Disperse spell."

mob/GM
	verb
		Teach_Herbificus()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Herbificus))
					M<<"<b><font color=green>You learned Herbificus!"
			src<<"You've taught your class the Herbificus spell."

mob/GM
	verb
		Teach_Solidus()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Solidus))
					M<<"<b><font color=green>You learned Solidus!"
			src<<"You've taught your class the Solidus spell."