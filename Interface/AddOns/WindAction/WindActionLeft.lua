function WindActionLeft_OnLoad(self)
	MultiBarLeft:SetParent(WindActionLeft)
	MultiBarLeft:SetFrameStrata("HIGH");
	WindActionLeft:SetFrameStrata("MEDIUM");-- MEDIUM , BACKGROUND
	WindActionLeft:Show()

	MultiBarLeft:SetScript("OnShow", WindActionLeft_OnShow);
	MultiBarLeft:SetScript("OnHide", WindActionLeft_OnHide);

	WindCommon_setPoint(MultiBarLeftButton1, "TOPLEFT", WindActionLeft, "TOPLEFT", 10, -9);
	self:RegisterEvent("VARIABLES_LOADED");
--	self:RegisterEvent("PET_BATTLE_OPENING_START");
--	self:RegisterEvent("PET_BATTLE_CLOSE");
end

function WindActionLeft_OnShow()
	if MultiBarLeft:IsShown() == true then
		WindActionLeft_setBorder()
		if not InCombatLockdown() and WindActionLeftConfig then
			WindActionLeft:SetScale(WindActionLeftConfig[4]);
			--WindActionLeft:Show()
		end
	end
end

function WindActionLeft_OnHide()
	WindActionLeft:SetBackdrop(nil)
end

function WindActionLeft_OnEvent(self, event, ...)
	local arg1, arg2 = ...;
	if (event == "VARIABLES_LOADED") then
		WindActionLeft_initConfig();
		WindActionLeft_refresh();
--[[
	elseif (event == "PET_BATTLE_OPENING_START") then
		if not InCombatLockdown() then
			WindActionLeft:Hide()
		end
	elseif (event == "PET_BATTLE_CLOSE") then
		if not InCombatLockdown() and MultiBarLeft:IsShown() == true then
			WindActionLeft:Show()
		end
--]]
	end
end

function WindActionLeft_initConfig()
	if (not WindActionLeftConfig) then WindActionLeftConfig = WindActionDefault["Left"]; end
	if (IsAddOnLoaded("WindConfig")) then
		WindActionConfigLeft_show();
		WindActionConfigLeft_setColor(color);
	end
end

function WindActionLeft_resetConfig()
	WindActionLeftConfig = WindActionDefault["Left"];

	WindActionLeft_refresh();

	if (IsAddOnLoaded("WindConfig")) then
		WindActionConfigLeft_show();
		WindActionConfigLeft_setColor(color);
	end
end

function WindActionLeft_refresh()
  if (WindActionLeftConfig) then
    WindActionLeft_setPoint();
    WindActionLeft_setSize();
    WindActionLeft_setScale();
    WindActionLeft_setBorder();
	end
end

function WindActionLeft_setPoint()
  WindCommon_setPoint(WindActionLeft, WindActionLeftConfig[1], UIParent, WindActionLeftConfig[1], WindActionLeftConfig[2], WindActionLeftConfig[3]);
end

function WindActionLeft_setScale()
  if MultiBarLeft:IsShown() then
    if not InCombatLockdown() then
      WindActionLeft:SetScale(WindActionLeftConfig[4]);
    end
	end
end

function WindActionLeft_setSize()
	local index = WindActionLeftConfig[5];
	WindCommon_setSize(WindActionLeft, WindActionBorderSize[index][1], WindActionBorderSize[index][2]);
	WindActionButton_setAnchor(index, "MultiBarLeftButton");
end

function WindActionLeft_setBorder()
	if MultiBarLeft:IsShown() and (not WindActionLeftConfig or WindActionLeftConfig[6]) then
		WindActionLeft:SetBackdrop(WindCommon_ColorBorder);
		WindActionLeft_setColor();
	end
end

function WindActionLeft_setColor()
  if (WindActionLeftConfig) then
    WindActionLeft:SetBackdropBorderColor(WindActionLeftConfig[7][1].r, WindActionLeftConfig[7][1].g, WindActionLeftConfig[7][1].b, WindActionLeftConfig[7][1].a);
    WindActionLeft:SetBackdropColor(WindActionLeftConfig[7][2].r, WindActionLeftConfig[7][2].g, WindActionLeftConfig[7][2].b, WindActionLeftConfig[7][2].a);
  end
end

function WindActionLeft_resetColor()
	WindActionLeftConfig[7] = WindActionDefault["Left"][7];
	WindActionLeft_setColor();
end