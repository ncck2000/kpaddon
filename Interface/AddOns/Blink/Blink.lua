
local addon = {}
local modName = "BlinkConfig"
_G[modName] = addon

local addons = {}
local commands = {}

local tinsert = table.insert
local tremove = table.remove

local getArgs, tmp, new, del, gettext, getfunc, gettable, getbool, getvalue, showhide, disable
do
	local cache = setmetatable({},{__mode='k'})
	function new()
		local t = next(cache)
		if t then
			cache[t] = nil
			return t
		else
			return {}
		end
	end
	function del(t)
		for k in pairs(t) do
			t[k] = nil
		end
		cache[t] = true
		return nil
	end

	local t = {}
	function tmp(...)
		for k in pairs(t) do
			t[k] = nil
		end
		for i = 1, select('#', ...), 2 do
			local k = select(i, ...)
			if k then
				t[k] = select(i+1, ...)
			else
				break
			end
		end
		return t
	end
	local info = {}
	function getArgs(...)
		if type(select(1,...))=='table' then
			info = select(1,...)
		else
			info = tmp(...)
		end
		return info
	end
	function getbool(value)
		if type(value)=='boolean' then
			return value
		elseif type(value)=='function' then
			return value()
		end
	end
	function getvalue(value)
		if type(value)=='function' then
			return value()
		else
			return value
		end
	end
	function gettext(text)
		if type(text)=='string' then
			return text
		elseif type(text)=='function' then
			return text()
		end
	end
	function gettable(t)
		if type(t)=='table' then
			return t
		elseif type(t)=='function' then
			return t()
		end
	end
	function getfunc(func)
		if func and type(func)=='function' then
			return func
		elseif func and type(func)=='string' then
			local f = getglobal(func)
			if f and type(f)=='function' then
				return f
			end
		end
	end
	function showhide(frame, showhideValue)
		if showhideValue then
			if getbool(showhideValue) then
				frame:Show()
			else
				frame:Hide()
			end
		else
			frame:Show()
		end
	end
	function disable(frame, disableValue)
		if disableValue then
			if getbool(disableValue) then
				frame.disable()
			else
				frame.enable()
			end
		end
	end
end

local function digit2(num)
	num = (num + 0.05) * 10
	num = math.floor(num)
	return num/10
end
local function copyTable(src)
	local dest = {}
	for k, v in pairs(src) do
		if type(v)=='table' then
			dest[k] = copyTable(v)
		else
			dest[k] = v
		end
	end
	return dest
end

local function hexToDec(hex)
	if not hex or string.len(hex)~=8 then
		return 1, 1, 1, 1
	end
	local r = hex:sub(1, 2)
	local g = hex:sub(3, 4)
	local b = hex:sub(5, 6)
	local a = hex:sub(7, 8)
	r = tonumber(r, 16) / 255
	g = tonumber(g, 16) / 255
	b = tonumber(b, 16) / 255
	a = tonumber(a, 16) / 255
	return r, g, b, a
end
local function FloatToText(r, g, b, a)
	if ( type (r) == "table" and r.r and r.g and r.b ) then
		r, g, b, a = r.r, r.g, r.b, (r.a or 1.0)
	end
	if ( r > 1 ) then r = 1.0 end
	if ( g > 1 ) then g = 1.0 end
	if ( b > 1 ) then b = 1.0 end
	if ( a > 1 ) then a = 1.0 end
	local newR, newG, newB, newA = math.floor(r * 255), math.floor(g * 255), math.floor(b * 255), math.floor(a * 255)
	local fmt = "%.2x"

	return string.format(fmt, newR )..string.format(fmt, newG )..string.format(fmt, newB )..string.format(fmt, newA )
end

local function findSuper(frame)
	if frame.super then
		return findSuper(frame.super)
	end
	return frame
end

local nextIsTarget
local function editboxHandleTabbing(frame, editbox, startSuper)
	if not frame or not editbox then return end
	local _frame
	if startSuper then
		_frame = findSuper(frame)
		_frame.isTopSuper = true
	else
		_frame = frame
	end

	if IsShiftKeyDown() then
		for i=#_frame.controls, 1, -1 do
			if _frame.controls[i]:IsShown() then
				if _frame.controls[i].type == "group" and _frame.controls[i].enabled then
					if editboxHandleTabbing(_frame.controls[i], editbox) then
						return true
					end
				elseif (_frame.controls[i].type == 'string' or _frame.controls[i].type == 'range') and _frame.controls[i].enabled then
					if nextIsTarget then
						_frame.controls[i].edit:SetFocus()
						return true
					end
					if _frame.controls[i]==editbox then
						nextIsTarget = true
					end
				end
			end
		end
	else
		for i=1, #_frame.controls do
			if _frame.controls[i]:IsShown() then
				if _frame.controls[i].type == "group" and _frame.controls[i].enabled then
					if editboxHandleTabbing(_frame.controls[i], editbox) then
						return true
					end
				elseif (_frame.controls[i].type == 'string' or _frame.controls[i].type == 'range') and _frame.controls[i].enabled then
					if nextIsTarget then
						_frame.controls[i].edit:SetFocus()
						return true
					end
					if _frame.controls[i]==editbox then
						nextIsTarget = true
					end
				end
			end
		end
	end
	if _frame.isTopSuper and editboxHandleTabbing(_frame, editbox) then
		_frame.isTopSuper = nil
		return true
	end
end

function addon:RegisterOptions(opt)
	if not opt then
		return
	end
	local o = gettable(opt)
	if not o.name then
		return
	end
	if addons[o.name] then
		return
	end

	local newAddon = CreateFrame("FRAME")
	newAddon:SetParent(InterfaceOptionsFramePanelContainer)
	newAddon.controls = {}
	if o.parent and addons[o.parent] then
		newAddon.parent = o.parent
	end
	
	newAddon:SetScript("OnShow", function (obj)
		if not obj.panel then
			local padding = 8
			obj.panel = addon:CreateScrollFrame{
				parent = obj,
				options = o.options,
				padding = padding,
				width = obj:GetParent():GetWidth() - 32,
				height = obj:GetParent():GetHeight() - 10,
				scrollBarHideable = true,
			}
		end
		obj.panel.refresh()
	end)

	newAddon.name = o.name
	addons[o.name] = newAddon
	InterfaceOptions_AddCategory(addons[o.name])
	if o.command and type(o.command)=='table' then
		local tempName = o.name:gsub("[ \\!@#%*;'\":%$%%%^&%?%.%(%)%[%]]","_")
		SlashCmdList[tempName] = function (msg)
			--InterfaceOptionsFrame_OpenToFrame(o.name)
			InterfaceOptionsFrame_OpenToCategory(o.name)
		end

		commands[o.name] = {}
		local count = 1
		for k, v in pairs(o.command) do
			setglobal("SLASH_"..tempName..count, "/"..v)
			tinsert(commands[o.name], v)
			count = count + 1
		end
	elseif o.command and type(o.command)=='string' then
		local tempName = o.name:gsub("[ \\!@#%*;'\":%$%%%^&%?%.%(%)%[%]]","_")
		SlashCmdList[tempName] = function (msg)
			InterfaceOptionsFrame_OpenToCategory(o.name)
		end
		setglobal("SLASH_"..tempName.."1", "/"..o.command)
		commands[o.name] = o.command
	end

	if not o.parent and o.children then
		for i=1, #o.children do
			o.children[i].parent = o.name
			self:RegisterOptions(o.children[i])
		end
	end
end

SlashCmdList["BLINK"] = function (msg)
	if msg and commands[msg:trim()] then
		InterfaceOptionsFrame_OpenToCategory(msg:trim())
		return
	end
	--print("블링크 설정 애드온 v1.3")
	local text = ""
	for addonname, cmds in pairs(commands) do
		if type(cmds)=="table" then
			for i=1, #cmds do
				if text == "" then
					text = "/"..cmds[i]
				else
					text = text..", /"..cmds[i]
				end
			end
			text = "   |cff00ff00"..addonname.."|r : "..text
		else
			text = "   |cff00ff00"..addonname.."|r : /"..cmds
		end
		print(text)
		text = ""
	end
end
setglobal("SLASH_BLINK1", "/blink")
setglobal("SLASH_BLINK2", "/블링크")

local frame_count = 1
function addon:GetBorder(a)
	if not a then return end
	if not a.name then
		a.name = "blink_options_frame_"..frame_count
		frame_count = frame_count + 1
	end
	local frame = CreateFrame("Frame", a.name, a.parent)
	frame:SetWidth(a.width or a.parent:GetWidth()-20)
	frame:SetHeight(a.height or 20)
	
	local childbg = frame:CreateTexture(nil,"BACKGROUND")
	childbg:SetAllPoints(frame)
	childbg:SetTexture(a.r or 0, a.g or 0, a.b or 0, a.a or 0)
	return frame
end
function addon:GetString(a)
	if not a then return end
	local text
	if a.obj then
		text = a.obj
		text:SetFontObject(a.fontobject)
	else
		text = a.parent:CreateFontString(nil, "OVERLAY", a.fontobject or "GameFontNormal")
	end
	if a.font then
		text:SetFont(a.font, a.size or 14, a.outline)
	elseif not a.fontobject then
		text:SetFontObject("GameFontNormalSmall")
	end
	text:SetText(gettext(a.text))
	if a.r and a.g and a.b then
		local r, g, b = getvalue(a.r), getvalue(a.g), getvalue(a.b)
		text:SetTextColor(r, g, b, getvalue(a.a) or 1)
	end
	if a.size then
		text:SetTextHeight(a.size)
	end
	if a.justifyH then
		text:SetJustifyH(a.justifyH)
	end
	if a.justifyV then
		text:SetJustifyV(a.justifyV)
	end
	text.enable = function ()
		if a.r and a.g and a.b then
			local r, g, b = getvalue(a.r), getvalue(a.g), getvalue(a.b)
			text:SetTextColor(r, g, b, getvalue(a.a) or 1)
		else
			text:SetTextColor(1, .82, 0) -- 노란색
		end
	end
	text.disable = function ()
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b)
	end
	return text
