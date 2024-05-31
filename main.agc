// Author : Brianna Dayman
// Project: CSE1910_INDIVIDUALPROJECT_Dayman_Brianna 
// Created: 2024-05-01

// show all errors
SetErrorMode(2)

// set window properties
SetWindowTitle( "CSE1910_INDIVIDUALPROJECT_Dayman_Brianna" )
SetWindowSize( 600, 800, 0 )
SetWindowAllowResize( 1 ) // allow the user to resize the window

// set display properties
SetVirtualResolution( 600, 800 ) // doesn't have to match the window
SetOrientationAllowed( 1, 1, 1, 1 ) // allow both portrait and landscape on mobile devices
SetSyncRate( 30, 0 ) // 30fps instead of 60 to save battery
SetScissor( 0,0,0,0 ) // use the maximum available screen space, no black borders
UseNewDefaultFonts( 1 ) // since version 2.0.22 we can use nicer default fonts

//settings
SetPrintSize(30)
CreateImageColor(2, Random(1, 255), Random(1, 255), Random(1, 255), 255)
CreateImageColor(3, 255, 255, 255, 255)

//---------CONSTANTS---------//
#constant SHIP = 1
#constant OBS = 2
#constant OBS2 = 3
#constant PTS = 4
#constant SPACE = 32
#constant BACKGROUND = 6
#constant BACKGROUND2 = 7
#constant W = 87
#constant A = 65
#constant S = 83
#constant D = 68
#constant ESC = 27

//---------CREATE SPRITES---------//
LoadImage(6, "background.jpg")
CreateSprite(BACKGROUND, 6)
bkgX = 0
bkgY = 0
SetSpritePosition(6, bkgX, bkgY)

LoadImage(7, "background.jpg")
CreateSprite(BACKGROUND2, 7)
bkg2X = GetVirtualWidth()
bkg2Y = 0
SetSpritePosition(7, bkg2X, bkg2Y)


LoadImage(1, "ship.png")
CreateSprite(SHIP, 1)
SetSpriteSize(SHIP, 80, 80)
shipx = GetVirtualWidth()/2 - GetSpriteWidth(SHIP)/2
shipy = GetVirtualHeight()/2 - GetSpriteHeight(SHIP)/2
SetSpritePosition(SHIP, shipx, shipy)
 
//---------CREATE OBSTACLES-----------//
CreateSprite(OBS, 2) //TOP WALL
obsW = 40
obsH = 40
obsX = GetVirtualWidth()
obsY = 0
SetSpriteSize(OBS, obsW, obsH)
SetSpritePosition(OBS, obsX, obsY)

CreateSprite(OBS2, 2) //BOTTOM WALL
ob2sW = 40
obs2H = 40
obs2X = GetVirtualWidth()
obs2Y = 100
SetSpriteSize(OBS2, obs2X, obs2Y)
SetSpritePosition(OBS2, obs2X, obs2Y)

CreateSprite(PTS, 3)
SetSpriteSize(PTS, 30, 30)
ptsx = GetVirtualWidth()
ptsy = obsH + 150
SetSpritePosition(PTS, ptsx, ptsy)

//---------TEXT SPRITES-----------//

CreateText(4, "SCORE: "+str(score))
SetTextSize(4, 40)
SetTextPosition(4, 0, 0)

CreateText(5, "HIGHSCORE: "+str(highscore))
SetTextSize(5, 40)
SetTextPosition(5, 0, 40)

CreateText(8, "WELCOME TO SPACE ADVENTURES!")
SetTextSize(8, 35)
SetTextPosition(8, GetVirtualWidth()/2 - GetTextTotalWidth(8)/2, GetVirtualHeight()/2.3 - GetTextTotalHeight(8))

CreateText(9, "DON'T TOUCH THE OBSTACLES, OR FALL!")
SetTextSize(9, 35)
SetTextPosition(9, GetVirtualWidth()/2 - GetTextTotalWidth(9)/2, GetVirtualHeight()/2 - GetTextTotalHeight(9))

CreateText(10, "PRESS 'SPACEBAR' TO BEGIN")
SetTextSize(10, 35)
SetTextPosition(10, GetVirtualWidth()/2 - GetTextTotalWidth(10)/2, GetVirtualHeight()/1.77 - GetTextTotalHeight(10))

CreateText(11, "(use 'wasd' to fly the ship)")
SetTextAngle(11, 353)
SetTextSize(11, 35)
SetTextPosition(11, GetVirtualWidth()/2 - 20, GetVirtualHeight()/2 + 80)

