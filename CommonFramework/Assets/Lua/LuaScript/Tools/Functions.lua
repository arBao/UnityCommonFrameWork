
--输出日志--
function log(str)
    Debugger.Log(str);
end

--错误日志--
function logError(str) 
	Debugger.LogError(str);
end

--警告日志--
function logWarn(str) 
	Debugger.LogWarning(str);
end

--查找对象--
function find(str)
	return GameObject.Find(str);
end

function destroy(obj)
	GameObject.Destroy(obj);
end

function newObject(prefab)
	return GameObject.Instantiate(prefab);
end

--创建面板--
function createPanel(name)
	panelMgr:CreatePanel(name);
end

function child(str)
	return transform:FindChild(str);
end

function subGet(childNode, typeName)		
	return child(childNode):GetComponent(typeName);
end

function findPanel(str) 
	local obj = find(str);
	if obj == nil then
		error(str.." is null");
		return nil;
	end
	return obj:GetComponent("BaseLua");
end

function loadPrefabObject(path)
	-- body
	return assetMgr:LoadRes(path, typeof(GameObject));
end

function addPrefabToTarget(target, child)
	-- body
	return UIUtility.AddPrefabToTarget(target, child);
end

function notifyActive( viewid )
	-- body
	local onActive = GameFramework.UIBaseView.OnActiveEventStream;
	LuaReflectionTool.Instance:CallObjectMethodOverLoad(onActive,'FRP.EventStream`1[ViewID]','Fire',0,{viewid},{'ViewID'});
end

function notifyDeactive( viewid )
	-- body
	local onDeactive = GameFramework.UIBaseView.OnDeActiveEventStream;
	LuaReflectionTool.Instance:CallObjectMethodOverLoad(onDeactive,'FRP.EventStream`1[ViewID]','Fire',0,{viewid},{'ViewID'});
end

function notifyShow( viewid )
	-- body
	local onShow = GameFramework.UIBaseView.OnShowEventStream;
	LuaReflectionTool.Instance:CallObjectMethodOverLoad(onShow,'FRP.EventStream`1[ViewID]','Fire',0,{viewid},{'ViewID'});
end

function notifyHide( viewid )
	-- body
	local onHide = GameFramework.UIBaseView.OnHideEventStream;
	LuaReflectionTool.Instance:CallObjectMethodOverLoad(onHide,'FRP.EventStream`1[ViewID]','Fire',0,{viewid},{'ViewID'});
end

--输出日志--
function logColor(...)
	str = ""
	for k, v in pairs{...} do
		if type(v) == "string" then
			str = str .. v .. ", "
		else
			str = str .. tostring(v) .. ", "
		end
	end
    Debugger.LogError("<color=yellow>" .. str .. "</color>");
end

function string.split(str, delimiter)
	if str==nil or str=='' or delimiter==nil then
		return nil
	end
	
    local result = {}
    for match in (str..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match)
    end
    return result
end

function file_exists(path)
  local file = io.open(path, "rb")
  if file then file:close() end
  return file ~= nil
end

function length_of_file(filename)
  local fh = assert(io.open(filename, "rb"))
  local len = assert(fh:seek("end"))
  fh:close()
  return len
end