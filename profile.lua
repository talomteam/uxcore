require('lib/configure')
require('lib/tableprint')
local mongo = require 'mongo'
local client = mongo.Client 'mongodb://127.0.0.1'
local collection = client:getCollection('uniXcape-voice','sipinterface')

local strquery = [===[
[
    {
        "$match":
        {
            "$and":[{"type":{"$ne":"Endpoint"}},{"type":{"$ne":"Phone"}}] 
        }
    }
]

]===]

local query = mongo.BSON ('{}')


profile_patt = [[
  <profile name="{profile_name}">
    <gateways>

    </gateways>
    <settings>
      <param name="enable-timer" value="false"/>
      <param name="user-agent-string" value="unixcape"/>
      <param name="rtp-timer-name" value="soft"/>
      <param name="codec-prefs" value="$${global_codec_prefs}"/>
      <param name="inbound-codec-negotiation" value="generous"/>
      <param name="inbound-reg-force-matching-username" value="true"/>
      <param name="nonce-ttl" value="86400"/>
      <param name="rfc2833-pt" value="101"/>
      <param name="manage-presence" value="true"/>
      <param name="auth-calls" value="true"/>
      <param name="sip-ip" value="{ipaddr}"/>
      <param name="rtp-ip" value="{ipaddr}"/>
      <param name="sip-port" value="{port}"/>
      <param name="nat-options-ping" value="true"/>
      <param name="all-reg-options-ping" value="true"/>
      <param name="ext-sip-ip" value="auto-nat"/>
      <param name="ext-rtp-ip" value="auto-nat"/>
      <param name="context" value="context_2"/>
      <param name="force-register-domain" value="{ipaddr}"/>
      <param name="force-register-db-domain" value="{ipaddr}"/>
    </settings>
    <domains>
      <domain name="all" alias="true" parse="false"/>
    </domains>
  </profile>
]]
profile  = ""
for document in collection:find(query):iterator() do
    profile = profile .. profile_patt:gsub("{profile_name}",document.name):gsub("{ipaddr}",document.ip_address_to_bind_to):gsub("{port}",document.port_to_bind_to)
   
end

XML_STRING = profile
print(XML_STRING)