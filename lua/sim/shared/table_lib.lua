local M = {}

---@param ... table[]
function M.merge(...)
  local merged = {}

  for _, tbl in ipairs({ ... }) do
    table.move(tbl, 1, #tbl, #merged + 1, merged)
  end

  return merged
end

return M
