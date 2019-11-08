WindActionBorderSize = { {495, 55}, {255, 95}, {175, 135}, {135, 175}, {95, 255}, {55, 495} }

function WindAction_OnLoad()
	--MainMenuExpBar:Hide()
	--MainMenuBarMaxLevelBar:SetAlpha(0) -- hide the xp bar

	WindCommon_setPoint(MainMenuBar, "BOTTOM", UIParent, "BOTTOM", 0, -1000) -- 8.0 ╨нем ╬х╣й.
	WindActionBody_initConfig()
	--MainMenuBarArtFrame:Hide()
  
  MainMenuBarOverlayFrame:Hide()  --MainMenuBarArtFrameBackground:Hide()
	MainMenuBarLeftEndCap:Hide()
	MainMenuBarRightEndCap:Hide()
	--MainMenuBarArtFrame:SetFrameLevel(MainMenuBarArtFrame:GetParent():GetFrameLevel()+6);
	MainMenuBarArtFrame:SetFrameStrata("BACKGROUND");
	MainMenuBar:SetFrameStrata("BACKGROUND");

	--MicroButtonAndBagsBar.MicroBagBar:Hide()
--	TimerTracker:Hide()
	--StatusTrackingBarManager:Hide()

	--hooksecurefunc("UIParent_ManageFramePosition", WindAction_ManageFramePositions)
  --SpellFlyout.Toggle = nil
end

function WindActionBody_initConfig()
	if (not WindActionBodyConfig) then WindActionBodyConfig = WindActionDefault["Body"]; end
end

function WindActionBody_resetConfig()
	WindActionBodyConfig = WindActionDefault["Body"];
	WindActionBody_refresh();
end

function WindActionBody_refresh()
	--WindAction_ManageFramePositions();
end

