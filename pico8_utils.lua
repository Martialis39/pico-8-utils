-- events.lua
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
-- pathfinding.lua
g = {} -- a global state object
g.neighbor_map = {} -- a map of all neighbors for all tiles to save time at runtime


function bfs(start_row, start_col, end_row, end_col, grid)
    local visited = {}
    local prev = {}
    for i=1, #grid do
        visited[i] = {}
        prev[i] = {}
    end
    local q = {{col=start_col, row = start_row}}
    local i = 0
    while #q > 0 do
        local curr = q[1]
        deli(q, 1)
        local row,col = curr.row, curr.col
        if col == end_col and row == end_row then
            break
        end
        visited[row][col] = true

        local neighbors = g.neighbor_map[row][col] or {}

        foreach(neighbors, function(neighbor)
            local r, c = neighbor.row, neighbor.col
            if visited[r][c] == true or grid[r][c].type == "#" then
                return 
            end

            prev[r][c] = {row=row, col=col}
            add(q, neighbor)
        end)
    end
    return prev
end

function path_from_result(sr, sc, er, ec, prev)
    if not prev[er][ec] then return {} end

    local path = {}
    local current = {row = er, col = ec}
    
    while current do
        add(path, current)
        local next = prev[current.row][current.col]
        current = next
    end

    if #path < 1 then
        return {}
    end
    local r = reverse(path)
    if r[1].col == sc and r[1].row == sr then
        return r
    else
        return {}
    end

end

function solve(srow, scol, erow, ecol, grid)
  local res = bfs(srow, scol, erow, ecol, grid)
  return path_from_result(srow, scol, erow, ecol, res)
end

 function reverse(table)
    local res = {}
    local j = 1
    for i=#table, 1, -1 do
        res[i] = table[j]
        j += 1
    end
    return res
end


-- util.lua

function for_each_grid(grid, fn, break_fn)
    local early_break = break_fn or function()
        return false
    end

    local i = 1
    while i <= #grid and (early_break() == false) do
        local j = 1
        while j <= #grid[i] and (early_break() == false) do
            
            fn(grid[i][j])
            j = j + 1
        end

        i = i + 1
    end
end

function log(str, override)
    local o = override or false
    printh(str, "log.txt", o)
    return o
end

function logt(t, l)
    local label = l or nil
    local s = ""
    if label then
        s = s .. label .. ": "
    end
    for k, v in pairs(t) do
        local new_snip = k..":"..v.."; "
        s = s .. new_snip
    end
    log(s)
    return s
end

function logtr(t, l)
local label = l or nil
    local s = ""
    if label then
        s = s .. label .. ": "
    end
    for k, v in pairs(t) do
        if type(v) == "table" then
            local res = logtr(v, k)
            s = s..res
        else
            local new_snip = k..":"..v.."; "
        s = s .. new_snip
        end
    end
    log(s)
    return s
end

-- ty nerdy teachers!
function rect_rect_collision( r1, r2 )
  return r1.x < r2.x+r2.w and
         r1.x+r1.w > r2.x and
         r1.y < r2.y+r2.h and
         r1.y+r1.h > r2.y
end


function foreachi(tbl, fn)
    local i = 1
    foreach(tbl, function(e)
        fn(e, i)
        i+=1
    end)
end

function lerp(a, b, t)
    local result = a+t*(b-a)
    return result
end

-- filter accepts a list (table) and a function
-- it calls the function on every elemnt of the list
-- if the response is truthy, the element is kept in a new list, otherwise it is discared
-- the return value is the new list
function filter(list, fn)
    local result = {}
    for i=1, #list do
        local element = list[i]
        local test = fn(element)
        if(test) then
            add(result, element)
        end
        
    end
    return result
end
-- vec.lua

-- ty nerdy teachers!
local mtbl = {
  __sub = function(a, b) 
      return vec2((a.x-b.x), (a.y-b.y))
  end,
  __add = function(a, b) 
      return vec2((a.x+b.x), (a.y+b.y))
  end,
  __mul = function(a, b) 
      return vec2((a.x * b), (a.y * b))
  end,
  __eq = function(a, b)
      return a.x == b.x and b.y == a.y
  end,
  __tostring = function(table)
    local s = ""
    for k,v in pairs(table) do
        s = s..k..": "..v.."; "
    end
    return s
  end
}


function vec2(x, y)
    local x = x or 0
    local y = y or 0
    local t = {x=x, y=y}
    setmetatable(t, mtbl)
    return t
end

function distance_to(a, b)
    return abs(a.x - b.x) + abs(a.y - b.y)
end
