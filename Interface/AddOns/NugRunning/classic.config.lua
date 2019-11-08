-----------------------------------------------------------------------------------
-- It's a better idea to edit userconfig.lua in NugRunningUserConfig addon folder
-- CONFIG GUIDE: https://github.com/rgd87/NugRunning/wiki/NugRunningUserConfig
-----------------------------------------------------------------------------------
local _, helpers = ...
local Spell = helpers.Spell
local ModSpell = helpers.ModSpell
local Cooldown = helpers.Cooldown
local Activation = helpers.Activation
local EventTimer = helpers.EventTimer
local Cast = helpers.Cast
local Item = helpers.Item
local Anchor = helpers.Anchor
local Talent = helpers.ClassicTalent
local Totem = helpers.Totem
local Glyph = helpers.Glyph
local GetCP = helpers.GetCP
local SPECS = helpers.SPECS
local IsPlayerSpell = IsPlayerSpell
local IsUsableSpell = IsUsableSpell
local _,class = UnitClass("player")

-- NugRunningConfig.overrideTexture = true
-- NugRunningConfig.texture = "Interface\\AddOns\\NugRunning\\statusbar"
-- NugRunningConfig.overrideFonts = true
-- NugRunningConfig.nameFont = { font = "Interface\\AddOns\\NugRunning\\Calibri.ttf", size = 10, alpha = 0.5 }
-- NugRunningConfig.timeFont = { font = "Interface\\AddOns\\NugRunning\\Calibri.ttf", size = 8, alpha = 1 }
-- NugRunningConfig.stackFont = { font = "Interface\\AddOns\\NugRunning\\Calibri.ttf", size = 12 }

NugRunningConfig.nameplates.parented = true

NugRunningConfig.colors = {}
local colors = NugRunningConfig.colors
colors["RED"] = { 0.8, 0, 0}
colors["RED2"] = { 1, 0, 0}
-- colors["RED3"] = { 183/255, 58/255, 93/255}
colors["LRED"] = { 1,0.4,0.4}
colors["DRED"] = { 0.55,0,0}
colors["CURSE"] = { 0.6, 0, 1 }
colors["PINK"] = { 1, 0.3, 0.6 }
colors["PINK2"] = { 1, 0, 0.5 }
colors["PINK3"] = { 226/255, 35/255, 103/255 }
colors["PINKIERED"] = { 206/255, 4/256, 56/256 }
colors["TEAL"] = { 0.32, 0.52, 0.82 }
colors["TEAL2"] = {38/255, 221/255, 163/255}
colors["TEAL3"] = {52/255, 172/255, 114/255}
colors["DTEAL"] = {15/255, 78/255, 60/255}
colors["ORANGE"] = { 1, 124/255, 33/255 }
colors["ORANGE2"] = { 1, 66/255, 0 }
colors["FIRE"] = {1,80/255,0}
colors["LBLUE"] = {149/255, 121/255, 214/255}
colors["DBLUE"] = { 50/255, 34/255, 151/255 }
colors["GOLD"] = {1,0.7,0.5}
colors["LGREEN"] = { 0.63, 0.8, 0.35 }
colors["GREEN"] = {0.3, 0.9, 0.3}
colors["DGREEN"] = { 0, 0.35, 0 }
colors["PURPLE"] = { 187/255, 75/255, 128/255 }
colors["PURPLE2"] = { 188/255, 37/255, 186/255 }
colors["BURGUNDY"] = { 102/255, 22/255, 49/255 }
colors["REJUV"] = { 1, 0.2, 1}
colors["PURPLE3"] = { 64/255, 48/255, 109/255 }
colors["PURPLE4"] = { 121/255, 29/255, 57/255 }
colors["PURPLE5"] = { 0.49, 0.16, 0.60 }
colors["DPURPLE"] = {74/255, 14/255, 85/255}
colors["DPURPLE2"] = {0.42, 0, 0.7}
colors["CHIM"] = {199/255, 130/255, 255/255}
colors["FROZEN"] = { 65/255, 110/255, 1 }
colors["CHILL"] = { 0.6, 0.6, 1}
colors["BLACK"] = {0.35,0.35,0.35}
colors["SAND"] = { 168/255, 75/255, 11/255 }
colors["WOO"] = {151/255, 86/255, 168/255}
colors["WOO2"] = {80/255, 83/255, 150/255}
colors["WOO2DARK"] = {30/255, 30/255, 65/255}
colors["BROWN"] = { 192/255, 77/255, 48/255}
colors["DBROWN"] = { 118/255, 69/255, 50/255}
colors["MISSED"] = { .15, .15, .15}
colors["DEFAULT_DEBUFF"] = { 0.8, 0.1, 0.7}
colors["DEFAULT_BUFF"] = { 1, 0.4, 0.2}

local DotSpell = function(id, opts)
    if type(opts.duration) == "number" then
        local m = opts.duration*0.3 - 0.2
        -- opts.recast_mark = m
        opts.overlay = {0, m, 0.25}
    end
    return Spell(id,opts)
end
helpers.DotSpell = DotSpell


local Interrupt = function(id, name, duration)
    EventTimer(id, { event = "SPELL_INTERRUPT", short = "Interrupted", name = name, target = "pvp", duration = duration, shine = true, color = colors.LBLUE })
end
helpers.Interrupt = Interrupt

if select(4,GetBuildInfo()) > 19999 then return end

-- RACIALS
Spell( 23234 ,{ name = "피의격노", global = true, duration = 15, scale = 0.75, group = "buffs" })
Spell( 20594 ,{ name = "석화", global = true, duration = 8, shine = true, group = "buffs" })
Spell( 20549 ,{ name = "전투 발구르기", global = true, duration = 2, multiTarget = true, color = colors.DRED })
Spell( 7744 ,{ name = "포세이큰의 의지", global = true, duration = 5, group = "buffs", color = colors.PURPLE5 })

-- Cast({ 746, 1159, 3267, 3268, 7926, 7927, 10838, 10839, 18608, 18610, 23567, 23568, 23569, 23696, 24412, 24413, 24414 },
    -- { name = "First Aid", global = true, tick = 1, tickshine = true, overlay = {"tick", "tickend", 0.4 }, color = colors.LGREEN })



if class == "WARLOCK" then
-- Interrupt(119910, "Spell Lock", 6) -- Felhunter spell from action bar
Interrupt(19244, "주문 잠금", 6) -- Rank 1
Interrupt(19647, "주문 잠금", 8) -- Rank 2
Spell( 24259 ,{ name = "침묵", duration = 3, color = colors.PINK }) -- Spell Lock Silence

local normalize_dots_to = nil--26

Spell({ 1714, 11719 }, { name = "언어의 저주", duration = 30, color = colors.CURSE })
Spell({ 702, 1108, 6205, 7646, 11707, 11708 },{  name = "무력화의 저주", duration = 120, color = colors.CURSE })
Spell({ 17862, 17937 }, { name = "어둠의 저주", duration = 300, glowtime = 15, color = colors.CURSE })
Spell({ 1490, 11721, 11722 }, { name = "원소의 저주", duration = 300, glowtime = 15, color = colors.CURSE })
Spell({ 704, 7658, 7659, 11717 }, { name = "무모함의 저주", duration = 120, shine = true, color = colors.CURSE })
Spell( 603 ,{ name = "파멸의 저주", duration = 60, ghost = true, color = colors.CURSE, nameplates = true, })
Spell( 18223 ,{ name = "피로의 저주", duration = 12, ghost = true, color = colors.CURSE })

