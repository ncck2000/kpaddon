WindInfo_StandingID = {"|cFFFF0000매우 적대적|r","|cFFFF0000적대적|r","|cFFFF0000약간 적대적|r","|cFFFFFF00중립적|r","|cFF00FF00약간 우호적|r","|cFF00FF00우호적|r","|cFF00FF00매우 우호적|r","|cFF00FF00확고한 동맹|r"};

local WindInfoBar_LastFactionName
local WindInfoBar_LastFaction
local WindInfoBarIsShown
-- ArtifactWatchBar.StatusBar
function WindInfo_OnLoad(self)

	WindCommon_setBackground(WindInfoBorder, WindInfo, 2);
	WindInfoBorder:Show();

	-- 블리자드 기본 경험치바 재사용
	--MainMenuExpBar:SetParent(WindInfo);
	--MainMenuExpBar:SetStatusBarTexture("Interface\\AddOns\\WindCommon\\UI-StatusBar.tga");
	WindInfoXPBar:SetFrameStrata("BACKGROUND");

	-- 2.0.3 이후로 MainMenuExpBar에 함께 나타났던 버그 수정 --
--	MainMenuBarTexture0:Hide();
--	MainMenuBarTexture1:Hide();
--	MainMenuBarTexture2:Hide();
--	MainMenuBarTexture3:Hide();
--	MainMenuBarOverlayFrame:Hide();
	

	-- 안테나(?) 숨김...
--	ExhaustionTick:Hide();
--	ExhaustionTickNormal:Hide();
--	ExhaustionTickHighlight:Hide();
--	ExhaustionLevelFillBar:Hide();

	-- 경험치바(휴식게이지 포함), 평판바 위치 설정
	
	WindCommon_setPoint(WindInfoRestXP, "TOPLEFT", WindInfo, "TOPLEFT", 6, -6);
	WindCommon_setPoint(WindInfoXPBar, "TOPLEFT", WindInfo, "TOPLEFT", 6, -6);
	WindCommon_setPoint(WindInfoRPBar, "BOTTOMLEFT", WindInfo, "BOTTOMLEFT", 6, 6);

	WindInfo_updateXP(self);
	WindInfo_updateRP(self);

	WindInfoMouse:SetAllPoints(WindInfo);
	WindInfo:SetFrameLevel(0);
	WindInfoRestXP:SetFrameLevel(1);
	WindInfoXPBar:SetFrameLevel(2);
	
	WindInfoRPBar:SetFrameLevel(2);
	WindInfoXP:SetFrameLevel(3);
	WindInfoRP:SetFrameLevel(3);
	WindInfoMoney:SetFrameLevel(3);
	WindInfoTime:SetFrameLevel(3);
	WindInfoPerf:SetFrameLevel(3);
	WindInfoBag:SetFrameLevel(3);
	WindInfoDura:SetFrameLevel(3);
	WindInfoTick:SetFrameLevel(3);
	WindInfoDate:SetFrameLevel(3);
	WindInfoMouse:SetFrameLevel(4);

	WindInfo:RegisterEvent("VARIABLES_LOADED");
	WindInfo:RegisterEvent("PLAYER_ENTERING_WORLD");
	WindInfo:RegisterEvent("PLAYER_XP_UPDATE");
	WindInfo:RegisterEvent("CHAT_MSG_COMBAT_FACTION_CHANGE");
	WindInfo:RegisterEvent("UPDATE_FACTION");
	
end

