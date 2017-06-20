require 'SystemModule/Network/UDP/UdpNetwork'
require 'SystemModule/Network/UDP/LinkUDPPackets'
require 'Proto/person_pb'
require 'Proto/UdpPackage_pb'
require 'SystemModule/Network/TCP/TCPNetwork'
require 'SystemModule/Network/KCP/KCPNetwork'


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

        --local SendSucess = function(pack)
        --
        --end
        --
        --local ReceiveCallback = function(pack)
        --    --Debugger.LogError('ReceiveCallback')
        --    local udppackage = UdpPackage_pb.UdpPackage()
        --    udppackage:ParseFromString(pack.data)
        --
        --    Debugger.LogError('udppackage.posX  ' .. udppackage.posX)
        --    Debugger.LogError('udppackage.posY  ' .. udppackage.posY)
        --end
        --UdpNetwork:GetInstance():Init()
        --UdpNetwork:GetInstance():ListenTo(1000,ReceiveCallback)

        --local kcpNetwork = KCPNetwork.New()
        --kcpNetwork:Init(1,'127.0.0.1',11110,11111)
        --
        --kcpNetwork:SetReceiveAction(function(buffer)
        --    --local udppackage = UdpPackage_pb.UdpPackage()
        --    local luabuffer = buffer:ToLuaBuffer()
        --    Debugger.LogError('Receive string.len(luabuffer)  ' .. string.len(luabuffer))
        --    --udppackage:ParseFromString(luabuffer)
        --
        --    --Debugger.LogError('Receive  udppackage.posX  ' .. udppackage.posX)
        --    --Debugger.LogError('Receive  udppackage.posY  ' .. udppackage.posY)
        --end)


        KCPNetwork:GetInstance():Init(1,'192.168.0.149',8008,8007,
        function(buffer)
            local udppackage = UdpPackage_pb.UdpPackage()
            Debugger.LogError('Receive string.len(luabuffer)  ' .. string.len(buffer))
            udppackage:ParseFromString(buffer)

            Debugger.LogError('Receive  udppackage.posX  ' .. udppackage.posX)
            Debugger.LogError('Receive  udppackage.posY  ' .. udppackage.posY)
        end)

        UpdateBeat:Add(function (self)
            --kcpNetwork:Update()
            KCPNetwork:GetInstance():Update()
        end,self)

        self.loginView.OnClickButtonSendCallback = function ()
            self.id = self.id + 1
            self.seq = self.seq + 1
            local udppackage = UdpPackage_pb.UdpPackage()
            udppackage.posX = 100 + self.id
            udppackage.posY = 200 + self.id
            local data = udppackage:SerializeToString()
            local length = string.len(data)
            Debugger.LogError('origin data length  ' .. length)
            KCPNetwork:GetInstance():Send(1,1,data)
        end

        self.loginView.OnClickButtonLinkTestCallback = function ()

        end

        self.loginView.OnClickButtonBattleCallback = function ()
            local funcProgress = function (operation)
                Debugger.LogError(operation.progress)
            end
            local finishCallback = function ()
                self:SendMessage(MessageNames.OpenUIBattle,nil)
            end
            SceneMgr.LoadASync('Battle',funcProgress,finishCallback,false)
        end

        TCPNetwork:GetInstance():Init()
        self.loginView.OnClickButtonTcpConnectCallback = function ()
            TCPNetwork:GetInstance():Connect('192.168.0.149',8008,
            function ()
                Debugger.LogError('Success connect')
            end,
            function(err)
                Debugger.LogError('fail ' .. err)
            end)

            --TimerManager:GetInstance():CallActionDelay(function(parm)
            --    Debugger.LogError('calldelay  ' .. parm)
            --end,3,'11',0)
        end

        self.loginView.OnClickButtonTcpSendCallback = function ()
            local udppackage = UdpPackage_pb.UdpPackage()
            udppackage.posX = 100 + self.id
            udppackage.posY = 200 + self.id
            local data = udppackage:SerializeToString()

            TCPNetwork:GetInstance():Send(1,data,
            function(data)
                Debugger.LogError('Success send call back ' .. data)
                --local luabuffer = data:ToLuaBuffer()
                udppackage:ParseFromString(data)
                Debugger.LogError('udppackage.posX  ' .. udppackage.posX)
                Debugger.LogError('udppackage.posY  ' .. udppackage.posY)
            end,
            function(err)
                Debugger.LogError('fail send ' .. err)
            end)
        end

    end
    self.loginView:Show()

end

return ControllerLogin