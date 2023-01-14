local rem = Instance.new("RemoteEvent", owner.Character)

--made by local sexy man scandalous

local scheme = {
	main = Color3.fromRGB(166, 110, 114),
	dark = Color3.fromRGB(95, 77, 85),
	darklight = Color3.fromRGB(103, 61, 62),
	border = Color3.fromRGB(163, 120, 121)
}

local root = Instance.new("Part")
root.Name = "root"
root.Anchored = true
root.BottomSurface = Enum.SurfaceType.Smooth
root.BrickColor = BrickColor.new("Really black")
root.CFrame = CFrame.new(66.8749924, 5.75, 44.3125038, 1, 0, 0, 0, 1, 0, 0, 0, 1)
root.CanCollide = false
root.CanTouch = false
root.Color = Color3.fromRGB(17, 17, 17)
root.Position = Vector3.new(66.9, 5.75, 44.3)
root.Size = Vector3.new(22.6, 11.5, 0.0917)
root.TopSurface = Enum.SurfaceType.Smooth

root.Parent = script

local console = Instance.new("SurfaceGui")
console.Name = "console"
console.ClipsDescendants = true
console.LightInfluence = 0
console.PixelsPerStud = 200
console.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
console.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
console.Parent = root

local VER = "1.0.0"

task.defer(function()
	while true do 
		local dt = task.wait()
		root.CFrame = root.CFrame:Lerp(owner.Character.HumanoidRootPart.CFrame * CFrame.new(0,root.Size.Y/3, -6) * CFrame.Angles(0,math.pi,0), 0.2 + (1 - (0.2 ^ dt)))
	end
end)

local globalRef = {}
function push(data) -- roact ripoff
	local new = Instance.new(data.class or "Frame")
	for i, v in data do 
		if i ~= "class" and i ~= "children" and i ~= "ref" then
			new[i] = v
		end
	end
	if data.ref then
		globalRef[data.ref] = new
	end
	if data.children then
		for name, child in data.children do 
			local obj = push(child)
			obj.Name = name
			obj.Parent = new
		end
	end

	return new
end

local screenobject = {}
screenobject.__index = screenobject

function screenobject:add()
	local new = Util.screen()
	table.insert(self._children, new)
	return new
end

function screenobject:widget(name, data)
	--[[
		{
			minx : number?,
			miny : number?,
			maxx : number?,
			maxy : number?,
			x : number?,
			y : number?,
			px : number?,
			py : number?,
			canfs : boolean?,
		}
	]]
	local new = self:push{
		Size = UDim2.fromOffset(data.x or 2127, data.y or 1158),
		Position = UDim2.fromOffset(data.x or console.AbsoluteSize.X / 2, data.y or console.AbsoluteSize.Y / 2),
		BackgroundColor3 = scheme.border,
		
		children = {
			corner = {
				class = "UICorner",
				
				CornerRadius = UDim.new(0,20)
			}
		}
	}
end

function screenobject:push(data) -- roact ripoff 2
	local new = Instance.new(data.class or "Frame")
	for i, v in data do 
		if i ~= "class" and i ~= "children" and i ~= "ref" then
			new[i] = v
		end
	end
	if data.ref then
		self[data.ref] = new
	end
	if data.children then
		for name, child in data.children do 
			self:push(child)(new).Name = name
		end
	end
	
	return function(parent)
		new.Parent = parent or self._base
		return new
	end
end

function screenobject:prompt(type, title, text)
	local widget = self:widget(title)
end

Util = {
	frame = function(trans)
		local f = Instance.new("Frame")
		f.Size = UDim2.fromScale(1,1)
		if trans then
			f.BackgroundTransparency = 1
		end
		f.BorderSizePixel = 0
		return f
	end,
	screen = function()
		local f = Util.frame(true)
		f.Parent = console
		local screen = setmetatable({}, screenobject)
		screen._base = f
		screen._children = {}
		
		return screen
	end,
}

local main = Util.screen()
local desktop = main:add()