Spell( 17941 ,{ name = "어둠의 무아지경", duration = 10, shine = true, priority = 15, glowtime = 10, scale = 0.7, shinerefresh = true, color = colors.DPURPLE })


Spell( 6358, { name = "유혹", duration = 20, color = colors.PURPLE4 }) -- varies, Improved Succubus
Spell({ 5484, 17928 }, { name = "공포의 울부짖음", shine = true, multiTarget = true,
    duration = function(timer)
        return timer.spellID == 5484 and 10 or 15
    end
})
Spell({ 5782, 6213, 6215 }, { name = "공포",
    duration = function(timer)
        if timer.spellID == 5782 then return 10
        elseif timer.spellID == 6213 then return 15
        else return 20 end
    end
})
Spell({ 710, 18647 }, { name = "추방", nameplates = true, color = colors.TEAL3,
    duration = function(timer)
        return timer.spellID == 710 and 20 or 30
    end
})
Spell({ 6789, 17925, 17926 }, { name = "죽음의 고리", duration = 3, color = colors.DTEAL })


Spell({ 18265, 18879, 18880, 18881}, { name = "생명력 착취", duration = 30, priority = 5, fixedlen = normalize_dots_to, nameplates = true, ghost = true, color = colors.DTEAL })
Spell({ 980, 1014, 6217, 11711, 11712, 11713 }, { name = "고통의 저주", duration = 24, fixedlen = normalize_dots_to, nameplates = true, ghost = true, priority = 6, color = colors.CURSE })
Spell({ 172, 6222, 6223, 7648, 11671, 11672, 25311 }, { name = "부패", tick = 3, overlay = {"tick", "end", 0.35}, priority = 9, fixedlen = normalize_dots_to, nameplates = true, ghost = true, color = colors.PINK3,
    duration = function(timer, opts)
        if timer.spellID == 172 then
            return 12
        elseif timer.spellID == 6222 then
            return 15
        else
            return 18
        end
    end }) -- Corruption
Spell({ 348, 707, 1094, 2941, 11665, 11667, 11668, 25309 },{ name = "제물", recast_mark = 1.5, overlay = {0, 1.5, 0.3}, duration = 15, nameplates = true, priority = 10, ghost = true, color = colors.RED })

Spell({ 17877, 18867, 18868, 18869, 18870, 18871 }, { name = "어둠의 연소", duration = 5, scale = 0.5, color = colors.DPURPLE }) -- Soul Shard debuff

Cooldown( 17962, { name = "점화", ghost = true, priority = 5, color = colors.PINK })


Spell({ 6229, 11739, 11740, 28610 } ,{ name = "암흑계 수호", duration = 30, group = "buffs", scale = 0.7, color=colors.DPURPLE})
Spell({ 7812, 19438, 19440, 19441, 19442, 19443 }, { name = "희생", duration = 30, group = "buffs", shine = true, color=colors.GOLD })
Spell({ 17767, 17850, 17851, 17852, 17853, 17854 }, { name = "어둠 흡수", duration = 10, color = colors.LRED, target = "pet" })

end



if class == "SHAMAN" then
Interrupt({ 8042, 8044, 8045, 8046, 10412, 10413, 10414 }, "대지 충격", 2)

-- Spell( 3600 ,{ name = "Earthbind", maxtimers = 1, duration = 5, timeless = true, color = colors.BROWN, scale = 0.7 })
Spell({ 16257, 16277, 16278, 16279, 16280 }, { name = "질풍", duration = 15, scale = 0.8, group = "buffs", shine = true, shinerefresh = true, color = colors.DPURPLE })
Spell({ 8056, 8058, 10472, 10473 }, { name = "냉기 충격", duration = 8, color = colors.LBLUE })
Spell({ 8050, 8052, 8053, 10447, 10448, 29228 }, { name = "화염 충격", duration = 12, color = colors.RED, ghost = true })
Cooldown( 8042 ,{ name = "충격", color = colors.TEAL3, ghost = 2, priority = 1, ghosteffect = "MAGICCAST", scale = 0.9 })
Cooldown( 17364 ,{ name = "폭풍의 일격", color = colors.CURSE, priority = 10, scale_until = 5, ghost = true  })
Spell( 29063 ,{ name = "집중력", shine = true, duration = 6, color = colors.PURPLE4, group = "buffs" })
Spell( 16246 ,{ name = "정신 집중", shine = true, duration = 15, color = colors.CHIM, group = "buffs" })
Spell( 16166 ,{ name = "정기의 깨달음", shine = true, duration = 15, priority = 12, timeless = true, color = colors.DPURPLE })
Spell( 16188 ,{ name = "자연의 신속함", shine = true, duration = 15, group = "buffs", priority = -12, timeless = true, color = colors.WOO2DARK })
Spell( 29203 ,{ name = "치유의 길", maxtimers = 2, duration = 15, scale = 0.7, color = colors.LGREEN })

-- TOTEMS
local PRIO_FIRE = -77
local PRIO_EARTH = -78
local PRIO_WATER = -79
local PRIO_AIR = -80
Totem(136102, { name = "속박의 토템", spellID = 2484, group = "buffs", ghost = 1, color = colors.DBROWN, shine = true, tick = 3, overlay = {"tick", "tickend"}, priority = PRIO_EARTH })
Totem(136097, { name = "돌발톱 토템", spellID = 5730, group = "buffs", color = colors.WOO2, shine = true, priority = PRIO_EARTH })
Totem(136098, { name = "수호의 토템", spellID = 8071, group = "buffs", color = colors.WOO, ghost = 1, scale = 0.7, priority = PRIO_EARTH })
Totem(136023, { name = "돌가죽 토템", short = "Strength", spellID = 8075, group = "buffs", color = colors.DTEAL, scale = 0.7, ghost = 1, priority = PRIO_EARTH })
Totem(136108, { name = "진동의 토템", spellID = 8143, group = "buffs", color = colors.PINK, ghost = 1, priority = PRIO_EARTH })

Totem(135824, { name = "불꽃 회오리 토템", spellID = 1535, group = "buffs", color = colors.LRED, shine = true, priority = PRIO_FIRE })
Totem(135826, { name = "용암 토템", spellID = 8190, group = "buffs", color = colors.DRED, tick = 2, overlay = {"tick", "end", 0.3}, priority = PRIO_FIRE })
Totem(135825, { name = "불타는 토템", spellID = 3599, group = "buffs", color = colors.RED, priority = PRIO_FIRE, ghost = 1 })
Totem(136040, { name = "불꽃의 토템", spellID = 8227, group = "buffs", color = colors.PURPLE4, priority = PRIO_FIRE, scale = 0.7, ghost = 1 })
Totem(135866, { name = "냉기 저항 토템", short = "냉기저항", spellID = 8181, group = "buffs", color = colors.LRED, ghost = 1, scale = 0.5, priority = PRIO_FIRE })

