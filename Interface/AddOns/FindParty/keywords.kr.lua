-------------------------------------------
-- 최종수정 : 2019/9/15

-- 각종 필터링 정보를 담고 있는 파일입니다.
-- 패치로 새로운 던전이 추가되거나 난이도가 추가될 경우 이 파일에서 수정하시면 됩니다.
-- 난이도 추가시에는 FindParty.lua 파일에서 별도 처리가 필요할 수도 있습니다.

FP_CATEGORY_COLOR = {
	["raid40"] = {0.7, 0, 0.7},
	["raid20"] = {1.0, 0.7, 0.7},
	["field"] = {0.2, 0.6, 0.8},
	["dungeon"] = {0.5, 0.5, 0.8},
	["bg"] = {0, 1, 0},
	["quest"] = {1, 1, 1},
}

-- ==============================
-- 던전 분류 키워드를 정의합니다.
-- 아래 모든 필드가 있어야합니다.
-- category는 새로운 분류를 추가할 때 이용하시면 됩니다.
-- name은 던전 이름을 입력하며, 낮은 번호가 우선으로 인식됩니다. 번호가 중복되지 않도록 하여주시기 바랍니다.
-- color는 해당 던전의 색상을 지정하는 곳입니다. FP_CATEGORY_COLOR의 테이블 이름에 맞게 입력하셔야 합니다.
-- keywords는 파티모집 문구에 해당 문자열이 있을 경우 해당 난이도로 분류할 수 있도록 정의하는 부분입니다.

