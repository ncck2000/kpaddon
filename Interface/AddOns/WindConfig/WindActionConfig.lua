function WindActionConfig_OnShow()
	WindActionConfigMain_show();
	WindActionConfigBottomLeft_show();
	WindActionConfigBottomRight_show();
	WindActionConfigMenu_show();
	WindActionConfigRight_show();
	WindActionConfigLeft_show();
	WindActionConfigBag_show();
	WindActionConfigPet_show();
	WindActionConfigShift_show();
	if (WindActionScroll) then WindActionConfigScroll_show(); end
	if (WindActionExtension) then WindActionConfigExtension_show(); end
	WindActionConfigVehicleLeave_show();
end

function WindActionConfigVIEWBR_OnClick(self)
	local parent = self:GetParent():GetName();
	if (self:GetChecked()) then
		self:SetChecked(true);
		getglobal(parent.."_setBorder")(true);
	else
		self:SetChecked(false);
		getglobal(parent.."_setBorder")(false);
	end
end

function WindActionConfigVIEWTOOLTIP_OnClick(self)
	local parent = self:GetParent():GetName();
	if (self:GetChecked()) then
		self:SetChecked(true);
		getglobal(parent.."_setTooltip")(true);
	else
		self:SetChecked(false);
		getglobal(parent.."_setTooltip")(false);
	end
end

function WindActionConfig_clearType(target)
	local line = nil;
	for i=1, 8 do
		line = getglobal(target.."Line"..i);
		if (line) then line:SetChecked(false); end
	end
end

function WindActionConfigLine_OnClick(self, nmb)
	local parent = self:GetParent():GetName();
	getglobal(parent.."_setType")(nmb);
end

function WindActionConfigMain_show()
	WindConfig_setUnCheckAll("WindActionConfigMain");
	WindConfig_setCheck("WindActionConfigMain", WindActionMainConfig[1]);
	WindActionConfigMainX:SetText(WindActionMainConfig[2]);
	WindActionConfigMainY:SetText(WindActionMainConfig[3]);
	WindActionConfigMainSCALE:SetText(string.format("%0.3f", WindActionMainConfig[4]));
	if (WindActionMainConfig[6]) then WindActionConfigMainVIEWBR:SetChecked(true);
	else WindActionConfigMainVIEWBR:SetChecked(false); end
	WindActionConfigMain_setLine();
	if (WindActionMainConfig[7]) then WindActionConfigMainCOLOR1NormalTexture:SetVertexColor(WindActionMainConfig[7][1].r, WindActionMainConfig[7][1].g, WindActionMainConfig[7][1].b, WindActionMainConfig[7][1].a);
	WindActionConfigMainCOLOR2NormalTexture:SetVertexColor(WindActionMainConfig[7][2].r, WindActionMainConfig[7][2].g, WindActionMainConfig[7][2].b, WindActionMainConfig[7][2].a); end
end

function WindActionConfigMain_setLine()
	WindActionConfig_clearType("WindActionConfigMain");
	getglobal("WindActionConfigMainLine"..WindActionMainConfig[5]):SetChecked(true);
end

function WindActionConfigMain_setConfigPoint(point, x, y)
	WindActionMainConfig[1] = point;
	WindActionMainConfig[2] = x;
	WindActionMainConfig[3] = y;
	WindActionMain_setPointAndSize();
end

function WindActionConfigMain_setConfigX(x)
	WindActionMainConfig[2] = x;
	WindActionMain_setPointAndSize();
end

function WindActionConfigMain_setConfigY(y)
	WindActionMainConfig[3] = y;
	WindActionMain_setPointAndSize();
end

function WindActionConfigMain_setConfigScale(scale)
	WindActionMainConfig[4] = scale;
	WindActionMain_setScale();
end

function WindActionConfigMain_getPoint()
	return WindActionMainConfig[1];
end

function WindActionConfigMain_setBorder(haveBorder)
	WindActionMainConfig[6] = haveBorder;
	WindActionMain_setBorder();
end

function WindActionConfigMain_setType(nmb)
	WindActionMainConfig[5] = nmb;
	WindActionConfigMain_setLine();
	WindActionMain_setPointAndSize();
end

function WindActionConfigMain_setColor(color)
	if (color) then
		WindActionMain_setColor();
	end
end

function WindActionConfigMain_resetColor()
	WindActionMain_resetColor();

	local colorArray = WindActionMainConfig[7];
	WindActionConfigMainCOLOR1NormalTexture:SetVertexColor(colorArray[1].r, colorArray[1].g, colorArray[1].b, colorArray[1].a);
	WindActionConfigMainCOLOR2NormalTexture:SetVertexColor(colorArray[2].r, colorArray[2].g, colorArray[2].b, colorArray[2].a);
end

