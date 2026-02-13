local BubbleIcons = CreateFrame("Frame")
BubbleIcons:SetScript("OnEvent", function(self, event, ...) self[event](self, ...) end)
BubbleIcons:RegisterEvent("PLAYER_ENTERING_WORLD")

local gmatch, gsub, lower = string.gmatch, string.gsub, string.lower
local ICON_LIST = ICON_LIST
local ICON_TAG_LIST = ICON_TAG_LIST

local ICON_LIST_LOCALIZED = {
	-- deDE
	["stern"] = "rt1",
	["kreis"] = "rt2",
	["diamant"] = "rt3",
	["dreieck"] = "rt4",
	["mond"] = "rt5",
	["quadrat"] = "rt6",
	["kreuz"] = "rt7",
	["totenschädel"] = "rt8",
	-- enUS
	["star"] = "rt1",
	["circle"] = "rt2",
	["diamond"] = "rt3",
	["triangle"] = "rt4",
	["moon"] = "rt5",
	["square"] = "rt6",
	["cross"] = "rt7",
	["skull"] = "rt8",
	-- esES/esMX
	["estrella"] = "rt1",
	["círculo"] = "rt2",
	["circulo"] = "rt2",
	["diamante"] = "rt3",
	["triángulo"] = "rt4",
	["triangulo"] = "rt4",
	["luna"] = "rt5",
	["cuadrado"] = "rt6",
	["cruz"] = "rt7",
	["calavera"] = "rt8",
	-- frFR
	["étoile"] = "rt1",
	["etoile"] = "rt1",
	["cercle"] = "rt2",
	["losange"] = "rt3",
	["lune"] = "rt5",
	["carré"] = "rt6",
	["carre"] = "rt6",
	["croix"] = "rt7",
	["crâne"] = "rt8",
	["crane"] = "rt8",
	-- koKR
	["별"] = "rt1",
	["동그라미"] = "rt2",
	["다이아몬드"] = "rt3",
	["세모"] = "rt4",
	["달"] = "rt5",
	["네모"] = "rt6",
	["가위표"] = "rt7",
	["해골"] = "rt8",
	-- ruRU
	["звезда"] = "rt1",
	["круг"] = "rt2",
	["ромб"] = "rt3",
	["треугольник"] = "rt4",
	["полумесяц"] = "rt5",
	["квадрат"] = "rt6",
	["крест"] = "rt7",
	["череп"] = "rt8",
	-- zhCN
	["星形"] = "rt1",
	["圆形"] = "rt2",
	["菱形"] = "rt3",
	["三角"] = "rt4",
	["月亮"] = "rt5",
	["方块"] = "rt6",
	["十字"] = "rt7",
	["骷髅"] = "rt8",
	-- zhTW
	["星星"] = "rt1",
	["圈圈"] = "rt2",
	["鑽石"] = "rt3",
	["方形"] = "rt6",
	["頭顱"] = "rt8",
	-- itIT
	["stella"] = "rt1",
	["cerchio"] = "rt2",
	["rombo"] = "rt3",
	["triangolo"] = "rt4",
	["quadrato"] = "rt6",
	["croce"] = "rt7",
	["teschio"] = "rt8",
	-- ptBR
	["estrela"] = "rt1",
	["triângulo"] = "rt4",
	["lua"] = "rt5",
	["quadrado"] = "rt6",
	["xis"] = "rt7",
	["caveira"] = "rt8"
}

function BubbleIcons:PLAYER_ENTERING_WORLD()
	self:Show()
	self:SetScript("OnUpdate", function(self, elapsed)
		self.throttle = (self.throttle or 0.1) - elapsed
		if self.throttle < 0 then
			self.throttle = 0.1
			self:ProcessBubbles()
		end
	end)
end

function BubbleIcons:ProcessBubbles()
	for i = 1, WorldFrame:GetNumChildren() do
		local frame = select(i, WorldFrame:GetChildren())
		local backdrop = frame:GetBackdrop()
		
		if backdrop and backdrop.bgFile == [[Interface\Tooltips\ChatBubble-Background]] then
			for j = 1, frame:GetNumRegions() do
				local region = select(j, frame:GetRegions())
				
				if region:GetObjectType() == "FontString" then
					local text = region:GetText() or ""
					
					if text ~= region.lastText then
						local newText = text
						
						for tag in gmatch(text, "%b{}") do
							local term = lower(gsub(tag, "[{}]", ""))
							term = ICON_LIST_LOCALIZED[term] or term
							
							if ICON_TAG_LIST[term] and ICON_LIST[ICON_TAG_LIST[term]] then
								newText = gsub(newText, tag, ICON_LIST[ICON_TAG_LIST[term]] .. "0|t")
							end
						end
						
						region:SetText(newText)
						region.lastText = newText
					end
				end
			end
		end
	end
end
