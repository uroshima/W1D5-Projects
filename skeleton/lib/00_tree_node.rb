require 'byebug'
class PolyTreeNode
  attr_reader :value, :children, :parent 
  
  def initialize(value)
    @value = value 
    @parent = nil 
    @children = []
  end
  
  def parent=(parent)
    self.parent.children.reject! { |child| self == child } if self.parent
    @parent = parent 
    @parent.children << self unless @parent.nil?
  end
  
  def add_child(child_node)
    child_node.parent = self 
  end
  
  def remove_child(child_node)
    raise "Not a child" unless @children.include?(child_node)
    child_node.parent = nil 
  end
  
  def dfs(target_value)
    return self if self.value == target_value
    @children.each do |child|
      search_results = child.dfs(target_value)
      return search_results unless search_results.nil?
    end
    nil 
  end
  
  def bfs(target_value)
    return self if self.value == target_value
    checked_nodes = [self]
    
    until checked_nodes.empty?
      # debugger
      child = checked_nodes.shift
      return child if child.value == target_value
      # next if child.children.empty?
      child.children.each do |kid|
        checked_nodes << kid
      end
    end
    
    nil
  end
  
  def trace_path_back
    shortest_path = [self.value]
    parent_node = self.parent
    until parent_node.parent.nil?
      shortest_path.unshift(parent_node.value)
      parent_node = parent_node.parent
    end
    shortest_path.unshift(parent_node.value)
    shortest_path
  end
end