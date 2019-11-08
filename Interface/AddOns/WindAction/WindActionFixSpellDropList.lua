
local SPELLFLYOUT_DEFAULT_SPACING = 4;
local SPELLFLYOUT_INITIAL_SPACING = 7;
local SPELLFLYOUT_FINAL_SPACING = 4;

hooksecurefunc(SpellFlyout, "Toggle", function (self, flyoutID, parent, direction, distance, isActionBar)

	if InCombatLockdown() then
		return;
	end
	
	if (self:IsShown() and self:GetParent() == parent) == false then
		return;
	end
	
	local _, _, numSlots, isKnown = GetFlyoutInfo(flyoutID);
	local actionBar = parent:GetParent();
	
	-- Make sure this flyout is known
	if (not isKnown or numSlots == 0) then
		return;
	end
	
	if (not direction or not (actionBar == MultiBarRight or actionBar == MultiBarLeft)) then
		return;
	end
	
	-- Update all spell buttons for this flyout
	local prevButton = nil;
	local numButtons = 0;
	for i=1, numSlots do
		local spellID, isKnown = GetFlyoutSlotInfo(flyoutID, i);
		local visible = true;
		
		-- Ignore Call Pet spells if there isn't a pet in that slot
		local petIndex, petName = GetCallPetSpellInfo(spellID);
		if (isActionBar and petIndex and (not petName or petName == "")) then
			visible = false;
		end
		
		if (isKnown and visible) then
			local button = _G["SpellFlyoutButton"..numButtons+1];
			if (button) then
				button:ClearAllPoints();
				if (prevButton) then
					button:SetPoint("BOTTOM", prevButton, "TOP", 0, SPELLFLYOUT_DEFAULT_SPACING);
				else
					button:SetPoint("BOTTOM", 0, SPELLFLYOUT_INITIAL_SPACING);
				end
				
				prevButton = button;
				numButtons = numButtons+1;
			end

		end
	end

	if (numButtons > 0) then
		-- Show the flyout
		self:SetFrameStrata("DIALOG");
		self:ClearAllPoints();
		
		if (not distance) then
			distance = 0;
		end
		
		self.BgEnd:ClearAllPoints();
		self:SetPoint("BOTTOM", parent, "TOP", 0, 0);
		self.BgEnd:SetPoint("TOP");
		SetClampedTextureRotation2(self.BgEnd, 0);
		self.HorizBg:Hide();
		self.VertBg:Show();
		self.VertBg:ClearAllPoints();
		self.VertBg:SetPoint("TOP", self.BgEnd, "BOTTOM");
		self.VertBg:SetPoint("BOTTOM", 0, distance);
		
		self:SetWidth(prevButton:GetWidth());
		self:SetHeight((prevButton:GetHeight()+SPELLFLYOUT_DEFAULT_SPACING) * numButtons - SPELLFLYOUT_DEFAULT_SPACING + SPELLFLYOUT_INITIAL_SPACING + SPELLFLYOUT_FINAL_SPACING);

		self:SetBorderColor(0.7, 0.7, 0.7);
		
		--self:Show();
	end

end)

hooksecurefunc('ActionButton_UpdateFlyout', function (self)

	if (self:GetParent() == MultiBarRight or self:GetParent() == MultiBarLeft) then
		local actionType, flyoutId = GetActionInfo(self.action);
		if (actionType == "flyout") then
			-- Update border and determine arrow position
			local arrowDistance;
			if ((SpellFlyout and SpellFlyout:IsShown() and SpellFlyout:GetParent() == self) or GetMouseFocus() == self) then
				self.FlyoutBorder:Show();
				self.FlyoutBorderShadow:Show();
				arrowDistance = 5;
			else
				self.FlyoutBorder:Hide();
				self.FlyoutBorderShadow:Hide();
				arrowDistance = 2;
			end
			
			-- Update arrow
			self.FlyoutArrow:Show();
			self.FlyoutArrow:ClearAllPoints();
			self.FlyoutArrow:SetPoint("TOP", self, "TOP", 0, arrowDistance);
			SetClampedTextureRotation2(self.FlyoutArrow, 0);
		else
			self.FlyoutBorder:Hide();
			self.FlyoutBorderShadow:Hide();
			self.FlyoutArrow:Hide();
		end
	end
end)

function SetClampedTextureRotation2(texture, rotationDegrees)
	if (rotationDegrees ~= 0 and rotationDegrees ~= 90 and rotationDegrees ~= 180 and rotationDegrees ~= 270) then
		error("SetRotation: rotationDegrees must be 0, 90, 180, or 270");
		return;
	end
	
	if not (texture.rotationDegrees) then
		texture.origTexCoords = {texture:GetTexCoord()};
		texture.origWidth = texture:GetWidth();
		texture.origHeight = texture:GetHeight();
	end
	
	if (texture.rotationDegrees == rotationDegrees) then
		return;
	end

	--texture.rotationDegrees = rotationDegrees;
	
	if (rotationDegrees == 0 or rotationDegrees == 180) then
		texture:SetWidth(texture.origWidth);
		texture:SetHeight(texture.origHeight);
	else
		texture:SetWidth(texture.origHeight);
		texture:SetHeight(texture.origWidth);
	end
	
	if (rotationDegrees == 0) then
		texture:SetTexCoord( texture.origTexCoords[1], texture.origTexCoords[2],
											texture.origTexCoords[3], texture.origTexCoords[4],
											texture.origTexCoords[5], texture.origTexCoords[6],
											texture.origTexCoords[7], texture.origTexCoords[8] );
	elseif (rotationDegrees == 90) then
		texture:SetTexCoord( texture.origTexCoords[3], texture.origTexCoords[4],
											texture.origTexCoords[7], texture.origTexCoords[8],
											texture.origTexCoords[1], texture.origTexCoords[2],
											texture.origTexCoords[5], texture.origTexCoords[6] );
	elseif (rotationDegrees == 180) then
		texture:SetTexCoord( texture.origTexCoords[7], texture.origTexCoords[8],
											texture.origTexCoords[5], texture.origTexCoords[6],
											texture.origTexCoords[3], texture.origTexCoords[4],
											texture.origTexCoords[1], texture.origTexCoords[2] );
	elseif (rotationDegrees == 270) then
		texture:SetTexCoord( texture.origTexCoords[5], texture.origTexCoords[6],
											texture.origTexCoords[1], texture.origTexCoords[2],
											texture.origTexCoords[7], texture.origTexCoords[8],
											texture.origTexCoords[3], texture.origTexCoords[4] );
	end
end