function WindInfo_updateXP(self)
  -- classic 버전으로 변경 -- 190829
	-- 만렙(현재는 90)까지의 남은 경험치를 계산하기 위한 경험치 누적수치 맵
	
	xpl = { 0,		400,		1300,		2700,		4800,		-- Level:1~5
		7600,	  	11200,	  15700,		21100,		27600,		-- Level:6~10
		35200,		44000,		54100,		65500,		78400,		-- Level:11~15
		92800,		108800,		126500,		145900,		167200,		-- Level:16~20
		190400,		215600,		242900,		272300,		304000,		-- Level:21~25
		338000,		374400,		413300,		454700,		499000,		-- Level:26~30
		546400,		597200,		651700,	  710300,	  773100,		-- Level:31~35
		840200,		911800,		987900,		1068700,		1154400,		-- Level:36~40
		1245100,		1340900,		1441900,	  1548200,	  1660000, 	-- Level:41~45
		1777500,	  1900700,	  2029800,	  2164900,	  2306100,	  -- Level:46~50
		2453600,	  2607500,	  2767900,	  2935000,	  3108900,	  -- Level:51~55
		3289700,  	3477600,  	3672600,	  3874900,  	4084700,  	-- Level:56~60
		
		5676670,  	5938530,  	6208340,	  6486220,  	6772000,  	-- Level:61~65
		7066080,  	7368580,	  7679620,	  7999020,  	8327190,	  -- Level:66~70
		8664250,  	9010000,	  9364880,   	9729000,	  10102150, 	-- Level:71~75
		10484780,	  10877000,	  11278600,	  11690030,	  12111400,	  -- Level:76~80
		12542840, 	12984110, 	13435670,	  13897650,	  14369800, 	-- Level:81~85
		14852600,	  15346170,	  15850240,	  16365320,	  16891520, 	-- Level:86~90
		17434110, 	17988120,	  18553660,	  19130440,	  19718990, 	-- Level:91~95
		20319430,	  20931870,	  21556430,	  22193240,	  22841970, 	-- Level:96~100
		23498970, 	24161970,	  24830970,	  25505970, 	26186970, 	-- Level:101~105
		26873970, 	27566970,	  28265970,	  28970970,	  29681970,	  -- Level:106~110 
		30398970,	  31230420,	  32068770,	  32914020,	  33766170,	  -- Level:111~115 
		34625220,	  35491170,	  36364020, 	37243770,	  38130420, 	-- Level:116~120 
	};

	local level = UnitLevel("player");
	if (level > 0 and level < MAX_PLAYER_LEVEL) then
		if ( WindInfo.XP ) then
			WindInfo.LastXP = UnitXP("player") - WindInfo.XP;
		end
		WindInfo.XP = UnitXP("player");
		WindInfo.MaxXP = UnitXPMax("player");

		if(WindInfo.MaxXP == 0) then 
			if(level > 2) then 
				WindInfo.MaxXP = xpl[level] - xpl[level - 1];
			else 
				WindInfo.MaxXP = xpl[2]; 
			end
		end
	
		WindInfo.TotalXP = xpl[level] + WindInfo.XP;	-- 현재까지의 총 경험치 산출
		WindInfo.RestXP = GetXPExhaustion();
		WindInfo.XPPer = string.format("%0.1f", (WindInfo.XP / WindInfo.MaxXP) * 100); 
		WindInfo.XTL = WindInfo.MaxXP - WindInfo.XP;
		WindInfo.XTLPer = 100 - tonumber(WindInfo.XPPer);
		if ( WindInfo.LastXP and WindInfo.LastXP > 0 ) then
			WindInfo.MTL = tonumber( WindInfo.XTL / WindInfo.LastXP )
			if ( floor(WindInfo.MTL) < WindInfo.MTL ) then
				WindInfo.MTL = floor(WindInfo.MTL) + 1;
			else
				WindInfo.MTL = floor(WindInfo.MTL)
			end
			WindInfo.XPText = "|cFFFFFF00"..WindInfo.XTL.." |cFFFFFFFF( |cFFFFFF00"..WindInfo.XTLPer.."|cFFFFFFFF% ) |cFFFF00FF"..WindInfo.MTL.."|cFFFFFFFF회";
		else
			WindInfo.XPText = "|cFFFFFF00"..WindInfo.XTL.." |cFFFFFFFF( |cFFFFFF00"..WindInfo.XTLPer.."|cFFFFFFFF% )";
		end
		if (not WindInfo.RestXP) then WindInfo.RestXP = 0; end
		WindInfo.RestXPPer = string.format("%0.1f", (WindInfo.RestXP / WindInfo.MaxXP) * 100);
		WindInfo.XPPer = string.format("%0.1f", (WindInfo.XP / WindInfo.MaxXP) * 100); 
		
		-- 만렙까지의 경험치 산출(맵에 해당 수치가 있을 경우에만 계산됨)
		if(xpl[MAX_PLAYER_LEVEL]) then 
			WindInfo.NeedXP = xpl[MAX_PLAYER_LEVEL] - WindInfo.TotalXP;	-- 만렙까지의 남은 경험치
			WindInfo.NeedXPPer = string.format("%0.1f", (WindInfo.NeedXP / xpl[MAX_PLAYER_LEVEL]) * 100);
		end

		WindInfoRestXP:SetMinMaxValues(0, WindInfo.MaxXP);
		if (WindInfo.RestXP) then WindInfoRestXP:SetValue(WindInfo.XP + tonumber(WindInfo.RestXP)); end
		
		WindInfoXPBar:SetMinMaxValues(min(0, WindInfo.XP),WindInfo.MaxXP);
		if (WindInfo.XP) then WindInfoXPBar:SetValue(WindInfo.XP);end

		if ( not WindInfoBarIsShown ) then WindInfoRestXP:Hide();
		WindInfoXPBar:Hide(); return; end

		WindInfoRestXP:Show();
		WindInfoXPBar:Show();
	else
	
    local startLevel, currentXp
    local currentMaxXp = currentMaxXp or 1
		local azeriteItemLocation = C_AzeriteItem.FindActiveAzeriteItem()
		if not azeriteItemLocation then
      return
    end
		local azeriteItemIcon = C_Item.GetItemIcon(azeriteItemLocation)
		local startXp = C_AzeriteItem.GetAzeriteItemXPInfo(azeriteItemLocation)
		startLevel, currentMaxXp = C_AzeriteItem.GetPowerLevel(azeriteItemLocation)
		currentXp, currentMaxXp = C_AzeriteItem.GetAzeriteItemXPInfo(azeriteItemLocation)

		--WindInfoRestXP:SetMinMaxValues(0, numPointsAvailableToSpend + artifactPointsSpent);
		--if (WindInfo.RestXP) then WindInfoRestXP:SetValue(xpForNextPoint); end
		WindInfo.XP = startXp
		WindInfo.MaxXP = currentMaxXp
		WindInfo.XPPer = string.format("%0.1f", (WindInfo.XP / WindInfo.MaxXP) * 100); 
		WindInfo.XTL = WindInfo.MaxXP - WindInfo.XP;
		WindInfo.XTLPer = 100 - tonumber(WindInfo.XPPer);
		WindInfoXPBar:SetMinMaxValues(min(0, WindInfo.XP),WindInfo.MaxXP);
		if (WindInfo.XP) then WindInfoXPBar:SetValue(WindInfo.XP);end

		if ( not WindInfoBarIsShown ) then 
      WindInfoRestXP:Hide();
      WindInfoXPBar:Hide(); 
      return; 
		end

		WindInfoRestXP:Hide();
		WindInfoXPBar:Show();
	end
	local exhaustionStateID = GetRestState();
		if (exhaustionStateID == 1) then
			WindInfoXPBar:SetStatusBarColor(0.0, 0.39, 0.88, 1.0);
		elseif (exhaustionStateID == 2) then
			WindInfoXPBar:SetStatusBarColor(0.58, 0.0, 0.55, 1.0);
		end
	--ExhaustionLevelFillBar:Hide();  -- 8.0
