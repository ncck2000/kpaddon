function WindConfig_closeAll()
	if WindActionConfig then WindActionConfig:Hide(); end
	if WindBBConfig then WindBBConfig:Hide(); end
	if WindCastingConfig then WindCastingConfig:Hide(); end
	if WindChatConfig then WindChatConfig:Hide(); end
	if WindInfoConfig then WindInfoConfig:Hide(); end
	if WindMinimapConfig then WindMinimapConfig:Hide(); end
end

function WindConfig_resetAll()

	ReloadUI();

	if WindActionConfig then

		WindActionBody_resetConfig();
		WindActionMain_resetConfig();
		WindActionMenu_resetConfig();
		WindActionBag_resetConfig();
		WindActionBottomLeft_resetConfig();
		WindActionBottomRight_resetConfig();
		WindActionLeft_resetConfig();
		WindActionRight_resetConfig();
		WindActionPet_resetConfig();
		WindActionScroll_resetConfig();
		WindActionShift_resetConfig();
		WindActionVehicleLeave_resetConfig();
	end
	if WindBBConfig then end
	if WindCastingConfig then end
	if WindChatConfig then end
	if WindInfoConfig then
		WindInfoBag_resetConfig();
		WindInfoTime_resetConfig();
		WindInfoTick_resetConfig();
		WindInfoPerf_resetConfig();
		WindInfoMoney_resetConfig();
		WindInfoDura_resetConfig();
		WindInfoDate_resetConfig();
		WindInfoBody_resetConfig();
		WindInfoXP_resetConfig();
		WindInfoRP_resetConfig();
	end
	if WindMinimapConfig then end
end

function WindUserData_Save()
	if (WindActionDefault) then
		if (not WindActionUserData1) then
			WindActionUserData1 = {};
		end
		WindActionUserData1["Body"] = WindActionBodyConfig;
		WindActionUserData1["Main"] = WindActionMainConfig;
		WindActionUserData1["BottomLeft"] = WindActionBottomLeftConfig;
		WindActionUserData1["BottomRight"] = WindActionBottomRightConfig;
		WindActionUserData1["Left"] = WindActionLeftConfig;
		WindActionUserData1["Right"] = WindActionRightConfig;
		WindActionUserData1["Pet"] = WindActionPetConfig;
		WindActionUserData1["Shift"] = WindActionShiftConfig;
		WindActionUserData1["Bag"] = WindActionBagConfig;
		WindActionUserData1["Menu"] = WindActionMenuConfig;
		WindActionUserData1["Scroll"] = WindActionScrollConfig;
		WindActionUserData1["CastingBar"] = WindActionCastingBarConfig;
		WindActionUserData1["VehicleLeave"] = WindActionVehicleLeaveConfig;
	end

	if (WindInfoDefault) then
		if (not WindInfoUserData1) then
			WindInfoUserData1 = {};
		end
		WindInfoUserData1["Body"] = WindInfoBodyConfig;
		WindInfoUserData1["XP"] = WindInfoXPConfig;
		WindInfoUserData1["RP"] = WindInfoRPConfig;
		WindInfoUserData1["Bag"] = WindInfoBagConfig;
		WindInfoUserData1["Money"] = WindInfoMoneyConfig;
		WindInfoUserData1["Perf"] = WindInfoPerfConfig;
		WindInfoUserData1["Time"] = WindInfoTimeConfig;
		WindInfoUserData1["Date"] = WindInfoDateConfig;
		WindInfoUserData1["Dura"] = WindInfoDuraConfig;
		WindInfoUserData1["Tick"] = WindInfoTickConfig;
		WindInfoUserData1["Token"] = WindInfoTokenConfig;
	end

	if (WindBBDefault) then
		if (not WindBBUserData1) then
			WindBBUserData1 = {};
		end
		WindBBUserData1 = WindBBConfigAll;
	end
end

