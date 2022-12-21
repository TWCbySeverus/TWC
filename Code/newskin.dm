mob/var/pncustom_n = 0
mob/var/pncustom_r = 0
mob/var/pncustom_g = 0
mob/var/pncustom_b = 0


mob/HGM/verb/Edit_Name_Overlay(var/mob/Player/M in Players)
	var/input = input("Type in Color as hex") as text
	M.pncustom_r=GetRedPart(input)
	M.pncustom_g=GetGreenPart(input)
	M.pncustom_b =GetBluePart(input)
	M.pncustom_n=1
	M.GenerateNameOverlay(255,255,255)


obj/tester
	icon='tester.dmi'
	verb/Set_Icon()
		set src in view(5)
		var/icon_a = input("Choose Icon") as icon
		if(src in view(5))
			src.icon = icon_a