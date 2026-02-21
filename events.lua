-- Events

player_moved_event = "pme" -- example event

local listeners = {
    [player_moved_event] = {}
}

function add_listener(type, fn)
    if (listeners[type]) then
        add(listeners[type], fn)
    end
end


function emit(t)
    local ls = listeners[t]
    if not ls then
        return
    end
    foreach(ls, function(listener)
        listener()
    end)

end

function emit_recalc() -- example use
    emit(player_moved_event)
end