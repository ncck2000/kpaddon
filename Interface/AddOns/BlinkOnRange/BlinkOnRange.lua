-------------------------------------------------------------------------------
--
--  Mod Name : BlinkOnRange v3.0
--  Author   : Blink
--  Date     : 2005/05/31
--  LastUpdate : 2008/03/16
--
-------------------------------------------------------------------------------

local frame
local addonname = "BlinkOnRange"

local fSpells = {}
local hSpells = {}
local currSpells = {}
local myclass = select(2, UnitClass("player"))
local RegistGUI
local primary
local defaultDB = {
	version = 1.01,
	enable = true,
	lock = false,
	fmt = "%i %s (%c)",
	x = 0,
	y = -80,
	
	spec = {
		{ fspell = "", hspell = "", },
		{ fspell = "", hspell = "", },
		{ fspell = "", hspell = "", },
		{ fspell = "", hspell = "", },
	},
}

local function SpellScan()
	local hostileSpell = BOR_CLASS_SPELLS[myclass].hostile
	local friendlySpell = BOR_CLASS_SPELLS[myclass].friendly

	for k, v in pairs(hSpells) do hSpells[k] = nil end
	for k, v in pairs(fSpells) do fSpells[k] = nil end

	local name, icon, cost, costType, costInfo
	local count = 0
	if hostileSpell then
		for k, v in pairs(hostileSpell) do
			if v==0 or v==primary then
				name, _, icon = GetSpellInfo(k)
				costInfo = GetSpellPowerCost(k)

				if costInfo and costInfo[1] then
					cost = costInfo[1].minCost
					costType = costInfo[1].type
				else
					cost = 0
					costType = nil
				end

				if name then
					hSpells[k] = {
						cost = cost,
						costType = costType,
						icon = icon
					}
					count = count + 1
				end
			end
		end
	end
	if friendlySpell then
		for k, v in pairs(friendlySpell) do
			if v==0 or v==primary then
				name, _, icon = GetSpellInfo(k)
				costInfo = GetSpellPowerCost(k)
				if costInfo and costInfo[1] then
					cost = costInfo[1].minCost
					costType = costInfo[1].type
				else
					cost = 0
					costType = nil
				end
				if name then
					fSpells[k] = {
						cost = cost,
						costType = costType,
						icon = icon
					}
					count = count + 1
				end
			end
		end
	end
	return count
end

local function DrawFrame(frame)
	frame:ClearAllPoints();
	frame:SetPoint("CENTER", (BOR_Config.x or 0), (BOR_Config.y or -80))
	frame:SetWidth(100)
	frame:SetHeight(30)
	frame:SetFrameStrata("BACKGROUND")
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
		local xOffset = math.ceil(myX - uiParentX)
		local yOffset = math.ceil(myY - uiParentY)

		f:ClearAllPoints()
		f:SetPoint("CENTER", xOffset, yOffset)
		BOR_Config.x = xOffset
		BOR_Config.y = yOffset
	end)

	frame:SetBackdrop({
		bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		tile = true, tileSize = 16, edgeSize = 16,
		insets={left = 4, right = 4, top = 4, bottom = 4}
	})
	frame:SetBackdropBorderColor(0.5, 0.5, 0.5, 0.5)
	frame:SetBackdropColor(TOOLTIP_DEFAULT_BACKGROUND_COLOR.r, TOOLTIP_DEFAULT_BACKGROUND_COLOR.g, TOOLTIP_DEFAULT_BACKGROUND_COLOR.b, 0.5)

	frame.text = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	frame.text:ClearAllPoints()
	frame.text:SetPoint("CENTER")
	frame.text:SetText("")
end

local function FrameLock(frame, t)
	if t then
		frame:EnableMouse(false)
		frame:SetMovable(false)
		frame:SetBackdropBorderColor(0.5, 0.5, 0.5, 0)
		frame:SetBackdropColor(TOOLTIP_DEFAULT_BACKGROUND_COLOR.r, TOOLTIP_DEFAULT_BACKGROUND_COLOR.g, TOOLTIP_DEFAULT_BACKGROUND_COLOR.b, 0)
	else
		frame:EnableMouse(true)
		frame:SetMovable(true)
		frame:SetBackdropBorderColor(0.5, 0.5, 0.5, 0.5)
		frame:SetBackdropColor(TOOLTIP_DEFAULT_BACKGROUND_COLOR.r, TOOLTIP_DEFAULT_BACKGROUND_COLOR.g, TOOLTIP_DEFAULT_BACKGROUND_COLOR.b, 0.5)
	end
