function WindBBConfig_OnShow()
	WindBBConfigBodyX:SetText(WindBBConfigAll[1]);
	WindBBConfigBodyY:SetText(WindBBConfigAll[2]);
	WindBBConfigBodySCALE:SetText(string.format("%0.3f", WindBBConfigAll[3]));
	if (WindBBConfigAll[4]) then 
		WindBBConfigBody1COLOR1NormalTexture:SetVertexColor(WindBBConfigAll[4][1][1].r, WindBBConfigAll[4][1][1].g, WindBBConfigAll[4][1][1].b, WindBBConfigAll[4][1][1].a);
		WindBBConfigBody1COLOR2NormalTexture:SetVertexColor(WindBBConfigAll[4][1][2].r, WindBBConfigAll[4][1][2].g, WindBBConfigAll[4][1][2].b, WindBBConfigAll[4][1][2].a);
--	WindBBConfigBody2COLOR1NormalTexture:SetVertexColor(WindBBConfigAll[4][2][1].r, WindBBConfigAll[4][2][1].g, WindBBConfigAll[4][2][1].b, WindBBConfigAll[4][2][1].a);
--	WindBBConfigBody2COLOR2NormalTexture:SetVertexColor(WindBBConfigAll[4][2][2].r, WindBBConfigAll[4][2][2].g, WindBBConfigAll[4][2][2].b, WindBBConfigAll[4][2][2].a);
		WindBBConfigBody3COLOR1NormalTexture:SetVertexColor(WindBBConfigAll[4][3][1].r, WindBBConfigAll[4][3][1].g, WindBBConfigAll[4][3][1].b, WindBBConfigAll[4][3][1].a);
		WindBBConfigBody3COLOR2NormalTexture:SetVertexColor(WindBBConfigAll[4][3][2].r, WindBBConfigAll[4][3][2].g, WindBBConfigAll[4][3][2].b, WindBBConfigAll[4][3][2].a); 
	end
end

function WindBBConfigBody_setConfigX(x)
	WindBBConfigAll[1] = x;
	WindBB_updateContainerFrameAnchors()
--	CloseAllBags();
--	OpenAllBags(1);
end

function WindBBConfigBody_setConfigY(y)
	WindBBConfigAll[2] = y;
	WindBB_updateContainerFrameAnchors()
--	CloseAllBags();
--	OpenAllBags(1);
end

function WindBBConfigBody_setConfigScale(scale)
	WindBBConfigAll[3] = scale;
	WindBB_setScale();
--	CloseAllBags();
--	OpenAllBags(1);
end

function WindBBConfigBody_getPoint()
	return "BOTTOMRIGHT";
end

function WindBBConfigBody_setConfigColor(color)
	if (color) then
		WindBB_setColor();
--		CloseAllBags();
--		OpenAllBags(1);
	end
end

function WindBBConfigBody_resetColor(index)
	WindBB_resetColor(index);

	local colorArray = WindBBConfigAll[4][index];
	getglobal("WindBBConfigBody"..index.."COLOR1NormalTexture"):SetVertexColor(colorArray[1].r, colorArray[1].g, colorArray[1].b, colorArray[1].a);
	getglobal("WindBBConfigBody"..index.."COLOR2NormalTexture"):SetVertexColor(colorArray[2].r, colorArray[2].g, colorArray[2].b, colorArray[2].a);
end