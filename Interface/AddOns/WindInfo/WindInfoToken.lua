function WindInfoToken_OnLoad(self)
	--WindInfoTokenSmall:SetAllPoints(WindInfoToken);
	WindInfoToken:RegisterEvent("VARIABLES_LOADED");
end

function WindInfoToken_OnUpdate(self)

  local Tokens = {}
  Tokens[1] = WindInfoTokenToken1
  Tokens[2] = WindInfoTokenToken2
  Tokens[3] = WindInfoTokenToken3
  local TokenCount = 0
  	for i=1, MAX_WATCHED_TOKENS do
    local name, count, icon, currencyID = GetBackpackCurrencyInfo(i);
      if name ~= nil then
        TokenCount = TokenCount + 1
      end
    end
    WindCommon_setPoint(WindInfoTokenToken0, "LEFT", "WindInfoToken", "LEFT", -10, 0);
  	for i=1, MAX_WATCHED_TOKENS do
      local index = i
  		local watchButton = Tokens[index];
  		local name, count, icon, currencyID = GetBackpackCurrencyInfo(index);

  		if name then
  			getglobal("WindInfoTokenToken".. index .. "Icon"):SetTexture(icon);
	
        WindInfoToken_TextLen(getglobal("WindInfoTokenToken".. index), index, count, TokenCount);

  			local currencyText = BreakUpLargeNumbers(count);
  			if strlenutf8(currencyText) > 5 then
  				currencyText = AbbreviateNumbers(count);
  			end


  			watchButton.count:SetText(currencyText);
  			watchButton.currencyID = currencyID;
  			watchButton:Show();

  		else
  			watchButton:Hide();
  		end
  	end
end

function WindInfoToken_TextLen(frame, id, count, TokenCount)
  local left = 0
    if count < 10 then
      left = left + 20
    elseif count < 100 then
      left = left + 30
    elseif count < 1000 then
      left = left + 40
    else
      left = left + 45
    end
    
  if TokenCount == 1 then
    if id == 1 then
      left = left + 50
    end
  elseif TokenCount == 2 then
    if id == 1 then
      left = left + 10
    end
  end
  WindCommon_setPoint(frame, "LEFT", getglobal("WindInfoTokenToken".. id - 1), "LEFT", left, 0);
end

function WindInfoToken_OnEvent(self, event, ...)
	if (event == "VARIABLES_LOADED") then
		WindInfoToken_initConfig();
		WindInfoToken_OnUpdate(self);
		WindInfoToken_setPoint();
		WindInfoToken_setScale();
		WindInfoToken_setSize();
		WindInfoToken_setView();
		WindInfoToken_setMouse();
	end
end

function WindInfoToken_initConfig()
	if (not WindInfoTokenConfig) then WindInfoTokenConfig = WindInfoDefault["Token"]; end
end

function WindInfoToken_resetConfig()
	WindInfoTokenConfig = WindInfoDefault["Token"];
end

function WindInfoToken_setPoint()
	WindCommon_setPoint(WindInfoToken, WindInfoTokenConfig[1], "WindInfo", WindInfoTokenConfig[1], WindInfoTokenConfig[2], WindInfoTokenConfig[3]);
end

function WindInfoToken_setScale()
	WindInfoToken:SetScale(WindInfoTokenConfig[4]);
end

function WindInfoToken_setSize()
	WindCommon_setSize(WindInfoToken, WindInfoTokenConfig[5], WindInfoTokenConfig[6]);
end

function WindInfoToken_setView()
	if (WindInfoTokenConfig[7]) then WindInfoToken:Show();
	else WindInfoToken:Hide(); end
end

function WindInfoToken_setMouse()
	if (WindInfoTokenConfig[8]) then WindInfoToken:Show();
	else WindInfoToken:Hide(); end
end
