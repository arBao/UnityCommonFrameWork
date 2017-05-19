Model = class()

function Model:ctor()
	self.sendMsgCallBack = nil
end

function Model:SendMessage(msg,msgBody)
	self.sendMsgCallBack(msg,msgBody)
end