module Algs
  class ConnectedComponents

    # Yeilds once for each discovered connected component
    # passing an array of connected pages to the block
    #
    # This method means I don't have to keep every component in memory,
    # so I think the only object that grows with input size is the marked array.
    def self.each vertexes, adj_proc, rev_adj_proc, &block
      marked = Hash.new false # table of marked vertexes

      df_order = Algs::DFOrder.new vertexes, rev_adj_proc

      df_order.post_order.reverse_each do |v_0|
        unless marked[v_0]
          component = Array.new
          stack = [v_0]
          while v = stack.pop
            marked[v] = true
            component << v
            adj_proc.call(v).each { |adj| stack << adj unless marked[adj] }
          end
          yield component
        end
      end
    end
  end
end
