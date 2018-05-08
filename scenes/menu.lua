
local composer = require( "composer" )
local scene = composer.newScene()
local myData = require( "mydata" )
local styledText = require("styledText")
-- [Title View]

local gameBg
local title
--local startBtn
local mode2Btn
local mode3Btn
local aboutBtn
-- [TitleView Group]
local titleView

local function handleLevelSelect( event )
    if ( "ended" == event.phase ) then
        playSound('select')
        myData.settings.mode = event.target.id
        composer.removeScene( "scenes.menu",true )
        composer.gotoScene( "scenes.levelselect", { effect = "crossFade", time = 333 } )
    end
end

--
-- Start the composer event handlers
--
function scene:create( event )
    local sceneGroup = self.view
end

function scene:show( event )
    local sceneGroup = self.view
    gameBg = display.newImageRect('images/background.png',768,1024)
    gameBg.anchorX=0
    gameBg.anchorY=0

--    title = display.newImage('images/banner.png')
    -- add title
    title = display.newImageRect("images/banner.png", 330, 113, true)
    title.x=display.contentCenterX
    title.y = title.height
--    title = display.newText({text="JAPANESE WORD-SEARCH PUZZLE",width=300,height=100,align='center',font=native.systemFontBold,fontSize=30})
--    title.x = display.contentCenterX
--    title.y = 120
    sceneGroup:insert(gameBg)
    --    sceneGroup:insert(title)
    --	startBtn = display.newImage('images/play.png')
    --	startBtn.x = display.contentCenterX
    --	startBtn.y = display.contentCenterY + 20
    --    startBtn = display.newText({text="Romaji",align='center',font=native.systemFontBold,fontSize=25})
    --    startBtn.x = display.contentCenterX
    --    startBtn.y = display.contentCenterY + 20


--    startBtn = styledText.newText({
--        text = "Romaji",
--        textColor = {255,255,255,255},
--        x = display.contentCenterX,
--        y = display.contentCenterY,
--        font = native.systemFontBold,
--        size = 40,
--        shadowOffset = 2,
--        shadowColor = {230,80,6,100},
--        glowOffset = 4,
--        glowColor = {249,178,85,180}
--    })
--    startBtn.id = 'romaji'

    mode2Btn = styledText.newText({
        text = "ひらがな",
        textColor = {255,255,255,255},
        x = display.contentCenterX,
        y = display.contentCenterY,
        font = native.systemFontBold,
        size = 44,
        shadowOffset = 2,
        shadowColor = {230,80,6,100},
        glowOffset = 4,
        glowColor = {247,145,46,180}
    })
    mode2Btn.id = 'hiragana'

    mode3Btn = styledText.newText({
        text = "カタカナ",
        textColor = {255,255,255,255},
        x = display.contentCenterX,
        y = mode2Btn.y + 110,
        font = native.systemFontBold,
        size = 44,
        shadowOffset = 2,
        shadowColor = {230,80,6,100},
        glowOffset = 4,
        glowColor = {230,133,6,180}
    })
    mode3Btn.id = 'katakana'

    titleView = display.newGroup()
    titleView:insert(title)
--    titleView:insert(startBtn)
    titleView:insert(mode2Btn)
    titleView:insert(mode3Btn)
    sceneGroup:insert(titleView)
--    startBtn:addEventListener( "touch", handleLevelSelect )
    mode2Btn:addEventListener( "touch", handleLevelSelect )
    mode3Btn:addEventListener( "touch", handleLevelSelect )

    if event.phase == "did" then
    end
end

function scene:hide( event )
    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
    elseif ( phase == "did" ) then

    end
end

function scene:destroy( event )
    local sceneGroup = self.view
end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )


return scene