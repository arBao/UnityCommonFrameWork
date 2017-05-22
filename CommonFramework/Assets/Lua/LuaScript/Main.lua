require 'Framework/TestRequire'
require 'Tools/Class'
require 'Modules/TestModule/LuaComponentTest'
require 'Framework/MVCFramework/MessageCenter'
require 'Framework/MVCFramework/MVCFrameWork'
require 'Tools/Functions'
require 'Const/CSVPaths'
require 'Const/MessageNames'
require 'Tools/CSVParser'
require 'Tools/PrintTable'


--主入口函数。从这里开始lua逻辑
function Main()	
	MessageCenter.AddListener('MsgTest',MsgTest)
	MessageCenter.AddListener('MsgTest',MsgTest1)
	MessageCenter.AddListener('MsgTest',MsgTest2)
	MessageCenter.AddListener('MsgTest',MsgTest2)
	MessageCenter.RemoveListener('MsgTest',MsgTest)	
	MessageCenter.RemoveListener('MsgTest',MsgTest1)
	MessageCenter.RemoveListener('MsgTest',MsgTest2)
	TestFunc()		
	--local gameobj = UnityEngine.GameObject.Find('UILogin')
	--LuaComponent.Add(gameobj,LuaComponentTest)
	MVCFrameWork.Init()

	MessageCenter.SendMessage('ControllerMsgTest',122)
	MessageCenter.SendMessage(MessageNames.OpenUILogin,'')
	--local obj = AssetsManager.Instance:GetAsset('Assets/Res/UIPrefab/UILogin.prefab',typeof(UnityEngine.GameObject))
	--local uidata = CSVParser.LoadCsv(CSVPaths.UIConfig,'UILogin')
	--Debugger.LogError('uidata.path  ' .. uidata.path)
end

function MsgTest(msg,msgBody)
	print('MsgTest  msgBody ' .. msgBody)
end

function MsgTest1(msg,msgBody)
	print('MsgTest1  msgBody ' .. msgBody)
end

function MsgTest2(msg,msgBody)
	print('MsgTest2  msgBody ' .. msgBody)
end

--场景切换通知
function OnLevelWasLoaded(level)
	collectgarbage("collect")
	Time.timeSinceLevelLoad = 0
end

function TestFunc()
	print('TestFunc 2222222222321321321313131321')
	require 'Modules/TestClass/ClassTest'
	MessageCenter.SendMessage('MsgTest',1)
end