function WindActionConfigBottomLeft_show()
	WindConfig_setUnCheckAll("WindActionConfigBottomLeft");
	WindConfig_setCheck("WindActionConfigBottomLeft", WindActionBottomLeftConfig[1]);
	WindActionConfigBottomLeftX:SetText(WindActionBottomLeftConfig[2]);
	WindActionConfigBottomLeftY:SetText(WindActionBottomLeftConfig[3]);
	WindActionConfigBottomLeftSCALE:SetText(string.format("%0.3f", WindActionBottomLeftConfig[4]));
	if (WindActionBottomLeftConfig[6]) then WindActionConfigBottomLeftVIEWBR:SetChecked(true);
	else WindActionConfigBottomLeftVIEWBR:SetChecked(false); end
	WindActionConfigBottomLeft_setLine();
	if (WindActionBottomLeftConfig[7]) then WindActionConfigBottomLeftCOLOR1NormalTexture:SetVertexColor(WindActionBottomLeftConfig[7][1].r, WindActionBottomLeftConfig[7][1].g, WindActionBottomLeftConfig[7][1].b, WindActionBottomLeftConfig[7][1].a);
	WindActionConfigBottomLeftCOLOR2NormalTexture:SetVertexColor(WindActionBottomLeftConfig[7][2].r, WindActionBottomLeftConfig[7][2].g, WindActionBottomLeftConfig[7][2].b, WindActionBottomLeftConfig[7][2].a); end
end

function WindActionConfigBottomLeft_setLine()
	WindActionConfig_clearType("WindActionConfigBottomLeft");
	getglobal("WindActionConfigBottomLeftLine"..WindActionBottomLeftConfig[5]):SetChecked(true);
end

function WindActionConfigBottomLeft_setConfigPoint(point, x, y)
	WindActionBottomLeftConfig[1] = point;
	WindActionBottomLeftConfig[2] = x;
	WindActionBottomLeftConfig[3] = y;
	WindActionBottomLeft_setPoint();
end

function WindActionConfigBottomLeft_setConfigX(x)
	WindActionBottomLeftConfig[2] = x;
	WindActionBottomLeft_setPoint();
end

function WindActionConfigBottomLeft_setConfigY(y)
	WindActionBottomLeftConfig[3] = y;
	WindActionBottomLeft_setPoint();
end

function WindActionConfigBottomLeft_setConfigScale(scale)
	WindActionBottomLeftConfig[4] = scale;
	WindActionBottomLeft_setScale();
end

function WindActionConfigBottomLeft_getPoint()
	return WindActionBottomLeftConfig[1];
end

function WindActionConfigBottomLeft_setBorder(haveBorder)
	WindActionBottomLeftConfig[6] = haveBorder;
	WindActionBottomLeft_setBorder();
end

function WindActionConfigBottomLeft_setType(nmb)
	WindActionBottomLeftConfig[5] = nmb;
	WindActionConfigBottomLeft_setLine();
	WindActionBottomLeft_setSize();
end

function WindActionConfigBottomLeft_setColor(color)
	if (color) then WindActionBottomLeft_setColor(); end
end

function WindActionConfigBottomLeft_resetColor()
	WindActionBottomLeft_resetColor();

	local colorArray = WindActionBottomLeftConfig[7];
	WindActionConfigBottomLeftCOLOR1NormalTexture:SetVertexColor(colorArray[1].r, colorArray[1].g, colorArray[1].b, colorArray[1].a);
	WindActionConfigBottomLeftCOLOR2NormalTexture:SetVertexColor(colorArray[2].r, colorArray[2].g, colorArray[2].b, colorArray[2].a);
end


function WindActionConfigBottomRight_show()
	WindConfig_setUnCheckAll("WindActionConfigBottomRight");
	WindConfig_setCheck("WindActionConfigBottomRight", WindActionBottomRightConfig[1]);
	WindActionConfigBottomRightX:SetText(WindActionBottomRightConfig[2]);
	WindActionConfigBottomRightY:SetText(WindActionBottomRightConfig[3]);
	WindActionConfigBottomRightSCALE:SetText(string.format("%0.3f", WindActionBottomRightConfig[4]));
	if (WindActionBottomRightConfig[6]) then WindActionConfigBottomRightVIEWBR:SetChecked(true);
	else WindActionConfigBottomRightVIEWBR:SetChecked(false); end
	WindActionConfigBottomRight_setLine();
	if (WindActionBottomRightConfig[7]) then WindActionConfigBottomRightCOLOR1NormalTexture:SetVertexColor(WindActionBottomRightConfig[7][1].r, WindActionBottomRightConfig[7][1].g, WindActionBottomRightConfig[7][1].b, WindActionBottomRightConfig[7][1].a);
	WindActionConfigBottomRightCOLOR2NormalTexture:SetVertexColor(WindActionBottomRightConfig[7][2].r, WindActionBottomRightConfig[7][2].g, WindActionBottomRightConfig[7][2].b, WindActionBottomRightConfig[7][2].a); end
