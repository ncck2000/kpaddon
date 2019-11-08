WindActionPetSize = {{355, 49},	{185, 83},	{83, 185},	{49, 355}}

function WindActionPet_OnLoad(self)
	self:RegisterEvent("VARIABLES_LOADED");
	WindActionPet:Show()
	WindActionPet:SetFrameStrata("MEDIUM");-- MEDIUM , BACKGROUND, HIGH
	WindActionPet:SetFrameLevel(9)
	WindActionPet:SetParent(PetActionButton1)
end

function WindActionPet_OnShow(self)
	WindActionPet_setBorder()
end

function WindActionPet_OnHide(self)
	WindActionPet:SetBackdrop(nil);
end

function WindActionPet_Update()
	if ( PetHasActionBar() and UnitIsVisible("pet") ) then
		WindActionPet_OnShow();
	else
		WindActionPet_OnHide();--WindActionPet:Hide();
	end
end

hooksecurefunc("ShowPetActionBar", WindActionPet_Update)
hooksecurefunc("HidePetActionBar", WindActionPet_Update)--PossessBar_Update

function WindActionPet_OnEvent(self, event, ...)
	if (event == "VARIABLES_LOADED") then
		WindActionPet_initConfig();
		WindActionPet_refresh();
		WindActionPet_Update();
	end
end

function WindActionPet_initConfig()
	if (not WindActionPetConfig) then
		WindActionPetConfig = WindActionDefault["Pet"];

		local _, class = UnitClass("player");
		if ( class == "DEATHKNIGHT") then
			WindActionPetConfig[2] = 69
		elseif ( class == "SHAMAN" or class == "DRUID" ) then
		elseif ( class == "WARLOCK" ) then
			--WindActionPetConfig[2] = 69
		elseif ( class == "PALADIN" ) then
		end
	end

	if (IsAddOnLoaded("WindConfig")) then
		WindActionConfigPet_show();
		WindActionConfigPet_setColor(color);
	end
end

function WindActionPet_resetConfig()
	WindActionPetConfig = WindActionDefault["Pet"];

	local _, class = UnitClass("player");
	if ( class == "DEATHKNIGHT") then
		WindActionPetConfig[2] = 69
	elseif ( class == "SHAMAN" or class == "DRUID" ) then
	elseif ( class == "WARLOCK" ) then
		--WindActionPetConfig[2] = 69
	elseif ( class == "PALADIN" ) then
	end

	WindActionPet_refresh();

	if (IsAddOnLoaded("WindConfig")) then
		WindActionConfigPet_show();
		WindActionConfigPet_setColor(color);
	end
end

function WindActionPet_refresh()
	WindActionPet_setPointAndSize();
	WindActionPet_setBorder();
	WindActionPet_setScale();
end

function WindActionPet_setPointAndSize()
	local index = WindActionPetConfig[5];
	WindCommon_setSize(WindActionPet, WindActionPetSize[index][1], WindActionPetSize[index][2]);
	WindCommon_setPoint(WindActionPet, WindActionPetConfig[1], UIParent, WindActionPetConfig[1], WindActionPetConfig[2], WindActionPetConfig[3]);
	-- ÆÖ ¾×¼Ç¹öÆ° À§Ä¡ ¼³Á¤
	WindCommon_setPoint(PetActionButton1, "TOPLEFT", WindActionPet, "TOPLEFT", 10, -9);
	WindActionPet_setAnchor(index);
end


function WindActionPet_setScale()
	--WindActionPet:SetScale(WindActionPetConfig[4]);
	for i=1, 10 do
		getglobal("PetActionButton"..i):SetScale(WindActionPetConfig[4]);
		-- Frame Strata¸¦ ³·Ãá´Ù.
		getglobal("PetActionButton"..i):SetFrameStrata("HIGH");
		getglobal("PetActionButton"..i):SetFrameLevel(5)
	end
	WindActionPet:SetFrameStrata("MEDIUM")
end

