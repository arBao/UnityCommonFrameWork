ModelManager = class()
local dicModels = {}
function ModelManager.RegisterModels(models)
	for modelName,modelClass in pairs(models) do
		Debugger.LogError("modelName " .. modelName)
		Debugger.LogError(modelClass)
		local model = modelClass.new()
		local function SendMsg(msg,msgBody)
			MessageCenter.SendMsg(msg,msgBody)
		end
		model.sendMsgCallBack = SendMsg
		dicModels[modelName] = model
	end
end

function ModelManager.GetModel(modelName)
	return dicModels[modelName]
end