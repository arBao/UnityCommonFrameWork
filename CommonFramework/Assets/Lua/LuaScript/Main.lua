require 'Framework/TestRequire'
require 'Modules/TestModule/LuaComponentTest'

--主入口函数。从这里开始lua逻辑
function Main()					
	 TestFunc()		
	 local gameobj = UnityEngine.GameObject.Find('UILogin')
	 LuaComponent.Add(gameobj,LuaComponentTest)
end

--场景切换通知
function OnLevelWasLoaded(level)
	collectgarbage("collect")
	Time.timeSinceLevelLoad = 0
end

function TestFunc()
	print('TestFunc 2222222222321321321313131321')
end

