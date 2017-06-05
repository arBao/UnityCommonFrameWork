require 'SystemModule/Network/UdpNetwork'
require 'Proto/person_pb'
require 'Proto/UdpPackage_pb'

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

local function SendSucess()

end

local function ReceiveCallback(data)

end

function ControllerLogin:ShowUILogin()
    if self.loginView == nil then
        self.loginView = self:GetView('ViewUILogin')
        self.loginView.OnClickButtonLoginCallback = function ( )
            self:SendMessage(MessageNames.OpenUIPopUp1,nil)
        end

        if self.id == nil then
            self.id = 0
        end
        if self.seq == nil then
            self.seq = 0
        end

        UdpNetwork:Init(SendSucess,ReceiveCallback)

        self.loginView.OnClickButtonSendCallback = function ()
            self.id = self.id + 1
            self.seq = self.seq + 1
            local udppackage = UdpPackage_pb.UdpPackage()
            udppackage.seqid = 10;
            udppackage.posX = 100
            udppackage.posY = 200
            local data = udppackage:SerializeToString()

            UdpNetwork.Send(254,data)

        end
    end
    self.loginView:Show()

end

return ControllerLogin