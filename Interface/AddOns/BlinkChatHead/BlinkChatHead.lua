-------------------------------------------------------------------------------
--
--  Mod Name : Blink Chat Header
--  Author   : Blink
--  Date     : 2004/10/11
--  LastUpdate : 2008/03/14
--
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------

local VERSION = 2.4
local DATAFORMAT = 3
local addon = {}
local modName = "BlinkChatHead"
_G[modName] = addon
addon.version = VERSION

local types = {
	{"SAY", BLINK_CHAT_HEAD_SAY},
	{"WHISPER", BLINK_CHAT_HEAD_WHISPER},
	{"YELL", BLINK_CHAT_HEAD_YELL},
	{"GUILD", BLINK_CHAT_HEAD_GUILD},
	{"PARTY", BLINK_CHAT_HEAD_PARTY},
	{"CHANNEL", BLINK_CHAT_HEAD_CHANNEL},
	{"RAID", BLINK_CHAT_HEAD_RAID},
	{"RAID_WARNING", BLINK_CHAT_HEAD_RAID_WARNING},
	{"RAID_LEADER", BLINK_CHAT_HEAD_RAID_LEADER},
	{"INSTANCE_CHAT", BLINK_CHAT_HEAD_INSTANCE_CHAT},
	{"INSTANCE_CHAT_LEADER", BLINK_CHAT_HEAD_INSTANCE_CHAT_LEADER},
	{"INSTANCE_CHAT", BLINK_CHAT_HEAD_INSTANCE_CHAT},
}

-- PagerMessagePrefix is variable of Pager.
local PagerMessagePrefix = getglobal("PagerMessagePrefix")

-- overriding function
local OriginalSendChatMessage = nil
local tonumber = tonumber
local strsplit = strsplit
local tinsert = table.insert
local tremove = table.remove

BCH_BM_TYPE = "ALL"
BCH_BM_CURRENT_CHAT_HEAD = ""

-------------------------------------------------------------------------------
-- print
-------------------------------------------------------------------------------
local function print(msg)
	ChatFrame1:AddMessage(msg, 1.0, 1.0, 0.2)
end


-------------------------------------------------------------------------------
function addon:OnLoad()
	BCH_DATA = {}
	self.frame = CreateFrame("Frame")
	self.frame:RegisterEvent("VARIABLES_LOADED")
	self.frame:SetScript("OnEvent", function ()
		if ( not BCH_VERSION_INFO or BCH_VERSION_INFO < DATAFORMAT ) then
			BCH_DATA = {}
			BCH_VERSION_INFO = DATAFORMAT
		end
		self:RegistGUI()
		-- easter egg ^^
		self:InsertIcon({"블링크","blink"}, "Interface\\ChatFrame\\UI-ChatIcon-Blizz.blp")
	end)
	
	-- hook
	OriginalSendChatMessage = SendChatMessage
	SendChatMessage = BCH_SendChatMessage

	-- slash command
	SlashCmdList["CHAT_HEAD"] = function(msg)
		local ctype, head = strsplit(" ", msg, 2)
		if(ctype:len() <= 0) then
			print(BLINK_CHAT_HEAD_DESC)
		else
			self:SetChatHead(ctype, head)
		end
	end
	for i=1, #BLINK_CHATHEAD_COMMAND do
		setglobal("SLASH_CHAT_HEAD"..i, BLINK_CHATHEAD_COMMAND[i])
	end

	SlashCmdList["CHAT_HEAD_LIST"] = function(msg)
		self:PrintList()
	end
	for i=1, #BLINK_CHATHEAD_LIST_COMMAND do
		setglobal("SLASH_CHAT_HEAD_LIST"..i, BLINK_CHATHEAD_LIST_COMMAND[i])
	end

	SlashCmdList["CALCULATOR"] = function(msg)
		self:Calculator(msg)
	end
	setglobal("SLASH_CALCULATOR1", "/계산")
end


-- hook SendChatMessage function ----------------------------------------------