end

--function WindInfo_ArtifactUpdate() 
--  	local artifactItemID, _, _, _, artifactTotalXP, artifactPointsSpent, _, _, _, _, _, _, artifactTier = C_ArtifactUI.GetEquippedArtifactInfo(); 
--  	local numPointsAvailableToSpend, xp, xpForNextPoint = ArtifactBarGetNumArtifactTraitsPurchasableFromXP(artifactPointsSpent, artifactTotalXP, artifactTier); 
  

--  	self:SetBarValues(xp, 0, xpForNextPoint, numPointsAvailableToSpend + artifactPointsSpent); 
  	 
--  	self.StatusBar.artifactItemID = artifactItemID; 
--  	self.xp = xp; 
--  	self.totalXP = artifactTotalXP; 
--  	self.xpForNextPoint = xpForNextPoint; 
--  	self.numPointsAvailableToSpend = numPointsAvailableToSpend; 
--  	self:Show(); 
--  	self.Tick:SetShown(numPointsAvailableToSpend > 0); 
--  	self.StatusBar.Underlay:SetShown(numPointsAvailableToSpend > 0); 
--  	self.StatusBar.Overlay:Show(); 
--  	self.StatusBar.Overlay:SetAlpha(numPointsAvailableToSpend > 0 and .35 or .25); 
--  	self:UpdateTick(); 
--end 

function WindInfo_updateRP(self)
	WindInfo.RP = nil;
	WindInfo.MaxRP = nil;
	WindInfo.FactionRP = nil;
	WindInfo.StandingRP = nil;

	for i=1, GetNumFactions() do
		local name, description, standingID, barMin, barMax, barValue, atWarWith, canToggleAtWar, isHeader, isCollapsed, hasRep, isWatched, isChild = GetFactionInfo(i);         -- for 3.0.2 patch by 개델
