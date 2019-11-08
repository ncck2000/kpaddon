local WindInfoDateWeek = {"일","월","화","수","목","금","토"};

function WindInfoDate_OnLoad(self)
	WindInfoDateText:SetAllPoints(WindInfoDate);
	WindInfoDate:RegisterEvent("VARIABLES_LOADED");
	WindInfoDate.str = "";
end

function WindInfoDate_OnUpdate(self, elapsed)
	local str = WindInfoDate_setDate();
	if (str ~= WindInfoDate.str) then
		WindInfoDate.str = str;
		WindInfoDateText:SetText(WindInfoDate.str);
	end
end

function WindInfoDate_OnEvent(self, event, ...)
	if (event == "VARIABLES_LOADED") then
		WindInfoDate_initConfig();
		WindInfoDate_setPoint();
		WindInfoDate_setScale();
		WindInfoDate_setSize();
		WindInfoDate_setView();
		WindInfoDate_setMouse();
	end
end

function WindInfoDate_setDate()
	local year = date("%y", time()) + 2000;
	local mon = date("%m", time()) + 0;
	local day = date("%d", time()) + 0;
	return "|cFFFFFF00" ..year.. "|cFFFFFFFF".."년".." |cFFFFFF00" ..mon.. "|cFFFFFFFF".."월".." |cFFFFFF00"..day.."|cFFFFFFFF".."일 ".."|cFFFFFF00"..WindInfoDateWeek[tonumber(date("%w", time()))+1].."|cFFFFFFFF요일";
end

function WindInfoDate_initConfig()
	if (not WindInfoDateConfig) then WindInfoDateConfig = WindInfoDefault["Date"]; end
end

function WindInfoDate_resetConfig()
	WindInfoDateConfig = WindInfoDefault["Date"];
end


function WindInfoDate_setPoint()
	WindCommon_setPoint(WindInfoDate, WindInfoDateConfig[1], "WindInfo", WindInfoDateConfig[1], WindInfoDateConfig[2], WindInfoDateConfig[3]);
end

function WindInfoDate_setScale()
	WindInfoDate:SetScale(WindInfoDateConfig[4]);
end

function WindInfoDate_setSize()
	WindCommon_setSize(WindInfoDate, WindInfoDateConfig[5], WindInfoDateConfig[6]);
end

function WindInfoDate_setView()
	if (WindInfoDateConfig[7]) then WindInfoDate:Show();
	else WindInfoDate:Hide(); end
end

function WindInfoDate_setMouse()
	if (WindInfoDateConfig[8]) then WindInfoDate:Show();
	else WindInfoDate:Hide(); end
end