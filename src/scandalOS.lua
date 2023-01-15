local Input = Instance.new("RemoteEvent", owner.Character)
Input.Name = "Input"

--made by local sexy man scandalous

local tweenService = game:GetService("TweenService")

local scheme = {
	main = Color3.fromRGB(102, 85, 95),
	dark = Color3.fromRGB(86, 70, 77),
	darklight = Color3.fromRGB(103, 61, 62),
	border = Color3.fromRGB(163, 120, 121),

	main_text = Color3.fromRGB(255,255,255)
}
local InputObjects = {}

local transparencyProperties = {
	["ScrollingFrame"] = {
		"ScrollBarImageTransparency",
		"BackgroundTransparency"
	},
	["Frame"] = {
		"BackgroundTransparency"
	},
	["ImageLabel"] = {
		"BackgroundTransparency",
		"ImageTransparency"
	},
	["ImageButton"] = {
		"BackgroundTransparency",
		"ImageTransparency"
	},
	["TextLabel"] = {
		"BackgroundTransparency",
		"TextTransparency",
		"TextStrokeTransparency"
	},
	["TextBox"] = {
		"BackgroundTransparency",
		"TextTransparency",
		"TextStrokeTransparency"
	},
	["TextButton"] = {
		"BackgroundTransparency",
		"TextTransparency",
		"TextStrokeTransparency"
	},
}

local brightness = 0.65
for i, v in scheme do 
	scheme[i] = Color3.new(v.R * brightness,v.G * brightness,v.B * brightness)
end

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

local objects = {}
function push(data) -- roact ripoff
	local new = Instance.new(data.class or "Frame")
	for i, v in data do 
		if i ~= "class" and i ~= "children" and i ~= "ref" and i ~= "input" then
			new[i] = v
		end
	end
	if data.input then
		local added
		added = new.AncestryChanged:Connect(function()
			if new.Parent then
				added:Disconnect()
				if data.input.Drag then
					task.wait(0.25)
					Input:FireClient(owner, "drag", new)
				end
			end
			if new.Parent == nil then
				added:Disconnect()
				InputObjects[new] = nil
			end
		end)
		InputObjects[new] = data.input
	end
	if data.ref then
		if typeof(data.ref) == "table" then
			data.ref[2][data.ref[1]] = new
		else 
			objects[data.ref] = new
		end
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

local widgetobject = {}
widgetobject.__index = widgetobject

function widgetobject:mount(ui)
	ui.Parent = self._base.holder
	self._mount = ui
end

function widgetobject:close()
	local ui = {unpack(self._base:GetDescendants()), self._base}

	self.opened = false

	local info = TweenInfo.new(0.1, Enum.EasingStyle.Cubic)

	local tween = tweenService:Create(self._base, info, {Size = UDim2.fromOffset(self.sx - 200, self.sy - 200), BackgroundTransparency = 1})

	for _, obj in next, self._base:GetDescendants() do 
		local properties = transparencyProperties[obj.ClassName]
		if properties then
			for i = 1, #properties do 
				tweenService:Create(obj, info, {[properties[i]] = 1}):Play()
			end
		end
	end

	self._closed:Fire()

	tween:Play()
	return tween.Completed
end

function widgetobject:destroy()
	self._closed:Destroy()
	self._base:Destroy()
end

function widgetobject:open()
	self.opened = true

	local info = TweenInfo.new(0.1, Enum.EasingStyle.Cubic)

	self._base.Size = UDim2.fromOffset(self.sx - 200, self.sy - 200)
	self._base.BackgroundTransparency = 1

	local tween = tweenService:Create(self._base, info, {Size = UDim2.fromOffset(self.sx, self.sy), BackgroundTransparency = 0})

	for _, obj in next, self._base:GetDescendants() do 
		local properties = transparencyProperties[obj.ClassName]
		if properties then
			for i = 1, #properties do 
				local og = obj[properties[i]]
				obj[properties[i]] = 1
				tweenService:Create(obj, info, {[properties[i]] = og}):Play()
			end
		end
	end

	tween:Play()
	return tween.Completed
end

