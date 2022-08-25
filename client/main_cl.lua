ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(10)
    end
    while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
    end
    if ESX.IsPlayerLoaded() then

		ESX.PlayerData = ESX.GetPlayerData()

    end
end)

function GetPlayers()
	local players = {}

	for i = 0, ConfigPJB.slots do
		if NetworkIsPlayerActive(i) then
			table.insert(players, i)
		end
	end

	return players
end



Citizen.CreateThread(function()
	local blips = {}
	local currentPlayer = PlayerId()

	while true do
	
		if ConfigPJB.enable then			-- if you activate
		
			Wait(ConfigPJB.refresh)			-- refresh like setup in config

			local players = GetPlayers()	-- work on all players connected

			for player = 0, ConfigPJB.slots do
				if player ~= currentPlayer and NetworkIsPlayerActive(player) then	
					local playerPed = GetPlayerPed(player)
					local playerName = GetPlayerName(player)

					RemoveBlip(blips[player]) 	-- Delete blip of the player (to be refresh)
					
					if player.job == currentPlayer.job or ConfigPJB.setup == 1 then	-- If the player had the same job than the current player OR if the setup config indicate to see ALL players
					
						if currentPlayer.job.grade >= ConfigPJB.mingrade or ConfigPJB.setup == 1 then 		-- If the current player had enough grade level, he can see collegues
						
							local new_blip = AddBlipForEntity(playerPed)

							SetBlipNameToPlayerName(new_blip, player)	-- Add player name to blip
							SetBlipColour(new_blip, player + 10)		-- Make blip white
							SetBlipCategory(new_blip, 2)				-- Enable text on blip

							-- Set the blip to shrink when not on the minimap
							-- Citizen.InvokeNative(0x2B6D467DAB714E8D, new_blip, true)

							SetBlipScale(new_blip, 0.9)					-- Shrink player blips slightly
							Citizen.InvokeNative(0xBFEFE3321A3F5015, playerPed, playerName, false, false, '', false)	-- Add nametags above head

							blips[player] = new_blip					-- Record blip so we don't keep recreating it
						
						end -- end If the current player had enough grade level
						
					end -- end If the player had the same job
					
				end -- end if player ~= currentPlayer
			end -- enf for player = 0,			
		end -- end of if ConfigPJB.enable 
	end
end)
