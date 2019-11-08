function WindInfoConfig_OnShow()
	WindInfoConfigBody_show();
	WindInfoConfigXP_show();
	WindInfoConfigRP_show();
	WindInfoConfigMoney_show();
	WindInfoConfigTime_show();
	WindInfoConfigPerf_show();
	WindInfoConfigBag_show();
	if (WindInfoDate) then WindInfoConfigDate_show(); end
	if (WindInfoDura) then WindInfoConfigDura_show(); end
	if (WindInfoTick) then WindInfoConfigTick_show(); end
	if (WindInfoToken) then WindInfoConfigToken_show(); end
end

function WindInfoConfigMOUSE_OnClick(btn)
	local parent = btn:GetParent():GetName();
	if (btn:GetChecked()) then
		btn:SetChecked(true);
		_G[parent.."_setMouse"](true);
	else
		btn:SetChecked(false);
		_G[parent.."_setMouse"](false);
	end
end

function WindInfoConfigTEXT_OnClick(btn)
	local parent = btn:GetParent():GetName();
	if (btn:GetChecked()) then
		btn:SetChecked(true);
		_G[parent.."_setText"](true);
	else
		btn:SetChecked(false);
		_G[parent.."_setText"](false);
	end
end

function WindInfoConfigTOOLTIP_OnClick(btn)
	local parent = btn:GetParent():GetName();
	if (btn:GetChecked()) then
		btn:SetChecked(true);
		_G[parent.."_setTooltip"](true);
	else
		btn:SetChecked(false);
		_G[parent.."_setTooltip"](false);
	end
end

function WindInfoConfigBody_show()
	WindConfig_setUnCheckAll("WindInfoConfigBody");
	WindConfig_setCheck("WindInfoConfigBody", WindInfoBodyConfig[1]);
	WindInfoConfigBodyX:SetText(WindInfoBodyConfig[2]);
	WindInfoConfigBodyY:SetText(WindInfoBodyConfig[3]);
	WindInfoConfigBodySCALE:SetText(string.format("%0.3f", WindInfoBodyConfig[4]));
	WindInfoConfigBodyWIDTH:SetText(WindInfoBodyConfig[5]);
	WindInfoConfigBodyHEIGHT:SetText(WindInfoBodyConfig[6]);
	if (WindInfoBodyConfig[7]) then WindInfoConfigBodyMOUSEOVER:SetChecked(true);
	else WindInfoConfigBodyMOUSEOVER:SetChecked(false); end
	if (WindInfoBodyConfig[8]) then WindInfoConfigBodyCOLOR1NormalTexture:SetVertexColor(WindInfoBodyConfig[8][1].r, WindInfoBodyConfig[8][1].g, WindInfoBodyConfig[8][1].b, WindInfoBodyConfig[8][1].a);
	WindInfoConfigBodyCOLOR2NormalTexture:SetVertexColor(WindInfoBodyConfig[8][2].r, WindInfoBodyConfig[8][2].g, WindInfoBodyConfig[8][2].b, WindInfoBodyConfig[8][2].a); end
	if (WindInfoBodyConfig[9]) then WindInfoConfigBodyVIEWBR:SetChecked(true);
	else WindInfoConfigBodyVIEWBR:SetChecked(false); end
	if (WindInfoBodyConfig[10]) then WindInfoConfigBodySTBAR:SetChecked(true);
	else WindInfoConfigBodySTBAR:SetChecked(false); end
end

