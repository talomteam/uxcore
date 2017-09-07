local Str = ""
local function TableToXML_(Tab, Key2, Depth, Attributes2)
    print (Tab)
	for Key, Value in Pairs(Tab) do
		if Type(Key) == "string" and Type(Value) == "table" then
			if Key ~= "_attr" then
				if Value[1] then
					local Attributes = ""
					
					if Value._attr then
						Attributes = " "
						for Key, Value in Pairs(Value._attr) do
							Attributes = Attributes .. ToString(Key) .. "=\"" .. ToString(Value) .. "\" "
						end
					end
					
					Attributes = Attributes:Substring(1, #Attributes - 1)
					
					TableToXML_(Value, Key, Depth, Attributes)
				else
					local Attributes = ""
					
					if Value._attr then
						Attributes = " "
						for Key, Value in Pairs(Value._attr) do
							Attributes = Attributes .. ToString(Key) .. "=\"" .. ToString(Value) .. "\" "
						end
					end
					
					Attributes = Attributes:Substring(1, #Attributes - 1)
					
					Str = Str .. String.Repeat("\t", Depth) .. "<" .. ToString(Key) .. Attributes .. ">\n"
					
					TableToXML_(Value, Key, Depth + 1, Attributes)
					
					Str = Str .. String.Repeat("\t", Depth) ..  "</" .. ToString(Key) .. ">\n"
				end
			end
		elseif Type(Key) == "number" and Type(Value) == "table" then
			local Attributes = ""
				
			if Value._attr then
				Attributes = " "
				for Key, Value in Pairs(Value._attr) do
					Attributes = Attributes .. ToString(Key) .. "=\"" .. ToString(Value) .. "\" "
				end
			end
			
			Attributes = Attributes:Substring(1, #Attributes - 1)
		
			Str = Str .. String.Repeat("\t", Depth) ..  "<" .. ToString(Key2) .. Attributes .. ">\n"
			
			TableToXML_(Value, Key, Depth + 1, Attributes)
			
			Str = Str .. String.Repeat("\t", Depth) ..  "</" .. ToString(Key2) .. ">\n"
		
		elseif Type(Key) == "string" then
			Str = Str .. String.Repeat("\t", Depth) ..  "<" .. ToString(Key) .. ">" .. ToString(Value) .. "</" .. ToString(Key) .. ">\n"
		else
			Attributes2 = Attributes2 or ""
			Str = Str .. String.Repeat("\t", Depth) ..  "<" .. ToString(Key2) .. Attributes2 .. ">" .. ToString(Value) .. "</" .. ToString(Key2) .. ">\n"
		end
	end
end 

function TableToXML(Tab)
	Str = ""
	
	TableToXML_(Tab, "", 0)
	
	return Str
end