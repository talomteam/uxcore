function printable(tb,level)
    level = level or 1
    local spaces = string.rep('', level*2)
    for k, v in pairs(tb) do
        if type(v) ~= "table" then
            print(spaces ..  k .. '=' .. v)
        else
            print(spaces .. k )
            level = level + 1
            printable(v, level)
        end
    end
end