Totem(135832, { name = "화염 저항 토템", short = "화염저항", spellID = 8184, group = "buffs", color = colors.FROZEN, ghost = 1, scale = 0.5, priority = PRIO_WATER })
Totem(135127, { name = "치유의 토템", short = "치유", spellID = 5394, group = "buffs", color = colors.LGREEN, ghost = 3, scale = 0.7, priority = PRIO_WATER })
Totem(136053, { name = "마나샘 토템", short = "마나샘", spellID = 5675, group = "buffs", color = colors.PURPLE, ghost = 3, scale = 0.7, priority = PRIO_WATER })
Totem(136070, { name = "독정화 토템", short = "독정화", spellID = 8166, group = "buffs", color = colors.GREEN, ghost = 1, scale = 0.7, priority = PRIO_WATER })
Totem(136019, { name = "질병 정화 토템", short = "질병정화", spellID = 8166, group = "buffs", color = colors.BROWN, ghost = 1, scale = 0.7, priority = PRIO_WATER })
Totem(135861, { name = "마나 해일 토템", short = "마나해일", spellID = 16190, group = "buffs", effect = "UNHOLY", color = colors.TEAL2, ghost = 1, priority = PRIO_WATER })

Totem(136039, { name = "마법정화 토템", spellID = 8177, group = "buffs", color = colors.CURSE, shine = true, tick = 10, overlay = {"tick", "end", 0.35}, priority = PRIO_AIR, ghost = 1, ghosteffect = "SLICENDICE" })
Totem(136114, { name = "질풍 토템", spellID = 8512, group = "buffs", color = colors.PINK3, shine = true, scale = 0.7, ghosteffect = "FIRESHOT", priority = PRIO_AIR, ghost = 3 })
Totem(136046, { name = "은총의 토템", short = "민첩", spellID = 8835, group = "buffs", color = colors.PURPLE5, ghost = 1, scale = 0.7, priority = PRIO_AIR })
Totem(136061, { name = "자연 저항 토템", short = "자연저항", spellID = 10595, group = "buffs", color = colors.TEAL3, ghost = 1, scale = 0.5, priority = PRIO_AIR })
Totem(136022, { name = "바람막이 토템", spellID = 15107, group = "buffs", color = colors.BLACK, scale = 0.7, priority = PRIO_AIR, ghost = 1 })
Totem(136013, { name = "평온의 토템", short = "평온", spellID = 25908, group = "buffs", color = colors.LBLUE, scale = 0.5, priority = PRIO_AIR, ghost = 1 })
-- Totem(136082, { name = "Sentry Totem", spellID = 6495, group = "buffs", color = colors.CURSE, ghost = 1, priority = PRIO_AIR })
end

if class == "PALADIN" then

Spell( 20066 ,{ name = "참회", duration = 6 })
Spell({ 2878, 5627, 5627 }, { name = "언데드 처치",
    duration = function(timer)
        if timer.spellID == 2878 then return 10
        elseif timer.spellID == 5627 then return 15
        else return 20 end
    end
})
Cooldown( 879 ,{ name = "퇴마술", color = colors.ORANGE, ghost = true, priority = 8, })
Cooldown( 24275 ,{ name = "천벌의 망치", color = colors.TEAL2, ghost = true, priority = 11 })

Spell( 1044 ,{ name = "자유의 손길", duration = 10, group = "buffs" })
Spell({ 6940, 20729 }, { name = "희생의 축복", duration = 10, group = "buffs", color = colors.LRED })
Spell({ 1022, 5599, 10278 }, { name = "보호의 손길", group = "buffs", color = colors.WOO2,
    duration = function(timer)
        if timer.spellID == 1022 then return 6
        elseif timer.spellID == 5599 then return 8
        else return 10 end
    end
})
-- DS includes Divine Protection
Spell({ 498, 5573, 642, 1020 }, { name = "천상의 보호막", duration = 12, group = "buffs", color = colors.BLACK }) --varies BUFF

Spell({ 20375, 20915, 20918, 20919, 20920 }, { name = "지휘의 문장", scale_until = 8, priority = 6, duration = 30, ghost = 1, color = colors.RED })
Spell({ 21084, 20287, 20288, 20289, 20290, 20291, 20292, 20293 }, { name = "정의의 문장", scale_until = 8, priority = 6, duration = 30, ghost = 1, color = colors.DTEAL })
Spell({ 20162, 20305, 20306, 20307, 20308, 21082 }, { name = "성전사의 문장", scale_until = 8, priority = 6, duration = 30, ghost = 1, color = colors.GOLD })
Spell({ 20165, 20347, 20348, 20349 }, { name = "빛의 문장", scale_until = 8, priority = 6, duration = 30, ghost = 1, color = colors.LGREEN })
Spell({ 20166, 20356, 20357 }, { name = "지혜의 문장", scale_until = 8, priority = 6, duration = 30, ghost = 1, color = colors.LBLUE })
Spell( 20164 , { name = "심판의 문장", scale_until = 8, priority = 6, duration = 30, ghost = 1, color = colors.BLACK })

Spell({ 21183, 20188, 20300, 20301, 20302, 20303 }, { name = "성전사의 심판", short = "성전사", duration = 10, color = colors.GOLD })
Spell({ 20185, 20344, 20345, 20346 }, { name = "빛의 심판", short = "빛", duration = 10, color = colors.LGREEN })
Spell({ 20186, 20354, 20355 }, { name = "지혜의 심판", short = "지혜", duration = 10, color = colors.LBLUE })
Spell( 20184 , { name = "정의의 심판", short = "정의", duration = 10, color = colors.BLACK })

Spell({ 853, 5588, 5589, 10308 }, { name = "심판의 망치", short = "망치", color = colors.FROZEN,
    duration = function(timer)
        if timer.spellID == 853 then return 3
        elseif timer.spellID == 5588 then return 4
        elseif timer.spellID == 5589 then return 5
        else return 6 end
    end
}) -- varies

Spell( 20216 ,{ name = "신의 은총", shine = true, duration = 15, priority = 12, timeless = true, scale = 0.7, color = colors.DPURPLE })
Cooldown( 26573 ,{ name = "신성화", color = colors.PINKIERED, priority = 9, scale = 0.85, ghost = true })
Cooldown( 20473 ,{ name = "신성 충격", ghost = 1, priority = 5, scale_until = 5, color = colors.WOO })
Cooldown( 20271 ,{ name = "심판", ghost = true, priority = 8, color = colors.PURPLE })

Spell({ 20925, 20927, 20928 }, { name = "신성한 방패", duration = 10, priority = 7, scale = 1, ghost = true, arrow = colors.PINK2, color = colors.PINK3 })

end

if class == "HUNTER" then

-- EventTimer({ event = "SPELL_CAST_SUCCESS", spellID = 1543, name = "Flare", scale = 0.5, color = colors.GOLD, duration = 30 })
Spell( 19263 ,{ name = "공격 저지", duration = 10, color = colors.LBLUE, shine = true, group = "buffs" })
Spell( 3045 ,{ name = "속사", duration = 15, color = colors.PINK2, group = "buffs" })
Spell( 19574 ,{ name = "야수의 격노", duration = 18, target = "pet", group = "buffs", shine = true, color = colors.LRED })