--		local name, description, standingId, bottomValue, topValue, earnedValue, atWarWith, canToggleAtWar, isHeader, isCollapsed, isWatched = GetFactionInfo(i);
		if (isWatched) then
			WindInfo.RP = barValue-barMin;
			WindInfo.MaxRP = barMax-barMin;
			WindInfo.FactionRP = name;
			WindInfo.StandingRP = standingID;
			WindInfo.RTR = WindInfo.MaxRP - WindInfo.RP
			if( WindInfo.MaxRP == 0 ) then
				WindInfo.RPPer = 100;
			else
				WindInfo.RPPer = string.format("%0.2f", (WindInfo.RP/WindInfo.MaxRP)*100);
			end
			WindInfo.RTRPer = 100 - WindInfo.RPPer;
			if ( WindInfoBar_LastFactionName == name and WindInfoBar_LastFaction ) then
				WindInfo.MTR = tonumber(WindInfo.RTR / WindInfoBar_LastFaction)
				if ( floor(WindInfo.MTR) < WindInfo.MTR ) then
					WindInfo.MTR = floor(WindInfo.MTR) + 1;
				else
					WindInfo.MTR = floor(WindInfo.MTR)
				end
				WindInfo.RPText = "|cFFFFFF00"..WindInfo.RTR.." |cFFFFFFFF( |cFFFFFF00"..WindInfo.RTRPer.."|cFFFFFFFF% ) |cFFFF00FF"..WindInfo.MTR.."|cFFFFFFFF회";
			elseif ( WindInfo.RTR > 0 ) then
				WindInfo.RPText = "|cFFFFFF00"..WindInfo.RTR.." |cFFFFFFFF( |cFFFFFF00"..WindInfo.RTRPer.."|cFFFFFFFF% )";
			else
				WindInfo.RPText = nil;
			end
		end
	end
	if ( not WindInfoBarIsShown ) then WindInfoRPBar:Hide(); return; end

	if (WindInfo.RP) then
		WindInfoRPBar:SetMinMaxValues(0, WindInfo.MaxRP);
		WindInfoRPBar:SetValue(tonumber(WindInfo.RP));
		local color = FACTION_BAR_COLORS[WindInfo.StandingRP];
		WindInfoRPBar:SetStatusBarColor(color.r, color.g, color.b);

		WindInfoRPBar:Show();
	else WindInfoRPBar:Hide(); end
end

function ReputationWatchBar_Update(newLevel)
end

function WindInfoMouse_RefreshView()

		if WindInfoPerfConfig[7] then 
			if WindInfoPerfConfig[8] then WindInfoPerf:Hide(); 
			else WindInfoPerf:Show(); end
		end
		if WindInfoDateConfig[7] then 
			if WindInfoDateConfig[8] then WindInfoDate:Hide(); 
			else WindInfoDate:Show(); end
		end
		if WindInfoTickConfig[7] then 
			if WindInfoTickConfig[8] then WindInfoTick:Hide(); 
			else WindInfoTick:Show(); end
		end
		if WindInfoMoneyConfig[7] then 
			if WindInfoMoneyConfig[8] then WindInfoMoney:Hide(); 
			else WindInfoMoney:Show(); end
		end
		if WindInfoBagConfig[7] then 
			if WindInfoBagConfig[8] then WindInfoBag:Hide(); 
			else WindInfoBag:Show(); end
		end
		if WindInfoTimeConfig[7] then 
			if WindInfoTimeConfig[8] then WindInfoTime:Hide(); 
			else WindInfoTime:Show(); end
		end
		if WindInfoDuraConfig[7] then 
			if WindInfoDuraConfig[8] then WindInfoDura:Hide(); 
			else WindInfoDura_BagUpdate();
			WindInfoDura:Show(); end
		end
		if (WindInfoXPConfig[7]) then 
			if (WindInfoXPConfig[8]) then WindInfoXPText:Hide();
			else WindInfoXPText:Show(); end
		end
		if (WindInfoRPConfig[7]) then
			if (WindInfoRPConfig[8]) then WindInfoRPText:Hide();
			else WindInfoRPText:Show(); end
		end
		
end

function WindInfoMouse_HidehView()
		if WindInfoPerfConfig[7] then WindInfoPerf_setMouse();
		else WindInfoPerf:Hide(); end
		if WindInfoDateConfig[7] then WindInfoDate_setMouse();
		else WindInfoDate:Hide(); end
		if WindInfoTickConfig[7] then WindInfoTick_setMouse();
		else WindInfoTick:Hide(); end
		if WindInfoMoneyConfig[7] then WindInfoMoney_setMouse();
		else WindInfoMoney:Hide(); end
		if WindInfoBagConfig[7] then WindInfoBag_setMouse();
		else WindInfoBag:Hide(); end
		if WindInfoTimeConfig[7] then WindInfoTime_setMouse();
		else WindInfoTime:Hide(); end
		if WindInfoDuraConfig[7] then WindInfoDura_setMouse();
		else WindInfoDura:Hide(); end
		if WindInfoXPConfig[7] then WindInfoXP_setMouse();
		else WindInfoXPText:Hide(); end
		if WindInfoRPConfig[7] then WindInfoRP_setMouse();
		else WindInfoRPText:Hide(); end
