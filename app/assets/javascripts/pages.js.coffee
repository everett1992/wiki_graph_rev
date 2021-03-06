# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  window.show_page = (page_id) ->
    $.getJSON "/pages/#{page_id}/info", (page) =>
      $('#show_page').html(HandlebarsTemplates['show_page'](page))

  window.init = (root_node)->
    window.root_node ||= root_node
    window.graph = new Graph('#graph', window.root_node)
    window.graph.next()


  window.update = ->
    enabled = $('input[name=auto]:checked').val() == "on"

    if enabled
      window.graph.next()

    interval = $('input[name=interval]').val()
    setTimeout(window.update, interval)

  window.Graph = (element, root)->
    @ids = window.page_ids
    @gen = 0
    @g3 = jsnx.Graph()
    @queue = []

    @add_random = ->
      if @ids.length > 0
        rand_id = Math.floor(Math.random() * @ids.length)
        page_id = @ids[rand_id]

        @add page_id
        @g3.add_nodes_from [page_id]

    @add = (page_id) ->
      @ids.splice(@ids.indexOf(String(page_id)), 1)
      @queue.push page_id

    @link_pages = (links) ->
      nodes = []
      edges = []

      for link in links
        if @g3.nodes().indexOf(String(link.to_id)) == -1
          @add link.to_id
          nodes.push link.to_id
        else
          console.log "exits"

        edges.push [link.from_id, link.to_id]

      if nodes.length > 0
        @g3.add_nodes_from nodes, group: @gen
      if edges.length > 0
        @g3.add_edges_from edges

      d3.selectAll('g.node').on 'click', (d, e) ->
        console.log d
        show_page d.node

    @next = =>
      @gen += 1
      prev = @queue
      @queue = []

      if  $('input[name=auto_add]:checked').val() == "on" && prev.length == 0
        @add_random()

      for page_id in prev
        $.getJSON "/links/from/#{page_id}", (links) =>
          @link_pages(links)

    # Add root node
    @add root
    @g3.add_nodes_from [root]

    color = d3.scale.category20()
    jsnx.draw(@g3,
      element: element,
      layout_attr:
        charge: -120,
        linkDistance: 20
      node_attr:
        r: 5,
        page_id: (d) -> d.node
      node_style:
        fill: (d) -> color(d.data.group)
        stroke: 'none'
      edge_style:
        stroke: '#999'
    , true)
    this