local appobject = {}
appobject.__index = appobject

function appobject:pin()
	return appobject
end

function appobject:icon(icon)
	self._base.icon.Image = icon
	self._icon = icon
	return appobject
end

desktop:prompt(0, "scandalOS is currently running on version "..VER, "scandalOS")

local sys = desktop:push{
	class = "ImageLabel",
	
	AnchorPoint = Vector2.one / 2,
	Position = UDim2.fromScale(0.5,0.5),
	Size = UDim2.fromScale(1,1),
	Image = "http://www.roblox.com/asset/?id=12149779984",
	
	children = {
		desktop = {
			
			Size = UDim2.new(1,0,1,-165),
			BackgroundTransparency = 1,
			
			children = {
				inner = {	
					ref = "desktop_apps",
					
					BackgroundTransparency = 1,
					Size = UDim2.fromScale(1,1),
					
					children = {
						grid = {
							class = "UIGridLayout",

							CellPadding = UDim2.fromOffset(25,25),
							CellSize = UDim2.fromOffset(225,255)
						},
					}
				},
				padding = {
					class = "UIPadding",

					PaddingBottom = UDim.new(0,50),
					PaddingLeft = UDim.new(0,50),
					PaddingRight = UDim.new(0,50),
					PaddingTop = UDim.new(0,50),
				},
			}
		},
		bar = {			
			Size = UDim2.new(1,0,0,165),
			Position = UDim2.new(0,0,1,-165),
			BorderSizePixel = 0,
			BackgroundColor3 = Color3.fromRGB(255,255,255),
			
			children = {
				apps = {
					Size = UDim2.fromScale(1,1),
					BackgroundTransparency = 1,
					
					children = {
						inner = {					
							ref = "pinned_apps",
							
							BackgroundTransparency = 1,
							Size = UDim2.fromScale(1 - 0.04,1),
							Position = UDim2.fromScale(0.04,0),

							children = {
								list = {
									class = "UIListLayout",

									FillDirection = Enum.FillDirection.Horizontal,
									Padding = UDim.new(0,5),
								},
							}
						},
						padding = {
							class = "UIPadding",

							PaddingBottom = UDim.new(0,18),
							PaddingLeft = UDim.new(0,18),
							PaddingRight = UDim.new(0,18),
							PaddingTop = UDim.new(0,18),
						},
					}
				},
				start = {
					ref = "start_button",
					class = "ImageButton",
					
					Image = "rbxassetid://4689592016",
					Size = UDim2.fromScale(0.04,0.5),
					Rotation = 45,
					ScaleType = Enum.ScaleType.Fit,
					Position = UDim2.fromScale(0.003,0.25),
					BackgroundTransparency = 1,
				},
				gradient = {
					class = "UIGradient",
					
					Color = ColorSequence.new({
						ColorSequenceKeypoint.new(0, Color3.fromRGB(34, 49, 49)),
						ColorSequenceKeypoint.new(0.1, Color3.fromRGB(28, 37, 39)),
						ColorSequenceKeypoint.new(1, Color3.fromRGB(77, 50, 60)),
					}),
					Rotation = 90
				},
			}
		}
	}
}()

local Extentions = {
	["exe"] = {function() end, icon = "http://www.roblox.com/asset/?id=12151567147"},
	["lua"] = {function() end, icon = "rbxassetid://5588630"},
	["dec"] = {function(s)
		s:icon(s.data.content)
	end},
	["txt"] = {function() end, icon = "http://www.roblox.com/asset/?id=12151606601"},
	["snd"] = {function() end, icon = "rbxassetid://9206046736"},
	
	["_exp"] = {function() end, icon = "rbxassetid://12153795262"},
	["_rec"] = {function() end, icon = "rbxassetid://3390460027"}
}

