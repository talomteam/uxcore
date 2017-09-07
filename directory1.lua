require("lib/configure")
require("lib/tableprint")
require("lib/printable")
 xml = require("LuaXML")
local mongo = require 'mongo'
local client = mongo.Client 'mongodb://127.0.0.1'
local collection = client:getCollection('uniXcape-voice','device')


local strquery = [===[
[
    {
        "$match":
        {
            "$and":[{"type":{"$ne":"Endpoint"}},{"type":{"$ne":"Phone"}}] 
        }
    },
    {
        "$lookup":
        {
            "localField":"restriction",
            "from":"restriction",
            "foreignField":"_id",
            "as":"restrictionInfo"
        } 
    }
]

]===]

local query = mongo.BSON (strquery) 
local document = collection:aggregate(query)
local value = document:value()

if value == nil then
    print("not exits data")
    local result = [[
        <?xml version="1.0" encoding="UTF-8" standalone="no"?>
        <document type="freeswitch/xml">
            <section name="result">
                <result status="not found" />
            </section>
        </document> ]]
    XML_STRING = result
    return
end
  
local p_username = value.sip_username
local p_password = value.sip_password
local v_inbound_call_name = value.inbound_call_name
local v_inbound_call_number = value.inbound_call_number
local v_outbound_call_name = value.outbound_call_name
local v_outbound_call_number = value.outbound_call_number



directory=[[
  <document type="freeswitch/xml">
    <section name="directory">
      <domain>
        <params>
          <param name="dial-string" value="{presence_id=${dialed_user}@${dialed_domain}}${sofia_contact(${dialed_user}@${dialed_domain})}"/>
        </params>
        <groups>
          <group>
            <users>
              <user>
                <params>
                  </params>
                  <variables>
                  </variables>
              </user>
            </users>
          </group>
        </groups>
      </domain>
    </section>
  </document>]]


x = xml.eval(directory)
--print(to_string(x))
-- print(to_string(x))
-- printable(x)
print(x[1][1])






    
