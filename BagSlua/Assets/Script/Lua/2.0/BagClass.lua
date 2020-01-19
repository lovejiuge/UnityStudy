require("baseclass")
require("BagData")
require("ItemClass")
BagClass = BagClass or BaseClass()
function BagClass:__init()
	BagData.New()
	BagData.Instance:LoadSprite()
	self:GameObjectInit()
	self:SetVarInit()
	self:AddListenerInit()
	self:SetActiveInit()
end

--初始化方法
--start-------------------------------
function BagClass:GameObjectInit()
	local menuUIOb = GameObject.Find("GameUI/MenuUI")
	self.bagBtnTrans = menuUIOb.transform:Find("BagBtn")
	self.bagUITrans = menuUIOb.transform:Find("BagUI")
--MenuUI
	local moneyUITrans = menuUIOb.transform:Find("MoneyUI")
	self.goldCountText = moneyUITrans:Find("Gold/Count"):GetComponent(Text)
	self.goldAddBtn = moneyUITrans:Find("Gold/Add"):GetComponent(Button)
	self.jewelryCountText = moneyUITrans:Find("Jewelry/Count"):GetComponent(Text)
	self.jewelryAddBtn = moneyUITrans:Find("Jewelry/Add"):GetComponent(Button)
	self.crystalCountText = moneyUITrans:Find("Crystal/Count"):GetComponent(Text)
	self.crystalAddBtn = moneyUITrans:Find("Crystal/Add"):GetComponent(Button)
--物品类型
	local typeTrans = self.bagUITrans:Find("Type")
	self.allTypeImg = typeTrans:Find("AllType"):GetComponent(Image)
	self.propTypeImg = typeTrans:Find("PropType"):GetComponent(Image)
	self.giftTypeImg = typeTrans:Find("GiftType"):GetComponent(Image)
	self.expercardTypeImg = typeTrans:Find("ExperCardType"):GetComponent(Image)
	self.performTypeImg = typeTrans:Find("PerformType"):GetComponent(Image)
	self.inscriptionTypeImg = typeTrans:Find("InscriptionType"):GetComponent(Image)
	self.newTypeImg = typeTrans:Find("NewType"):GetComponent(Image)	
--描述框
	self.itemBackgroundTrans = self.bagUITrans:Find("Content/Background")
	self.itemTrans = self.itemBackgroundTrans:Find("Item")
	local describe = self.bagUITrans:Find("Describe")
	self.describeItemTrans = describe:Find("Item")
	self.describeIconImg = self.describeItemTrans:Find("Icon"):GetComponent(Image)
	self.describeNameText = self.describeItemTrans:Find("Name"):GetComponent(Text)
	self.describeCount = self.describeItemTrans:Find("Count"):GetComponent(Text)
	self.describeContentText = describe:Find("ContentDescribe/DescribeText"):GetComponent(Text)
	self.describePriceTipText = describe:Find("TipText"):GetComponent(Text)
--新建物品
	self.createTrans = typeTrans:Find("Create")
	self.cretew = menuUIOb.transform:Find("CreateWindow")
	local tip = self.cretew:Find("Tip")
	self.confirm = tip:Find("Confirm")
	self.cancel = tip:Find("Cancel")
	self.tipIconInputField = tip:Find("Icon/InputField"):GetComponent(InputField)
	self.tipNameInputField = tip:Find("Name/InputField"):GetComponent(InputField)
	self.tipCountInputField = tip:Find("Count/InputField"):GetComponent(InputField)
	self.tipTypeInputField = tip:Find("Type/InputField"):GetComponent(InputField)
	self.tipPriceInputField = tip:Find("Price/InputField"):GetComponent(InputField)
	self.tipDescribeInputField = tip:Find("Describe/InputField"):GetComponent(InputField)
--使用物品
	self.use = describe:Find("Use")
--售卖物品
	self.sell = describe:Find("Sell")
end