end

function WindInfoMouse_OnEnter(self, motion)
	if (WindInfoBodyConfig[7]) then
    WindInfoMouse_RefreshView();
		WindInfo_ShowTooltip(self);
	end
end

function WindInfoMouse_OnLeave(self, motion)
	if (WindInfoBodyConfig[7]) then
    WindInfoMouse_HidehView();
	end
end

function WindInfo_OnEvent(self, event, ...)
	if (event == "VARIABLES_LOADED") then
		WindInfoBody_initConfig();
		WindInfoBody_refresh();

		WindInfoXP_initConfig();
		WindInfoXP_refresh();

		WindInfoRP_initConfig();
		WindInfoRP_refresh();

		if WindInfoPerfConfig[7] then WindInfoPerf_setMouse();
		else WindInfoPerf:Hide(); end
		if WindInfoDateConfig[7] then WindInfoDate_setMouse();
		else WindInfoDate:Hide(); end
		if WindInfoTickConfig[7] then WindInfoTick_setMouse();
		else WindInfoTick:Hide(); end
		if WindInfoMoneyConfig[7] then WindInfoMoney_setMouse();
		else WindInfoMoney:Hide(); end
		if WindInfoBagConfig[7] then WindInfoBag_setMouse();
		else WindInfoBag:Hide(); end
		if WindInfoTimeConfig[7] then WindInfoTime_setMouse();
		else WindInfoTime:Hide(); end
		if WindInfoDuraConfig[7] then WindInfoDura_setMouse();
		else WindInfoDura:Hide(); end
		if WindInfoXPConfig[7] then WindInfoXP_setMouse();
		else WindInfoXPText:Hide(); end
		if WindInfoRPConfig[7] then WindInfoRP_setMouse();
		else WindInfoRPText:Hide(); end

		WindInfoBar_setSize(self);
	elseif (event == "PLAYER_ENTERING_WORLD" or event == "PLAYER_XP_UPDATE" or event == "UPDATE_EXHAUSTION") then
		WindInfo_updateXP(self);
		WindInfoXP_setText();
	elseif (event == "CHAT_MSG_COMBAT_FACTION_CHANGE") then
	 local arg1 = ...;
		if string.find (arg1, "(.+)에 대한 평판이 (%d+)만큼 상승했습니다." ) then
			local _, _, LastFactionName, LastFaction = string.find(arg1, "(.+)에 대한 평판이 (%d+)만큼 상승했습니다" )
			if (LastFactionName == WindInfo.FactionRP ) then
				WindInfoBar_LastFactionName = LastFactionName
				WindInfoBar_LastFaction = LastFaction
			end
		end
	elseif (event == "UPDATE_FACTION") then
		WindInfo_updateRP(self);
		WindInfoRP_setText(self);
		WindInfoBar_setSize(self);
	end
end