end

function WindActionConfigBottomRight_setLine()
	WindActionConfig_clearType("WindActionConfigBottomRight");
	getglobal("WindActionConfigBottomRightLine"..WindActionBottomRightConfig[5]):SetChecked(true);
end

function WindActionConfigBottomRight_setConfigPoint(point, x, y)
	WindActionBottomRightConfig[1] = point;
	WindActionBottomRightConfig[2] = x;
	WindActionBottomRightConfig[3] = y;
	WindActionBottomRight_setPoint();
end

function WindActionConfigBottomRight_setConfigX(x)
	WindActionBottomRightConfig[2] = x;
	WindActionBottomRight_setPoint();
end

function WindActionConfigBottomRight_setConfigY(y)
	WindActionBottomRightConfig[3] = y;
	WindActionBottomRight_setPoint();
end

function WindActionConfigBottomRight_setConfigScale(scale)
	WindActionBottomRightConfig[4] = scale;
	WindActionBottomRight_setScale();
end

function WindActionConfigBottomRight_getPoint()
	return WindActionBottomRightConfig[1];
end

function WindActionConfigBottomRight_setBorder(haveBorder)
	WindActionBottomRightConfig[6] = haveBorder;
	WindActionBottomRight_setBorder();
end

function WindActionConfigBottomRight_setType(nmb)
	WindActionBottomRightConfig[5] = nmb;
	WindActionConfigBottomRight_setLine();
	WindActionBottomRight_setSize();
end

function WindActionConfigBottomRight_setColor(color)
	if (color) then WindActionBottomRight_setColor(); end
end

function WindActionConfigBottomRight_resetColor()
	WindActionBottomRight_resetColor();

	local colorArray = WindActionBottomRightConfig[7];
	WindActionConfigBottomRightCOLOR1NormalTexture:SetVertexColor(colorArray[1].r, colorArray[1].g, colorArray[1].b, colorArray[1].a);
	WindActionConfigBottomRightCOLOR2NormalTexture:SetVertexColor(colorArray[2].r, colorArray[2].g, colorArray[2].b, colorArray[2].a);
end


function WindActionConfigMenu_show()
	WindConfig_setUnCheckAll("WindActionConfigMenu");
	WindConfig_setCheck("WindActionConfigMenu", WindActionMenuConfig[1]);
	WindActionConfigMenuX:SetText(WindActionMenuConfig[2]);
	WindActionConfigMenuY:SetText(WindActionMenuConfig[3]);
	WindActionConfigMenuSCALE:SetText(string.format("%0.3f", WindActionMenuConfig[4]));
	if (WindActionMenuConfig[6]) then WindActionConfigMenuVIEWBR:SetChecked(true);
	else WindActionConfigMenuVIEWBR:SetChecked(false); end
	if (WindActionMenuConfig[7]) then WindActionConfigMenuCOLOR1NormalTexture:SetVertexColor(WindActionMenuConfig[7][1].r, WindActionMenuConfig[7][1].g, WindActionMenuConfig[7][1].b, WindActionMenuConfig[7][1].a);
	WindActionConfigMenuCOLOR2NormalTexture:SetVertexColor(WindActionMenuConfig[7][2].r, WindActionMenuConfig[7][2].g, WindActionMenuConfig[7][2].b, WindActionMenuConfig[7][2].a); end
	if (WindActionMenuConfig[8]) then WindActionConfigMenuVIEW:SetChecked(true);
	else WindActionConfigMenuVIEW:SetChecked(false); end
	WindActionConfigMenu_setLine();
end

function WindActionConfigMenu_setLine()
	WindActionConfig_clearType("WindActionConfigMenu");
	getglobal("WindActionConfigMenuLine"..WindActionMenuConfig[5]):SetChecked(true);
end

function WindActionConfigMenu_setConfigPoint(point, x, y)
	WindActionMenuConfig[1] = point;
	WindActionMenuConfig[2] = x;
	WindActionMenuConfig[3] = y;
	WindActionMenu_setPoint();
end

function WindActionConfigMenu_setConfigX(x)
	WindActionMenuConfig[2] = x;
	WindActionMenu_setPoint();
end

function WindActionConfigMenu_setConfigY(y)
	WindActionMenuConfig[3] = y;
	WindActionMenu_setPoint();
end

function WindActionConfigMenu_setConfigScale(scale)
	WindActionMenuConfig[4] = scale;
	WindActionMenu_setScale();
end

function WindActionConfigMenu_getPoint()
	return WindActionMenuConfig[1];
end

