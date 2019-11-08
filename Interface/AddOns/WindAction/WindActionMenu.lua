WindActionMenuSize = {
	{240, 55},
	{130, 90},
	{80, 165},
	{55, 310}
}

function WindActionMenu_OnLoad(self)		

	self:RegisterEvent("VARIABLES_LOADED");
TalentMicroButton:Show();
end

function WindActionMenu_OnEvent(self, event, ...)

	if (event == "VARIABLES_LOADED") then	
		WindActionMenu_OnShow();
	end
end

function WindActionMenu_OnShow()

	WindCommon_setParentPoint(CharacterMicroButton, WindActionMenu, "TOPLEFT", WindActionMenu, "TOPLEFT", 11, 12);

	--check the buttons in the MICRO_BUTTONS table
	for _, buttonName in pairs(MICRO_BUTTONS) do
		local button = _G[buttonName]
		if button then
			button:SetParent(WindActionMenu)
		end
	end
			
	WindActionMenu_initConfig();
	WindActionMenu_refresh();

end

function WindActionMenu_OnHide()
	WindActionMenu:Hide();
end

function WindActionMenu_initConfig()
	if (not WindActionMenuConfig) then WindActionMenuConfig = WindActionDefault["Menu"]; end

	if (IsAddOnLoaded("WindConfig")) then 
		WindActionConfigMenu_show();
		WindActionConfigMenu_setColor(color); 
	end
end

function WindActionMenu_resetConfig()
	WindActionMenuConfig = WindActionDefault["Menu"];

	WindActionMenu_refresh();
	
	if (IsAddOnLoaded("WindConfig")) then 
		WindActionConfigMenu_show();
		WindActionConfigMenu_setColor(color); 
	end
end

function WindActionMenu_refresh()
	WindActionMenu_setPoint();
	WindActionMenu_setScale();
	WindActionMenu_setSize();
	WindActionMenu_setBorder();
	WindActionMenu_setView();
end

function WindActionMenu_setPoint()
	WindCommon_setPoint(WindActionMenu, WindActionMenuConfig[1], UIParent, WindActionMenuConfig[1], WindActionMenuConfig[2], WindActionMenuConfig[3]);
end

function WindActionMenu_setScale()
	WindActionMenu:SetScale(WindActionMenuConfig[4]);
end

function WindActionMenu_setSize()
	local index = WindActionMenuConfig[5];
	WindCommon_setSize(WindActionMenu, WindActionMenuSize[index][1], WindActionMenuSize[index][2]);
	WindActionMenu_setAnchor(index);
end

local moving2
hooksecurefunc(QuestLogMicroButton, "SetPoint", function(self)
  if moving2 then
  return
  end

  moving2 = true
  if (WindActionMenuConfig) then
    local index = 1
    index = WindActionMenuConfig[5] 
    if (index == 3 or index == 4) then
      self:SetMovable(true)
      self:SetUserPlaced(true)
      self:ClearAllPoints()
      self:SetPoint("TOPLEFT", TalentMicroButton, "BOTTOMLEFT", 0, 22);
      self:SetMovable(false)
      moving2 = nil
    end
  end
end)

function WindActionMenu_setAnchor(index)

	--micro menu button objects
	local MICRO_BUTTONS = MICRO_BUTTONS
	local buttonList = {}
	--check the buttons in the MICRO_BUTTONS table
	--local find = false
	QuestLogMicroButton:SetParent(WindActionMenu)

	for _, buttonName in pairs(MICRO_BUTTONS) do
		local button = _G[buttonName]
		
		if button then  -- and button:IsShown()
		--	if button == QuestLogMicroButton then
    --    else
          tinsert(buttonList, button)
		--	end
		end
	end

 -- tinsert(buttonList, QuestLogMicroButton)
  
	local NUM_MICROBUTTONS = # buttonList
	if (index == 1) then
	
		local preButton = nil;
		for _, button in pairs(buttonList) do
			if (preButton ~= nil) then
				WindCommon_setPoint(button, "LEFT", preButton, "RIGHT", -2, 0);
			end
			preButton = button;
		end
		
	elseif (index == 2) then
	
		local preButton = nil;
		local headButton = nil;
		local count = 0;
		for _, button in pairs(buttonList) do
			count = count + 1
			if (headButton == nil) then
				headButton = button
			end
			if (preButton ~= nil) then
				WindCommon_setPoint(button, "LEFT", preButton, "RIGHT", -2, 0);
			end
			if (floor(NUM_MICROBUTTONS / 2) == count - 1) then
				WindCommon_setPoint(button, "TOPLEFT", headButton, "BOTTOMLEFT", 0, 22);
			end
			preButton = button;
		end
		
	elseif (index == 3) then
	
		local preButton = nil;
		local headButton = nil;
		local count = 0;
		for _, button in pairs(buttonList) do
			count = count + 1
			if (headButton == nil) then
				headButton = button
			end
			if (preButton == nil) then
			
			else
				WindCommon_setPoint(button, "TOPLEFT", preButton, "BOTTOMLEFT", 0, 22);
			end
			if (floor(NUM_MICROBUTTONS / 2) == count - 1) then
				WindCommon_setPoint(button, "LEFT", headButton, "RIGHT", -2, 0);
			end
		
			preButton = button;
		end
		
	elseif (index == 4) then
	
		local preButton = nil;
		for _, button in pairs(buttonList) do
			if (preButton == nil) then
			
			else
				WindCommon_setPoint(button, "TOPLEFT", preButton, "BOTTOMLEFT", 0, 22);
			end
			preButton = button;
		end
		
	end
end

function WindActionMenu_setBorder()
	if (not WindActionMenuConfig or WindActionMenuConfig[6]) then 
		WindActionMenu:SetBackdrop(WindCommon_ColorBorder);
		WindActionMenu_setColor();
	else WindActionMenu:SetBackdrop(nil); end
end

function WindActionMenu_setColor()
	WindActionMenu:SetBackdropBorderColor(WindActionMenuConfig[7][1].r, WindActionMenuConfig[7][1].g, WindActionMenuConfig[7][1].b, WindActionMenuConfig[7][1].a);
	WindActionMenu:SetBackdropColor(WindActionMenuConfig[7][2].r, WindActionMenuConfig[7][2].g, WindActionMenuConfig[7][2].b, WindActionMenuConfig[7][2].a);
end

function WindActionMenu_resetColor()
	WindActionMenuConfig[7] = WindActionDefault["Menu"][7];

	WindActionMenu_setColor();
end

function WindActionMenu_setView()
	if (not WindActionMenuConfig or WindActionMenuConfig[8]) then 
		WindActionMenu:Show();
	else 
		WindActionMenu:Hide(); 
	end
end

function WindActionMenu_UpdateTalentButton()
	if ( UnitLevel("player") < 10 ) then 
		--TalentMicroButton:Hide();
	else 
		TalentMicroButton:Show(); 
	end
end

MainMenuBar:HookScript("OnShow", function(self)
  WindActionMenu_OnShow();
end)

MainMenuBar:HookScript("OnHide", function(self)
  WindActionMenu_OnHide();
end)