Spell({ 1513, 14326, 14327 }, { name = "야수 겁주기",
    duration = function(timer)
        if timer.spellID == 1513 then return 10
        elseif timer.spellID == 14326 then return 15
        else return 20 end
    end
})

Spell({ 1978, 13549, 13550, 13551, 13552, 13553, 13554, 13555, 25295 }, { name = "독사 쐐기", duration = 15, color = colors.PURPLE, ghost = true, })
Spell({ 3043, 14275, 14276, 14277 }, { name = "전갈 쐐기", duration = 20, color = colors.TEAL })
Spell({ 3034, 14279, 14280 }, { name = "살무사 쐐기", duration = 8, color = colors.DBLUE })
Spell({ 19386, 24132, 24133 }, { name = "비룡 쐐기", short = "수면", duration = 12, color = colors.PURPLE3, ghost = 1 })
Spell({ 24131, 24134, 24135 }, { name = "비룡 쐐기", duration = 12, color = colors.GREEN }) -- Wyvern Sting Dot


Spell(19229, { name = "날개 절단 연마", shine = true, duration = 5, scale = 0.6, color = colors.DBROWN })
Spell({ 19306, 20909, 20910 }, { name = "역습", shine = true, duration = 5, scale = 0.6, color = colors.DBROWN })

Cooldown( 19306 ,{ name = "역습", ghost = 1, priority = 5, color = colors.PURPLE4 })
Activation( 19306, { for_cd = true, effect = "FIRESHOT", ghost = 5 })

Spell({ 13812, 14314, 14315 }, { name = "폭발의 덫", duration = 20, multiTarget = true, color = colors.RED, ghost = 1 })
Spell({ 13797, 14298, 14299, 14300, 14301 }, { name = "제물의 덫", duration = 15, color = colors.RED, ghost = 1 })
Spell({ 3355, 14308, 14309 }, { name = "얼음의 덫", color = colors.FROZEN,
    duration = function(timer)
        local mul = 1 + 0.15*Talent(19239, 19245) -- Clever Traps
        if timer.spellID == 3355 then return 10*mul
        elseif timer.spellID == 14308 then return 15*mul
        else return 20*mul end
    end
})

Spell( 19503 , { name = "산탄 사격", duration = 4, color = colors.PINK3, shine = true })

Cooldown( 1495 ,{ name = "살쾡이의 이빨", ghost = true, priority = 4, color = colors.WOO })
Cooldown( 2973 ,{ name = "랩터의 일격", ghost = 1, priority = 3, color = colors.LBLUE })

-- Cooldown( 19434 ,{ name = "Aimed Shot", ghost = true, priority = 10, color = colors.TEAL3 })
Cooldown( 2643 ,{ name = "일제 사격", ghost = true, priority = 5, color = colors.PINKIERED })
Cooldown( 3044 ,{ name = "신비한 사격", ghost = true, priority = 7, color = colors.TEAL3 })
Spell({ 2974, 14267, 14268 }, { name = "날개 절단", duration = 10, color = colors.BROWN })
Spell( 5116 ,{ name = "충격포", duration = 4, color = colors.BROWN })
Spell( 19410 ,{ name = "충격포 연마", duration = 3, shine = true, color = colors.RED })
Spell( 24394 ,{ name = "위협", duration = 3, shine = true, color = colors.RED })

end

if class == "DRUID" then
Interrupt(16979, "야성의 돌진", 4)

Spell( 22812 ,{ name = "나무 껍질", duration = 15, color = colors.WOO2, group = "buffs" })
Spell({ 339, 1062, 5195, 5196, 9852, 9853 }, { name = "휘감는 뿌리", color = colors.DBROWN,
    duration = function(timer)
        if timer.spellID == 339 then return 12
        elseif timer.spellID == 1062 then return 15
        elseif timer.spellID == 5195 then return 18
        elseif timer.spellID == 5196 then return 21
        elseif timer.spellID == 9852 then return 24
        else return 27 end
    end
}) -- varies
Spell({ 2908, 8955, 9901 }, { name = "동물 달래기", duration = 15, color = colors.PURPLE5 })
-- includes Faerie Fire (Feral) ranks
Spell({ 770, 778, 9749, 9907, 17390, 17391, 17392 }, { name = "요정의 불꽃(야성)", duration = 40, color = colors.PURPLE5 })
Spell({ 2637, 18657, 18658 }, { name = "겨울잠", color = colors.PURPLE4, nameplates = true,
    duration = function(timer)
        if timer.spellID == 2637 then return 20
        elseif timer.spellID == 18657 then return 30
        else return 40 end
    end
}) -- varies
Spell({ 99, 1735, 9490, 9747, 9898 }, { name = "위협의 포효", duration = 30, color = colors.DTEAL, multiTarget = true, shinerefresh = true })
Spell({ 5211, 6798, 8983 }, { name = "강타", color = colors.RED,
    duration = function(timer)
        local brutal_impact = Talent(16940, 16941)*0.5
        if timer.spellID == 5211 then return 2+brutal_impact
        elseif timer.spellID == 6798 then return 3+brutal_impact
        else return 4+brutal_impact end
    end
}) -- varies

Spell( 5209 , { name = "도전의 포효", duration = 6, multiTarget = true })
Spell( 6795 ,{ name = "포효", duration = 3 })
-- SKIPPING: Nature's Grasp
Spell({ 1850, 9821 }, { name = "질주", duration = 15 })
Spell( 5229, { name = "분노", color = colors.PURPLE4, shine = true, scale = 0.6, group = "buffs", duration = 10 })
Spell({ 22842, 22895, 22896 }, { name = "광포한 재생력", duration = 10, color = colors.LGREEN })

Spell( 19675, { name = "야성의 돌진", duration = 4, color = colors.DBROWN, shine = true })

Spell( 16922, { name = "별빛 화살 기절", duration = 3, shine = true, color = colors.RED })
Spell({ 9005, 9823, 9827 }, { name = "암습", priority = -20, color = colors.RED,
    duration = function(timer)
        local brutal_impact = Talent(16940, 16941)*0.5
        return 2+brutal_impact
    end
})
Spell({ 9007, 9824, 9826 }, { name = "암습 피해", duration = 18, priority = 4, color = colors.PINK3 })
Spell({ 8921, 8924, 8925, 8926, 8927, 8928, 8929, 9833, 9834, 9835 }, { name = "달빛 섬광", priority = 5, ghost = true, color = colors.PURPLE, nameplates = true,
duration = function(timer)
    if timer.spellID == 8921 then return 9
    else return 12 end
end
})
Spell({ 1822, 1823, 1824, 9904 }, { name = "갈퀴 발톱", tick = 3, overlay = {"tick", "end"}, duration = 9, priority = 6, nameplates = true, ghost = true, color = colors.PINKIERED })
Spell({ 1079, 9492, 9493, 9752, 9894, 9896 }, { name = "도려내기", tick = 2, overlay = {"tick", "end"}, duration = 12, priority = 5, ghost = true, nameplates = true, color = colors.RED })
Spell({ 5217, 6793, 9845, 9846 }, { name = "맹공격", duration = 6, color = colors.GOLD, scale = 0.7, group = "buffs", shine = true })

