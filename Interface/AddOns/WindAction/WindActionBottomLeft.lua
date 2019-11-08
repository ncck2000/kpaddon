function WindActionBottomLeft_OnLoad(self)
	WindActionBottomLeft:SetParent(MultiBarBottomLeft)
	MultiBarBottomLeft:SetFrameStrata("HIGH");
	WindActionBottomLeft:SetFrameStrata("MEDIUM");-- MEDIUM , BACKGROUND
	WindActionBottomLeft:Show()

	MultiBarBottomLeft:SetScript("OnShow", WindActionBottomLeft_OnShow);
	MultiBarBottomLeft:SetScript("OnHide", WindActionBottomLeft_OnHide);

	WindCommon_setPoint(MultiBarBottomLeftButton1, "TOPLEFT", WindActionBottomLeft, "TOPLEFT", 10, -9);
	self:RegisterEvent("VARIABLES_LOADED");
end

function WindActionBottomLeft_OnShow()
	WindActionBottomLeft_setBorder()
end

function WindActionBottomLeft_OnHide()
	WindActionBottomLeft:SetBackdrop(nil);
end

function WindActionBottomLeft_OnEvent(self, event, ...)
	local arg1, arg2 = ...;
	if (event == "VARIABLES_LOADED") then
		WindActionBottomLeft_initConfig();
		WindActionBottomLeft_refresh();
	end
end

function WindActionBottomLeft_initConfig()
	if (not WindActionBottomLeftConfig) then WindActionBottomLeftConfig = WindActionDefault["BottomLeft"]; end
	if (IsAddOnLoaded("WindConfig")) then
		WindActionConfigBottomLeft_show();
		WindActionConfigBottomLeft_setColor(color);
	end
end

function WindActionBottomLeft_resetConfig()
	WindActionBottomLeftConfig = WindActionDefault["BottomLeft"];

	WindActionBottomLeft_refresh();

	if (IsAddOnLoaded("WindConfig")) then
		WindActionConfigBottomLeft_show();
		WindActionConfigBottomLeft_setColor(color);
	end
end

function WindActionBottomLeft_refresh()
	WindActionBottomLeft_setPoint();
	WindActionBottomLeft_setScale();
	WindActionBottomLeft_setSize();
	WindActionBottomLeft_setBorder();
end

function WindActionBottomLeft_setPoint()
	WindCommon_setPoint(WindActionBottomLeft, WindActionBottomLeftConfig[1], UIParent, WindActionBottomLeftConfig[1], WindActionBottomLeftConfig[2], WindActionBottomLeftConfig[3]);
end

function WindActionBottomLeft_setScale()
	MultiBarBottomLeft:SetScale(WindActionBottomLeftConfig[4]);
end

function WindActionBottomLeft_setSize()
	local index = WindActionBottomLeftConfig[5];
	WindCommon_setSize(WindActionBottomLeft, WindActionBorderSize[index][1], WindActionBorderSize[index][2]);
	WindActionButton_setAnchor(index, "MultiBarBottomLeftButton");
end

function WindActionBottomLeft_setBorder()
	if (not WindActionBottomLeftConfig or WindActionBottomLeftConfig[6]) then
		WindActionBottomLeft:SetBackdrop(WindCommon_ColorBorder);
		WindActionBottomLeft_setColor();
	end
end

function WindActionBottomLeft_setColor()
  if (WindActionBottomLeftConfig) then
	WindActionBottomLeft:SetBackdropBorderColor(WindActionBottomLeftConfig[7][1].r, WindActionBottomLeftConfig[7][1].g, WindActionBottomLeftConfig[7][1].b, WindActionBottomLeftConfig[7][1].a);
	WindActionBottomLeft:SetBackdropColor(WindActionBottomLeftConfig[7][2].r, WindActionBottomLeftConfig[7][2].g, WindActionBottomLeftConfig[7][2].b, WindActionBottomLeftConfig[7][2].a);
  end
end

function WindActionBottomLeft_resetColor()
	WindActionBottomLeftConfig[7] = WindActionDefault["BottomLeft"][7];
	WindActionBottomLeft_setColor();
end