end
function addon:GetButton(a)
	if not a then return end
	local btn
	if a.isGray then
		btn = CreateFrame("Button", nil, a.parent, "UIPanelButtonGrayTemplate")
	else
		btn = CreateFrame("Button", nil, a.parent, "UIPanelButtonTemplate")
	end
	btn:SetWidth(a.width or 80)
	btn:SetHeight(a.height or 20)
	btn:SetText(gettext(a.text))
	btn:SetFrameLevel(a.parent:GetFrameLevel()+1)
	if a.tooltip then
		btn:SetScript("OnEnter", function(obj)
			GameTooltip:SetOwner(obj, "ANCHOR_BOTTOMLEFT")
			GameTooltip:SetText(gettext(a.tooltip), nil, nil, nil, nil, 1)
			GameTooltip:Show()
		end)
		btn:SetScript("OnLeave", function(obj) GameTooltip:Hide() end)
	end
	btn.disable = function ()
		btn:Disable()
	end
	btn.enable = function ()
		btn:Enable()
	end
	if a.func then
		btn:SetScript("OnClick", function (obj)
			getfunc(a.func)()
		end)
	end
	return btn
end
function addon:GetCheckButton(a)
	if not a then return end
	local btn = CreateFrame("CheckButton", nil, a.parent, "UICheckButtonTemplate")
	btn:SetWidth(26)
	btn:SetHeight(26)
	btn.text = self:GetString{
		parent = btn,
		text = a.text,
		fontobject = a.fontobject,
		font = a.font,
		outline = a.outline,
		r = a.r or 1,
		g = a.g or 1,
		b = a.b or 1,
		a = a.a or 1,
		size = a.size,
	}
	btn.text:SetPoint("LEFT", btn, "RIGHT", 0, 0)
	if a.tooltip then
		btn:SetScript("OnEnter", function(obj)
			GameTooltip:SetOwner(obj, a.anchor or "ANCHOR_BOTTOMLEFT")
			GameTooltip:SetText(gettext(a.tooltip), nil, nil, nil, nil, 1)
			GameTooltip:Show()
		end)
		btn:SetScript("OnLeave", function(obj) GameTooltip:Hide() end)
	end
	btn.enable = function ()
		btn.text.enable()
		btn:Enable()
	end
	btn.disable = function ()
		btn.text.disable()
		btn:Disable()
	end
	return btn
end
function addon:GetRadioButton(a)
	local width = a.width or 100
	local panel = self:GetBorder{
		parent = a.parent,
		width = width,
		height = a.height or 20,
--		r = .3,
--		g = .3,
--		b = .3,
--		a = .3,
	}
	panel.button = CreateFrame("CheckButton", nil, panel, "UIRadioButtonTemplate")
	panel.button:SetPoint("LEFT", 0, 0)
--	button:SetWidth(22)
--	button:SetHeight(22)
	panel.text = self:GetString{
		parent = panel,
		text = a.text,
		fontobject = a.fontobject,
		font = a.font,
		outline = a.outline,
		r = a.r or 1,
		g = a.g or 1,
		b = a.b or 1,
		a = a.a or 1,
		size = a.size,
	}
	panel.text:SetPoint("LEFT", panel.button, "RIGHT", 0, 0)

	if a.tooltip then
		panel.button:SetScript("OnEnter", function(obj)
			GameTooltip:SetOwner(obj, "ANCHOR_BOTTOMLEFT")
			GameTooltip:SetText(gettext(a.tooltip), nil, nil, nil, nil, 1)
			GameTooltip:Show()
		end)
		panel.button:SetScript("OnLeave", function(obj) GameTooltip:Hide() end)
	end

	panel.enable = function ()
		panel.text.enable()
		panel.button:Enable()
	end
	panel.disable = function ()
		panel.text.disable()
		panel.button:Disable()
	end
	return panel
end


-- Element Create functions
function addon:CreateDescription(a)
	if not a then return end
	local padding = a.padding or 5
	local width = a.width or (a.parent:GetWidth() - (padding*2))
	local panel = self:GetBorder{
		parent = a.parent,
		width = width,
		height = a.height or 20,
--		r = .3,
--		g = .3,
--		b = .3,
--		a = .3,
	}
	panel.refresh = function ()
		if not panel.text then
			panel.text = self:GetString{
				parent = panel,
				text = a.text,
				r = a.r,
				g = a.g,
				b = a.b,
				a = a.a,
				fontobject = a.fontobject,
				font = a.font,
				outline = a.outline,
				size = a.size,
				justifyH = a.justifyH,
				justifyV = a.justifyV,
			}
		else
			self:GetString{
				obj = panel.text,
				text = a.text,
				r = a.r,
				g = a.g,
				b = a.b,
				a = a.a,
				fontobject = a.fontobject,
				font = a.font,
				outline = a.outline,
				size = a.size,
				justifyH = a.justifyH,
				justifyV = a.justifyV,
			}
		end
		local stringwidth = panel.text:GetStringWidth()
		local lines = 1
		if stringwidth > width then
			lines = math.ceil(stringwidth / width)
		end
		panel:SetHeight( (panel.text:GetStringHeight()+2) * lines )
		panel.text:SetHeight(panel:GetHeight())
		panel.text:SetNonSpaceWrap(true)
		panel.text:ClearAllPoints()
		panel.text:SetPoint("TOPLEFT")
		panel.text:SetPoint("RIGHT")
		showhide(panel, a.showhide)
	end
	--panel.refresh()
	return panel
end
function addon:CreateButton(a)
	if not a then return end
	local padding = a.padding or 5
	local width = a.width or (a.parent:GetWidth() - (padding*2))
	local button = self:GetBorder{
		parent = a.parent,
		width = width,
		height = a.height,
--		r = .3,
--		g = .3,
--		b = .3,
--		a = .3,
	}
	button.enable = function ()
		button.button.enable()
		button.enabled = true
	end
	button.disable = function ()
		button.button.disable()
		button.enabled = false
	end

	button.refresh = function ()
		if not button.button then
			button.button = self:GetButton{
				parent = button,
				text = a.text,
				tooltip = a.tooltip,
				anchor = a.anchor,
				width = a.buttonwidth or 120,
				height = a.height,
				func = a.func,
			}
		else
			button.button:SetText(gettext(a.text))
		end
		if a.func then
			button.button:SetScript("OnClick", function (obj)
				getfunc(a.func)()
				if a.needRefresh then
					if a.frame and a.frame.refresh then
						a.frame.refresh()
					end
				end
			end)
		end
		button.button:SetPoint("CENTER")
		disable(button, a.disable)
		showhide(button, a.showhide)
	end

	button.type = "execute"
	button.enabled = true
	--button.refresh()
	return button
end

function addon:CreateCheckButton(a)
	if not a then return end
	local padding = a.padding or 5
	local width = a.width or (a.parent:GetWidth() - (padding*2))
	local button = self:GetBorder{
		parent = a.parent,
		width = width,
		height = a.height,
--		r = .3,
--		g = .3,
--		b = .3,
--		a = .3,
	}


	button.enable = function ()
		button.check.enable()
		button.enabled = true
	end
	button.disable = function ()
		button.check.disable()
		button.enabled = false
	end
	button.refresh = function ()
		if not button.check then
			button.check = self:GetCheckButton{
				parent = button,
				text = a.text,
				fontobject = a.fontobject,
				font = a.font,
				outline = a.outline,
				r = a.titleR,
				g = a.titleG,
				b = a.titleB,
				a = a.titleA,
				size = a.titlesize,
				tooltip = a.tooltip,
				anchor = a.anchor,
			}
		else
			self:GetString{
				obj = button.check.text,
				text = a.text,
				r = a.titleR or 1,
				g = a.titleG or 1,
				b = a.titleB or 1,
				a = a.titleA or 1,
				fontobject = a.fontobject,
				font = a.font,
				outline = a.outline,
				size = a.titlesize,
				justifyH = a.justifyH,
				justifyV = a.justifyV,
			}
		end
		if a.depth then
			button.check:SetPoint("LEFT", (a.depth*20), 0)
		else
			button.check:SetPoint("LEFT", 0, 0)
		end
		button.check:SetScript("OnClick", function (obj)
			if a.set then
				local set = getfunc(a.set)
				set(obj:GetChecked())
				if a.needRefresh then
					if a.frame and a.frame.refresh then
						a.frame.refresh()
					end
				end
			end
		end)

		button.check.text:SetText(gettext(a.text))
		if a.get then
			local get = getfunc(a.get)
			button.check:SetChecked(get() and true or false)
		else
			button.check:SetChecked(false)
		end
		disable(button, a.disable)
		showhide(button, a.showhide)
	end

	button.type = "toggle"
	button.enabled = true
	--button.refresh()
	return button
end