Spell( 2893 ,{ name = "독 해제", tick = 2, tickshine = true, overlay = {"tick", "end"}, group = "buffs", duration = 8, color = colors.TEAL2 })
Spell( 29166 , { name = "정신 자극", duration = 20, shine = true, color = colors.DBLUE })

Spell({ 8936, 8938, 8939, 8940, 8941, 9750, 9856, 9857, 9858 }, { name = "재생", duration = 21, scale = 0.7, color = colors.LGREEN })
Spell({ 774, 1058, 1430, 2090, 2091, 3627, 8910, 9839, 9840, 9841, 25299 }, { name = "회복", scale = 1, duration = 12, color = colors.REJUV })
Spell( 16870 ,{ name = "정신 집중", shine = true, group = "buffs", duration = 15, color = colors.CHIM })

Spell({ 5570, 24974, 24975, 24976, 24977 }, { name = "곤충 떼", duration = 12, priority = 6, color = colors.TEAL3, ghost = true, nameplates = true, })
Spell( 17116 ,{ name = "자연의 신속함", shine = true, duration = 15, group = "buffs", priority = -12, timeless = true, scale = 0.7, color = colors.WOO2DARK })


end

if class == "MAGE" then
Interrupt(2139, "마법 차단", 10)

Spell( 18469 ,{ name = "침묵", duration = 4, color = colors.CHIM }) -- Improved Counterspell
Spell({ 118, 12824, 12825, 12826, 28270, 28271, 28272 },{ name = "변이", glowtime = 5, ghost = 1, ghosteffect = "SLICENDICE", color = colors.LGREEN,
    duration = function(timer)
        if timer.spellID == 118 then return 20
        elseif timer.spellID == 12824 then return 30
        elseif timer.spellID == 12825 then return 40
        else return 50 end
    end
}) -- varies


Spell( 11958 ,{ name = "얼음 방패", duration = 10, color = colors.CHIM, group = "buffs", shine = true })
Spell({ 1463, 8494, 8495, 10191, 10192, 10193 }, { name = "마나 보호막", duration = 60, ghost = true, group = "buffs", color = colors.TEAL })
Spell({ 11426, 13031, 13032, 13033 }, { name = "얼음 보호막", duration = 60, ghost = true, group = "buffs", color = colors.TEAL3 })
Spell({ 543, 8457, 8458, 10223, 10225 }, { name = "화염계 수호", duration = 30, group = "buffs", scale = 0.7, color = colors.ORANGE })
Spell({ 6143, 8461, 8462, 10177, 28609 }, { name = "냉기계 수호", duration = 30, group = "buffs", scale = 0.7, color = colors.LBLUE })
Spell( 28682 ,{ name = "발화", color = colors.DPURPLE, timeless = true, group = "buffs", priority = -20, duration = 10 })

Cooldown( 2136, { name = "화염 작열", color = colors.LRED, ghost = true })

Spell( 12355 ,{ name = "충돌", duration = 2, shine = true, color = colors.PURPLE3 }) -- fire talent stun proc
Spell( 12654 ,{ name = "작열", duration = 4, shine = true, shinerefresh = true, ghost = true, ghosteffect = "FIRESHOT", color = colors.PINK3 })
EventTimer({ spellID = 12654, event = "SPELL_PERIODIC_DAMAGE",
    action = function(active, srcGUID, dstGUID, spellID, damage )
        local ignite_timer = NugRunning.gettimer(active, spellID, dstGUID, "DEBUFF")
        if ignite_timer then
            ignite_timer:SetName(damage)
        end
    end})
Spell( 22959 ,{ name = "화염 저항력 약화", duration = 30, scale = 0.5, priority = -10, glowtime = 4, ghost = true, ghosteffect = "GOUGE", color = colors.BROWN })

Spell({ 2120, 2121, 8422, 8423, 10215, 10216 }, { name = "불기둥", duration = 8, color = colors.PURPLE, multiTarget = true })

-- EventTimer({ spellID = 153561, event = "SPELL_CAST_SUCCESS", name = "Meteor", duration = 2.9, color = colors.FIRE })

Spell({ 11113, 13018, 13019, 13020, 13021 }, { name = "화염 폭풍", duration = 6, scale = 1,  color = colors.DBROWN, multiTarget = true })
Spell({ 120, 8492, 10159, 10160, 10161 }, { name = "냉기 돌풍", scale = 0.6,  color = colors.CHILL, multiTarget = true,
    duration = function(timer)
        local permafrost = Talent(11175, 12569, 12571)
        return 8 + permafrost
    end
})

-- Frost Armor
Spell( 6136 , { name = "빙결", scale = 0.6,  color = colors.CHILL, multiTarget = true,
    duration = function(timer)
        local permafrost = Talent(11175, 12569, 12571)
        return 5 + permafrost
    end
})


Spell({ 116, 205, 837, 7322, 8406, 8407, 8408, 10179, 10180, 10181, 25304 }, { name = "얼음 화살", scale = 0.6, color = colors.CHILL,
    duration = function(timer)
        local permafrost = Talent(11175, 12569, 12571)
        if timer.spellID == 116 then return 5 + permafrost
        elseif timer.spellID == 205 then return 6 + permafrost
        elseif timer.spellID == 837 then return 6 + permafrost
        elseif timer.spellID == 7322 then return 7 + permafrost
        elseif timer.spellID == 8406 then return 7 + permafrost
        elseif timer.spellID == 8407 then return 8 + permafrost
        elseif timer.spellID == 8408 then return 8 + permafrost
        else return 9 + permafrost end
    end
}) -- varies


Spell( 12494 ,{ name = "동상", duration = 5, color = colors.FROZEN, shine = true })
Spell({ 122, 865, 6131, 10230 } ,{ name = "얼음 회오리", duration = 8, color = colors.FROZEN, multiTarget = true })

Spell( 12536 ,{ name = "정신 집중", shine = true, group = "buffs", duration = 15, color = colors.CHIM })
Spell( 12043 ,{ name = "냉정", shine = true, duration = 15, group = "buffs", priority = -12, timeless = true, scale = 0.7, color = colors.WOO2DARK })
Spell( 12042 ,{ name = "신비의 마법 강화", duration = 15, group = "buffs", color = colors.PINK })

end

if class == "PRIEST" then

Spell( 15487 ,{ name = "침묵", duration = 5, color = colors.PINK })

Spell({ 14743, 27828 } ,{ name = "집중력", shine = true, duration = 6, effect = "FIRESHOT", color = colors.PURPLE4, group = "buffs" })
Cast({ 15407, 17311, 17312, 17313, 17314, 18807 }, { name = "정신의 채찍", short = "", priority = 13, tick = 1, overlay = {"tick", "tickend"}, color = colors.PURPLE2, priority = 11, duration = 3, scale = 0.8 })
Spell({ 10797, 19296, 19299, 19302, 19303, 19304, 19305 }, { name = "별조각", duration = 6, priority = 9, color = colors.CHIM })
Spell({ 2944, 19276, 19277, 19278, 19279, 19280 }, { name = "파멸의 역병", duration = 24, priority = 9, color = colors.PURPLE4 })

