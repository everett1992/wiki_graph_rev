class ConnectedComponent < ActiveRecord::Base
  has_many :pages
  has_many :links
  belongs_to :wiki

  def graph
    g = GraphViz.new :G, type: :digraph
    nodes = Hash.new

    self.pages.find_each { |page| nodes[page.id] = g.add_nodes page.title }
    self.links.find_each { |link| g.add_edges nodes[link.from_id], nodes[link.to_id] }

    return g
  end

  # This might not be a model method, it is only called once, after loading wiki data (isn't actually called right now)
  def self.generate pages
    vertexes = pages.pluck :id

    # I tried building in memory adjacancy matrixes, but exceded 8G memory.
    # TODO: Look into adjacancy matrix again (build in mysql?)
    # Returns an array of pages that link to the passed page
    adj_proc = Proc.new { |page_id| Link.where(from_id: page_id).pluck(:to_id) }
    # Returns an array of pages that link to the passed page (used for reverse graph)
    rev_adj_proc = Proc.new { |page_id| Link.where(to_id: page_id).pluck(:from_id) }

    #                                                                          |- Component -|
    # Returns an array of connected components represented as sets of pages. [ [ <page>, ... ], ... ]
    Algs::ConnectedComponents.each(vertexes, adj_proc, rev_adj_proc) do |connected_pages|
      component = ConnectedComponent.new
      component.pages << Page.find(connected_pages)
      component.save
    end
  end
end