function BagClass:AddListenerInit()
	self.bagBtnTrans:GetComponent(Button).onClick:AddListener(
		function()
			self.bagBtnTrans.gameObject:SetActive(false)
			self.bagUITrans.gameObject:SetActive(true)
		end
	)

	self.bagUITrans:Find("ExitBag"):GetComponent(Button).onClick:AddListener(
		function()
			self.bagBtnTrans.gameObject:SetActive(true)
			self.bagUITrans.gameObject:SetActive(false)
		end
	)
	self.allTypeImg:GetComponent(Button).onClick:AddListener(
		function()
			self:onClickType(self.allTypeImg)
		end
	)
	self.propTypeImg:GetComponent(Button).onClick:AddListener(
		function()
			self:onClickType(self.propTypeImg)
		end
	)
	self.giftTypeImg:GetComponent(Button).onClick:AddListener(
		function()
			self:onClickType(self.giftTypeImg)
		end
	)
	self.expercardTypeImg:GetComponent(Button).onClick:AddListener(
		function()
			self:onClickType(self.expercardTypeImg)
		end
	)
	self.performTypeImg:GetComponent(Button).onClick:AddListener(
		function()
			self:onClickType(self.performTypeImg)
		end
	)
	self.inscriptionTypeImg:GetComponent(Button).onClick:AddListener(
		function()
			self:onClickType(self.inscriptionTypeImg)
		end
	)
	self.newTypeImg:GetComponent(Button).onClick:AddListener(
		function()
			self:onClickType(self.newTypeImg)
		end
	)

	self.createTrans:GetComponent(Button).onClick:AddListener(
		function()
			self:onClickCreateW()
		end
	)
	self.use:GetComponent(Button).onClick:AddListener(
		function()
			self:onClickUse()
		end
	)
	self.sell:GetComponent(Button).onClick:AddListener(
		function()
			self:onClickSell()
		end
	)
	self.confirm:GetComponent(Button).onClick:AddListener(
		function()
			self:onClickConfirmCW()
		end
	)
	self.cancel:GetComponent(Button).onClick:AddListener(
		function()
			self:onClickCancelCW()
		end
	)
end

function BagClass:SetActiveInit()
	self.cretew.gameObject:SetActive(false)
	self.bagUITrans.gameObject:SetActive(true)
	self.itemTrans:Find("HL").gameObject:SetActive(false)
	self.TypeList[self.currentType].sprite = BagData.Instance:GetSprite(6)
	self:HideDescribeItem()
	self:ClearCreateWindow()
end
function BagClass:SetVarInit()
	self.itemId = 1
	self.itemPos = 1
	self.currentId = 1
	self.currentType = "AllType"
	local widthCase = self.itemBackgroundTrans.rect.width
	local heightCase = self.itemBackgroundTrans.rect.height
	self.widthItem = self.itemTrans.rect.width
	self.heightItem = self.itemTrans.rect.height
	self.xItem = self.itemTrans.anchoredPosition.x
	self.yItem = self.itemTrans.anchoredPosition.y
	self.widthSize = math.floor(widthCase / self.widthItem)
	self.heightSize = math.floor(heightCase / self.heightItem)

	self.TypeList ={}
	self.TypeList[self.allTypeImg.name] = self.allTypeImg
	self.TypeList[self.propTypeImg.name] = self.propTypeImg
	self.TypeList[self.giftTypeImg.name] = self.giftTypeImg
	self.TypeList[self.expercardTypeImg.name] = self.expercardTypeImg
	self.TypeList[self.performTypeImg.name] = self.performTypeImg
	self.TypeList[self.inscriptionTypeImg.name] = self.inscriptionTypeImg
	self.TypeList[self.newTypeImg.name] = self.newTypeImg
end
---end-------------------------------

--核心方法
---start----------------------------------
function BagClass:onClickCreateW()
	self:ClearCreateWindow()
	self.cretew.gameObject:SetActive(true)
end
function BagClass:onClickConfirmCW()
	local deletelist = BagData.Instance.deleteList["AllType"]
	local tempId = deletelist[1] or self.itemId
	local tempItem = BagData.Instance.itemList[tempId] or ItemClass.New(GameObject.Instantiate(self.itemTrans), self.itemId)
	self:SetCreateList()
	tempItem:SetData(BagData.Instance.createDataList)
	if tempId == self.itemId then
		tempItem.ob.transform:SetParent(self.itemTrans.parent)
		tempItem.ob:GetComponent("Button").onClick:AddListener(
			function()
				self:OnClickHightLightOff()
				self.currentId = tempItem:OnClickHightLightOn()
				self:ShowDescribeItem(tempItem)
			end
		)
		self.itemId = self.itemId + 1
	else
		if tempItem.type ~= "AllType" then
			table.remove(BagData.Instance.deleteList[tempItem.type], 1)
		end
		table.remove(BagData.Instance.deleteList["AllType"], 1)
	end
	--在itemList表中我们以物品唯一id作为下标，通过id唯一确定物品
	BagData.Instance.itemList[tempId] = tempItem
	tempItem.ob.anchoredPosition = self:Getxy(tempItem.pos)
	if tempItem.type ~= "AllType" then
		table.insert(BagData.Instance.showList[tempItem.type], tempId)
	end
	table.insert(BagData.Instance.showList["AllType"], tempId)
	--当在格子里插入一个物品时候，此时应该将itempos指向下一个位置
	self.itemPos = tempItem.pos + 1
	self:ClearCreateWindow()
	self.cretew.gameObject:SetActive(false)
end
function BagClass:onClickCancelCW()
	self:ClearCreateWindow()
	self.cretew.gameObject:SetActive(false)