function addon:CreateEditBox(a)

	local padding = a.padding or 5
	local width = a.width or (a.parent:GetWidth() - (padding*2))
	local height = a.height or 20
	local buttonWidth = 50

	local panel = self:GetBorder{
		parent = a.parent,
		width = width,
		height = height,
--		r = 0,
--		g = .3,
--		b = 0,
--		a = .3,
	}
	panel.type = "string"

	panel.edit = CreateFrame("EditBox", nil, panel)
		local left = panel.edit:CreateTexture(nil, "BACKGROUND")
		left:SetPoint("LEFT", 0, 0)
		left:SetTexture("Interface\\Common\\Common-Input-Border")
		left:SetTexCoord(0, 0.0625, 0, 0.625)
		left:SetWidth(8)
		left:SetHeight(20)
		local right = panel.edit:CreateTexture(nil, "BACKGROUND")
		right:SetPoint("RIGHT", 0, 0)
		right:SetTexture("Interface\\Common\\Common-Input-Border")
		right:SetTexCoord(0.9375, 1.0, 0, 0.625)
		right:SetWidth(8)
		right:SetHeight(20)
		local middle = panel.edit:CreateTexture(nil, "BACKGROUND")
		middle:SetPoint("LEFT", left, "RIGHT")
		middle:SetPoint("RIGHT", right, "LEFT")
		middle:SetTexture("Interface\\Common\\Common-Input-Border")
		middle:SetTexCoord(0.0625, 0.9375, 0, 0.625)
		middle:SetHeight(20)
	panel.edit:SetTextColor(1,1,1)
	panel.edit:SetFontObject("ChatFontNormal")
	panel.edit:SetWidth(80) -- 임시로..
	panel.edit:SetHeight(20)
	panel.edit:SetAutoFocus(nil)
	panel.edit:SetTextInsets(5,5,0,0)

	local get = getfunc(a.get)
	local set = getfunc(a.set)
	local function ShowButton()
		panel.button:Show()
		panel.edit:SetTextInsets(5,30,0,0)
	end
	local function HideButton()
		panel.button:Hide()
		panel.edit:SetTextInsets(5,5,0,0)
	end
	panel.edit.lasttext = get()

	if a.tooltip then
		panel.edit:SetScript("OnEnter", function(obj)
			GameTooltip:SetOwner(obj, "ANCHOR_BOTTOMLEFT")
			GameTooltip:SetText(gettext(a.tooltip), nil, nil, nil, nil, 1)
			GameTooltip:Show()
		end)
		panel.edit:SetScript("OnLeave", function(obj) GameTooltip:Hide() end)
	end

	panel.edit:SetScript("OnReceiveDrag", function (obj)
		local type, id, info = GetCursorInfo()
		if type == "item" then
			panel.edit:SetText(info)
			ClearCursor()
		elseif type == "spell" then
			local name, rank = GetSpellName(id, info)
			if rank and rank:match("%d") then
				name = name.."("..rank..")"
			end
			local spelllink = GetSpellLink(id, info)
			name = name .. "("..id..")"
			if spelllink then
				name = name .. " "..spelllink
			end
			panel.edit:SetText(name)
			--ClearCursor()
		end
	end)
	panel.edit:SetScript("OnMouseDown", panel.edit:GetScript("OnReceiveDrag"))
	panel.edit:SetScript("OnTabPressed", function (obj)
		nextIsTarget = false
		editboxHandleTabbing(a.frame, panel, true)
	end)
	panel.edit:SetScript("OnEditFocusGained", panel.edit.HighlightText)
	panel.edit:SetScript("OnEditFocusLost", function(obj)
		obj:HighlightText(0,0)
	end)
	panel.edit:SetScript("OnEscapePressed", function(obj)
		if get then
			obj:SetText(get() or "")
			panel.edit.lasttext = get() or ""
		end
		HideButton()
		obj:ClearFocus()
	end)
	panel.edit:SetScript("OnEnterPressed", function(obj)
		local text = obj:GetText()
		local allowBlank = getbool(a.allowBlank)
		if (not text or text=="") and not allowBlank then
			if get then
				obj:SetText(get() or "")
			end
		else
			if set then
				set(obj:GetText())
				if a.needRefresh then
					if a.frame and a.frame.refresh then
						a.frame.refresh()
					end
				end
			end
		end
		panel.edit.lasttext = obj:GetText()
		HideButton()
		obj:ClearFocus()
	end)
	panel.edit:SetScript("OnTextChanged", function (obj)
		local value = panel.edit:GetText()
		if value ~= panel.edit.lasttext then
			panel.edit.lasttext = value
			ShowButton()
		end
	end)

	panel.button = self:GetButton{
		parent = panel.edit,
		text = "OK",
		width = 25,
		height = 20,
		tooltip = "수정한 값을 저장합니다.",
	}
	panel.button:SetPoint("RIGHT", panel.edit, "RIGHT",-2,0)
	panel.button:SetScript("OnClick", function (obj)
		panel.edit:ClearFocus()
		local f = panel.edit:GetScript("OnEnterPressed")
		f(panel.edit)
	end)
	panel.button:Hide()

	panel.enable = function ()
		panel.edit:EnableKeyboard(true)
		panel.edit:EnableMouse(true)
		panel.edit:SetTextColor(1,1,1)
		if panel.text then
			panel.text.enable()
		end
		panel.enabled = true
	end
	panel.disable = function ()
		panel.edit:EnableKeyboard(false)
		panel.edit:EnableMouse(false)
		panel.edit:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b)
		panel.edit:ClearFocus()
		if panel.text then
			panel.text.disable()
		end
		panel.enabled = false
	end

	panel.refresh = function ()
		local editWidth = 0
		if a.text then
			if not panel.text then
				panel.text = self:GetString{
					parent = panel,
					text = a.text,
					fontobject = a.fontobject,
					font = a.font,
					outline = a.outline,
					r = a.titleR,
					g = a.titleG,
					b = a.titleB,
					a = a.titleA,
					size = a.titlesize,
				}
			else
				self:GetString{
					obj = panel.text,
					text = a.text,
					fontobject = a.fontobject,
					font = a.font,
					outline = a.outline,
					r = a.titleR,
					g = a.titleG,
					b = a.titleB,
					a = a.titleA,
					size = a.titlesize,
				}
			end

			if a.wide then
				panel.text:SetPoint("TOPLEFT", panel, "TOPLEFT", 0, 0)
			else
				panel.text:SetPoint("LEFT", panel, "LEFT", 0, 0)
			end

			editWidth = width - panel.text:GetStringWidth() - 10
			if editWidth > (width/3)*2 then
				editWidth = (width/3)*2
			elseif editWidth < 70 then
				editWidth = 70
			end
			if a.wide then
				editWidth = width -- - 20
			end
		else
			editWidth = width -- 20
		end

		panel.edit:SetWidth(editWidth)
		if a.wide then
			if panel.text then
				panel:SetHeight(panel.text:GetHeight() + panel.edit:GetHeight() + 2)
				panel.edit:SetPoint("BOTTOM", panel, "BOTTOM", 0, 0)
			else
				panel.edit:SetPoint("CENTER", 0, 0)
			end
		else
			if panel.text then
				panel.edit:SetPoint("RIGHT", panel, "RIGHT", 0, 0)
			else
				panel.edit:SetPoint("CENTER", 0, 0)
			end
		end
		if get then
			panel.edit:SetText(get() or "")
			panel.edit:SetCursorPosition(0)
			panel.edit.lasttext = get() or ""
		end
		HideButton()
		disable(panel, a.disable)
		showhide(panel, a.showhide)
	end

	if a.wide and panel.text then
		panel:SetHeight(panel.text:GetHeight() + panel.edit:GetHeight()+3)
	end

	panel.enabled = true
	--panel.refresh()
	return panel
end