function widgetobject:title(str)
	self._base.top.holder.left.label.Size = UDim2.new(0,game:GetService("TextService"):GetTextSize(str, 25, Enum.Font.Legacy, Vector2.new(self.sx, 0)).X,1,0)
	self._base.top.holder.left.label.Text = str
end

function widgetobject:icon(str)
	self._base.top.holder.left.icon.Image = str
end

function widgetobject:move(x, y)
	self._base.Position = UDim2.fromOffset(x, y)
	self.x = x 
	self.y = y 
end

function widgetobject:size(x, y)
	self.sx = x 
	self.sy = y 
	self._base.Size = UDim2.fromOffset(x, y)
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

	local widget = setmetatable({}, widgetobject)

	local size = UDim2.fromOffset(data.sx or 2127, data.sy or 1158)
	local new
	local last = os.clock()
	new = push{
		Size = size,
		AnchorPoint = Vector2.one/2,
		Position = UDim2.fromOffset(data.x or (console.AbsoluteSize.X / 2), data.y or (console.AbsoluteSize.Y / 2)),
		BackgroundColor3 = scheme.border,

		children = {
			corner = {
				class = "UICorner",

				CornerRadius = UDim.new(0,20)
			},
			top = {
				BackgroundColor3 = scheme.dark,
				Size = UDim2.new(1,0,0,80),

				children = {
					cover = {
						Size = UDim2.fromScale(1,0.3),
						Position = UDim2.fromScale(0,0.7),
						BackgroundColor3 = scheme.dark,
						BorderSizePixel = 0,
					},
					corner = {
						class = "UICorner",

						CornerRadius = UDim.new(0,20)
					},
					holder = {
						input = {
							Drag = function(position)
								tweenService:Create(new, TweenInfo.new(os.clock() - last, Enum.EasingStyle.Linear), {Position = position + UDim2.fromOffset(new.AbsoluteSize.X/2, new.AbsoluteSize.Y/2)}):Play()
								widget.x = new.AbsolutePosition.X
								widget.y = new.AbsolutePosition.Y
								last = os.clock()
							end,
						},


						Size = UDim2.fromScale(1,1),
						BackgroundTransparency = 1,

						children = { 
							padding = {
								class = "UIPadding",

								PaddingBottom = UDim.new(0,13),
								PaddingLeft = UDim.new(0,13),
								PaddingRight = UDim.new(0,13),
								PaddingTop = UDim.new(0,13),
							},
							left = {
								Size = UDim2.fromScale(0.5,1),
								BackgroundTransparency = 1,
								ZIndex = 2,

								children = {
									list = {
										class = "UIListLayout",

										FillDirection = Enum.FillDirection.Horizontal,
										Padding = UDim.new(0,16)
									},
									icon = {
										class = "ImageLabel",

										Image = data.icon or "rbxassetid://12154980802",
										Size = UDim2.new(0,50,1,0),
										BackgroundTransparency = 1,
										ScaleType = Enum.ScaleType.Fit
									},
									label = {
										class = "TextBox",

										TextEditable = false,
										ClearTextOnFocus = false,
										TextColor3 = scheme.main_text,
										Text = name,
										TextSize = 25,
										TextXAlignment = Enum.TextXAlignment.Left,
										TextTruncate = Enum.TextTruncate.AtEnd,
										Size = UDim2.new(0,game:GetService("TextService"):GetTextSize(name, 25, Enum.Font.Legacy, Vector2.new(size.X, 0)).X,1,0),
										BackgroundTransparency = 1
									}
								}
							},
							right = {
								Size = UDim2.fromScale(0.5,1),
								Position = UDim2.fromScale(0.5, 0),
								BackgroundTransparency = 1,
								ZIndex = 2,

								children = {
									list = {
										class = "UIListLayout",

										FillDirection = Enum.FillDirection.Horizontal,
										Padding = UDim.new(0,6),
										HorizontalAlignment = Enum.HorizontalAlignment.Right,
									},

									[1] = {
										class = "TextButton",
										input = {
											MouseB1Down = function()
											end,
										},

										Text = "-",
										TextColor3 = scheme.main_text,
										TextSize = 35,
										Size = UDim2.new(0,50,1,0),
										BackgroundTransparency = 1,
									},
									[2] = {
										class = "TextButton",
										input = {
											MouseB1Down = function()
											end,
										},

										Text = "□",
										TextColor3 = scheme.main_text,
										TextSize = 25,
										Size = UDim2.new(0,50,1,0),
										BackgroundTransparency = 1,
									},
									[3] = {
										class = "TextButton",
										input = {
											MouseB1Down = function()
												widget:close():Wait()
												widget:destroy()
											end,
										},

										Text = "X",
										TextColor3 = scheme.main_text,
										TextSize = 18,
										Size = UDim2.new(0,50,1,0),
										BackgroundTransparency = 1,
									},
								}
							}
						}
					}
				}
			},
			holder = {
				Position = UDim2.fromOffset(0,80),
				BackgroundTransparency = 1,
				Size = UDim2.new(1,0,1,-80),

				children = {
					padding = {
						class = "UIPadding",

						PaddingBottom = UDim.new(0,2),
						PaddingLeft = UDim.new(0,2),
						PaddingRight = UDim.new(0,2),
						PaddingTop = UDim.new(0,2),
					},
					corner = {
						class = "UICorner",

						CornerRadius = UDim.new(0,20)
					},
				}
			}
		}
	}

	widget.x = new.Position.X.Offset
	widget.y =new.Position.Y.Offset
	widget.sx = new.Size.X.Offset
	widget.sy = new.Size.Y.Offset

	new.Parent = self._base

	local closed = Instance.new("BindableEvent")
	widget._closed = closed
	widget.closed = closed.Event

	widget._base = new

	return widget
