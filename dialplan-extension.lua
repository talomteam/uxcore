require('lib/configure')
local mongo = require 'mongo'
local client = mongo.Client 'mongodb://127.0.0.1'
local collection = client:getCollection('uniXcape-voice','device')


local strquery = [===[
[
   {
        "$match":
        {
            "user":{ "$exists":"true"}
        }
    },
    {
        "$lookup":
        {
            "localField":"user",
            "from":"user",
            "foreignField":"_id",
            "as":"userInfo"
        } 
    }
]

]===]

dialplan_patt = [[
    <extension name="{name}" continue="true">
      <condition field="destination_number" expression="^{number}$">
        {action}
      </condition>
    </extension>
]]
action_patt = [[ <action application="{application}" data="{data}"/>
]]
local query = mongo.BSON (strquery) 
local document = collection:aggregate(query)

dialplan_extension = ""
for document in collection:aggregate(query):iterator() do
    action = ""
    dialplan_extension = dialplan_extension .. dialplan_patt:gsub("{name}",document.device_name):gsub("{number}",document.userInfo[1].extension_number)
    action = action .. action_patt:gsub("{application}","bridge"):gsub("{data}","user/".. document.sip_username .. "@" .. IPADDR)
    dialplan_extension = dialplan_extension:gsub("{action}",action)
end

XML_STRING = dialplan_extension
print(XML_STRING)
