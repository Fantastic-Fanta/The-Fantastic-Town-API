local ImportCode = "ABCD" -- Your import code, please import your model in first beforehand into workspace
local Connector = "Simple" -- 'Simple' or 'Arrows'

local PresetBeams = {
	Simple = {
		Width = 0.1,
		Texture = ""
	},
	Arrows = {
		Texture = "rbxassetid://12338397670",
		Width = 1
	}
}

local HighlightColors = {
	TransparencyUnset = Color3.new(1, 0.948821, 0),
	NoLink = Color3.new(1, 0.0747387, 0)
}

local function LinkSignals(M)
	local CreateBeam = function(a,b,c,p)
		local Connection = Instance.new("Beam",M)
		Connection.Attachment0 = a
		Connection.Attachment1 = b
		Connection.Color = ColorSequence.new(c)
		Connection.Width0 = p.Width
		Connection.Width1 = p.Width
		Connection.Enabled = true
		Connection.Transparency = NumberSequence.new(0)
		Connection.Texture = p.Texture
		Connection.TextureMode = Enum.TextureMode.Static
		Connection.TextureLength = 2
		Connection.TextureSpeed = 1 
		Connection.LightEmission = 1 
		Connection.LightInfluence = 0
		Connection.FaceCamera = true
	end
	
	local CreateHighlight = function(a,t)
		local HL = Instance.new("Highlight",a)
		HL.OutlineColor = HighlightColors[t]
		HL.FillColor = Color3.new(1,1,1)
		HL.FillTransparency = 0.5
	end

	local Send,Recv,Err,Count = {},{},{},{}
	for _,v in ipairs(M:GetChildren()) do
		
		if v.Name == "InSignal" then
			table.insert(Send, v)
		elseif v.Name == "OutSignal" then
			table.insert(Recv, v)
		end
		
		if v:FindFirstChild("Texture") and math.abs(v.Texture.Transparency) ~= 500 and v.Name ~= "BaseHinge" then
			print("Unset")
			CreateHighlight(v,"TransparencyUnset")
		end
	end

	for _, i in ipairs(Send) do
		for _, o in ipairs(Recv) do
			if i.Color == o.Color then
				local a = Instance.new("Attachment",o)
				local b = Instance.new("Attachment",i)
				a.Position = Vector3.new(0, 0, 0)
				b.Position = Vector3.new(0, 0, 0)
				CreateBeam(a,b,i.Color,PresetBeams[Connector])
				table.insert(Count,i)
				table.insert(Count,o)
			end
		end
	end
	
	table.foreach(Send,function(_,c) if not table.find(Count,c) then CreateHighlight(c,"NoLink") end end)
	table.foreach(Recv,function(_,c) if not table.find(Count,c) then CreateHighlight(c,"NoLink") end end)
end

task.wait(1)
local ImportedModel = workspace:WaitForChild("Import "..string.upper(ImportCode)) or workspace:FindFirstChild("Model")
LinkSignals(ImportedModel)
