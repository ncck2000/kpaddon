WIDValues_Armor = { value=0, max=0, cost=0 };
WIDValues_Inven = { value=0, max=0, cost=0 };
WID_CurrPercent = 100;

local WindInfoDura_Slots = {
	{ name = INVTYPE_HEAD, slot = "Head" },
	{ name = INVTYPE_SHOULDER, slot = "Shoulder" },
	{ name = INVTYPE_CHEST, slot = "Chest" },
	{ name = INVTYPE_WAIST, slot = "Waist" },
	{ name = INVTYPE_LEGS, slot = "Legs" },
	{ name = INVTYPE_FEET, slot = "Feet" },
	{ name = INVTYPE_WRIST, slot = "Wrist" },
	{ name = INVTYPE_HAND, slot = "Hands" },
	{ name = INVTYPE_WEAPONMAINHAND, slot = "MainHand" },
	{ name = INVTYPE_WEAPONOFFHAND, slot = "SecondaryHand" },
	{ name = INVENTORY_TOOLTIP },
}
	
function WindInfoDura_OnLoad(self)
	self:RegisterEvent("VARIABLES_LOADED");
	self:RegisterEvent("PLAYER_DEAD");
	self:RegisterEvent("PLAYER_UNGHOST");
	self:RegisterEvent("MERCHANT_UPDATE");
	self:RegisterEvent("MERCHANT_CLOSED");
	self:RegisterEvent("UPDATE_INVENTORY_ALERTS");
	self:RegisterEvent("PLAYER_LEAVING_WORLD");
	self:RegisterEvent("PLAYER_ENTERING_WORLD");
end

function WindInfoDura_OnEvent(self, event, ...)
	if (event == "VARIABLES_LOADED") then 
		WindInfoDura_BagUpdate();
		WindInfoDura_initConfig();
		WindInfoDura_setPoint();
		WindInfoDura_setScale();
		WindInfoDura_setSize();
		WindInfoDura_setView();
		WindInfoDura_setMouse();
	end
	if (event == "PLAYER_ENTERING_WORLD" or event == "UPDATE_INVENTORY_ALERTS" or event == "MERCHANT_UPDATE" or 
		event == "MERCHANT_CLOSED" or event == "PLAYER_UNGHOST" or event == "PLAYER_DEAD") then
		if(CanMerchantRepair() and WID_CurrPercent < 100) then WindInfoDura.bagupdate = 0;
		else WindInfoDura.bagupdate = 5; end
	end
	if (event == "PLAYER_ENTERING_WORLD") then self:RegisterEvent("UPDATE_INVENTORY_ALERTS"); return; end
	if (event == "PLAYER_LEAVING_WORLD") then self:UnregisterEvent("UPDATE_INVENTORY_ALERTS"); return; end
end

function WindInfoDura_OnUpdate(self, elapsed)
	if(WindInfoDura.bagupdate) then WindInfoDura.bagupdate = WindInfoDura.bagupdate - elapsed;
		if ( WindInfoDura.bagupdate <= 0 ) then	WindInfoDura_BagUpdate();
		WindInfoDura.bagupdate = nil; end
	end
end

function WindInfoDura_BagUpdate()
	WIDValues_Inven.value = 0;
	WIDValues_Inven.max = 0;
	WIDValues_Inven.cost = 0;
	for bag = 0, 4 do	
		for slot = 1, GetContainerNumSlots(bag) do
			local sPercent, value, max, cost = WindInfoDura_GetStatus(slot, bag);
			if (cost ~= nil) then WIDValues_Inven.value = WIDValues_Inven.value + value;
			WIDValues_Inven.max = WIDValues_Inven.max + max;
			WIDValues_Inven.cost = WIDValues_Inven.cost + cost; end
		end
	end
	WIDValues_Armor.value = 0;
	WIDValues_Armor.max = 0;
	WIDValues_Armor.cost = 0;
	for i = 1, 10 do
		local sPercent, value, max, cost = WindInfoDura_GetStatus(i);
		if (cost ~= nil) then WIDValues_Armor.value = WIDValues_Armor.value + value;
		WIDValues_Armor.max = WIDValues_Armor.max + max;
		WIDValues_Armor.cost = WIDValues_Armor.cost + cost; end
	end
	WindInfoDura_UpdatePercent();
end