end

local pendingChange = false
local loadded = false
local function frameOnEvent(self, event, ...)
	local arg1, arg2, arg3 = ...
	if event == "VARIABLES_LOADED" then
		pendingChange = true
		--primary = GetSpecialization();
		primary = 1;
		if UnitExists("target") and BOR_Config and BOR_Config.enable then
			self:Show()
		else
			self:Hide()
		end
	elseif event == "SPELLS_CHANGED" then
		pendingChange = true
	elseif event == "PLAYER_TARGET_CHANGED" then
		if UnitExists("target") and BOR_Config and BOR_Config.enable then
			self:Show()
		else
			self:Hide()
		end
		return
	elseif event == "PLAYER_SPECIALIZATION_CHANGED" and arg1=="player" then
		if BOR_Config and BOR_Config.enable then
			--primary = GetSpecialization();
			primary = 1;
			if BOR_Config.spec and BOR_Config.spec[primary] then
				currSpells = {
					hspell = BOR_Config.spec[primary].hspell,
					fspell = BOR_Config.spec[primary].fspell,
				}
			else
				pendingChange = true
			end
		end
	end

	if (pendingChange and not InCombatLockdown()) then
		pendingChange = false
		local count = SpellScan()
		-- primary = GetSpecialization()
		primary = 1;
		if not loadded and count > 0 then
			if not BOR_Config or not BOR_Config.version or BOR_Config.version<defaultDB.version then
				BOR_Config = {}
				BOR_Config.version = defaultDB.version
				BOR_Config.enable = defaultDB.enable
				BOR_Config.lock = defaultDB.lock
				BOR_Config.x = defaultDB.x
				BOR_Config.y = defaultDB.y

				BOR_Config.fmt = defaultDB.fmt
				BOR_Config.spec = {{ fspell = "", hspell = "", },{ fspell = "", hspell = "", },{ fspell = "", hspell = "", },{ fspell = "", hspell = "", },}
				for k, v in pairs(hSpells) do
					BOR_Config.spec[1].hspell = k;
					BOR_Config.spec[2].hspell = k;
					BOR_Config.spec[3].hspell = k;
					BOR_Config.spec[4].hspell = k;
					break;
				end
				for k, v in pairs(fSpells) do
					BOR_Config.spec[1].fspell = k;
					BOR_Config.spec[2].fspell = k;
					BOR_Config.spec[3].fspell = k;
					BOR_Config.spec[4].fspell = k;
					break;
				end
			end

			primary = primary>0 and primary or 1
			currSpells.hspell = BOR_Config.spec[primary].hspell
			currSpells.fspell = BOR_Config.spec[primary].fspell

			DrawFrame(self)
			FrameLock(self, BOR_Config.lock)
			RegistGUI()
			if not BOR_Config.enable then
				self:Hide()
			end
			loadded = true
		end
	end
end

