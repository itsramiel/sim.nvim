local M = {}

---@param s string
function M.lines(s)
	if s:sub(-1) ~= "\n" then
		s = s .. "\n"
	end
	return s:gmatch("(.-)\r*\n")
end

return M
