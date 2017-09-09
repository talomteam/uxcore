if XML_REQUEST == nil then
    return
end
 freeswitch.consoleLog("notice", XML_REQUEST['section'])
if XML_REQUEST['section'] == 'directory' then
    if params:getHeader("action") == "sip_auth" then
        local directory = require("directory")
        directory.set(params)
        XMLSTRING = directory.getXML()
        --freeswitch.consoleLog("notice",params:serialize())
    end
end

if XML_REQUEST['section'] == 'dialplan' then
  freeswitch.consoleLog("notice",params:serialize())
end

if XML_REQUEST['section'] == 'configuration' then
  freeswitch.consoleLog("notice",params:serialize())
end

