local grid = {}
function init(r,c)
	-- rows & cols
	grid = {}
	for i = 1, r do
		grid[i] = {}

		for j = 1, c do
			grid[i][j] = 0
		end
	end
end
if(grid[j][i] == 0) then
	L1Map[j][i] = alphabet[math.floor(math.random() * table.maxn(alphabet))+1]
end

return grid
