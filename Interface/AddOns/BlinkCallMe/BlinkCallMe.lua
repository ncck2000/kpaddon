-------------------------------------------------------------------------------
--
--  Title      : 나를 불러주세요~
--  Version    : 2.1
--  Author     : Blink
--  Date       : 2005/03/26
--  LastUpdate : 2014/11/16
--
-------------------------------------------------------------------------------

local frame

local onEvent
local display
local registGUI

local tinsert = table.insert
local tremove = table.remove

local bScroll = LibStub and LibStub("LibScroller-1.0")
local outputFormat = "[%s]: %s"
local tempName = false
local tempName2 = false
local defaultDB = {
	callme = {
		enable = true,
		display = "default",
		names = {},
		exceptChannels = {},
	},
	whosaid = {
		enable = true,
		display = "default",
		who = {},
	},
}
local tcopy
local function playSoundFor(soundPath)
	if soundPath then
		if type(soundPath)=="string" and ((string.sub(soundPath, -4) == ".wav") or (string.sub(soundPath, -4) == ".mp3") or (string.sub(soundPath, -4) == ".ogg")) then
			PlaySoundFile(soundPath)
		elseif type(soundPath)=="number" then
			PlaySound(soundPath)
		end
	end
end
function tcopy(to, from) -- "to" must be a table (possibly empty)
	for k,v in pairs(from) do
		if(type(v)=="table") then
			if not to then to = {} end
			to[k] = {}
			tcopy(to[k], v)
		else
			to[k] = v
		end
	end
end
function checkName(msg)
	if ( msg:find(UnitName("player")) ) then
		return true
	else
		for i=1, #bcmDB.callme.names do
			if( msg:find(bcmDB.callme.names[i]) )then
				return true
			end
		end
	end
end
function onEvent(self, event, ...)
	local arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9 = ...
	if event == "PLAYER_ENTERING_WORLD" then
		if not bcmDB then
			bcmDB = {}
			tcopy(bcmDB, defaultDB)
		end
		if not bcmDB.callme then
			bcmDB.callme = {}
			tcopy(bcmDB.callme, defaultDB.callme)
		end
		if not bcmDB.whosaid then
			bcmDB.whosaid = {}
			tcopy(bcmDB.whosaid, defaultDB.whosaid)
		end
		if bcmDB.callme.enable or bcmDB.whosaid.enable then
			self:RegisterEvent("CHAT_MSG_CHANNEL")
			self:RegisterEvent("CHAT_MSG_SAY")
			self:RegisterEvent("CHAT_MSG_PARTY")
			self:RegisterEvent("CHAT_MSG_YELL")
			self:RegisterEvent("CHAT_MSG_RAID")
			self:RegisterEvent("CHAT_MSG_RAID_WARNING")
			self:RegisterEvent("CHAT_MSG_RAID_LEADER")
			self:RegisterEvent("CHAT_MSG_GUILD")
			self:RegisterEvent("CHAT_MSG_MONSTER_SAY")
			self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
			self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")
		end
		registGUI()
		return
	end

	local showCallMe
	local showWhosaid

	local n, s = strmatch(arg2, "^([^-]+)-(.*)")
	local server
	if ( n ) then
		arg2 = n
		server = s
	end

	if bcmDB.whosaid.enable then
		for i=1, #bcmDB.whosaid.who,1 do
			if( event ~= "CHAT_MSG_RAID_WARNING" and arg2 == bcmDB.whosaid.who[i] )then
				showWhosaid = true
			end
		end
	end

	if bcmDB.callme.enable then
		if ( event == "CHAT_MSG_CHANNEL" ) then
			if bcmDB.callme.exceptChannels[arg8] then
				showCallMe = false
			else
				showCallMe = checkName(arg1)
			end
		else
			showCallMe = checkName(arg1)
		end
	end

	if (showCallMe or showWhosaid) and arg2~=UnitName("player") then
	--if (showCallMe or showWhosaid) then
		local chattypes = _G.ChatTypeInfo
		if( event == "CHAT_MSG_CHANNEL" )then
			if chattypes["CHANNEL"..arg8] then
				color = chattypes["CHANNEL"..arg8]
			else
				color = chattypes["CHANNEL"]
			end
		else
			local ct = strsub(event, 10)
			if chattypes[ct] then
				color = chattypes[ct]
			else
				color = chattypes["SAY"]
			end
		end

		if showCallMe then
			display(outputFormat:format(arg2, arg1), bcmDB.callme.display, "Interface\\AddOns\\BlinkCallMe\\BlinkCallMe.mp3", color)
		end
		if showWhosaid then
			display(outputFormat:format(arg2, arg1), bcmDB.whosaid.display, SOUNDKIT.RAID_WARNING, color)
		end
	end
