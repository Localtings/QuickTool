local ChangeHistoryService = game:GetService("ChangeHistoryService")
local Selection = game:GetService("Selection")

local toolbar = plugin:CreateToolbar("QuickTool")

local btn = toolbar:CreateButton(
	"QuickTool",
	"Create tools with ease.",
	string.format("rbxthumb://type=Asset&id=%s&w=420&h=420", "7673025")
) 

function validateType(ins)
	return ins:IsA("BasePart")
end

btn.ClickableWhenViewportHidden = true

btn.Click:Connect(function()
	local selectedObjects = Selection:Get()

	local handlePart, validPart

	for i, v in ipairs(selectedObjects) do
		if validateType(v) then 
			if v.Name == "Handle" then
				handlePart = v
				break
			else
				validPart = v
			end	
		end
	end

	local mainPart
	if handlePart then
		mainPart = handlePart
	elseif validPart then
		mainPart = validPart
	else
		error("None of the selected instances were valid.", 3)
	end

	--====

	local path = game:GetService("StarterPack")

	local tool = Instance.new("Tool")
	mainPart.Name = "Handle"

	for i, v in ipairs(selectedObjects) do
		v.Parent = tool
		if v ~= mainPart and validateType(v) then
			local weld = Instance.new("Weld")
			weld.Part0 = mainPart
			weld.Part1 = v
			weld.C0 = mainPart.CFrame:Inverse()
			weld.C1 = v.CFrame:Inverse()
			weld.Parent = mainPart
		end
	end

	tool.Parent = path
	ChangeHistoryService:SetWaypoint("Created a tool")
end)
