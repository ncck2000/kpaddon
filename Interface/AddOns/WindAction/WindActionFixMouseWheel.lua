WindActionMain:SetScript("OnMouseWheel", function(self, delta)
	if not InCombatLockdown() and not IsShiftKeyDown() then
	--	WindActionDefault["Main"][4] = WindActionDefault["Main"][4] + (delta * 0.01)
		WindActionMainConfig[4] = WindActionMainConfig[4] + (delta * 0.01)
		WindActionBottomLeftConfig[4] = WindActionMainConfig[4]
		WindActionBottomRightConfig[4] = WindActionMainConfig[4]
		WindActionLeftConfig[4] = WindActionMainConfig[4]
		WindActionRightConfig[4] = WindActionMainConfig[4]
		WindActionPetConfig[4] = WindActionMainConfig[4]
		WindActionShiftConfig[4] = WindActionMainConfig[4]
		WindActionBagConfig[4] = WindActionMainConfig[4]
		WindActionMenuConfig[4] = WindActionMainConfig[4]
		WindActionScrollConfig[4] = WindActionMainConfig[4]
		WindActionShiftConfig[4] = WindActionMainConfig[4]
		WindActionVehicleLeaveConfig[4] = WindActionMainConfig[4]
		
		local containerShowing = false;
		for i=1, NUM_CONTAINER_FRAMES, 1 do
			local frame = getglobal("ContainerFrame"..i);
			if frame:IsShown() then containerShowing = true; break; end
		end
		if WindInfo and WindInfo:IsShown() and WindBag1 and containerShowing and WindBBConfigAll then
			local left, bottom, width, height = WindInfo:GetRect()
			WindBBConfigAll[2] = (bottom + height + 7) * WindActionMainConfig[4]
			WindBB_updateContainerFrameAnchors()
		end
		--DEFAULT_CHAT_FRAME:AddMessage("WindAction Scale " .. WindActionMainConfig[4])
		
		WindActionBody_refresh();
		WindActionMain_refresh();			
		WindActionMenu_refresh();		
		WindActionBag_refresh();
		WindActionBottomLeft_refresh();
		WindActionBottomRight_refresh();
		WindActionLeft_refresh();
		WindActionRight_refresh();
		WindActionPet_refresh();
		WindActionScroll_refresh();
		WindActionShift_refresh();
		WindActionVehicleLeave_refresh();
		
		if (WindInfoDefault) then
			WindInfoBodyConfig[4] = WindActionMainConfig[4]

			WindInfoBag_refresh();
			WindInfoTime_refresh();
			WindInfoPerf_refresh();
			WindInfoBody_refresh();
			WindInfoXP_refresh();
			WindInfoRP_refresh();
			WindInfoMouse_HidehView();
		end
	end
end)