end
function BagClass:onClickSell()
	local tempItem = BagData.Instance.itemList[self.currentId]
	--是否可售卖待完成
	if tempItem.HLTransform.gameObject.activeSelf then
		tempItem.ob.gameObject:SetActive(false)
		tempItem.HLTransform.gameObject:SetActive(false)
		--售卖价格待补充
		if tempItem.type ~= "AllType" then
			table.insert(BagData.Instance.deleteList[tempItem.type], self.currentId)
		end
		table.insert(BagData.Instance.deleteList["AllType"], self.currentId)
	end
	self:ChangeShowList()
	self:HideDescribeItem()
	self:SortClick()
end
function BagClass:SortClick()
	self.itemPos = 1
	local showList = BagData.Instance.showList[self.currentType]
	for _, value in pairs(showList) do
		local tempItem = BagData.Instance.itemList[value]
		tempItem.ob.anchoredPosition = self:Getxy(self.itemPos)
		tempItem.ob.gameObject:SetActive(true)
		BagData.Instance.itemList[value].pos = self.itemPos
		self.itemPos = self.itemPos + 1
	end
end
function BagClass:onClickUse()
	print("use")
end
---end------------------------------------

--其他方法
--分类-----------------------------------

function BagClass:onClickType(ImgObject)
	self:UpdateOldType()
	self.TypeList[ImgObject.name].sprite = BagData.Instance:GetSprite(6)
	self.currentType = ImgObject.name
	self:SortClick()
end

--
--
---数据计算--------------------------------------------
function BagClass:SetCreateList()
	local createList = {}
	createList.pos = self.itemPos
	createList.icon = tonumber(self.tipIconInputField.text)
	createList.name = self.tipNameInputField.text
	createList.count = self.tipCountInputField.text
	createList.type = self.tipTypeInputField.text
	createList.price = self.tipPriceInputField.text
	createList.describe = self.tipDescribeInputField.text
	BagData.Instance:SetCreateDataList(createList)
end
function BagClass:Getxy(pos)
	local x = self.xItem + (pos - 1) % self.widthSize * self.widthItem
	local y = self.yItem - math.floor((pos - 1) / self.widthSize) % self.heightSize * self.heightItem
	return {x, y}
end
function BagClass:ChangeShowList()
	local temp = 0
	local len = 0
	local showList = nil
	if self.currentType ~= "AllType" then
		showList = BagData.Instance.showList[self.currentType]
		for key, value in pairs(showList) do
			if self.currentId == value then
				temp = key
				break
			end
		end
		table.remove(BagData.Instance.showList[self.currentType], temp)
		showList = nil
	end
	showList = BagData.Instance.showList["AllType"]
	for key, value in pairs(showList) do
		if self.currentId == value then
			temp = key
			break
		end
	end
	table.remove(BagData.Instance.showList["AllType"], temp)
	len = #BagData.Instance.showList["AllType"]
	--由于下次新建的物体肯定在显示表最后一个元素(pos)下一位位置
	if len == 0 then
		self.itemPos = 1
	else
		self.itemPos = BagData.Instance.itemList[showList[len]].pos + 1
	end
end
--
--
---窗口------------------------------------------------
function BagClass:ClearCreateWindow()
	self.tipIconInputField.text = "1"
	self.tipNameInputField.text = ""
	self.tipCountInputField.text = "0"
	self.tipTypeInputField.text = self.currentType
	self.tipPriceInputField.text = "0"
	self.tipDescribeInputField.text = ""
end

function BagClass:OnClickHightLightOff()
	BagData.Instance.itemList[self.currentId].HLTransform.gameObject:SetActive(false)
end

function BagClass:ShowDescribeItem(tempItem)
	self.describeIconImg.sprite = BagData.Instance:GetSprite(tempItem.icon)
	self.describeNameText.text = tempItem.name
	self.describeCount.text = string.format("拥有：<color=#05FF00FF>%s</color>", tempItem.count)
	self.describeContentText.text = string.format("\t<color=#6E8CB2FF>%s</color>", tempItem.describe)
	self.describePriceTipText.text = string.format("<color=#05FF00FF>可出售：</color><color=#ff0000>%s</color>", tempItem.price)

	self.describeIconImg.gameObject:SetActive(true)
	self.describeNameText.gameObject:SetActive(true)
	self.describeCount.gameObject:SetActive(true)
	self.describeContentText.gameObject:SetActive(true)
	self.describePriceTipText.gameObject:SetActive(true)
end

function BagClass:HideDescribeItem()
	self.describeIconImg.gameObject:SetActive(false)
	self.describeNameText.gameObject:SetActive(false)
	self.describeCount.gameObject:SetActive(false)
	self.describeContentText.gameObject:SetActive(false)
	self.describePriceTipText.gameObject:SetActive(false)
end

function BagClass:UpdateOldType()
	self.TypeList[self.currentType].sprite = BagData.Instance:GetSprite(7)
	self:ClearItem()
end

function BagClass:ClearItem()
	local showList = BagData.Instance.showList[self.currentType]
	for _, value in pairs(showList) do
		BagData.Instance.itemList[value].ob.gameObject:SetActive(false)
	end
end