local text, spellname, spellcount, spellicon
local function frameOnUpdate(self, elapsed)
	if not BOR_Config or not BOR_Config.enable or not loadded then return end
	self.timer = self.timer + elapsed
	if self.timer > 0.333 then
		self.timer = 0
		text = BOR_Config.fmt or defaultDB.fmt
		spellname, spellcount, spellicon, count = "", "", "", 0
		if ( UnitExists("target") and UnitCanAttack("player","target") and not UnitIsDead("target")  and UnitIsVisible("target") ) then
			if currSpells.hspell and hSpells[currSpells.hspell] then
				if ( IsSpellInRange( currSpells.hspell, "target" ) == 1 ) then
					spellname = currSpells.hspell
					spellicon = hSpells[currSpells.hspell].icon
					cost = hSpells[currSpells.hspell].cost
					if ( cost > 0 ) then

						if hSpells[currSpells.hspell].costType == SPELL_POWER_RUNES then
							for i = 1, 7 do
								_, _, runeReady = GetRuneCooldown(i)
								if runeReady then
									count = count + 1
								end
							end
						else
							count = floor(UnitPower("player", hSpells[currSpells.hspell].costType)/cost)
						end
						if ( count > 0 ) then
							spellcount = count
						else
							spellcount = ""
						end
					else
						spellcount = "∞"
					end
				end
			end
		elseif ( UnitExists("target") and UnitIsFriend("player","target") and not UnitIsUnit("player","target") and UnitIsPlayer("target") and UnitIsVisible("target") ) then
			if currSpells.fspell and fSpells[currSpells.fspell] then
				if ( IsSpellInRange( currSpells.fspell, "target" ) == 1 ) then
					spellname = currSpells.fspell
					spellicon = fSpells[currSpells.fspell].icon
					cost = fSpells[currSpells.fspell].cost
					if ( cost > 0 ) then
						local count = floor(UnitPower("player", fSpells[currSpells.fspell].costType)/cost)
						if ( count > 0 ) then
							spellcount = count
						else
							spellcount = ""
						end
					else
						spellcount = "∞"
					end
				end
			end
		end
		if spellname then
			text = text:gsub("%%s", spellname)
		end
		text = text:gsub("%%s", "")
		
		if spellcount then
			text = text:gsub("%%c", spellcount)
		end
		text = text:gsub("%%c", "")

		if spellicon then
			text = text:gsub("%%i", "|T"..spellicon..":18|t")
		end
		text = text:gsub("%%i", "")
		text = text:gsub("%(%)", "")
		text = text:gsub("%[%]", "")

		self.text:SetText(text:trim())
		local width = self.text:GetWidth()+20
		if width < 80 then width = 80 end
		self:SetWidth(width)
	end
end

frame = CreateFrame("Button", nil, UIParent)
frame.timer = 0
frame:RegisterEvent("VARIABLES_LOADED")
frame:RegisterEvent("SPELLS_CHANGED")
frame:RegisterEvent("PLAYER_REGEN_ENABLED")
frame:RegisterEvent("PLAYER_TARGET_CHANGED")
--frame:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
frame:SetScript("OnEvent", frameOnEvent)
frame:SetScript("OnUpdate", frameOnUpdate)