FP_DUNGEON_KEYWORDS = {
	[1] = {
		category = "공격대",
		dungeon = {
			[1] = {
				name = "낙스라마스",
				color = "raid40",
				keywords = {"낙스", "켈투"},
			},
			[2] = {
				name = "안퀴라즈 사원",
				color = "raid40",
				keywords = {"안퀴", "안퀴사원", "안퀴40", "사원", "쑨", "크툰"},
				excludekeywords = {"가라"},
			},
			[3] = {
				name = "안퀴라즈 폐허",
				color = "raid20",
				keywords = {"안퀴폐허", "폐허", "안퀴20"},
			},
			[4] = {
				name = "줄구룹",
				color = "raid20",
				keywords = {"줄구룹"},
			},
			[5] = {
				name = "검은날개 둥지",
				color = "raid40",
				keywords = {"검둥", "네파"},
			},
			[6] = {
				name = "화산 심장부",
				color = "raid40",
				keywords = {"화산", "화심", "라그"},
				excludekeywords = {"하실", "나락"}, -- 입장퀘 필터링
			},
			[7] = {
				name = "오닉시아",
				color = "raid40",
				keywords = {"오닉"},
				excludekeywords = {"하실", "해골"}, -- 입장퀘 필터링
			},
		},
	},
	[2] = {
		category = "던전",
		dungeon = {
			[1] = {
				name = "가라앉은 사원 (아탈학카르)",
				color = "dungeon",
				keywords = {"학카르", "학칼", "아탈"},
			},
			[2] = {
				name = "가시덩굴 구릉",
				color = "dungeon",
				keywords = {"구릉", "구렁", "구룽"},
			},
			[3] = {
				name = "가시덩굴 우리",
				color = "dungeon",
				keywords = {"우리"},
				excludekeywords = {"마우리"},
			},
			[4] = {
				name = "검은심연의 나락",
				color = "dungeon",
				keywords = {"심연", "검은심연", "검은심연의"},
				excludekeywords = {"바위"},
			},
			[5] = {
				name = "검은바위 나락",
				color = "dungeon",
				keywords = {"나락", "윈저"},
				excludekeywords = {"심연"},
			},
			[6] = {
				name = "검은바위 첨탑 하층",
				color = "dungeon",
				keywords = {"하층"},
			},
			[7] = {
				name = "검은바위 첨탑 상층",
				color = "dungeon",
				keywords = {"상층", "괴수", "드라키"},
			},
			[8] = {
				name = "그림자송곳니 성채",
				color = "dungeon",
				keywords = {"그송", "송곳니", "성채"},
			},
			[9] = {
				name = "놈리건",
				color = "dungeon",
				keywords = {"놈리"},
			},
			[10] = {
				name = "마라우돈",
				color = "dungeon",
				keywords = {"마라우돈", "우동", "마라"},
			},
			[11] = {
				name = "붉은십자군 수도원",
				color = "dungeon",
				keywords = {"십자군", "수도원"},
				excludekeywords = {"진홍"},
			},
			[12] = {
				name = "성난불길 협곡",
				color = "dungeon",
				keywords = {"성난불길", "성불"},
			},
			[13] = {
				name = "스톰윈드 지하감옥",
				color = "dungeon",
				keywords = {"감옥"},
			},
			[14] = {
				name = "스칼로맨스",
				color = "dungeon",
				keywords = {"스칼", "교장"},
			},
			[15] = {
				name = "스트라솔름",
				color = "dungeon",
				keywords = {"솔름", "솔룸", "솔륨", "솔롬", "남작"},
			},
			[16] = {
				name = "울다만",
				color = "dungeon",
				keywords = {"울다"},
			},
			[17] = {
				name = "죽음의 폐광",
				color = "dungeon",
				keywords = {"폐광"},
			},
			[18] = {
				name = "줄파락",
				color = "dungeon",
				keywords = {"줄파"},
			},
			[19] = {
				name = "통곡의 동굴",
				color = "dungeon",
				keywords = {"통곡"},
			},
			[20] = {
				name = "혈투의 전장",
				color = "dungeon",
				keywords = {"혈투", "혈장"},
			},
		},
	},
	[3] = {
		category = "전장",
		dungeon = {
			[1] = {
				name = "전장",
				color = "bg",
				keywords = {"전장", "아라시", "알방", "노래방", "토방"},
				excludekeywords = {"퀘", "쐐기"},
			},
		},
	},
	[4] = {
		category = "필드보스",
		dungeon = {
			[1] = {
				name = "필드보스",
				color = "field",
				keywords = {"카자크", "카작", "아주", "아주어고스", "녹용", "녹용팟", "레손", "이손드레", "에메리스", "타에라"},
			},
		}
	},
	[5] = {
		category = "퀘스트",
		dungeon = {
			[1] = {
				name = "퀘스트",
				color = "quest",
				keywords = {"퀘", "하실", "입장퀘"},
				excludekeywords = {"골팟", "올분", "참석", "길드", "하신"},
			},
		},
	},
}

-- 던전 이름 뒤에 다음 문자열이 기록되어 있으면 무시합니다.
-- 운다손, 갈레온손 같은 경우를 제거하기 위함입니다.
FP_DUNGEON_IGNORE_POSTFIX_KEYWORDS = {
	"손",--운다 손
	"뜸",--운다 뜸
	"없",--운다 없나요?
	"ㅅ"--운다 ㅅㅅ
}

-- 목록 툴팁에서 가독성에 영향을 주는 문자열을 사전 제거 합니다. 가능한 최소로 사용하세요.
FP_TOOLTIP_IGNORE_KEYWORDS = {
	-- 툴팁에는 이모티콘이 표시되지 않으므로 이모티콘 관련 문자들 제거
	"{해골}", "{별}", "{다이아몬드}", "{세모}", "{가위표}", "{동그라미}", "{달}", "{네모}", "{rt1}", "{rt2}", "{rt3}", "{rt4}", "{rt5}", "{rt6}", "{rt7}", "{rt8}"
}

-- 스팸 메시지 필터링 문자열
FP_GLOBAL_EXCLUDE_KEYWORDS = {
	"길드에서",
	"길드원",
	"길드는",
	"길원",
	"친목",
	"함께",
	"파밍",
	"렙업",
	"레벨업",
	"레벨링",
}