function BCH_SendChatMessage( text, ctype, lang, ... )

	if( text == nil ) then
		return;
	end
	local head = ""
	if ( BCH_DATA ) then
		if( ctype == "WHISPER" and BCH_DATA["WHISPER"] )then
			if( PagerMessagePrefix == nil or strsub(text, 1, strlen(PagerMessagePrefix)) ~= PagerMessagePrefix ) then
				head = BCH_DATA["WHISPER"]
			end
		elseif ( ctype == "CHANNEL" ) then
			if( addon:IsBaseChannel( select(1,...) ) ) then
				head = BCH_DATA["CHANNEL"]
			elseif BCH_DATA["CUSTOMCHANNEL"] then
				local channelNum, channelName = GetChannelName(select(1,...))
				head = BCH_DATA["CUSTOMCHANNEL"][channelName] or ""
			end
		else
			head = BCH_DATA[ctype] or ""
		end

		if( head ) then
			text = head .. text
		end
	end
	OriginalSendChatMessage( text, ctype, lang , ...)
end


-- ////////////////////////////////////////////////////////////////////////////

function addon:SetChatHead( ctype, headmsg , silence)
	if( ctype == nil ) then
		if ( not silence ) then
			print(BLINK_CHAT_HEAD_DESC)
		end
		return
	end

	if( headmsg == nil or headmsg:trim() == "" ) then
		headmsg = nil
		headmsg_desc = BLINK_CHAT_HEAD_EMPTY
	else
		headmsg_desc = headmsg
	end

	local function inTable(t,v)
		for idx, value in pairs(t) do
			if ( idx == v or value[1] == v or value[2] == v ) then
				return true;
			end
		end
		return false;
	end

	if ctype:upper() == "ALL" or ctype == BLINK_CHAT_HEAD_ALL then
		for i=1, #types do
			self:SetData(types[i][1], headmsg)
			if ( not silence ) then
				print( BLINK_CHAT_HEAD_OK:format(types[i][2], headmsg_desc) )
			end
		end
		if BCH_DATA["CUSTOMCHANNEL"] then
			for c, h in pairs(BCH_DATA["CUSTOMCHANNEL"]) do
				if ( self:InChannel(c) ) then
					self:SetData(c, headmsg, true)
					if ( not silence ) then
						print( BLINK_CHAT_HEAD_CHANNEL_OK:format(c, headmsg_desc) )
					end
				else
					self:SetData(c, nil, true)
				end
			end
		end
		return
	end

	for i=1, #types do
		for j=1, #types[i] do
			if( types[i][j] == ctype:upper() ) then
				self:SetData(types[i][1], headmsg)
				if ( not silence ) then
					print( BLINK_CHAT_HEAD_OK:format(types[i][2], headmsg_desc) )
				end
				return
			end
		end
	end

	if ( self:InChannel(ctype) ) then
		self:SetData(ctype, headmsg, true)
		if ( not silence ) then
			print( BLINK_CHAT_HEAD_CHANNEL_OK:format(ctype, headmsg_desc) )
		end
		return
	end

	self:SetData(ctype, nil)
	self:SetData(ctype, nil, true)
	if ( not silence ) then
		print( BLINK_CHAT_HEAD_DESC )
	end
end

function addon:PrintList()
	local function inTable(t,v)
		for idx,value in pairs(t) do
			if ( idx == v or value[1] == v or value[2] == v ) then
				return true
			end
		end
		return false
	end

	for i=1, #types do
		local head
		if not BCH_DATA or not BCH_DATA[types[i][1]] or BCH_DATA[types[i][1]] == "" then
			head = BLINK_CHAT_HEAD_EMPTY
		else
			head = BCH_DATA[types[i][1]]
		end
		print( BLINK_CHATHEAD_LIST:format(types[i][2], head) )
	end
	if BCH_DATA and BCH_DATA["CUSTOMCHANNEL"] then
		for k, v in pairs(BCH_DATA["CUSTOMCHANNEL"]) do
			print(BLINK_CHATHEAD_LIST_CHANNEL:format(k, v))
		end
	end
end

function addon:Calculator(msg)
	local origHandler = geterrorhandler()
	seterrorhandler(function (msg)
		print("잘못된 계산식입니다.")
	end)
	msg = "local answer="..msg..";if answer then SendChatMessage(\"계산: "..msg.."\",\"SAY\");SendChatMessage(\"결과: \"..answer,\"SAY\") end"
	RunScript(msg)
	seterrorhandler(origHandler)
end

function addon:IsBaseChannel(cn)
	local channelNum, channelName = GetChannelName(cn)
	local ret = false
	if channelNum > 0 and channelName then
		for i=1, #BLINK_CHAT_HEAD_BASE_CHANNELS do
			if( channelName:find(BLINK_CHAT_HEAD_BASE_CHANNELS[i]) ) then
				return true
			end
		end
	end
	return false
