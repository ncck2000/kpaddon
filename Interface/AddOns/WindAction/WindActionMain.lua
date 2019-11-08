function WindActionMain_OnLoad(self)

	WindActionMain:SetParent(MainMenuBar)
	WindActionMain:SetFrameStrata("MEDIUM");
	WindActionMain:SetFrameLevel(0)

	self:RegisterEvent("VARIABLES_LOADED");

	--self:RegisterEvent("UPDATE_OVERRIDE_ACTIONBAR");
end

function WindActionMain_OnEvent(self, event, ...)
	local arg1, arg2 = ...;
	if (event == "VARIABLES_LOADED") then
		WindActionMain_initConfig();
		WindActionMain_refresh();
		WindActionMain_SetDrawLayer(true);
--	elseif (event == "UPDATE_OVERRIDE_ACTIONBAR") then
--		WindActionMain_SetDrawLayer(HasOverrideActionBar() == false);
   -- WindCommon_setPoint(MainMenuBar, "BOTTOM", UIParent, "BOTTOM", 0, -1000)  -- 임시 수정 8.0

	end
end

function WindActionMain_initConfig()
	if (not WindActionMainConfig) then WindActionMainConfig = WindActionDefault["Main"]; end
	if (IsAddOnLoaded("WindConfig")) then
		WindActionConfigMain_show();
		WindActionConfigMain_setColor(color);
	end
end

function WindActionMain_resetConfig()
	WindActionMainConfig = WindActionDefault["Main"];

	WindActionMain_refresh();

	if (IsAddOnLoaded("WindConfig")) then
		WindActionConfigMain_show();
		WindActionConfigMain_setColor(color);
	end
end

function WindActionMain_refresh()
	WindActionMain_setPointAndSize();
	WindActionMain_setScale();
	WindActionMain_setBorder();
end

function WindActionMain_setPointAndSize()
	local index = WindActionMainConfig[5];
	WindCommon_setSize(WindActionMain, WindActionBorderSize[index][1], WindActionBorderSize[index][2]);
	WindCommon_setPoint(WindActionMain, WindActionMainConfig[1], UIParent, WindActionMainConfig[1], WindActionMainConfig[2], WindActionMainConfig[3]);
	-- 매인액션버튼 위치 설정
	WindCommon_setPoint(ActionButton1, "TOPLEFT", WindActionMain, "TOPLEFT", 10, -9);
	WindActionButton_setAnchor(index, "ActionButton");
	-- 보너스액션버튼 위치 설정
	--WindCommon_setPoint(BonusActionButton1, "TOPLEFT", WindActionMain, "TOPLEFT", 10, -9);
	--WindActionButton_setAnchor(index, "BonusActionButton");
end

function WindActionMain_setScale()
	WindActionMain:SetScale(WindActionMainConfig[4]);
	for i=1, 12 do
		getglobal("ActionButton"..i):SetScale(WindActionMainConfig[4]);
		--getglobal("BonusActionButton"..i):SetScale(WindActionMainConfig[4]);

		-- 스케일조정시 frame strata를 조정한다.
		getglobal("ActionButton"..i):SetFrameStrata("HIGH");
		--getglobal("BonusActionButton"..i):SetFrameStrata("LOW"); --프레임레벨 설정(BACKGROUND,LOW,MEDIUM,HIGH,DIALOG,FULLSCREEN,FULLSCREEN_DIALOG,TOOLTIP)
	end
end

function WindActionMain_setBorder()
	if (not WindActionMainConfig or WindActionMainConfig[6]) then
		WindActionMain:SetBackdrop(WindCommon_ColorBorder);
		WindActionMain_setColor();
	else
		WindActionMain:SetBackdrop(nil);
	end
end

function WindActionMain_setColor()
	WindActionMain:SetBackdropBorderColor(WindActionMainConfig[7][1].r, WindActionMainConfig[7][1].g, WindActionMainConfig[7][1].b, WindActionMainConfig[7][1].a);
	WindActionMain:SetBackdropColor(WindActionMainConfig[7][2].r, WindActionMainConfig[7][2].g, WindActionMainConfig[7][2].b, WindActionMainConfig[7][2].a);
end

function WindActionMain_resetColor()
	WindActionMainConfig[7] = WindActionDefault["Main"][7];
	WindActionMain_setColor();
end

function WindActionMain_SetDrawLayer(isShow)
	if (isShow and (not WindActionMainConfig or WindActionMainConfig[6])) then
		if not InCombatLockdown() then
			WindActionMain:Show();
		end
	else
		WindActionMain:Hide();
	end
end


--MainMenuBar:SetScript("OnShow", function(...)
--end)
--MainMenuBar:HookScript("OnShow", function()
--end)

-- ToolsActionBar에서 인용하였습니다.
--hooksecurefunc("ShowBonusActionBar", function()
--	for i = 1, 12 do
--		getglobal("ActionButton"..i):SetAlpha(0)
--		getglobal("ActionButton"..i):RegisterForClicks("")
--		getglobal("ActionButton"..i):RegisterForDrag("")
--	end
--end)
--hooksecurefunc("HideBonusActionBar", function()
--	for i = 1, 12 do
--		getglobal("ActionButton"..i):SetAlpha(1)
--		getglobal("ActionButton"..i):RegisterForClicks("AnyUp")
--		getglobal("ActionButton"..i):RegisterForDrag("LeftButton", "RightButton")
--	end
--end)