WindActionShiftSize = { {231, 51}, {195, 87}, {87, 195}, {51, 231} }

function WindActionShift_OnLoad(self)
	--WindCommon_setSize(StanceBarFrame, 1, 1)
	WindActionShift:Show()
	WindActionShift:SetFrameStrata("MEDIUM")
	WindActionShift:SetFrameLevel(9)
	WindActionShift:SetParent(StanceButton1)

	StanceBarFrame:SetScript("OnShow", WindActionShift_OnShow);
	StanceBarFrame:SetScript("OnHide", WindActionShift_OnHide);

	self:RegisterEvent("VARIABLES_LOADED")
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	self:RegisterEvent("UPDATE_SHAPESHIFT_FORMS")

	StanceBarRight:Hide();
	StanceBarLeft:Hide();
	StanceBarMiddle:Hide();
	StanceBarRight:SetTexture(nil)
	StanceBarLeft:SetTexture(nil)
	StanceBarMiddle:SetTexture(nil)
end

function WindActionShift_OnShow()
	if not InCombatLockdown() then
		WindCommon_setPoint(StanceButton1, "TOPLEFT", WindActionShift, "TOPLEFT",  10, -9);
	end
	WindActionShift_setBorder();
end

function WindActionShift_OnHide()
	WindActionShift:SetBackdrop(nil);
end

function WindActionShift_OnEvent(self, event, ...)
	local arg1, arg2 = ...;
	if (event == "VARIABLES_LOADED" or event == "PLAYER_ENTERING_WORLD") then
		WindActionShift_initConfig();
		WindActionShift_refresh();
	elseif (event == "UPDATE_SHAPESHIFT_FORMS") then
		WindActionShift_setPointAndSize();
	end
end

function WindActionShift_initConfig()
	if (not WindActionShiftConfig) then
		WindActionShiftConfig = WindActionDefault["Shift"];

		local _, class = UnitClass("player");
		if ( class == "DEATHKNIGHT") then
			WindActionShiftConfig[2] = -186
		elseif ( class == "SHAMAN" or class == "DRUID" ) then
		elseif ( class == "WARLOCK" ) then
			WindActionShiftConfig[2] = -220
		elseif ( class == "PALADIN" ) then
		end

	end

	if (IsAddOnLoaded("WindConfig")) then
		WindActionConfigShift_show()
		WindActionConfigShift_setColor(color)
	end
end

function WindActionShift_resetConfig()
	WindActionShiftConfig = WindActionDefault["Shift"];

	local _, class = UnitClass("player");
	if ( class == "DEATHKNIGHT") then
		WindActionShiftConfig[2] = -186
	elseif ( class == "SHAMAN" or class == "DRUID" ) then
	elseif ( class == "WARLOCK" ) then
		WindActionShiftConfig[2] = -220
	elseif ( class == "PALADIN" ) then
	end

	WindActionShift_refresh();

	if (IsAddOnLoaded("WindConfig")) then
		WindActionConfigShift_show()
		WindActionConfigShift_setColor(color)
	end
end

function WindActionShift_refresh()
	WindActionShift_setScale()
	WindActionShift_setBorder()
	WindActionShift_setPointAndSize()

	local numForms = GetNumShapeshiftForms();
	local NUM_SHAPESHIFT_SLOTS = 10;
	for i=1, NUM_SHAPESHIFT_SLOTS do
		if ( i <= numForms ) then
			_G["StanceButton"..i.."NormalTexture2"]:SetTexture(nil)
		end
	end
end

function WindActionShift_setScale()
	for i=1, 10 do
		getglobal("StanceButton"..i):SetScale(WindActionShiftConfig[4])
		-- Frame Strata¸¦ ³·Ãá´Ù.
		getglobal("StanceButton"..i):SetFrameStrata("HIGH");
		getglobal("StanceButton"..i):SetFrameLevel(5)
	end
	WindActionShift:SetFrameStrata("MEDIUM")
end

