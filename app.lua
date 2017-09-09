--[[ freeswitch.consoleLog("notice", "SECTION " .. XML_REQUEST["section"] .. "\n")
If XML_REQUEST['section'] == 'directory' then
  freeswitch.consoleLog("notice",params:serialize())
end

if XML_REQUEST['section'] == 'dialplan' then
  freeswitch.consoleLog("notice",params:serialize())
end

if XML_REQUEST['section'] == 'configuration' then
  freeswitch.consoleLog("notice",params:serialize())
end
]]
freeswitch.consoleLog("notice", "Debug from gen_dir_user_xml.lua, provided params:\n" .. params:serialize() .. "\n")