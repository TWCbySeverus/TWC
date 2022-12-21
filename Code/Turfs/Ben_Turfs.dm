turf/Ben_Turfs
	icon='NTurfs.dmi'

	Map_Edge
		icon_state = "Edge"
		density = 1
		opacity = 1
		flyblock = 1
	Grass
		icon='turf.dmi'
		icon_state = "snow"

	Grass_Edge_Right
		icon_state = "sRight"

	Grass_Edge_Left
		icon_state = "sLeft"

	Grass_Edge_Top
		icon_state = "sTop"

	Grass_Edge_Bottom
		icon_state = "sBottom"

	Grass_Edge_Top_Right
		icon_state = "sTR"

	Grass_Edge_Top_Left
		icon_state = "sTL"

	Grass_Edge_Bottom_Right
		icon_state = "sBR"

	Grass_Edge_Bottom_Left
		icon_state = "sBL"

	Grass_Edge_Northeast
		icon_state = "snortheast"

	Grass_Edge_Northwest
		icon_state = "snorthwest"

	Grass_Edge_Southeast
		icon_state = "ssoutheast"

	Grass_Edge_Southwest
		icon_state = "ssouthwest"

	Snow
		icon_state = "Snow"

	Snow_Edge_Right
		icon_state = "sright"

	Snow_Edge_Left
		icon_state = "sleft"

	Snow_Edge_Top
		icon_state = "stop"

	Snow_Edge_Bottom
		icon_state = "sbottom"

	Snow_Edge_Top_Right
		icon_state = "str"

	Snow_Edge_Top_Left
		icon_state = "stl"

	Snow_Edge_Bottom_Right
		icon_state = "sbr"

	Snow_Edge_Bottom_Left
		icon_state = "sbl"

	Stone_Floor
		icon_state = "Stone"

	Wooden_Floor
		icon_state = "Wooden Floor"

	Wooden_Floor_Black
		icon_state = "Wooden Floor Black"

	Light_Wooden_Floor
		icon_state = "Wooden Floor2"

	Wooden_Dock_Floor
		icon_state = "Wood Long"

	Stone_Floor
		icon_state = "Stone"

	Metal_Wall
		icon_state = "Metal"
		density = 1
		flyblock = 1

	Metal_Wall2
		icon_state = "Metal2"
		density = 1
		flyblock = 1

	Wooden_Wall_Paneling1
		icon_state = "WoodWallPaneling"
		density = 1
		flyblock = 1

	Wooden_Wall_Paneling2
		icon_state = "WoodWallPaneling2"
		density = 1
		flyblock = 1

	Red_Wallpaper
		icon_state = "red wallpaper"
		density = 1
		flyblock = 1

	Cabin_Window
		icon_state = "wallpaper window"
		flyblock = 1
		layer = MOB_LAYER+1

	Cabin_Outdoor_Window
		icon_state = "moving train window"
		flyblock = 1
		layer = MOB_LAYER+1

	Panel_Arch
		icon_state = "PanelArch"
		flyblock = 1
		layer = MOB_LAYER+1

	Old_Stone_Wall_Bottom
		icon_state = "Old Stone Bottom"
		density = 1
		flyblock = 1

	Old_Stone_Wall_Top
		icon_state = "Old Stone"
		density = 1
		flyblock = 1

	Grey_Stone_Wall_Bottom
		icon_state = "Grey Stone Bottom"
		density = 1
		flyblock = 1

	Grey_Stone_Wall_Top
		icon_state = "Grey Stone"
		density = 1
		flyblock = 1

	Hole_In_Wall
		icon_state = "hole"
		flyblock = 1
		density=0
		Entered(mob/M)
			if(M.key)
				M.loc=locate(4,2,17)
				M.Move(locate(4,2,17))
			else
				M.x-=1

	Red_Brick_Wall
		icon_state = "Brick"
		density = 1
		flyblock = 1

	Grey_Roof
		icon_state = "Roof"
		density = 1
		opacity = 1
		flyblock = 1

	School_Roof
		icon_state = "Roof"
		density = 1
		flyblock = 1

	Hogwarts_Roof
		icon_state = "Hogwarts"
		density = 1
		opacity = 1
		layer=6
		flyblock = 1

	Red_Roof
		icon_state = "Red"
		density = 1
		opacity = 1
		flyblock = 1

	Blue_Roof
		icon_state = "Blue"
		density = 1
		opacity = 1
		flyblock = 1

	Gold_Roof
		icon_state = "Gold"
		density = 1
		opacity = 1
		flyblock = 1

	Green_Roof
		icon_state = "Green"
		density = 1
		opacity = 1
		layer=6
		flyblock = 1

	Diamonds_Tile
		icon_state = "Tile 1"

	Diamond_Tile
		icon_state = "Tile 2"

	Circular_Tile
		icon_state = "Tile 3"

	Square_Tile
		icon_state = "Tile 4"

	Hexagon_Tile
		icon_state = "Tile 5"

	Brick_Archway
		icon_state = "Brick Arch"
		layer = MOB_LAYER+1

	Concrete
		icon_state = "Concrete"

	Pavement
		icon_state = "Pavement"

	Slated_Tile
		icon_state = "Slate"

	Cobble_Path
		icon_state = "Cobble"

	Old_Stone_Tile
		icon_state = "Tiles"

	Blue_Carpet
		icon_state = "Blue Carpet"

	Red_Carpet
		icon_state = "Red Carpet"

	Green_Carpet
		icon_state = "Green Carpet"

	Yellow_Carpet
		icon_state = "Yellow Carpet"

	Black_Carpet
		icon_state = "Black Carpet"

	White_Carpet
		icon_state = "White Carpet"

	Duel_Carpet
		icon_state = "Duel Carpet"

	Sand
		icon_state = "Sand"

	Sand_Edge_Right
		icon_state = "SAright"

	Sand_Edge_Left
		icon_state = "SAleft"

	Sand_Edge_Top
		icon_state = "SAtop"

	Sand_Edge_Bottom
		icon_state = "SAbottom"

	Tiled_Roof
		icon_state = "Tiled"
		density = 1
		opacity = 1
		flyblock = 1

	Old_Stone_Archway
		icon_state = "Arch"
		layer = MOB_LAYER+1

	Grey_Stone_Archway
		icon_state = "Grey Stone Arch"
		layer = MOB_LAYER+1

	Road
		icon_state = "Road"

	Road_Vertical
		icon_state = "Road 1"

	Road_Horizontal
		icon_state = "Road 2"

	Road_Horizontal_Crossing
		icon_state = "Road 3"

	Road_Vertical_Crossing
		icon_state = "Road 4"

