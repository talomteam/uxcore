require('lib/printable')
xml = require('lib/luaxml-mod-xml')
handler = require('lib/luaxml-mod-handler')

sample = [[
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
  </document>
]]
treehandler = handler.simpleTreeHandler()
x = xml.xmlParser(treehandler)
x:parse(sample)

printable(treehandler.root)
-- treehandler.root["document"]["_attr"]["id"] = "xxx"
treehandler.root["document"]["section"]["domain"]["_attr"]={name="aa"}
treehandler.root["document"]["section"]["domain"]["groups"]["group"]["users"]["user"]["variables"][] ={variable={_attr={name="xx",data="YY"}}} 

--table.insert(treehandler.root["document"]["section"]["domain"],{_attr={ name="YYY",id="JJ"}})
print(treehandler.root["document"]["_attr"]["id"])
print(xml.serialize(treehandler.root))


