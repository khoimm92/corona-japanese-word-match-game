local loadsave = require("loadsave")
local inspect = require( "inspect" )
local composer = require( "composer" )
local scene = composer.newScene()
local myData = require( "mydata" )
local widget = require( "widget" )
local adsLib      = require("adsLib")
-- [Title View]

local gameBg
local title
local startBtn
local aboutBtn
-- [TitleView Group]
local titleView

local uiGroup
local expectedWords
local wordsList
local currentWords
local scrollView

local tfs = display.newGroup()
local line
local lines = display.newGroup()
local clearLevel
local alert

local L1
local L1Map
local mode
local alphabet
local correct = 0 -- Số từ tìm được

local removeObjs
local onCollision
local gameListeners = {}
local buildSoup = {}
local startDraw = {}
local hitTestObjects = {}
local detectLetters = {}

function gameListeners(action)

	if(action == 'add') then
		gameBg:addEventListener('touch', startDraw)
		gameBg:addEventListener('touch', detectLetters)
	else
		gameBg:removeEventListener('touch', startDraw)
		gameBg:removeEventListener('touch', detectLetters)
	end
end

function buildSoup(sceneGroup)
    tfs = display.newGroup()
	for i = 1, #L1Map[1] do
		for j = 1, #L1Map do
			tf = display.newText('', 0, 0, native.systemFontBold, 19)
			tf:setTextColor(102, 102, 102)
			tf.width = 22
			tf.height = 21
			tf.x = math.floor(-10 + (31.3 * i))
			tf.y = math.floor(-10 + (35 * j))
			if(L1Map[j][i] == 0) then
				L1Map[j][i] = alphabet[math.floor(math.random() * table.maxn(alphabet))+1]
			end

			tf.text = L1Map[j][i]
			tf.id = L1Map[j][i]
			tfs:insert(tf)
		end
	end
	sceneGroup:insert( tfs )
	local scrollView = widget.newScrollView
		{
			width = display.contentWidth,
			height = 50,
			scrollWidth = 1600,
			scrollHeight = 50,
			verticalScrollDisabled = true,
			horizontalScrollDisabled = false,
--			isBounceEnabled = false,
		}
	expectedWords = display.newGroup(scrollView)
	scrollView.x = display.contentCenterX
	scrollView.y = display.contentHeight - 65

	for i = 1, #L1 do
--        wordsList = display.newText(L1[i], display.contentCenterX, 10+tfs.height+(i*20), native.systemFontBold, 13)
		local x=50
		if (i>1) then
			x=expectedWords[i-1].x+expectedWords[i-1].width+20
		end

        wordsList = display.newText(L1[i], x, 24, native.systemFontBold, 18)
        wordsList:setTextColor(0.5)
        wordsList.id=L1[i]
        expectedWords:insert(wordsList)
	end
	scrollView:insert( expectedWords )
	sceneGroup:insert( scrollView )
end


function startDraw:touch(e)
--    lines = display.newGroup()
    if(e.phase == 'began') then
        initX = e.x
        initY = e.y
    elseif(e.phase == 'ended') then
        line = display.newLine(initX, initY, e.x, e.y)
        line.strokeWidth = 7
        line:setStrokeColor(255, 142, 42, 60)
        line.alpha = 0.5
        lines:insert(line)
    end
end

function hitTestObjects(obj1, obj2)
	if ( obj1 == nil ) then  -- Make sure the first object exists
	return false
	end
	if ( obj2 == nil ) then  -- Make sure the other object exists
	return false
	end
	local left = obj1.contentBounds.xMin <= obj2.contentBounds.xMin and obj1.contentBounds.xMax >= obj2.contentBounds.xMin
	local right = obj1.contentBounds.xMin >= obj2.contentBounds.xMin and obj1.contentBounds.xMin <= obj2.contentBounds.xMax
	local up = obj1.contentBounds.yMin <= obj2.contentBounds.yMin and obj1.contentBounds.yMax >= obj2.contentBounds.yMin
	local down = obj1.contentBounds.yMin >= obj2.contentBounds.yMin and obj1.contentBounds.yMin <= obj2.contentBounds.yMax
	return (left or right) and (up or down)
end

function detectLetters:touch(e)
	local selectedWord = ''
	for i = 1, tfs.numChildren do
		if(hitTestObjects(lines[lines.numChildren], tfs[i])) then
			selectedWord = selectedWord .. tfs[i].text
            print(selectedWord)
		end
	end

	local right = false
	for j = 0, #L1 do
		if(selectedWord == L1[j] and expectedWords[j].id==selectedWord) then
			right=true
			lines[lines.numChildren].width=25
			playSound('score')
			correct = correct + 1