function WindInfoConfigXP_show()
	WindConfig_setUnCheckAll("WindInfoConfigXP");
	WindConfig_setCheck("WindInfoConfigXP", WindInfoXPConfig[1]);
	WindInfoConfigXPX:SetText(WindInfoXPConfig[2]);
	WindInfoConfigXPY:SetText(WindInfoXPConfig[3]);
	WindInfoConfigXPSCALE:SetText(string.format("%0.3f", WindInfoXPConfig[4]));
	WindInfoConfigXPWIDTH:SetText(WindInfoXPConfig[5]);
	WindInfoConfigXPHEIGHT:SetText(WindInfoXPConfig[6]);
	if (WindInfoXPConfig[7]) then WindInfoConfigXPVIEW:SetChecked(true);
	else WindInfoConfigXPVIEW:SetChecked(false); end
	if (WindInfoXPConfig[8]) then WindInfoConfigXPMOUSE:SetChecked(true);
	else WindInfoConfigXPMOUSE:SetChecked(false); end
	if (WindInfoXPConfig[9]) then WindInfoConfigXPTEXT:SetChecked(true);
	else WindInfoConfigXPTEXT:SetChecked(false); end
	if (WindInfoXPConfig[10]) then WindInfoConfigXPTOOLTIP:SetChecked(true);
	else WindInfoConfigXPTOOLTIP:SetChecked(false); end
end

function WindInfoConfigRP_show()
	WindConfig_setUnCheckAll("WindInfoConfigRP");
	WindConfig_setCheck("WindInfoConfigRP", WindInfoRPConfig[1]);
	WindInfoConfigRPX:SetText(WindInfoRPConfig[2]);
	WindInfoConfigRPY:SetText(WindInfoRPConfig[3]);
	WindInfoConfigRPSCALE:SetText(string.format("%0.3f", WindInfoRPConfig[4]));
	WindInfoConfigRPWIDTH:SetText(WindInfoRPConfig[5]);
	WindInfoConfigRPHEIGHT:SetText(WindInfoRPConfig[6]);
	if (WindInfoRPConfig[7]) then WindInfoConfigRPVIEW:SetChecked(true);
	else WindInfoConfigRPVIEW:SetChecked(false); end
	if (WindInfoRPConfig[8]) then WindInfoConfigRPMOUSE:SetChecked(true);
	else WindInfoConfigRPMOUSE:SetChecked(false); end
	if (WindInfoRPConfig[9]) then WindInfoConfigRPTEXT:SetChecked(true);
	else WindInfoConfigRPTEXT:SetChecked(false); end
	if (WindInfoRPConfig[10]) then WindInfoConfigRPTOOLTIP:SetChecked(true);
	else WindInfoConfigRPTOOLTIP:SetChecked(false); end
end

function WindInfoConfigMoney_show()
	WindConfig_setUnCheckAll("WindInfoConfigMoney");
	WindConfig_setCheck("WindInfoConfigMoney", WindInfoMoneyConfig[1]);
	WindInfoConfigMoneyX:SetText(WindInfoMoneyConfig[2]);
	WindInfoConfigMoneyY:SetText(WindInfoMoneyConfig[3]);
	WindInfoConfigMoneySCALE:SetText(string.format("%0.3f", WindInfoMoneyConfig[4]));
	WindInfoConfigMoneyWIDTH:SetText(WindInfoMoneyConfig[5]);
	WindInfoConfigMoneyHEIGHT:SetText(WindInfoMoneyConfig[6]);
	if (WindInfoMoneyConfig[7]) then WindInfoConfigMoneyVIEW:SetChecked(true);
	else WindInfoConfigMoneyVIEW:SetChecked(false); end
	if (WindInfoMoneyConfig[8]) then WindInfoConfigMoneyMOUSE:SetChecked(true);
	else WindInfoConfigMoneyMOUSE:SetChecked(false); end
end

function WindInfoConfigToken_show()
	WindConfig_setUnCheckAll("WindInfoConfigToken");
	WindConfig_setCheck("WindInfoConfigToken", WindInfoTokenConfig[1]);
	WindInfoConfigTokenX:SetText(WindInfoTokenConfig[2]);
	WindInfoConfigTokenY:SetText(WindInfoTokenConfig[3]);
	WindInfoConfigTokenSCALE:SetText(string.format("%0.3f", WindInfoTokenConfig[4]));
	WindInfoConfigTokenWIDTH:SetText(WindInfoTokenConfig[5]);
	WindInfoConfigTokenHEIGHT:SetText(WindInfoTokenConfig[6]);
	if (WindInfoTokenConfig[7]) then WindInfoConfigTokenVIEW:SetChecked(true);
	else WindInfoConfigTokenVIEW:SetChecked(false); end
	if (WindInfoTokenConfig[8]) then WindInfoConfigTokenMOUSE:SetChecked(true);
	else WindInfoConfigTokenMOUSE:SetChecked(false); end
