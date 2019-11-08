WindActionBagSize = {
	{225, 55, 80, 0},
	{55, 225, 0, -80}
}

function WindActionBag_OnLoad(self)
	CharacterBag0Slot:SetParent(WindActionBag);
	CharacterBag1Slot:SetParent(WindActionBag);
	CharacterBag2Slot:SetParent(WindActionBag);
	CharacterBag3Slot:SetParent(WindActionBag);
	--KeyRingButton:SetParent(WindActionBag);
	--KeyRingButton:Show();
	WindActionBag:SetFrameStrata("MEDIUM");
	WindActionBag:SetFrameLevel(0)
	WindActionBag:RegisterEvent("VARIABLES_LOADED");
end

function WindActionBag_OnEvent(self, event, ...)
	if (event == "VARIABLES_LOADED") then
		WindActionBag_initConfig();
		WindActionBag_refresh();
	end
end

function WindActionBag_initConfig()
	if (not WindActionBagConfig) then WindActionBagConfig = WindActionDefault["Bag"]; end

	if (IsAddOnLoaded("WindConfig")) then
		WindActionConfigBag_show();
		WindActionConfigBag_setColor(color);
	end
end

function WindActionBag_resetConfig()
	WindActionBagConfig = WindActionDefault["Bag"];

	WindActionBag_refresh();

	if (IsAddOnLoaded("WindConfig")) then
		WindActionConfigBag_show();
		WindActionConfigBag_setColor(color);
	end
end

function WindActionBag_refresh()
	WindActionBag_setPoint();
	WindActionBag_setScale();
	WindActionBag_setSize();
	WindActionBag_setBorder();
	WindActionBag_setView();
end

function WindActionBag_setPoint()
	WindCommon_setPoint(WindActionBag, WindActionBagConfig[1], UIParent, WindActionBagConfig[1], WindActionBagConfig[2], WindActionBagConfig[3]);
end

function WindActionBag_setScale()
	WindActionBag:SetScale(WindActionBagConfig[4]);
end

function WindActionBag_setSize()
	local index = WindActionBagConfig[5];
  WindCommon_setParentPoint(MainMenuBarBackpackButton, WindActionBag, "CENTER", WindActionBag, "CENTER", WindActionBagSize[index][3], WindActionBagSize[index][4]);
	WindCommon_setSize(WindActionBag, WindActionBagSize[index][1], WindActionBagSize[index][2]);
	WindActionBag_setAnchor(index);
end

function WindActionBag_setAnchor(index)
	if (index == 1) then
		WindCommon_setPoint(CharacterBag0Slot, "RIGHT", MainMenuBarBackpackButton, "LEFT", -3, 0);
		WindCommon_setPoint(CharacterBag1Slot, "RIGHT", CharacterBag0Slot, "LEFT", -3, 0);
		WindCommon_setPoint(CharacterBag2Slot, "RIGHT", CharacterBag1Slot, "LEFT", -3, 0);
		WindCommon_setPoint(CharacterBag3Slot, "RIGHT", CharacterBag2Slot, "LEFT", -3, 0);
		--WindCommon_setPoint(KeyRingButton, "RIGHT", CharacterBag3Slot, "LEFT", -2.5, -0.5);
		--WindCommon_setSize(KeyRingButton, 18, 39);
		--KeyRingButton:SetNormalTexture("Interface/Buttons/UI-Button-KeyRing");
		--KeyRingButton:SetHighlightTexture("Interface/Buttons/UI-Button-KeyRing-Highlight");
		--KeyRingButton:SetPushedTexture("Interface/Buttons/UI-Button-KeyRing-Down");
	elseif (index == 2) then
		WindCommon_setPoint(CharacterBag0Slot, "BOTTOMRIGHT", MainMenuBarBackpackButton, "TOPRIGHT", 0, 3);
		WindCommon_setPoint(CharacterBag1Slot, "BOTTOMRIGHT", CharacterBag0Slot, "TOPRIGHT", 0, 3);
		WindCommon_setPoint(CharacterBag2Slot, "BOTTOMRIGHT", CharacterBag1Slot, "TOPRIGHT", 0, 3);
		WindCommon_setPoint(CharacterBag3Slot, "BOTTOMRIGHT", CharacterBag2Slot, "TOPRIGHT", 0, 3);
		--WindCommon_setPoint(KeyRingButton, "BOTTOMRIGHT", CharacterBag3Slot, "TOPRIGHT", 0.5, 0.5);
		--WindCommon_setSize(KeyRingButton, 39, 18);
		--KeyRingButton:SetNormalTexture("Interface\\AddOns\\WindAction\\Buttons\\UI-Button-KeyRing");
		--KeyRingButton:SetHighlightTexture("Interface\\AddOns\\WindAction\\Buttons\\UI-Button-KeyRing-Highlight");
		--KeyRingButton:SetPushedTexture("Interface\\AddOns\\WindAction\\Buttons\\UI-Button-KeyRing-Down");
	end
end

function WindActionBag_setBorder()
	if (not WindActionBagConfig or WindActionBagConfig[6]) then WindActionBag:SetBackdrop(WindCommon_ColorBorder);
	WindActionBag_setColor();
	else WindActionBag:SetBackdrop(nil); end
end

function WindActionBag_setColor()
	WindActionBag:SetBackdropBorderColor(WindActionBagConfig[7][1].r, WindActionBagConfig[7][1].g, WindActionBagConfig[7][1].b, WindActionBagConfig[7][1].a);
	WindActionBag:SetBackdropColor(WindActionBagConfig[7][2].r, WindActionBagConfig[7][2].g, WindActionBagConfig[7][2].b, WindActionBagConfig[7][2].a);
end

function WindActionBag_resetColor()
	WindActionBagConfig[7] = WindActionDefault["Bag"][7];
	WindActionBag_setColor();
end

function WindActionBag_setView()
	if (not WindActionBagConfig or WindActionBagConfig[8]) then WindActionBag:Show();
	else WindActionBag:Hide(); end
end