function WindActionShift_setPointAndSize()
	local index = WindActionShiftConfig[5]
  if not InCombatLockdown() then
    WindActionShift_setAnchor(index)
	end
	WindActionShift_setSize()
	WindCommon_setPoint(WindActionShift, WindActionShiftConfig[1], UIParent, WindActionShiftConfig[1], WindActionShiftConfig[2], WindActionShiftConfig[3])
	WindCommon_setPoint(StanceButton1, "TOPLEFT", WindActionShift, "TOPLEFT", 10.5, -10.5)
end

function WindActionShift_setSize()
	local index = WindActionShiftConfig[5]
	local blanksize = 15
	local buttonsize = 36
	if (GetNumShapeshiftForms() == 1) then
		UIPARENT_MANAGED_FRAME_POSITIONS["StanceBarFrame"].baseY = 6 * WindActionShiftConfig[4]
		UIPARENT_MANAGED_FRAME_POSITIONS["StanceBarFrame"].anchorTo="WindActionShift"
		UIPARENT_MANAGED_FRAME_POSITIONS["StanceBarFrame"].point="BOTTOMLEFT"
		UIPARENT_MANAGED_FRAME_POSITIONS["StanceBarFrame"].rpoint="BOTTOMLEFT"
		WindCommon_setSize(WindActionShift, blanksize + buttonsize, blanksize + buttonsize)
	else
		for i=2, 10 do
			if (GetNumShapeshiftForms() == i) then
				if (index == 1) then
					WindCommon_setSize(WindActionShift, blanksize + buttonsize*i, blanksize + buttonsize)
				elseif (index == 2) then
					WindCommon_setSize(WindActionShift, blanksize + buttonsize*floor((i*0.5)+0.5), blanksize + buttonsize*2)
				elseif (index == 3) then
					WindCommon_setSize(WindActionShift, blanksize + buttonsize*2, blanksize + buttonsize*floor((i*0.5)+0.5))
				elseif (index == 4) then
					WindCommon_setSize(WindActionShift, blanksize + buttonsize, blanksize + buttonsize*i)
				end
			end
		end
	end
end