end

function display(msg, panel, sound, color)
	if panel == "bScroll" and bScroll then
		bScroll:Display(
			'action', 'text',
			'message', msg,
			'r', color.r,
			'g', color.g,
			'b', color.b,
			'textsize', 18,
			'type', 'up',
			'font', "Fonts\\2002b.TTF"
		)
	elseif panel == "sct" and SCT and SCT.CmdDisplay then
		SCT:DisplayText(msg, color, true, "event", 1)
	elseif panel == "msbt" and MikSBT and MikSBT.DisplayMessage then
		MikSBT.DisplayMessage(msg, MikSBT.DISPLAYTYPE_NOTIFICATION, false, color.r*255, color.g*255, color.b*255, nil, nil, 1)
	elseif panel == "parrot" and Parrot and Parrot.ShowMessage then
		Parrot:ShowMessage(msg, nil, nil, color.r, color.g, color.b)
	elseif panel == "raidwarning" and RaidNotice_AddMessage then
		RaidNotice_AddMessage(RaidWarningFrame, msg, color)
	elseif panel == "blizzard" and SHOW_COMBAT_TEXT=="1" and CombatText_AddMessage then
		CombatText_AddMessage(msg, CombatText_StandardScroll, color.r, color.g, color.b)
	else
		if( UIErrorsFrame )then
			UIErrorsFrame:AddMessage(msg, color.r, color.g, color.b, 1.0, UIERRORS_HOLD_TIME)
		end
	end
	playSoundFor(sound)
end