Spell({ 453, 8192, 10953 }, { name = "평정", duration = 15, color = colors.PURPLE5 })

Spell({ 9484, 9485, 10955 }, { name = "언데드 속박", glowtime = 5, nameplates = true, color = colors.PURPLE3, ghost = 1, ghosteffect = "SLICENDICE",
    duration = function(timer)
        if timer.spellID == 9484 then return 30
        elseif timer.spellID == 9485 then return 40
        else return 50 end
    end
}) -- varies
Spell( 10060, { name = "마력 주입", duration = 15, group = "buffs", color = colors.TEAL2 })
-- make charged to 20?
Spell({ 588, 602, 1006, 7128, 10951, 10952 }, { name = "내면의 열정", duration = 600, priority = -100, color = colors.GOLD, scale = 0.7 })
Spell({ 17, 592, 600, 3747, 6065, 6066, 10898, 10899, 10900, 10901 }, { name = "신의 권능: 보호막", short = "보호막", shinerefresh = true, duration = 30, color = colors.LRED })
Spell( 552 , { name = "질병 해제", tick = 5, tickshine = true, overlay = {"tick", "end"}, duration = 20, scale = 0.5, color = colors.BROWN })

Spell({ 14914, 15261, 15262, 15263, 15264, 15265, 15266, 15267 }, { name = "신성한 불꽃", color = colors.PINK, duration = 10, ghost = true })
Spell({ 139, 6074, 6075, 6076, 6077, 6078, 10927, 10928, 10929, 25315 }, { name = "소생", shinerefresh = true, color = colors.LGREEN, duration = 15,  scale = 0.8  })
Spell({ 586, 9578, 9579, 9592, 10941, 10942 }, { name = "소실", duration = 10, scale = 0.6, shine = true, color = colors.CHILL })
Cooldown( 8092, { name = "정신 분열", priority = 9, color = colors.CURSE, ghosteffect = "MAGICCAST", ghost = true })

Spell({ 8122, 8124, 10888, 10890 }, { name = "영혼의 절규", duration = 8, shine = true, multiTarget = true })
Spell({ 589, 594, 970, 992, 2767, 10892, 10893, 10894 }, { name = "어둠의 권능: 고통", short = "고통", ghost = true, nameplates = true, priority = 8, color = colors.PURPLE,
    duration = function(timer, opts)
        local duration = 18
        -- Improved SWP, 2 ranks: Increases the duration of your Shadow Word: Pain spell by 3 sec.
        return duration + 3*Talent(15275, 15317)
    end
 }) -- varies by talents

Spell( 15269 ,{ name = "의식 상실", duration = 3, shine = true, color = colors.PURPLE3 })
-- Cast( 15407, { name = "Mind Flay", short = "", priority = 12, tick = 1, overlay = {"tick", "tickend"}, color = colors.PURPLE2, priority = 11, duration = 3, scale = 0.8 })
-- Spell( 15258 ,{ name = "Shadow Vulnerability", short = "Vulnerability", duration = 15, scale = 0.5, priority = -10, glowtime = 4, ghost = true, ghosteffect = "GOUGE", color = colors.DPURPLE })
Spell( 15286 ,{ name = "흡혈의 선물", duration = 60, priority = 5, shinerefresh = true, ghost = true, ghosteffect = "GOUGE", color = colors.PURPLE4 })
Spell( 14751 ,{ name = "내면의 집중력", shine = true, duration = 15, group = "buffs", priority = -12, timeless = true, scale = 0.7, color = colors.WOO2DARK })

end

if class == "ROGUE" then
Interrupt({ 1766, 1767, 1768, 1769 }, "발차기", 5)

Spell( 18425 ,{ name = "발차기 침묵", duration = 2, color = colors.PINK }) -- Improved Kick

-- Premedi doesn't work because UnitAura scan kills it
-- Spell( 14183 ,{ name = "Premeditation", duration = 10, group = "buffs", color = colors.CURSE })

Spell( 13750 ,{ name = "아드레날린 촉진", group = "buffs", priority = -5, duration = 15, color = colors.LRED })
Spell( 13877 ,{ name = "폭풍의 칼날", group = "buffs", priority = -4, duration = 15, color = colors.PURPLE5 })

-- TODO: Premeditation timer

Spell( 1833 , { name = "비열한 습격", duration = 4, color = colors.LRED })
Spell({ 2070, 6770, 11297 }, { name = "기정시키기", color = colors.LBLUE, glowtime = 5, ghost = 1, ghosteffect = "SLICENDICE",
    duration = function(timer)
        if timer.spellID == 6770 then return 25 -- yes, Rank 1 spell id is 6770 actually
        elseif timer.spellID == 2070 then return 35
        else return 45 end
    end
}) -- varies
Spell( 2094 , { name = "실명", duration = 10, color = colors.WOO })

Spell({ 11327, 11329 }, { name = "소멸", duration = 10, group = "buffs", scale = 0.5, color = colors.BLACK })

Spell({ 8647, 8649, 8650, 11197, 11198 }, { name = "약점 노출", duration = 30, color = colors.WOO2 })
Spell({ 703, 8631, 8632, 8633, 11289, 11290 }, { name = "목조르기", color = colors.PINK3, duration = 18 })
Spell({ 408, 8643 }, { name = "급소 가격", shine = true, color = colors.LRED,
    duration = function(timer)
        local duration = timer.spellID == 8643 and 1 or 0 -- if Rank 2, add 1s
        return duration + GetCP()
    end,
}) -- varies
Spell({ 1943, 8639, 8640, 11273, 11274, 11275 }, { name = "파열", tick = 2, tickshine = true, overlay = {"tick", "end"}, shine = true, color = colors.RED,
    duration = function() return (6 + GetCP()*2) end,
}) -- varies
Spell({ 5171, 6774 }, { name = "난도질", shinerefresh = true, color = colors.PURPLE,
    duration = function(timer)
        local mul = 1 + 0.15*Talent(14165, 14166, 14167)
        return (6 + GetCP()*3)*mul
    end
}) -- varies

Spell({ 2983, 8696, 11305 }, { name = "전력 질주", group = "buffs", shine = true, duration = 8 })
Spell( 5277 ,{ name = "회피", group = "buffs", color = colors.PINK, duration = 15 })
Spell({ 1776, 1777, 8629, 11285, 11286 }, { name = "후려치기", shine = true, color = colors.PINK3,
    duration = function(timer)
        return 4 + 0.5*Talent(13741, 13793, 13792)
    end
})

Spell( 14177 ,{ name = "냉혈", shine = true, duration = 15, group = "buffs", priority = -12, timeless = true, scale = 0.7, color = colors.DTEAL })
Spell({ 14143, 14149 }, { name = "냉혹함", group = "buffs", scale = 0.75, duration = 20, color = colors.TEAL3 })
Cooldown( 14251, { name = "반격", color = colors.DBROWN, scale = 0.8 })
Activation( 14251, { for_cd = true, effect = "FIRESHOT", ghost = 6 })

