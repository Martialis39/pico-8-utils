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