end

function WindInfoConfigTime_show()
	WindConfig_setUnCheckAll("WindInfoConfigTime");
	WindConfig_setCheck("WindInfoConfigTime", WindInfoTimeConfig[1]);
	WindInfoConfigTimeX:SetText(WindInfoTimeConfig[2]);
	WindInfoConfigTimeY:SetText(WindInfoTimeConfig[3]);
	WindInfoConfigTimeSCALE:SetText(string.format("%0.3f", WindInfoTimeConfig[4]));
	WindInfoConfigTimeWIDTH:SetText(WindInfoTimeConfig[5]);
	WindInfoConfigTimeHEIGHT:SetText(WindInfoTimeConfig[6]);
	if (WindInfoTimeConfig[7]) then WindInfoConfigTimeVIEW:SetChecked(true);
	else WindInfoConfigTimeVIEW:SetChecked(false); end
	if (WindInfoTimeConfig[8]) then WindInfoConfigTimeMOUSE:SetChecked(true);
	else WindInfoConfigTimeMOUSE:SetChecked(false); end
end

function WindInfoConfigPerf_show()
	WindConfig_setUnCheckAll("WindInfoConfigPerf");
	WindConfig_setCheck("WindInfoConfigPerf", WindInfoPerfConfig[1]);
	WindInfoConfigPerfX:SetText(WindInfoPerfConfig[2]);
	WindInfoConfigPerfY:SetText(WindInfoPerfConfig[3]);
	WindInfoConfigPerfSCALE:SetText(string.format("%0.3f", WindInfoPerfConfig[4]));
	WindInfoConfigPerfWIDTH:SetText(WindInfoPerfConfig[5]);
	WindInfoConfigPerfHEIGHT:SetText(WindInfoPerfConfig[6]);
	if (WindInfoPerfConfig[7]) then WindInfoConfigPerfVIEW:SetChecked(true);
	else WindInfoConfigPerfVIEW:SetChecked(false); end
	if (WindInfoPerfConfig[8]) then WindInfoConfigPerfMOUSE:SetChecked(true);
	else WindInfoConfigPerfMOUSE:SetChecked(false); end
end

function WindInfoConfigBag_show()
	WindConfig_setUnCheckAll("WindInfoConfigBag");
	WindConfig_setCheck("WindInfoConfigBag", WindInfoBagConfig[1]);
	WindInfoConfigBagX:SetText(WindInfoBagConfig[2]);
	WindInfoConfigBagY:SetText(WindInfoBagConfig[3]);
	WindInfoConfigBagSCALE:SetText(string.format("%0.3f", WindInfoBagConfig[4]));
	WindInfoConfigBagWIDTH:SetText(WindInfoBagConfig[5]);
	WindInfoConfigBagHEIGHT:SetText(WindInfoBagConfig[6]);
	if (WindInfoBagConfig[7]) then WindInfoConfigBagVIEW:SetChecked(true);
	else WindInfoConfigBagVIEW:SetChecked(false); end
	if (WindInfoBagConfig[8]) then WindInfoConfigBagMOUSE:SetChecked(true);
	else WindInfoConfigBagMOUSE:SetChecked(false); end
end

function WindInfoConfigDate_show()
	WindConfig_setUnCheckAll("WindInfoConfigDate");
	WindConfig_setCheck("WindInfoConfigDate", WindInfoDateConfig[1]);
	WindInfoConfigDateX:SetText(WindInfoDateConfig[2]);
	WindInfoConfigDateY:SetText(WindInfoDateConfig[3]);
	WindInfoConfigDateSCALE:SetText(string.format("%0.3f", WindInfoDateConfig[4]));
	WindInfoConfigDateWIDTH:SetText(WindInfoDateConfig[5]);
	WindInfoConfigDateHEIGHT:SetText(WindInfoDateConfig[6]);
	if (WindInfoDateConfig[7]) then WindInfoConfigDateVIEW:SetChecked(true);
	else WindInfoConfigDateVIEW:SetChecked(false); end
	if (WindInfoDateConfig[8]) then WindInfoConfigDateMOUSE:SetChecked(true);
	else WindInfoConfigDateMOUSE:SetChecked(false); end