local filesys = (function()
	--// Written by: R0bl0x10501050

	--// Filename: TraversableTable.lua

	----

	local function checkDictionary(tbl)
		local isDict = true
		for i, v in pairs(tbl) do -- accurately get the "first" element to check
			if i == 1 then
				isDict = false
			end
			break
		end
		return isDict
	end

	local function safeGetLength(tbl)
		if typeof(tbl) == "table" then
			local isDict = checkDictionary(tbl)
			local length = 0
			if isDict then
				for _, _ in pairs(tbl) do
					length += 1
				end
			else
				length = #tbl
			end
			return length
		else
			return 0
		end
	end

	local Node
	Node = {
		__newindex = function(t, k, v)
			local isDict
			if not rawget(t, '_children') then
				rawset(t, '_children', {})
				isDict = (k == 1)
			else
				isDict = checkDictionary(rawget(t, '_children'))
			end

			local newNode = Node.new(v)
			rawset(newNode, 'Parent', t)

			if isDict then
				rawset(t, '_idx', k)
				rawset(rawget(t, '_children'), k, newNode)
			else
				rawset(t, '_idx', #rawget(t, '_children') + 1)
				table.insert(rawget(t, '_children'), newNode)
			end
		end,
		__index = function(t, k)
			return rawget(rawget(t, '_children'), k)
			--if checkDictionary(t._children) then
			--	return rawget(t._children, k)
			--else
			--	return rawget(t._children, k)
			--end
		end,
	}

	function Node.new(value)
		local self = setmetatable({
			_raw = value
		}, Node)

		if typeof(value) == "string" or typeof(value) == "number" or typeof(value) == "boolean" or typeof(value) == "userdata" or typeof(value) == "function" then
			rawset(self, '_type', 'primitive')
		elseif typeof(value) == "table" then
			rawset(self, '_type', 'complex')

			local isDict = checkDictionary(value)

			rawset(self, '_children', {})

			if isDict then
				for k, v in pairs(value) do
					local newNode = Node.new(v)
					rawset(newNode, 'Parent', self)
					rawset(newNode, '_idx', k)
					rawset(rawget(self, '_children'), k, newNode)
				end
			else
				for _, v in ipairs(value) do
					local newNode = Node.new(v)
					rawset(newNode, 'Parent', self)
					rawset(newNode, '_idx', safeGetLength(rawget(self, '_children')) + 1)
					table.insert(self._children, newNode)
				end
			end
		end

		rawset(self, "Any", function()
			return {
				ForEach = function(f)
					for _, v in ipairs(self._children) do
						f(v)
					end
				end,
				Connect = function(f)
					for _, v in ipairs(self._children) do
						if v.Connect then
							v:Connect(f)
						end
					end
				end,
			}
		end)

		rawset(self, "Construct", function()
			local function _construct(n)
				if rawget(n, '_type') == "primitive" then
					return rawget(n, '_raw')
				elseif rawget(n, '_type') == "complex" then

					local tbl = {}
					for k, v in pairs(rawget(n, '_children')) do
						if typeof(v) == "table" then
							tbl[k] = _construct(v)
						else
							tbl[k] = rawget(v, '_raw')
						end
					end
					return tbl
				end
			end

			return _construct(self)
		end)

		rawset(self, "Get", function()
			return rawget(self, '_raw')
		end)

		rawset(self, "List", function()
			local isDict = checkDictionary(rawget(self, '_children'))
			local keys = {}
			for k, _ in pairs(rawget(self, '_children')) do
				table.insert(keys, k)
			end
			return keys
		end)

		rawset(self, "Set", function(self2, new)
			if rawget(self, 'Parent') then
				local newNode = Node.new(new)
				local oldIdx = rawget(self, '_idx')
				rawset(rawget(rawget(self, 'Parent'), '_children'), rawget(self, '_idx'), newNode)
				--self.Parent._children[self._idx] = newNode
				self = nil
				--local isDict = checkDictionary(self.Parent._children)
				--if isDict then
				--	rawe
				--else

				--end
			end
		end)

		return self
	end

	--function Node:Get()
	--	return self._raw
	--end

	--function Node:List()
	--	local isDict = checkDictionary(self._children)
	--	local keys = {}
	--	if isDict then
	--		for k, _ in pairs(self._children) do
	--			table.insert(keys, k)
	--		end
	--	end
	--	return keys
	--end



	local TraversableTable = {}

	function TraversableTable.new(tbl)
		--local self = setmetatable({
		--	_raw = tbl,
		--	_tbl = Node.new(tbl)
		--}, TraversableTable)

		--return self
		return Node.new(tbl)
	end

	return TraversableTable
end)()

local files = filesys.new{
	OS = {
		Desktop = {
			internal = true,
			children = {

			}
		}
	}
}

local InputObjects = {}

local file = {
	class = "TextButton",

	Text = "",
	BackgroundTransparency = 1,

	children = {
		highlight = {
			BackgroundColor3 = Color3.fromRGB(236, 102, 126),
			BorderColor3 = Color3.new(1,1,1),
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1,1),
			ZIndex = 0
		},
		icon = {
			class = "ImageLabel",

			Size = UDim2.fromScale(1, 0.54),
			Position = UDim2.fromScale(0,0.036),
			BackgroundTransparency = 1,
			ScaleType = Enum.ScaleType.Fit,
		},
		label = {
			class = "TextBox",

			Active = false,
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(0.95, 0.375),
			AnchorPoint = Vector2.new(0.5,0),
			Position = UDim2.fromScale(0.5,0.625),
			TextColor3 = Color3.new(1,1,1),
			ClearTextOnFocus = false,
			TextSize = 25,
			BackgroundColor3 = Color3.fromRGB(236, 102, 126),
			TextYAlignment = Enum.TextYAlignment.Top,
			TextStrokeTransparency = 0.5,
			TextTruncate = Enum.TextTruncate.AtEnd,
			TextWrapped = true
		}
	}
}

