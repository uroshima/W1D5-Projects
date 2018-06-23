require_relative "00_tree_node.rb"
require 'byebug'
class Knight_Path_Finder
  attr_reader :start_pos, :board, :visited_positions
  
  def initialize(start_pos = [0, 0])
    @start_pos = start_pos
    @board = Array.new(8) { Array.new(8) }
    @visited_positions = [start_pos]
    @move_tree = build_move_tree
  end
  
  def self.valid_move?(pos)
    return false if pos[0] < 0 || pos[0] > 7
    return false if pos[1] < 0 || pos[1] > 7
    true
  end
  
  def self.valid_moves(pos)
    row, col = pos 
    # debugger
    valids = [[row + 2, col + 1], [row + 2, col - 1], [row + 1, col + 2], [row + 1, col - 2], [row - 2, col + 1], [row - 2, col - 1], [row - 1, col + 2], [row - 1, col - 2]]
    valids.select { |move| valid_move?(move)}
  end
  
  def [](pos)
    row, col = pos 
    board[row][col]
  end
  
  def []=(pos, value)
    row, col = pos 
    board[row][col] = value 
  end
  
  def new_move_positions(pos)
    posibilities = Knight_Path_Finder.valid_moves(pos)
    posibilities.select! {|posibility| @visited_positions.include?(posibility) == false}
    @visited_positions += posibilities
    posibilities
  end
  
  def build_move_tree
    root = PolyTreeNode.new(start_pos)
    queue = [root]

    until queue.empty?
      curr_node = queue.shift
      children = new_move_positions(curr_node.value)
      children.map! { |child| PolyTreeNode.new(child)}
      queue += children
      children.each do |child|
        curr_node.add_child(child)
      end
    end
    
    root
  end
  
  def find_path(ending_pos)
    path = @move_tree.bfs(ending_pos)
    path.trace_path_back
  end
  
  def trace_path_back
    shortest_path = [self.value]
    parent_node = self.parent
    until parent_node.parent.nil?
      shortest_path.unshift(parent_node.value)
      parent_node = parent_node.parent
    end
    
    shortest_path
  end
end