function WindActionButton_setAnchor(index, btn)
	if (index == 1) then
		WindCommon_setPoint(getglobal(btn.."2"), "LEFT", btn.."1", "RIGHT", 4, 0)
		WindCommon_setPoint(getglobal(btn.."3"), "LEFT", btn.."2", "RIGHT", 4, 0)
		WindCommon_setPoint(getglobal(btn.."4"), "LEFT", btn.."3", "RIGHT", 4, 0)
		WindCommon_setPoint(getglobal(btn.."5"), "LEFT", btn.."4", "RIGHT", 4, 0)
		WindCommon_setPoint(getglobal(btn.."6"), "LEFT", btn.."5", "RIGHT", 4, 0)
		WindCommon_setPoint(getglobal(btn.."7"), "LEFT", btn.."6", "RIGHT", 4, 0)
		WindCommon_setPoint(getglobal(btn.."8"), "LEFT", btn.."7", "RIGHT", 4, 0)
		WindCommon_setPoint(getglobal(btn.."9"), "LEFT", btn.."8", "RIGHT", 4, 0)
		WindCommon_setPoint(getglobal(btn.."10"), "LEFT", btn.."9", "RIGHT", 4, 0)
		WindCommon_setPoint(getglobal(btn.."11"), "LEFT", btn.."10", "RIGHT", 4, 0)
		WindCommon_setPoint(getglobal(btn.."12"), "LEFT", btn.."11", "RIGHT", 4, 0)
	elseif (index == 2) then
		WindCommon_setPoint(getglobal(btn.."2"), "LEFT", btn.."1", "RIGHT", 4, 0)
		WindCommon_setPoint(getglobal(btn.."3"), "LEFT", btn.."2", "RIGHT", 4, 0)
		WindCommon_setPoint(getglobal(btn.."4"), "LEFT", btn.."3", "RIGHT", 4, 0)
		WindCommon_setPoint(getglobal(btn.."5"), "LEFT", btn.."4", "RIGHT", 4, 0)
		WindCommon_setPoint(getglobal(btn.."6"), "LEFT", btn.."5", "RIGHT", 4, 0)
		WindCommon_setPoint(getglobal(btn.."7"), "TOPLEFT", btn.."1", "BOTTOMLEFT", 0, -4)
		WindCommon_setPoint(getglobal(btn.."8"), "LEFT", btn.."7", "RIGHT", 4, 0)
		WindCommon_setPoint(getglobal(btn.."9"), "LEFT", btn.."8", "RIGHT", 4, 0)
		WindCommon_setPoint(getglobal(btn.."10"), "LEFT", btn.."9", "RIGHT", 4, 0)
		WindCommon_setPoint(getglobal(btn.."11"), "LEFT", btn.."10", "RIGHT", 4, 0)
		WindCommon_setPoint(getglobal(btn.."12"), "LEFT", btn.."11", "RIGHT", 4, 0)
	elseif (index == 3) then
		WindCommon_setPoint(getglobal(btn.."2"), "LEFT", btn.."1", "RIGHT", 4, 0)
		WindCommon_setPoint(getglobal(btn.."3"), "LEFT", btn.."2", "RIGHT", 4, 0)
		WindCommon_setPoint(getglobal(btn.."4"), "LEFT", btn.."3", "RIGHT", 4, 0)
		WindCommon_setPoint(getglobal(btn.."5"), "TOPLEFT", btn.."1", "BOTTOMLEFT", 0, -4)
		WindCommon_setPoint(getglobal(btn.."6"), "LEFT", btn.."5", "RIGHT", 4, 0)
		WindCommon_setPoint(getglobal(btn.."7"), "LEFT", btn.."6", "RIGHT", 4, 0)
		WindCommon_setPoint(getglobal(btn.."8"), "LEFT", btn.."7", "RIGHT", 4, 0)
		WindCommon_setPoint(getglobal(btn.."9"), "TOPLEFT", btn.."5", "BOTTOMLEFT", 0, -4)
		WindCommon_setPoint(getglobal(btn.."10"), "LEFT", btn.."9", "RIGHT", 4, 0)
		WindCommon_setPoint(getglobal(btn.."11"), "LEFT", btn.."10", "RIGHT", 4, 0)
		WindCommon_setPoint(getglobal(btn.."12"), "LEFT", btn.."11", "RIGHT", 4, 0)
	elseif (index == 4) then
		WindCommon_setPoint(getglobal(btn.."2"), "LEFT", btn.."1", "RIGHT", 4, 0)
		WindCommon_setPoint(getglobal(btn.."3"), "LEFT", btn.."2", "RIGHT", 4, 0)
		WindCommon_setPoint(getglobal(btn.."4"), "TOPLEFT", btn.."1", "BOTTOMLEFT", 0, -4)
		WindCommon_setPoint(getglobal(btn.."5"), "LEFT", btn.."4", "RIGHT", 4, 0)
		WindCommon_setPoint(getglobal(btn.."6"), "LEFT", btn.."5", "RIGHT", 4, 0)
		WindCommon_setPoint(getglobal(btn.."7"), "TOPLEFT", btn.."4", "BOTTOMLEFT", 0, -4)
		WindCommon_setPoint(getglobal(btn.."8"), "LEFT", btn.."7", "RIGHT", 4, 0)
		WindCommon_setPoint(getglobal(btn.."9"), "LEFT", btn.."8", "RIGHT", 4, 0)
		WindCommon_setPoint(getglobal(btn.."10"), "TOPLEFT", btn.."7", "BOTTOMLEFT", 0, -4)
		WindCommon_setPoint(getglobal(btn.."11"), "LEFT", btn.."10", "RIGHT", 4, 0)
		WindCommon_setPoint(getglobal(btn.."12"), "LEFT", btn.."11", "RIGHT", 4, 0)
	elseif (index == 5) then
		WindCommon_setPoint(getglobal(btn.."2"), "LEFT", btn.."1", "RIGHT", 4, 0)
		WindCommon_setPoint(getglobal(btn.."3"), "TOPLEFT", btn.."1", "BOTTOMLEFT", 0, -4)
		WindCommon_setPoint(getglobal(btn.."4"), "LEFT", btn.."3", "RIGHT", 4, 0)
		WindCommon_setPoint(getglobal(btn.."5"), "TOPLEFT", btn.."3", "BOTTOMLEFT", 0, -4)
		WindCommon_setPoint(getglobal(btn.."6"), "LEFT", btn.."5", "RIGHT", 4, 0)
		WindCommon_setPoint(getglobal(btn.."7"), "TOPLEFT", btn.."5", "BOTTOMLEFT", 0, -4)
		WindCommon_setPoint(getglobal(btn.."8"), "LEFT", btn.."7", "RIGHT", 4, 0)
		WindCommon_setPoint(getglobal(btn.."9"), "TOPLEFT", btn.."7", "BOTTOMLEFT", 0, -4)
		WindCommon_setPoint(getglobal(btn.."10"), "LEFT", btn.."9", "RIGHT", 4, 0)
		WindCommon_setPoint(getglobal(btn.."11"), "TOPLEFT", btn.."9", "BOTTOMLEFT", 0, -4)
		WindCommon_setPoint(getglobal(btn.."12"), "LEFT", btn.."11", "RIGHT", 4, 0)
	elseif (index == 6) then
		WindCommon_setPoint(getglobal(btn.."2"), "TOPLEFT", btn.."1", "BOTTOMLEFT", 0, -4)
		WindCommon_setPoint(getglobal(btn.."3"), "TOPLEFT", btn.."2", "BOTTOMLEFT", 0, -4)
		WindCommon_setPoint(getglobal(btn.."4"), "TOPLEFT", btn.."3", "BOTTOMLEFT", 0, -4)
		WindCommon_setPoint(getglobal(btn.."5"), "TOPLEFT", btn.."4", "BOTTOMLEFT", 0, -4)
		WindCommon_setPoint(getglobal(btn.."6"), "TOPLEFT", btn.."5", "BOTTOMLEFT", 0, -4)
		WindCommon_setPoint(getglobal(btn.."7"), "TOPLEFT", btn.."6", "BOTTOMLEFT", 0, -4)
		WindCommon_setPoint(getglobal(btn.."8"), "TOPLEFT", btn.."7", "BOTTOMLEFT", 0, -4)
		WindCommon_setPoint(getglobal(btn.."9"), "TOPLEFT", btn.."8", "BOTTOMLEFT", 0, -4)
		WindCommon_setPoint(getglobal(btn.."10"), "TOPLEFT", btn.."9", "BOTTOMLEFT", 0, -4)
		WindCommon_setPoint(getglobal(btn.."11"), "TOPLEFT", btn.."10", "BOTTOMLEFT", 0, -4)
		WindCommon_setPoint(getglobal(btn.."12"), "TOPLEFT", btn.."11", "BOTTOMLEFT", 0, -4)
	end