function WindUserData_Load()
	if (WindActionDefault and WindActionUserData1) then
		WindActionBodyConfig = WindActionUserData1["Body"];
		WindActionMainConfig = WindActionUserData1["Main"];
		WindActionBottomLeftConfig = WindActionUserData1["BottomLeft"];
		WindActionBottomRightConfig = WindActionUserData1["BottomRight"];
		WindActionLeftConfig = WindActionUserData1["Left"];
		WindActionRightConfig = WindActionUserData1["Right"];
		WindActionPetConfig = WindActionUserData1["Pet"];
		WindActionShiftConfig = WindActionUserData1["Shift"];
		WindActionBagConfig = WindActionUserData1["Bag"];
		WindActionMenuConfig = WindActionUserData1["Menu"];
		WindActionScrollConfig = WindActionUserData1["Scroll"];
		WindActionCastingBarConfig = WindActionUserData1["CastingBar"];
		WindActionVehicleLeaveConfig = WindActionUserData1["VehicleLeave"];
	end

	if (WindInfoDefault and WindInfoUserData1) then
		WindInfoBodyConfig = WindInfoUserData1["Body"];
		WindInfoXPConfig = WindInfoUserData1["XP"];
		WindInfoRPConfig = WindInfoUserData1["RP"];
		WindInfoBagConfig = WindInfoUserData1["Bag"];
		WindInfoMoneyConfig = WindInfoUserData1["Money"];
		WindInfoPerfConfig = WindInfoUserData1["Perf"];
		WindInfoTimeConfig = WindInfoUserData1["Time"];
		WindInfoDateConfig = WindInfoUserData1["Date"];
		WindInfoDuraConfig = WindInfoUserData1["Dura"];
		WindInfoTickConfig = WindInfoUserData1["Tick"];
		WindInfoTokenConfig = WindInfoUserData1["Token"];
	end

	if (WindBBDefault and WindBBUserData1) then
		WindBBConfigAll = WindBBUserData1;
	end

	if not InCombatLockdown() then
		if (WindActionDefault) then
			WindActionBody_refresh();
			WindActionMain_refresh();
			WindActionMenu_refresh();
			WindActionBag_refresh();
			WindActionBottomLeft_refresh();
			WindActionBottomRight_refresh();
			WindActionLeft_refresh();
			WindActionRight_refresh();
			WindActionPet_refresh();
			WindActionScroll_refresh();
			WindActionShift_refresh();
			WindActionVehicleLeave_refresh();
		end

		if (WindInfoDefault) then
			WindInfoBag_refresh();
			WindInfoTime_refresh();
			WindInfoPerf_refresh();
			WindInfoBody_refresh();
			WindInfoXP_refresh();
			WindInfoRP_refresh();
		end

		if (WindBBDefault) then
			WindBank_refresh();
		end
	end
end

function WindConfig_validScale(value)
	if (value <= 0) then value = 0.1; end
	if (value > 2) then value = 2.0; end
	return value;
end

function WindConfig_validX(point, value)
--	if (string.find(point, "LEFT") and (value < -10)) then value = -10; end
--	if (string.find(point, "RIGHT") and (value > 10)) then value = 10; end
	return value;
end

function WindConfig_validY(point, value)
--	if (string.find(point, "BOTTOM") and (value < -10)) then value = -10; end
--	if (string.find(point, "TOP") and (value > 10)) then value = 10; end
	return value;
end

function WindConfig_validWidthHeight(value)
	if (value <= 0) then value = 0.1; end
	return value;
end

function WindConfig_changePoint(self, point)
	local parent = self:GetParent():GetName();
	WindConfig_setUnCheckAll(parent);
	self:SetChecked(true);
	getglobal(parent.."X"):SetText("0");
	getglobal(parent.."Y"):SetText("0");
	getglobal(parent.."_setConfigPoint")(point, 0, 0);
end

function WindConfig_changeScale(self, isMove)
	local parent = self:GetParent():GetName();
	local scale = WindConfig_validScale(self:GetNumber());
	self:SetText(string.format("%0.3f", scale));
	getglobal(parent.."_setConfigScale")(scale);

	if (isMove) then getglobal(parent.."X"):SetFocus();
	else self:ClearFocus(); end
end

function WindConfig_changeX(self, isMove)
	local parent = self:GetParent():GetName();
	local x = WindConfig_validX(getglobal(parent.."_getPoint")(), self:GetNumber());
	self:SetText(x);
	getglobal(parent.."_setConfigX")(x);

	if (isMove) then getglobal(parent.."Y"):SetFocus();
	else self:ClearFocus(); end
end

function WindConfig_changeY(self)
	local parent = self:GetParent():GetName();
	local y = WindConfig_validY(getglobal(parent.."_getPoint")(), self:GetNumber());
	self:SetText(y);
	getglobal(parent.."_setConfigY")(y);

	self:ClearFocus();
end

function WindConfig_setUnCheckAll(target)
	getglobal(target.."TOPLEFT"):SetChecked(false);
	getglobal(target.."TOP"):SetChecked(false);
	getglobal(target.."TOPRIGHT"):SetChecked(false);
	getglobal(target.."LEFT"):SetChecked(false);
	getglobal(target.."CENTER"):SetChecked(false);
	getglobal(target.."RIGHT"):SetChecked(false);
	getglobal(target.."BOTTOMLEFT"):SetChecked(false);
	getglobal(target.."BOTTOM"):SetChecked(false);
	getglobal(target.."BOTTOMRIGHT"):SetChecked(false);
end

function WindConfig_setCheck(target, point)
	if (point == "TOPLEFT") then getglobal(target.."TOPLEFT"):SetChecked(true);
	elseif (point == "TOP") then getglobal(target.."TOP"):SetChecked(true);
	elseif (point == "TOPRIGHT") then getglobal(target.."TOPRIGHT"):SetChecked(true);
	elseif (point == "LEFT") then getglobal(target.."LEFT"):SetChecked(true);
	elseif (point == "CENTER") then getglobal(target.."CENTER"):SetChecked(true);
	elseif (point == "RIGHT") then getglobal(target.."RIGHT"):SetChecked(true);
	elseif (point == "BOTTOMLEFT") then getglobal(target.."BOTTOMLEFT"):SetChecked(true);
	elseif (point == "BOTTOM") then getglobal(target.."BOTTOM"):SetChecked(true);
	elseif (point == "BOTTOMRIGHT") then getglobal(target.."BOTTOMRIGHT"):SetChecked(true); end
