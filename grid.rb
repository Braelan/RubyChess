# Module for common 2D array operations

module GRID
  def cells_each(&prc)
    grid.each_with_index do |row, row_idx|
      row.each_with_index do |cell, col_idx|
        prc.call(cell, [row_idx, col_idx])
      end
    end
  end

  def cells_map(&prc)
    output = Array.new(grid.count) { Array.new(grid.first.count) }
    cells_each do |cell, pos|
      output[pos[0]][pos[1]] = prc.call(cell, pos)
    end
    output
  end

  def cells_select(&prc)
    output = []
    cells_each do |cell, pos|
      output << cell if prc.call(cell, pos)
    end
    output
  end

  def cells_index_where(&prc)
    output = []
    cells_each do |cell, pos|
      output << pos if prc.call(cell, pos)
    end
    output
  end

  def cells_all?(&prc)
    cells_each do |cell, pos|
      return false unless prc.call(cell, pos)
    end
    true
  end

  def cells_none?(&prc)
    cells_each do |cell, pos|
      return false if prc.call(cell, pos)
    end
    true
  end

  def cells_any?(&prc)
    output = false
    cells_each do |cell, pos|
      output = output || prc.call(cell, pos)
    end
    output
  end

  def dup_grid
    grid.dup.map(&:dup)
  end

  def cells_inject(accum = nil, &prc)
    cells = cells_select {|_| true}
    accum = cells.shift if accum.nil?
    cells.inject(accum, &prc)
  end

  def [](row, col)
    grid[row][col]
  end

  def []=(row, col, value)
    grid[row][col] = value
  end

  def new_grid(num_rows, num_colums = nil, def_cell = nil)
    num_columns ||= num_rows
    @grid = Array.new(num_rows) { Array.new(num_columns) { def_cell } }
  end

  private

  attr_reader :grid

end

class Grid
  include GRID
  def initialize(rows, columns, default_cell = nil)
    @grid = Array.new(rows) { Array.new(columns) { default_cell } }
  end
end