end

function screenobject:prompt(type, title, text)
	local widget = self:widget(title)
end

function screenobject:mount(ui)
	ui.Parent = self._base
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

--desktop:prompt(0, "scandalOS is currently running on version "..VER, "scandalOS")

local sys = push{
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
					input = {
						MouseB1Down = function()
							tweenService:Create(objects.start_button, TweenInfo.new(0.4, Enum.EasingStyle.Cubic), {Rotation = objects.start_button.Rotation + 90}):Play()
						end,
						MouseEnter = function()
							tweenService:Create(objects.start_button, TweenInfo.new(0.4, Enum.EasingStyle.Cubic), {Size = UDim2.fromScale(0.049, 0.59)}):Play()
						end,
						MouseLeave = function()
							tweenService:Create(objects.start_button, TweenInfo.new(0.4, Enum.EasingStyle.Cubic), {Size = UDim2.fromScale(0.04, 0.5)}):Play()
						end,
					},

					Image = "rbxassetid://4689592016",
					Size = UDim2.fromScale(0.04, 0.5),
					Rotation = 45,
					AnchorPoint = Vector2.one / 2,
					ScaleType = Enum.ScaleType.Fit,
					Position = UDim2.fromScale(0.02,0.5),
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
}

main:mount(sys)

local Extentions = {
	["exe"] = {function() end, icon = "rbxassetid://12154969411"},
	["lua"] = {function() end, icon = "rbxassetid://5588630"},
	["dec"] = {function(s)
		s:icon(s.data.content)
	end},
	["txt"] = {function() end, icon = "rbxassetid://12154964558"},
	["snd"] = {function() end, icon = "rbxassetid://9206046736"},

	["_exp"] = {function() end, icon = "rbxassetid://12153795262"},
	["_rec"] = {function() end, icon = "rbxassetid://12154966342"}
}

local files = {
	["_THISPC"] = {
		name = "This PC",
		internal = true,
		visible = false,
		icon = "rbxassetid://12166186986",
		children = {}
	}
}


files._THISPC.children._DESKTOP = {
	name = "Desktop",
	internal = true,
	icon = "rbxassetid://12166175276",
	parent = files._THISPC,
	children = {}
}
files._THISPC.children._DOCUMENTS = {
	name = "Documents",
	internal = true,
	icon = "rbxassetid://12166015476",
	parent = files._THISPC,
	children = {}
}
files._THISPC.children._PICTURES = {
	name = "Pictures",
	internal = true,
	icon = "rbxassetid://12166015476",
	parent = files._THISPC,
	children = {}
}
files._THISPC.children._MUSIC = {
	name = "Music",
	internal = true,
	icon = "rbxassetid://12166016634",
	parent = files._THISPC,
	children = {}
}

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

