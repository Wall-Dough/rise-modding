-- Returns the player manager
function get_player_manager()
    return sdk.get_managed_singleton("snow.player.PlayerManager")
end

-- Returns the enemy manager
function get_enemy_manager()
    return sdk.get_managed_singleton("snow.enemy.EnemyManager")
end

-- Returns the GUI equipment change manager
function get_equip_change_manager()
    return sdk.get_managed_singleton("snow.gui.fsm.equipchange.GuiEquipChangeFsmManager")
end

-- Returns the player
-- (if no id specified, returns current player)
function get_player(id)
    local playman = get_player_manager()
    if not playman then return nil end
    return playman:call("getPlayer", id or 0)
end

-- Returns the player's main weapon
-- (if no player specified, uses current player)
function get_main_weapon(player)
    player = player or get_player()
    if not player then return nil end
    return player:get_field("_WeaponMain")
end

-- Returns the player's sub weapon (e.g. LS scabbard)
-- (if no player specified, uses current player)
function get_sub_weapon(player)
    player = player or get_player()
    if not player then return nil end
    return player:get_field("_WeaponSub")
end

-- Returns transform for an object
-- (if no object specified, returns nil
function get_object_transform(object)
    if not object then return nil end
    return object:call("get_Transform")
end

-- Returns the transform object for the weapon
-- (if no weapon specified, uses current player's main weapon)
function get_weapon_transform(weapon)
    weapon = weapon or get_main_weapon()
    if not weapon then return nil end
    return get_object_transform(object)
end

-- Sets the scale for an object
-- (if no scale or object, does nothing)
function set_object_scale(scale, object)
    if not scale then return end
    if not object then return end
    local transform = get_object_transform(object)
    if transform then
        transform:call("set_LocalScale", scale)
    else
        object:call("set_LocalScale", scale)
    end
end

-- Sets the weapon's scale
-- (if no weapon specified, uses current player's main weapon)
function set_weapon_scale(scale, weapon)
    weapon = weapon or get_main_weapon()
    set_object_scale(scale, weapon)
end

-- Set the scale of a player
-- (if no player specified, uses current player)
function set_player_scale(scale, player)
    player = player or get_player()
    set_object_scale(scale, player)
end

-- Get a large monster during a quest
-- (if no ID specified, uses the first large monster, e.g. target)
function get_large_monster(id)
    local enemyman = get_enemy_manager()
    return enemyman:call("getBossEnemy", id or 0)
end

-- Sets the scale of a large monster
-- (if no monster specified, uses the first large monster)
function set_large_monster_scale(scale, monster)
    monster = monster or get_monster()
    monster:call("set_LocalScale", scale)
end

-- ATTEMPTS to ride a large monster
-- This doesn't work yet. I'm just guessing on this one.
function ride_large_monster(pid, mid)
    local monster = monster or get_large_monster(mid)
    if not monster then return end
    if monster:call("isMarionette") then return end
    monster:call("requestMarionetteRideOn", pid or 0)
    monster:call("forceMarionetteStart", false)
end

-- ATTEMPTS to return currently selected inventory data
function get_equip_change_window()
    local equipman = get_equip_change_manager()
    if not equipman then return nil end
    return equipman:call("getEquipChangeWindow")
end

function get_equip_list()
    local equipwin = get_equip_change_window()
    if not equipwin then return nil end
    return equipwin:get_field("_PlayerEquipList")
end

function get_equipment_inventory_count()
    local equipinv = get_equip_change_window()
    if not equipinv then return 0 end
    return equipinv:call("get_Count")
end

-- Adds included function as a hook every frame
function do_every_frame(func)
    if not func then return end
    re.on_application_entry("PrepareRendering", func)
end

function before_equip_list_update(args)
    local equip_man = get_equip_change_manager()
    log.debug("equip_man: "..tostring(equip_man))
    local equip_inv = equip_man:call("get_EquipChangeArmorSeriesDataList")
    log.debug("equip_inv: "..tostring(equip_inv))
    local equip_count = equip_inv:call("get_Count")
    log.debug("equip_count: "..tostring(equip_count))
end

function after_equip_list_update()
    
end

function hook_equip_list(before, after)
    sdk.hook(
        sdk.find_type_definition("snow.gui.SnowGuiCommonBehavior.EquipList"):get_method("updateItemContents"), before, after)
end

function before_equip_select(args)
    local equip_man = sdk.to_managed_object(args[2])
    log.debug("equip_man: "..tostring(equip_man))
    local equip_inv = equip_man:call("get_EquipChangeArmorSeriesDataList")
    log.debug("equip_inv: "..tostring(equip_inv))
    local equip_count = equip_inv:call("get_Count")
    log.debug("equip_count: "..tostring(equip_count))
end

function after_equip_select()
end

function hook_equip_select(before, after)
    sdk.hook(
        sdk.find_type_definition("snow.gui.fsm.equipchange.GuiEquipChangeFsmManager"):get_method("openEquipChangeWindow"), before, after)
end
