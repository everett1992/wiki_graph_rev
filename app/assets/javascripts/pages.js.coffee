# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  window.Graph = (element, root)->
    @gen = 0
    @g3 = jsnx.Graph()
    @queue = []

    @link_pages = (links) ->
      nodes = []
      edges = []
      for link in links
        if @g3.nodes().indexOf(String(link.to_id)) == -1
          @queue.push link.to_id
          nodes.push link.to_id
        else
          console.log "exits"

        edges.push [link.from_id, link.to_id]

      if nodes.length > 0
        @g3.add_nodes_from nodes, group: @gen
      if edges.length > 0
        @g3.add_edges_from edges

    @next = =>
      @gen += 1
      prev = @queue
      @queue = []
      for page_id in prev
        $.getJSON "/links/from/#{page_id}", (links) =>
          @link_pages(links)

    # Add root node
    @queue.push root
    @g3.add_nodes_from [root]

    color = d3.scale.category20()
    jsnx.draw(@g3,
      element: element,
      layout_attr:
        charge: -120,
        linkDistance: 20
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

