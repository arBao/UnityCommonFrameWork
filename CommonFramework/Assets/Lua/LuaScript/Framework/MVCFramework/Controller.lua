Controller = class()

function Controller:ctor()
	Debugger.LogError('Controller:ctor')
	self.sendMsgCallBack = nil
	self.removeMsgListeningCallBack = nil
	self.getViewCallback = nil
	self.getModelCallback = nil
end

--overload method
function Controller:MessagesListening()
	local messages = {}
	return messages
end

--overload method
function Controller:OnReciveMessage(msg,msgBody)
	
end

function Controller:SendMessage(msg,msgBody)
	self.sendMsgCallBack(msg,msgBody)
end

function Controller:GetView(viewName)
	return self.getViewCallback(viewName)
end

function Controller:GetModel(modelName)
	return self.getModelCallback(modelName)
end
