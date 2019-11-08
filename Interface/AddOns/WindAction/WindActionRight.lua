function WindActionRight_OnLoad(self)
	MultiBarRight:SetParent(WindActionRight)--MultiBarRight:SetParent(WindActionRight)
	MultiBarRight:SetFrameStrata("HIGH");
	WindActionRight:SetFrameStrata("MEDIUM");
	WindActionRight:Show();--if (not MultiBar3_IsVisible() or not MultiBar4_IsVisible()) then WindActionRight:Hide() end

	MultiBarRight:SetScript("OnShow", WindActionRight_OnShow);
	MultiBarRight:SetScript("OnHide", WindActionRight_OnHide);

	WindCommon_setPoint(MultiBarRightButton1, "TOPLEFT", WindActionRight, "TOPLEFT", 10, -9);
	self:RegisterEvent("VARIABLES_LOADED");
	--self:RegisterEvent("PET_BATTLE_OPENING_START");
	--self:RegisterEvent("PET_BATTLE_CLOSE");
end

function WindActionRight_OnShow()
	if MultiBarRight:IsShown() == true then
		WindActionRight_setBorder()
		if not InCombatLockdown() and WindActionRightConfig then
			WindActionRight:SetScale(WindActionRightConfig[4]);
			--WindActionRight:Show()
		end
	end
end

function WindActionRight_OnHide()
	WindActionRight:SetBackdrop(nil);
end

function WindActionRight_OnEvent(self, event, ...)
	local arg1, arg2 = ...;
	if (event == "VARIABLES_LOADED") then
		WindActionRight_initConfig();
		WindActionRight_refresh();
--[[
	elseif (event == "PET_BATTLE_OPENING_START") then
		if not InCombatLockdown() then
			WindActionRight:Hide()
		end
	elseif (event == "PET_BATTLE_CLOSE") then
		if not InCombatLockdown() and MultiBarRight:IsShown() == true then
			WindActionRight:Show()
		end
--]]
	end
end

function WindActionRight_initConfig()
	if (not WindActionRightConfig) then WindActionRightConfig = WindActionDefault["Right"]; end
	if (IsAddOnLoaded("WindConfig")) then
		WindActionConfigRight_show();
		WindActionConfigRight_setColor(color);
	end
end

function WindActionRight_resetConfig()
	WindActionRightConfig = WindActionDefault["Right"];

	WindActionRight_refresh();

	if (IsAddOnLoaded("WindConfig")) then
		WindActionConfigRight_show();
		WindActionConfigRight_setColor(color);
	end
end

function WindActionRight_refresh()
  if (WindActionRightConfig) then
    WindActionRight_setPoint();
    WindActionRight_setScale();
    WindActionRight_setSize();
    WindActionRight_setBorder();
	end
end

function WindActionRight_setPoint()
	WindCommon_setPoint(WindActionRight, WindActionRightConfig[1], UIParent, WindActionRightConfig[1], WindActionRightConfig[2], WindActionRightConfig[3]);
end

function WindActionRight_setScale()
  if MultiBarRight:IsShown() then
    if not InCombatLockdown() then
      WindActionRight:SetScale(WindActionRightConfig[4]);
    end
	end
end

function WindActionRight_setSize()
	local index = WindActionRightConfig[5];
	WindCommon_setSize(WindActionRight, WindActionBorderSize[index][1], WindActionBorderSize[index][2]);
	WindActionButton_setAnchor(index, "MultiBarRightButton");
end

function WindActionRight_setBorder()
	if MultiBarRight:IsShown() and (not WindActionRightConfig or WindActionRightConfig[6]) then
		WindActionRight:SetBackdrop(WindCommon_ColorBorder);
		WindActionRight_setColor();
	end
end

function WindActionRight_setColor()
  if (WindActionRightConfig) then
	WindActionRight:SetBackdropBorderColor(WindActionRightConfig[7][1].r, WindActionRightConfig[7][1].g, WindActionRightConfig[7][1].b, WindActionRightConfig[7][1].a);
	WindActionRight:SetBackdropColor(WindActionRightConfig[7][2].r, WindActionRightConfig[7][2].g, WindActionRightConfig[7][2].b, WindActionRightConfig[7][2].a);
  end
end

function WindActionRight_resetColor()
	WindActionRightConfig[7] = WindActionDefault["Right"][7];
	WindActionRight_setColor();
end