function WindActionPet_setAnchor(index)
	if (index == 1) then
		WindCommon_setPoint(PetActionButton2, "LEFT", PetActionButton1, "RIGHT", 4, 0);
		WindCommon_setPoint(PetActionButton3, "LEFT", PetActionButton2, "RIGHT", 4, 0);
		WindCommon_setPoint(PetActionButton4, "LEFT", PetActionButton3, "RIGHT", 4, 0);
		WindCommon_setPoint(PetActionButton5, "LEFT", PetActionButton4, "RIGHT", 4, 0);
		WindCommon_setPoint(PetActionButton6, "LEFT", PetActionButton5, "RIGHT", 4, 0);
		WindCommon_setPoint(PetActionButton7, "LEFT", PetActionButton6, "RIGHT", 4, 0);
		WindCommon_setPoint(PetActionButton8, "LEFT", PetActionButton7, "RIGHT", 4, 0);
		WindCommon_setPoint(PetActionButton9, "LEFT", PetActionButton8, "RIGHT", 4, 0);
		WindCommon_setPoint(PetActionButton10, "LEFT", PetActionButton9, "RIGHT", 4, 0);
	elseif (index == 2) then
		WindCommon_setPoint(PetActionButton2, "LEFT", PetActionButton1, "RIGHT", 4, 0);
		WindCommon_setPoint(PetActionButton3, "LEFT", PetActionButton2, "RIGHT", 4, 0);
		WindCommon_setPoint(PetActionButton4, "LEFT", PetActionButton3, "RIGHT", 4, 0);
		WindCommon_setPoint(PetActionButton5, "LEFT", PetActionButton4, "RIGHT", 4, 0);
		WindCommon_setPoint(PetActionButton6, "TOPLEFT", PetActionButton1, "BOTTOMLEFT", 0, -4);
		WindCommon_setPoint(PetActionButton7, "LEFT", PetActionButton6, "RIGHT", 4, 0);
		WindCommon_setPoint(PetActionButton8, "LEFT", PetActionButton7, "RIGHT", 4, 0);
		WindCommon_setPoint(PetActionButton9, "LEFT", PetActionButton8, "RIGHT", 4, 0);
		WindCommon_setPoint(PetActionButton10, "LEFT", PetActionButton9, "RIGHT", 4, 0);
	elseif (index == 3) then
		WindCommon_setPoint(PetActionButton2, "LEFT", PetActionButton1, "RIGHT", 4, 0);
		WindCommon_setPoint(PetActionButton3, "TOPLEFT", PetActionButton1, "BOTTOMLEFT", 0, -4);
		WindCommon_setPoint(PetActionButton4, "LEFT", PetActionButton3, "RIGHT", 4, 0);
		WindCommon_setPoint(PetActionButton5, "TOPLEFT", PetActionButton3, "BOTTOMLEFT", 0, -4);
		WindCommon_setPoint(PetActionButton6, "LEFT", PetActionButton5, "RIGHT", 4, 0);
		WindCommon_setPoint(PetActionButton7, "TOPLEFT", PetActionButton5, "BOTTOMLEFT", 0, -4);
		WindCommon_setPoint(PetActionButton8, "LEFT", PetActionButton7, "RIGHT", 4, 0);
		WindCommon_setPoint(PetActionButton9, "TOPLEFT", PetActionButton7, "BOTTOMLEFT", 0, -4);
		WindCommon_setPoint(PetActionButton10, "LEFT", PetActionButton9, "RIGHT", 4, 0);
	elseif (index == 4) then
		WindCommon_setPoint(PetActionButton2, "TOPLEFT", PetActionButton1, "BOTTOMLEFT", 0, -4);
		WindCommon_setPoint(PetActionButton3, "TOPLEFT", PetActionButton2, "BOTTOMLEFT", 0, -4);
		WindCommon_setPoint(PetActionButton4, "TOPLEFT", PetActionButton3, "BOTTOMLEFT", 0, -4);
		WindCommon_setPoint(PetActionButton5, "TOPLEFT", PetActionButton4, "BOTTOMLEFT", 0, -4);
		WindCommon_setPoint(PetActionButton6, "TOPLEFT", PetActionButton5, "BOTTOMLEFT", 0, -4);
		WindCommon_setPoint(PetActionButton7, "TOPLEFT", PetActionButton6, "BOTTOMLEFT", 0, -4);
		WindCommon_setPoint(PetActionButton8, "TOPLEFT", PetActionButton7, "BOTTOMLEFT", 0, -4);
		WindCommon_setPoint(PetActionButton9, "TOPLEFT", PetActionButton8, "BOTTOMLEFT", 0, -4);
		WindCommon_setPoint(PetActionButton10, "TOPLEFT", PetActionButton9, "BOTTOMLEFT", 0, -4);
	end
end

WindCommon_ColorBorder2 = {
	bgFile = "Interface/Tooltips/UI-Tooltip-Background",
	edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
	tile = true,
	tileSize = 20,
	edgeSize = 15,
	insets = { left = 3, right = 3, top = 3, bottom = 3 } }
function WindActionPet_setBorder()
	if (not WindActionPetConfig or WindActionPetConfig[6]) then
		WindActionPet:SetBackdrop(WindCommon_ColorBorder2);
		if WindActionPetConfig then
			WindActionPet_setColor();
		end
	else
		WindActionPet:SetBackdrop(nil);
	end
end

function WindActionPet_setColor()
	WindActionPet:SetBackdropBorderColor(WindActionPetConfig[7][1].r, WindActionPetConfig[7][1].g, WindActionPetConfig[7][1].b, WindActionPetConfig[7][1].a);
	WindActionPet:SetBackdropColor(WindActionPetConfig[7][2].r, WindActionPetConfig[7][2].g, WindActionPetConfig[7][2].b, WindActionPetConfig[7][2].a);
end

function WindActionPet_resetColor()
	WindActionPetConfig[7] = WindActionDefault["Pet"][7];
	WindActionPet_setColor();
end