function RegistGUI()
	if _G.BlinkConfig then
		_G.BlinkConfig:RegisterOptions{
			name = "거리체크",
			type = "root",
			command = {"거리체크","onrange"},
			options = {
				{
					type = "description",
					text = "블링크의 거리체크 애드온",
					fontobject = "QuestTitleFont",
					r = 1,
					g = 0.82,
					b = 0,
					justifyH = "LEFT",
				},
				{
					type = "description",
					text = "선택한 주문/스킬의 사용거리 및 시전가능 횟수를 보여줍니다.",
					fontobject = "ChatFontNormal",
					justifyH = "LEFT",
					justifyV = "TOP",
				},
				{
					type = "toggle",
					text = "사용",
					tooltip = "거리체크 애드온을 사용합니다.",
					get = function ()
						return BOR_Config.enable
					end,
					set = function (value)
						BOR_Config.enable = value
					end,
					needRefresh = true,
				},
				{
					type = "toggle",
					text = "잠금",
					tooltip = "움직이지 않게 고정시킵니다.(테두리가 사라집니다.)",
					get = function ()
						return BOR_Config.lock
					end,
					set = function (value)
						BOR_Config.lock = value
						FrameLock(frame, BOR_Config.lock)
					end,
					disable = function ()
						return not BOR_Config.enable
					end,
				},
				{
					type = "string",
					text = "표시 형식",
					tooltip = "화면에 표시할 형식을 설정합니다.|n사용 가능 태그|n%s => 주문/스킬 이름|n%c => 사용가능횟수|n%i => 주문/스킬 아이콘",
					get = function ()
						return BOR_Config.fmt
					end,
					set = function (value)
						BOR_Config.fmt = value
					end,
				},
				{
					type = "radio",
					text = "우호적인 주문",
					disable = function ()
						return not BOR_Config.enable
					end,
					values = function ()
						local values = {}
						if fSpells then
							for k, v in pairs(fSpells) do
								tinsert(values, {
									text = "|T"..v.icon..":20|t "..k,
									value = k,
								})
							end
						end
						return values
					end,
					show = function ()
						local count = 0
						for k, v in pairs(fSpells) do
							count = count + 1
						end
						if count>0 then
							return true
						end
					end,
					get = function ()
						return BOR_Config.spec[primary].fspell
					end,
					set = function (value)
						BOR_Config.spec[primary].fspell = value
						currSpells.fspell = value
					end,
					col = 4,
				},
				{
					type = "radio",
					text = "적대적인 주문",
					disable = function ()
						return not BOR_Config.enable
					end,
					values = function ()
						local values = {}
						if hSpells then
							for k, v in pairs(hSpells) do
								tinsert(values, {
									text = "|T"..v.icon..":20|t "..k,
									value = k,
								})
							end
						end
						return values
					end,
					show = function ()
						local count = 0
						for k, v in pairs(hSpells) do
							count = count + 1
						end
						if count>0 then
							return true
						end
					end,
					get = function ()
						return BOR_Config.spec[primary].hspell
					end,
					set = function (value)
						BOR_Config.spec[primary].hspell = value
						currSpells.hspell = value
					end,
					col = 4,
				},
--				{
--					type = "group",
--					text = "1특성",
--					disable = function ()
--						return not BOR_Config.enable or GetSpecialization()~=1
--					end,
--					options = {
--						{
--							type = "radio",
--							text = "우호적인 주문",
--							values = function ()
--								local values = {}
--								if fSpells then
--									for k, v in pairs(fSpells) do
--										tinsert(values, {
--											text = "|T"..v.icon..":20|t "..k,
--											value = k,
--										})
--									end
--								end
--								return values
--							end,
--							show = function ()
--								local count = 0
--								for k, v in pairs(fSpells) do
--									count = count + 1
--								end
--								if count>0 then
--									return true
--								end
--							end,
--							get = function ()
--								return BOR_Config.spec1.fspell
--							end,
--							set = function (value)
--								BOR_Config.spec1.fspell = value
--								if GetSpecialization() == 1 then
--									currSpells.fspell = value
--								end
--							end,
--							col = 3,
--						},
--						{
--							type = "radio",
--							text = "적대적인 주문",
--							values = function ()
--								local values = {}
--								if hSpells then
--									for k, v in pairs(hSpells) do
--										tinsert(values, {
--											text = "|T"..v.icon..":20|t "..k,
--											value = k,
--										})
--									end
--								end
--								return values
--							end,
--							show = function ()
--								local count = 0
--								for k, v in pairs(hSpells) do
--									count = count + 1
--								end
--								if count>0 then
--									return true
--								end
--							end,
--							get = function ()
--								return BOR_Config.spec1.hspell
--							end,
--							set = function (value)
--								BOR_Config.spec1.hspell = value
--								if GetSpecialization() == 1 then
--									currSpells.hspell = value
--								end
--							end,
--							col = 3,
--						},
--					},
--				},
--				{
--					type = "group",
--					text = "2특성",
--					disable = function ()
--						return not BOR_Config.enable or GetSpecialization()~=2
--					end,
--					options = {
--						{
--							type = "radio",
--							text = "우호적인 주문",
--							values = function ()
--								local values = {}
--								if fSpells then
--									for k, v in pairs(fSpells) do
--										tinsert(values, {
--											text = "|T"..v.icon..":20|t "..k,
--											value = k,
--										})
--									end
--								end
--								return values
--							end,
--							show = function ()
--								local count = 0
--								for k, v in pairs(fSpells) do
--									count = count + 1
--								end
--								if count>0 then
--									return true
--								end
--							end,
--							get = function ()
--								return BOR_Config.spec2.fspell
--							end,
--							set = function (value)
--								BOR_Config.spec2.fspell = value
--								if GetSpecialization() == 2 then
--									currSpells.fspell = value
--								end
--							end,
--							col = 3,
--						},
--						{
--							type = "radio",
--							text = "적대적인 주문",
--							values = function ()
--								local values = {}
--								if hSpells then
--									for k, v in pairs(hSpells) do
--										tinsert(values, {
--											text = "|T"..v.icon..":20|t "..k,
--											value = k,
--										})
--									end
--								end
--								return values
--							end,
--							show = function ()
--								local count = 0
--								for k, v in pairs(hSpells) do
--									count = count + 1
--								end
--								if count>0 then
--									return true
--								end
--							end,
--							get = function ()
--								return BOR_Config.spec2.hspell
--							end,
--							set = function (value)
--								BOR_Config.spec2.hspell = value
--								if GetSpecialization() == 2 then
--									currSpells.hspell = value
--								end
--							end,
--							col = 3,
--						},
--					},
--				},
			},
		}
	end
end