function WindActionConfigMenu_setBorder(haveBorder)
	WindActionMenuConfig[6] = haveBorder;
	WindActionMenu_setBorder();
end

function WindActionConfigMenu_setType(nmb)
	WindActionMenuConfig[5] = nmb;
	WindActionConfigMenu_setLine();
	WindActionMenu_setSize();
end

function WindActionConfigMenu_setColor(color)
	if (color) then WindActionMenu_setColor(); end
end

function WindActionConfigMenu_resetColor()
	WindActionMenu_resetColor();

	local colorArray = WindActionMenuConfig[7];
	WindActionConfigMenuCOLOR1NormalTexture:SetVertexColor(colorArray[1].r, colorArray[1].g, colorArray[1].b, colorArray[1].a);
	WindActionConfigMenuCOLOR2NormalTexture:SetVertexColor(colorArray[2].r, colorArray[2].g, colorArray[2].b, colorArray[2].a);
end

function WindActionConfigMenu_setView(isView)
	WindActionMenuConfig[8] = isView;
	WindActionMenu_setView();
end

function WindActionConfigRight_show()
	WindConfig_setUnCheckAll("WindActionConfigRight");
	WindConfig_setCheck("WindActionConfigRight", WindActionRightConfig[1]);
	WindActionConfigRightX:SetText(WindActionRightConfig[2]);
	WindActionConfigRightY:SetText(WindActionRightConfig[3]);
	WindActionConfigRightSCALE:SetText(string.format("%0.3f", WindActionRightConfig[4]));
	if (WindActionRightConfig[6]) then WindActionConfigRightVIEWBR:SetChecked(true);
	else WindActionConfigRightVIEWBR:SetChecked(false); end
	WindActionConfigRight_setLine();
	if (WindActionRightConfig[7]) then WindActionConfigRightCOLOR1NormalTexture:SetVertexColor(WindActionRightConfig[7][1].r, WindActionRightConfig[7][1].g, WindActionRightConfig[7][1].b, WindActionRightConfig[7][1].a);
	WindActionConfigRightCOLOR2NormalTexture:SetVertexColor(WindActionRightConfig[7][2].r, WindActionRightConfig[7][2].g, WindActionRightConfig[7][2].b, WindActionRightConfig[7][2].a); end
end

function WindActionConfigRight_setLine()
	WindActionConfig_clearType("WindActionConfigRight");
	getglobal("WindActionConfigRightLine"..WindActionRightConfig[5]):SetChecked(true);
end

function WindActionConfigRight_setConfigPoint(point, x, y)
	WindActionRightConfig[1] = point;
	WindActionRightConfig[2] = x;
	WindActionRightConfig[3] = y;
	WindActionRight_setPoint();
end

function WindActionConfigRight_setConfigX(x)
	WindActionRightConfig[2] = x;
	WindActionRight_setPoint();
end

function WindActionConfigRight_setConfigY(y)
	WindActionRightConfig[3] = y;
	WindActionRight_setPoint();
end

function WindActionConfigRight_setConfigScale(scale)
	WindActionRightConfig[4] = scale;
	WindActionRight_setScale();
end

function WindActionConfigRight_getPoint()
	return WindActionRightConfig[1];
end

function WindActionConfigRight_setBorder(haveBorder)
	WindActionRightConfig[6] = haveBorder;
	WindActionRight_setBorder();
end

function WindActionConfigRight_setType(nmb)
	WindActionRightConfig[5] = nmb;
	WindActionConfigRight_setLine();
	WindActionRight_setSize();
end

function WindActionConfigRight_setColor(color)
	if (color) then WindActionRight_setColor(); end
end

function WindActionConfigRight_resetColor()
	WindActionRight_resetColor();

	local colorArray = WindActionRightConfig[7];
	WindActionConfigRightCOLOR1NormalTexture:SetVertexColor(colorArray[1].r, colorArray[1].g, colorArray[1].b, colorArray[1].a);
	WindActionConfigRightCOLOR2NormalTexture:SetVertexColor(colorArray[2].r, colorArray[2].g, colorArray[2].b, colorArray[2].a);
end

function WindActionConfigLeft_show()
	WindConfig_setUnCheckAll("WindActionConfigLeft");
	WindConfig_setCheck("WindActionConfigLeft", WindActionLeftConfig[1]);
	WindActionConfigLeftX:SetText(WindActionLeftConfig[2]);
	WindActionConfigLeftY:SetText(WindActionLeftConfig[3]);
	WindActionConfigLeftSCALE:SetText(string.format("%0.3f", WindActionLeftConfig[4]));
	if (WindActionLeftConfig[6]) then WindActionConfigLeftVIEWBR:SetChecked(true);
	else WindActionConfigLeftVIEWBR:SetChecked(false); end
	WindActionConfigLeft_setLine();
	if (WindActionLeftConfig[7]) then WindActionConfigLeftCOLOR1NormalTexture:SetVertexColor(WindActionLeftConfig[7][1].r, WindActionLeftConfig[7][1].g, WindActionLeftConfig[7][1].b, WindActionLeftConfig[7][1].a);
	WindActionConfigLeftCOLOR2NormalTexture:SetVertexColor(WindActionLeftConfig[7][2].r, WindActionLeftConfig[7][2].g, WindActionLeftConfig[7][2].b, WindActionLeftConfig[7][2].a); end
