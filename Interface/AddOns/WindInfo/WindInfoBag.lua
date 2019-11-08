function WindInfoBag_OnLoad(self)
	WindInfoBagText:SetAllPoints(WindInfoBag);
	WindInfoBagText:SetText(WindInfoBag_setBag());
	WindInfoBag:RegisterEvent("VARIABLES_LOADED");
	WindInfoBag:RegisterEvent("BAG_UPDATE");
	WindInfoBag:RegisterEvent("PLAYER_ENTERING_WORLD");
end

function WindInfoBag_OnEvent(self, event, ...)
	if (event == "VARIABLES_LOADED") then
		WindInfoBag_initConfig();
		WindInfoBag_refresh();
	elseif (event == "BAG_UPDATE" or event == "PLAYER_ENTERING_WORLD") then
		WindInfoBagText:SetText(WindInfoBag_setBag());
	end
end

function WindInfoBag_setBag()
	local total =0;
	local used = 0;
	for index = 0, 4 do
		if( index == 0 or GetInventoryItemCount("player", 19 + index) == 0 ) then total, used = WindInfoBag_setOneBag(index, total, used); end
	end
	if( ( total - used ) > 16 ) then
		return "|cFFFFFFFF"..used.."|cFFFFFFFF/"..total;
	elseif( ( total - used ) < 4 ) then
		return "|cFFFF0000"..used.."|cFFFF0000/"..total;
	else
		return "|cFFFFFF00"..used.."|cFFFFFF00/"..total;
	end
--	return "|cFFFFFF00"..used.."|cFFFFFFFF/".."|cFFFFFF00"..total;
end

function WindInfoBag_setOneBag(index, total, used)
	local size = GetContainerNumSlots(index);
	local u = used;
	for i = 1, size do
		if( GetContainerItemInfo(index, i) ) then u = u + 1; end
	end
	return total+size, u;
end

function WindInfoBag_initConfig()
	if (not WindInfoBagConfig) then WindInfoBagConfig = WindInfoDefault["Bag"]; end
end

function WindInfoBag_resetConfig()
	WindInfoBagConfig = WindInfoDefault["Bag"];

	WindInfoBag_refresh();
end

function WindInfoBag_refresh()
	WindInfoBag_setPoint();
	WindInfoBag_setScale();
	WindInfoBag_setSize();
	WindInfoBag_setView();
	WindInfoBag_setMouse();
end

function WindInfoBag_setPoint()
	WindCommon_setPoint(WindInfoBag, WindInfoBagConfig[1], "WindInfo", WindInfoBagConfig[1], WindInfoBagConfig[2], WindInfoBagConfig[3]);
end

function WindInfoBag_setScale()
	WindInfoBag:SetScale(WindInfoBagConfig[4]);
end

function WindInfoBag_setSize()
	WindCommon_setSize(WindInfoBag, WindInfoBagConfig[5], WindInfoBagConfig[6]);
end

function WindInfoBag_setView()
	if (WindInfoBagConfig[7]) then WindInfoBag:Show();
	else WindInfoBag:Hide(); end
end

function WindInfoBag_setMouse()
	if (WindInfoBagConfig[8]) then WindInfoBag:Show();
	else WindInfoBag:Hide(); end
end