end

function WindAction_ManageFramePositions()

	--if (false) then
	--print("WindAction_ManageFramePositions")
	-- Update the variable with the happy magic number.
	UpdateMenuBarTop();

	CONTAINER_OFFSET_X = WindActionBodyConfig[5] or 0;

	-- Custom positioning not handled by the loop
	-- Update shapeshift bar appearance
	StanceBarLeft:Hide();
	StanceBarRight:Hide();
	StanceBarMiddle:Hide();
	for i=1, NUM_STANCE_SLOTS do
		_G["StanceButton"..i]:GetNormalTexture():SetWidth(60);
		_G["StanceButton"..i]:GetNormalTexture():SetHeight(60);
	end

	-- Set battlefield minimap position
	if ( BattlefieldMinimapTab and not BattlefieldMinimapTab:IsUserPlaced() ) then
		BattlefieldMinimapTab:SetPoint("TOP", "UIParent", "TOP", 0, -100);
	end

	-- Setup y anchors
	local anchorY = 0;
	-- Capture bars
	if ( NUM_EXTENDED_UI_FRAMES ) then
		local captureBar;
		local numCaptureBars = 0;
		for i=1, NUM_EXTENDED_UI_FRAMES do
			captureBar = getglobal("WorldStateCaptureBar"..i);
			if ( captureBar and captureBar:IsShown() ) then
				captureBar:SetPoint("TOPRIGHT", MinimapCluster, "BOTTOMRIGHT", -CONTAINER_OFFSET_X, anchorY);
				anchorY = anchorY - captureBar:GetHeight();
			end
		end
	end
	-- Quest timers
	--QuestTimerFrame:SetPoint("TOPRIGHT", "MinimapCluster", "BOTTOMRIGHT", -CONTAINER_OFFSET_X, anchorY);
	--if ( QuestTimerFrame:IsShown() ) then
	--	anchorY = anchorY - QuestTimerFrame:GetHeight();
	--end
	-- Setup durability offset
	if ( DurabilityFrame ) then
		local durabilityOffset = 0;
		if ( DurabilityShield:IsShown() or DurabilityOffWeapon:IsShown() or DurabilityRanged:IsShown() ) then
			durabilityOffset = 20;
		end
		DurabilityFrame:SetPoint("TOPRIGHT", "MinimapCluster", "BOTTOMRIGHT", -CONTAINER_OFFSET_X-durabilityOffset, anchorY);
		if ( DurabilityFrame:IsShown() ) then
			anchorY = anchorY - DurabilityFrame:GetHeight();
		end
	end

	--QuestWatchFrame:SetPoint("TOPRIGHT", "MinimapCluster", "BOTTOMRIGHT", -CONTAINER_OFFSET_X, anchorY);

	-- Update chat dock since the dock could have moved
	FCF_DockUpdate();
	--updateContainerFrameAnchors();
	--end

end

--hooksecurefunc("UIParent_ManageFramePositions", function()
--	local r1, r2, r3, r4, r5 = ObjectiveTrackerFrame:GetPoint();
--	--ObjectiveTrackerFrame:ClearAllPoints();
--	ObjectiveTrackerFrame:SetPoint(r1, r2, r3, -5, r5);
--end)

--[[
local origsetpoint = getmetatable(VehicleSeatIndicator).__index.SetPoint
local function move(self)
   self:ClearAllPoints()
   origsetpoint(self, "TOPRIGHT", MinimapCluster, "BOTTOMRIGHT", 0, 0)
end
hooksecurefunc(VehicleSeatIndicator, "SetPoint", move)
move(VehicleSeatIndicator)
]]
--local WindHookMultiActionBar_Update = MultiActionBar_Update

--hooksecurefunc("MultiActionBar_Update", function()
--	if not InCombatLockdown() and UnitOnTaxi("player") then
--    WindHookMultiActionBar_Update();
--	end
--	WindActionLeft_setScale();
--	WindActionRight_setScale();
--end)
--[[
hooksecurefunc("MultiActionBar_Update", function()

  if not InCombatLockdown() then
    if MultiBarLeft:IsShown() then
      WindActionLeft:Show();
    else
      WindActionLeft:Hide();
    end
    if MultiBarRight:IsShown() then
      WindActionRight:Show();
    else
      WindActionRight:Hide();
    end
    if MultiBarBottomLeft:IsShown() then
      WindActionBottomLeft:Show();
    else
      WindActionBottomLeft:Hide();
    end
    if MultiBarBottomRight:IsShown() then
      WindActionBottomRight:Show();
    else
      WindActionBottomRight:Hide();
    end
  end

	WindActionLeft_setScale();
	WindActionRight_setScale();
end)
]]