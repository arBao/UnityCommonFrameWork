Controller = class()

function Controller:ctor()
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
	self.getViewCallback(viewName)
end

function Controller:GetModel(modelName)
	self.getModelCallback(modelName)
end
