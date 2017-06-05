require 'Proto/person_pb'

local ControllerLogin = class(Controller)
function ControllerLogin:ctor()
	self.loginView = nil
	Debugger.LogError('ControllerLogin:ctor')
end

function ControllerLogin:MessagesListening()
	local messages = 
	{
		MessageNames.OpenUILogin,
	}
	return messages
end

function ControllerLogin:OnReciveMessage(msg,msgBody)
	if msg == MessageNames.OpenUILogin then
		Debugger.LogError('MessageNames.OpenUILogin ' .. msgBody)
		self:ShowUILogin()
	elseif msg == '111' then
		Debugger.LogError('111 ' .. msgBody)
	end
end

local function ReceiveMsg(id,data)
    Debugger.LogError("id " .. id)
    local person = person_pb.Person()
    local str = data:ToLuaBuffer()
    person:ParseFromString(str)
    Debugger.LogError("person.id kkk " .. person.id)
end

function ControllerLogin:ShowUILogin()
    if self.loginView == nil then
        self.loginView = self:GetView('ViewUILogin')
        self.loginView.OnClickButtonLoginCallback = function ( )
            self:SendMessage(MessageNames.OpenUIPopUp1,nil)
        end
        UDPServer.Instance:Init()
        UDPServer.Instance:ReceiveMsg(ReceiveMsg)
        if self.id == nil then
            self.id = 0
        end
        if self.seq == nil then
            self.seq = 0
        end

        self.loginView.OnClickButtonSendCallback = function ()
            self.id = self.id + 1
            self.seq = self.seq + 1
            local datasend = {}
            table.insert(datasend,1)
            table.insert(datasend,2)
            table.insert(datasend,3)
            table.insert(datasend,4)

            local person = person_pb.Person()
            person.id = 1000
            person.name = "tom"
            person.email = "tom@1.com"
            local data = person:SerializeToString()

            UDPServer.Instance:SendUDPMsg(data, self.id,self.seq)
        end
    end
    self.loginView:Show()

end

return ControllerLogin