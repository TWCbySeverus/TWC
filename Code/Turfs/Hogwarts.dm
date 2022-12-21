obj/Ben_Hogwarts
	icon = 'Hogwarts 32x32.dmi'

	Large_Wall_Torch_Lit
		luminosity=10
		icon_state = "LargeWallTorchLit"

	Large_Wall_Torch_Unlit
		luminosity=0
		icon_state = "LargeWallTorchUnlit"


	Wall_Torch_Unlit
		icon_state = "SmallWallTorchUnlit"

	Small_Candle_Post
		icon_state = "Small Candle Post"

	Medium_Candle_Post
		icon_state = "Medium Candle Post"

	Large_Candle_Post
		icon_state = "Large Candle Post"

	Hanging_Note
		icon_state = "Ruleboard"

	Bookstack1
		icon_state = "Bookstacks1"

	Bookstack2
		icon_state = "Bookstacks2"

	Bookstack3
		icon_state = "Bookstacks3"

	Bookstack4
		icon_state = "Bookstacks4"

	Bookstack5
		icon_state = "Bookstacks5"

	Bookstack6
		icon_state = "Bookstacks6"

	Bookstack7
		icon_state = "Bookstacks7"

	Bookstack8
		icon_state = "Bookstacks8"

	Coathanger
		icon_state = "WallHanger"

	Dock_Pole
		icon_state = "DockPole"
		density = 1

	Light_Pillar_Middle
		icon_state = "PillarExtra2"
		layer = 6

	Light_Pillar_Bottom
		icon_state = "PillarExtra"
		density = 1

	Light_Pillar_Top
		icon_state = "PillarExtra3"
		layer = 6

	Dark_Pillar_Middle
		icon_state = "PillarMarble2"
		layer = 6

	Dark_Pillar_Bottom
		icon_state = "PillarMarble"
		density = 1

	Dark_Pillar_Top
		icon_state = "PillarMarble3"
		layer = 6

	Side_Torch_Right_Lit
		icon_state = "SideTorchRightLit"
		layer = MOB_LAYER+1

	Side_Torch_Left_Lit
		icon_state = "SideTorchLeftLit"
		layer = MOB_LAYER+1

	Side_Torch_Right_Unlit
		icon_state = "SideTorchRightUnlit"
		layer = MOB_LAYER+1

	Side_Torch_Left_Unlit
		icon_state = "SideTorchLeftUnlit"
		layer = MOB_LAYER+1

	Chess_Board
		icon_state = "Chessboard"

	Manhole
		icon_state = "Manhole"

	Drain
		icon_state = "Drain"

	Wall_Drain
		icon_state = "Wall Drain"

	Crystal_Ball
		icon_state = "Crystal Ball"

	Long_Drain
		icon_state = "Long Drain"

	Low_Wooden_Wall
		icon_state = "WHorizontal"
		layer = MOB_LAYER+1

	Low_Wooden_Wall_Right
		icon_state = "WRight"

	Low_Wooden_Wall_Left
		icon_state = "WLeft"

	Low_Old_Stone_Wall
		icon_state = "Horizontal"
		layer = MOB_LAYER+1

	Low_Old_Stone_Wall_Right
		icon_state = "Right"
		pixel_y = 14
		layer = MOB_LAYER+1

	Low_Old_Stone_Wall_Left
		icon_state = "Left"
		pixel_y = 14
		layer = MOB_LAYER+1

	Grey_Low_Old_Stone_Wall
		icon_state = "G Horizontal"
		layer = MOB_LAYER+1

	Grey_Low_Old_Stone_Wall_Right
		icon_state = "G Right"
		pixel_y = 14
		layer = MOB_LAYER+1

	Grey_Low_Old_Stone_Wall_Left
		icon_state = "G Left"
		pixel_y = 14
		layer = MOB_LAYER+1

	Column_Bottom
		icon_state = "Column Bottom"
		density = 1

	Column_Top
		icon_state = "Column Top"
		layer = MOB_LAYER+1

	Column_Top_B
		icon_state = "Column Top B"
		layer = MOB_LAYER+1

	Chalkboard_Top
		icon_state = "Chalkboard Top"
		layer = MOB_LAYER+1

	Chalkboard_Bottom
		icon_state = "Chalkboard Bottom"
		density = 1

	Small_Cross
		icon_state = "HCross"
		density = 1
		color = "#FFFFFF"


obj/Large_Hogwarts_Objects
	icon = 'Hogwarts Objects.dmi'

	Bookcase_Full
		icon_state = "Full"
		density = 1
		layer = MOB_LAYER+1
		bound_width = 64

	Bookcase_Empty
		icon_state = "Empty"
		density = 1
		layer = MOB_LAYER+1
		bound_width = 64

	Wand_Shelf
		icon_state = "Wands"
		density = 1
		layer = MOB_LAYER+1
		bound_width = 64

	Large_Cabinet
		icon_state = "Cabinet"
		density = 1
		layer = MOB_LAYER+1
		bound_width = 64

	Large_Drawers
		icon_state = "Drawers"
		density = 1
		layer = MOB_LAYER+1
		bound_width = 64

	Metal_Fence
		icon_state = "Horizontal"
		density = 1
		layer = MOB_LAYER+1

	Metal_Fence_Left_Side
		icon_state = "VerticalL"
		layer = MOB_LAYER+1

	Metal_Fence_Right_Side
		icon_state = "VerticalR"
		layer = MOB_LAYER+1

	Small_Cabinet
		icon_state = "Small Cabinet"
		density = 1
		layer = MOB_LAYER+1
		bound_width = 32

	Small_Drawers
		icon_state = "Small Drawers"
		density = 1
		layer = MOB_LAYER+1
		bound_width = 32
		bound_height = 32

	Wooden_Fence
		icon_state = "WHorizontal"
		density = 1
		layer = MOB_LAYER+1

	Wooden_Fence_Side
		icon_state = "WVertical"
		layer = MOB_LAYER+1

	Classroom_Window1
		icon_state = "Window 1"
		density = 1

	Classroom_Window2
		icon_state = "Window 2"
		density = 1


obj/Stairs
	icon = 'NTurfs.dmi'
	icon_state = "Stairs"

turf
	sideBlock

		var/blockDir

		wood
			icon_state = "Wooden Floor"
//			color = "#704f32"

			East
				blockDir = EAST
			West
				blockDir = WEST

		Enter(atom/movable/O)
			.=..()

			if(O.density && (get_dir(src, O) & blockDir) && isplayer(O))
				O.Bump(src)
				return 0

		Exit(atom/movable/O, atom/newloc)
			.=..()

			if(O.density && (get_dir(O, newloc) & blockDir) && isplayer(O))
				O.Bump(src)
				return 0

		East
			blockDir = EAST
		West
			blockDir = WEST
		South
			blockDir = SOUTH
