local show = true
local active = false
local numero = 1
local ProgressColor = {0, 255, 60}
local global_text
local global_timer
local global_type
------------EXAMPLE------------------------
--	  local timer = 5 
--	  local type = "success" 
--    local text = "Simple test rdx_notification"
--    TriggerEvent("rdx_notification:start", text, timer, type)
--------------OR-------------------------

--    TriggerEvent("rdx_notification:start", "Simple test rdx_notification" , 5)


RegisterNetEvent('rdx_notification:start')
AddEventHandler('rdx_notification:start',  function(_text, _timer, _type)
global_type = _type
global_text = _text
global_timer =_timer
if _type == "error" then
	ProgressColor =  {0, 0, 0}
elseif _type == "success" then
	ProgressColor =  {0, 255, 60}
elseif _type == "warning" then
	ProgressColor =  {255, 111, 0}
else
	ProgressColor =  {0, 255, 60}
end
    if active then
	  Citizen.CreateThread(function()
        active = false
        hideUI()
		 Citizen.Wait(100)
		TriggerEvent("rdx_notification:start", global_text , global_timer, global_type)
		end)
    else
        active = true
        numero = GetLengthOfLiteralString(_text)
        print(numero)
        ShowUI(_text, numero)
        bg(_timer)
    end
end)




function hideUI()
    SendNUIMessage({
        type = "ui",
        display = false

    })
    show = false
    active = false
end

function ShowUI(text)
    local _text = text
    local _numero = numero*1.1
    if _numero < 80 then
        _numero = 80
    end
    SendNUIMessage({
        type = "ui",
        display = true,
        text = _text,
        numero = _numero
    })
    show = true
end


function bg(_timer)
    local offset = 0
    local height = numero*0.0015
    local load_offset = 0.6
    if height < 0.1 then
        height = 0.1
    end
    if numero < 100 and numero > 75 then
        offset = 0.01
        load_offset = 0.60
    end
    if numero > 100 and numero < 145 then
        offset = numero*0.0002
    end
    if numero >= 145 then
        offset = numero*0.0003
    end
    if numero > 200 then
        offset = numero*0.0004
        load_offset = 0.58
    end
    print(offset)
    HasStreamedTextureDictLoaded("generic_textures")
    HasStreamedTextureDictLoaded("feeds")
    Citizen.CreateThread(function()
        local timer = _timer*100
        local loading = 0.22
        local del = loading/timer
        while  show and timer > 0 do
            Citizen.Wait(0)
            DrawSprite("feeds", "toast_bg", 0.15, 0.57+offset, 0.25, height, 0.2, 119, 9, 1, 255, 1)
            DrawSprite("generic_textures", "hud_menu_4a", 0.15, load_offset +(offset*2), loading, 0.01, 0.2, ProgressColor[1], ProgressColor[2], ProgressColor[3], 190, 0)
            timer = timer - 1
            loading = loading - del
        end

        hideUI()
    end)

end