end

function addon:InChannel(cn)
	for i = 1, 10, 1 do
		local channelNum, channelName = GetChannelName(i)
		if ( channelName == cn ) then
			return true
		end
	end
	return false
end

function addon:SetData(ctype, head, isChannel)
	if ( not BCH_DATA ) then
		BCH_DATA = {}
	end
	if isChannel then
		if ( not BCH_DATA["CUSTOMCHANNEL"] ) then
			BCH_DATA["CUSTOMCHANNEL"] = {}
		end
		BCH_DATA["CUSTOMCHANNEL"][ctype] = head
	else
		BCH_DATA[ctype] = head
	end
end

function addon:InsertIcon(name, icon)
	if ICON_LIST and ICON_TAG_LIST then
		if name and icon then
			tinsert(ICON_LIST, "|T"..icon..":")
			if type(name)=='table' then
				for i=1, #name do
					ICON_TAG_LIST[name[i]:lower()] = #ICON_LIST
				end
			else
				ICON_TAG_LIST[name:lower()] = #ICON_LIST
			end
		end
	end
end

function addon:RegistGUI()
	if _G.BlinkConfig then
		local tooltip_tag = "|n{별} => |TInterface\\TargetingFrame\\UI-RaidTargetingIcon_1:0|t|n"
		tooltip_tag = tooltip_tag .. "{동그라미} => |TInterface\\TargetingFrame\\UI-RaidTargetingIcon_2:0|t|n"
		tooltip_tag = tooltip_tag .. "{다이야몬드} => |TInterface\\TargetingFrame\\UI-RaidTargetingIcon_3:0|t|n"
		tooltip_tag = tooltip_tag .. "{세모} => |TInterface\\TargetingFrame\\UI-RaidTargetingIcon_4:0|t|n"
		tooltip_tag = tooltip_tag .. "{달} => |TInterface\\TargetingFrame\\UI-RaidTargetingIcon_5:0|t|n"
		tooltip_tag = tooltip_tag .. "{네모} => |TInterface\\TargetingFrame\\UI-RaidTargetingIcon_6:0|t|n"
		tooltip_tag = tooltip_tag .. "{가위표} => |TInterface\\TargetingFrame\\UI-RaidTargetingIcon_7:0|t|n"
		tooltip_tag = tooltip_tag .. "{해골} => |TInterface\\TargetingFrame\\UI-RaidTargetingIcon_8:0|t"
		_G.BlinkConfig:RegisterOptions{
			name = "말머리",
			type = "root",
			command = {"말머리설정","chatheadconfig"},
			options = {
				{
					type = "description",
					text = "블링크의 말머리 애드온",
					fontobject = "QuestTitleFont",
					r = 1,
					g = 0.82,
					b = 0,
					justifyH = "LEFT",
				},
				{
					type = "description",
					text = "채팅 종류별로 자동으로 말머리를 붙여줍니다.",
					fontobject = "ChatFontNormal",
					justifyH = "LEFT",
					justifyV = "TOP",
				},
				{
					type = "group",
					options = {
						{
							type = "string",
							text = "전체 말머리",
							tooltip = "모든 채팅말머리를 일괄적으로 입력합니다.",
							fontobject = "ChatFontNormal",
							titleR = 1,
							titleG = .82,
							titleB = 0,
							get = function ()
								return ""
							end,
							set = function (value)
								self:SetChatHead("ALL", value)
							end,
							needRefresh = true,
							--allowBlank = true,
						},
						{
							type = "string",
							text = "일반대화 말머리",
							tooltip = "일반대화창의 말머리를 입력합니다."..tooltip_tag,
							fontobject = "ChatFontNormal",
							titleR = function () return ChatTypeInfo["SAY"].r end,
							titleG = function () return ChatTypeInfo["SAY"].g end,
							titleB = function () return ChatTypeInfo["SAY"].b end,
							get = function ()
								return BCH_DATA["SAY"]
							end,
							set = function (value)
								self:SetChatHead("SAY", value)
							end,
							allowBlank = true,
						},
						{
							type = "string",
							text = "귓말 말머리",
							tooltip = "귓말의 말머리를 입력합니다."..tooltip_tag,
							fontobject = "ChatFontNormal",
							titleR = function () return ChatTypeInfo["WHISPER"].r end,
							titleG = function () return ChatTypeInfo["WHISPER"].g end,
							titleB = function () return ChatTypeInfo["WHISPER"].b end,
							get = function ()
								return BCH_DATA["WHISPER"]
							end,
							set = function (value)
								self:SetChatHead("WHISPER", value)
							end,
							allowBlank = true,
						},
						{
							type = "string",
							text = "외침 말머리",
							tooltip = "외침의 말머리를 입력합니다."..tooltip_tag,
							fontobject = "ChatFontNormal",
							titleR = function () return ChatTypeInfo["YELL"].r end,
							titleG = function () return ChatTypeInfo["YELL"].g end,
							titleB = function () return ChatTypeInfo["YELL"].b end,
							get = function ()
								return BCH_DATA["YELL"]
							end,
							set = function (value)
								self:SetChatHead("YELL", value)
							end,
							allowBlank = true,
						},
						{
							type = "string",
							text = "채널 말머리",
							tooltip = "일반채널(1.공개 2.거래 3.수비 4.파티찾기)의 말머리를 입력합니다.",
							fontobject = "ChatFontNormal",
							titleR = function () return ChatTypeInfo["CHANNEL"].r end,
							titleG = function () return ChatTypeInfo["CHANNEL"].g end,
							titleB = function () return ChatTypeInfo["CHANNEL"].b end,
							get = function ()
								return BCH_DATA["CHANNEL"]
							end,
							set = function (value)
								self:SetChatHead("CHANNEL", value)
							end,
							allowBlank = true,
						},
						{
							show = function ()
								return IsInGuild()
							end,
							type = "string",
							text = "길드 말머리",
							tooltip = "길드대화창의 말머리를 입력합니다."..tooltip_tag,
							fontobject = "ChatFontNormal",
							titleR = function () return ChatTypeInfo["GUILD"].r end,
							titleG = function () return ChatTypeInfo["GUILD"].g end,
							titleB = function () return ChatTypeInfo["GUILD"].b end,
							get = function ()
								return BCH_DATA["GUILD"]
							end,
							set = function (value)
								self:SetChatHead("GUILD", value)
							end,
							allowBlank = true,
						},
						{
							type = "string",
							text = "파티 말머리",
							tooltip = "파티대화창의 말머리를 입력합니다."..tooltip_tag,
							fontobject = "ChatFontNormal",
							titleR = function () return ChatTypeInfo["PARTY"].r end,
							titleG = function () return ChatTypeInfo["PARTY"].g end,
							titleB = function () return ChatTypeInfo["PARTY"].b end,
							get = function ()
								return BCH_DATA["PARTY"]
							end,
							set = function (value)
								self:SetChatHead("PARTY", value)
							end,
							allowBlank = true,
						},
						{
							type = "string",
							text = "공격대 말머리",
							tooltip = "공격대대화창의 말머리를 입력합니다."..tooltip_tag,
							fontobject = "ChatFontNormal",
							titleR = function () return ChatTypeInfo["RAID"].r end,
							titleG = function () return ChatTypeInfo["RAID"].g end,
							titleB = function () return ChatTypeInfo["RAID"].b end,
							get = function ()
								return BCH_DATA["RAID"]
							end,
							set = function (value)
								self:SetChatHead("RAID", value)
							end,
							allowBlank = true,
						},
						{
							type = "string",
							text = "공격대 경보 말머리",
							tooltip = "공격대 경보의 말머리를 입력합니다."..tooltip_tag,
							fontobject = "ChatFontNormal",
							titleR = function () return ChatTypeInfo["RAID_WARNING"].r end,
							titleG = function () return ChatTypeInfo["RAID_WARNING"].g end,
							titleB = function () return ChatTypeInfo["RAID_WARNING"].b end,
							get = function ()
								return BCH_DATA["RAID_WARNING"]
							end,
							set = function (value)
								self:SetChatHead("RAID_WARNING", value)
							end,
							allowBlank = true,
						},
						{
							type = "string",
							text = "공격대장 말머리",
							tooltip = "공격대장의 말머리를 입력합니다."..tooltip_tag,
							fontobject = "ChatFontNormal",
							titleR = function () return ChatTypeInfo["RAID_LEADER"].r end,
							titleG = function () return ChatTypeInfo["RAID_LEADER"].g end,
							titleB = function () return ChatTypeInfo["RAID_LEADER"].b end,
							get = function ()
								return BCH_DATA["RAID_LEADER"]
							end,
							set = function (value)
								self:SetChatHead("RAID_LEADER", value)
							end,
							allowBlank = true,
						},
						{
							type = "string",
							text = "인던 말머리",
							tooltip = "인던 말머리를 입력합니다."..tooltip_tag,
							fontobject = "ChatFontNormal",
							titleR = function () return ChatTypeInfo["INSTANCE_CHAT"].r end,
							titleG = function () return ChatTypeInfo["INSTANCE_CHAT"].g end,
							titleB = function () return ChatTypeInfo["INSTANCE_CHAT"].b end,
							get = function ()
								return BCH_DATA["INSTANCE_CHAT"]
							end,
							set = function (value)
								self:SetChatHead("INSTANCE_CHAT", value)
							end,
							allowBlank = true,
						},
						{
							type = "string",
							text = "인던리더 말머리",
							tooltip = "인던리더 말머리를 입력합니다."..tooltip_tag,
							fontobject = "ChatFontNormal",
							titleR = function () return ChatTypeInfo["INSTANCE_CHAT_LEADER"].r end,
							titleG = function () return ChatTypeInfo["INSTANCE_CHAT_LEADER"].g end,
							titleB = function () return ChatTypeInfo["INSTANCE_CHAT_LEADER"].b end,
							get = function ()
								return BCH_DATA["INSTANCE_CHAT_LEADER"]
							end,
							set = function (value)
								self:SetChatHead("INSTANCE_CHAT_LEADER", value)
							end,
							allowBlank = true,
						},
						--[[{
							type = "string",
							text = "전장 말머리",
							tooltip = "전장 말머리를 입력합니다."..tooltip_tag,
							fontobject = "ChatFontNormal",
							titleR = function () return ChatTypeInfo["BATTLEGROUND"].r end,
							titleG = function () return ChatTypeInfo["BATTLEGROUND"].g end,
							titleB = function () return ChatTypeInfo["BATTLEGROUND"].b end,
							get = function ()
								return BCH_DATA["BATTLEGROUND"]
							end,
							set = function (value)
								self:SetChatHead("BATTLEGROUND", value)
							end,
							allowBlank = true,
						},
						{
							type = "string",
							text = "전장지휘관 말머리",
							tooltip = "전장 지휘관 말머리를 입력합니다."..tooltip_tag,
							fontobject = "ChatFontNormal",
							titleR = function () return ChatTypeInfo["BATTLEGROUND_LEADER"].r end,
							titleG = function () return ChatTypeInfo["BATTLEGROUND_LEADER"].g end,
							titleB = function () return ChatTypeInfo["BATTLEGROUND_LEADER"].b end,
							get = function ()
								return BCH_DATA["BATTLEGROUND_LEADER"]
							end,
							set = function (value)
								self:SetChatHead("BATTLEGROUND_LEADER", value)
							end,
							allowBlank = true,
						},]]
					},
				},
				{
					type = "group",
					text = "입장한 사설 채널목록",
					fontobject = "QuestTitleFont",
					titleR = 1,
					titleG = .82,
					titleB = 0,
					options = function ()
						local opt = {}
						local count = 0
						for i = 1, 10, 1 do
							local channelNum, channelName = GetChannelName(i)
							if channelNum>0 and channelName then
								if ( not self:IsBaseChannel(channelName) ) then
									count = count + 1
									tinsert(opt, {
										type = "string",
										text = count..". "..channelName.."채널 말머리",
										tooltip = channelName.."채널 말머리를 설정합니다.",
										fontobject = "ChatFontNormal",
										titleR = function () return ChatTypeInfo["CHANNEL"..channelNum].r end,
										titleG = function () return ChatTypeInfo["CHANNEL"..channelNum].g end,
										titleB = function () return ChatTypeInfo["CHANNEL"..channelNum].b end,
										get = function ()
											return BCH_DATA["CUSTOMCHANNEL"] and BCH_DATA["CUSTOMCHANNEL"][channelName] or ""
										end,
										set = function (value)
											if not BCH_DATA["CUSTOMCHANNEL"] then
												BCH_DATA["CUSTOMCHANNEL"] = {}
											end
											BCH_DATA["CUSTOMCHANNEL"][channelName] = value
										end,
										allowBlank = true,
									})
								end
							end
						end
						if #opt == 0 then
							tinsert(opt, {
								type = "description",
								text = "입장한 사설채널이 없습니다",
							})
						end
						return opt
					end,
				},
			},
		}
	end
end

addon:OnLoad()
