# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  window.Graph = (element, root)->
    @g3 = jsnx.Graph()
    @queue = []

    @link_pages = (from_id, to_id) ->
      if @g3.nodes().indexOf(to_id) == -1
        @queue.push to_id
        @g3.add_nodes_from [to_id]

      @g3.add_edges_from [[from_id, to_id]]

    @next = =>
      page_id = @queue.shift()
      $.getJSON "/links/from/#{page_id}", (links) =>
        for link in links
          @link_pages(link.from_id, link.to_id)

    # Add root node
    @queue.push root
    @g3.add_nodes_from [root]

    color = d3.scale.category20()
    jsnx.draw(@g3,
      element: element,
      layout_attr:
        charge: -120,
        linkDistance: 300
      node_attr:
        r: 5,
        title: (d) -> d.data.title
        label: (d) -> d.data.title
      node_style:
        fill: (d) -> color(d.data.group)
        stroke: 'none'
      edge_style:
        stroke: '#999'
    , true)
    this

  window.graph = new Graph('#graph', root_node)
