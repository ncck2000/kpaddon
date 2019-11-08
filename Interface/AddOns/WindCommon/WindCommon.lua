WindCommon_Border = {
	bgFile = "Interface/DialogFrame/UI-DialogBox-Background",
	edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
	tile = true,
	tileSize = 16,
	edgeSize = 16,
	insets = { left = 5, right = 5, top = 5, bottom = 5 } }

WindCommon_ColorBorder = {
	bgFile = "Interface/Tooltips/UI-Tooltip-Background",
	edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
	tile = true,
	tileSize = 20,
	edgeSize = 20,
	insets = { left = 5, right = 5, top = 5, bottom = 5 } }

function WindCommon_setParentPoint(child, parent, point, frame, relativePoint, xOfs, yOfs)
	child:SetParent(parent);
	WindCommon_setPoint(child, point, frame, relativePoint, xOfs, yOfs);
end

function WindCommon_setPoint(frame, point, relative, relativePoint, xOfs, yOfs)
	frame:ClearAllPoints();
	frame:SetPoint(point, relative, relativePoint, xOfs, yOfs);
end

function WindCommon_setSize(frame, width, height)
	frame:SetWidth(width);
	frame:SetHeight(height);
end

function WindCommon_setBackground(bg, frame, inset)
	WindCommon_setBackgroundPoint(bg, frame, inset)
	WindCommon_setBackgroundLevel(bg, frame);
end

function WindCommon_setBackgroundPoint(bg, context, inset)
	local minset = inset * (-1);
	bg:ClearAllPoints();
	bg:SetPoint("BOTTOMLEFT", context, "BOTTOMLEFT", minset, minset);
	bg:SetPoint("TOPLEFT", context, "TOPLEFT", minset, inset);
	bg:SetPoint("TOPRIGHT", context, "TOPRIGHT", inset, inset);
	bg:SetPoint("BOTTOMRIGHT", context, "BOTTOMRIGHT", inset, minset);
end

function WindCommon_setBackgroundLevel(bg, context)
	local level = context:GetFrameLevel();
	bg:SetFrameLevel(level);
	context:SetFrameLevel(level+1);
end

function WindCommon_setHide(object)
	object:SetAlpha(0.0);
	WindCommon_setSize(object, 1, 1);
end


local WindTimer_Tick = 0;
local WindTimer_Tick2 = 0;

WindTimer = {
	["WindInfoMoney"] = nil,
};

function WindTimer_OnUpdate(self, elapsed)
	if (WindTimer_Tick > 1) then
		WindTimer_Tick = 0;
		WindTimer_Fire2Tick();
	else WindTimer_Tick = WindTimer_Tick+1; end
end

function WindTimer_Fire2Tick()
	WindTimer_Fire(2);
	if (WindTimer_Tick2 > 1) then
		WindTimer_Tick2 = 0;
		WindTimer_Fire4Tick();
	else WindTimer_Tick2 = WindTimer_Tick2+1; end
end

function WindTimer_Fire4Tick()
	WindTimer_Fire(4);
end

function WindTimer_Fire(tick)
	if (WindTimer["WindInfoMoney"] == tick) then WindInfoMoney_loop(); end
end

function WindCommon_Print(msg)
	if(ChatFrame1) then
		ChatFrame1:AddMessage(msg, 1.0, 1.0, 0.0);
	end
end