turf/MousePathTiles
	icon = 'Mouse Path Tiles.dmi'
	Floor
		icon_state = "floor"
	Bottomless_Pit
		icon_state = "floor_hole"
		density = 1
	Metal_Grate
		icon_state = "floor_grate"

obj/MousePathObjects
	icon = 'Mouse Path Tiles.dmi'
	Moss_
		icon_state = "mossfloor"
	Moss__
		icon_state = "mossfloor2"
	Moss___
		icon_state = "mossfloor3"
	Moss____
		icon_state = "mossfloor4"

turf/OllivanderShop
	icon = 'Ollivander.dmi'
	density=1
	flyblock=1
	Row1_3
		density=0
		layer=6
		icon_state = "13"
	Row2_3
		density=0
		layer=6
		icon_state = "22"
	Row3_3
		density=0
		layer=6
		icon_state = "33"
	Row4_3
		density=0
		layer=6
		icon_state = "43"
	Row5_3
		icon_state = "53"
	brick
		icon_state = "brick"
	Row1_1
		icon_state = "1"
	Row1_2
		icon_state = "12"
	Row1_4
		icon_state = "14"
	Row2_1
		icon_state = "2"
	Row2_2
		icon_state = "21"
	Row2_4
		icon_state = "23"
	Row3_1
		icon_state = "3"
	Row3_2
		icon_state = "32"
	Row3_4
		icon_state = "34"
	Row4_1
		icon_state = "4"
	Row4_2
		icon_state = "42"
	Row4_4
		icon_state = "44"
	Row5_1
		icon_state = "5"
	Row5_2
		icon_state = "52"
	Row6_1
		density=0
		icon_state = "6"
	Row6_2
		density=0
		icon_state = "62"
	Row6_3
		density=0
		icon_state = "63"
	Row6_4
		density=0
		icon_state = "64"
/*
	Floor
		icon_state = "main"
		flyblock = 1
		layer=2
	Bottomless_Pit
		icon_state = "bottom"
		density = 1
		layer=1*/

turf/Gringotts
	icon = 'Gringotts.dmi'
	Wall
		icon_state = "wall"
		flyblock = 1
		layer=2
	Pillar
		icon_state = "pillar"
		density = 1
		layer=1


