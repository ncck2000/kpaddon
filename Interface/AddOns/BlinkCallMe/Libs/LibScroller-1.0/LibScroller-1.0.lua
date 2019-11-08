
local debug = false

local MAJOR_VERSION = "LibScroller-1.0"
local MINOR_VERSION = 20160724

local MAX_PANEL = 30

local tinsert = table.insert
local tremove = table.remove

-- #AUTODOC_NAMESPACE lib

local lib, oldMinor = LibStub:NewLibrary(MAJOR_VERSION, MINOR_VERSION)
if not lib then return end -- No upgrade needed

local oldLib
if oldMinor then
	oldLib = {}
	for k,v in pairs(lib) do
		oldLib[k] = v
		lib[k] = nil
	end
end

local drawIt
local frame
local anyActive = false
local running = {}
local animations = {}
local panels = {}
local empty_panel

-- frame for events and OnUpdate
if oldLib and oldLib.frame then
	frame = oldLib.frame
	frame:SetScript("OnUpdate", nil)
	for k in pairs(frame) do
		if k ~= 0 then
			frame[k] = nil
		end
	end
else
	frame = CreateFrame("Frame", MAJOR_VERSION .. "_Frame", UIParent)
end
lib.frame = frame

lib.scrollAreas = oldLib and oldLib.scrollAreas or {}
lib.defaultScrollAreas = oldLib and oldLib.defaultScrollAreas or {}

local defaultScrollAreas = {
	{
		name = "Incoming",
		width = 40,
		height = 260,
		x = -240,
		y = -30,
		scrollTime = 3,
	},
	{
		name = "Outgoing",
		width = 40,
		height = 260,
		x = 240,
		y = -30,
		scrollTime = 3,
	},
	{
		name = "NotificationUp",
		width = 40,
		height = 160,
		x = 0,
		y = 120,
		scrollTime = 3,
	},
	{
		name = "NotificationDown",
		width = 40,
		height = 160,
		x = 0,
		y = -120,
		scrollTime = 3,
	},
	{
		name = "Sticky",
		width = 40,
		height = 90,
		x = 0,
		y = -250,
		scrollTime = 3,
	},
	{
		name = "Crit",
		width = 90,
		height = 90,
		x = 0,
		y = 0,
		scrollTime = 3,
	},
	{
		name = "Fountain",
		width = 90,
		height = 90,
		x = 0,
		y = 0,
		scrollTime = 3,
	},
}
local tmp, new, del
do
	local cache = setmetatable({},{__mode='k'})
	function new()
		local t = next(cache)
		if t then
			cache[t] = nil
			return t
		else
			return {}
		end
	end
	function del(t)
		for k in pairs(t) do
			t[k] = nil
		end
		cache[t] = true
		return nil
	end

	local t = {}
	function tmp(...)
		for k in pairs(t) do
			t[k] = nil
		end
		for i = 1, select('#', ...), 2 do
			local k = select(i, ...)
			if k then
				t[k] = select(i+1, ...)
			else
				break
			end
		end
		return t
	end
end

local function getRelateTo(align, oriRelateTo)
	if not align or align=='' then
		align = "CENTER"
	end
	if (oriRelateTo=='TOP' or oriRelateTo=='BOTTOM') and align~='CENTER' then
		return oriRelateTo..align:upper()
	end
	return oriRelateTo
end

local function getScrollArea(name, width, height, x, y, scrollTime, posFunc, addonname)
	if not name then
		return
	end
	local frame = CreateFrame("Button", nil, UIParent)
	frame.name = name
	frame.posFunc = posFunc
	frame.width = width or 100
	frame.height = height or 100
	frame.scrollTime = scrollTime or 3
	frame.x = x or 0
	frame.y = y or 0
	frame.addonname = addonname or "bScroll"
	
	frame:ClearAllPoints()
	frame:SetWidth(width)
	frame:SetHeight(height)
	frame:SetFrameStrata("BACKGROUND")
	frame:SetPoint("CENTER", x, y)
	frame:SetFrameLevel(0)
	frame:SetClampedToScreen(1)

	frame:EnableMouse(true)
	frame:RegisterForDrag("LeftButton")
	frame:RegisterForClicks("AnyUp")
	frame:SetMovable(true)
	frame:SetScript("OnDragStart", function(f) f:StartMoving() end)
	frame:SetScript("OnDragStop", function(f)
		f:StopMovingOrSizing()
		local uiParentX, uiParentY = UIParent:GetCenter()
		local myX, myY = f:GetCenter()
		local s = f:GetEffectiveScale()
		--myX, myY = myX*s, myY*s
		local xOffset = math.ceil(myX - uiParentX)
		local yOffset = math.ceil(myY - uiParentY)

		f:ClearAllPoints()
		f:SetPoint("CENTER", UIParent, "CENTER", xOffset, yOffset)
		f.text:SetText(("%s (%d,%d)"):format(f.name, xOffset, yOffset))
		f.x = xOffset
		f.y = yOffset
		if f.posFunc and type(f.posFunc)=='function' then
			f.posFunc(xOffset, yOffset)
		end
	end)
	frame:SetBackdrop({
		bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
		edgeFile = "",
		tile = true, tileSize = 5, edgeSize = 0,
		insets={left = 0, right = 0, top = 0, bottom = 0}
	})
	frame:SetBackdropColor(0.0,0,0, 0.5)

	frame:SetResizable(true)
	frame:SetMinResize(40,40)

	frame:Hide()


		sizehandle = CreateFrame("Frame", nil, frame)
		sizehandle:Show()
		sizehandle:SetFrameLevel(frame:GetFrameLevel() + 10) -- place this above everything
		sizehandle:SetWidth(7)
		sizehandle:SetHeight(7)
		sizehandle:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -1, 1)
		sizehandle:EnableMouse(true)
		
		sizehandle:SetScript("OnMouseDown", function ()
			frame.isResizing = true
			frame:StartSizing("BOTTOMRIGHT")
		end)
		sizehandle:SetScript("OnMouseUp", function ()
			frame:StopMovingOrSizing()
			if not frame.isResizing then return end -- don't do anything on frame creation
			frame.width = frame:GetWidth()
			frame.height = frame:GetHeight()
			frame.isResizing = false
			if frame.posFunc and type(frame.posFunc)=='function' then
				frame.posFunc(nil, nil, frame.width, frame.height)
			end
		end)

		sizetexture = sizehandle:CreateTexture(nil,"BACKGROUND")
		sizetexture:SetAllPoints(sizehandle)
		sizetexture:SetTexture(.5, 0, 0, .3)
		sizetexture:SetBlendMode("ADD")
		sizetexture:Show()

		frame.text = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
		frame.text:ClearAllPoints()
		frame.text:SetPoint("CENTER")
		frame.text:SetText(("%s (%d,%d)"):format(frame.name, x, y))

	return frame
