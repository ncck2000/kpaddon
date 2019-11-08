function WindActionVehicleLeave_OnLoad(self)
	MainMenuBarVehicleLeaveButton:SetScript("OnShow", function()
		WindActionVehicleLeave_setPoint()
	end);
	
	self:RegisterEvent("VARIABLES_LOADED");
end

function WindActionVehicleLeave_OnShow()
end

function WindActionVehicleLeave_OnHide()
end

function WindActionVehicleLeave_OnEvent(self, event, ...)
	local arg1, arg2 = ...;
	if (event == "VARIABLES_LOADED") then
		WindActionVehicleLeave_initConfig();
		WindActionVehicleLeave_refresh();
	end
end

function WindActionVehicleLeave_initConfig()
	if (not WindActionVehicleLeaveConfig) then WindActionVehicleLeaveConfig = WindActionDefault["VehicleLeave"]; end

	if (IsAddOnLoaded("WindConfig")) then 
		WindActionConfigVehicleLeave_show();
	end
end

function WindActionVehicleLeave_resetConfig()
	WindActionVehicleLeaveConfig = WindActionDefault["VehicleLeave"];

	WindActionVehicleLeave_refresh();
	
	if (IsAddOnLoaded("WindConfig")) then 
		WindActionConfigVehicleLeave_show();
	end
end

function WindActionVehicleLeave_refresh()
	WindActionVehicleLeave_setPoint();
	WindActionVehicleLeave_setScale();
end

function WindActionVehicleLeave_setPoint()
	MainMenuBarVehicleLeaveButton:ClearAllPoints();
	MainMenuBarVehicleLeaveButton:SetPoint(WindActionVehicleLeaveConfig[1], UIParent, WindActionVehicleLeaveConfig[1], WindActionVehicleLeaveConfig[2], WindActionVehicleLeaveConfig[3])
end

function WindActionVehicleLeave_setScale()
	MainMenuBarVehicleLeaveButton:SetScale(WindActionVehicleLeaveConfig[4]);
end

function WindActionVehicleLeave_resetColor()
	WindActionVehicleLeaveConfig[7] = WindActionDefault["VehicleLeave"][7];
end