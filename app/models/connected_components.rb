class ConnectedComponents
  attr_reader :id, :count

  def initialize vertexes, adj_proc, rev_adj_proc
    @marked = Hash.new false # table of marked vertexes
    @id = Hash.new           # map of id -> component id

    # Number of strongly connected components
    @count = 0

    @adj_proc = adj_proc

    df_order = DFOrder.new vertexes, rev_adj_proc

    p df_order.post_order.reverse_each.map { |id| Page.find(id).title }
    df_order.post_order.reverse_each do |v|
       unless @marked[v]
         dfs v
         @count += 1
       end
    end
  end

  private

  def dfs v
    stack = [v]
    while v = stack.pop
      @marked[v] = true
      @id[v] = @count
      @adj_proc.call(v).each { |adj| stack << adj unless @marked[adj] }
    end
  end
end