function WindActionShift_setAnchor(index)
	if (index == 1) then
		WindCommon_setPoint(StanceButton2, "LEFT", StanceButton1, "RIGHT", 6, 0)
		WindCommon_setPoint(StanceButton3, "LEFT", StanceButton2, "RIGHT", 6, 0)
		WindCommon_setPoint(StanceButton4, "LEFT", StanceButton3, "RIGHT", 6, 0)
		WindCommon_setPoint(StanceButton5, "LEFT", StanceButton4, "RIGHT", 6, 0)
		WindCommon_setPoint(StanceButton6, "LEFT", StanceButton5, "RIGHT", 6, 0)
		WindCommon_setPoint(StanceButton7, "LEFT", StanceButton6, "RIGHT", 6, 0)
		WindCommon_setPoint(StanceButton8, "LEFT", StanceButton7, "RIGHT", 6, 0)
		WindCommon_setPoint(StanceButton9, "LEFT", StanceButton8, "RIGHT", 6, 0)
		WindCommon_setPoint(StanceButton10, "LEFT", StanceButton9, "RIGHT", 6, 0)
	elseif (index == 2) then
		WindCommon_setPoint(StanceButton2, "TOPLEFT", StanceButton1, "BOTTOMLEFT", 0, -6)
		WindCommon_setPoint(StanceButton3, "LEFT", StanceButton1, "RIGHT", 6, 0)
		WindCommon_setPoint(StanceButton4, "TOPLEFT", StanceButton3, "BOTTOMLEFT", 0, -6)
		WindCommon_setPoint(StanceButton5, "LEFT", StanceButton3, "RIGHT", 6, 0)
		WindCommon_setPoint(StanceButton6, "TOPLEFT", StanceButton5, "BOTTOMLEFT", 0, -6)
		WindCommon_setPoint(StanceButton7, "LEFT", StanceButton5, "RIGHT", 6, 0)
		WindCommon_setPoint(StanceButton8, "TOPLEFT", StanceButton7, "BOTTOMLEFT", 0, -6)
		WindCommon_setPoint(StanceButton9, "LEFT", StanceButton7, "RIGHT", 6, 0)
		WindCommon_setPoint(StanceButton10, "TOPLEFT", StanceButton9, "BOTTOMLEFT", 0, -6)
	elseif (index == 3) then
		WindCommon_setPoint(StanceButton2, "LEFT", StanceButton1, "RIGHT", 6, 0)
		WindCommon_setPoint(StanceButton3, "TOPLEFT", StanceButton1, "BOTTOMLEFT", 0, -6)
		WindCommon_setPoint(StanceButton4, "LEFT", StanceButton3, "RIGHT", 6, 0)
		WindCommon_setPoint(StanceButton5, "TOPLEFT", StanceButton3, "BOTTOMLEFT", 0, -6)
		WindCommon_setPoint(StanceButton6, "LEFT", StanceButton5, "RIGHT", 6, 0)
		WindCommon_setPoint(StanceButton7, "TOPLEFT", StanceButton5, "BOTTOMLEFT", 0, -6)
		WindCommon_setPoint(StanceButton8, "LEFT", StanceButton7, "RIGHT", 6, 0)
		WindCommon_setPoint(StanceButton9, "TOPLEFT", StanceButton7, "BOTTOMLEFT", 0, -6)
		WindCommon_setPoint(StanceButton10, "LEFT", StanceButton9, "RIGHT", 6, 0)
	elseif (index == 4) then
		WindCommon_setPoint(StanceButton2, "TOPLEFT", StanceButton1, "BOTTOMLEFT", 0, -6)
		WindCommon_setPoint(StanceButton3, "TOPLEFT", StanceButton2, "BOTTOMLEFT", 0, -6)
		WindCommon_setPoint(StanceButton4, "TOPLEFT", StanceButton3, "BOTTOMLEFT", 0, -6)
		WindCommon_setPoint(StanceButton5, "TOPLEFT", StanceButton4, "BOTTOMLEFT", 0, -6)
		WindCommon_setPoint(StanceButton6, "TOPLEFT", StanceButton5, "BOTTOMLEFT", 0, -6)
		WindCommon_setPoint(StanceButton7, "TOPLEFT", StanceButton6, "BOTTOMLEFT", 0, -6)
		WindCommon_setPoint(StanceButton8, "TOPLEFT", StanceButton7, "BOTTOMLEFT", 0, -6)
		WindCommon_setPoint(StanceButton9, "TOPLEFT", StanceButton8, "BOTTOMLEFT", 0, -6)
		WindCommon_setPoint(StanceButton10, "TOPLEFT", StanceButton9, "BOTTOMLEFT", 0, -6)
	end
end

WindCommon_ColorBorder2 = {
	bgFile = "Interface/Tooltips/UI-Tooltip-Background",
	edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
	tile = true,
	tileSize = 20,
	edgeSize = 15,
	insets = { left = 3, right = 3, top = 3, bottom = 3 } }
function WindActionShift_setBorder()
	if (not WindActionShiftConfig or WindActionShiftConfig[6]) then
		WindActionShift:SetBackdrop(WindCommon_ColorBorder2)
		WindActionShift_setColor()
	else
		WindActionShift:SetBackdrop(nil)
	end
end

function WindActionShift_setColor()
	WindActionShift:SetBackdropBorderColor(WindActionShiftConfig[7][1].r, WindActionShiftConfig[7][1].g, WindActionShiftConfig[7][1].b, WindActionShiftConfig[7][1].a)
	WindActionShift:SetBackdropColor(WindActionShiftConfig[7][2].r, WindActionShiftConfig[7][2].g, WindActionShiftConfig[7][2].b, WindActionShiftConfig[7][2].a)
end

function WindActionShift_resetColor()
	WindActionShiftConfig[7] = WindActionDefault["Shift"][7]
	WindActionShift_setColor()
end

function WindActionShift_setView()
	if (not WindActionShiftConfig or WindActionShiftConfig[8]) then
		StanceBarFrame:Show();
	else
		StanceBarFrame:Hide();
	end
end
