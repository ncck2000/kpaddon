
-- Slash
SLASH_WINDACTION1 = "/wind";
SLASH_WINDACTION2 = "/windaction";
SlashCmdList.WINDACTION = function (msg)
	local cmd, arg = string.split(" ", msg:lower())
	if (cmd == strlower("reset")) then

		ReloadUI();

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
		
	elseif (cmd == strlower("scale")) then
		--ReloadUI();
		
		WindActionDefault["Main"][4] = arg
		WindActionDefault["BottomLeft"][4] = arg
		WindActionDefault["BottomRight"][4] = arg
		WindActionDefault["Left"][4] = arg
		WindActionDefault["Right"][4] = arg
		WindActionDefault["Pet"][4] = arg
		WindActionDefault["Shift"][4] = arg
		WindActionDefault["Bag"][4] = tonumber(arg) * 0.93
		WindActionDefault["Menu"][4] = tonumber(arg) * 0.93
		WindActionDefault["Scroll"][4] = arg
		WindActionDefault["Latency"][4] = arg

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
		
	else
		DEFAULT_CHAT_FRAME:AddMessage("Wind Action Command: /windaction or /wind", 1,1,1);
		DEFAULT_CHAT_FRAME:AddMessage("[ reset | scale ]", 1,1,1);
		DEFAULT_CHAT_FRAME:AddMessage("★ reset - 윈드 액션바 설정초기화",0.75,0.75,0.75);
		DEFAULT_CHAT_FRAME:AddMessage("★ scale - 비율을 지정한 값으로 변경. 예) /windaction scale 0.85",0.75,0.75,0.75);
		DEFAULT_CHAT_FRAME:AddMessage("마우스 휠로 전체 스캐일 조절이 가능합니다.",0.85,0.85,0.45);
		DEFAULT_CHAT_FRAME:AddMessage("윈드 정보바는 /windinfo 로 확인가능합니다.",0.85,0.85,0.45);
	end
end