function newfile(title, ext, app, path)
	local extData = Extentions[ext]
	local obj = push(file)
	
	path = "Desktop"
	obj.label.Text = title
	InputObjects[obj] = {
		MouseEnter = function()
			obj.highlight.BackgroundTransparency = 0.7
		end,
		MouseLeave = function()
			obj.highlight.BackgroundTransparency = 1
		end,
	}
	
	local file = setmetatable({}, appobject)
	file._base = obj
	file._icon = app.icon or (extData.icon or "rbxassetid://782617573")
	file.data = app
	file.path = path .. "/" .. title .. "." .. ext
	
	obj.icon.Image = file._icon
	
	local dir = path:split("/")
	local parent = files.OS

	for i = 1, #dir do 
		local found = parent[dir[i]]
		if found then
			parent = found
		end
	end

	if path == "Desktop" then
		obj.Parent = desktop.desktop_apps
	end

	parent.children[title .. "." .. ext] = {
		object = obj,
		children = {}
	}
	
	extData[1](file)

	return file
end

function newfolder(title, path)
	local obj = push(file)

	obj.label.Text = title
	InputObjects[obj] = {
		MouseEnter = function()
			obj.highlight.BackgroundTransparency = 0.7
		end,
		MouseLeave = function()
			obj.highlight.BackgroundTransparency = 1
		end,
	}

	local file = setmetatable({}, appobject)
	file._base = obj
	file._icon = "http://www.roblox.com/asset/?id=12152267187"
	file._folder = true
	file.path = path .. "/" .. title
	
	local dir = path:split("/")
	local parent = files.OS
	
	for i = 1, #dir do 
		local found = parent[dir[i]]
		if found then
			parent = found
		end
	end

	if path == "Desktop" then
		obj.Parent = desktop.desktop_apps
	end
	
	parent.children[title] = {
		object = obj,
		children = {}
	}
	
	obj.icon.Image = file._icon
	
	return file
end

