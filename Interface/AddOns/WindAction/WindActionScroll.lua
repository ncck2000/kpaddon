WindActionScrollSize = {
	{37, 55},
	{58, 37}
}

local function WindActionScroll_InitText()
  MainMenuBarPageNumber:SetParent(WindActionScroll)
  MainMenuBarPageNumber:SetPoint("CENTER", WindActionScroll, "CENTER", 11.5, 0)
end

function WindActionScroll_OnLoad(self)
	WindCommon_setParentPoint(ActionBarUpButton, WindActionScroll, "TOPLEFT", WindActionScroll, "TOPLEFT", 2.5, -2);
	--MainMenuBarPageNumber:Hide()--MainMenuBarArtFrame.PageNumber:Hide()
	MainMenuBarTexture2:Hide()
	ActionBarUpButton:SetParent(WindActionScroll);
	ActionBarDownButton:SetParent(WindActionScroll);
	ActionBarUpButton:SetFrameStrata("MEDIUM");
	ActionBarDownButton:SetFrameStrata("MEDIUM");
	WindActionScroll:Show();
	WindActionScroll:SetFrameStrata("MEDIUM");
	WindActionScroll:SetFrameLevel(0)
	WindActionScroll:SetParent(MainMenuBar);
	WindActionScroll_InitText()
	self:RegisterEvent("VARIABLES_LOADED");
	self:RegisterEvent("ACTIONBAR_PAGE_CHANGED");
end


function WindActionScroll_OnEvent(self, event, ...)
	if (event == "VARIABLES_LOADED") then
		WindActionScroll_initConfig();
		WindActionScroll_refresh();
	end
end

function WindActionScroll_initConfig()
	if (not WindActionScrollConfig) then WindActionScrollConfig = WindActionDefault["Scroll"]; end

	if (IsAddOnLoaded("WindConfig")) then 
		WindActionConfigScroll_show();
		WindActionConfigScroll_setColor(color); 
	end
end

function WindActionScroll_resetConfig()
	WindActionScrollConfig = WindActionDefault["Scroll"];

	WindActionScroll_refresh();
	
	if (IsAddOnLoaded("WindConfig")) then 
		WindActionConfigScroll_show();
		WindActionConfigScroll_setColor(color); 
	end
end

function WindActionScroll_refresh()
	WindActionScroll_setPoint();
	WindActionScroll_setScale();
	WindActionScroll_setSize();
	WindActionScroll_setBorder();
	WindActionScroll_setView();
end

function WindActionScroll_setPoint()
	WindCommon_setPoint(WindActionScroll, WindActionScrollConfig[1], UIParent, WindActionScrollConfig[1], WindActionScrollConfig[2], WindActionScrollConfig[3]);
end

function WindActionScroll_setScale()
	WindActionScroll:SetScale(WindActionScrollConfig[4]);
end

function WindActionScroll_setSize()
	local index = WindActionScrollConfig[5];
	WindCommon_setSize(WindActionScroll, WindActionScrollSize[index][1], WindActionScrollSize[index][2]);
	WindActionScroll_setAnchor(index);
end

function WindActionScroll_setAnchor(index)
	if (index == 1) then
		WindCommon_setPoint(ActionBarDownButton, "TOPLEFT", ActionBarUpButton, "BOTTOMLEFT", 0, 12);
  MainMenuBarPageNumber:SetPoint("CENTER", WindActionScroll, "CENTER", 11.5, 0)
	elseif (index == 2) then
		WindCommon_setPoint(ActionBarDownButton, "BOTTOMLEFT", ActionBarUpButton, "BOTTOMRIGHT", -10, 0);
  MainMenuBarPageNumber:SetPoint("CENTER", WindActionScroll, "CENTER", 0, 0)
	end
end

function WindActionScroll_setBorder()
	if (not WindActionScrollConfig or WindActionScrollConfig[6]) then 
		WindActionScroll:SetBackdrop(WindCommon_ColorBorder);
		WindActionScroll_setColor();
	else 
		WindActionScroll:SetBackdrop(nil); 
	end
end

function WindActionScroll_setColor()
	WindActionScroll:SetBackdropBorderColor(WindActionScrollConfig[7][1].r, WindActionScrollConfig[7][1].g, WindActionScrollConfig[7][1].b, WindActionScrollConfig[7][1].a);
	WindActionScroll:SetBackdropColor(WindActionScrollConfig[7][2].r, WindActionScrollConfig[7][2].g, WindActionScrollConfig[7][2].b, WindActionScrollConfig[7][2].a);
end

function WindActionScroll_resetColor()
	WindActionScrollConfig[7] = WindActionDefault["Scroll"][7];
	WindActionScroll_setColor();
end

function WindActionScroll_setView()
	if (not WindActionScrollConfig or WindActionScrollConfig[8]) then 
		WindActionScroll:Show();
	else 
		WindActionScroll:Hide(); 
	end
end