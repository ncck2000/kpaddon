-- 2016.06.27 메인버튼들 빈칸 그림 표시 설정에 의해 빈칸 테두리 표시되도록 추가.
hooksecurefunc("MultiActionBar_UpdateGridVisibility", function()
	if ( MultibarGrid_IsVisible() == "1" or MultibarGrid_IsVisible() == 1 ) then
		WindActionMain_ShowGrid();
	else
		WindActionMain_HideGrid();
	end
end)

--NUM_MULTIBAR_BUTTONS = 12;
function WindActionMain_ShowGrid()
  if not InCombatLockdown() then
    for i=1, 12 do

      getglobal("ActionButton"..i):SetAttribute("showgrid", getglobal("ActionButton"..i):GetAttribute("showgrid") + 1);

      _G[getglobal("ActionButton"..i):GetName().."NormalTexture"]:SetVertexColor(1.0, 1.0, 1.0, 0.5);

      if ( getglobal("ActionButton"..i):GetAttribute("showgrid") >= 1 and not getglobal("ActionButton"..i):GetAttribute("statehidden") ) then
        getglobal("ActionButton"..i):Show();
      end
    end
  end	
end

function WindActionMain_HideGrid()
  if not InCombatLockdown() then
    for i=1, 12 do

      local showgrid = getglobal("ActionButton"..i):GetAttribute("showgrid");

      if ( showgrid > 0 ) then
        getglobal("ActionButton"..i):SetAttribute("showgrid", showgrid - 1);
      end

      if ( getglobal("ActionButton"..i):GetAttribute("showgrid") == 0 and not HasAction(getglobal("ActionButton"..i).action) ) then
        getglobal("ActionButton"..i):Hide();
      end
    end
  end	
end