function WindInfo_ShowTooltip(self)
	GameTooltip_SetDefaultAnchor(GameTooltip, self);
	local uiScale = GetCVar("uiscale") + 0;
	local screenHeight = 768;
	local screenWidth = 1024;
	local anchor;
	local x, y = WindInfo:GetCenter();
	if( GetCVar("useUiScale") == "1" ) then
		screenHeight = 768 / uiScale;
		screenWidth = 1024 / uiScale;
	end

	if( y < screenHeight / 2 ) then
		if( x < screenWidth / 2 ) then
			anchor = "ANCHOR_TOPRIGHT";
		else
			anchor = "ANCHOR_TOPLEFT";
		end
		GameTooltip:SetOwner(WindInfo, anchor);
	else
		if( x < screenWidth / 2 ) then
			GameTooltip:SetOwner(WindInfo, "ANCHOR_NONE");
			GameTooltip:SetPoint("TOPRIGHT", "WindInfo", "TOPRIGHT", 0, -WindInfo:GetHeight());
		else
			GameTooltip:SetOwner(WindInfo, "ANCHOR_NONE");
			GameTooltip:SetPoint("TOPLEFT", "WindInfo", "TOPLEFT", 0, -WindInfo:GetHeight());
		end
	end
	if (WindInfoDuraConfig[7]) then
		GameTooltip:AddLine("|cffffd200수리비|r");
		GameTooltip:AddDoubleLine("|c00FFFFFF".."가방 장비 :".."|r", WindInfoDura_GetMoneyString(WIDValues_Inven.cost),1,1,1,1,1,1);
		GameTooltip:AddDoubleLine("|c00FFFFFF".."착용 장비 :".."|r", WindInfoDura_GetMoneyString(WIDValues_Armor.cost),1,1,1,1,1,1);
		GameTooltip:AddDoubleLine("|c00FFFFFF".."모든 장비 :".."|r", WindInfoDura_GetMoneyString( (WIDValues_Inven.cost + WIDValues_Armor.cost ) ),1,1,1,1,1,1);
		if ((WindInfoBarIsShown and WindInfo.XP and WindInfoXPConfig[10]) or (WindInfoBarIsShown and WindInfo.RP and WindInfoRPConfig[10])) then
			GameTooltip:AddLine(" ");
		end
	end
	local level = UnitLevel("player");
	if (level > 0 and level < MAX_PLAYER_LEVEL and WindInfoXPConfig[10]) then
		if ( not WindInfoBarIsShown ) then GameTooltip:Show(); return; end
		GameTooltip:AddLine("|cffffd200경험치|r");
		GameTooltip:AddLine("|c00FFFFFF".."현재 경험치 : ".."|r".."|cFFFFFF00"..WindInfo.XP.." |cFFFFFFFF/|cFFFFFF00 "..WindInfo.MaxXP.." |cFFFFFFFF( |cFFFFFF00"..WindInfo.XPPer.."|cFFFFFFFF% )");
		if (WindInfo.RestXP) then
			GameTooltip:AddLine("|c00FFFFFF".."휴식 경험치 : ".."|r".."|cFFFFFF00"..WindInfo.RestXP.." |cFFFFFFFF( |cFFFFFF00"..WindInfo.RestXPPer.."|cFFFFFFFF% )");
		end
		if (WindInfo.XPText) then
			local nextlevel = level + 1
			GameTooltip:AddLine("|c00FFFFFF"..nextlevel.."레벨까지 남은 경험치 : "..WindInfo.XPText);
			
			if(xpl[MAX_PLAYER_LEVEL]) then
				GameTooltip:AddLine("|c00FFFFFF"..MAX_PLAYER_LEVEL.."레벨까지 남은 경험치 : |cFFFFFF00"..WindInfo.NeedXP.." |cFFFFFFFF( |cFFFFFF00"..WindInfo.NeedXPPer.."|cFFFFFFFF% )");			
			end
		end

		if (WindInfoBarIsShown and WindInfo.RP and WindInfoRPConfig[10]) then
			GameTooltip:AddLine(" ");
		end		
	end
	if (WindInfo.RP and WindInfoRPConfig[10]) then
		if ( not WindInfoBarIsShown ) then GameTooltip:Show(); return; end
		GameTooltip:AddLine("|cffffd200평판|r");
		GameTooltip:AddLine("|cFFFFFFFF"..WindInfo.FactionRP.." : |cFFFFFF00"..WindInfo.RP.." |cFFFFFFFF/|cFFFFFF00 "..WindInfo.MaxRP.."|cFFFFFFFF ( |cFFFFFF00"..WindInfo.RPPer.."|cFFFFFFFF% ) "..WindInfo_StandingID[WindInfo.StandingRP]);
		if ( WindInfo.RPText and (WindInfo.StandingRP < 8) ) then
			GameTooltip:AddLine(WindInfo_StandingID[WindInfo.StandingRP+1].."|cFFFFFFFF 까지 남은 평판 |cFFFFFFFF: |cFFFFFF00"..WindInfo.RPText);
		end
	end
	GameTooltip:Show();
end

function WindInfoBody_initConfig(self)
	if (not WindInfoBodyConfig) then 
		WindInfoBodyConfig = WindInfoDefault["Body"]; 
	end
	
	if (IsAddOnLoaded("WindConfig")) then 
		WindInfoConfigBody_show();
		WindInfoConfigBody_setColor(color); 
	end
end

function WindInfoBody_resetConfig(self)
	WindInfoBodyConfig = WindInfoDefault["Body"];
	
	WindInfoBody_refresh();
	
	if (IsAddOnLoaded("WindConfig")) then 
		WindInfoConfigBody_show();
		WindInfoConfigBody_setColor(color); 
	end