end

function WindActionConfigLeft_setLine()
	WindActionConfig_clearType("WindActionConfigLeft");
	getglobal("WindActionConfigLeftLine"..WindActionLeftConfig[5]):SetChecked(true);
end

function WindActionConfigLeft_setConfigPoint(point, x, y)
	WindActionLeftConfig[1] = point;
	WindActionLeftConfig[2] = x;
	WindActionLeftConfig[3] = y;
	WindActionLeft_setPoint();
end

function WindActionConfigLeft_setConfigX(x)
	WindActionLeftConfig[2] = x;
	WindActionLeft_setPoint();
end

function WindActionConfigLeft_setConfigY(y)
	WindActionLeftConfig[3] = y;
	WindActionLeft_setPoint();
end

function WindActionConfigLeft_setConfigScale(scale)
	WindActionLeftConfig[4] = scale;
	WindActionLeft_setScale();
end

function WindActionConfigLeft_getPoint()
	return WindActionLeftConfig[1];
end

function WindActionConfigLeft_setBorder(haveBorder)
	WindActionLeftConfig[6] = haveBorder;
	WindActionLeft_setBorder();
end

function WindActionConfigLeft_setType(nmb)
	WindActionLeftConfig[5] = nmb;
	WindActionConfigLeft_setLine();
	WindActionLeft_setSize();
end

function WindActionConfigLeft_setColor(color)
	if (color) then WindActionLeft_setColor(); end
end

function WindActionConfigLeft_resetColor()
	WindActionLeft_resetColor();

	local colorArray = WindActionLeftConfig[7];
	WindActionConfigLeftCOLOR1NormalTexture:SetVertexColor(colorArray[1].r, colorArray[1].g, colorArray[1].b, colorArray[1].a);
	WindActionConfigLeftCOLOR2NormalTexture:SetVertexColor(colorArray[2].r, colorArray[2].g, colorArray[2].b, colorArray[2].a);
end

function WindActionConfigBag_show()
	WindConfig_setUnCheckAll("WindActionConfigBag");
	WindConfig_setCheck("WindActionConfigBag", WindActionBagConfig[1]);
	WindActionConfigBagX:SetText(WindActionBagConfig[2]);
	WindActionConfigBagY:SetText(WindActionBagConfig[3]);
	WindActionConfigBagSCALE:SetText(string.format("%0.3f", WindActionBagConfig[4]));
	if (WindActionBagConfig[6]) then WindActionConfigBagVIEWBR:SetChecked(true);
	else WindActionConfigBagVIEWBR:SetChecked(false); end
	if (WindActionBagConfig[7]) then WindActionConfigBagCOLOR1NormalTexture:SetVertexColor(WindActionBagConfig[7][1].r, WindActionBagConfig[7][1].g, WindActionBagConfig[7][1].b, WindActionBagConfig[7][1].a);
	WindActionConfigBagCOLOR2NormalTexture:SetVertexColor(WindActionBagConfig[7][2].r, WindActionBagConfig[7][2].g, WindActionBagConfig[7][2].b, WindActionBagConfig[7][2].a); end
	if (WindActionBagConfig[8]) then WindActionConfigBagVIEW:SetChecked(true);
	else WindActionConfigBagVIEW:SetChecked(false); end
	WindActionConfigBag_setLine();
end

function WindActionConfigBag_setLine()
	WindActionConfig_clearType("WindActionConfigBag");
	getglobal("WindActionConfigBagLine"..WindActionBagConfig[5]):SetChecked(true);
end

function WindActionConfigBag_setConfigPoint(point, x, y)
	WindActionBagConfig[1] = point;
	WindActionBagConfig[2] = x;
	WindActionBagConfig[3] = y;
	WindActionBag_setPoint();
end

function WindActionConfigBag_setConfigX(x)
	WindActionBagConfig[2] = x;
	WindActionBag_setPoint();
end

function WindActionConfigBag_setConfigY(y)
	WindActionBagConfig[3] = y;
	WindActionBag_setPoint();
end

function WindActionConfigBag_setConfigScale(scale)
	WindActionBagConfig[4] = scale;
	WindActionBag_setScale();
end

function WindActionConfigBag_getPoint()
	return WindActionBagConfig[1];