function WindInfoDura_GetStatus(index, bag)
	local val = 0;
	local max = 0;
	local cost = 0;
	local hasItem, repairCost
	WIDCHKTT:SetOwner(WorldFrame, "ANCHOR_NONE");
	if (bag) then
		local _, lRepairCost = WIDCHKTT:SetBagItem(bag, index);
		repairCost = lRepairCost;
		hasItem = 1;
	else
		local slotName = WindInfoDura_Slots[index].slot .. "Slot";
		local id = GetInventorySlotInfo(slotName);
		local lHasItem, _, lRepairCost = WIDCHKTT:SetInventoryItem("player", id);
		hasItem = lHasItem;
		repairCost = lRepairCost;
	end
	if (hasItem) then
		if (repairCost) then cost = repairCost; end
		for i = 1, 30 do
			local field = _G["WIDCHKTTTextLeft" .. i];
			if (field ~= nil) then
				local text = field:GetText();
				if (text) then
					local _, _, f_val, f_max = string.find(text, "^내구도 (%d+) / (%d+)$");
					if (f_val) then
						val = tonumber(f_val);
						max = tonumber(f_max);
					end
				end
			end
		end
	end
	WIDCHKTT:Hide();
	return WindInfoDura_GetStatusPercent(val, max), val, max, cost;
end

function WindInfoDura_GetStatusPercent(val, max)
	if (max > 0) then return (val / max); end
	return 1.0;
end

function WindInfoDura_UpdatePercent()
	local green = GREEN_FONT_COLOR;
	local yellow = NORMAL_FONT_COLOR;
	local red = RED_FONT_COLOR;
	local percent = WindInfoDura_GetStatusPercent(WIDValues_Armor.value, WIDValues_Armor.max);
	local color = {};
	if (percent == 1.0) then color = green;
	elseif (percent == 0.5) then color = yellow;
	elseif (percent == 0.0) then color = red;
	elseif (percent > 0.5) then 
		local pct = (1.0 - percent) * 2;
		color.r =(yellow.r - green.r)*pct + green.r;
		color.g = (yellow.g - green.g)*pct + green.g;
		color.b = (yellow.b - green.b)*pct + green.b;
	elseif (percent < 0.5) then
		local pct = (0.5 - percent) * 2;
		color.r = (red.r - yellow.r)*pct + yellow.r;
		color.g = (red.g - yellow.g)*pct + yellow.g;
		color.b = (red.b - yellow.b)*pct + yellow.b;
	end
	if( ceil(percent*100) > 100) then percent = 100; else percent = ceil(percent*100); end
	WID_CurrPercent = percent;
	WindInfoDuraText:SetText(percent.."%");
	WindInfoDuraText:SetTextColor(color.r, color.g, color.b);
end

function WindInfoDura_ReturnSplitMoney(sMoney)
	local gold = floor(sMoney / (COPPER_PER_SILVER * SILVER_PER_GOLD));
	local silver = floor((sMoney - (gold * COPPER_PER_SILVER * SILVER_PER_GOLD)) / COPPER_PER_SILVER);
	local copper = mod(sMoney, COPPER_PER_SILVER);
	return gold, silver, copper;
end

function WindInfoDura_GetMoneyString(sAmt)
	if(not sAmt or tonumber(sAmt) == 0 ) then return "0"; end
	local gold, silver, copper = WindInfoDura_ReturnSplitMoney(sAmt);
	if(not gold) then gold = 0; end
	if(not silver) then silver = 0; end
	if(not copper) then copper = 0; end
	local sStoreString = "";
	if(gold ~= 0) then sStoreString = string.format("|c00FFFFFF%s|r|c00E2CD54g|r ", gold);
	end
	if(gold ~= 0 or silver ~= 0) then
		if(silver == 0) then sStoreString = sStoreString..string.format("|c00FFFFFF%s|r|c00AEAEAEs|r ", "00");
		else sStoreString = sStoreString..string.format("|c00FFFFFF%s|r|c00AEAEAEs|r ", silver); end
	end
	if(gold ~= 0 or silver ~= 0 or  copper ~= 0) then
		if(copper == 0) then sStoreString = sStoreString..string.format("|c00FFFFFF%s|r|c00D7844Dc|r", "00");
		else sStoreString = sStoreString..string.format("|c00FFFFFF%s|r|c00D7844Dc|r", copper); end
	end
	return sStoreString;
end

function WindInfoDura_initConfig()
	if (not WindInfoDuraConfig) then WindInfoDuraConfig = WindInfoDefault["Dura"]; end
end

function WindInfoDura_resetConfig()
	WindInfoDuraConfig = WindInfoDefault["Dura"];
end

function WindInfoDura_setPoint()
	WindCommon_setPoint(WindInfoDura, WindInfoDuraConfig[1], "WindInfo", WindInfoDuraConfig[1], WindInfoDuraConfig[2], WindInfoDuraConfig[3]);
end

function WindInfoDura_setScale()
	WindInfoDura:SetScale(WindInfoDuraConfig[4]);
end

function WindInfoDura_setSize()
	WindCommon_setSize(WindInfoDura, WindInfoDuraConfig[5], WindInfoDuraConfig[6]);
end

function WindInfoDura_setView()
	if (WindInfoDuraConfig[7]) then WindInfoDura:Show();
	else WindInfoDura:Hide(); end
end

function WindInfoDura_setMouse()
	if (WindInfoDuraConfig[8]) then WindInfoDura:Show();
	else WindInfoDura:Hide(); end
end