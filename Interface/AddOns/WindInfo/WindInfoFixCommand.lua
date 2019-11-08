SLASH_WINDINFO1 = "/windinfo";
SlashCmdList.WINDINFO = function (msg)
	local cmd, arg = string.split(" ", msg:lower())
	if (cmd == strlower("reset")) then
		ReloadUI();

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
	elseif (cmd == strlower("scale")) then
		--ReloadUI();		
		WindInfoBodyConfig[4] = arg

		WindInfoBag_refresh();
		WindInfoTime_refresh();
		WindInfoPerf_refresh();
		WindInfoBody_refresh();
		WindInfoXP_refresh();
		WindInfoRP_refresh();
	else
		DEFAULT_CHAT_FRAME:AddMessage("Wind Info Command: /windinfo", 1,1,1);
		DEFAULT_CHAT_FRAME:AddMessage("[ reset | scale ]", 1,1,1);
		DEFAULT_CHAT_FRAME:AddMessage("★ reset - 윈드 정보바 설정초기화",0.75,0.75,0.75);
		DEFAULT_CHAT_FRAME:AddMessage("★ scale - 비율을 지정한 값으로 변경. 예) /windinfo scale 0.85",0.75,0.75,0.75);
	end
end