--			L1[j]=0
            --@TODO: hiệu ứng correct
            expectedWords[j]:setTextColor(5/255,180/255,230/255)
			expectedWords[j].id=0
		end
	end

	if (e.phase == 'ended' and right == false) then
		playSound('gameover')
		--remove that incorrect line
		timer.performWithDelay( 200, function() lines:remove(lines.numChildren) end, 1 )
	end

	if(correct == #L1) then
--		display.remove(lines)
		playSound('score')
		clearLevel()
		--save current cleared level
		if (myData.settings.currentLevel >= myData.modeAlphabet[mode].unlockedLevels) then
			myData.modeAlphabet[mode].unlockedLevels=myData.settings.currentLevel+1
			saveDataTable[mode].unlockedLevels=myData.settings.currentLevel+1
			loadsave.saveTable(saveDataTable, "japanese-word-search.json")
		end
	end

return true
end

function clearLevel()
	gameListeners('rm')
	uiGroup = display.newGroup()
	local fadeRect = display.newRect(uiGroup,display.contentWidth*0.5,display.contentHeight*0.5,display.contentWidth,display.contentHeight)
	fadeRect:setFillColor(0,0,0,0.8)
	fadeRect.alpha = 0.1

	local overRect = display.newImageRect(uiGroup,"images/rect_over.png", 220, 250)
	overRect.x = display.contentWidth*0.5; overRect.y = display.contentCenterY
	overRect.alpha = 0.5
	local overText = display.newText({parent=uiGroup,text="LEVEL "..myData.settings.currentLevel.." CLEARED!",font=native.systemFontBold,fontSize=22})
	overText.x = overRect.x
	overText.y = overRect.y-65
	overText:setFillColor(212/225, 137/225, 7/225)

	local nextBtn = display.newImageRect(uiGroup,"images/next.png", 60, 60)
	nextBtn.x = overRect.x; nextBtn.y = overRect.y + 25
	nextBtn.id = "next"
	if (myData.settings.currentLevel < myData.maxLevels) then
		nextBtn.isVisible = true
	else
		nextBtn.isVisible = false
	end

	local rateBtn = display.newImageRect(uiGroup,"images/info.png", 50, 50)
	rateBtn.x = overRect.x; rateBtn.y = nextBtn.y + nextBtn.height/2 + 38; rateBtn.id = "rate"

	local homeBtn = display.newImageRect(uiGroup,"images/back.png", 50, 50)
	homeBtn.x = rateBtn.x - 64; homeBtn.y = rateBtn.y; homeBtn.id = "home"

	local retryBtn = display.newImageRect(uiGroup,"images/restart.png", 50, 50)
	retryBtn.x = rateBtn.x + 64; retryBtn.y = rateBtn.y; retryBtn.id = "retry"

	local trans2 = transition.to(uiGroup, {time=250, delay=250, y=0, onComplete=function()
		local function buttonTouched(event)
			local t = event.target
			local id = t.id

			if event.phase == "began" then
				display.getCurrentStage():setFocus( t )
				t.isFocus = true
				t.alpha = 0.7

			elseif t.isFocus then
				if event.phase == "ended"  then
					display.getCurrentStage():setFocus( nil )
					t.isFocus = false
					t.alpha = 1
					playSound('plank')
					local b = t.contentBounds
					if event.x >= b.xMin and event.x <= b.xMax and event.y >= b.yMin and event.y <= b.yMax then
--						playSound("select")

						if id == "home" then
							removeObjs()
							composer.removeScene( "scenes.game")
							composer.gotoScene( "scenes.levelselect", "fade", 400 )
						elseif id == "rate" then
							local options =
							{
								iOSAppId = iOSAppId,
								androidAppPackageName=androidAppPackageName,
								nookAppEAN = nookAppEAN,
								supportedAndroidStores = { "google", "samsung", "amazon", "nook" },
							}
							native.showPopup( "appStore", options )
						elseif id == "retry" then
							removeObjs()
							composer.removeScene( "scenes.game", false )
							composer.gotoScene( "scenes.game", { effect = "crossFade", time = 333 } )
						else--next level
							removeObjs()
							myData.settings.currentLevel = myData.settings.currentLevel+1
							adsLib.showInterstitial()
							composer.removeScene( "scenes.game", false )
							composer.gotoScene( "scenes.game", { effect = "crossFade", time = 333 } )
						end
					end
				end
			end
			return true
		end
		nextBtn:addEventListener("touch", buttonTouched)
		retryBtn:addEventListener("touch", buttonTouched)
		rateBtn:addEventListener("touch", buttonTouched)
		homeBtn:addEventListener("touch", buttonTouched)
	end})
end

function removeObjs()
	display.remove(tfs)
	display.remove(uiGroup)
	display.remove(expectedWords)
	display.remove(lines)
	lines=nil
end

function scene:create( event )
	local sceneGroup = self.view
	local phase = event.phase
	if (L1~=nil) then
		L1:removeSelf()
		L1=nil
	end
--	if ( phase == "will" ) then
--	elseif ( phase == "did" ) then
--		Main()
--	end
	gameBg = display.newImageRect('images/background.png',768,1024)
	gameBg.anchorX=0
	gameBg.anchorY=0
	mode = myData.settings.mode
	print('lv '..myData.settings.currentLevel)
	print('mode '..myData.settings.mode)
	alphabet = myData.modeAlphabet[mode].alphabet
	local cLevel = myData.modeAlphabet[mode].levels[tonumber(myData.settings.currentLevel)]
	L1 = cLevel.W
	L1Map = cLevel.W_M
	sceneGroup:insert(gameBg)
	buildSoup(sceneGroup) gameListeners('add')
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
	--@TODO: loi so khong
end

function scene:show( event )
	local sceneGroup = self.view

	if event.phase == "did" then
	end
end

local function onKeyEvent( event )
	local phase = event.phase
	local keyName = event.keyName
	print( event.phase, event.keyName )
	if ( "back" == keyName and phase == "up" ) then
		display.remove(lines)
		lines=nil
		return true
	end
	return false
end
Runtime:addEventListener( "key", onKeyEvent )
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )


return scene