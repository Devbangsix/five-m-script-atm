ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('orp:bank:deposit')
AddEventHandler('orp:bank:deposit', function(amount)
    local _source = source
	
	local xPlayer = ESX.GetPlayerFromId(_source)
	if amount == nil or amount <= 0 or amount > xPlayer.getMoney() then
		TriggerClientEvent('orp:bank:notify', _source, "error", "จำนวนเงินที่ไม่ถูกต้อง")
	else
		xPlayer.removeMoney(amount)
		xPlayer.addAccountMoney('bank', tonumber(amount))
		TriggerClientEvent('orp:bank:notify', _source, "success", "คุณฝากสำเร็จ $" .. amount)
	end
end)

RegisterServerEvent('orp:bank:withdraw')
AddEventHandler('orp:bank:withdraw', function(amount)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local min = 0
	amount = tonumber(amount)
	min = xPlayer.getAccount('bank').money
	if amount == nil or amount <= 0 or amount > min then
		TriggerClientEvent('orp:bank:notify', _source, "error", "จำนวนเงินที่ไม่ถูกต้อง")
	else
		xPlayer.removeAccountMoney('bank', amount)
		xPlayer.addMoney(amount)
		TriggerClientEvent('orp:bank:notify', _source, "success", "คุณถอนสำเร็จ $" .. amount)
	end
end)

RegisterServerEvent('orp:bank:balance')
AddEventHandler('orp:bank:balance', function()
	
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	balance = xPlayer.getAccount('bank').money
	TriggerClientEvent('orp:bank:info', _source, balance)
end)

RegisterServerEvent('orp:bank:moneyin')
AddEventHandler('orp:bank:moneyin', function()
	
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	--local xItem = xPlayer.getInventoryItem('cash')
	moneyin = xPlayer.getMoney('cash')
	TriggerClientEvent('orp:bank:infomoneyin', _source, moneyin)
end)

RegisterServerEvent('orp:bank:transfer')
AddEventHandler('orp:bank:transfer', function(to, amountt)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xTarget = ESX.GetPlayerFromId(to)
	local amount = amountt
	local balance = 0

	if(xTarget == nil or xTarget == -1) then
		TriggerClientEvent('orp:bank:notify', _source, "error", "ไม่พบผู้รับ")
	else
		balance = xPlayer.getAccount('bank').money
		zbalance = xTarget.getAccount('bank').money
		
		if tonumber(_source) == tonumber(to) then
			TriggerClientEvent('orp:bank:notify', _source, "error", "โอนเงินให้ตัวเองไม่ได้")
		else
			if balance <= 0 or balance < tonumber(amount) or tonumber(amount) <= 0 then
				TriggerClientEvent('orp:bank:notify', _source, "error", "คุณมีเงินไม่พอสำหรับการโอนเงินครั้งนี้")
			else
				xPlayer.removeAccountMoney('bank', tonumber(amount))
				xTarget.addAccountMoney('bank', tonumber(amount))
				TriggerClientEvent('orp:bank:notify', _source, "success", "โอนเรียบร้อย $" .. amount)
				TriggerClientEvent('orp:bank:notify', to, "success", "คุณเพิ่งได้รับ $" .. amount .. ' ผ่านการโอน')
			end
		end
	end
end)