end

function WindInfoConfigDura_show()
	WindConfig_setUnCheckAll("WindInfoConfigDura");
	WindConfig_setCheck("WindInfoConfigDura", WindInfoDuraConfig[1]);
	WindInfoConfigDuraX:SetText(WindInfoDuraConfig[2]);
	WindInfoConfigDuraY:SetText(WindInfoDuraConfig[3]);
	WindInfoConfigDuraSCALE:SetText(string.format("%0.3f", WindInfoDuraConfig[4]));
	WindInfoConfigDuraWIDTH:SetText(WindInfoDuraConfig[5]);
	WindInfoConfigDuraHEIGHT:SetText(WindInfoDuraConfig[6]);
	if (WindInfoDuraConfig[7]) then WindInfoConfigDuraVIEW:SetChecked(true);
	else WindInfoConfigDuraVIEW:SetChecked(false); end
	if (WindInfoDuraConfig[8]) then WindInfoConfigDuraMOUSE:SetChecked(true);
	else WindInfoConfigDuraMOUSE:SetChecked(false); end
end

function WindInfoConfigTick_show()
	WindConfig_setUnCheckAll("WindInfoConfigTick");
	WindConfig_setCheck("WindInfoConfigTick", WindInfoTickConfig[1]);
	WindInfoConfigTickX:SetText(WindInfoTickConfig[2]);
	WindInfoConfigTickY:SetText(WindInfoTickConfig[3]);
	WindInfoConfigTickSCALE:SetText(string.format("%0.3f", WindInfoTickConfig[4]));
	WindInfoConfigTickWIDTH:SetText(WindInfoTickConfig[5]);
	WindInfoConfigTickHEIGHT:SetText(WindInfoTickConfig[6]);
	if (WindInfoTickConfig[7]) then WindInfoConfigTickVIEW:SetChecked(true);
	else WindInfoConfigTickVIEW:SetChecked(false); end
	if (WindInfoTickConfig[8]) then WindInfoConfigTickMOUSE:SetChecked(true);
	else WindInfoConfigTickMOUSE:SetChecked(false); end
end

function WindInfoConfigBody_setConfigPoint(point, x, y)
	WindInfoBodyConfig[1] = point;
	WindInfoBodyConfig[2] = x;
	WindInfoBodyConfig[3] = y;
	WindInfoBody_setPoint();
end

function WindInfoConfigBody_setConfigX(x)
	WindInfoBodyConfig[2] = x;
	WindInfoBody_setPoint();
end

function WindInfoConfigBody_setConfigY(y)
	WindInfoBodyConfig[3] = y;
	WindInfoBody_setPoint();
end

function WindInfoConfigBody_setConfigScale(scale)
	WindInfoBodyConfig[4] = scale;
	WindInfoBody_setScale();
end

function WindInfoConfigBody_getPoint()
	return WindInfoBodyConfig[1];
end

function WindInfoConfigBody_setWidth(width)
	WindInfoBodyConfig[5] = width;
	WindInfoBody_setSize();
	WindInfoBar_setSize();
end

function WindInfoConfigBody_setHeight(height)
	WindInfoBodyConfig[6] = height;
	WindInfoBody_setSize();
	WindInfoBar_setSize();
end

function WindInfoConfigBodyMOUSEOVER_OnClick(isChecked)
	if (isChecked) then
		DEFAULT_CHAT_FRAME:AddMessage("Wind Info MouseOver / Tooltip Event is enabled.");
		WindInfoConfigBodyMOUSEOVER:SetChecked(true);
		WindInfoConfigBody_setMouseOver(true);
	else
		DEFAULT_CHAT_FRAME:AddMessage("Wind Info MouseOver / Tooltip Event is desabled.");
		WindInfoConfigBodyMOUSEOVER:SetChecked(false);
		WindInfoConfigBody_setMouseOver(false);
	end
