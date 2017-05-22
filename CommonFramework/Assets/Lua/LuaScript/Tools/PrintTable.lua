PrintTable = {};  
PrintTable.print = function(data)  
 
    local cstring = "";  
    PrintTable.tableprint(data,cstring);  
end  
  
PrintTable.tableprint = function(data,cstring)  
    Debugger.LogError("#############PrintTable###########"); 
    if data == nil then   
        Debugger.LogError("core.print data is nil");  
    end  
    local cs = cstring .. " ";  
    Debugger.LogError(cstring .."{");  
    if(type(data)=="table") then  
        for k, v in pairs(data) do  
            Debugger.LogError(cs..tostring(k).." = "..tostring(v));  
            if(type(v)=="table") then  
                PrintTable.tableprint(v,cs);  
            end  
        end  
    else  
        Debugger.LogError(cs..tostring(data));  
    end  
    Debugger.LogError(cstring .."}");  
end  


PrintTable.ToString = function (_t)  
    local szRet = "{"  
    function doT2S(_i, _v)  
        if "number" == type(_i) then  
            szRet = szRet .. "[" .. _i .. "] = "  
            if "number" == type(_v) then  
                szRet = szRet .. _v .. ","  
            elseif "string" == type(_v) then  
                szRet = szRet .. '"' .. _v .. '"' .. ","  
            elseif "table" == type(_v) then  
                szRet = szRet .. PrintTable.ToString(_v) .. ","  
            else  
                szRet = szRet .. "nil,"  
            end  
        elseif "string" == type(_i) then  
            szRet = szRet .. '["' .. _i .. '"] = '  
            if "number" == type(_v) then  
                szRet = szRet .. _v .. ","  
            elseif "string" == type(_v) then  
                szRet = szRet .. '"' .. _v .. '"' .. ","  
            elseif "table" == type(_v) then  
                szRet = szRet .. PrintTable.ToString(_v) .. ","  
            else  
                szRet = szRet .. "nil,"  
            end  
        end  
    end  
    table.foreach(_t, doT2S)  
    szRet = szRet .. "}"  
    return szRet  
end  