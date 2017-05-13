ClassFather = class()
function ClassFather:ctor(val)
    print('ClassFather ctor')
    self.count = val
end

function ClassFather:show()
    print('ClassFather show')
end

ClassSon1 = class(ClassFather)
function ClassSon1:ctor(val)
    self.count = val
end

function ClassSon1:show()
    self:super('show')
    print('ClassSon1 show')
end

function ClassSon1:bake()
    print('ClassSon1 bake')
end

local o = ClassSon1.new(5)
print(o.count)
o:show()

--以上是封装继承多态


InterfaceShow = class()
