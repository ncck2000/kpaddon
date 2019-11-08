MoneyTypeInfo["PLAYER"] = { 
    UpdateFunc = function(self) 
        local money = (GetMoney() - GetCursorMoney() - GetPlayerTradeMoney()); 
         return money; 
    end, 
  
    PickupFunc = function(self, amount) 
        PickupPlayerMoney(amount); 
    end, 
  
    DropFunc = function(self) 
        DropCursorMoney(); 
    end, 
  
    collapse = 1, 
    canPickup = 1, 
    showSmallerCoins = "Backpack"
}; 

function WindInfoMoney_OnLoad(self)
	WindInfoMoneySmall:SetAllPoints(WindInfoMoney);
	WindInfoMoney:RegisterEvent("VARIABLES_LOADED");
	WindInfoMoney:RegisterEvent("PLAYER_MONEY");
	MoneyFrame_Update("WindInfoMoneySmall", MoneyTypeInfo["PLAYER"].UpdateFunc());
	if (WindInfoMoney_NeedReload()) then WindTimer["WindInfoMoney"] = 4; end
end

function WindInfoMoney_OnShow(self)
  WindInfoMoney_NeedReload();
end

function WindInfoMoney_NeedReload()
		 

	local money = GetMoney() 
  local gold = floor(money / (COPPER_PER_SILVER * SILVER_PER_GOLD)); 
  --local goldDisplay = BreakUpLargeNumbers(gold); 
  --local silver = floor((money - (gold * COPPER_PER_SILVER * SILVER_PER_GOLD)) / COPPER_PER_SILVER); 
  local copper = mod(money, COPPER_PER_SILVER); 
  
  local left = 0
  local left2 = 0
	
    if gold > 10000 then
      WindInfoMoneySmallGoldButton:Show();
      WindInfoMoneySmallSilverButton:Hide();
      WindInfoMoneySmallCopperButton:Hide();
      if gold < 10000000 then
        left = -20
      end
    elseif gold > 0 then
      WindInfoMoneySmallGoldButton:Show();
      WindInfoMoneySmallSilverButton:Show();
      WindInfoMoneySmallCopperButton:Show();
      left = -10
      left2 = 15
    else
      WindInfoMoneySmallGoldButton:Hide();
      WindInfoMoneySmallSilverButton:Show();
      WindInfoMoneySmallCopperButton:Show();
    end
    
    WindCommon_setPoint(WindInfoMoneySmallGoldButton, "LEFT", "WindInfoMoneySmall", "LEFT", left, 0);
    WindCommon_setPoint(WindInfoMoneySmallSilverButton, "LEFT", "WindInfoMoneySmall", "LEFT", left2, 0);
    
	if (WindInfoMoneySmallGoldButton
		and WindInfoMoneySmallSilverButton
		and copper > 0 ) then
		--and tonumber(WindInfoMoneySmallCopperButtonText:GetText()) > 0 ) then
		return false;
	else 
    return true; 
	end
	
end

function WindInfoMoney_loop()
	MoneyFrame_Update("WindInfoMoneySmall", MoneyTypeInfo["PLAYER"].UpdateFunc());
	if (WindInfoMoney_NeedReload()) then WindTimer["WindInfoMoney"] = 4;
	else WindTimer["WindInfoMoney"] = nil; end
end

function WindInfoMoney_OnEvent(self, event, ...)
	if (event == "VARIABLES_LOADED") then
		WindInfoMoney_initConfig();
		WindInfoMoney_setPoint();
		WindInfoMoney_setScale();
		WindInfoMoney_setSize();
		WindInfoMoney_setView();
		WindInfoMoney_setMouse();
  elseif (event == "PLAYER_MONEY") then
		WindInfoMoney_NeedReload();
	end
end

function WindInfoMoney_initConfig()
	if (not WindInfoMoneyConfig) then WindInfoMoneyConfig = WindInfoDefault["Money"]; end
end

function WindInfoMoney_resetConfig()
	WindInfoMoneyConfig = WindInfoDefault["Money"];
end

function WindInfoMoney_setPoint()
	WindCommon_setPoint(WindInfoMoney, WindInfoMoneyConfig[1], "WindInfo", WindInfoMoneyConfig[1], WindInfoMoneyConfig[2], WindInfoMoneyConfig[3]);
end

function WindInfoMoney_setScale()
	WindInfoMoney:SetScale(WindInfoMoneyConfig[4]);
end

function WindInfoMoney_setSize()
	WindCommon_setSize(WindInfoMoney, WindInfoMoneyConfig[5], WindInfoMoneyConfig[6]);
end

function WindInfoMoney_setView()
	if (WindInfoMoneyConfig[7]) then WindInfoMoney:Show();
	else WindInfoMoney:Hide(); end
end

function WindInfoMoney_setMouse()
	if (WindInfoMoneyConfig[8]) then WindInfoMoney:Show();
	else WindInfoMoney:Hide(); end
end