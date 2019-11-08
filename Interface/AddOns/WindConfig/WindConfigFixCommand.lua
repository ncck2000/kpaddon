SlashCmdList.WindConfigCOMMAND = 
function () 
	if WindConfig then
		if WindConfig:IsShown() then
			WindConfig:Hide();
		else
			WindConfig:Show();
		end
	end
end

SLASH_WindConfigCOMMAND1 = "/windconfig"
