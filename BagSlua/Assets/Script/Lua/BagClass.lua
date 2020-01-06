------------暂时没使用
-- 背包类
-- 用来管理背包各个部件，通过物品Id来改变物品属性
-- 属性
-- 方法
-- 1 增加 随机增加则需要绑定物品的父节点以及设置坐标 一般增加则是从对象池中取得id，通过id找到物品对象
-- 2 删除 将id放入对象池中，并更新显示表(删除对应的id)
-- 3 整理 从显示表一一拿出id，然后找到物体，设置物体位置
require("baseclass")
require("BagItem")
BagClass = BagClass or BaseClass()
local bagItem = BagItem.New()
function BagClass:__init()
    self.obRoot = GameObject.Find("BagUI/BagPanel/BagBackground")
    --显示表
    self.showTables = {}
    --删除表
    self.deletedTables = {}
	--唯一Id
	self.itemId = 1
	--格子位置
    self.itemPos = 1
    self.itemsTransform = self.obRoot.transform:Find("ItemBackground/Items")
	self.targetTransform = self.itemsTransform.transform:Find("item")
    local widthCase = self.itemsTransform.transform:Find("Itembackground").rect.width
    local heightCase = self.itemsTransform.transform:Find("Itembackground").rect.height
    self.widthItem = self.targetTransform.rect.width
    self.heightItem = self.targetTransform.rect.height
    self.xItem = self.targetTransform.anchoredPosition.x
	self.yItem = self.targetTransform.anchoredPosition.y
	self.widthSize = math.floor(widthCase / self.widthItem)
	self.heightSize = math.floor(heightCase / self.heightItem)
	self.describeList = {}
	table.insert(self.describeList,self.obRoot.transform:Find("DescribeBackground/Items/item/itemImage").gameObject)
	table.insert(self.describeList,self.obRoot.transform:Find("DescribeBackground/Items/item/itemText").gameObject)
	table.insert(self.describeList,self.obRoot.transform:Find("DescribeBackground/Items/Describe/DescribeText").gameObject)
	--将描述列表传递
	bagItem:SetDescribeList(self.describeList)
    local addBtnOb = self.obRoot.transform:Find("Add")
	local addBtn = addBtnOb:GetComponent("Button")
	addBtn.onClick:AddListener(function() self:AddClick() end)
    local deleBtnOb = self.obRoot.transform:Find("Delete")
	local deleBtn = deleBtnOb:GetComponent("Button")
	deleBtn.onClick:AddListener(function() self:DeleClick() end)
    local sortBtnOb = self.obRoot.transform:Find("Sort")
    local sortBtn = sortBtnOb:GetComponent("Button")
    sortBtn.onClick:AddListener(function() self:SortClick() end)
end

function BagClass:AddClick()
	-- 如果对象池有元素则从对象池中取已有Id，如果没有，则取新建的Id
	local temp = self.deletedTables[1] or self.itemId
	bagItem:CreateItem(self:Getxy(),temp,self.targetTransform,next(self.deletedTables)==nil)
	bagItem.itemTables[temp].ob:GetComponent(RectTransform).anchoredPosition = bagItem.itemTables[temp].xy
	table.insert(self.showTables,temp)
	self:SetItemPos(bagItem.itemTables[temp].xy)
	if temp == self.itemId then  
		self.itemId = self.itemId + 1
	else  
		table.remove(self.deletedTables,1)
	end
end

function BagClass:Getxy()
	local x = self.xItem + (self.itemPos-1) % self.widthSize * self.widthItem
	local y = self.yItem - math.floor((self.itemPos-1) / self.widthSize) % self.heightSize * self.heightItem
	return {x,y}
end

function BagClass:DeleClick()
	if bagItem:IsAbleDelete() then  
		bagItem:DeleteItem()
		table.insert(self.deletedTables,bagItem.currentPos)
		bagItem:NoDescribeItem()
		self:UpdateShowTables()
	end
end

function BagClass:SortClick()
	self.itemPos = 1
	for _, value in pairs(self.showTables) do
		local itemTable = bagItem.itemTables[value]
		itemTable.xy = self:Getxy()
		itemTable.ob:GetComponent(RectTransform).anchoredPosition = itemTable.xy
		self:SetItemPos(itemTable.xy)
	end
end

function BagClass:UpdateShowTables()
	local temp = 0
	local len = 0
	for key, value in pairs(self.showTables) do
		if  not bagItem.itemTables[value].ob.gameObject.activeSelf  then
			temp = key
			break
		end
	end
	table.remove(self.showTables,temp)
	len = #self.showTables
	self:SetItemPos(bagItem.itemTables[self.showTables[len]].xy)
end

function BagClass:SetItemPos(xy)
	--itemPos从1开始，第一个格子为偏移量 0 + 1
	--itemPos保留的下一个位置 + 1
	self.itemPos = math.floor((xy[1] - self.xItem) / self.widthItem) + math.floor((-xy[2] + self.yItem) / self.heightItem) * self.widthSize + 1 + 1
end

function BagClass:table_maxn(t)
	local mn = nil;
	local mk = nil
	for k, v in pairs(t) do
	  if(mn == nil) then
		mn = v
		mk = k
	  end
	  if mn < v then
		mn = v
		mk = k
	  end
	end
	return mk,mn
  end