end

local function createBaseFrame()
	if frame:GetScript("OnUpdate") then
		return
	end
	frame:SetFrameStrata("BACKGROUND")
	frame:SetPoint("CENTER", UIParent)
	frame:SetFrameLevel(0)

	frame:SetWidth(1)
	frame:SetHeight(1)
	frame:Hide()

	frame.timer = 0
	frame:SetScript("OnUpdate", function (self, elapsed)
		self.timer = self.timer + elapsed
		if self.timer > .01 then
			self.timer = 0
			anyActive = false
			if ( #running > 0 ) then
				for _,panel in pairs(running) do
					if ( panel:IsShown() ) then
						anyActive = true
						panel.elapsed = panel.elapsed + elapsed
						lib:DrawPanel(panel)
					end
				end
			end
			if ((anyActive ~= true) and (self:IsVisible())) then
				self:Hide()
			end
		end
	end)
end

function lib:OnLoad()
	createBaseFrame()

	local panelName
	for i=1, MAX_PANEL, 1 do
		panelName = MAJOR_VERSION.."Frame"..i
		if not _G[panelName] then
			panels[i] = frame:CreateFontString(panelName, "ARTWORK", "GameFontNormal")
			panels[i]:Hide()
		else
			panels[i] = _G[panelName]
			panels[i]:Hide()
		end
	end

	for i=1, #defaultScrollAreas do
		local sa = defaultScrollAreas[i]
		if not self:HasScrollArea(sa.name) then
			self:CreateScrollArea(sa.name, sa.width, sa.height, sa.x, sa.y, sa.scrollTime, sa.posFunc, sa.addonname)
		end
		self.defaultScrollAreas[sa.name] = true
	end
	collectgarbage("collect")
end

function lib:SetLevel(level)
	if not level then
		level = "BACKGROUND"
	end
	if level~="BACKGROUND"
	and level~="LOW"
	and level~="MEDIUM"
	and level~="HIGH"
	and level~="DIALOG"
	and level~="FULLSCREEN"
	and level~="TOOLTIP"
	then
		return
	end
	frame:SetFrameStrata(level)
end

function lib:GetAnimationTypes()
	local ats = {}
	for t, a in pairs(animations) do
		table.insert(ats, { text = (a.name or t), value = t})
	end
	return ats
end

function lib:CreateScrollArea(name, width, height, x, y, scrollTime, posFunc, addonname)
	local sa = getScrollArea(name, width, height, x, y, scrollTime, posFunc, addonname)
	if not sa then return end
	tinsert(self.scrollAreas, sa)
	self.scrollAreas[name] = sa
	return self.scrollAreas[name]
end

function lib:UpdateScrollArea(name, width, height, x, y, scrollTime, posFunc, addonname)
	if not self:HasScrollArea(name) then
		return self:CreateScrollArea(name, width, height, x, y, scrollTime, posFunc, addonname)
	end

	local sa = self:GetScrollArea(name)
	if width then
		sa:SetWidth(width)
		sa.width = width
	end
	if height then
		sa:SetHeight(height)
		sa.height = height
	end
	sa.x = x or sa.x
	sa.y = y or sa.y
	sa.scrollTime = scrollTime or sa.scrollTime
	if posFunc and type(posFunc)=='function' then
--		if sa.posFunc and type(sa.posFunc)=='function' then
--			local oldf = sa.posFunc
--			sa.posFunc = function (x, y)
--				oldf(x,y)
--				posFunc(x,y)
--			end
--		else
			sa.posFunc = posFunc
--		end
	end
	sa.addonname = addonname or sa.addonname
	sa:SetPoint("CENTER", sa.x, sa.y)
	return sa
end

function lib:IsDefaultScrollArea(name)
	return self.defaultScrollAreas[name]
end

function lib:HasScrollArea(name)
	if self.scrollAreas[name] then
		return true
	end
end

function lib:GetScrollArea(name)
	return self.scrollAreas[name]
end

function lib:GetScrollAreas()
	return self.scrollAreas
end

function lib:DeleteScrollArea(name)
	local index
	for i=1, #self.scrollAreas do
		if self.scrollAreas[i].name == name then
			index = i
			break
		end
	end
	if not index then
		return
	end
	self.scrollAreas[name]:Hide()
	tremove(self.scrollAreas, index)
	self.scrollAreas[name] = nil
end

function lib:RenameScrollArea(new, old)
	local temp = self.scrollAreas[old]
	if self.scrollAreas[new] then
		return false
	end
	for i=1, #self.scrollAreas do
		if self.scrollAreas[i].name == old then
			self.scrollAreas[i].name = new
			break
		end
	end
	self.scrollAreas[new] = temp
	return true
end

function lib:ToggleScrollAreas()
	local showAll
	for i=1, #self.scrollAreas do
		if showAll==true then
			self.scrollAreas[i]:Show()
		elseif showAll==false then
			self.scrollAreas[i]:Hide()
		else
			if self.scrollAreas[i]:IsShown() then
				self.scrollAreas[i]:Hide()
				showAll = false
			else
				self.scrollAreas[i]:Show()
				showAll = true
			end
		end
	end
end

function lib:ResetScrollAreas()
	for k, v in pairs(self.scrollAreas) do
		self.scrollAreas[k]:Hide()
		self.scrollAreas[k] = nil
	end
	for i=1, #defaultScrollAreas do
		local sa = defaultScrollAreas[i]
		if not self:HasScrollArea(sa.name) then
			self:CreateScrollArea(sa.name, sa.width, sa.height, sa.x, sa.y, sa.scrollTime, sa.posFunc, sa.addonname)
		end
		self.defaultScrollAreas[sa.name] = true
	end
end

-- 패널 움직이기
function lib:DrawPanel(panel)
	if ( panel.scrollFunction and type(panel.scrollFunction) == 'function' ) then
		drawIt = panel:scrollFunction()
	else
		if ( panel.type and animations[panel.type] ) then
			drawIt = animations[panel.type]:scroll(panel)
		else
			drawIt = animations["up"]:scroll(panel)
		end
	end
	if drawIt then
		if panel.align and panel.align=='left' then
			panel:SetPoint("LEFT", panel.area, panel.relateTo, panel.xPos + panel.xOffset, panel.yPos + panel.yOffset )
		elseif panel.align and panel.align=='right' then
			panel:SetPoint("RIGHT", panel.area, panel.relateTo, panel.xPos + panel.xOffset, panel.yPos + panel.yOffset )
		else
			panel:SetPoint("CENTER", panel.area, panel.relateTo, panel.xPos + panel.xOffset, panel.yPos + panel.yOffset )
		end
		panel:SetAlpha(panel.alpha * panel.maxAlpha)
		if panel.texture then
			panel.texture:SetAlpha(panel.alpha)
		end
	else
		self:removePanel(panel)
	end
end

-- 빈 패널 찾기
function lib:findIdlePanel()
	local anyAvail = false
	for i=1, MAX_PANEL do
		empty_panel = panels[i]
		if ( not empty_panel:IsShown() ) then
			anyAvail = true
			break
		end 
	end
	--if none availble, get oldest
	if (not anyAvail) then
		empty_panel = self:getOldestPanel()
	end

	return empty_panel
end

-- 가장오래된 패널 찾기
function lib:getOldestPanel()
	local oldestPanel = running[1]
	self:removePanel(oldestPanel)
	return oldestPanel
end

-- 패널 초기화
function lib:removePanel(panel)
	for index, value in pairs(running) do
		if ( value == panel ) then
			tremove(running, index)
			panel:SetAlpha(0)
			panel:Hide()
			panel:ClearAllPoints()
			if panel.texture then
				panel.texture:ClearAllPoints()
				panel.texture:SetTexture(nil)
			end
			break
		end
	end
end

-- 모든패널 초기화
function lib:removeAllPanels()
	for i=1, MAX_PANEL do
		panel = panels[i]
		self:removePanel(panel)
	end
end

function lib:getPanelCount(type)
	local count = 0
	for index, panel in pairs(running) do
		if ( panel.type == type ) then
			count = count + 1
		end
	end
	return count
end

-- 출력메세지 추가 : info table
function lib:Run(info)
	if ( not info ) then
		return
	end

	if info.message == '' then info.message = nil end
	if info.icon == '' then info.icon = nil end
	if not info.message and not info.icon then return end

	-- 패널 인스턴스
	local panel = self:findIdlePanel()

	local r,g,b
	r = info.r or 1.0
	g = info.g or 1.0
	b = info.b or 1.0

	-- 글자크기
	local textsize = info.textsize or 24
	local font = info.font or "Fonts\\2002b.TTF"
	local outline = info.outline or ""

	-- 패널타입
	if ( not info.type ) then
		panel.type = "up"
	else
		panel.type = info.type:lower()
	end

	-- 패널타입에 따른 스크롤함수 지정
	if ( info.scrollFunction and type(info.scrollFunction) == 'function' ) then
		panel.scrollFunction = info.scrollFunction
	end

	-- 패널 시작 시간
	panel.elapsed = 0

	-- 패널 폰트 설정
	panel.textsize = textsize

	-- 투명도
	panel.maxAlpha = (info.maxAlpha or 100) / 100

	-- 패널 초기 위치
	panel.xPos = 0
	panel.yPos = 0
	panel.xOffset = info.xOffset or 0
	panel.yOffset = info.yOffset or 0
	panel.align = info.align -- init()함수에서 필요에 따라 align값을 변경해줘야하니까 미리 대입해준다.
	panel.iconalign = info.iconalign

	-- 패널 앵커
	if ( not info.area and not getglobal(info.area) ) then
		panel.area, panel.relateTo = self:GetScrollArea(animations[panel.type].scrollArea), animations[panel.type].relateTo or "CENTER"
	else
		panel.area, panel.relateTo = info.area, info.relateTo or animations[panel.type].relateTo or "CENTER"
	end

	if not panel.area then
		return
	end

	--debug
	panel.msg = info.message

	-- 이전 패널과 너무가까우면 위치를 조절한다.
	if (panel.type and animations[panel.type] and animations[panel.type].init ) then
		animations[panel.type]:init(panel)
	end

	if panel.align=='left' then
		panel.relateTo = getRelateTo(panel.align, panel.relateTo)
		panel:SetPoint("LEFT", panel.area, panel.relateTo, panel.xPos + panel.xOffset, panel.yPos + panel.yOffset )
	elseif panel.align=='right' then
		panel.relateTo = getRelateTo(panel.align, panel.relateTo)
		panel:SetPoint("RIGHT", panel.area, panel.relateTo, panel.xPos + panel.xOffset, panel.yPos + panel.yOffset )
	else
		panel:SetPoint("CENTER", panel.area, panel.relateTo, panel.xPos + panel.xOffset, panel.yPos + panel.yOffset )
	end
	panel:SetFont(font, panel.textsize, outline)
	panel:SetTextColor(r, g, b)
	panel:SetText(info.message)
	panel:SetAlpha(0)
	panel:Show()

	-- 패널 셋팅
	if info.message then
		if ( info.icon ) then
			if ( not panel.texture ) then
				panel.texture = frame:CreateTexture(nil, "ARTWORK")
				panel.texture:ClearAllPoints()
			end
			if not info.iconborder then
				panel.texture:SetTexCoord(.1,.9,.1,.9)
			else
				panel.texture:SetTexCoord(0,1,0,1)
			end
			panel.texture:SetTexture(info.icon)
			panel.texture:SetWidth(panel.textsize)
			panel.texture:SetHeight(panel.textsize)
			if panel.iconalign=='left' then
				panel.texture:SetPoint("RIGHT", panel, "LEFT", -5, 0)
			else
				panel.texture:SetPoint("LEFT", panel, "RIGHT", 5, 0)
			end
			panel.texture:Show()
			--panel:SetWidth(panel.text:GetWidth() + panel.texture:GetWidth())
			--panel:SetHeight(panel.textsize)
		else
			if ( panel.texture ) then
				panel.texture:Hide()
			end
			--panel:SetWidth(panel.text:GetWidth())
			--panel:SetHeight(panel.textsize)
		end
	else
		if ( not panel.texture ) then
			panel.texture = frame:CreateTexture(nil, "ARTWORK")
		end
		if not info.iconborder then
			panel.texture:SetTexCoord(.1,.9,.1,.9)
		else
			panel.texture:SetTexCoord(0,1,0,1)
		end
		panel.texture:ClearAllPoints()
		panel.texture:SetTexture(info.icon)
		panel.texture:SetWidth(panel.textsize)
		panel.texture:SetHeight(panel.textsize)
		panel.texture:SetPoint("CENTER", panel, "CENTER")
		panel.texture:Show()
	end

	tinsert(running, panel)

	-- 애드온 Showing
	if (not frame:IsVisible()) then
		frame:Show()
	end

end

function lib:AddAnimation(info)
	if ( not info or not info.type ) then
		return
	end
	if ( animations[info.type] ) then
		return
	end
	animations[info.type] = info
end

function lib:ToggleMovingArea(AniType)
	if not AniType then return end
	if animations and
		animations[AniType] and
		animations[AniType].toggleArea and
		type(animations[AniType].toggleArea)=='function' then
		animations[AniType]:toggleArea()
	end
end

local info
function lib:Display(...)
	if type(select(1,...))=='table' then
		info = select(1,...)
	else
		info = tmp(...)
	end
	if ( not info ) then
		return
	end
	lib:Run(info)
end

-- scroll up
lib:AddAnimation{
	name = "위로",
	type = "up",
	scrollArea = "NotificationUp",
	relateTo = "BOTTOM",
	scroll = function (self, panel)
		local elapsed = panel.elapsed
		local position, alpha
		local scrollTime = panel.area.scrollTime or 3 --self.default.scrollTime
		local fadeInTime = 0.75 --self.default.fadeInTime
		local fadeOutTime = 1.1 --self.default.fadeOutTime
		local holdTime = scrollTime - fadeInTime - fadeOutTime
		local range = panel.area.height --:GetHeight()

		if ( elapsed < fadeInTime ) then
			alpha = (elapsed / fadeInTime)
		elseif ( elapsed < (fadeInTime + holdTime) ) then
			alpha = 1.0
		elseif ( elapsed < (fadeInTime + holdTime + fadeOutTime) ) then
			alpha = 1.0 - ((elapsed - holdTime - fadeInTime) / fadeOutTime)
		else
			return false
		end

		position = math.floor(range * (elapsed / scrollTime))
		panel.alpha = alpha
		panel.yPos = position
		return true
	end,

	init = function (self, panel)
		if not panel.area or not panel.area.height then
			return
		end
		local panelCount = #running
		local prevPanel, topTimePrev
		local perPixelTime = (panel.area.scrollTime or 3) / panel.area.height --:GetHeight()
		local currentPanel = panel
		local spacing = 8 --self.default.spacing -- 8

		for i=panelCount, 1, -1 do
			if ( running[i].type == panel.type and running[i].area==panel.area ) then
				prevPanel = running[i]
				topTimePrev = prevPanel.elapsed - (prevPanel.textsize + spacing) * perPixelTime
				if (topTimePrev < currentPanel.elapsed) then
					prevPanel.elapsed = currentPanel.elapsed + (prevPanel.textsize + spacing) * perPixelTime
				else
					return
				end
				currentPanel = prevPanel
			end
		end
	end,
}

-- scroll down
lib:AddAnimation{
	name = "아래로",
	type = "down",
	scrollArea = "NotificationDown",
	relateTo = "TOP",
	scroll = function (self, panel)
		local elapsed = panel.elapsed
		local position, alpha
		local fadeInTime = .75 --self.default.fadeInTime
		local fadeOutTime = 1.1 --self.default.fadeOutTime
		local scrollTime = panel.area.scrollTime or 3 --self.default.scrollTime
		local range = panel.area.height --:GetHeight()
		local holdTime = scrollTime - fadeInTime - fadeOutTime

		if ( elapsed < fadeInTime ) then
			alpha = (elapsed / fadeInTime)
		elseif ( elapsed < (fadeInTime + holdTime) ) then
			alpha = 1.0
		elseif ( elapsed < (fadeInTime + holdTime + fadeOutTime) ) then
			alpha = 1.0 - ((elapsed - holdTime - fadeInTime) / fadeOutTime)
		else
			return false
		end

		position = math.floor(range * (elapsed / scrollTime))
		panel.alpha = alpha
		panel.yPos = -1*position
		return true
	end,

	init = function (self, panel)
		if not panel.area or not panel.area.height then
			return
		end
		local panelCount = #running
		local prevPanel, topTimeCurrent
		local perPixelTime = (panel.area.scrollTime or 3) / panel.area.height
		local currentPanel = panel
		local spacing = 8 --self.default.spacing

		for i=panelCount, 1, -1 do
			if ( running[i].type == panel.type and running[i].area==panel.area ) then
				prevPanel = running[i]
				topTimeCurrent = currentPanel.elapsed + (currentPanel.textsize + spacing) * perPixelTime
				if ( prevPanel.elapsed < topTimeCurrent ) then
					prevPanel.elapsed = topTimeCurrent
				else
					return
				end
				currentPanel = prevPanel
			end
		end
	end,
}

-- sticky and jiggle
lib:AddAnimation{
	name = "고정 - 위로",
	type = "sticky",
	scrollArea = "Sticky",
	relateTo = "BOTTOM",
	JIGGLE_DELAY_TIME = 0.05,
	scroll = function (self,panel)
		local elapsed = panel.elapsed
		local fadeOutTime = 1.0 --self.default.fadeOutTime
		local scrollTime = panel.area.scrollTime or 3 --self.default.scrollTime
		local holdTime = scrollTime - fadeOutTime --self.default.holdTime
		local alpha
		if ( elapsed < holdTime ) then
			alpha = 1.0
			if (elapsed - panel.timeLastJiggled > self.JIGGLE_DELAY_TIME) then
				panel.xPos = panel.xOriginalPos + math.ceil(math.random(-1, 1))
				panel.yPos = panel.yOriginalPos + math.ceil(math.random(-1, 1))
				panel.timeLastJiggled = elapsed
			end
		elseif ( elapsed < scrollTime ) then
			alpha = 1.0 - ((elapsed - holdTime) / fadeOutTime)
			panel.xPos = panel.xOriginalPos
			panel.yPos = panel.yOriginalPos
		else
			return false
		end
		panel.alpha = alpha
		return true
	end,

	init = function (self, panel)
		local prevPanel, topTimeCurrent
		local currentPanel
		local spacing = 3 --self.default.spacing
		local showingTime = panel.area.scrollTime or 3 --self.default.scrollTime

		panel.xPos = 0
		panel.yPos = 0
		panel.timeLastJiggled = -1
		panel.xOriginalPos = panel.xPos
		panel.yOriginalPos = panel.yPos
		panel.pos = 1
		currentPanel = panel

		for i=#running, 1, -1 do
			if ( running[i].type == panel.type and running[i].area==panel.area ) then
				prevPanel = running[i]
				prevPanel.yOriginalPos = prevPanel.yOriginalPos + prevPanel:GetHeight() + spacing
				currentPanel = prevPanel
			end
		end
	end,
}

-- sticky and jiggle
lib:AddAnimation{
	name = "고정 - 아래로",
	type = "stickydown",
	scrollArea = "Sticky",
	relateTo = "TOP",
	JIGGLE_DELAY_TIME = 0.05,
	scroll = function (self,panel)
		local elapsed = panel.elapsed
		local fadeOutTime = 1.0 --self.default.fadeOutTime
		local scrollTime = panel.area.scrollTime or 3 --self.default.scrollTime
		local holdTime = scrollTime - fadeOutTime --self.default.holdTime
		local alpha
		if ( elapsed < holdTime ) then
			alpha = 1.0
			if (elapsed - panel.timeLastJiggled > self.JIGGLE_DELAY_TIME) then
				panel.xPos = panel.xOriginalPos + math.ceil(math.random(-1, 1))
				panel.yPos = panel.yOriginalPos + math.ceil(math.random(-1, 1))
				panel.timeLastJiggled = elapsed
			end
		elseif ( elapsed < scrollTime ) then
			alpha = 1.0 - ((elapsed - holdTime) / fadeOutTime)
			panel.xPos = panel.xOriginalPos
			panel.yPos = panel.yOriginalPos
		else
			return false
		end
		panel.alpha = alpha
		return true
	end,

	init = function (self, panel)
		local prevPanel, topTimeCurrent
		local currentPanel
		local spacing = 3 --self.default.spacing
		local showingTime = panel.area.scrollTime or 3 --self.default.scrollTime

		panel.xPos = 0
		panel.yPos = 0
		panel.timeLastJiggled = -1
		panel.xOriginalPos = panel.xPos
		panel.yOriginalPos = panel.yPos
		panel.pos = 1
		currentPanel = panel

		for i=#running, 1, -1 do
			if ( running[i].type == panel.type and running[i].area==panel.area ) then
				prevPanel = running[i]
				prevPanel.yOriginalPos = prevPanel.yOriginalPos - prevPanel:GetHeight() - spacing
				currentPanel = prevPanel
			end
		end
	end,
}

-- crit effect
lib:AddAnimation{
	name = "치명타효과",
	type = "crit",
	scrollArea = "Crit",
	relateTo = "CENTER",
	matrix = {{0,0},{-1,1},{1,1},{-1,-1},{1,-1},{-2,0},{2,0},{0,2},{0,-2}},
	scroll = function (self, panel)
		local elapsed = panel.elapsed
		local alpha
		local textsize = panel.textsize
		local increaseTime = .1 --self.default.increaseTime
		local decreaseTime = .1 --self.default.decreaseTime
		local fadeOutTime = 1.0 --self.default.fadeOutTime
		local scrollTime = 2.45 --self.default.scrollTime -- panel.area.scrollTime or self.default.scrollTime
		local holdTime = scrollTime - increaseTime - decreaseTime - fadeOutTime

		if ( elapsed < increaseTime ) then
			alpha = 1.0
			textsize = textsize * (elapsed / increaseTime) * 1.5
			panel:SetTextHeight(textsize)
			if panel.texture and panel.texture:IsShown() then
				panel.texture:SetWidth(textsize)
				panel.texture:SetHeight(textsize)
				if not panel:GetText() then
					panel.texture:SetPoint("CENTER", panel, "CENTER")
				else
					if panel.iconalign=='left' then
						panel.texture:SetPoint("RIGHT", panel, "LEFT", -5, 0)
					else
						panel.texture:SetPoint("LEFT", panel, "RIGHT", 5, 0)
					end
				end
			end
		elseif ( elapsed < (increaseTime + decreaseTime) ) then
			alpha = 1.0
			textsize = (textsize * 1.5) - ((elapsed - increaseTime) / decreaseTime * (textsize*0.5))
			panel:SetTextHeight(textsize)
			if panel.texture and panel.texture:IsShown() then
				panel.texture:SetWidth(textsize)
				panel.texture:SetHeight(textsize)
				if not panel:GetText() then
					panel.texture:SetPoint("CENTER", panel, "CENTER")
				else
					if panel.iconalign=='left' then
						panel.texture:SetPoint("RIGHT", panel, "LEFT", -5, 0)
					else
						panel.texture:SetPoint("LEFT", panel, "RIGHT", 5, 0)
					end
				end
			end
		elseif ( elapsed < (increaseTime + decreaseTime + holdTime) ) then
			alpha = 1.0
		elseif ( elapsed < (increaseTime + decreaseTime + holdTime + fadeOutTime) ) then
			alpha = 1.0 - ((elapsed - increaseTime - decreaseTime - holdTime) / fadeOutTime)
		else
			return false
		end
		if textsize <= 0 then
			textsize = 1
		end

		panel.alpha = alpha
		return true
	end,

	init = function (self, panel)
		local xy
		local yOffset = 30 --panel.area.height / 4 -- self.default.yOffset
		local xOffset = 50 --panel.area.width / 4 --self.default.xOffset

		panel.align = 'center' -- 크리효과는 항상 가운데 정렬해야함.

		local r = math.random(1,9)
		xy = self.matrix[r]
		panel.xPos = xy[1]*xOffset
		panel.yPos = xy[2]*yOffset
		panel.myPos = r

	end,
}

-- 분수모양 스크롤 from CombatText - Blizzard
lib:AddAnimation{
	name = "분수효과",
	type = "fountain",
	scrollArea = "Crit",
	relateTo = "BOTTOM",
	radius = 160,
	scroll = function (self, panel)
		local alpha
		local elapsed = panel.elapsed
		local scrollTime = panel.area.scrollTime or 2 --self.default.scrollTime
		local fadeOutTime = .9 --self.default.fadeOutTime

		if ( elapsed < (scrollTime-fadeOutTime) ) then
			alpha = 1.0
		elseif ( elapsed < scrollTime ) then
			alpha = 1.0 - ((elapsed - (scrollTime-fadeOutTime)) / fadeOutTime)
		elseif ( elapsed >= scrollTime ) then
			return false
		end

		local xPos = panel.xDir * ( self.radius * cos(90 * elapsed / scrollTime) ) - panel.xDir * self.radius
		local yPos = self.radius * sin(90 * elapsed / scrollTime)

		panel.alpha = alpha
		panel.xPos = xPos
		panel.yPos = yPos
		return true
	end,

	init = function (self, panel)
		local panelCount = #running
		local prevPanel, topTimePrev
		local scrollTime = panel.area.scrollTime or self.default.scrollTime
		local spacing = 8 --self.default.spacing
		local perPixelTime = scrollTime / self.radius
		local currentPanel = panel

		if ( not panel.area.lastXDir or panel.area.lastXDir == -1 ) then
			panel.xDir = 1
			--panel.align = 'right'
			panel.area.lastXDir = 1
		else
			panel.xDir = -1
			--panel.align = 'left'
			panel.area.lastXDir = -1
		end

		for i=panelCount, 1, -1 do
			if ( running[i].type == panel.type and running[i].xDir == panel.xDir and running[i].area == panel.area ) then
				prevPanel = running[i]
				topTimePrev = prevPanel.elapsed - (prevPanel.textsize + spacing) * perPixelTime
				if (topTimePrev < currentPanel.elapsed) then
					prevPanel.elapsed = currentPanel.elapsed + (prevPanel.textsize + spacing) * perPixelTime
				else
					return
				end
				currentPanel = prevPanel
			end
		end
	end,
}

-- parabola left up
lib:AddAnimation{
	name = "왼쪽 곡선 위로",
	type = "curveleftup",
	scrollArea = "Incoming",
	relateTo = "RIGHT",
	midPoint = 0,
	fourA = 0,
	scroll = function (self, panel)
		local elapsed = panel.elapsed
		local position, alpha
		local fadeInTime = .75 --self.default.fadeInTime
		local fadeOutTime = 1.1 --self.default.fadeOutTime
		local scrollTime = panel.area.scrollTime or 3 --self.default.scrollTime
		local height = panel.area.height
		local width = panel.area.width
		local holdTime = scrollTime - fadeInTime - fadeOutTime

		if ( elapsed < fadeInTime ) then
			alpha = (elapsed / fadeInTime)
		elseif ( elapsed < (fadeInTime + holdTime) ) then
			alpha = 1.0
		elseif ( elapsed < (fadeInTime + holdTime + fadeOutTime) ) then
			alpha = 1.0 - ((elapsed - holdTime - fadeInTime) / fadeOutTime)
		else
			return false
		end

		position = math.floor(height * (elapsed / scrollTime))
		panel.alpha = alpha
		panel.yPos = position
		local y = position - self.midPoint
		panel.yPos = position - (height/2)
		panel.xPos = (y * y) / self.fourA - width
		return true
	end,

	init = function (self, panel)
		if not panel.area or not panel.area.height then
			return
		end
		local scrollTime = panel.area.scrollTime or 3 --self.default.scrollTime
		local height = panel.area.height
		local width = panel.area.width
		local spacing = 8 --self.default.spacing

		local panelCount = #running
		local prevPanel, topTimePrev
		local perPixelTime = scrollTime / height
		local currentPanel = panel
		local midPoint = height / 2
		self.midPoint = midPoint
		self.fourA = (midPoint * midPoint) / width
		panel.xPos = 0
		panel.yPos = 0 - height/2
		for i=panelCount, 1, -1 do
			if ( running[i].type == panel.type and running[i].area==panel.area ) then
				prevPanel = running[i]
				topTimePrev = prevPanel.elapsed - (prevPanel.textsize + spacing) * perPixelTime
				if (topTimePrev < currentPanel.elapsed) then
					prevPanel.elapsed = currentPanel.elapsed + (prevPanel.textsize + spacing) * perPixelTime
				else
					return
				end
				currentPanel = prevPanel
			end
		end
	end,
}

-- parabola left down
lib:AddAnimation{
	name = "왼쪽 곡선 아래로",
	type = "curveleftdown",
	scrollArea = "Incoming",
	relateTo = "RIGHT",
	midPoint = 0,
	fourA = 0,
	scroll = function (self, panel)
		local elapsed = panel.elapsed
		local position, alpha
		local fadeInTime = .75 --self.default.fadeInTime
		local fadeOutTime = 1.1 --self.default.fadeOutTime
		local scrollTime = panel.area.scrollTime or 3 --self.default.scrollTime
		local height = panel.area.height
		local width = panel.area.width
		local holdTime = scrollTime - fadeInTime - fadeOutTime

		if ( elapsed < fadeInTime ) then
			alpha = (elapsed / fadeInTime)
		elseif ( elapsed < (fadeInTime + holdTime) ) then
			alpha = 1.0
		elseif ( elapsed < (fadeInTime + holdTime + fadeOutTime) ) then
			alpha = 1.0 - ((elapsed - holdTime - fadeInTime) / fadeOutTime)
		else
			return false
		end

		position = math.floor(height * (elapsed / scrollTime))
		panel.alpha = alpha
		local y = position - self.midPoint
		panel.yPos = -1*position + height/2
		panel.xPos = (y * y) / self.fourA - width
		return true
	end,

	init = function (self, panel)
		if not panel.area or not panel.area.height then
			return
		end
		local scrollTime = panel.area.scrollTime or 3 --self.default.scrollTime
		local height = panel.area.height
		local width = panel.area.width
		local spacing = 8 --self.default.spacing

		local panelCount = #running
		local prevPanel, topTimeCurrent
		local perPixelTime = scrollTime / height
		local currentPanel = panel
		local midPoint = height / 2
		self.midPoint = midPoint
		self.fourA = (midPoint * midPoint) / width
		panel.xPos = 0
		panel.yPos = height/2

		for i=panelCount, 1, -1 do
			if ( running[i].type == panel.type and running[i].area==panel.area ) then
				prevPanel = running[i]
				topTimeCurrent = currentPanel.elapsed + (currentPanel.textsize + spacing) * perPixelTime
				if ( prevPanel.elapsed < topTimeCurrent ) then
					prevPanel.elapsed = topTimeCurrent
				else
					return
				end
				currentPanel = prevPanel
			end
		end
	end,
}

-- parabola right up
lib:AddAnimation{
	name = "오른쪽 곡선 위로",
	type = "curverightup",
	scrollArea = "Outgoing",
	relateTo = "LEFT",
	fourA = 0,
	midPoint = 0,
	scroll = function (self, panel)
		local elapsed = panel.elapsed
		local position, alpha
		local fadeInTime = .75 --self.default.fadeInTime
		local fadeOutTime = 1.1 --self.default.fadeOutTime
		local scrollTime = panel.area.scrollTime or 3 --self.default.scrollTime
		local height = panel.area.height
		local width = panel.area.width
		local holdTime = scrollTime - fadeInTime - fadeOutTime

		if ( elapsed < fadeInTime ) then
			alpha = (elapsed / fadeInTime)
		elseif ( elapsed < (fadeInTime + holdTime) ) then
			alpha = 1.0
		elseif ( elapsed < (fadeInTime + holdTime + fadeOutTime) ) then
			alpha = 1.0 - ((elapsed - holdTime - fadeInTime) / fadeOutTime)
		else
			return false
		end

		position = math.floor(height * (elapsed / scrollTime))
		panel.alpha = alpha
		local y = position - self.midPoint
		panel.yPos = position - height/2
		panel.xPos = width - (y * y) / self.fourA
		return true
	end,

	init = function (self, panel)
		if not panel.area or not panel.area.height then
			return
		end
		local scrollTime = panel.area.scrollTime or 3 --self.default.scrollTime
		local height = panel.area.height
		local width = panel.area.width
		local spacing = 8 --self.default.spacing

		local panelCount = #running
		local prevPanel, topTimePrev
		local perPixelTime = scrollTime / height
		local currentPanel = panel
		local midPoint = height / 2
		self.midPoint = midPoint
		self.fourA = (midPoint * midPoint) / width
		panel.xPos = 0
		panel.yPos = 0 - height/2
		for i=panelCount, 1, -1 do
			if ( running[i].type == panel.type and running[i].area==panel.area ) then
				prevPanel = running[i]
				topTimePrev = prevPanel.elapsed - (prevPanel.textsize + spacing) * perPixelTime
				if (topTimePrev < currentPanel.elapsed) then
					prevPanel.elapsed = currentPanel.elapsed + (prevPanel.textsize + spacing) * perPixelTime
				else
					return
				end
				currentPanel = prevPanel
			end
		end
	end,
}

-- parabola left down
lib:AddAnimation{
	name = "오른쪽 곡선 아래로",
	type = "curverightdown",
	scrollArea = "Outgoing",
	relateTo = "LEFT",
	midPoint = 0,
	fourA = 0,
	scroll = function (self, panel)
		local elapsed = panel.elapsed
		local position, alpha

		local fadeInTime = .75 --self.default.fadeInTime
		local fadeOutTime = 1.1 --self.default.fadeOutTime
		local scrollTime = panel.area.scrollTime or 3 --self.default.scrollTime
		local height = panel.area.height
		local width = panel.area.width

		local holdTime = scrollTime - fadeInTime - fadeOutTime

		if ( elapsed < fadeInTime ) then
			alpha = (elapsed / fadeInTime)
		elseif ( elapsed < (fadeInTime + holdTime) ) then
			alpha = 1.0
		elseif ( elapsed < (fadeInTime + holdTime + fadeOutTime) ) then
			alpha = 1.0 - ((elapsed - holdTime - fadeInTime) / fadeOutTime)
		else
			return false
		end

		position = math.floor(height * (elapsed / scrollTime))
		panel.alpha = alpha
		local y = position - self.midPoint
		panel.yPos = -1*position + height/2
		panel.xPos = width - (y * y) / self.fourA -- + 200
		return true
	end,

	init = function (self, panel)
		if not panel.area or not panel.area.height then
			return
		end
		local scrollTime = panel.area.scrollTime or 3 --self.default.scrollTime
		local height = panel.area.height
		local width = panel.area.width
		local spacing = 8 --self.default.spacing

		local panelCount = #running
		local prevPanel, topTimeCurrent
		local perPixelTime = scrollTime / height
		local currentPanel = panel
		local midPoint = height / 2
		self.midPoint = midPoint
		self.fourA = (midPoint * midPoint) / width
		panel.xPos = 0
		panel.yPos = height/2
		for i=panelCount, 1, -1 do
			if ( running[i].type == panel.type and running[i].area==panel.area ) then
				prevPanel = running[i]
				topTimeCurrent = currentPanel.elapsed + (currentPanel.textsize + spacing) * perPixelTime
				if ( prevPanel.elapsed < topTimeCurrent ) then
					prevPanel.elapsed = topTimeCurrent
				else
					return
				end
				currentPanel = prevPanel
			end
		end
	end,
}


lib:OnLoad()

--lib:ToggleMovingArea("curveleftdown")
--lib:ToggleMovingArea("curveleftup")
--lib:ToggleMovingArea("curverightup")
--
--lib:ToggleMovingArea("curveleftdown")
--lib:ToggleMovingArea("curverightdown")

--function bScroll:OpenAll()
--	bScroll:ToggleMovingArea("text", "up")
--	bScroll:ToggleMovingArea("text", "down")
--	bScroll:ToggleMovingArea("text", "crit")
--	bScroll:ToggleMovingArea("text", "fountain")
--	bScroll:ToggleMovingArea("text", "sticky")
--	bScroll:ToggleMovingArea("text", "curveleftup")
--	bScroll:ToggleMovingArea("text", "curveleftdown")
--	bScroll:ToggleMovingArea("text", "curverightup")
--	bScroll:ToggleMovingArea("text", "curverightdown")
--	bScroll:Set("text", "curverightdown", "scrollTime", 3)
--	bScroll:Set("text", "curverightdown", "height", 260)
--	bScroll:Set("text", "curverightdown", "width", 40)
--end
--
--function bScroll:Test()
--	bScroll:Display('action', 'text','message', 'TEST MESSAGE1','textsize', 24,'type', 'up')
--	bScroll:Display('action', 'text','message', 'TEST MESSAGE2','textsize', 24,'type', 'up')
--	bScroll:Display('action', 'text','message', 'TEST MESSAGE3','textsize', 24,'type', 'up')
----	bScroll:Display('action', 'text','message', 'TEST MESSAGE','textsize', 24,'type', 'down')
----	bScroll:Display('action', 'text','message', 'TEST MESSAGE1','textsize', 24,'type', 'crit')
----	bScroll:Display('action', 'text','message', 'TEST MESSAGE2','textsize', 24,'type', 'crit')
----	bScroll:Display('action', 'text','message', 'TEST MESSAGE3','textsize', 24,'type', 'crit')
----	bScroll:Display('action', 'text','message', 'TEST MESSAGE4','textsize', 24,'type', 'crit')
----	bScroll:Display('action', 'text','message', 'TEST MESSAGE1','textsize', 24,'type', 'fountain')
----	bScroll:Display('action', 'text','message', 'TEST MESSAGE2','textsize', 24,'type', 'fountain')
----	bScroll:Display('action', 'text','message', 'TEST MESSAGE1','textsize', 24,'type', 'sticky')
----	bScroll:Display('action', 'text','message', 'TEST MESSAGE2','textsize', 24,'type', 'sticky')
----	bScroll:Display('action', 'text','message', 'TEST MESSAGE3','textsize', 24,'type', 'sticky')
--end
------
----/run bScroll:ToggleMovingArea("text", "up")
----/run bScroll:ToggleMovingArea("text", "down")
----/run bScroll:ToggleMovingArea("text", "crit")
----/run bScroll:ToggleMovingArea("text", "fountain")
----/run bScroll:ToggleMovingArea("text", "sticky")
----
----/run bScroll:Display('action', 'text','message', 'TEST MESSAGE','textsize', 24,'type', 'up')
----/run bScroll:Display('action', 'text','message', 'TEST MESSAGE','textsize', 24,'type', 'down')
----/run bScroll:Display('action', 'text','message', 'TEST MESSAGE','textsize', 24,'type', 'crit')
----/run bScroll:Display('action', 'text','message', 'TEST MESSAGE','textsize', 24,'type', 'fountain')
----/run bScroll:Display('action', 'text','message', 'TEST MESSAGE','textsize', 24,'type', 'sticky')
----/run bScroll:Display('action', 'text','message', 'TEST MESSAGE','textsize', 24,'type', 'curveleftup')
----/run bScroll:Display('action', 'text','message', 'TEST MESSAGE','textsize', 24,'type', 'curveleftdown')
----/run bScroll:Display('action', 'text','message', 'TEST MESSAGE','textsize', 24,'type', 'curverightup')
----/run bScroll:Display('action', 'text','message', 'TEST MESSAGE','textsize', 24,'type', 'curverightdown')