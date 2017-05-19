ControllerManager = class()
local dicControllers = {}
function ControllerManager.RegisterControllers(controllers)
	for controllerName,controllerClass in pairs(controllers) do
		Debugger.LogError("controllerName " .. controllerName)
		Debugger.LogError(controllerClass)
		local controller = controllerClass.new()
		local msgListening = controller:MessagesListening()
		for i = 1,#msgListening do
			local function MsgRegister(msg,msgBody)
				controller:OnReciveMessage(msg,msgBody)
			end
			-- print('MsgRegister ' .. msgListening[i])
			-- print(MsgRegister)
			MessageCenter.AddListener(msgListening[i],MsgRegister)

			local function SendMsg(msg,msgBody)
				MessageCenter.SendMsg(msg,msgBody)
			end
			controller.sendMsgCallBack = SendMsg
		end
		dicControllers[controllerName] = controller

	end
end