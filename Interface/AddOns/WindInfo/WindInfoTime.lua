function WindInfoTime_OnLoad(self)
	WindInfoTimeText:SetAllPoints(WindInfoTime);
	WindInfoTime:RegisterEvent("VARIABLES_LOADED");
	WindInfoTime.str = "";
end

function TEXT(text)
  return text;
end

function WindInfoTime_OnUpdate(self, elapsed)
	local str = WindInfoTime_setTime();
	if (str ~= WindInfoTime.str) then
		WindInfoTime.str = str;
		WindInfoTimeText:SetText(WindInfoTime.str);
	end
end

function WindInfoTime_OnEvent(self, event, ...)
	if (event == "VARIABLES_LOADED") then
		WindInfoTime_initConfig();
		WindInfoTime_refresh();
	end
end

function WindInfoTime_setTime()
	local h, m = GetGameTime();
	local t = "오전";
	if (h >= 12) then t = "오후"; end
	if (h > 12) then h = h - 12; end
	if (h == 0) then h = 12; end
	return "|cFFFFFFFF"..t.." |cFFFFFF00"..format(TEXT(TIME_TWENTYFOURHOURS), h, m);
end

function WindInfoTime_initConfig()
	if (not WindInfoTimeConfig) then WindInfoTimeConfig = WindInfoDefault["Time"]; end
end

function WindInfoTime_resetConfig()
	WindInfoTimeConfig = WindInfoDefault["Time"];
	
	WindInfoTime_refresh();
end

function WindInfoTime_refresh()	
	WindInfoTime_setPoint();
	WindInfoTime_setScale();
	WindInfoTime_setSize();
	WindInfoTime_setView();
	WindInfoTime_setMouse();
end

function WindInfoTime_setPoint()
	WindCommon_setPoint(WindInfoTime, WindInfoTimeConfig[1], "WindInfo", WindInfoTimeConfig[1], WindInfoTimeConfig[2], WindInfoTimeConfig[3]);
end

function WindInfoTime_setScale()
	WindInfoTime:SetScale(WindInfoTimeConfig[4]);
end

function WindInfoTime_setSize()
	WindCommon_setSize(WindInfoTime, WindInfoTimeConfig[5], WindInfoTimeConfig[6]);
end

function WindInfoTime_setView()
	if (WindInfoTimeConfig[7]) then WindInfoTime:Show();
	else WindInfoTime:Hide(); end
end

function WindInfoTime_setMouse()
	if (WindInfoTimeConfig[8]) then WindInfoTime:Show();
	else WindInfoTime:Hide(); end
end