Cooldown( 14278, { name = "그림자 일격", color = colors.WOO, ghost = true, scale_until = 5, })

EventTimer({ event = "SPELL_CAST_SUCCESS", spellID = 1725, name = "혼란", color = colors.WOO2DARK, duration = 10 })

end

if class == "WARRIOR" then
Interrupt({ 6552, 6554 }, "자루 공격", 4)
Interrupt({ 72, 1671, 1672 }, "방패 가격", 6)

Spell( 18498 ,{ name = "침묵", duration = 3, color = colors.PINK }) -- Improved Shield Bash

Spell( 20230 ,{ name = "보복", group = "buffs", shine = true, duration = 15, color = colors.PINK })
Spell( 1719 ,{ name = "무모한 희생", group = "buffs", shine = true, duration = 15, color = colors.REJUV })
Spell( 871, { name = "방패의 벽", group = "buffs", shine = true, duration = 10, color = colors.WOO }) -- varies
Spell( 12976, { name = "최후의 저항", group = "buffs", color = colors.PURPLE3, duration = 20, priority = -8 })
Spell( 12328, { name = "죽음의 소원", group = "buffs", shine = true, duration = 30, color = colors.PINKIERED })

Spell({ 772, 6546, 6547, 6548, 11572, 11573, 11574 }, { name = "분쇄", tick = 3, tickshine = true, overlay = {"tick", "end"}, color = colors.RED, ghost = true,
    duration = function(timer)
        if timer.spellID == 772 then return 9
        elseif timer.spellID == 6546 then return 12
        elseif timer.spellID == 6547 then return 15
        elseif timer.spellID == 6548 then return 18
        else return 21 end
    end
}) -- varies
Spell({ 1715, 7372, 7373 }, { name = "무력화", ghost = true, color = colors.PURPLE4, duration = 15 })
Spell( 23694 , { name = "무력화 연마", shine = true, color = colors.BLACK, duration = 5 }) -- Improved Hamstring

Spell({ 694, 7400, 7402, 20559, 20560 }, { name = "도발의 일격", color = colors.LRED, duration = 6, shine = true })
Spell( 1161 ,{ name = "도전의 외침", duration = 6, multiTarget = true })
Spell( 355 ,{ name = "도발", duration = 3 })

Cooldown( 7384, { name = "제압", shine = true, priority = 9, color = colors.TEAL3, priority = 7, isknowncheck = function() return GetShapeshiftForm() ~= 2 end })
Activation( 7384, { for_cd = true, effect = "FIRESHOT", ghost = 5 })

Cooldown( 1680, { name = "소용돌이", ghost = true, color = colors.PINKIERED, priority = 9.5 })
Spell({ 6343, 8198, 8204, 8205, 11580, 11581 }, { name = "천둥벼락", multiTarget = true, color = colors.DBLUE, scale = 0.6, affiliation = "raid",
    duration = function(spellID)
        if spellID == 6343 then return 10
        elseif spellID == 8198 then return 14
        elseif spellID == 8204 then return 18
        elseif spellID == 8205 then return 22
        elseif spellID == 11580 then return 26
        else return 30 end
    end
}) -- Thunder Clap
-- Cooldown( 6343, { name = "Thunder Clap", ghost = 1, scale = 0.8, color = colors.PINKIERED, priority = 9.5 })
Spell({ 5242, 6192, 6673, 11549, 11550, 11551, 25289 }, { name = "전투의 외침", ghost = 7, target = "player", scale_until = 20, priority = -300, effect = "BLOODBOIL", effecttime = 10, glowtime = 10, affiliation = "raid", color = colors.DPURPLE, duration = 120 })
Spell({ 1160, 6190, 11554, 11555, 11556 }, { name = "사기의 외침", duration = 30, scale = 0.85, color = colors.DTEAL, affiliation = "raid", multiTarget = true, shinerefresh = true })
Spell( 18499, { name = "광전사의 격노", color = colors.REJUV, shine = true, scale = 0.6, group = "buffs", duration = 10 })
Spell({ 20253, 20614, 20615 }, { name = "봉쇄 기절", duration = 3, shine = true, color = colors.DRED })

Spell( 12323, { name = "날카로운 고함", multiTarget = true, duration = 6, color = colors.DBROWN })
Spell( 20511 ,{ name = "위협의 외침", duration = 8, priority = -1 }) -- Main Target
Spell( 5246 ,{ name = "위협의 외침", duration = 8, priority = -1.1, scale = 0.5, color = colors.PURPLE4, multiTarget = true }) -- AoE Fear


Spell( 676 ,{ name = "무장 해제", color = colors.PINK3, scale = 0.8, shine = true,
    duration = function(timer)
        return 10 + Talent(12313, 12804, 12807)
    end,
}) -- varies
-- Spell( 29131 ,{ name = "Bloodrage", color = colors.WOO, duration = 10, scale = 0.5, shine = true })

Cooldown( 6572 ,{ name = "복수", priority = 5, color = colors.PURPLE, resetable = true, fixedlen = 6, isknowncheck = function() return GetShapeshiftForm() == 2 end })
Activation( 6572, { for_cd = true, effect = "FIRESHOT", ghost = 5 })
-- There's no spell activation overlay in classic, so using SPELL_UPDATE_USABLE to emulate it

Spell( 12798 , { name = "복수 기절", duration = 3, shine = true, color = colors.DRED })

Spell( 2565 ,{ name = "방패 막기", color = colors.WOO2, shine = true, group = "buffs", shinerefresh = true, priority = - 9, duration = 5, arrow = colors.LGREEN }) -- varies BUFF
Cooldown( 2565 ,{ name = "방패 막기", priority = 9.9, scale = 0.5, ghost = true, color = colors.DPURPLE })

Cooldown( 23922, { name = "방패 밀쳐내기", short = "방밀", priority = 10, fixedlen = 6, ghost = true, ghosteffect = "MAGICCAST", color = colors.CURSE, isknowncheck = function() return IsPlayerSpell(23922) end })
Cooldown( 12294, { name = "죽음의 일격", priority = 10, short = "죽격", fixedlen = 6, ghost = true, ghosteffect = "MAGICCAST",  color = colors.CURSE, isknowncheck = function() return IsPlayerSpell(12294) end })
Cooldown( 23881, { name = "피의 갈증", priority = 10, short = "피갈", fixedlen = 6, ghost = true, ghosteffect = "MAGICCAST",  color = colors.CURSE, isknowncheck = function() return IsPlayerSpell(23881) end })

-- Make Charges?
Spell({ 7386, 7405, 8380, 11596, 11597 }, { name = "방어구 가르기", duration = 30, color = colors.DBROWN })
Spell( 12809 ,{ name = "충격의 일격", color = colors.TEAL2, shine = true, duration = 5 })
Spell( 12292 ,{ name = "휩쓸기 일격", group = "buffs", shine = true, priority = -100503, color = colors.LRED, duration = 20, scale = 0.8 })
Spell({ 12880, 14201, 14202, 14203, 14204 }, { name = "격노", color = colors.PURPLE4, shine = true, shinerefresh = true, scale = 1, group = "buffs", priority = -3, duration = 12 })
Spell({ 12966, 12967, 12968, 12969, 12970 }, { name = "질풍", color = colors.PURPLE5, shinerefresh = true, shine = true, scale = 0.7, group = "buffs", priority = -1, duration = 15 })

