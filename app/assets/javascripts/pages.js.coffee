# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  #:: Bind keys
  $('#reset').on 'click', ->
    window.init()

  window.show_page = (page_id) ->
    $.getJSON "/pages/#{page_id}/info", (page) =>
      $('#show_page').html(HandlebarsTemplates['show_page'](page))

  window.init = (root_node) ->
    root_node = parseInt(root_node, 10)
    window.root_node ||= root_node
    window.graph = new Graph('#graph', window.root_node)

  window.Graph = (element, root)->
    @g3 = jsnx.Graph()

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
    $.getJSON "/pages/#{root}/connected_component", (data) =>
      console.log data
      pages = []
      links = []

      for page in data.pages
        pages.push page.id

      for link in data.links
        links.push [link.from_id, link.to_id]

      @g3.add_nodes_from pages
      @g3.add_edges_from links

