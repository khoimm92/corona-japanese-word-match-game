display.setStatusBar( display.HiddenStatusBar )
display.setDefault("background", 1, 1, 1)

local composer = require("composer")
local loadsave = require("loadsave")
local Leaderboard = require("Leaderboard")
local adsLib      = require("adsLib")
setup    = require("setup")
composer.recycleOnSceneChange = true

math.randomseed( os.time() )

local soundPool = {}
soundPool["select"] = audio.loadSound("sounds/select.mp3")
soundPool["score"] = audio.loadSound("sounds/point.mp3")
soundPool["plank"] = audio.loadSound("sounds/plank.mp3")
soundPool["gameover"] = audio.loadSound("sounds/gameover.mp3")
audio.setVolume(0.6, {channel = 1})
audio.setVolume(1, {channel = 2})
audio.setVolume(1, {channel = 3})
audio.setVolume(1, {channel = 4})

function playSound(name,params)
	if soundPool[name] ~= nil then 
		return audio.play(soundPool[name],params)
	end
end

_G.saveDataTable		= {}
_G.bottomSide = display.contentHeight-display.screenOriginY -2

local function systemEvents( event )
   print("systemEvent " .. event.type)
   if ( event.type == "applicationSuspend" ) then
      print( "suspending..........................." )
   elseif ( event.type == "applicationResume" ) then
      print( "resuming............................." )
   elseif ( event.type == "applicationExit" ) then
      print( "exiting.............................." )
   elseif ( event.type == "applicationStart" ) then
      if useLeaderboard == true then
		Leaderboard.init()
      end
      adsLib.init()
      adsLib.showBannerAd("bottom")
   end
   return true
end

local function onKeyEvent( event )
    local phase = event.phase
    local keyName = event.keyName
    if ( "back" == keyName and phase == "up" ) then
        if ( composer.getCurrentSceneName() == "scenes.menu" ) then
            native.requestExit()
        elseif ( composer.getCurrentSceneName() == "scenes.game" ) then
--            if ( composer.isOverlay ) then
--                composer.hideOverlay()
--            else
                composer.removeScene( "scenes.game" )
                composer.gotoScene( "scenes.levelselect", { effect="crossFade", time=300 } )
--            end
        elseif ( composer.getCurrentSceneName() == "scenes.levelselect" ) then
            composer.gotoScene( "scenes.menu", { effect="crossFade", time=300 } )
        end
        return true
    end
    return false
end
Runtime:addEventListener( "key", onKeyEvent )
Runtime:addEventListener( "system", systemEvents )
--if loadsave.fileExists("leverman.json", system.DocumentsDirectory) then
--	saveDataTable = loadsave.loadTable("japanese-word-search.json")
--else
--	saveDataTable.bestScore = 1
--	loadsave.saveTable(saveDataTable, "japanese-word-search.json")
--end
--
--saveDataTable = loadsave.loadTable("japanese-word-search.json")
--_G.bestScore = saveDataTable.bestScore
composer.gotoScene( "scenes.menu", "fade", 200 )
--composer.gotoScene( "scenes.menu", "fade", 200 )