end


local effects = {}
effects["UNHOLY"] = {
    path = "spells/enchantments/skullballs.m2",
    scale = 4,
    x = -6, y = -2,
}
effects["PURPLESWIPE"] = {
    path = "spells/enchantments/shaman_purple.m2",
    scale = 4,
    x = -10, y = -3,
}
effects["FIRESHOT"] = {
    path = "spells/fireshot_missile.m2",
    scale = 5,
    x = -3, y = -4,
}
effects["GOUGE"] = {
    path = "spells/Gouge_precast_state_hand.m2",
    scale = 5,
    x = -4, y = 0,
}
effects["MAGICCAST"] = {
    path = "spells/magic_cast_hand.m2",
    scale = 3,
    x = -12, y = -1,
}
effects["LIGHTNING"] = {
    path = "spells/lightning_precast_low_hand.m2",
    scale = 5,
    x = -1, y = 0,
}
effects["BACKSTAB"] = {
    path = "spells/backstab_impact_chest.m2",
    scale = 3,
    x = -5, y = -2,
}
effects["SLICENDICE"] = {
    path = "spells/slicedice_impact_chest.m2",
    scale = 3,
    x = -8, y = 0,
}
effects["BLOODBOIL"] = {
    path = "spells/bloodboil_impact_chest.m2",
    scale = 3.5,
    x = -4, y = -8,
}
NugRunningConfig.effects = effects

local FEAR = "FEAR"
local SILENCE = "SILENCE"
local INCAP = "INCAP"
local STUN = "STUN"
local HORROR = "HORROR"
local OPENER_STUN = "OPENER_STUN"
local RANDOM_STUN = "RANDOM_STUN"
local RANDOM_ROOT = "RANDOM_ROOT"
local FROST_SHOCK = "FROST_SHOCK"
local ROOT = "ROOT"

helpers.DR_TypesPVE = {
    [OPENER_STUN] = true,
    [STUN] = true,
}

helpers.DR_CategoryBySpellID = {
    -- Silences weren't on DR until 3.0.8
    -- Are random stuns even diminished at all among themselves?
    -- Random roots?

    [20549] = STUN, -- War Stomp
    [16566] = ROOT, -- Net-o-Matic

    [5782] = FEAR, -- Fear 3 ranks
    [6213] = FEAR,
    [6215] = FEAR,
    [5484] = FEAR, -- Howl of Terror 2 ranks
    [17928] = FEAR,
    [6358] = FEAR, -- Seduction

    -- [24259] = SILENCE, -- Spell Lock

    -- Coil wasn't on DR in classic
    -- [6789]    = HORROR, -- Death Coil 3 ranks
    -- [17925]   = HORROR,
    -- [17926]   = HORROR,
    [22703] = STUN, -- Infernal Summon Stun


    [20066] = INCAP, -- Repentance

    [853] = STUN, -- Hammer of Justice 4 ranks
    [5588] = STUN,
    [5589] = STUN,
    [10308] = STUN,

    [20170] = RANDOM_STUN, -- Seal of Justice Stun



    [3355] = INCAP, -- Freezing Trap Effect 3 ranks
    [14308] = INCAP,
    [14309] = INCAP,

    [19386] = INCAP, -- Wyvern Sting 3 ranks
    [24132] = INCAP,
    [24133] = INCAP,

    -- [19503] = NONE, -- Scatter Shot
    [19229] = RANDOM_ROOT, -- Improved Wing Clip Root

    [19306] = ROOT, -- Counterattack

    [19410] = RANDOM_STUN, -- Conc stun
    [24394] = STUN, -- Intimidation


    [2637] = INCAP, -- Hibernate 3 ranks
    [18657] = INCAP,
    [18658] = INCAP,

    [5211] = STUN, -- Bash 3 ranks
    [6798] = STUN,
    [8983] = STUN,

    [339] = ROOT, -- Entangling Roots 6 ranks
    [1062] = ROOT,
    [5195] = ROOT,
    [5196] = ROOT,
    [9852] = ROOT,
    [9853] = ROOT,
    [16922] = RANDOM_STUN, -- Improved Starfire

    -- Pounce wasn't on the same DR with Cheap Shot until 3.1.0
    [9005] = STUN, -- Pounce 3 ranks
    [9823] = STUN,
    [9827] = STUN,


    -- [18469] = SILENCE, -- Silence (Improved Counterspell)

    [118] = INCAP, -- Polymorph 7 variants
    [12824] = INCAP,
    [12825] = INCAP,
    [12826] = INCAP,
    [28270] = INCAP,
    [28271] = INCAP,
    [28272] = INCAP,

    -- Frostbite wasn't on DR until 2.1.0
    -- [12494] = RANDOM_ROOT, -- Frostbite
    [12355] = RANDOM_STUN, -- Impact

    [122] = ROOT, -- Frost Nova 4 rank
    [865] = ROOT,
    [6131] = ROOT,
    [10230] = ROOT,

    [8056] = FROST_SHOCK, -- Frost Shock 4 ranks
    [8058] = FROST_SHOCK,
    [10472] = FROST_SHOCK,
    [10473] = FROST_SHOCK,


    -- [15487] = SILENCE, -- Silence (Priest)
    [15269] = RANDOM_STUN, -- Blackout

    -- MIND CONTROL ???
    -- No Undeads for Shackle in classic

    [8122] = FEAR, -- Psychic Scream
    [8124] = FEAR,
    [10888] = FEAR,
    [10890] = FEAR,


    -- [18425] = SILENCE, -- Imp Kick
    [1833] = OPENER_STUN, -- Cheap Shot
    -- Blind wasn't on Fear until some time in 3.0, and before that it was with Cyclone,
    -- and in classic probably with itself
    -- [2094] = FEAR, -- Blind

    [2070] = INCAP, -- Sap 3 ranks
    [6770] = INCAP,
    [11297] = INCAP,

    [1776] = INCAP, -- Gouge 5 ranks
    [1777] = INCAP,
    [8629] = INCAP,
    [11285] = INCAP,
    [11286] = INCAP,

    [408] = STUN, -- Kidney Shot 2 ranks
    [8643] = STUN,

    [5530] = RANDOM_STUN, -- Mace Spec Stun, shared by both Rogue and Warrior


    -- [18498] = SILENCE, -- Imp Shield Bash Silence
    [23694] = RANDOM_ROOT, -- Improved Hamstring Root

    -- Disarm wasn't on DR until 2.3.0
    -- [676] = "DISARM", -- Disarm

    [12809] = STUN, -- Concussion Blow
    [12798] = RANDOM_STUN, -- Improved Revenge
    [5246] = FEAR, -- Intimidating Shout
    [7922] = STUN, -- Charge

    [20253] = STUN, -- Intercept Stun 3 ranks
    [20614] = STUN,
    [20615] = STUN,
}
