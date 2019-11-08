function WindActionBottomRight_OnLoad(self)
	WindActionBottomRight:SetParent(MultiBarBottomRight)
	MultiBarBottomRight:SetFrameStrata("HIGH");
	WindActionBottomRight:SetFrameStrata("MEDIUM");-- MEDIUM , BACKGROUND
	WindActionBottomRight:Show()

	MultiBarBottomRight:SetScript("OnShow", WindActionBottomRight_OnShow);
	MultiBarBottomRight:SetScript("OnHide", WindActionBottomRight_OnHide);

	WindCommon_setPoint(MultiBarBottomRightButton1, "TOPLEFT", WindActionBottomRight, "TOPLEFT", 10, -9);
	self:RegisterEvent("VARIABLES_LOADED");
end

function WindActionBottomRight_OnShow()
	WindActionBottomRight_setBorder()
end

function WindActionBottomRight_OnHide()
	WindActionBottomRight:SetBackdrop(nil);
end

function WindActionBottomRight_OnEvent(self, event, ...)
	local arg1, arg2 = ...;
	if (event == "VARIABLES_LOADED") then
		WindActionBottomRight_initConfig();
		WindActionBottomRight_refresh();
	end
end

function WindActionBottomRight_initConfig()
	if (not WindActionBottomRightConfig) then WindActionBottomRightConfig = WindActionDefault["BottomRight"]; end
	if (IsAddOnLoaded("WindConfig")) then
		WindActionConfigBottomRight_show();
		WindActionConfigBottomRight_setColor(color);
	end
end

function WindActionBottomRight_resetConfig()
	WindActionBottomRightConfig = WindActionDefault["BottomRight"];

	WindActionBottomRight_refresh();

	if (IsAddOnLoaded("WindConfig")) then
		WindActionConfigBottomRight_show();
		WindActionConfigBottomRight_setColor(color);
	end
end

function WindActionBottomRight_refresh()
	WindActionBottomRight_setPoint();
	WindActionBottomRight_setScale();
	WindActionBottomRight_setSize();
	WindActionBottomRight_setBorder();
end

function WindActionBottomRight_setPoint()
	WindCommon_setPoint(WindActionBottomRight, WindActionBottomRightConfig[1], UIParent, WindActionBottomRightConfig[1], WindActionBottomRightConfig[2], WindActionBottomRightConfig[3]);
end

function WindActionBottomRight_setScale()
	MultiBarBottomRight:SetScale(WindActionBottomRightConfig[4]);
end

function WindActionBottomRight_setSize()
	local index = WindActionBottomRightConfig[5];
	WindCommon_setSize(WindActionBottomRight, WindActionBorderSize[index][1], WindActionBorderSize[index][2]);
	WindActionButton_setAnchor(index, "MultiBarBottomRightButton");
end

function WindActionBottomRight_setBorder()
	if (not WindActionBottomRightConfig or WindActionBottomRightConfig[6]) then
		WindActionBottomRight:SetBackdrop(WindCommon_ColorBorder);
		WindActionBottomRight_setColor();
	end
end

function WindActionBottomRight_setColor()
   if (WindActionBottomRightConfig) then
	WindActionBottomRight:SetBackdropBorderColor(WindActionBottomRightConfig[7][1].r, WindActionBottomRightConfig[7][1].g, WindActionBottomRightConfig[7][1].b, WindActionBottomRightConfig[7][1].a);
	WindActionBottomRight:SetBackdropColor(WindActionBottomRightConfig[7][2].r, WindActionBottomRightConfig[7][2].g, WindActionBottomRightConfig[7][2].b, WindActionBottomRightConfig[7][2].a);
	end
end

function WindActionBottomRight_resetColor()
	WindActionBottomRightConfig[7] = WindActionDefault["BottomRight"][7];
	WindActionBottomRight_setColor();
end