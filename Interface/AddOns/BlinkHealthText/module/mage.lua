
local module = _G["BlinkHealthTextModule"]

if select(2, UnitClass("player")) ~= "MAGE" or not module then return end

local tcopy
local config_added = false

local L_FINGERS_OF_FROST = "서리의 손가락"
local L_BRAIN_FREEZE = "두뇌 빙결"

local L_SHATTER = "산산조각"
local L_FROST_NOVA = "얼음 회오리"
local L_FROSTJAW = "서리투성이 턱"
local L_MAGE_CONFIG = "마법사 설정"
local L_USE_MAGE_ACTIVATED_SPELL = "전문화별 발동 효과 발동시 아이콘을 표시합니다."
local L_USE_MAGE_ARCANE_COUNT = "비전 전문화 마법사의 비전 충전물의 갯수를 표시합니다."

local activation_spells = {}

local defaultDB = {
	db_ver = 1.2,
	use_activated_spells = true,
	show_arcane_count = true,
}

-------------------------------------------------------------------------------
-- local functions
-------------------------------------------------------------------------------

function tcopy(to, from) -- "to" must be a table (possibly empty)
	for k,v in pairs(from) do
		if(type(v)=="table") then
			if not to then to = {} end
			to[k] = {}
			tcopy(to[k], v)
		else
			to[k] = v
		end
	end
end

local function getSize(baseSize, expirationTime, duration)
	local size = (expirationTime-GetTime()) / duration
	if size < 0.3 then
		size = baseSize * .8
	elseif size < 0.6 then
		size = baseSize * 1.0
	else
		size = baseSize * 1.2
	end
	return size / 2
end


-------------------------------------------------------------------------------
-- module functions
-------------------------------------------------------------------------------
function module:init()
	if self.addon.db then
		if not self.addon.db.class or not self.addon.db.class.db_ver or self.addon.db.class.db_ver < defaultDB.db_ver then
			self.addon.db.class = {}
			tcopy(self.addon.db.class, defaultDB)
		end
	end

	if self.addon.db.class.use_activated_spells then
		module:EnableActivatedSpell()
	end

	if not config_added then
		self:AddMiscConfig{
			type = "description",
			text = L_MAGE_CONFIG,
			fontobject = "QuestTitleFont",
			r = 1,
			g = 0.82,
			b = 0,
			justifyH = "LEFT",
		}
		self:AddMiscConfig{
			type = "toggle",
			text = L_USE_MAGE_ACTIVATED_SPELL,
			tooltip = L_USE_MAGE_ACTIVATED_SPELL,
			get = function ()
				return self.addon.db.class.use_activated_spells
			end,
			set = function (value)
				self.addon.db.class.use_activated_spells = value
				if self.addon.db.class.use_activated_spells then
					module:EnableActivatedSpell()
				else
					module:DisableActivatedSpell()
				end
			end,
		}
		
		self:AddMiscConfig{
			type = "toggle",
			text = L_USE_MAGE_ARCANE_COUNT,
			tooltip = L_USE_MAGE_ARCANE_COUNT,
			get = function ()
				return self.addon.db.class.show_arcane_count
			end,
			set = function (value)
				self.addon.db.class.show_arcane_count = value
			end,
		}
--		self:AddMiscConfig{
--			type = "description",
--			text = "전문화별 발동 효과 발동시 아이콘을 표시합니다.",
--			fontobject = "ChatFontNormal",
--			justifyH = "LEFT",
--			justifyV = "TOP",
--		}
		config_added = true
	end
end


function module:EnableActivatedSpell()
	activation_spells = {}
--	self.addon.mainFrame:RegisterEvent("SPELL_ACTIVATION_OVERLAY_GLOW_SHOW")
--	self.addon.mainFrame:RegisterEvent("SPELL_ACTIVATION_OVERLAY_GLOW_HIDE")
end

function module:DisableActivatedSpell()
	activation_spells = {}
--	self.addon.mainFrame:UnregisterEvent("SPELL_ACTIVATION_OVERLAY_GLOW_SHOW")
--	self.addon.mainFrame:UnregisterEvent("SPELL_ACTIVATION_OVERLAY_GLOW_HIDE")
end

function module:SPELL_ACTIVATION_OVERLAY_GLOW_SHOW(...)
	local spellID, texture, positions, scale, r, g, b = ...;
	local icon = GetSpellTexture(spellID)
	if icon then
		if not activation_spells[icon] then
			activation_spells[icon] = 0
		end
		activation_spells[icon] = activation_spells[icon] + 1
	end
end

function module:SPELL_ACTIVATION_OVERLAY_GLOW_HIDE(...)
	local spellID = ...;
	local icon = GetSpellTexture(spellID)
	if icon and activation_spells and activation_spells[icon] then
		activation_spells[icon] = activation_spells[icon] - 1
		if activation_spells[icon] < 0 then
			activation_spells[icon] = 0
		end
	end
end


function module:getTargetText()
	local text = ""

	if self.addon.db.class.use_activated_spells then
		for texture, cnt in pairs(activation_spells) do
			if cnt > 0 then
				text = text .. (":|T%s:%d|t"):format(texture, self.addon.db.fontSizeHealth/2)
			end
		end
	end

	return text
end
--
--function module:getTargetHealthColor()
--	local name
--
--	if self.config[L_SHATTER].use and self.addon.db.class.use_shatter then
--		if self.config[L_FINGERS_OF_FROST].use then
--			name = UnitAura("player", L_FINGERS_OF_FROST, nil, "HELPFUL")
--			if name then
--				return true, 0.75, 0.75, 1.0 -- 파란색? 하늘색?
--			end
--		end
--		name = UnitAura("target", L_FROST_NOVA, nil, "HARMFUL")
--		if name then
--			return true, 0.75, 0.75, 1.0 -- 파란색? 하늘색?
--		end
--		if self.config[L_FROSTJAW].use then
--			name = UnitAura("target", L_FROSTJAW, nil, "HARMFUL")
--			if name then
--				return true, 0.75, 0.75, 1.0 -- 파란색? 하늘색?
--			end
--		end
--	end
--end

function module:getPlayerText()
	if self.addon.db.class.show_arcane_count then
--	if GetSpecialization() ~= 1 then
--			return ""
--		end
--		local arcanes = UnitPower("player", SPELL_POWER_ARCANE_CHARGES, true);
--		if arcanes > 0 then
--			return arcanes
--		end
	end
	return ""
end