end

function WindActionConfigBag_setBorder(haveBorder)
	WindActionBagConfig[6] = haveBorder;
	WindActionBag_setBorder();
end

function WindActionConfigBag_setType(nmb)
	WindActionBagConfig[5] = nmb;
	WindActionConfigBag_setLine();
	WindActionBag_setSize();
end

function WindActionConfigBag_setColor(color)
	if (color) then WindActionBag_setColor(); end
end

function WindActionConfigBag_resetColor()
	WindActionBag_resetColor();

	local colorArray = WindActionBagConfig[7];
	WindActionConfigBagCOLOR1NormalTexture:SetVertexColor(colorArray[1].r, colorArray[1].g, colorArray[1].b, colorArray[1].a);
	WindActionConfigBagCOLOR2NormalTexture:SetVertexColor(colorArray[2].r, colorArray[2].g, colorArray[2].b, colorArray[2].a);
end

function WindActionConfigBag_setView(isView)
	WindActionBagConfig[8] = isView;
	WindActionBag_setView();
end

function WindActionConfigPet_show()
	WindConfig_setUnCheckAll("WindActionConfigPet");
	WindConfig_setCheck("WindActionConfigPet", WindActionPetConfig[1]);
	WindActionConfigPetX:SetText(WindActionPetConfig[2]);
	WindActionConfigPetY:SetText(WindActionPetConfig[3]);
	WindActionConfigPetSCALE:SetText(string.format("%0.3f", WindActionPetConfig[4]));
	if (WindActionPetConfig[6]) then WindActionConfigPetVIEWBR:SetChecked(true);
	else WindActionConfigPetVIEWBR:SetChecked(false); end
	WindActionConfigPet_setLine();
	if (WindActionPetConfig[7]) then WindActionConfigPetCOLOR1NormalTexture:SetVertexColor(WindActionPetConfig[7][1].r, WindActionPetConfig[7][1].g, WindActionPetConfig[7][1].b, WindActionPetConfig[7][1].a);
	WindActionConfigPetCOLOR2NormalTexture:SetVertexColor(WindActionPetConfig[7][2].r, WindActionPetConfig[7][2].g, WindActionPetConfig[7][2].b, WindActionPetConfig[7][2].a); end
end

function WindActionConfigPet_setLine()
	WindActionConfig_clearType("WindActionConfigPet");
	getglobal("WindActionConfigPetLine"..WindActionPetConfig[5]):SetChecked(true);
end

function WindActionConfigPet_setConfigPoint(point, x, y)
	WindActionPetConfig[1] = point;
	WindActionPetConfig[2] = x;
	WindActionPetConfig[3] = y;
	WindActionPet_setPointAndSize();
end

function WindActionConfigPet_setConfigX(x)
	WindActionPetConfig[2] = x;
	WindActionPet_setPointAndSize();
end

function WindActionConfigPet_setConfigY(y)
	WindActionPetConfig[3] = y;
	WindActionPet_setPointAndSize();
end

function WindActionConfigPet_setConfigScale(scale)
	WindActionPetConfig[4] = scale;
	WindActionPet_setScale();
end

function WindActionConfigPet_getPoint()
	return WindActionPetConfig[1];
end

function WindActionConfigPet_setBorder(haveBorder)
	WindActionPetConfig[6] = haveBorder;
	WindActionPet_setBorder();
end

function WindActionConfigPet_setType(nmb)
	WindActionPetConfig[5] = nmb;
	WindActionConfigPet_setLine();
	WindActionPet_setPointAndSize();
end

function WindActionConfigPet_setColor(color)
	if (color) then WindActionPet_setColor(); end
end

function WindActionConfigPet_resetColor()
	WindActionPet_resetColor();

	local colorArray = WindActionPetConfig[7];
	WindActionConfigPetCOLOR1NormalTexture:SetVertexColor(colorArray[1].r, colorArray[1].g, colorArray[1].b, colorArray[1].a);
	WindActionConfigPetCOLOR2NormalTexture:SetVertexColor(colorArray[2].r, colorArray[2].g, colorArray[2].b, colorArray[2].a);
end

