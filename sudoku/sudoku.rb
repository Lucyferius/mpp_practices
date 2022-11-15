require 'matrix'
def solve_sudoku(grid)
  raise ArgumentError.new('Matrix size should be N*N') unless grid.row_size == grid.column_size
  solve(grid, 0, 0)
end
def is_safe(grid, row, col, num)
  range = (0..(grid.column_size - 1))
  range.each do |i|
    if grid[row, i] == num || grid[i, col] == num
      return false
    end
  end

  half_size = Math.sqrt(grid.column_size).to_i
  start_row = row - (row % half_size)
  start_col = col - (col % half_size)
  (0..(half_size-1)).each do |i|
    (0..(half_size-1)).each do | j |
      if grid[(i + start_row), (j + start_col)] == num
        return false
      end
    end
  end
  true
end
def solve(grid, row, col)
  if row == grid.column_size - 1 && col == grid.column_size
    return true
  end

  if col == grid.column_size
    row += 1
    col = 0
  end

  if grid[row, col] > 0
    return solve(grid, row, (col + 1))
  end

  (1..grid.column_size).each do |num|
    if is_safe(grid, row, col, num)
      grid[row, col] = num
      if solve(grid, row, (col + 1))
        return true
      end
    end
    grid[row, col] = 0
  end
  false
end



grid = Matrix[
  [3, 0, 6, 5, 0, 8, 4, 0, 0],
  [5, 2, 0, 0, 0, 0, 0, 0, 0],
  [0, 8, 7, 0, 0, 0, 0, 3, 1],
  [0, 0, 3, 0, 1, 0, 0, 8, 0],
  [9, 0, 0, 8, 6, 3, 0, 0, 5],
  [0, 5, 0, 0, 9, 0, 6, 0, 0],
  [1, 3, 0, 0, 0, 0, 2, 5, 0],
  [0, 0, 0, 0, 0, 0, 0, 7, 4],
  [0, 0, 5, 2, 0, 6, 3, 0, 0]]

puts grid.to_a.map(&:inspect)
if solve_sudoku(grid)
  puts
  puts grid.to_a.map(&:inspect)
else
  puts
  puts 'No solution'
end