do -- INTERNAL FILES
	local removed = {}	

	local exp = newfile("File Explorer", "_exp", {
		activated = function()
			local widget = desktop:widget("File Explorer")
			local explorer = push{
				Size = UDim2.fromOffset(2127,1158),
				AnchorPoint = Vector2.one / 2,
				Position = UDim2.fromOffset(0.5,0.5),
				BackgroundColor3 = scheme.main,

				children = {
					corner = {
						class = "UICorner",

						CornerRadius = UDim.new(0,20)
					},
					side = {
						Size = UDim2.fromScale(0.15,1),
						BackgroundColor3 = Color3.new(1,1,1),

						children = {
							cover = {
								Position = UDim2.fromScale(0.85,0),
								Size = UDim2.fromScale(0.15,1),
								BorderSizePixel = 0,

								children = {
									gradient = {
										class = "UIGradient",

										Color = ColorSequence.new({
											ColorSequenceKeypoint.new(0, scheme.dark),
											ColorSequenceKeypoint.new(0.806, scheme.dark),
											ColorSequenceKeypoint.new(1, scheme.darklight),
										})
									}
								}
							}
						}
					}
				}
			}
			
			explorer.Parent = widget
		end,
	}, "Desktop") 
	local rec = newfile("Recycle Bin", "_rec", {}, "Desktop")
	
	local recyclebin = {
		delete = function(path)
			local dir = path:split("/")
			local file = files.OS

			for i = 1, #dir do 
				local found = file[dir[i]]
				if found then
					file = found
					if i == #dir then
						removed[path] = found
						file[dir[i]] = nil
					end
				end
			end
			
			rec:icon("rbxassetid://6121397353")
		end,
		restore = function(path)
			local torestore = removed[path]
			if torestore then
				local pathdata = path:split("/")
				local filename =  pathdata[#pathdata]:split(".")
				if not filename[2] then
					newfolder(filename[1], path)
				else 
					newfile(filename[1], filename[2], torestore.data, path)
				end
			end
			
			rec:icon("rbxassetid://3390460027")
		end,
		clear = function()
			for i, v in removed do 
				v.object:Destroy()
			end
			table.clear(removed)
		end,
	}
end

local hw = newfolder("HOMEWORK", "Desktop")

newfile("1", "dec", {
	content = "rbxassetid://10973602799"
}, hw.path)
newfile("2", "dec", {
	content = "rbxassetid://11933539182"
}, hw.path)
newfile("3", "dec", {
	content = "rbxassetid://11114834710"
}, hw.path)
newfile("4", "dec", {
	content = "rbxassetid://11160575793"
}, hw.path)
newfile("5", "dec", {
	content = "rbxassetid://11933509898"
}, hw.path)
newfile("6", "dec", {
	content = "rbxassetid://11933523815"
}, hw.path)
newfile("7", "dec", {
	content = "rbxassetid://7355974967"
}, hw.path)
newfile("8", "dec", {
	content = "rbxassetid://6998029717"
}, hw.path)
newfile("9", "dec", {
	content = "rbxassetid://10617251275"
}, hw.path)
newfile("10", "dec", {
	content = "rbxassetid://10617251275"
}, hw.path)


local Input = Instance.new("RemoteEvent", owner.PlayerGui)
local Client = NLS([[local UI = script.UI.Value

for _, Object in next, UI:GetDescendants() do
if Object:IsA("TextButton") then
Object.MouseEnter:Connect(function()
script.Parent:FireServer("MouseEnter", Object)
end)
Object.MouseLeave:Connect(function()
script.Parent:FireServer("MouseLeave", Object)
end)
Object.MouseButton1Down:Connect(function()
script.Parent:FireServer("MouseB1Down", Object)
end)
Object.MouseButton1Up:Connect(function()
script.Parent:FireServer("MouseB1Up", Object)
end)
end
end]], Input)
local Value = Instance.new("ObjectValue")
Value.Name = "UI"
Value.Value = console
Value.Parent = Client

Input.OnServerEvent:Connect(function(owner, Type, Object)
	local Inp = InputObjects[Object]
	if Inp then
		local Func = Inp[Type]
		if Func then
			Func()
		end
	end
end)
