module Algs
  class DFOrder
    attr_reader :post_order

    def initialize vertexes, adj_proc
      @post_order = Array.new   # tracks post order
      @adj_proc = adj_proc      # finds adjacent nodes
      @marked = Hash.new(false) # id -> marked (true/false)

      vertexes.each do |v|
        dfs(v) unless @marked[v]
      end
    end

    def dfs v
      stack = [v]
      while v = stack.last
        @marked[v] = true
        length = stack.count
        @adj_proc.call(v).each { |adj| stack << adj unless @marked[adj] }
        if length == stack.count
          stack.pop
          @post_order << v
        end
      end
    end
  end
end