function WindActionConfigShift_show()
	WindConfig_setUnCheckAll("WindActionConfigShift");
	WindConfig_setCheck("WindActionConfigShift", WindActionShiftConfig[1]);
	WindActionConfigShiftX:SetText(WindActionShiftConfig[2]);
	WindActionConfigShiftY:SetText(WindActionShiftConfig[3]);
	WindActionConfigShiftSCALE:SetText(string.format("%0.3f", WindActionShiftConfig[4]));
	if (WindActionShiftConfig[6]) then WindActionConfigShiftVIEWBR:SetChecked(true);
	else WindActionConfigShiftVIEWBR:SetChecked(false); end
	if (WindActionShiftConfig[7]) then WindActionConfigShiftCOLOR1NormalTexture:SetVertexColor(WindActionShiftConfig[7][1].r, WindActionShiftConfig[7][1].g, WindActionShiftConfig[7][1].b, WindActionShiftConfig[7][1].a);
	WindActionConfigShiftCOLOR2NormalTexture:SetVertexColor(WindActionShiftConfig[7][2].r, WindActionShiftConfig[7][2].g, WindActionShiftConfig[7][2].b, WindActionShiftConfig[7][2].a); end
	if (WindActionShiftConfig[8]) then WindActionConfigShiftVIEW:SetChecked(true);
	else WindActionConfigShiftVIEW:SetChecked(false); end
	WindActionConfigShift_setLine();
end

function WindActionConfigShift_setLine()
	WindActionConfig_clearType("WindActionConfigShift");
	getglobal("WindActionConfigShiftLine"..WindActionShiftConfig[5]):SetChecked(true);
end

function WindActionConfigShift_setConfigPoint(point, x, y)
	WindActionShiftConfig[1] = point;
	WindActionShiftConfig[2] = x;
	WindActionShiftConfig[3] = y;
	WindActionShift_setPointAndSize();
end

function WindActionConfigShift_setConfigX(x)
	WindActionShiftConfig[2] = x;
	WindActionShift_setPointAndSize();
end

function WindActionConfigShift_setConfigY(y)
	WindActionShiftConfig[3] = y;
	WindActionShift_setPointAndSize();
end

function WindActionConfigShift_setConfigScale(scale)
	WindActionShiftConfig[4] = scale;
	WindActionShift_setScale();
end

function WindActionConfigShift_getPoint()
	return WindActionShiftConfig[1];
end

function WindActionConfigShift_setBorder(haveBorder)
	WindActionShiftConfig[6] = haveBorder;
	WindActionShift_setBorder();
end

function WindActionConfigShift_setType(nmb)
	WindActionShiftConfig[5] = nmb;
	WindActionConfigShift_setLine();
	WindActionShift_setSize();
end

function WindActionConfigShift_setColor(color)
	if (color) then WindActionShift_setColor(); end
end

function WindActionConfigShift_resetColor()
	WindActionShift_resetColor();

	local colorArray = WindActionShiftConfig[7];
	WindActionConfigShiftCOLOR1NormalTexture:SetVertexColor(colorArray[1].r, colorArray[1].g, colorArray[1].b, colorArray[1].a);
	WindActionConfigShiftCOLOR2NormalTexture:SetVertexColor(colorArray[2].r, colorArray[2].g, colorArray[2].b, colorArray[2].a);
end

function WindActionConfigShift_setView(isView)
	WindActionShiftConfig[8] = isView;
	WindActionShift_setView();
end

function WindActionConfigScroll_show()
	WindConfig_setUnCheckAll("WindActionConfigScroll");
	WindConfig_setCheck("WindActionConfigScroll", WindActionScrollConfig[1]);
	WindActionConfigScrollX:SetText(WindActionScrollConfig[2]);
	WindActionConfigScrollY:SetText(WindActionScrollConfig[3]);
	WindActionConfigScrollSCALE:SetText(string.format("%0.3f", WindActionScrollConfig[4]));
	if (WindActionScrollConfig[6]) then WindActionConfigScrollVIEWBR:SetChecked(true);
	else WindActionConfigScrollVIEWBR:SetChecked(false); end
	if (WindActionScrollConfig[7]) then WindActionConfigScrollCOLOR1NormalTexture:SetVertexColor(WindActionScrollConfig[7][1].r, WindActionScrollConfig[7][1].g, WindActionScrollConfig[7][1].b, WindActionScrollConfig[7][1].a);
	WindActionConfigScrollCOLOR2NormalTexture:SetVertexColor(WindActionScrollConfig[7][2].r, WindActionScrollConfig[7][2].g, WindActionScrollConfig[7][2].b, WindActionScrollConfig[7][2].a); end
	if (WindActionScrollConfig[8]) then WindActionConfigScrollVIEW:SetChecked(true);
	else WindActionConfigScrollVIEW:SetChecked(false); end
	WindActionConfigScroll_setLine();
end

function WindActionConfigScroll_setLine()
	WindActionConfig_clearType("WindActionConfigScroll");
	getglobal("WindActionConfigScrollLine"..WindActionScrollConfig[5]):SetChecked(true);
end

function WindActionConfigScroll_setConfigPoint(point, x, y)
	WindActionScrollConfig[1] = point;
	WindActionScrollConfig[2] = x;
	WindActionScrollConfig[3] = y;
	WindActionScroll_setPoint();
end

