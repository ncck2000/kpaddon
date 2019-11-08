-- 최대 메모리 증가허용 수치 결정(MB 단위) --
initMemSize = 0;
maxMemGapSize = 5;

function WindInfoPerf_OnLoad(self)
	WindInfoPerfText:SetAllPoints(WindInfoPerf);
	WindInfoPerf:RegisterEvent("VARIABLES_LOADED");
end

function WindInfoPerf_OnUpdate(self, elapsed)
	WindInfoPerfText:SetText(WindInfoPerf_setPerf());
end

function WindInfoPerf_OnEvent(self, event, ...)
	if (event == "VARIABLES_LOADED") then
		-- 초기 메모리 점유율 저장
		-- 정확한 초기 메모리를 알기위해 한번 가비지수집을 한다.
		collectgarbage();			
		initMemSize = ceil(gcinfo() / 1024);

		-- 초기화 시도
		WindInfoPerf_initConfig();
		WindInfoPerf_refresh();
	end
end

function WindInfoPerf_setPerf()
	local _, _, lat = GetNetStats();
	lat = floor(lat);
	local fps = floor(GetFramerate());
	local intMem = gcinfo() / 1024;
	local formattedMem = string.format("%0.2f", intMem);

	-- 메모리 증가치가 정해진 수치보다 높아지면 자동으로 가비지수집을 시행한다.
	-- WindInfoPerf_garbageCollector(floor(intMem));

	return "|cFFFFFF00"..fps.."|cFFFFFFFFFPS |cFFFFFF00"..lat.."|cFFFFFFFFms |cFFFFFF00"..formattedMem.."|cFFFFFFFFMB";
end

function WindInfoPerf_initConfig()
	if (not WindInfoPerfConfig) then WindInfoPerfConfig = WindInfoDefault["Perf"]; end
end

function WindInfoPerf_resetConfig()
	WindInfoPerfConfig = WindInfoDefault["Perf"];
	
	WindInfoPerf_refresh();
end

function WindInfoPerf_refresh()	
	WindInfoPerf_setPoint();
	WindInfoPerf_setScale();
	WindInfoPerf_setSize();
	WindInfoPerf_setView();
	WindInfoPerf_setMouse();
end

function WindInfoPerf_setPoint()
	WindCommon_setPoint(WindInfoPerf, WindInfoPerfConfig[1], "WindInfo", WindInfoPerfConfig[1], WindInfoPerfConfig[2], WindInfoPerfConfig[3]);
end

function WindInfoPerf_setScale()
	WindInfoPerf:SetScale(WindInfoPerfConfig[4]);
end

function WindInfoPerf_setSize()
	WindCommon_setSize(WindInfoPerf, WindInfoPerfConfig[5], WindInfoPerfConfig[6]);
end

function WindInfoPerf_setView()
	if (WindInfoPerfConfig[7]) then WindInfoPerf:Show();
	else WindInfoPerf:Hide(); end
end

function WindInfoPerf_setMouse()
	if (WindInfoPerfConfig[8]) then WindInfoPerf:Show();
	else WindInfoPerf:Hide(); end
end

function WindInfoPerf_garbageCollector(mem)
	local currentMemSize = mem;
	local currentMemGapSize = currentMemSize - initMemSize;
	if (currentMemGapSize > maxMemGapSize) then collectgarbage(); end
end