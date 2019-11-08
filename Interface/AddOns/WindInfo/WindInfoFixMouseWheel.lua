-- WindInfo만 따로 쓸 경우 대비용
WindInfo:SetScript("OnMouseWheel", function(self, delta)
	if not InCombatLockdown() then	
		WindInfoBodyConfig[4] = WindInfoBodyConfig[4] + (delta * 0.01)
	--	DEFAULT_CHAT_FRAME:AddMessage("WindInfo Scale " .. WindInfoBodyConfig[4])

		WindInfoBag_refresh();
		WindInfoTime_refresh();
		--WindInfoTick_resetConfig();
		WindInfoPerf_refresh();
		--WindInfoMoney_resetConfig();
		--WindInfoDura_resetConfig();
		--WindInfoDate_resetConfig();
		WindInfoBody_refresh();
		WindInfoXP_refresh();
		WindInfoRP_refresh();
		WindInfoMouse_HidehView();
	end
end)