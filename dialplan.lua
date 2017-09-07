local mongo = require 'mongo'
local client = mongo.Client 'mongodb://127.0.0.1'
local collection = client:getCollection('uniXcape-voice','numbers')


local strquery = [===[
[
   {
        "$match":
        {
            "feature_code":{ "$exists":"true"}
        }
    },
    {
        "$lookup":
        {
            "localField":"feature_code",
            "from":"featurecode",
            "foreignField":"_id",
            "as":"featurecodeInfo"
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
local query = mongo.BSON (strquery) 
local document = collection:aggregate(query)

dialplan_featurecode = ""
for document in collection:aggregate(query):iterator() do
    dialplan_featurecode = dialplan_featurecode .. dialplan_patt:gsub("{name}",document.featurecodeInfo[1].feature_name):gsub("{number}",document.number)
   
end

XML_STRING = dialplan_featurecode
print(XML_STRING)