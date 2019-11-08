function WindActionCastingBar_OnLoad(self)
	CastingBarFrame:SetScript("OnShow", function()
		WindActionCastingBar_setPoint()
	end);
	
--	UIPARENT_MANAGED_FRAME_POSITIONS["CastingBarFrame"].yOffset = -20
--	CastingBarFrame:SetScale(WindActionMainConfig[4] + 0.5)
	--CastingBarFrame:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 150)
	
	self:RegisterEvent("VARIABLES_LOADED");
end

function WindActionCastingBar_OnShow()
end

function WindActionCastingBar_OnHide()
end

function WindActionCastingBar_OnEvent(self, event, ...)
	local arg1, arg2 = ...;
	if (event == "VARIABLES_LOADED") then
		WindActionCastingBar_initConfig();
		WindActionCastingBar_refresh();
	end
end

function WindActionCastingBar_initConfig()
	if (not WindActionCastingBarConfig) then WindActionCastingBarConfig = WindActionDefault["CastingBar"]; end

	if (IsAddOnLoaded("WindConfig")) then 
		WindActionConfigCastingBar_show();
	end
end

function WindActionCastingBar_resetConfig()
	WindActionCastingBarConfig = WindActionDefault["CastingBar"];

	WindActionCastingBar_refresh();
	
	if (IsAddOnLoaded("WindConfig")) then 
		WindActionConfigCastingBar_show();
	end
end

function WindActionCastingBar_refresh()
	WindActionCastingBar_setPoint();
	WindActionCastingBar_setScale();
end

function WindActionCastingBar_setPoint()
	CastingBarFrame:ClearAllPoints();
	CastingBarFrame:SetPoint(WindActionCastingBarConfig[1], UIParent, WindActionCastingBarConfig[1], WindActionCastingBarConfig[2], WindActionCastingBarConfig[3])
end

function WindActionCastingBar_setScale()
	CastingBarFrame:SetScale(WindActionCastingBarConfig[4]);
end

function WindActionCastingBar_resetColor()
	WindActionCastingBarConfig[7] = WindActionDefault["CastingBar"][7];
end