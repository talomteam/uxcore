local gethttp = {}
local http = require("socket.http")
local ltn12 = require("ltn12")

function gethttp.sendRequest(url,method,payload,ctype)
local path = url
  local payload = payload
  local response_body = { }

  local res, code, response_headers, status = http.request
  {
    url = path,
    method = method,
    headers =
    {
      ["Authorization"] = "",
      ["Content-Type"] = "application/"..ctype,
      ["Content-Length"] = payload:len()
    },
    source = ltn12.source.string(payload),
    sink = ltn12.sink.table(response_body)
  }
 -- luup.task('Response: = ' .. table.concat(response_body) .. ' code = ' .. code .. '   status = ' .. status,1,'Sample POST request with JSON data',-1)
    return response_body
end