function registGUI()
	if _G.BlinkConfig then
		_G.BlinkConfig:RegisterOptions{
			name = "나를 불러주세요",
			type = "root",
			command = {"나를불러주세요","callme"},
			options = {
				{
					type = "description",
					text = "블링크의 나를불러주세요",
					fontobject = "QuestTitleFont",
					r = 1,
					g = 0.82,
					b = 0,
					justifyH = "LEFT",
				},
				{
					type = "description",
					text = "채팅창에 등록한 이름이 나오면 소리를 내어 알려줍니다.",
					fontobject = "ChatFontNormal",
					justifyH = "LEFT",
					justifyV = "TOP",
				},
				{
					type = "toggle",
					text = "사용",
					tooltip = "나를 불러주세요 애드온을 사용합니다.",
					get = function ()
						return bcmDB.callme.enable
					end,
					set = function (value)
						bcmDB.callme.enable = value
						if bcmDB.callme.enable and not bcmDB.whosaid.enable then
							frame:RegisterEvent("CHAT_MSG_CHANNEL")
							frame:RegisterEvent("CHAT_MSG_SAY")
							frame:RegisterEvent("CHAT_MSG_PARTY")
							frame:RegisterEvent("CHAT_MSG_YELL")
							frame:RegisterEvent("CHAT_MSG_RAID")
							frame:RegisterEvent("CHAT_MSG_RAID_WARNING")
							frame:RegisterEvent("CHAT_MSG_RAID_LEADER")
							frame:RegisterEvent("CHAT_MSG_GUILD")
							frame:RegisterEvent("CHAT_MSG_MONSTER_SAY")
							frame:RegisterEvent("CHAT_MSG_MONSTER_YELL")
							frame:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")
						elseif not bcmDB.callme.enable and not bcmDB.whosaid.enable then
							frame:UnregisterEvent("CHAT_MSG_CHANNEL")
							frame:UnregisterEvent("CHAT_MSG_SAY")
							frame:UnregisterEvent("CHAT_MSG_PARTY")
							frame:UnregisterEvent("CHAT_MSG_YELL")
							frame:UnregisterEvent("CHAT_MSG_RAID")
							frame:UnregisterEvent("CHAT_MSG_RAID_WARNING")
							frame:UnregisterEvent("CHAT_MSG_RAID_LEADER")
							frame:UnregisterEvent("CHAT_MSG_GUILD")
							frame:UnregisterEvent("CHAT_MSG_MONSTER_SAY")
							frame:UnregisterEvent("CHAT_MSG_MONSTER_YELL")
							frame:UnregisterEvent("CHAT_MSG_MONSTER_EMOTE")
						end
					end,
					needRefresh = true,
				},
				{
					type = "radio",
					text = "출력패널",
					tooltip = "나를 부르는 메세지를 출력할 곳을 선택합니다.",
					values = function ()
						local opt = {}
						tinsert(opt, { text = "기본", value = "default", fontobject = "ChatFontNormal", })
						tinsert(opt, { text = "기본 전투메세지", value = "blizzard", fontobject = "ChatFontNormal", disable = function () return not (SHOW_COMBAT_TEXT=="1" and CombatText_AddMessage) end, })
						tinsert(opt, { text = "공격대 경보", value = "raidwarning", fontobject = "ChatFontNormal", disable = function () return not RaidNotice_AddMessage end, })
						tinsert(opt, { text = "블링크 스크롤러", value = "bScroll", fontobject = "ChatFontNormal", disable = function () return not bScroll end, })
						tinsert(opt, { text = "sct", value = "sct", fontobject = "ChatFontNormal", disable = function () return not (SCT and SCT.CmdDisplay) end, })
						tinsert(opt, { text = "MikSBT", value = "msbt", fontobject = "ChatFontNormal", disable = function () return not (MikSBT and MikSBT.DisplayMessage) end, })
						tinsert(opt, { text = "Parrot", value = "parrot", fontobject = "ChatFontNormal", disable = function () return not (Parrot and Parrot.ShowMessage) end, })
						return opt
					end,
					get = function ()
						return bcmDB.callme.display
					end,
					set = function (value)
						bcmDB.callme.display = value
					end,
					disable = function ()
						return not bcmDB.callme.enable
					end,
					col = 4,
				},
				{
					type = "multiselect",
					text = "난빼줘 채널",
					tooltip = "선택한 채널에서의 나를불러줘는 작동하지 않습니다.",
					values = function ()
						local opt = {}
						tinsert(opt, { text = "1. 공개", value=1, fontobject = "ChatFontNormal", titleR = function () return ChatTypeInfo["CHANNEL1"].r end, titleG = function () return ChatTypeInfo["CHANNEL1"].g end, titleB = function () return ChatTypeInfo["CHANNEL1"].b end, })
						tinsert(opt, { text = "2. 거래", value=2, fontobject = "ChatFontNormal", titleR = function () return ChatTypeInfo["CHANNEL2"].r end, titleG = function () return ChatTypeInfo["CHANNEL2"].g end, titleB = function () return ChatTypeInfo["CHANNEL2"].b end, })
						tinsert(opt, { text = "3. 수비", value=3, fontobject = "ChatFontNormal", titleR = function () return ChatTypeInfo["CHANNEL3"].r end, titleG = function () return ChatTypeInfo["CHANNEL3"].g end, titleB = function () return ChatTypeInfo["CHANNEL3"].b end, })
						tinsert(opt, { text = "4. 파티찾기", value=4, fontobject = "ChatFontNormal", titleR = function () return ChatTypeInfo["CHANNEL4"].r end, titleG = function () return ChatTypeInfo["CHANNEL4"].g end, titleB = function () return ChatTypeInfo["CHANNEL4"].b end, })
						for i = 4, 10, 1 do
							local channelNum, channelName = GetChannelName(i)
							if channelNum>0 and channelName then
								tinsert(opt, {
									text = channelNum..". "..channelName,
									value = channelNum,
									fontobject = "ChatFontNormal",
									titleR = function () return ChatTypeInfo["CHANNEL"..channelNum].r end,
									titleG = function () return ChatTypeInfo["CHANNEL"..channelNum].g end,
									titleB = function () return ChatTypeInfo["CHANNEL"..channelNum].b end,
								})
							end
						end
						return opt
					end,
					get = function ()
						return bcmDB.callme.exceptChannels
					end,
					set = function (value)
						bcmDB.callme.exceptChannels = value
					end,
					disable = function ()
						return not bcmDB.callme.enable
					end,
					col = 4,
				},
				{
					type = "group",
					text = "목록",
					options = function ()
						local opt = {}
						tinsert(opt, {
							type = "execute",
							text = "이름 추가",
							tooltip = "이름을 추가합니다.",
							func = function ()
								tempName = true
							end,
							needRefresh = true,
							buttonwidth = 100,
						})
						for i=1, #bcmDB.callme.names do
							tinsert(opt, {
								type = "string",
								get = function ()
									return bcmDB.callme.names[i]
								end,
								set = function (value)
									if not value or value:trim() == "" then
										tremove(bcmDB.callme.names, i)
									else
										bcmDB.callme.names[i] = value
									end
								end,
								needRefresh = true,
								allowBlank = true,
							})
						end
						if tempName then
							tinsert(opt, {
								type = "string",
								get = function ()
									return ""
								end,
								set = function (value)
									if not value or value == "" then
										tempName = true
									else
										tinsert(bcmDB.callme.names, value)
										tempName = false
									end
								end,
								needRefresh = true,
								allowBlank = true,
							})
						end

						return opt
					end,
				},
			},
			children = {
				{
					type = "root",
					name = "누가말하나?",
					command = {"누가말하나","whosaid"},
					options = {
						{
							type = "description",
							text = "블링크의 누가말하나?",
							fontobject = "QuestTitleFont",
							r = 1,
							g = 0.82,
							b = 0,
							justifyH = "LEFT",
						},
						{
							type = "description",
							text = "등록한 이름의 플레이어가 말을 하면 소리를 내어 알려줍니다.",
							fontobject = "ChatFontNormal",
							justifyH = "LEFT",
							justifyV = "TOP",
						},
						{
							type = "toggle",
							text = "사용",
							tooltip = "누가말하나? 애드온을 사용합니다.",
							get = function ()
								return bcmDB.whosaid.enable
							end,
							set = function (value)
								bcmDB.whosaid.enable = value
								if bcmDB.whosaid.enable and not bcmDB.callme.enable then
									frame:RegisterEvent("CHAT_MSG_CHANNEL")
									frame:RegisterEvent("CHAT_MSG_SAY")
									frame:RegisterEvent("CHAT_MSG_PARTY")
									frame:RegisterEvent("CHAT_MSG_YELL")
									frame:RegisterEvent("CHAT_MSG_RAID")
									frame:RegisterEvent("CHAT_MSG_RAID_WARNING")
									frame:RegisterEvent("CHAT_MSG_RAID_LEADER")
									frame:RegisterEvent("CHAT_MSG_GUILD")
									frame:RegisterEvent("CHAT_MSG_MONSTER_SAY")
									frame:RegisterEvent("CHAT_MSG_MONSTER_YELL")
									frame:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")
								elseif not bcmDB.whosaid.enable and not bcmDB.callme.enable then
									frame:UnregisterEvent("CHAT_MSG_CHANNEL")
									frame:UnregisterEvent("CHAT_MSG_SAY")
									frame:UnregisterEvent("CHAT_MSG_PARTY")
									frame:UnregisterEvent("CHAT_MSG_YELL")
									frame:UnregisterEvent("CHAT_MSG_RAID")
									frame:UnregisterEvent("CHAT_MSG_RAID_WARNING")
									frame:UnregisterEvent("CHAT_MSG_RAID_LEADER")
									frame:UnregisterEvent("CHAT_MSG_GUILD")
									frame:UnregisterEvent("CHAT_MSG_MONSTER_SAY")
									frame:UnregisterEvent("CHAT_MSG_MONSTER_YELL")
									frame:UnregisterEvent("CHAT_MSG_MONSTER_EMOTE")
								end
							end,
							needRefresh = true,
						},
						{
							type = "radio",
							text = "출력패널",
							tooltip = "누가 말하는지 메세지를 출력할 곳을 선택합니다.",
							values = function ()
								local opt = {}
								tinsert(opt, { text = "기본", value = "default", fontobject = "ChatFontNormal", })
								tinsert(opt, { text = "기본 전투메세지", value = "blizzard", fontobject = "ChatFontNormal", disable = function () return not (SHOW_COMBAT_TEXT=="1" and CombatText_AddMessage) end, })
								tinsert(opt, { text = "공격대 경보", value = "raidwarning", fontobject = "ChatFontNormal", disable = function () return not RaidNotice_AddMessage end, })
								tinsert(opt, { text = "블링크 스크롤러", value = "bScroll", fontobject = "ChatFontNormal", disable = function () return not bScroll end, })
								tinsert(opt, { text = "sct", value = "sct", fontobject = "ChatFontNormal", disable = function () return not (SCT and SCT.CmdDisplay) end, })
								tinsert(opt, { text = "MikSBT", value = "msbt", fontobject = "ChatFontNormal", disable = function () return not (MikSBT and MikSBT.DisplayMessage) end, })
								tinsert(opt, { text = "Parrot", value = "parrot", fontobject = "ChatFontNormal", disable = function () return not (Parrot and Parrot.ShowMessage) end, })
								return opt
							end,
							get = function ()
								return bcmDB.whosaid.display
							end,
							set = function (value)
								bcmDB.whosaid.display = value
							end,
							disable = function ()
								return not bcmDB.whosaid.enable
							end,
							col = 4,
						},
						{
							type = "group",
							text = "목록",
							options = function ()
								local opt = {}
								tinsert(opt, {
									type = "execute",
									text = "플레이어 이름 추가",
									tooltip = "말할때 소리내어 알려줄 플레이어의 이름을 추가합니다.",
									func = function ()
										tempName2 = true
									end,
									needRefresh = true,
								})
								for i=1, #bcmDB.whosaid.who do
									tinsert(opt, {
										type = "string",
										get = function ()
											return bcmDB.whosaid.who[i]
										end,
										set = function (value)
											if not value or value == "" then
												tremove(bcmDB.whosaid.who, i)
											else
												bcmDB.whosaid.who[i] = value
											end
										end,
										needRefresh = true,
										allowBlank = true,
									})
								end
								if tempName2 then
									tinsert(opt, {
										type = "string",
										get = function ()
											return ""
										end,
										set = function (value)
											if not value or value == "" then
												tempName2 = true
											else
												tinsert(bcmDB.whosaid.who, value)
												tempName2 = false
											end
										end,
										needRefresh = true,
										allowBlank = true,
									})
								end

								return opt
							end,
						},

					},
				},
			},
		}
	end
end

frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:SetScript("OnEvent", onEvent)
