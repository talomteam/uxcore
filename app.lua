if XML_REQUEST == nil then
    return
end
 freeswitch.consoleLog("notice", XML_REQUEST['section'])
if XML_REQUEST['section'] == 'directory' then
  freeswitch.consoleLog("notice",params:serialize())
end

if XML_REQUEST['section'] == 'dialplan' then
  freeswitch.consoleLog("notice",params:serialize())
end

if XML_REQUEST['section'] == 'configuration' then
  freeswitch.consoleLog("notice",params:serialize())
end

