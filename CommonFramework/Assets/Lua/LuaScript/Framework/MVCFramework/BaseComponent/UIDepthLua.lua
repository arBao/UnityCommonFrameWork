UIDepthLua = {
	name = 'UIDepthLua',
	MonoComponent = nil,
	isUI = true,
	sortinglayer = nil,
	sortingOrder = nil,
	gameObject = nil,
}

function UIDepthLua:New()
	local o = {}
	setmetatable(o,self)
	self.__index = self
	return o
end

function UIDepthLua:Awake(monobehaviour)
	Debugger.LogError('Awake = '..self.name..'  monobehaviour  '..monobehaviour.name);
	self.MonoComponent = monobehaviour
	self.gameObject = monobehaviour.gameObject
end

function UIDepthLua:SetLayerData(isUIParm,sortinglayerParm,sortingOrderParm)
	self.isUI = isUIParm
	self.sortinglayer = sortinglayerParm
	self.sortingOrder = sortingOrderParm
	if isUIParm then
		local canvas = self.gameObject:GetComponent('Canvas')
		if canvas == nil then
			canvas = self.gameObject:AddComponent(typeof(UnityEngine.Canvas))
		end
		canvas.overrideSorting = true; 
		canvas.sortingOrder = sortingOrderParm
		canvas.sortingLayerName = sortinglayerParm
	else
		local renders = self.gameObject:GetComponentsInChildren('Renderer')
		for i = 1,#renders do
			local render = renders[i]
			render.sortingOrder = sortingOrderParm
			render.sortingLayerName = sortinglayerParm
		end
	end

end

function UIDepthLua:SetLayerOrderNum(orderNum)
	self.sortingOrder = orderNum
	if self.isUI then
		local canvas = self.gameObject:GetComponent('Canvas')
		canvas.sortingOrder = orderNum
	else
		local renders = self.gameObject:GetComponentsInChildren('Renderer')
		for i = 1,#renders do
			local render = renders[i]
			render.sortingOrder = orderNum
		end
	end

end