end

function WindConfig_changeWidth(editbox, isMove)
	local parent = editbox:GetParent():GetName();
	local width = WindConfig_validWidthHeight(editbox:GetNumber());
	editbox:SetText(width);
	getglobal(parent.."_setWidth")(width);

	if (isMove) then getglobal(parent.."HEIGHT"):SetFocus();
	else editbox:ClearFocus(); end
end

function WindConfig_changeHeight(editbox)
	local parent = editbox:GetParent():GetName();
	local height = WindConfig_validWidthHeight(editbox:GetNumber());
	editbox:SetText(height);
	getglobal(parent.."_setHeight")(height);
	editbox:ClearFocus();
end

function WindConfig_changeDistance(editbox)
	local parent = editbox:GetParent():GetName();
	local distance = WindConfig_validWidthHeight(editbox:GetNumber());
	editbox:SetText(distance);
	getglobal(parent.."_setDistance")(distance);
	editbox:ClearFocus();
end

function WindConfig_changeView(self, btn, down)
	local parent = self:GetParent():GetName();
	--self:SetChecked(down);
	getglobal(parent.."_setView")(self:GetChecked());
end

function WindActionConfig_PositionReset()
	WindActionConfig:ClearAllPoints();
	WindActionConfig:SetPoint("TOPLEFT", "WindConfig", "TOPRIGHT", 0, -0);
end

function WindConfig_OpenColorPicker(color, useOpacity, swatch)
	local c={};
	c.r = color.r;
	c.g = color.g;
	c.b = color.b;
	if (useOpacity) then
		c.a = 1.0 - color.a;
	end
	if(not c.a) then
		c.a = 0.0;
	end
	WindConfig_Temp = {};
	WindConfig_Temp.CurrentColor = color;
	WindConfig_Temp.CurrentSwatch = swatch;
	ColorPickerFrame.opacity = c.a;
	ColorPickerFrame:SetColorRGB(c.r, c.g, c.b);
	ColorPickerFrame.previousValues = {r = c.r, g = c.g, b = c.b, a = c.a};
	ColorPickerFrame.hasOpacity = useOpacity;
	ColorPickerFrame.func = WindConfig_SaveColorPicker;
	ColorPickerFrame.cancelFunc = WindConfig_CancelColorPicker;
	ColorPickerFrame:Show();
	ColorPickerFrame:Raise();
end

function WindConfig_SaveColorPicker()
	local r, g, b = ColorPickerFrame:GetColorRGB();
	WindConfig_Temp.CurrentColor.r = r;
	WindConfig_Temp.CurrentColor.g = g;
	WindConfig_Temp.CurrentColor.b = b;
	if (ColorPickerFrame.hasOpacity) then
		 WindConfig_Temp.CurrentColor.a = 1.0 - OpacitySliderFrame:GetValue();
	end

	getglobal(WindConfig_Temp.CurrentSwatch.."NormalTexture"):SetVertexColor(r, g, b);

	if (not ColorPickerFrame:IsVisible()) then
		local parent = getglobal(WindConfig_Temp.CurrentSwatch):GetParent():GetName();
		if (getglobal(parent.."_changeColor")) then
			getglobal(parent.."_changeColor")(WindConfig_Temp.CurrentColor);
		elseif (getglobal(parent.."_setConfigColor")) then
			getglobal(parent.."_setConfigColor")(WindConfig_Temp.CurrentColor);
		else
			getglobal(parent.."_setColor")(WindConfig_Temp.CurrentColor);
		end
		ColorPickerFrame.func = nil;
		ColorPickerFrame.cancelFunc = nil;
	end

end

function WindConfig_CancelColorPicker()
	WindConfig_Temp.CurrentColor.r = ColorPickerFrame.previousValues.r;
	WindConfig_Temp.CurrentColor.g = ColorPickerFrame.previousValues.g;
	WindConfig_Temp.CurrentColor.b = ColorPickerFrame.previousValues.b;
	if (ColorPickerFrame.hasOpacity) then
		 WindConfig_Temp.CurrentColor.a = 1.0 - ColorPickerFrame.previousValues.a;
	end

	getglobal(WindConfig_Temp.CurrentSwatch.."NormalTexture"):SetVertexColor(ColorPickerFrame.previousValues.r, ColorPickerFrame.previousValues.g, ColorPickerFrame.previousValues.b);

	if (not ColorPickerFrame:IsVisible()) then
		local parent = getglobal(WindConfig_Temp.CurrentSwatch):GetParent():GetName();
		if (getglobal(parent.."_changeColor")) then
			getglobal(parent.."_changeColor")(WindConfig_Temp.CurrentColor);
		elseif (getglobal(parent.."_setConfigColor")) then
			getglobal(parent.."_setConfigColor")(WindConfig_Temp.CurrentColor);
		else
			getglobal(parent.."_setColor")(WindConfig_Temp.CurrentColor);
		end
		ColorPickerFrame.func = nil;
		ColorPickerFrame.cancelFunc = nil;
	end
end
