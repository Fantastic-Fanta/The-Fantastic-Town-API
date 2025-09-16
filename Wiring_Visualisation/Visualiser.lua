
-- Configs --
local ImportCode = "ABCD" -- Your import code, please import your model in first beforehand into workspace
local Connector = "Simple" -- 'Simple' or 'Arrows'


-- Yap --
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

local Create = {
	Beam = function(a,b,c,p,m)
		local Connection = Instance.new("Beam",m)
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
	end,
	Highlight = function(a,t)
		local HL = Instance.new("Highlight",a)
		HL.OutlineColor = HighlightColors[t]
		HL.FillColor = Color3.new(1,1,1)
		HL.FillTransparency = 0.5
	end
}

local function LinkSignals(M)
	local Send,Recv,Err,Count = {},{},{},{}
	for _,v in ipairs(M:GetChildren()) do
		if v.Name == "InSignal" then
			table.insert(Send, v)
		elseif v.Name == "OutSignal" then
			table.insert(Recv, v)
		end
		
		if v:FindFirstChild("Texture") and math.abs(v.Texture.Transparency) ~= 500 and v.Name ~= "BaseHinge" then
			print("Unset")
			Create.Highlight(v,"TransparencyUnset")
		end
		
		if not v:FindFirstChild("Texture") and v.Transparency <=0.9 then
			v.Transparency = 0.9
		else
			v.Transparency = 0
		end
	end

	for _, i in ipairs(Send) do
		for _, o in ipairs(Recv) do
			if i.Color == o.Color then
				local a = Instance.new("Attachment",o)
				local b = Instance.new("Attachment",i)
				a.Position = Vector3.new(0, 0, 0)
				b.Position = Vector3.new(0, 0, 0)
				Create.Beam(a,b,i.Color,PresetBeams[Connector],M)
				table.insert(Count,i)
				table.insert(Count,o)
			end
		end
	end
	
	table.foreach(Send,function(_,c) if not table.find(Count,c) then Create.Highlight(c,"NoLink") end end)
	table.foreach(Recv,function(_,c) if not table.find(Count,c) then Create.Highlight(c,"NoLink") end end)
end

local ImportedModel = workspace:WaitForChild("Import "..string.upper(ImportCode),2)
if not ImportedModel then
	local HTTP = game:GetService("HttpService")
	local Raw = HTTP:GetAsync(
		"http://apis.valencel.com/bt/export/"..ImportCode,
		false, 
		{
			["bv-userid"] = "0000",
			["bv-productid"] = "BVProj.Valencel.BTWebService.ExportImportPlugin @1.8.0",
			["bv-productkey"] = "0000"
		}
	)
	if Raw then

		-- This part is cut from SerializerV3 module, can be found in F3X source
		Data = HTTP:JSONDecode(Raw)
		local Build,Instances = {},{}
		local Support = {
			FindTableOccurrence = function(Haystack, Needle)
				for Index, Value in pairs(Haystack) do
					if Value == Needle then
						return Index;
					end;
				end;
				return nil
			end,
			Slice = function (Table, Start, End)
				local Slice = {};
				for Index = Start, End do
					table.insert(Slice, Table[Index]);
				end;
				return Slice;
			end;
		}
		local Types = {
			Part = 0,
			WedgePart = 1,
			CornerWedgePart = 2,
			VehicleSeat = 3,
			Seat = 4,
			TrussPart = 5,
			Texture = 7,
			Decal = 8,
		};
		local DefaultNames = {
			Part = 'Part',
			WedgePart = 'Wedge',
			CornerWedgePart = 'CornerWedge',
			VehicleSeat = 'VehicleSeat',
			Seat = 'Seat',
			TrussPart = 'Truss',
			Texture = 'Texture',
			Decal = 'Decal',
		};

		local Build = {};
		local Instances = {};
		for Index, Datum in ipairs(Data.Items) do
			if Datum[1]<6
			then
				local Item = Instance.new(Support.FindTableOccurrence(Types, Datum[1]));
				Item.Size = Vector3.new(unpack(Support.Slice(Datum, 4, 6)));
				Item.CFrame = CFrame.new(unpack(Support.Slice(Datum, 7, 18)));
				Item.Color = Color3.new(Datum[19], Datum[20], Datum[21]);
				Item.Material = Datum[22];
				Item.Anchored = Datum[23] == 1;
				Item.CanCollide = Datum[24] == 1;
				Item.Reflectance = Datum[25];
				Item.Transparency = Datum[26];
				Instances[Index] = Item;
			end;
			if table.find({0,3,4},Datum[1]) then
				local Item = Instances[Index];
				if not Datum[1] then
					Item.Shape = Datum[33];
				end
			end;
			if Datum[1] == 5 then
				local Item = Instances[Index];
				Item.Style = Datum[33];
			end;
			if table.find({7,8},Datum[1]) then
				local Item = Instance.new(Support.FindTableOccurrence(Types, Datum[1]));
				Item.Texture = Datum[4];
				Item.Transparency = Datum[5];
				Item.Face = Datum[6];
				Instances[Index] = Item;
				if Datum[1] == 7 then
					local Item = Instances[Index];
					Item.StudsPerTileU = Datum[7];
					Item.StudsPerTileV = Datum[8];
				end;
			end;
		end;

		for Index, Datum in pairs(Data.Items) do
			local Item = Instances[Index];
			if Item and Datum[1] <= 18 then
				Item.Name = (Datum[3] == '') and DefaultNames[Item.ClassName] or Datum[3];
				if Datum[2] == 0 then
					table.insert(Build, Item);
				else
					Item.Parent = Instances[Datum[2]];
				end;
			end;
		end;
		local Model = Instance.new("Model",workspace)
		Model.Name = "Import "..string.upper(ImportCode)
		for _,v in pairs(Build) do
			v.Parent = Model
		end
		ImportedModel = Model
	end
end

task.wait(1)
LinkSignals(ImportedModel)