end

function WindInfoBody_refresh(self)	
	WindInfoBody_setPoint();
	WindInfoBody_setScale();
	WindInfoBody_setSize();
	WindInfoBody_setBorder();
	WindInfoBody_setSTBar();	
end

function WindInfoBody_setPoint(self)
	WindCommon_setPoint(WindInfo, WindInfoBodyConfig[1], UIParent, WindInfoBodyConfig[1], WindInfoBodyConfig[2], WindInfoBodyConfig[3]);
end

function WindInfoBody_setScale(self)
	WindInfo:SetScale(WindInfoBodyConfig[4]);
end

function WindInfoBody_setSize(self)
	WindCommon_setSize(WindInfo, WindInfoBodyConfig[5], WindInfoBodyConfig[6]);
	WindCommon_setSize(WindInfoRestXP, WindInfoBodyConfig[5], WindInfoBodyConfig[6]);
	WindCommon_setSize(WindInfoRPBar, WindInfoBodyConfig[5], WindInfoBodyConfig[6]);
end

function WindInfoBody_setBorder(self)
	if (WindInfoBodyConfig[9]) then WindInfoBorder:SetBackdrop(WindCommon_ColorBorder);
	WindInfoBody_setColor();
	else WindInfoBorder:SetBackdrop(nil); end
end

function WindInfoBody_setSTBar(self)
	if (WindInfoBodyConfig[10]) then WindInfoBarIsShown = true;
	else WindInfoBarIsShown = false; end

	WindInfo_updateXP(self);
	WindInfo_updateRP(self);
	WindInfoBar_setSize(self);
end

function WindInfoBody_setColor(self)
	WindInfoBorder:SetBackdropBorderColor(WindInfoBodyConfig[8][1].r, WindInfoBodyConfig[8][1].g, WindInfoBodyConfig[8][1].b, WindInfoBodyConfig[8][1].a);
	WindInfoBorder:SetBackdropColor(WindInfoBodyConfig[8][2].r, WindInfoBodyConfig[8][2].g, WindInfoBodyConfig[8][2].b, WindInfoBodyConfig[8][2].a);
end

function WindInfoBody_resetColor(self)
	WindInfoBodyConfig[8] = WindInfoDefault["Body"][8];
	WindInfoBody_setColor();
end

function WindInfoBar_setSize(self)
	if ( not WindInfoBarIsShown ) then WindInfoRestXP:Hide();
	WindInfoXPBar:Hide();
	WindInfoRestXP:Hide(); return; end

	local width = WindInfoBodyConfig[5]-12;
	local height = WindInfoBodyConfig[6] / 2;

	if (WindInfo.RP) then
		WindCommon_setSize(WindInfoRestXP, width, height-6);
		WindCommon_setSize(WindInfoXPBar, width, height-6);
	else
		WindCommon_setSize(WindInfoRestXP, width, WindInfoBodyConfig[6]-12);
		WindCommon_setSize(WindInfoXPBar, width, WindInfoBodyConfig[6]-12);
	end

	local level = UnitLevel("player");
	--if (level > 0 and level < MAX_PLAYER_LEVEL and WindInfo.RP) then 
    WindCommon_setSize(WindInfoRPBar, width, height-5);
	--else 
  --  WindCommon_setSize(WindInfoRPBar, width, WindInfoBodyConfig[6]-10); 
 --end
	
	--ExhaustionLevelFillBar:Hide();  -- 8.0
	
end

function WindInfoXP_initConfig(self)
	if (not WindInfoXPConfig) then 
		WindInfoXPConfig = WindInfoDefault["XP"]; 
	end
end

function WindInfoXP_resetConfig(self)

	WindInfoXPConfig = WindInfoDefault["XP"];

	WindInfoXP_refresh();
end

function WindInfoXP_refresh(self)
	WindInfoXP_setPoint();
	WindInfoXP_setScale();
	WindInfoXP_setSize();
	WindInfoXP_setView();
	WindInfoXP_setMouse();
end

function WindInfoXP_setPoint(self)
	WindCommon_setPoint(WindInfoXP, WindInfoXPConfig[1], "WindInfo", WindInfoXPConfig[1], WindInfoXPConfig[2], WindInfoXPConfig[3]);
end

function WindInfoXP_setScale(self)
	WindInfoXP:SetScale(WindInfoXPConfig[4]);
end

function WindInfoXP_setSize(self)
	WindCommon_setSize(WindInfoXP, WindInfoXPConfig[5], WindInfoXPConfig[6]);
