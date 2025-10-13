gui.createMainTab("Cash Dropper")
gui.addButton("Drop Cash", "Drop some cash.", function()
	script.queue(function()
		local playerPosition = util.getLocalPosition()
		local playerForward = ENTITY.GET_ENTITY_FORWARD_VECTOR(util.getLocalPlayerHandle())
		playerPosition.z = playerPosition.z + 3
		OBJECT.CREATE_MONEY_PICKUPS(playerPosition.x, playerPosition.y, playerPosition.z, 100000, 5, 0x113FD533)
	end)
end)