end

function WindInfoConfigBody_setMouseOver(isEnabled)
	WindInfoBodyConfig[7] = isEnabled;
end

function WindInfoConfigBody_setColor(color)
	if (color) then WindInfoBody_setColor(); end
end

function WindInfoConfigBody_resetColor()
	WindInfoBody_resetColor();

	local colorArray = WindInfoBodyConfig[8];
	WindInfoConfigBodyCOLOR1NormalTexture:SetVertexColor(colorArray[1].r, colorArray[1].g, colorArray[1].b, colorArray[1].a);
	WindInfoConfigBodyCOLOR2NormalTexture:SetVertexColor(colorArray[2].r, colorArray[2].g, colorArray[2].b, colorArray[2].a);
end

function WindInfoConfigBodyVIEWBR_OnClick(isChecked)
	if (isChecked) then
		WindInfoConfigBodyVIEWBR:SetChecked(true);
		WindInfoConfigBody_setBorder(true);
	else
		WindInfoConfigBodyVIEWBR:SetChecked(false);
		WindInfoConfigBody_setBorder(false);
	end
end

function WindInfoConfigBody_setBorder(haveBorder)
	WindInfoBodyConfig[9] = haveBorder;
	WindInfoBody_setBorder();
end

function WindInfoConfigBodySTBAR_OnClick(isChecked)
	if (isChecked) then
		WindInfoConfigBodySTBAR:SetChecked(true);
		WindInfoConfigBody_setSTBar(true);
	else
		WindInfoConfigBodySTBAR:SetChecked(false);
		WindInfoConfigBody_setSTBar(false);
	end
end

function WindInfoConfigBody_setSTBar(isShownBar)
	WindInfoBodyConfig[10] = isShownBar;
	WindInfoBody_setSTBar();
end

function WindInfoConfigXP_setConfigPoint(point, x, y)
	WindInfoXPConfig[1] = point;
	WindInfoXPConfig[2] = x;
	WindInfoXPConfig[3] = y;
	WindInfoXP_setPoint();
end

function WindInfoConfigXP_setConfigX(x)
	WindInfoXPConfig[2] = x;
	WindInfoXP_setPoint();
end

function WindInfoConfigXP_setConfigY(y)
	WindInfoXPConfig[3] = y;
	WindInfoXP_setPoint();
end

function WindInfoConfigXP_setConfigScale(scale)
	WindInfoXPConfig[4] = scale;
	WindInfoXP_setScale();
end

function WindInfoConfigXP_getPoint()
	return WindInfoXPConfig[1];
end

function WindInfoConfigXP_setWidth(width)
	WindInfoXPConfig[5] = width;
	WindInfoXP_setSize();
end

function WindInfoConfigXP_setHeight(height)
	WindInfoXPConfig[6] = height;
	WindInfoXP_setSize();
end

function WindInfoConfigXP_setView(isView)
	WindInfoXPConfig[7] = isView;
	WindInfoXP_setView();
end

function WindInfoConfigXP_setMouse(isMouse)
	WindInfoXPConfig[8] = isMouse;
	WindInfoXP_setMouse();
end

function WindInfoConfigXP_setText(isText)
	WindInfoXPConfig[9] = isText;
	WindInfoXP_setText();
end

function WindInfoConfigXP_setTooltip(isTooltip)
	WindInfoXPConfig[10] = isTooltip;
end

function WindInfoConfigRP_setConfigPoint(point, x, y)
	WindInfoRPConfig[1] = point;
	WindInfoRPConfig[2] = x;
	WindInfoRPConfig[3] = y;
	WindInfoRP_setPoint();
end

function WindInfoConfigRP_setConfigX(x)
	WindInfoRPConfig[2] = x;
	WindInfoRP_setPoint();