CreateText(12, "GAME OVER!")
SetTextSize(12, 35)
SetTextPosition(12, GetVirtualWidth()/2 - GetTextTotalWidth(12)/2, GetVirtualHeight()/1.83 - GetTextTotalHeight(12)/2)

CreateText(13, "Play Again? 'SPACEBAR' for yes, and 'ESC' for no")
SetTextSize(13, 35)
SetTextPosition(13, GetVirtualWidth()/2 - GetTextTotalWidth(13)/2, GetVirtualHeight()/1.70 - GetTextTotalHeight(13)/2)

//---------SOUND SPRITES-----------//
LoadSound(14, "coin_sound.wav")
LoadSound(15, "lose.wav")
LoadSound(16, "music.wav")

//variables//
speed = 10
score = 0
liveObst = 0
livePts = 0
title = 1
end_game = 0

do
	PlaySound(16, 1, 0)
	gosub title_screen
	gosub move_obst
	gosub ship_movement
	gosub points_movement
	gosub ship_gravity
	gosub score_count
	gosub scrolling_background
	gosub obs_collisions
    
    Sync()
loop


//---------SUBROUTINES---------//

title_screen:
while title = 1						//SHOW TITLE SCREEN AND MAKE SPRITES INVISIBLE
	SetTextString(4, "SCORE: "+str(score))			//reset score
	SetSpriteVisible(6, 0)
	SetSpriteVisible(7, 0)
	setspritevisible(SHIP, 0)
	settextvisible(4, 0)
	settextvisible(5, 0)
	SetTextVisible(8, 1)
	SetTextVisible(9, 1)
	SetTextVisible(10, 1)
	SetTextVisible(11, 1)
	SetTextVisible(12, 0)
	SetTextVisible(13, 0)

	if GetRawKeyPressed(ESC)
	end
	endif
	if GetRawKeyPressed(SPACE)
		title = 0					//START GAME(SHOW SPRITES, AND HIDE TITLE SCREEN)
		SetTextVisible(8, 0)
		SetTextVisible(9, 0)
		SetTextVisible(10, 0)
		SetTextVisible(11, 0)
		setspritevisible(SHIP, 1)
		setspritevisible(PTS, 1)
		setspritevisible(BACKGROUND, 1)
		setspritevisible(BACKGROUND2, 1)
		setspritevisible(OBS, 1)
		setspritevisible(OBS2, 1)
		settextvisible(4, 1)
		settextvisible(5, 1)
		SetTextPosition(4, 0, 0)
		SetTextPosition(5, 0, 40)
		//reset sprite positions
		obsX = GetVirtualWidth() + 50
		obsY = 0
		ptsX = obsx + 23
		ptsY = obsH + 150
		//make sure that the bottom obs is still going to be the same distance from the top
		obs2W = 70
		obs2H = 1000
		obs2X = GetVirtualWidth() + 50
		obs2Y = obsH + 300 
		SetSpriteSize(OBS2, obs2W, obs2H)
		SetSpritePosition(OBS2, obs2X, obs2Y)
		SetSpritePosition(PTS, ptsx, ptsy)
		SetSpritePosition(OBS, obsX, obsY)
		exit
	else
	endif
	Sync()
endwhile
return

ship_gravity:
//VARIABLES//
ship_dX = 10
ship_dY = 10

//ship gravity + boundaries//
shipy = shipy + ship_dY
SetSpritePosition(SHIP, shipx, shipy)
return

ship_movement:
//ship movement + boundaries//

if GetRawKeyState(W) //UP MOVEMENT//
	ship_dY = -20
	shipy = shipy + ship_dY
	SetSpritePosition(SHIP, shipx, shipy)
endif

if GetRawKeyState(S) //DOWN MOVEMENT//
	ship_dY = 12
	shipy = shipy + ship_dY
	SetSpritePosition(SHIP, shipx, shipy)
endif

if GetRawKeyState(A) //LEFT MOVEMENT//
	shipx = shipx - ship_dX
	SetSpritePosition(SHIP, shipx, shipy)
endif

if GetRawKeyState(D) //RIGHT MOVEMENT//
	shipx = shipx + ship_dX
	SetSpritePosition(SHIP, shipx, shipy)
endif
return

//CREATE MOVING WALLS
move_obst:
obs_dX = -10
obs2_dX = -10
//MOVEMENT OF THE TOP WALL
if liveObst = 0 //if the wall is offscreen
	obsW = 70	//Width and Height of the top wall
	obsH = Random(70, 550)
	obs2W = 70 		//Width and Height of the bottom wall
	obs2H = 1000
	obsX = GetVirtualWidth() 	//position of the top and bottom wall
	obsY = 0
	obs2X = GetVirtualWidth()
	obs2Y = obsH + 300 		//make the bottom wall 300 pixels below the top wall
	SetSpriteSize(OBS, obsW, obsH)
	SetSpriteSize(OBS2, obs2W, obs2H)
	liveObst = 1
