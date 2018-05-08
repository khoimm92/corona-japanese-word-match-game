local composer = require( "composer" )
local scene = composer.newScene()
--
-- Use widget.newButton and widget.newScrollView
--
local widget = require( "widget" )
--
-- My "global" like data table, see http://coronalabs.com/blog/2013/05/28/tutorial-goodbye-globals/
--
-- This will contain relevent data for tracking the current level, max levels, number of stars earned
-- per level and score per level (Not used in this tutorial) as well as other settings
--
local myData = require( "mydata" )
--
-- Use a vector star for demo purposes, you probably would want a graphic for this.  Math courtesy of:
-- http://www.smiffysplace.com/stars.html
local starVertices = { 0,-8, 1.763,-2.427, 7.608,-2.472, 2.853, 0.927, 4.702, 6.472, 0.0, 3.0, -4.702, 6.472, -2.853, 0.927, -7.608,-2.472, -1.763, -2.427, }

--
-- Button handler to go to the selected level
--
local function handleLevelSelect( event )
    if ( "ended" == event.phase ) then
        playSound('select')
        --
        -- event.target is the button.  The ID is a number indicating the level going to.  
        -- the "game" scene will use this setting to determine which level to play.  This could
        -- be done by passing parameters too.
        --
        -- Also purge the game scene so we get a fresh start.
        --
        myData.settings.currentLevel = event.target.id
        composer.removeScene( "scenes.game", false )
        composer.gotoScene( "scenes.game", { effect = "crossFade", time = 333 } )
    end
end
--
-- Start the composer event handlers
--
function scene:create( event )
    local sceneGroup = self.view
    --
    -- create your background here
    --
    local background = display.newImageRect('images/background.png',768,1024)
    background.anchorX=0
    background.anchorY=0

    sceneGroup:insert(background)
    --
    -- Use a widget.newScrollView to contain all the level button objects so you can support more than 
    -- a screen full of them.  Since this will only scroll vertically, lock the horizontal scrolling.
    --
    local levelSelectGroup = widget.newScrollView({
        width = 300,
        height = 480,
        scrollWidth = 320,
        scrollHeight = 800,
        horizontalScrollDisabled = true,
        hideBackground = true
    })
    --
    -- xOffset, yOffset and cellCount are used to position the buttons in the grid.  Set their
    -- initial values.
    --
    local xOffset = 60
    local yOffset = 60
    local cellCount = 1
    --
    -- define the array to hold each button
    --
    local buttons = {}
    --
    -- Determine the maxLevels from the myData table.  This is where you determine how many
    -- levels your game supports.  Loop over them, generating one button, group for each.
    --
    for i = 1, myData.maxLevels do
        -- create the button
        buttons[i] = widget.newButton({
            label = i,
            id = i,
            onEvent = handleLevelSelect,
            emboss = false,
            --properties for a rounded rectangle button...
            shape="roundedRect",
            width = 70,
            height = 52,
            font = native.systemFontBold,
            fontSize = 22,
            labelColor = { default = { 1, 1, 1}, over = { 0.5, 0.5, 0.5 }},
            cornerRadius = 8,
            labelYOffset = -6, 
            fillColor = { default={ 212/225, 137/225, 7/225, 1 }, over={ 0.5, 0.75, 1, 1 } },
--            strokeColor = { default={ 0, 0, 1, 1 }, over={ 0.333, 0.667, 1, 1 } },
--            strokeWidth = 2
        })
        -- position the button in the grid and add to the scrollView
        buttons[i].x = xOffset
        buttons[i].y = yOffset
        levelSelectGroup:insert(buttons[i])
        --
        -- Check to see if the player has achieved this level or not.  The .unlockedLevels
        -- value tracks the maximum level they have unlocked.  This lets them play previous
        -- levels if they wish to try and do better. 
        --
        -- However first, check to make sure this value has been set.  For a new user this
        -- value should be 1 if it's not been set.
        --
        -- If the level is locked, disable the button and fade the button out.
        --
        mode = myData.settings.mode

        if myData.modeAlphabet[mode].unlockedLevels == nil then
            myData.modeAlphabet[mode].unlockedLevels = 1
        end
        if i <= myData.modeAlphabet[mode].unlockedLevels then
            buttons[i]:setEnabled( true )
            buttons[i].alpha = 1.0
        else
            buttons[i]:setEnabled( false )
            buttons[i].alpha = 0.5
        end
        --
        -- Now generate stars earned for each level but only if:
        -- a. the levels table exists
        -- b. There is a stars value inside of the levels table and
        -- c. The number of stars is greater than 0 (no need to draw 0 stars, eh?)
        --
        -- Generate the star and position it relative to the button it goes with.
--        local star = {}
--        if myData.settings.levels[i] and myData.settings.levels[i].stars and myData.settings.levels[i].stars > 0 then
--            for j = 1, myData.settings.levels[i].stars do
--                star[j] = display.newPolygon( 0, 0, starVertices )
--                star[j]:setFillColor( 1, 0.9, 0)
--                star[j].strokeWidth = 1
--                star[j]:setStrokeColor( 1, 0.8, 0 )
--                star[j].x = buttons[i].x + (j * 16) - 32
--                star[j].y = buttons[i].y + 8
--                levelSelectGroup:insert(star[j])
--            end
--        end
        -- 
        -- Compute the position of the next button.  This is set to draw 5 wide.  It also spaces based on
        -- the button width and height + initial offset from the left.
        --
        xOffset = xOffset + 93
        cellCount = cellCount + 1
        if cellCount > 3 then
            cellCount = 1
            xOffset = 60
            yOffset = yOffset + 60
        end
    end
    --
    -- Load the scrollView into the scene and center it!
    --
    sceneGroup:insert(levelSelectGroup)
    levelSelectGroup.x = display.contentCenterX
    levelSelectGroup.y = display.contentCenterY
end
--
function scene:show( event )
    local sceneGroup = self.view
    --
    if event.phase == "did" then
    end
end
--
function scene:hide( event )
    local sceneGroup = self.view
    --
    if event.phase == "will" then
    end
end
--
function scene:destroy( event )
    local sceneGroup = self.view   
end

---------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
return scene