end

function WindInfoConfigRP_setConfigY(y)
	WindInfoRPConfig[3] = y;
	WindInfoRP_setPoint();
end

function WindInfoConfigRP_setConfigScale(scale)
	WindInfoRPConfig[4] = scale;
	WindInfoRP_setScale();
end

function WindInfoConfigRP_getPoint()
	return WindInfoRPConfig[1];
end

function WindInfoConfigRP_setWidth(width)
	WindInfoRPConfig[5] = width;
	WindInfoRP_setSize();
end

function WindInfoConfigRP_setHeight(height)
	WindInfoRPConfig[6] = height;
	WindInfoRP_setSize();
end

function WindInfoConfigRP_setView(isView)
	WindInfoRPConfig[7] = isView;
	WindInfoRP_setView();
end

function WindInfoConfigRP_setMouse(isMouse)
	WindInfoRPConfig[8] = isMouse;
	WindInfoRP_setMouse();
end

function WindInfoConfigRP_setText(isText)
	WindInfoRPConfig[9] = isText;
	WindInfoRP_setText();
end

function WindInfoConfigRP_setTooltip(isTooltip)
	WindInfoRPConfig[10] = isTooltip;
end

function WindInfoConfigMoney_setConfigPoint(point, x, y)
	WindInfoMoneyConfig[1] = point;
	WindInfoMoneyConfig[2] = x;
	WindInfoMoneyConfig[3] = y;
	WindInfoMoney_setPoint();
end

function WindInfoConfigMoney_setConfigX(x)
	WindInfoMoneyConfig[2] = x;
	WindInfoMoney_setPoint();
end

function WindInfoConfigMoney_setConfigY(y)
	WindInfoMoneyConfig[3] = y;
	WindInfoMoney_setPoint();
end

function WindInfoConfigMoney_setConfigScale(scale)
	WindInfoMoneyConfig[4] = scale;
	WindInfoMoney_setScale();
end

function WindInfoConfigMoney_getPoint()
	return WindInfoMoneyConfig[1];
end

function WindInfoConfigMoney_setWidth(width)
	WindInfoMoneyConfig[5] = width;
	WindInfoMoney_setSize();
end

function WindInfoConfigMoney_setHeight(height)
	WindInfoMoneyConfig[6] = height;
	WindInfoMoney_setSize();
end

function WindInfoConfigMoney_setView(isView)
	WindInfoMoneyConfig[7] = isView;
	WindInfoMoney_setView();
end

function WindInfoConfigMoney_setMouse(isMouse)
	WindInfoMoneyConfig[8] = isMouse;
	WindInfoMoney_setMouse();
end

function WindInfoConfigToken_setConfigPoint(point, x, y)
	WindInfoTokenConfig[1] = point;
	WindInfoTokenConfig[2] = x;
	WindInfoTokenConfig[3] = y;
	WindInfoToken_setPoint();
end

function WindInfoConfigToken_setConfigX(x)
	WindInfoTokenConfig[2] = x;
	WindInfoToken_setPoint();
end

function WindInfoConfigToken_setConfigY(y)
	WindInfoTokenConfig[3] = y;
	WindInfoToken_setPoint();
end

function WindInfoConfigToken_setConfigScale(scale)
	WindInfoTokenConfig[4] = scale;
	WindInfoToken_setScale();
end

function WindInfoConfigToken_getPoint()
	return WindInfoTokenConfig[1];
end

function WindInfoConfigToken_setWidth(width)
	WindInfoTokenConfig[5] = width;
	WindInfoToken_setSize();
end

function WindInfoConfigToken_setHeight(height)
	WindInfoTokenConfig[6] = height;
	WindInfoToken_setSize();
end

function WindInfoConfigToken_setView(isView)
	WindInfoTokenConfig[7] = isView;
	WindInfoToken_setView();
end

function WindInfoConfigToken_setMouse(isMouse)
	WindInfoTokenConfig[8] = isMouse;
	WindInfoToken_setMouse();
end

