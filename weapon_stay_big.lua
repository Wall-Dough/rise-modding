log.info("[weapon_stay_big.lua] loaded")

require("mhrise-utils")

local identity3f = Vector3f.new(1, 1, 1)
local WEAPON_SCALE = 1
local PLAYER_SCALE = 1
local MONSTER_SCALE = 1

--hook_equip_select(before_equip_select, after_equip_select)
hook_equip_list(before_equip_list_update, after_equip_list_update)

do_every_frame(function()
    local me = get_player()
    if not me then return end
    set_player_scale(identity3f * PLAYER_SCALE, me)

    local monster = get_large_monster()
    if not monster then return end
    set_large_monster_scale(identity3f * MONSTER_SCALE, monster)

    -- Scale the main weapon back to 100%
    local weapon = get_main_weapon(me)
    if not weapon then return end
    set_weapon_scale(identity3f * WEAPON_SCALE, weapon)

    -- Scale the sub weapon (LS scabbard for instance) back to 100%
    weapon = get_sub_weapon(me)
    if not weapon then return end
    set_weapon_scale(identity3f * WEAPON_SCALE, weapon)
end)