endif
obsx = obsx + obs_dX
obs2X = obs2X + obs2_dX
SetSpritePosition(OBS, obsX, obsY)
SetSpritePosition(OBS2, obs2X, obs2Y)
if obsX < 0 - GetSpriteWidth(OBS) + -GetSpriteWidth(OBS2)	//if the walls are off the screen, spawn them back to the right side
	LiveObst = 0
endif
return

points_movement:
pts_dX = -10
if livePts = 0
	SetSpriteVisible(PTS, 1)
	ptsW = 25
	ptsH = 25
	ptsX = obsx + 27.5
	ptsY = obsH + 150
	SetSpriteSize(PTS, ptsW, ptsH)
	SetSpritePosition(PTS, ptsX, ptsY)
	livePts = 1
endif
ptsX = ptsX + pts_dX
SetSpritePosition(PTS, ptsX, ptsY)
if obsX < 0 - GetSpriteWidth(OBS) + -GetSpriteWidth(OBS2)
	livePts = 0
endif
return

score_count:
if GetSpriteCollision(SHIP, PTS)
	PlaySound(14, 15, 0)
	ptsx = -10			//move the point off the screen so that it only counts as one point
	SetSpritePosition(PTS, ptsx, ptsy)
	score = score + 1
	SetTextString(4, "SCORE: "+str(score))
	SetSpriteVisible(PTS, 0)
	if score > highscore					//add a new highscore if current score if higher
		highscore = score
	SetTextString(5, "HIGHSCORE: "+str(highscore))
	endif
endif
return

scrolling_background:
//VARIABLES//
bkg_dX = -10
bkg2_dX = -10

if bkgX=-GetVirtualWidth()
	bkgX = GetVirtualWidth()
endif
if bkg2X=-GetVirtualWidth()
	bkg2X = GetVirtualWidth()
endif
bkgX = bkgX + bkg_dX
bkg2X = bkg2X + bkg2_dX
SetSpritePosition(BACKGROUND, bkgX, bkgY)
SetSpritePosition(BACKGROUND2, bkg2X, bkg2Y)
return


obs_collisions:
if GetSpriteCollision(SHIP, OBS) or GetSpriteCollision(SHIP, OBS2) or shipy < 0 or shipy > GetVirtualHeight() - GetSpriteHeight(SHIP) or shipx < 0 or shipx > GetVirtualWidth() - GetSpriteWidth(SHIP)
	PlaySound(15, 20, 0)
	//hide the sprites
	SetSpriteVisible(6, 0)
	SetSpriteVisible(7, 0)
	setspritevisible(OBS, 0)
	setspritevisible(OBS2, 0)
	setspritevisible(SHIP, 0)
	SetSpriteVisible(PTS, 0)
	score = 0
	do
		//show the score, highscore, gameover, and play again sprites
		settextvisible(4, 1)
		settextvisible(5, 1)
		SetTextVisible(12, 1)
		SetTextVisible(13, 1)
		SetTextPosition(4, GetVirtualWidth()/2 - GetTextTotalWidth(4)/2, GetVirtualHeight()/2.2 - GetTextTotalHeight(4)/2)
		SetTextPosition(5, GetVirtualWidth()/2 - GetTextTotalWidth(5)/2, GetVirtualHeight()/2 - GetTextTotalHeight(5)/2)
		if GetRawKeyPressed(ESC)	//add an option to leave the game
			end
		endif
		if GetRawKeyPressed(SPACE)
			shipx = GetVirtualWidth()/2 - GetSpriteWidth(SHIP)/2
			shipy = GetVirtualHeight()/2 - GetSpriteHeight(SHIP)/2
			SetSpritePosition(SHIP, shipx, shipy)
					obsX = GetVirtualWidth() + 50
					obsY = 0
					ptsX = obsx + 23
					ptsY = obsH + 150
					//make sure that the bottom obs is still going to be the same distance from the top
					obs2W = 70
					obs2H = 1000
					obs2X = GetVirtualWidth() + 50
					obs2Y = obsH + 300 
					SetSpriteSize(OBS2, obs2W, obs2H)
					SetSpritePosition(OBS2, obs2X, obs2Y)
					SetSpritePosition(PTS, ptsx, ptsy)
					SetSpritePosition(OBS, obsX, obsY)
			title = 1
			exit
		endif	
		Sync()
	loop
endif
return