local sliderCount = 1
function addon:CreateSlider(a)
	local padding = a.padding or 5
	local width = a.width or (a.parent:GetWidth() - (padding*2))
	local height = a.height or 20

	local panel = CreateFrame("Frame", nil, a.parent)
	panel:SetWidth(width)
	panel:SetHeight(height)
	panel.type = "range"

	panel.text = self:GetString{
		parent = panel,
		text = a.text,
		fontobject = a.fontobject,
		font = a.font,
		outline = a.outline,
		r = a.titleR,
		g = a.titleG,
		b = a.titleB,
		a = a.titleA,
		size = a.titlesize,
	}
	panel.text:SetPoint("LEFT", panel, "LEFT", 0, 0)

	panel.edit = CreateFrame("EditBox", nil, panel)
		local left = panel.edit:CreateTexture(nil, "BACKGROUND")
		left:SetPoint("LEFT", 0, 0)
		left:SetTexture("Interface\\Common\\Common-Input-Border")
		left:SetTexCoord(0, 0.0625, 0, 0.625)
		left:SetWidth(8)
		left:SetHeight(20)
		local right = panel.edit:CreateTexture(nil, "BACKGROUND")
		right:SetPoint("RIGHT", 0, 0)
		right:SetTexture("Interface\\Common\\Common-Input-Border")
		right:SetTexCoord(0.9375, 1.0, 0, 0.625)
		right:SetWidth(8)
		right:SetHeight(20)
		local middle = panel.edit:CreateTexture(nil, "BACKGROUND")
		middle:SetPoint("LEFT", left, "RIGHT")
		middle:SetPoint("RIGHT", right, "LEFT")
		middle:SetTexture("Interface\\Common\\Common-Input-Border")
		middle:SetTexCoord(0.0625, 0.9375, 0, 0.625)
		middle:SetHeight(20)
	panel.edit:SetPoint("RIGHT", panel, "RIGHT")
	panel.edit:SetTextColor(1,1,1)
	panel.edit:SetFontObject("ChatFontNormal")
	panel.edit:SetPoint("CENTER")
	panel.edit:SetWidth(50)
	panel.edit:SetHeight(20)
	panel.edit:SetAutoFocus(nil)
	panel.edit:SetJustifyH("RIGHT")
	panel.edit:SetFrameLevel(panel:GetFrameLevel()+1)
	panel.edit:SetTextInsets(5,5,0,0)
	--panel.edit:SetNumeric(true)

	local get = getfunc(a.get)
	local set = getfunc(a.set)

	if a.tooltip then
		panel.edit:SetScript("OnEnter", function(obj)
			GameTooltip:SetOwner(obj, "ANCHOR_BOTTOMLEFT")
			GameTooltip:SetText(gettext(a.tooltip), nil, nil, nil, nil, 1)
			GameTooltip:Show()
		end)
		panel.edit:SetScript("OnLeave", function(obj) GameTooltip:Hide() end)
	end

	panel.edit:SetScript("OnTabPressed", function (obj)
		nextIsTarget = false
		editboxHandleTabbing(a.frame, panel, true)
	end)
	panel.edit:SetScript("OnEditFocusGained", panel.edit.HighlightText)
	panel.edit:SetScript("OnEditFocusLost", function(obj)
		obj:HighlightText(0,0)
		if type(tonumber(obj:GetText())) ~= "number" then
			obj:SetText(digit2(panel.slider:GetValue()))
			obj:ClearFocus()
			return
		end
		if set then
			set(tonumber(obj:GetText()))
			if a.needRefresh then
				if a.frame and a.frame.refresh then
					a.frame.refresh()
				end
			end
		end
		panel.slider:SetValue(tonumber(obj:GetText()))
	end)
	panel.edit:SetScript("OnEscapePressed", function(obj)
		if get then
			obj:SetText(get() or a.min)
			panel.slider:SetValue(get() or a.min)
		end
		obj:ClearFocus()
	end)
	panel.edit:SetScript("OnEnterPressed", function(obj)
		if type(tonumber(obj:GetText())) ~= "number" then
			obj:SetText(digit2(panel.slider:GetValue()))
			obj:ClearFocus()
			return
		end
		if set then
			set(tonumber(obj:GetText()))
			if a.needRefresh then
				if a.frame and a.frame.refresh then
					a.frame.refresh()
				end
			end
		end
		panel.slider:SetValue(tonumber(obj:GetText()))
		obj:ClearFocus()
	end)

	local slider_name
	if name then
		slider_name = name and name.."Slider"
	else
		slider_name = "blink_options_slider_"..sliderCount
		sliderCount = sliderCount + 1
	end
	local sliderWidth = width - panel.text:GetStringWidth() - 55
	if sliderWidth > (width/5)*3 then
		sliderWidth = (width/5)*3
	elseif sliderWidth < 70 then
		sliderWidth = 70
	end
	panel.slider = CreateFrame("Slider", slider_name, panel, "OptionsSliderTemplate")
	panel.slider:SetWidth(sliderWidth)
	panel.slider:SetMinMaxValues(a.min, a.max)
	panel.slider:SetValueStep(a.step or 1)
	panel.slider:SetPoint("RIGHT", panel.edit, "LEFT", -10, 0)
	panel.slider:SetScript("OnValueChanged", function (obj)
		if set then
			set(digit2(tonumber(obj:GetValue())))
			if a.needRefresh then
				if a.frame and a.frame.refresh then
					a.frame.refresh()
				end
			end
		end
		panel.edit:SetText(digit2(tonumber(obj:GetValue())))
	end)
	--getglobal(panel.slider:GetName().."Low"):Hide()
	--getglobal(panel.slider:GetName().."High"):Hide()
	if a.tooltip then
		panel.slider:SetScript("OnEnter", function(obj)
			GameTooltip:SetOwner(obj, "ANCHOR_BOTTOMLEFT")
			GameTooltip:SetText(gettext(a.tooltip), nil, nil, nil, nil, 1)
			GameTooltip:Show()
		end)
		panel.slider:SetScript("OnLeave", function(obj) GameTooltip:Hide() end)
	end

	panel.enable = function ()
		panel.edit:EnableKeyboard(true)
		panel.edit:EnableMouse(true)
		panel.edit:SetTextColor(1,1,1)
		if panel.text then
			panel.text.enable()
		end
		BlizzardOptionsPanel_Slider_Enable(panel.slider)
		panel.slider:EnableMouse(true)
		panel.enabled = true
	end
	panel.disable = function ()
		panel.edit:EnableKeyboard(false)
		panel.edit:EnableMouse(false)
		panel.edit:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b)
		panel.edit:ClearFocus()
		if panel.text then
			panel.text.disable()
		end
		BlizzardOptionsPanel_Slider_Disable(panel.slider)
		panel.slider:EnableMouse(false)
		panel.enabled = false
	end
	panel.refresh = function ()
		if get then
			panel.edit:SetText(get() or a.min)
			panel.edit:SetCursorPosition(0)
			panel.slider:SetValue(get() or a.min)
		end
		disable(panel, a.disable)
		showhide(panel, a.showhide)
	end

	panel.enabled = true
	--panel.refresh()
	return panel
end

local ddCount = 1
function addon:CreateDropdown(a)
	local padding = a.padding or 5
	local width = a.width or (a.parent:GetWidth() - (padding*2))
	local height = a.height or 20
	local panel = self:GetBorder{
		parent = a.parent,
		width = width,
		height = height,
	}
	panel.text = self:GetString{
		parent = panel,
		text = a.text,
		fontobject = a.fontobject,
		font = a.font,
		outline = a.outline,
		r = a.titleR,
		g = a.titleG,
		b = a.titleB,
		a = a.titleA,
		size = a.titlesize,
	}
	panel.text:SetPoint("LEFT", 0, 0)

	local dd_name
	if name then
		dd_name = name and name.."Dropdown"
	else
		dd_name = "blink_options_dd_"..ddCount
		ddCount = ddCount + 1
	end
	panel.dropdown = CreateFrame("Frame", dd_name, panel, "UIDropDownMenuTemplate")

	panel.button = CreateFrame("Button", nil, panel)
	panel.button:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Up")
	panel.button:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Down")
	panel.button:SetDisabledTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Disabled")
	local t = panel.button:CreateTexture(nil, "BACKGROUND")
	t:SetPoint("TOPLEFT", panel.button, "TOPLEFT", 0, 0)
	t:SetPoint("BOTTOMRIGHT", panel.button, "BOTTOMRIGHT", 0, 0)
	t:SetTexture("Interface\\Buttons\\UI-Common-MouseHilight")
	t:SetBlendMode("ADD")
	panel.button:SetHighlightTexture(t)
	panel.button:SetWidth(24)
	panel.button:SetHeight(24)
	panel.button:SetPoint("RIGHT", panel, "RIGHT", 2, 0)
	panel.button:SetScript("OnClick", function ()
		--EasyMenu(gettable(a.values), panel.dropdown, panel.button, 20, 10, "MENU")
		local function init(frame, level, menuList)
			for i=1, #menuList do
				local v = menuList[i]
				local info = UIDropDownMenu_CreateInfo()
				if not v.value and v.options then
					info.hasArrow = true
					info.text = v.text
					info.value = v.text
					info.menuList = v.options
					UIDropDownMenu_AddButton(info, level)
				else
					info.func = function (obj)
						UIDropDownMenu_SetSelectedValue(frame, obj.value, nil)
						local set = getfunc(a.set)
						if set then
							set(obj.value)
							if a.needRefresh then
								if a.frame and a.frame.refresh then
									a.frame.refresh()
								end
							end
						end
						panel.valueText:SetText(v.text)
						local f = getfunc(v.func)
						if f and type(f)=='function' then
							f(v)
						end
					end
					local checked, get
					get = getfunc(a.get)
					if get then
						checked = get() == v.value
					end
					info.checked = checked
					info.text = v.text
					info.value = v.value
					UIDropDownMenu_AddButton(info, level)
				end
			end
		end
		UIDropDownMenu_Initialize(panel.dropdown, init, "MENU", nil, gettable(a.values))
		ToggleDropDownMenu(1, nil, panel.dropdown, panel.button, 20, 10, gettable(a.values))
	end)

	panel.valueText = self:GetString{parent = panel, text = a.text, fontobject = "ChatFontNormal", r=1, g=1, b=1}
	panel.valueText:SetPoint("RIGHT", panel.button, "LEFT", -2, 0)

	panel.enable = function ()
		panel.text.enable()
		panel.valueText.enable()
		panel.button:Enable()
		panel.enabled = true
	end
	panel.disable = function ()
		panel.text.disable()
		panel.valueText.disable()
		panel.button:Disable()
		panel.enabled = false
	end

	panel.refresh = function ()
		local tvalue = gettable(a.values)
		local getted_value = getfunc(a.get)()
		if getted_value then
			for i=1, #tvalue do
				if tvalue[i].value and tvalue[i].value == getted_value then
					panel.valueText:SetText(tvalue[i].text)
					break
				elseif tvalue[i].options and type(tvalue[i].options)=='table' then
					for j=1, #tvalue[i].options do
						if tvalue[i].options[j].value and tvalue[i].options[j].value == getted_value then
							panel.valueText:SetText(tvalue[i].options[j].text)
							break
						elseif tvalue[i].options[j].options and type(tvalue[i].options[j].options)=='table' then
							for k=1, #tvalue[i].options[j].options do
								if tvalue[i].options[j].options[k].value and tvalue[i].options[j].options[k].value == getted_value then
									panel.valueText:SetText(tvalue[i].options[j].options[k].text)
									break
								end
							end
						end
					end
				end
			end
		end
		disable(panel, a.disable)
		showhide(panel, a.showhide)
	end

	panel.type = "select"
	panel.enabled = true
	--panel.refresh()
	return panel
end