function WindActionConfigScroll_setConfigX(x)
	WindActionScrollConfig[2] = x;
	WindActionScroll_setPoint();
end

function WindActionConfigScroll_setConfigY(y)
	WindActionScrollConfig[3] = y;
	WindActionScroll_setPoint();
end

function WindActionConfigScroll_setConfigScale(scale)
	WindActionScrollConfig[4] = scale;
	WindActionScroll_setScale();
end

function WindActionConfigScroll_getPoint()
	return WindActionScrollConfig[1];
end

function WindActionConfigScroll_setBorder(haveBorder)
	WindActionScrollConfig[6] = haveBorder;
	WindActionScroll_setBorder();
end

function WindActionConfigScroll_setType(nmb)
	WindActionScrollConfig[5] = nmb;
	WindActionConfigScroll_setLine();
	WindActionScroll_setSize();
end

function WindActionConfigScroll_setColor(color)
	if (color) then WindActionScroll_setColor(); end
end

function WindActionConfigScroll_resetColor()
	WindActionScroll_resetColor();

	local colorArray = WindActionScrollConfig[7];
	WindActionConfigScrollCOLOR1NormalTexture:SetVertexColor(colorArray[1].r, colorArray[1].g, colorArray[1].b, colorArray[1].a);
	WindActionConfigScrollCOLOR2NormalTexture:SetVertexColor(colorArray[2].r, colorArray[2].g, colorArray[2].b, colorArray[2].a);
end

function WindActionConfigScroll_setView(isView)
	WindActionScrollConfig[8] = isView;
	WindActionScroll_setView();
end

function WindActionConfigVehicleLeave_show()
	WindConfig_setUnCheckAll("WindActionConfigVehicleLeave");
	WindConfig_setCheck("WindActionConfigVehicleLeave", WindActionVehicleLeaveConfig[1]);
	WindActionConfigVehicleLeaveSCALE:SetText(string.format("%0.3f", WindActionVehicleLeaveConfig[4]));
	WindActionConfigVehicleLeaveX:SetText(WindActionVehicleLeaveConfig[2]);
	WindActionConfigVehicleLeaveY:SetText(WindActionVehicleLeaveConfig[3]);
end

function WindActionConfigVehicleLeave_setConfigPoint(point, x, y)
	WindActionVehicleLeaveConfig[1] = point;
	WindActionVehicleLeaveConfig[2] = x;
	WindActionVehicleLeaveConfig[3] = y;
	WindActionVehicleLeave_setPoint();
end

function WindActionConfigVehicleLeave_setConfigX(x)
	WindActionVehicleLeaveConfig[2] = x;
	WindActionVehicleLeave_setPoint();
end

function WindActionConfigVehicleLeave_setConfigY(y)
	WindActionVehicleLeaveConfig[3] = y;
	WindActionVehicleLeave_setPoint();
end

function WindActionConfigVehicleLeave_setConfigScale(scale)
	WindActionVehicleLeaveConfig[4] = scale;
	WindActionVehicleLeave_setScale();
end

function WindActionConfigVehicleLeave_getPoint()
	return WindActionVehicleLeaveConfig[1];
end

function WindActionConfigVehicleLeave_setView(isView)
	WindActionVehicleLeaveConfig[8] = isView;
	WindActionVehicleLeave_setView();
end

function WindActionConfigCastingBar_show()
	WindConfig_setUnCheckAll("WindActionConfigCastingBar");
	WindConfig_setCheck("WindActionConfigCastingBar", WindActionCastingBarConfig[1]);
	WindActionConfigCastingBarSCALE:SetText(string.format("%0.3f", WindActionCastingBarConfig[4]));
	WindActionConfigCastingBarX:SetText(WindActionCastingBarConfig[2]);
	WindActionConfigCastingBarY:SetText(WindActionCastingBarConfig[3]);
end

function WindActionConfigCastingBar_setConfigPoint(point, x, y)
	WindActionCastingBarConfig[1] = point;
	WindActionCastingBarConfig[2] = x;
	WindActionCastingBarConfig[3] = y;
	WindActionCastingBar_setPoint();
end

function WindActionConfigCastingBar_setConfigX(x)
	WindActionCastingBarConfig[2] = x;
	WindActionCastingBar_setPoint();
end

function WindActionConfigCastingBar_setConfigY(y)
	WindActionCastingBarConfig[3] = y;
	WindActionCastingBar_setPoint();
end

function WindActionConfigCastingBar_setConfigScale(scale)
	WindActionCastingBarConfig[4] = scale;
	WindActionCastingBar_setScale();
end

function WindActionConfigCastingBar_getPoint()
	return WindActionCastingBarConfig[1];
end

function WindActionConfigCastingBar_setView(isView)
	WindActionCastingBarConfig[8] = isView;
	WindActionCastingBar_setView();
end