function WindInfoConfigTime_setConfigPoint(point, x, y)
	WindInfoTimeConfig[1] = point;
	WindInfoTimeConfig[2] = x;
	WindInfoTimeConfig[3] = y;
	WindInfoTime_setPoint();
end

function WindInfoConfigTime_setConfigX(x)
	WindInfoTimeConfig[2] = x;
	WindInfoTime_setPoint();
end

function WindInfoConfigTime_setConfigY(y)
	WindInfoTimeConfig[3] = y;
	WindInfoTime_setPoint();
end

function WindInfoConfigTime_setConfigScale(scale)
	WindInfoTimeConfig[4] = scale;
	WindInfoTime_setScale();
end

function WindInfoConfigTime_getPoint()
	return WindInfoTimeConfig[1];
end

function WindInfoConfigTime_setWidth(width)
	WindInfoTimeConfig[5] = width;
	WindInfoTime_setSize();
end

function WindInfoConfigTime_setHeight(height)
	WindInfoTimeConfig[6] = height;
	WindInfoTime_setSize();
end

function WindInfoConfigTime_setView(isView)
	WindInfoTimeConfig[7] = isView;
	WindInfoTime_setView();
end

function WindInfoConfigTime_setMouse(isMouse)
	WindInfoTimeConfig[8] = isMouse;
	WindInfoTime_setMouse();
end

function WindInfoConfigPerf_setConfigPoint(point, x, y)
	WindInfoPerfConfig[1] = point;
	WindInfoPerfConfig[2] = x;
	WindInfoPerfConfig[3] = y;
	WindInfoPerf_setPoint();
end

function WindInfoConfigPerf_setConfigX(x)
	WindInfoPerfConfig[2] = x;
	WindInfoPerf_setPoint();
end

function WindInfoConfigPerf_setConfigY(y)
	WindInfoPerfConfig[3] = y;
	WindInfoPerf_setPoint();
end

function WindInfoConfigPerf_setConfigScale(scale)
	WindInfoPerfConfig[4] = scale;
	WindInfoPerf_setScale();
end

function WindInfoConfigPerf_getPoint()
	return WindInfoPerfConfig[1];
end

function WindInfoConfigPerf_setWidth(width)
	WindInfoPerfConfig[5] = width;
	WindInfoPerf_setSize();
end

function WindInfoConfigPerf_setHeight(height)
	WindInfoPerfConfig[6] = height;
	WindInfoPerf_setSize();
end

function WindInfoConfigPerf_setView(isView)
	WindInfoPerfConfig[7] = isView;
	WindInfoPerf_setView();
end

function WindInfoConfigPerf_setMouse(isMouse)
	WindInfoPerfConfig[8] = isMouse;
	WindInfoPerf_setMouse();
end

function WindInfoConfigBag_setConfigPoint(point, x, y)
	WindInfoBagConfig[1] = point;
	WindInfoBagConfig[2] = x;
	WindInfoBagConfig[3] = y;
	WindInfoBag_setPoint();
end

function WindInfoConfigBag_setConfigX(x)
	WindInfoBagConfig[2] = x;
	WindInfoBag_setPoint();
end

function WindInfoConfigBag_setConfigY(y)
	WindInfoBagConfig[3] = y;
	WindInfoBag_setPoint();
end

function WindInfoConfigBag_setConfigScale(scale)
	WindInfoBagConfig[4] = scale;
	WindInfoBag_setScale();
end

function WindInfoConfigBag_getPoint()
	return WindInfoBagConfig[1];
end

function WindInfoConfigBag_setWidth(width)
	WindInfoBagConfig[5] = width;
	WindInfoBag_setSize();
end

function WindInfoConfigBag_setHeight(height)
	WindInfoBagConfig[6] = height;
	WindInfoBag_setSize();
end

function WindInfoConfigBag_setView(isView)
	WindInfoBagConfig[7] = isView;
	WindInfoBag_setView();
end

function WindInfoConfigBag_setMouse(isMouse)
	WindInfoBagConfig[8] = isMouse;
	WindInfoBag_setMouse();