function getFile(name, dir)
	for id, d in dir  do
		if d.name == name then
			return d, id
		end
	end
end

function newfile(title, ext, app, path)
	local extData = Extentions[ext]
	local obj = push(file)

	obj.label.Text = title

	local inputs = {
		MouseEnter = function()
			obj.highlight.BackgroundTransparency = 0.7
		end,
		MouseLeave = function()
			obj.highlight.BackgroundTransparency = 1
		end,
	}

	local file = setmetatable({}, appobject)

	if app.activated then
		local clickts = os.clock()
		inputs.MouseB1Down = function()
			if os.clock() - clickts < 0.2 then
				app.activated(file)
			end
			clickts = os.clock()
		end
	end

	InputObjects[obj] = inputs

	file._base = obj
	file._icon = app.icon or ((extData and extData.icon) or "rbxassetid://12154980802")
	file.data = app
	file.path = path .. "/" .. title .. "." .. ext

	obj.icon.Image = file._icon

	local dir = path:split("/")
	local parent = getFile("This PC", files)

	for i = 1, #dir do 
		local found = getFile(dir[i], parent.children)
		if found then
			parent = found
		end
	end
	if not parent then
		error(path.. " is not a valid path")
		return
	end
	if path == "Desktop" then
		obj.Parent = objects.desktop_apps
	end

	if extData then
		extData[1](file)
	end


	parent.children[game:GetService("HttpService"):GenerateGUID()] = {
		name = title,
		ext = ext,
		icon = file._icon,
		children = {},
		parent = parent,
	}

	return file
end