function addon:CreateRadioButton(a)
	if not a.values then return end
	local padding = a.padding or 5
	local width = a.width or (a.parent:GetWidth() - (padding*2))
	local height = a.height or 20
	local panel = self:GetBorder{
		parent = a.parent,
		width = width,
		height = height,
--		r = 0,
--		g = .3,
--		b = 0,
--		a = .3,
	}
	panel.type = "radio"
	panel.controls = {}

	panel.text = self:GetString{
		parent = panel,
		text = a.text,
		size = a.size,
		fontobject = a.fontobject,
		font = a.font,
		outline = a.outline,
		r = a.titleR,
		g = a.titleG,
		b = a.titleB,
		a = a.titleA,
		size = a.titlesize,
	}
	panel.text:SetPoint("TOPLEFT", 0, 0)

	panel.rdopanel = CreateFrame("Frame", nil, panel)
	panel.rdopanel:SetWidth(panel:GetWidth())
	panel.rdopanel:SetBackdrop({
		bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		tile = true, tileSize = 16, edgeSize = 16,
		insets={left = 5, right = 5, top = 5, bottom = 5}
	})
	panel.rdopanel:SetBackdropBorderColor(.6, .6, .6, 1)
	panel.rdopanel:SetBackdropColor(.35, .35, .35, .3)
	panel.rdopanel:SetPoint("TOPLEFT", 0, -1*panel.text:GetHeight()-3)

	panel.enable = function ()
		panel.text.enable()
		if #panel.controls > 0 then
			for i=1, #panel.controls do
				if panel.controls[i] then
					if panel.controls[i]:IsShown() then
						if panel.controls[i].enable then
							panel.controls[i].enable()
						end
					end
				end
			end
		end
		panel.enabled = true
	end
	panel.disable = function ()
		panel.text.disable()
		if #panel.controls > 0 then
			for i=1, #panel.controls do
				if panel.controls[i] then
					if panel.controls[i]:IsShown() then
						if panel.controls[i].disable then
							panel.controls[i].disable()
						end
					end
				end
			end
		end
		panel.enabled = false
	end

	panel.refresh = function ()
		local col = a.col or 1
		local opt = gettable(a.values)
		local rdo
		local innerHeight = 0
		local get = getfunc(a.get)
		local set = getfunc(a.set)
		local column
		for i=1, #panel.controls do
			panel.controls[i]:Hide()
			panel.controls[i] = nil -- 메모리-_-
		end
		local innerPanelWidth = (width - 10) / col
		for i=1, #opt do
			rdo = self:GetRadioButton{
				parent = panel.rdopanel,
				text = opt[i].text,
				tooltip = opt[i].tooltip,
				fontobject = opt[i].fontobject,
				font = opt[i].font,
				outline = opt[i].outline,
				r = opt[i].r,
				g = opt[i].g,
				b = opt[i].b,
				a = opt[i].a,
				size = opt[i].size,
				width = innerPanelWidth,
				height = 20,
			}
			rdo.button.value = opt[i].value
			
			column = (i-1) % col
			if i==1 then
				rdo:SetPoint("TOPLEFT", 5, -8 )
				innerHeight = innerHeight + rdo:GetHeight() + 10
			else
				if column==0 then
					rdo:SetPoint("TOPLEFT", panel.controls[i-col], "BOTTOMLEFT", 0, -10)
					innerHeight = innerHeight + rdo:GetHeight() + 10
				else
					rdo:SetPoint("LEFT", panel.controls[#panel.controls], "LEFT", innerPanelWidth, 0)
				end
			end

			if get then
				rdo.button:SetChecked(rdo.button.value == get())
			end
			if opt[i].tooltip then
				rdo.button:SetScript("OnEnter", function(obj)
					GameTooltip:SetOwner(obj, opt[i].anchor or "ANCHOR_BOTTOMLEFT")
					GameTooltip:SetText(gettext(opt[i].tooltip), nil, nil, nil, nil, 1)
					GameTooltip:Show()
				end)
				rdo.button:SetScript("OnLeave", function(obj) GameTooltip:Hide() end)
			end
			rdo.button:SetScript("OnClick", function (obj)
				for j=1, #panel.controls do
					if panel.controls[j].button~=obj then
						panel.controls[j].button:SetChecked(nil)
					else
						panel.controls[j].button:SetChecked(true)
					end
				end
				if set then
					set(obj.value)
					if a.needRefresh then
						if a.frame and a.frame.refresh then
							a.frame.refresh()
						end
					end
				end
				local f = getfunc(opt[i].func)
				if f and type(f)=='function' then
					f()
				end
			end)

			if opt[i].deleteFunc then
				rdo.deleteButton = CreateFrame("Button", nil, panel.rdopanel, "UIPanelCloseButton")
				rdo.deleteButton:SetWidth(18)
				rdo.deleteButton:SetHeight(18)
				rdo.deleteButton:SetPoint("LEFT", rdo.text, "RIGHT", 1, 0)
				rdo.deleteButton:SetScript("OnClick", function (obj)
					local f = getfunc(opt[i].deleteFunc)
					if f and type(f)=='function' then
						f()
					end
				end)
				rdo.deleteButton:SetScript("OnEnter", function(obj)
					GameTooltip:SetOwner(obj, "ANCHOR_BOTTOMLEFT")
					GameTooltip:SetText("삭제하기", nil, nil, nil, nil, 1)
					GameTooltip:Show()
				end)
				rdo.deleteButton:SetScript("OnLeave", function(obj) GameTooltip:Hide() end)
			end
			if getbool(a.disable)==true or getbool(opt[i].disable) then
				rdo.disable()
				if rdo.deleteButton then
					rdo.deleteButton:Disable()
				end
			end

			table.insert(panel.controls, rdo)
		end
		panel.rdopanel:SetHeight(innerHeight + 5)
		panel:SetHeight(panel.rdopanel:GetHeight() + panel.text:GetHeight() + 5)

		local checkedValue
		if get then
			checkedValue = get()
		end
		for j=1, #panel.controls do
			if (panel.controls[j].button.value == checkedValue) or (panel.controls[j].button.value=="" and not checkedValue) then
				panel.controls[j].button:SetChecked(true)
			else
				panel.controls[j].button:SetChecked(nil)
			end
		end
		disable(panel, a.disable)
		showhide(panel, a.showhide)
	end
	panel.enabled = true
	--panel.refresh()
	return panel
end

function addon:CreateCheckGroupButton(a)
	if not a.values then
		return
	end
	local padding = a.padding or 5
	local width = a.width or (a.parent:GetWidth() - (padding*2))
	local height = a.height or 20
	local panel = self:GetBorder{
		parent = a.parent,
		width = width,
		height = height,
--		r = 0,
--		g = .3,
--		b = 0,
--		a = .3,
	}
	panel.type = "multiselect"
	panel.controls = {}

	panel.text = self:GetString{
		parent = panel,
		text = a.text,
		size = a.size,
		fontobject = a.fontobject,
		font = a.font,
		outline = a.outline,
		r = a.titleR,
		g = a.titleG,
		b = a.titleB,
		a = a.titleA,
		size = a.titlesize,
	}
	panel.text:SetPoint("TOPLEFT", 0, 0)

	panel.chkpanel = CreateFrame("Frame", nil, panel)
	panel.chkpanel:SetWidth(panel:GetWidth())
	panel.chkpanel:SetBackdrop({
		bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		tile = true, tileSize = 16, edgeSize = 16,
		insets={left = 5, right = 5, top = 5, bottom = 5}
	})
	panel.chkpanel:SetBackdropBorderColor(.6, .6, .6, 1)
	panel.chkpanel:SetBackdropColor(.3, .15, 0, .3)
	panel.chkpanel:SetPoint("TOPLEFT", 0, -1*panel.text:GetHeight()-3)

	panel.enable = function ()
		panel.text.enable()
		if #panel.controls > 0 then
			for i=1, #panel.controls do
				if panel.controls[i] then
					if panel.controls[i]:IsShown() then
						if panel.controls[i].enable then
							panel.controls[i].enable()
						end
					end
				end
			end
		end
		panel.enabled = true
	end
	panel.disable = function ()
		panel.text.disable()
		if #panel.controls > 0 then
			for i=1, #panel.controls do
				if panel.controls[i] then
					if panel.controls[i]:IsShown() then
						if panel.controls[i].disable then
							panel.controls[i].disable()
						end
					end
				end
			end
		end
		panel.enabled = false
	end

	panel.refresh = function ()
		local col = a.col or 1
		local opt = gettable(a.values)
		local chk
		local innerHeight = 0
		local get = getfunc(a.get)
		local set = getfunc(a.set)
		local column
		local values
		panel.values = {}
		if get then
			values = get()
		end

		for i=1, #panel.controls do
			panel.controls[i]:Hide()
			panel.controls[i] = nil -- 메모리-_-
		end
		for i=1, #opt do
			chk = self:GetCheckButton{
				parent = panel.chkpanel,
				text = opt[i].text,
				fontobject = opt[i].fontobject,
				font = opt[i].font,
				outline = opt[i].outline,
				r = opt[i].titleR,
				g = opt[i].titleG,
				b = opt[i].titleB,
				a = opt[i].titleA,
				size = opt[i].titlesize,
				tooltip = opt[i].tooltip,
				anchor = opt[i].anchor,
			}
			if opt[i].r and opt[i].g and opt[i].b then
				chk.text:SetTextColor(opt[i].r, opt[i].g, opt[i].b, 1)
			end
			chk.value = opt[i].value
			chk.exclusion = opt[i].exclusion -- 배타 옵션..이게 true인 chk는 다른 chk들과 같이 체크될수 없다.(radio버튼같은거..)

			column = (i-1) % col
			if i==1 then
				chk:SetPoint("TOPLEFT", 5, -5 )
				innerHeight = innerHeight + chk:GetHeight() + 5
			else
				if column==0 then
					chk:SetPoint("TOPLEFT", panel.controls[i-col], "BOTTOMLEFT", 0, -5)
					innerHeight = innerHeight + chk:GetHeight() + 5
				else
					chk:SetPoint("LEFT", panel.controls[#panel.controls], "LEFT", width/col, 0)
				end
			end
			chk:SetChecked(values[chk.value])
			chk:SetScript("OnClick", function (obj)
				local chked = obj:GetChecked()
				if chked then
					for j=1, #panel.controls do
						if obj.exclusion then
							if panel.controls[j]~=obj then
								panel.controls[j]:SetChecked(not chked)
							end
						else
							if panel.controls[j].exclusion~=obj.exclusion then
								panel.controls[j]:SetChecked(not chked)
							end
						end
					end
				end

				for k, v in pairs(panel.values) do panel.values[k] = nil end
				for j=1, #panel.controls do
					if panel.controls[j]:GetChecked() then
						panel.values[panel.controls[j].value] = true
					end
				end
				if set then
					set(panel.values)
					if a.needRefresh then
						if a.frame and a.frame.refresh then
							a.frame.refresh()
						end
					end
				end
				local f = getfunc(opt[i].func)
				if f and type(f)=='function' then
					f(chked)
				end
			end)
			if getbool(a.disable)==true or getbool(opt[i].disable) then
				chk.disable()
			end

			table.insert(panel.controls, chk)
		end
		panel.chkpanel:SetHeight(innerHeight + 5)
		panel:SetHeight(panel.chkpanel:GetHeight() + panel.text:GetHeight() + 5)

		for j=1, #panel.controls do
			if values[panel.controls[j].value] then
				panel.controls[j]:SetChecked(true)
			else
				panel.controls[j]:SetChecked(nil)
			end
		end
		disable(panel, a.disable)
		showhide(panel, a.showhide)
	end
	panel.enabled = true
	--panel.refresh()
	return panel
end

function addon:CreateColorPicker(a) --ground, parent, name, text, tooltip, width, height, dbkey, dbkey2)
	if not a then return end
	local padding = a.padding or 5
	local width = a.width or (a.parent:GetWidth() - (padding*2))
	local height = a.height or 20

	local panel = CreateFrame("Frame", nil, a.parent)
	panel:SetWidth(width)
	panel:SetHeight(height)
	panel.type = "color"

	panel.text = self:GetString{
		parent = panel,
		text = a.text,
		fontobject = a.fontobject,
		font = a.font,
		outline = a.outline,
		r = a.titleR,
		g = a.titleG,
		b = a.titleB,
		a = a.titleA,
		size = a.titlesize,
	}
	panel.text:SetPoint("LEFT", panel, "LEFT", 0, 0)

	panel.button = CreateFrame("Button", nil, panel)
	panel.button:SetWidth(24)
	panel.button:SetHeight(24)
	panel.button:SetPoint("RIGHT", panel, "RIGHT")
	panel.button:Show()

	panel.button.colorSwatch = panel.button:CreateTexture(nil, "OVERLAY")
	panel.button.colorSwatch:SetWidth(19)
	panel.button.colorSwatch:SetHeight(19)
	panel.button.colorSwatch:SetTexture("Interface\\ChatFrame\\ChatFrameColorSwatch")
	panel.button.colorSwatch:SetPoint("CENTER", panel.button) --, "LEFT", 0, 0)
	panel.button.colorSwatch.texture = panel.button:CreateTexture(nil, "BACKGROUND")
	panel.button.colorSwatch.texture:SetWidth(16)
	panel.button.colorSwatch.texture:SetHeight(16)
	panel.button.colorSwatch.texture:SetTexture(1,1,1)
	panel.button.colorSwatch.texture:SetPoint("CENTER", panel.button.colorSwatch, "CENTER")
	panel.button.colorSwatch.texture:Show()
	

	local checkers = panel.button:CreateTexture(nil, "BACKGROUND")
	panel.button.colorSwatch.checkers = checkers
	checkers:SetTexture("Tileset\\Generic\\Checkers")
	checkers:SetDesaturated(true)
	checkers:SetVertexColor(1,1,1,0.75)
	checkers:SetTexCoord(.25,0,0.5,.25)
	checkers:SetPoint("CENTER", panel.button.colorSwatch, "CENTER")
	checkers:SetWidth(14)
	checkers:SetHeight(14)
	checkers:Show()

	local highlight = panel.button:CreateTexture(nil, "BACKGROUND")
	panel.button.highlight = highlight
	highlight:SetTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight")
	highlight:SetBlendMode("ADD")
	highlight:SetWidth(21)
	highlight:SetHeight(21)
	highlight:SetPoint("CENTER", panel.button)
	highlight:Hide()


	panel.button:SetScript("OnEnter", function (obj)
		panel.button.highlight:Show()
		if tooltip then
			GameTooltip:SetOwner(obj, "ANCHOR_BOTTOMLEFT")
			GameTooltip:SetText(tooltip, nil, nil, nil, nil, 1)
			GameTooltip:Show()
		end
	end)
	panel.button:SetScript("OnLeave", function (obj)
		panel.button.highlight:Hide()
		GameTooltip:Hide()
	end)

	panel.button:SetScript("OnClick", function(obj)
		ColorPickerFrame:Hide()
		ColorPickerFrame.func = function() end
		local r, g, b, al, get, set
		if a.get then
			get = getfunc(a.get)
			r, g, b, al = hexToDec(get())
		else
			r, g, b, al = 1, 1, 1, 1.0
		end
		if a.set then set = getfunc(a.set) end

		ColorPickerFrame:SetColorRGB(r, g, b)
		panel.button.previousValues = {r = r, g = g, b = b, a = al}
		ColorPickerFrame.hasOpacity, ColorPickerFrame.opacity = (al ~= nil), al
		ColorPickerFrame.func = function()
			local alpha = OpacitySliderFrame:GetValue()
			local color = {ColorPickerFrame:GetColorRGB()}
			panel.button.colorSwatch:SetVertexColor(color[1], color[2], color[3], alpha)
			local tc = FloatToText(color[1], color[2], color[3], alpha)
			if set then
				set(tc)
				if a.needRefresh then
					if a.frame and a.frame.refresh then
						a.frame.refresh()
					end
				end
			end
		end
		ColorPickerFrame.opacityFunc = function ()
			local alpha = OpacitySliderFrame:GetValue()
			local color = {ColorPickerFrame:GetColorRGB()}
			panel.button.colorSwatch:SetVertexColor(color[1], color[2], color[3], alpha)
			local tc = FloatToText(color[1], color[2], color[3], alpha)
			if set then
				set(tc)
				if a.needRefresh then
					if a.frame and a.frame.refresh then
						a.frame.refresh()
					end
				end
			end
		end
		ColorPickerFrame.cancelFunc = function()
			panel.button.colorSwatch:SetVertexColor(panel.button.previousValues.r,
						panel.button.previousValues.g,
						panel.button.previousValues.b,
						panel.button.previousValues.a)
			local tc = FloatToText(panel.button.previousValues.r,
						panel.button.previousValues.g,
						panel.button.previousValues.b,
						panel.button.previousValues.a)

			if set then
				set(tc)
				if a.needRefresh then
					if a.frame and a.frame.refresh then
						a.frame.refresh()
					end
				end
			end
		end
		ColorPickerFrame:Show()
	end)

	panel.enable = function ()
		panel.text.enable()
		panel.button:EnableMouse(true)
		local r, g, b, al, get
		if a.get then
			get = getfunc(a.get)
			r, g, b, al = hexToDec(get())
			panel.button.colorSwatch:SetVertexColor(r, g, b, al)
		end
		panel.enabled = true
	end
	panel.disable = function ()
		panel.text.disable()
		panel.button:EnableMouse(false)
		panel.button.colorSwatch:SetVertexColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b, 1)
		panel.enabled = false
	end
	panel.refresh = function ()
		local r, g, b, al, get
		if a.get then
			get = getfunc(a.get)
			r, g, b, al = hexToDec(get())
			panel.button.colorSwatch:SetVertexColor(r, g, b, al)
		end
		disable(panel, a.disable)
		showhide(panel, a.showhide)
	end

	panel.enabled = true
	--panel.refresh()
	return panel
end

function addon:CreateGroup(a)
	if not a.options then return end

	local padding = a.padding or 5
	local width = a.width or (a.parent:GetWidth() - (padding*2))
	local group = self:GetBorder{
		parent = a.parent,
		width = width,
--		r = .3,
--		g = .3,
--		b = .3,
--		a = .3,
	}

	group.type = "group"
	group.controls = {}
	group.super = a.frame

	group.enable = function ()
		if group.text then
			group.text.enable()
		end
		if #group.controls > 0 then
			for i=1, #group.controls do
				if group.controls[i] then
					if group.controls[i]:IsShown() then
						if group.controls[i].enable then
							group.controls[i].enable()
						end
					end
				end
			end
		end
		group.enabled = true
	end
	group.disable = function ()
		if group.text then
			group.text.disable()
		end
		if #group.controls > 0 then
			for i=1, #group.controls do
				if group.controls[i] then
					if group.controls[i]:IsShown() then
						if group.controls[i].disable then
							group.controls[i].disable()
						end
					end
				end
			end
		end
		group.enabled = false
	end
	group.refresh = function ()
		if not group.panel then
			group.panel = CreateFrame("Frame", nil, group)
			group.panel:SetWidth(group:GetWidth()+4)
			group.panel:SetBackdrop({
				bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
				edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
				tile = true, tileSize = 16, edgeSize = 16,
				insets={left = 5, right = 5, top = 5, bottom = 5}
			})
			group.panel:SetBackdropBorderColor(.6, .6, .6, 1)
			group.panel:SetBackdropColor(.3, .3, .3, .3)
		end
		if a.text then
			if not group.text then
				group.text = self:GetString{
					parent = group,
					text = a.text,
					--size = a.size or 16,
					fontobject = a.fontobject,
					font = a.font,
					outline = a.outline,
					r = a.titleR,
					g = a.titleG,
					b = a.titleB,
					a = a.titleA,
					size = a.titlesize,
				}
			else
				if a.fontobject then
					group.text:SetFontObject(a.fontobject)
				end
				group.text:SetText(gettext(a.text))
				if a.titleR and a.titleG and a.titleB then
					local r, g, b = getvalue(a.titleR), getvalue(a.titleG), getvalue(a.titleB)
					group.text:SetTextColor(r, g, b, getvalue(a.titleA) or 1)
				end
				if a.titlesize then
					group.text:SetTextHeight(a.titlesize)
				end
			end
			group.text:SetPoint("TOPLEFT", 0, 0)
			group.panel:SetPoint("TOP", 0, -1*group.text:GetHeight()-3)
		else
			group.panel:SetPoint("TOP", 0, 0)
		end

		local anchorTo
		local innerHeight = 0
		if #group.controls == 0 or type(a.options)=='function' then
			self:refresh(group, group.panel, a.options, a.padding)
		end
		if #group.controls > 0 then
			for i=1, #group.controls do
				if group.controls[i] then
					if group.controls[i].refresh then
						group.controls[i].refresh()
					end
					if group.controls[i]:IsShown() then
						if not anchorTo then
							group.controls[i]:SetPoint("TOP", 0, -1*padding)
						else
							group.controls[i]:SetPoint("TOP", anchorTo, "BOTTOM", 0, padding*-1)
						end
						anchorTo = group.controls[i]
						innerHeight = innerHeight + group.controls[i]:GetHeight() + a.padding
					end
				end
			end
		end
		group.panel:SetHeight(innerHeight + a.padding)
		if a.text then
			group:SetHeight(group.panel:GetHeight() + group.text:GetHeight() + 3)
		else
			group:SetHeight(group.panel:GetHeight())
		end
		disable(group, a.disable)
		showhide(group, a.showhide)
	end
	group.enabled = true
	--group.refresh()
	return group
end

local sf_count = 1
function addon:CreateScrollFrame(a)
	if not a.options then
		return
	end

	local padding = a.padding or 0

	local panel = self:GetBorder{
		parent = a.parent,
		width = a.width,
		height = a.height,
	}
	panel.selectedIndex = 1

	if a.frontCtrl then
		panel:SetPoint("TOPLEFT", a.frontCtrl, "BOTTOMLEFT", 0, -5)
	else
		panel:SetPoint("TOPLEFT", a.parent, "TOPLEFT", 5, -5)
	end

	sf_count = sf_count + 1
	panel.scrollFrame = CreateFrame("ScrollFrame", ("blink_options_scroll_%d"):format(sf_count), panel, "UIPanelScrollFrameTemplate")
	panel.scrollFrame.scrollBarHideable = true
	panel.scrollFrame:SetPoint("TOPLEFT", 0, 0)
	panel.scrollFrame:SetPoint("BOTTOMRIGHT", 0, 0)
	
	local cframe = CreateFrame("Frame", nil, panel.scrollFrame)
	panel.scrollFrame.child = cframe
	panel.scrollFrame:SetScrollChild(cframe)
	--panel.scrollFrame.child = getglobal(panel.scrollFrame:GetName().."ScrollChildFrame")
	panel.scrollFrame.child:ClearAllPoints()
	panel.scrollFrame.child:SetPoint("TOPLEFT", panel.scrollFrame, "TOPLEFT", 0, 0)
	panel.scrollFrame.child:SetPoint("TOPRIGHT", panel.scrollFrame, "TOPRIGHT", 0, 0)

	panel.scrollFrame.scrollBar = getglobal(panel.scrollFrame:GetName().."ScrollBar")

--	panel.scrollFrame:SetScript("OnScrollRangeChanged", function (obj, yrange)
--		ScrollFrame_OnScrollRangeChanged(obj, yrange)
--	end)

	panel.controls = {}

	panel.refresh = function ()
		local anchorTo
		local innerHeight = 0
		if #panel.controls == 0 or type(a.options)=='function' then
			self:refresh(panel, panel.scrollFrame.child, a.options, padding)
		end
		if #panel.controls > 0 then
			for i=1, #panel.controls do
				if panel.controls[i] then
					if panel.controls[i].refresh then
						panel.controls[i].refresh()
					end
					if panel.controls[i]:IsShown() then
						if not anchorTo then
							panel.controls[i]:SetPoint("TOP", 0, -1*padding)
						else
							panel.controls[i]:SetPoint("TOP", anchorTo, "BOTTOM", 0, padding*-1)
						end
						anchorTo = panel.controls[i]
						innerHeight = innerHeight + panel.controls[i]:GetHeight() + padding
					end
				end
			end
		end
		panel.scrollFrame.child:SetHeight(innerHeight + padding)
		panel.scrollFrame.child:SetWidth(a.width)

		local scrollrange = panel.scrollFrame:GetVerticalScrollRange()
		local width = a.width
		if ( floor(scrollrange) == 0 ) then
			panel.scrollFrame.scrollBar:Hide()
		else
			panel.scrollFrame.scrollBar:Show()
		end
	end
	panel.type = "scrollFrame"
	--panel.refresh()
	return panel
end

function addon:refresh(addonOrParent, anchorPoint, opt, padding)
	if not addonOrParent or not opt then
		return
	end
	local o = gettable(opt)
	for i=1, #addonOrParent.controls do
		addonOrParent.controls[i]:Hide()
		addonOrParent.controls[i] = nil
	end

	local innerHeight = 0
	for i=1, #o do
		local element
		if o[i].type == 'toggle' then -- checkbox
			element = self:CreateCheckButton{
				frame = addonOrParent,
				needRefresh = o[i].needRefresh,
				parent = anchorPoint,
				width = addonOrParent:GetWidth()-(padding*2),
				height = 20,
				text = o[i].text,
				fontobject = o[i].fontobject,
				font = o[i].font,
				outline = o[i].outline,
				titleR = o[i].titleR,
				titleG = o[i].titleG,
				titleB = o[i].titleB,
				titleA = o[i].titleA,
				titlesize = o[i].titlesize,
				tooltip = o[i].tooltip,
				get = o[i].get,
				set = o[i].set,
				showhide = o[i].show,
				padding = o[i].padding or padding,
				disable = o[i].disable,
				depth = o[i].depth,
			}
		elseif o[i].type == 'multiselect' then -- group checkbox
			element = self:CreateCheckGroupButton{
				frame = addonOrParent,
				needRefresh = o[i].needRefresh,
				parent = anchorPoint,
				width = addonOrParent:GetWidth()-(padding*2),
				height = 20,
				text = o[i].text,
				fontobject = o[i].fontobject,
				font = o[i].font,
				outline = o[i].outline,
				titleR = o[i].titleR,
				titleG = o[i].titleG,
				titleB = o[i].titleB,
				titleA = o[i].titleA,
				titlesize = o[i].titlesize,
				tooltip = o[i].tooltip,
				get = o[i].get,
				set = o[i].set,
				values = o[i].values,
				col = o[i].col,
				showhide = o[i].show,
				padding = o[i].padding or padding,
				disable = o[i].disable,
			}
		elseif o[i].type == 'radio' then -- group radio
			element = self:CreateRadioButton{
				frame = addonOrParent,
				needRefresh = o[i].needRefresh,
				parent = anchorPoint,
				width = addonOrParent:GetWidth()-(padding*2),
				height = 20,
				text = o[i].text,
				fontobject = o[i].fontobject,
				font = o[i].font,
				outline = o[i].outline,
				titleR = o[i].titleR,
				titleG = o[i].titleG,
				titleB = o[i].titleB,
				titleA = o[i].titleA,
				titlesize = o[i].titlesize,
				tooltip = o[i].tooltip,
				get = o[i].get,
				set = o[i].set,
				values = o[i].values,
				col = o[i].col,
				showhide = o[i].show,
				padding = o[i].padding or padding,
				disable = o[i].disable,
			}
		elseif o[i].type == 'select' then -- dropdown
			element = self:CreateDropdown{
				frame = addonOrParent,
				needRefresh = o[i].needRefresh,
				parent = anchorPoint,
				width = addonOrParent:GetWidth()-(padding*2),
				height = 20,
				text = o[i].text,
				fontobject = o[i].fontobject,
				font = o[i].font,
				outline = o[i].outline,
				titleR = o[i].titleR,
				titleG = o[i].titleG,
				titleB = o[i].titleB,
				titleA = o[i].titleA,
				titlesize = o[i].titlesize,
				tooltip = o[i].tooltip,
				get = o[i].get,
				set = o[i].set,
				values = o[i].values,
				showhide = o[i].show,
				padding = o[i].padding or padding,
				disable = o[i].disable,
			}
		elseif o[i].type == 'range' then -- slider
			element = self:CreateSlider{
				frame = addonOrParent,
				needRefresh = o[i].needRefresh,
				parent = anchorPoint,
				width = addonOrParent:GetWidth()-(padding*2),
				height = 30,
				text = o[i].text,
				fontobject = o[i].fontobject,
				font = o[i].font,
				outline = o[i].outline,
				titleR = o[i].titleR,
				titleG = o[i].titleG,
				titleB = o[i].titleB,
				titleA = o[i].titleA,
				titlesize = o[i].titlesize,
				tooltip = o[i].tooltip,
				get = o[i].get,
				set = o[i].set,
				min = o[i].min,
				max = o[i].max,
				step = o[i].step,
				showhide = o[i].show,
				padding = o[i].padding or padding,
				disable = o[i].disable,
			}
		elseif o[i].type == 'color' then -- color
			element = self:CreateColorPicker{
				frame = addonOrParent,
				needRefresh = o[i].needRefresh,
				parent = anchorPoint,
				width = addonOrParent:GetWidth()-(padding*2),
				height = 20,
				text = o[i].text,
				fontobject = o[i].fontobject,
				font = o[i].font,
				outline = o[i].outline,
				titleR = o[i].titleR,
				titleG = o[i].titleG,
				titleB = o[i].titleB,
				titleA = o[i].titleA,
				titlesize = o[i].titlesize,
				tooltip = o[i].tooltip,
				get = o[i].get,
				set = o[i].set,
				showhide = o[i].show,
				padding = o[i].padding or padding,
				disable = o[i].disable,
			}
		elseif o[i].type == 'string' then -- editbox
			element = self:CreateEditBox{
				frame = addonOrParent,
				needRefresh = o[i].needRefresh,
				parent = anchorPoint,
				width = addonOrParent:GetWidth()-(padding*2),
				height = 20,
				text = o[i].text,
				fontobject = o[i].fontobject,
				font = o[i].font,
				outline = o[i].outline,
				titleR = o[i].titleR,
				titleG = o[i].titleG,
				titleB = o[i].titleB,
				titleA = o[i].titleA,
				titlesize = o[i].titlesize,
				tooltip = o[i].tooltip,
				get = o[i].get,
				set = o[i].set,
				wide = o[i].wide,
				allowBlank = o[i].allowBlank,
				buttonText = o[i].buttonText,
				showhide = o[i].show,
				padding = o[i].padding or padding,
				disable = o[i].disable,
			}
		elseif o[i].type == 'execute' then
			element = self:CreateButton{
				frame = addonOrParent,
				needRefresh = o[i].needRefresh,
				parent = anchorPoint,
				width = addonOrParent:GetWidth()-(padding*2),
				height = 20,
				text = o[i].text,
				tooltip = o[i].tooltip,
				showhide = o[i].show,
				padding = o[i].padding or padding,
				disable = o[i].disable,
				func = o[i].func,
				buttonwidth = o[i].buttonwidth,
			}
		elseif o[i].type == 'description' then -- text only
			element = self:CreateDescription{
				frame = addonOrParent,
				needRefresh = o[i].needRefresh,
				parent = anchorPoint,
				width = addonOrParent:GetWidth()-(padding*2),
				height = 20,
				text = o[i].text,
				fontobject = o[i].fontobject,
				font = o[i].font,
				outline = o[i].outline,
				r = o[i].r,
				g = o[i].g,
				b = o[i].b,
				a = o[i].a,
				size = o[i].size,
				tooltip = o[i].tooltip,
				get = o[i].get,
				set = o[i].set,
				showhide = o[i].show,
				padding = o[i].padding or padding,
				justifyH = o[i].justifyH,
				justifyV = o[i].justifyV,
				disable = o[i].disable,
			}
		elseif o[i].type == 'group' then -- group
			element = self:CreateGroup{
				frame = addonOrParent,
				needRefresh = o[i].needRefresh,
				parent = anchorPoint,
				width = addonOrParent:GetWidth()-(padding*2),
				height = 20,
				text = o[i].text,
				fontobject = o[i].fontobject,
				font = o[i].font or "Fonts\\2002.TTF",
				outline = o[i].outline,
				titleR = o[i].titleR,
				titleG = o[i].titleG,
				titleB = o[i].titleB,
				titleA = o[i].titleA,
				titlesize = o[i].titlesize or 14,
				tooltip = o[i].tooltip,
				get = o[i].get,
				set = o[i].set,
				showhide = o[i].show,
				options = o[i].options,
				padding = o[i].padding or padding,
				disable = o[i].disable,
			}
		end
		if element then
			tinsert(addonOrParent.controls, element)
		end
	end
end

--[[
local v = true
local v2 = "c"
local v3 = "b"
local v4 = {
	["a"] = true,
	["b"] = true,
}
local v5 = false
local v6 = "aa"
local v7 = 3
local opt = {
	type = "root",
	name = "Add On",
	text = "text",
	command = {"addon","애드온"},
	options = {
		{
			type = "toggle",
			text = "checktext",
			tooltip = function ()
				return "tooltip~"
			end,
			get = function ()
				return v
			end,
			set = function (value)
				v = value
			end,
			needRefresh = true,
			disable = function ()
				return v2=="a"
			end,
		},
		{
			type = "select",
			text = "select",
			get = function ()
				return v2
			end,
			set = function (value)
				v2 = value
			end,
			values = {
				{ text = "a", value = "a", },
				{ text = "b", value = "b", },
				{ text = "c", value = "c", },
			},
			needRefresh = true,
			disable = function ()
				return not v
			end,
		},
		{
			show = function ()
				return v2=="a" or v2=="b"
			end,
			disable = function ()
				return not v
			end,
			type = "group",
			text = "group",
			fontobject = "QuestTitleFont",
			titleR = 1,
			titleG = .82,
			titleB = 0,
			options = {
				{
					type = "toggle",
					text = "checktext3",
					get = function ()
						return "var"
					end,
					set = function (value)
						-- var = value
					end,
				},
				{
					type = "toggle",
					text = "checktext4",
					get = function ()
						return "var"
					end,
					set = function (value)
						-- var = value
					end,
				},
				{
					type = "string",
					get = function ()
						return v6
					end,
					set = function (value)
						v6 = value
					end,
					buttonText = "확인",
				},
				{
					show = function ()
						return v2=="b"
					end,
					type = "group",
					text = "group",
					fontobject = "QuestTitleFont",
					titleR = 1,
					titleG = .82,
					titleB = 0,
					options = {
						{
							type = "toggle",
							text = "checktext3",
							get = function ()
								return "var"
							end,
							set = function (value)
								-- var = value
							end,
						},
						{
							type = "toggle",
							text = "checktext4",
							get = function ()
								return "var"
							end,
							set = function (value)
								-- var = value
							end,
						},
						{
							type = "string",
							get = function ()
								return v6
							end,
							set = function (value)
								v6 = value
							end,
						},
					},
				},
			},
		},
		{
			type = "toggle",
			text = "checktext2",
			get = function ()
				return "var"
			end,
			set = function (value)
				-- var = value
			end,
		},
		{
			type = "radio",
			text = "radio",
			get = function ()
				return v3
			end,
			set = function (value)
				v3 = value
			end,
			values = {
				{ text = "a", value = "a", },
				{ text = "b", value = "b", },
				{ text = "c", value = "c", },
			},
			col = 3,
			disable = function ()
				return not v
			end,
		},
		{
			type = "multiselect",
			text = "multiselect",
			fontobject = "QuestTitleFont",
			titleR = 1,
			titleG = .82,
			titleB = 0,
			get = function ()
				return v4
			end,
			set = function (value)
				v4 = value
			end,
			values = {
				{ text = "a", value = "a", exclusion = true, },
				{ text = "b", value = "b", },
				{ text = "c", value = "c", },
			},
			col = 3,
			disable = function ()
				return not v
			end,
		},
		{
			type = "toggle",
			text = "checktext3",
			get = function ()
				return "var"
			end,
			set = function (value)
				-- var = value
			end,
		},
		{
			type = "string",
			text = "STRING",
			titleR = 1,
			titleG = 0,
			titleB = 1,
			get = function ()
				return "aa"
			end,
			set = function (value)
				--
			end,
			buttonText = "확인",
			disable = function ()
				return not v
			end,
		},
		{
			type = "string",
			text = "STRING",
			wide = true,
			get = function ()
				return "bb"
			end,
			set = function (value)
				--
			end,
			buttonText = "확인",
		},
		{
			type = "string",
			wide = true,
			get = function ()
				return "cc"
			end,
			set = function (value)
				--
			end,
			buttonText = "확인",
		},
		{
			type = "string",
			get = function ()
				return "dd"
			end,
			set = function (value)
				--
			end,
			buttonText = "확인",
		},
		{
			type = "string",
			text = "STRING",
			get = function ()
				return "aa"
			end,
			set = function (value)
				--
			end,
			buttonText = "확인",
		},
		{
			type = "range",
			text = "STRING",
			get = function ()
				return v7
			end,
			set = function (value)
				v7 = value
			end,
			min = 0,
			max = 10,
			step = 1,
			disable = function ()
				return not v
			end,
		},
	},
	children = {
		{
			type = "root",
			name = "AddOn1",
			text = "text",
			command = {"addon1","애드온1"},
			options = {
				{
					type = "toggle",
					text = "checktext2",
					get = function ()
						return v5
					end,
					set = function (value)
						v5 = value
					end,
					needRefresh = true,
				},
				{
					show = function ()
						return v5
					end,
					type = "toggle",
					text = "checktext2",
					get = function ()
						return "var"
					end,
					set = function (value)
						-- var = value
					end,
				},
				{
					type = "toggle",
					text = "checktext3",
					get = function ()
						return "var"
					end,
					set = function (value)
						-- var = value
					end,
				},
				{
					type = "string",
					text = "STRING",
					get = function ()
						return "aa"
					end,
					set = function (value)
						--
					end,
				},
				{
					type = "range",
					text = "range",
					get = function ()
						return 3
					end,
					set = function (value)
						--
					end,
					min = 0,
					max = 10,
					step = 1,
				},
			},
		},
	},
}
addon:RegisterOptions(opt)

--PanelTemplates_SetTab(InterfaceOptionsFrame, 2); InterfaceOptionsFrame_TabOnClick(); InterfaceOptionsFrame_Show()
]]