end

function WindInfoConfigDate_setConfigPoint(point, x, y)
	WindInfoDateConfig[1] = point;
	WindInfoDateConfig[2] = x;
	WindInfoDateConfig[3] = y;
	WindInfoDate_setPoint();
end

function WindInfoConfigDate_setConfigX(x)
	WindInfoDateConfig[2] = x;
	WindInfoDate_setPoint();
end

function WindInfoConfigDate_setConfigY(y)
	WindInfoDateConfig[3] = y;
	WindInfoDate_setPoint();
end

function WindInfoConfigDate_setConfigScale(scale)
	WindInfoDateConfig[4] = scale;
	WindInfoDate_setScale();
end

function WindInfoConfigDate_getPoint()
	return WindInfoDateConfig[1];
end

function WindInfoConfigDate_setWidth(width)
	WindInfoDateConfig[5] = width;
	WindInfoDate_setSize();
end

function WindInfoConfigDate_setHeight(height)
	WindInfoDateConfig[6] = height;
	WindInfoDate_setSize();
end

function WindInfoConfigDate_setView(isView)
	WindInfoDateConfig[7] = isView;
	WindInfoDate_setView();
end

function WindInfoConfigDate_setMouse(isMouse)
	WindInfoDateConfig[8] = isMouse;
	WindInfoDate_setMouse();
end

function WindInfoConfigDura_setConfigPoint(point, x, y)
	WindInfoDuraConfig[1] = point;
	WindInfoDuraConfig[2] = x;
	WindInfoDuraConfig[3] = y;
	WindInfoDura_setPoint();
end

function WindInfoConfigDura_setConfigX(x)
	WindInfoDuraConfig[2] = x;
	WindInfoDura_setPoint();
end

function WindInfoConfigDura_setConfigY(y)
	WindInfoDuraConfig[3] = y;
	WindInfoDura_setPoint();
end

function WindInfoConfigDura_setConfigScale(scale)
	WindInfoDuraConfig[4] = scale;
	WindInfoDura_setScale();
end

function WindInfoConfigDura_getPoint()
	return WindInfoDuraConfig[1];
end

function WindInfoConfigDura_setWidth(width)
	WindInfoDuraConfig[5] = width;
	WindInfoDura_setSize();
end

function WindInfoConfigDura_setHeight(height)
	WindInfoDuraConfig[6] = height;
	WindInfoDura_setSize();
end

function WindInfoConfigDura_setView(isView)
	WindInfoDuraConfig[7] = isView;
	WindInfoDura_setView();
end

function WindInfoConfigDura_setMouse(isMouse)
	WindInfoDuraConfig[8] = isMouse;
	WindInfoDura_setMouse();
end

function WindInfoConfigTick_setConfigPoint(point, x, y)
	WindInfoTickConfig[1] = point;
	WindInfoTickConfig[2] = x;
	WindInfoTickConfig[3] = y;
	WindInfoTick_setPoint();
end

function WindInfoConfigTick_setConfigX(x)
	WindInfoTickConfig[2] = x;
	WindInfoTick_setPoint();
end

function WindInfoConfigTick_setConfigY(y)
	WindInfoTickConfig[3] = y;
	WindInfoTick_setPoint();
end

function WindInfoConfigTick_setConfigScale(scale)
	WindInfoTickConfig[4] = scale;
	WindInfoTick_setScale();
end

function WindInfoConfigTick_getPoint()
	return WindInfoTickConfig[1];
end

function WindInfoConfigTick_setWidth(width)
	WindInfoTickConfig[5] = width;
	WindInfoTick_setSize();
end

function WindInfoConfigTick_setHeight(height)
	WindInfoTickConfig[6] = height;
	WindInfoTick_setSize();
end

function WindInfoConfigTick_setView(isView)
	WindInfoTickConfig[7] = isView;
	WindInfoTick_setView();
end

function WindInfoConfigTick_setMouse(isMouse)
	WindInfoTickConfig[8] = isMouse;
	WindInfoTick_setMouse();
end