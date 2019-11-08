WindInfo_CurrHealth = 0;
WindInfo_CurrMana = 0;

function WindInfoTick_OnLoad(self)
	self.update = 0;
	self.alphamana = 1;
	self.alphahealth = 1;
	self:RegisterEvent("UNIT_HEALTH");
	self:RegisterEvent("UNIT_MAXHEALTH");
	self:RegisterEvent("UNIT_MANA");
--	self:RegisterEvent("UNIT_MAXMANA");   -- 8.0 ¾Ö·¯
	self:RegisterEvent("UNIT_POWER_UPDATE");
	self:RegisterEvent("UNIT_MAXPOWER");
	self:RegisterEvent("VARIABLES_LOADED");
	WindInfoTicksHealthText:SetText("|cFFFFFF00 HP : |c00FFFFFF" .. "0" .. "|r");
	WindInfoTicksManaText:SetText("|cFFFFFF00 MP : |c00FFFFFF" .. "0" .. "|r");
end

function WindInfoTick_OnEvent(self, event, ...)
	if ( event == "VARIABLES_LOADED" ) then
		WindInfoTick_initConfig();
		WindInfoTick_setPoint();
		WindInfoTick_setScale();
		WindInfoTick_setSize();
		WindInfoTick_setView();
		WindInfoTick_setMouse();
	end
	if ( event == "UNIT_HEALTH" or event == "UNIT_MAXHEALTH" and ... == "player" ) then
		local curr = UnitHealth("player");
		if ( curr > WindInfo_CurrHealth and WindInfo_CurrHealth ~= 0 ) then
			WindInfoTicksHealthText:SetText("|cFFFFFF00 HP : |c00FFFFFF" .. curr-WindInfo_CurrHealth .. "|r");
			WindInfoTick_LastHP = curr-WindInfo_CurrHealth;
			WindInfoTick.alphahealth = 1;
			WindInfoTicksHealthText:SetAlpha(1);
		end
		WindInfo_CurrHealth = curr;
	end
	if ( event == "UNIT_MANA" and ... == "player" ) then --   or event == "UNIT_MAXMANA" and ... == "player" ) then -- 8.0
		local curr = UnitPower("player");
		if ( curr > WindInfo_CurrMana and WindInfo_CurrMana ~= 0 ) then
			WindInfoTicksManaText:SetText("|cFFFFFF00 MP : |c00FFFFFF" .. curr-WindInfo_CurrMana .. "|r");
			WindInfoTick_LastMP = curr-WindInfo_CurrMana;
			WindInfoTick.alphamana = 1;
			WindInfoTicksManaText:SetAlpha(1);
		end
		WindInfo_CurrMana = curr;
	end
	if ( event == "UNIT_POWER_UPDATE" or event == "UNIT_MAXPOWER" and ... == "player" ) then
		local curr = UnitPower("player");
		if ( curr > WindInfo_CurrMana and WindInfo_CurrMana ~= 0 ) then
			WindInfoTicksManaText:SetText("|cFFFFFF00 MP : |c00FFFFFF" .. curr-WindInfo_CurrMana .. "|r");
			WindInfoTick_LastMP = curr-WindInfo_CurrMana;
			WindInfoTick.alphamana = 1;
			WindInfoTicksManaText:SetAlpha(1);
		end
		WindInfo_CurrMana = curr;
	end
end

function WindInfoTick_FadeMana()
	local class, eClass = UnitClass("player");
	if ( UnitPowerType("player") > 0 and eClass ~= "DRUID" ) then
		WindInfoTicksHealthText:SetJustifyH("CENTER");
		WindInfoTicksManaText:SetAlpha(0);
	else
		if ( WindInfoTick.alphamana <= 0.5 ) then return; end
		WindInfoTick.alphamana = WindInfoTick.alphamana - 0.0075;
		WindInfoTicksManaText:SetAlpha(WindInfoTick.alphamana);
	end
end

function WindInfoTick_FadeHealth()
	if ( WindInfoTick.alphahealth <= 0.5 ) then return; end
	WindInfoTick.alphahealth = WindInfoTick.alphahealth - 0.0075;
	WindInfoTicksHealthText:SetAlpha(WindInfoTick.alphahealth);
end

function WindInfoTick_Fade(elapsed)
	if (not IsAddOnLoaded("WindConfig")) then
		WindInfoTick.update = WindInfoTick.update + elapsed;
		if ( WindInfoTick.update >= 0.01 ) then
			WindInfoTick.update = WindInfoTick.update - 0.01;
			WindInfoTick_FadeMana();
			WindInfoTick_FadeHealth();
		end
	end
end

function WindInfoTick_initConfig()
	if (not WindInfoTickConfig) then WindInfoTickConfig = WindInfoDefault["Tick"]; end
end

function WindInfoTick_resetConfig()
	WindInfoTickConfig = WindInfoDefault["Tick"];
end

function WindInfoTick_setPoint()
	WindCommon_setPoint(WindInfoTick, WindInfoTickConfig[1], "WindInfo", WindInfoTickConfig[1], WindInfoTickConfig[2], WindInfoTickConfig[3]);
end

function WindInfoTick_setScale()
	WindInfoTick:SetScale(WindInfoTickConfig[4]);
end

function WindInfoTick_setSize()
	WindCommon_setSize(WindInfoTick, WindInfoTickConfig[5], WindInfoTickConfig[6]);
end

function WindInfoTick_setView()
	if (WindInfoTickConfig[7]) then WindInfoTick:Show();
	else WindInfoTick:Hide(); end
end

function WindInfoTick_setMouse()
	if (WindInfoTickConfig[8]) then WindInfoTick:Show();
	else WindInfoTick:Hide(); end
end