require('lib/configure')
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
local v_restrition = value.restrictionInfo[1].restriction_name

print (v_restrition)

directory=[[
<?xml version="1.0" encoding="UTF-8"?>
  <document type="freeswitch/xml">
    <section name="directory">
      <domain name="{domain_name}">
        <params>
          <param name="dial-string" value="{presence_id=${dialed_user}@${dialed_domain}}${sofia_contact(${dialed_user}@${dialed_domain})}"/>
        </params>
        <groups>
          <group>
            <users>
              <user id="{username}">
                <params>
                    {param}
                  </params>
                  <variables>
                    {variable}
                  </variables>
              </user>
            </users>
          </group>
        </groups>
      </domain>
    </section>
  </document>]]

data = directory:gsub("{domain_name}",IPADDR)
data = data:gsub("{username}",p_username)

variable_patt = [[<variable name="{v_name}" value="{v_value}"/>
]]
variable = variable_patt:gsub("{v_name}","inbound_call_name"):gsub("{v_value}",v_inbound_call_name)
variable = variable .. variable_patt:gsub("{v_name}","inbound_call_number"):gsub("{v_value}",v_inbound_call_number)
variable = variable .. variable_patt:gsub("{v_name}","outbound_call_number"):gsub("{v_value}",v_outbound_call_number)
variable = variable .. variable_patt:gsub("{v_name}","inbound_call_name"):gsub("{v_value}",v_inbound_call_name)
variable = variable .. variable_patt:gsub("{v_name}","restriction"):gsub("{v_value}",v_restrition)
variable = variable .. variable_patt:gsub("{v_name}","user_context"):gsub("{v_value}","outbound")

data = data:gsub("{variable}",variable)
param_patt = [[<param name="{p_name}" value="{p_value}"/>
]]
param = param_patt:gsub("{p_name}","password"):gsub("{p_value}",p_password)
data = data:gsub("{param}",param)

XML_STRING = data
print(XML_STRING)





    