do -- INTERNAL FILES
	local removed = {}	


	newfile("Command Prompt", "exe", {
		activated = function()
			local w = desktop:widget("Command Prompt", {
				icon = "rbxassetid://12167518904"
			})
			local txt = "scandalOS [Version "..VER.."]\nscandalous#2792\n\nC:/Desktop/"
			local ui = push{
				Size = UDim2.fromScale(1,1),
				BackgroundColor3 = Color3.new(),

				children = {
					corner = {
						class = "UICorner",

						CornerRadius = UDim.new(0,20)
					},
					cover = {
						Size = UDim2.fromScale(1,0.04),
						BackgroundColor3 = Color3.new(),
						BorderSizePixel = 0,
						ZIndex = 0, 
					},
					label = {
						class = "TextBox",

						ZIndex = 2,
						Size = UDim2.fromScale(1,1),
						BackgroundTransparency = 1,
						TextSize = 30,
						TextColor3 = Color3.new(1,1,1),
						TextXAlignment = Enum.TextXAlignment.Left,
						TextYAlignment = Enum.TextYAlignment.Top,
						ClearTextOnFocus = false,
						TextEditable = false,
						Text = "scandalOS [Version "..VER.."]\nscandalous#2792\n\nC:/Desktop/",
					}
				}
			}
			
			w:mount(ui)
			
			task.defer(function()
				local i = 0
				while true do 
					task.wait(0.5)
					i += 1
					ui.label.Text = txt .. (i%2 == 0 and "█" or "")
				end
			end)

		end,
		icon = "rbxassetid://12167518904"
	}, "Desktop")

	function openExplorer(path)
		local widget = desktop:widget("File Explorer", {
			icon = Extentions._exp.icon
		})
		local exp = {}
		local selected
		local explorer = push{
			Size = UDim2.fromScale(1,1),
			Position = UDim2.fromOffset(0.5,0.5),
			BackgroundColor3 = scheme.main,

			children = {
				cover = {
					Size = UDim2.fromScale(1,0.04),
					BackgroundColor3 = scheme.dark,
					BorderSizePixel = 0,
					ZIndex = 0, 

					children = {
						label = {
							ref = {"adr", exp},
							class = "TextBox",

							Size = UDim2.fromScale(1 - 0.22,1),
							Position = UDim2.fromScale(0.22,0),
							TextColor3 = scheme.main_text,
							TextSize = 18,
							TextXAlignment = Enum.TextXAlignment.Left,
							BackgroundTransparency = 1,
							ClearTextOnFocus = false,
							Text = "C:/"..(path or "")
						}
					}
				},
				main = {
					Position = UDim2.fromScale(0.21,0.04),
					Size = UDim2.fromScale(0.79,1 - 0.04),
					BackgroundTransparency = 1,

					children = {
						inner = {
							class = "ScrollingFrame",
							ref = {"inner", exp},

							Size = UDim2.fromScale(1,1),
							BackgroundTransparency = 1,
							ClipsDescendants = true,

							children = {
								grid = {
									class = "UIGridLayout",

									CellPadding = UDim2.fromOffset(33,33),
									CellSize = UDim2.fromOffset(180,180)
								},
							}
						},
						padding = {
							class = "UIPadding",

							PaddingBottom = UDim.new(0,30),
							PaddingLeft = UDim.new(0,30),
							PaddingRight = UDim.new(0,30),
							PaddingTop = UDim.new(0,30),
						}
					}
				},
				corner = {
					class = "UICorner",

					CornerRadius = UDim.new(0,20),
				},
				side = {						
					BorderSizePixel = 0,
					Size = UDim2.fromScale(0.21,1),
					BackgroundColor3 = scheme.dark,

					children = {
						holder = {
							Size = UDim2.fromScale(1,1),
							BackgroundTransparency = 1,

							children = {
								padding = {
									class = "UIPadding",

									PaddingBottom = UDim.new(0,9),
									PaddingLeft = UDim.new(0,9),
									PaddingRight = UDim.new(0,9),
									PaddingTop = UDim.new(0,9),
								},
								scroll = {
									class = "ScrollingFrame",
									ref = {"scroll", exp},

									BorderSizePixel = 0,
									BackgroundTransparency = 1,
									Size = UDim2.fromScale(1,1),

									children = {
										list = {
											class = "UIListLayout",
										},	
									}
								},
							}
						},
						corner = {
							class = "UICorner",

							CornerRadius = UDim.new(0,20)
						},
						cover = {
							Position = UDim2.fromScale(0.97,0),
							Size = UDim2.fromScale(0.03,1),
							BackgroundColor3 = scheme.dark,
							BorderSizePixel = 0,
						}
					}
				}
			}
		}

		widget:mount(explorer)
		widget:open()

		local function rec(tble, preopen, parent, indent)
			indent = indent or 0
			for id, data in tble do 
				local name = data.name
				local toggle = false 
				local s = {}

				local tab = push{
					Size = UDim2.new(1,0,0,60),
					BackgroundTransparency = 1,
					Name = "child",
					ref = {"tab", s},

					children = {
						list = {
							class = "UIListLayout",

							HorizontalAlignment = Enum.HorizontalAlignment.Right,
						},
					}
				}

				local haschildren = false

				local children = {}
				for id, data2 in next, data.children do 
					if data2.folder or data2.internal then
						children[id] = data2
						haschildren = true
					end
				end

				local md

				local dropdown = {
					ref = {"dd", s},
					class = "TextButton",
					input = {
						MouseEnter = function()
							if selected ~= s.dd then
								s.dd.BackgroundTransparency = 0.8
							end
						end,
						MouseLeave = function()
							if selected ~= s.dd then
								s.dd.BackgroundTransparency = 1
							end
						end,
						MouseB1Down = function()
							if selected then
								selected.BackgroundTransparency = 1
							end
							s.dd.BackgroundTransparency = 0.65
							selected = s.dd
							local path = {}
							local dir = data

							while true do
								if dir.parent == nil then
									break
								end
								table.insert(path, dir.name .. (dir.ext and ("." .. dir.ext) or ""))
								dir = dir.parent
							end 
							print(path)
							for i = 1, math.floor(#path/2) do
								local j = #path - i + 1
								path[i], path[j] = path[j], path[i]
							end

							exp.adr.Text = "C:/"..table.concat(path, "/")

							for _, obj in exp.inner:GetChildren() do 
								if not obj:IsA("UIGridLayout") then
									obj:Destroy()
								end
							end
							for _, data2 in data.children do 
								local name2 = data2.name
								local new = push(file)
								new.label.Text = name2
								new.label.TextSize /= 2
								new.icon.Image = data2.icon
								new.Parent = exp.inner
							end
						end,
					},

					AutoButtonColor = false,
					BorderSizePixel = 0,
					BackgroundColor3 = Color3.new(1,1,1),
					Text = "",
					Size = UDim2.new(1,-25 * indent,0,60),
					BackgroundTransparency = 1,

					children = {
						list = {
							class = "UIListLayout",

							FillDirection = Enum.FillDirection.Horizontal,
							Padding = UDim.new(0,12)
						},
						drop = {
							input = haschildren and {
								MouseB1Down = function()
									toggle = not toggle
									s.btn.Text = toggle and "v" or ">"
									if toggle then
										local i = 1
										for _, obj in s.tab:GetChildren() do 
											if obj.Name == "child" then
												obj.Visible = true
												i += 1
											end
										end
										s.tab.Size = UDim2.new(1,0,0,60 * i)
									else 
										s.tab.Size = UDim2.new(1,0,0,60)
										for _, obj in s.tab:GetChildren() do 
											if obj.Name == "child" then
												obj.Visible = false
											end
										end
									end
								end,
							} or nil,
							ref = {"btn", s},
							class = "TextButton",

							TextColor3 = scheme.main_text,
							Text = haschildren and ">" or "",
							TextSize = 30,
							FontFace = Font.new("rbxasset://fonts/families/FredokaOne.json", Enum.FontWeight.Bold),
							Size = UDim2.new(0,30,0,60),
							TextTransparency = 0.4,
							BackgroundTransparency = 1
						},
						icon = {
							class = "ImageLabel",

							Image = data.icon,
							Size = UDim2.new(0,50,0,60),
							BackgroundTransparency = 1,
							ScaleType = Enum.ScaleType.Fit
						},
						label = {
							class = "TextBox",

							TextEditable = false,
							ClearTextOnFocus = false,
							TextColor3 = scheme.main_text,
							Text = name,
							TextSize = 25,
							TextXAlignment = Enum.TextXAlignment.Left,
							TextTruncate = Enum.TextTruncate.AtEnd,
							Size = UDim2.new(1,-50,0,60),
							BackgroundTransparency = 1
						}
					}
				}

				tab.Parent = parent or exp.scroll

				if parent then
					tab.Visible = false
				end

				push(dropdown).Parent = s.tab
				rec(children, preopen, tab, (indent or 0) + 1)

				if preopen and id == preopen then
					local toopen = parent
					while true do
						if toopen == exp.scroll then
							break
						end
						local i = 1
						toopen.TextButton.drop.Text = "v"
						for _, obj in toopen:GetChildren() do 
							if obj.Name == "child" then
								obj.Visible = true
								i += 1
							end
						end
						s.tab.Size = UDim2.new(1,0,0,60 * i)
						toopen = toopen.Parent
					end 
					InputObjects[s.dd].MouseB1Down()
				end
			end
		end

		if path then
			exp.adr.Text = "C:/" .. path
			local dir = path:split("/")
			local parent = getFile("This PC", files).children

			for i = 1, #dir do 
				local found, id = getFile(dir[i], parent)
				if found then
					if i == #dir then
						parent = id
					else 
						parent = found.children
					end
				end
			end

			if not parent then
				error(path.. " is not a valid path")
				return
			end

			rec(files, parent)
		else
			rec(files)
		end
	end

	local exp = newfile("File Explorer", "_exp", {
		activated = function()
			openExplorer()
		end,
	}, "Desktop") 
	local rec = newfile("Recycle Bin", "_rec", {}, "Desktop")

	local recyclebin = {
		delete = function(path)
			local dir = path:split("/")
			local parent = getFile("This PC", files).children

			for i = 1, #dir do 
				local found = getFile(dir[i], parent)
				if found then
					parent = found.children
					if i == #dir and not found.internal then
						removed[path] = found
						file[dir[i]] = nil
						rec:icon("rbxassetid://12154971175")
					end
				end
			end
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

			rec:icon("rbxassetid://12154966342")
		end,
		clear = function()
			for i, v in removed do 
				v.object:Destroy()
			end
			table.clear(removed)
		end,
	}
end


function newfolder(title, path)
	local obj = push(file)

	obj.label.Text = title
	local clickts = os.clock()

	InputObjects[obj] = {
		MouseEnter = function()
			obj.highlight.BackgroundTransparency = 0.7
		end,
		MouseLeave = function()
			obj.highlight.BackgroundTransparency = 1
		end,
		MouseB1Down = function()
			if os.clock() - clickts < 0.2 then
				openExplorer(path .. "/" .. title)
			end
			clickts = os.clock()
		end
	}

	local file = setmetatable({}, appobject)
	file._base = obj
	file._icon = "rbxassetid://12154972021"
	file._folder = true
	file.path = path .. "/" .. title

	local dir = path:split("/")
	local parent = getFile("This PC", files)

	for i = 1, #dir do 
		local found = getFile(dir[i], parent.children)
		if found then
			parent = found
		end
	end	
	if not parent then
		error(path.. " is not a valid path")
		return
	end

	if path == "Desktop" then
		obj.Parent = objects.desktop_apps
	end

	parent.children[game:GetService("HttpService"):GenerateGUID()] = {
		name = title,
		object = obj,
		icon = file._icon,
		folder = true,
		children = {},
		parent = parent,
	}

	obj.icon.Image = file._icon

	return file
end

local hw = newfolder("HOMEWORK", "Desktop")

owner.Chatted:Connect(function()

end)


if game:GetService("RunService"):IsStudio() then
	function NLS(s,p) local locals = script.lc locals.Parent = p locals.Enabled = true return locals end
end
local Client = NLS([[local UI = script:WaitForChild("UI").Value

local mse = owner:GetMouse()

local UIS = game:GetService("UserInputService")
function dragify(Frame)
	print("listening to drag events")
	local dragToggle
	local dragSpeed
	local dragInput
	local dragStart
	local dragPos
	local startPos
	
	local offset = Vector2.new()

	local function updateInput(input)
		local relative = (-UI.Parent.CFrame:PointToObjectSpace(mse.Hit.Position) + UI.Parent.Size/2) * UI.PixelsPerStud
		script.Parent.Input:FireServer("Drag", Frame, UDim2.fromOffset(relative.X - offset.X, relative.Y - offset.Y))
	end
	Frame.InputBegan:Connect(function(input)
		if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and UIS:GetFocusedTextBox() == nil then
			dragToggle = true
			dragStart = input.Position
			startPos = Frame.Position
						script.Parent.Input:FireServer("Focus", Frame)
		local relative = (-UI.Parent.CFrame:PointToObjectSpace(mse.Hit.Position) + UI.Parent.Size/2) * UI.PixelsPerStud
			offset = Vector2.new(relative.X - Frame.AbsolutePosition.X, relative.Y- Frame.AbsolutePosition.Y)
			local ch
			ch = input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragToggle = false
					script.Parent.Input:FireServer("Unfocus", Frame)
					ch:Disconnect()
				end
			end)
		end
	end)
	Frame.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)
	local last = os.clock()
	game:GetService("UserInputService").InputChanged:Connect(function(input)
		if input == dragInput and dragToggle and (os.clock() - last > 0.03) then
			last = os.clock()
			updateInput(input)
		end
	end)
end

function Check(Object)
	if Object:IsA("TextButton") or Object:IsA("ImageButton") then
		Object.MouseEnter:Connect(function()
			script.Parent.Input:FireServer("MouseEnter", Object)
		end)
		Object.MouseLeave:Connect(function()
			script.Parent.Input:FireServer("MouseLeave", Object)
		end)
		Object.MouseButton1Down:Connect(function()
			script.Parent.Input:FireServer("MouseB1Down", Object)
		end)
		Object.MouseButton1Up:Connect(function()
			script.Parent.Input:FireServer("MouseB1Up", Object)
		end)
	end
end

UI.DescendantAdded:Connect(Check)

for _, Object in next, UI:GetDescendants() do
	Check(Object)
end

script.Parent.Input.OnClientEvent:Connect(function(Type, Object)
	if Type == "drag" then
		dragify(Object)
	end
end)]], owner.Character)
local Value = Instance.new("ObjectValue")
Value.Name = "UI"
Value.Value = console
Value.Parent = Client

Input.OnServerEvent:Connect(function(owner, Type, Object, ...)
	local Inp = InputObjects[Object]
	if Inp then
		local Func = Inp[Type]
		if Func then
			Func(...)
		end
	end
end)
