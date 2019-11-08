WindActionDefault = {
	["Body"] = { -- WindAction 공통 설정
		false				,	-- [1] : 재사용대기시간 사용여부
		false				,	-- [2] : 거리체크 사용여부
		false				,	-- [3] : 큰 단축키 사용여부
		false				,	-- [4] : 반짝임 효과 사용여부
		60					,	-- [5] : 기본 퀘스트 알림이 OFFSET(UIParent의 오른쪽 기준, <-(+))
	},
	["Main"] = { -- 메인액션바(WindActionMain) 기본값 설정
		"BOTTOM"			,	-- [1] : Anchor
		0				,	-- [2] : X 변위
		0				,	-- [3] : Y 변위
		0.85				,	-- [4] : Scale
		1				,	-- [5] : layout #
		true				,	-- [6] : 배경프레임 사용 여부
		{{r=1.0, g=0.82, b=0.0, a=1.0}	,	-- [7][1] : 배경프레임 경계선 색(rgb)
		 {r=0.0, g=0.0, b=0.0, a=0.8}}	,	-- [7][2] : 배경프레임 바탕 색(rgb)
		
	},
	["BottomLeft"] = { -- 좌측하단바(WindActionBottomLeft) 기본값 설정
		"BOTTOM"			,	-- [1] : Anchor
		0				,	-- [2] : X 변위
		52				,	-- [3] : Y 변위
		0.85				,	-- [4] : Scale
		1				,	-- [5] : layout #
		true				,	-- [6] : 배경프레임 사용 여부
		{{r=1.0, g=0.82, b=0.0, a=1.0}	,	-- [7][1] : 배경프레임 경계선 색(rgb)
		 {r=0.0, g=0.0, b=0.0, a=0.8}}	,	-- [7][2] : 배경프레임 바탕 색(rgb)
		
	},
	["BottomRight"] = { -- 우측하단바(WindActionBottomRight) 기본값 설정
		"BOTTOM"			,	-- [1] : Anchor
		492				,	-- [2] : X 변위
		52				,	-- [3] : Y 변위
		0.85				,	-- [4] : Scale
		1				,	-- [5] : layout #
		true				,	-- [6] : 배경프레임 사용 여부
		{{r=1.0, g=0.82, b=0.0, a=1.0}	,	-- [7][1] : 배경프레임 경계선 색(rgb)
		 {r=0.0, g=0.0, b=0.0, a=0.8}}	,	-- [7][2] : 배경프레임 바탕 색(rgb)
		
	},
	["Left"] = { -- 두번째사이드바(WindActionLeft) 기본값 설정
		"BOTTOM"			,	-- [1] : Anchor
		-492				,	-- [2] : X 변위
		52				,	-- [3] : Y 변위
		0.85				,	-- [4] : Scale
		1				,	-- [5] : layout #
		true				,	-- [6] : 배경프레임 사용 여부
		{{r=1.0, g=0.82, b=0.0, a=1.0}	,	-- [7][1] : 배경프레임 경계선 색(rgb)
		 {r=0.0, g=0.0, b=0.0, a=0.8}}	,	-- [7][2] : 배경프레임 바탕 색(rgb)
		
	},
	["Right"] = { -- 첫번째사이드바(WindActionRight) 기본값 설정
		"BOTTOM"				,	-- [1] : Anchor
		-492				,	-- [2] : X 변위
		0				,	-- [3] : Y 변위
		0.85				,	-- [4] : Scale
		1				,	-- [5] : layout #
		true				,	-- [6] : 배경프레임 사용 여부
		{{r=1.0, g=0.82, b=0.0, a=1.0}	,	-- [7][1] : 배경프레임 경계선 색(rgb)
		 {r=0.0, g=0.0, b=0.0, a=0.8}}	,	-- [7][2] : 배경프레임 바탕 색(rgb)
		
	},
	["Pet"] = { -- 소환수바(WindActionPet) 기본값 설정
		"BOTTOM"			,	-- [1] : Anchor
		0				,	-- [2] : X 변위
		104				,	-- [3] : Y 변위
		0.85				,	-- [4] : Scale
		1				,	-- [5] : layout #
		true				,	-- [6] : 배경프레임 사용 여부
		{{r=1.0, g=0.82, b=0.0, a=1.0}	,	-- [7][1] : 배경프레임 경계선 색(rgb)
		 {r=0.0, g=0.0, b=0.0, a=0.8}}	,	-- [7][2] : 배경프레임 바탕 색(rgb)
		
	},
	["Shift"] = { -- 태세바(WindActionShift) 기본값 설정
		"BOTTOM"			,	-- [1] : Anchor
		0				,	-- [2] : X 변위
		104				,	-- [3] : Y 변위
		0.85				,	-- [4] : Scale
		1				,	-- [5] : layout #
		true				,	-- [6] : 배경프레임 사용 여부
		{{r=1.0, g=0.82, b=0.0, a=1.0}	,	-- [7][1] : 배경프레임 경계선 색(rgb)
		 {r=0.0, g=0.0, b=0.0, a=0.8}}	,	-- [7][2] : 배경프레임 바탕 색(rgb)
		true				,	-- [8]: 보이기/감추기 설정
	},
	["Bag"] = { -- 가방(WindActionBag) 기본값 설정
		"BOTTOM"			,	-- [1] : Anchor
		701				,	-- [2] : X 변위
		0				,	-- [3] : Y 변위
		0.79				,	-- [4] : Scale
		1				,	-- [5] : layout #
		true				,	-- [6] : 배경프레임 사용 여부
		{{r=1.0, g=0.82, b=0.0, a=1.0}	,	-- [7][1] : 배경프레임 경계선 색(rgb)
		 {r=0.0, g=0.0, b=0.0, a=0.8}}	,	-- [7][2] : 배경프레임 바탕 색(rgb)
		true				,	-- [8] : 보이기/감추기 설정
	},
	["Menu"] = { -- 마이크로메뉴(WindActionMenu) 기본값 설정
		"BOTTOM"			,	-- [1] : Anchor
		455				,	-- [2] : X 변위
		0				,	-- [3] : Y 변위
		0.79				,	-- [4] : Scale
		1				,	-- [5] : layout #
		true				,	-- [6] : 배경프레임 사용 여부
		{{r=1.0, g=0.82, b=0.0, a=1.0}	,	-- [7][1] : 배경프레임 경계선 색(rgb)
		 {r=0.0, g=0.0, b=0.0, a=0.8}}	,	-- [7][2] : 배경프레임 바탕 색(rgb)
		true				,	-- [8] : 보이기/감추기 설정
	},
	["Scroll"] = { -- 매인액션바 스크롤버튼(WindActionScroll) 기본값 설정
		"BOTTOM"			,	-- [1] : Anchor
		263				,	-- [2] : X 변위
		0				,	-- [3] : Y 변위
		0.85				,	-- [4] : Scale
		1				,	-- [5] : layout #
		true				,	-- [6] : 배경프레임 사용 여부
		{{r=1.0, g=0.82, b=0.0, a=1.0}	,	-- [7][1] : 배경프레임 경계선 색(rgb)
		 {r=0.0, g=0.0, b=0.0, a=0.8}}	,	-- [7][2] : 배경프레임 바탕 색(rgb)
		true				,	-- [8] : 보이기/감추기 설정
	},
	["CastingBar"] = { -- 지연바(WindActionLatency) 기본값 설정
		"BOTTOM"			,	-- [1] : Anchor
		0				,	-- [2] : X 변위
		220				,	-- [3] : Y 변위
		1.3				,	-- [4] : Scale
		1				,	-- [5] : layout #
		true				,	-- [6] : 배경프레임 사용 여부
		{{r=1.0, g=0.82, b=0.0, a=1.0}	,	-- [7][1] : 배경프레임 경계선 색(rgb)
		 {r=0.0, g=0.0, b=0.0, a=0.8}}	,	-- [7][2] : 배경프레임 바탕 색(rgb)
		true				,	-- [8] : 보이기/감추기 설정
	},
	["VehicleLeave"] = { -- 탈것 내리기(WindActionVehicleLeave) 기본값 설정
		"BOTTOM"			,	-- [1] : Anchor
		0				,	-- [2] : X 변위
		200				,	-- [3] : Y 변위
		0.85				,	-- [4] : Scale
		1				,	-- [5] : layout #
		true				,	-- [6] : 배경프레임 사용 여부
		{{r=1.0, g=0.82, b=0.0, a=1.0}	,	-- [7][1] : 배경프레임 경계선 색(rgb)
		 {r=0.0, g=0.0, b=0.0, a=0.8}}	,	-- [7][2] : 배경프레임 바탕 색(rgb)
		true				,	-- [8] : 보이기/감추기 설정
	},
};