end

function WindInfoXP_setView(self)
	if (WindInfoXPConfig[7]) then WindInfoXPText:Show();
	else WindInfoXPText:Hide(); end
end

function WindInfoXP_setMouse(self)
	if (WindInfoXPConfig[8]) then WindInfoXPText:Show();
	else WindInfoXPText:Hide(); end
end

function WindInfoXP_setText(self)
	local level = UnitLevel("player");
	if (level > 0 and level < MAX_PLAYER_LEVEL) then
		if ( WindInfo.RestXP > 0 ) then
			if (WindInfoXPConfig and WindInfoXPConfig[9])then
				WindInfoXPText:SetText("|cFFFFFF00"..WindInfo.XP.." |cFFFFFFFF+|cFF00AAFF "..WindInfo.RestXP.." |cFFFFFFFF/|cFFFFFF00 "..WindInfo.MaxXP.." |cFFFFFFFF(|cFFFFFF00 "..WindInfo.XPPer.."|cFFFFFFFF% ), "..WindInfo.XPText.." XP");
			else
				WindInfoXPText:SetText("|cFFFFFF00"..WindInfo.XP.." |cFFFFFFFF+|cFF00AAFF "..WindInfo.RestXP.." |cFFFFFFFF/|cFFFFFF00 "..WindInfo.MaxXP.." |cFFFFFFFFXP");
			end
		else
			if (WindInfoXPConfig and WindInfoXPConfig[9])then
				WindInfoXPText:SetText("|cFFFFFF00"..WindInfo.XP.." |cFFFFFFFF/|cFFFFFF00 "..WindInfo.MaxXP.." |cFFFFFFFF(|cFFFFFF00 "..WindInfo.XPPer.."|cFFFFFFFF% ), "..WindInfo.XPText.." XP");
			else
				WindInfoXPText:SetText("|cFFFFFF00"..WindInfo.XP.." |cFFFFFFFF/|cFFFFFF00 "..WindInfo.MaxXP.." |cFFFFFFFFXP");
			end
		end
	end
end

function WindInfoRP_initConfig(self)
	if (not WindInfoRPConfig) then WindInfoRPConfig = WindInfoDefault["RP"]; end
end

function WindInfoRP_resetConfig(self)
	WindInfoRPConfig = WindInfoDefault["RP"];

	WindInfoRP_refresh();
end

function WindInfoRP_refresh(self)
	WindInfoRP_setPoint();
	WindInfoRP_setScale();
	WindInfoRP_setSize();
	WindInfoRP_setView();
	WindInfoRP_setMouse();
end

function WindInfoRP_setPoint(self)
	WindCommon_setPoint(WindInfoRP, WindInfoRPConfig[1], "WindInfo", WindInfoRPConfig[1], WindInfoRPConfig[2], WindInfoRPConfig[3]);
end

function WindInfoRP_setScale(self)
	WindInfoRP:SetScale(WindInfoRPConfig[4]);
end

function WindInfoRP_setSize(self)
	WindCommon_setSize(WindInfoRP, WindInfoRPConfig[5], WindInfoRPConfig[6]);
end

function WindInfoRP_setView(self)
	if (WindInfoRPConfig[7]) then WindInfoRPText:Show();
	else WindInfoRPText:Hide(); end
end

function WindInfoRP_setMouse(self)
	if (WindInfoRPConfig[8]) then WindInfoRPText:Show();
	else WindInfoRPText:Hide(); end
end

function WindInfoRP_setText(self)
	if (WindInfo.RP) then
		if (WindInfoRPConfig and WindInfoRPConfig[9]) then
			WindInfoRPText:SetText("|cFFFFFF00"..WindInfo.FactionRP.." |cFFFFFFFF: |cFFFFFF00"..WindInfo.RP.." |cFFFFFFFF/|cFFFFFF00 "..WindInfo.MaxRP.." |cFFFFFFFF(|cFFFFFF00 "..WindInfo.RPPer.."|cFFFFFFFF% ), "..WindInfo.RPText.." |cFFFFFFFF"..WindInfo_StandingID[WindInfo.StandingRP]);
		else
			WindInfoRPText:SetText("|cFFFFFF00"..WindInfo.FactionRP.." |cFFFFFFFF: |cFFFFFF00"..WindInfo.RP.." |cFFFFFFFF/|cFFFFFF00 "..WindInfo.MaxRP.." |cFFFFFFFF"..WindInfo_StandingID[WindInfo.StandingRP]);
		end
	end
end