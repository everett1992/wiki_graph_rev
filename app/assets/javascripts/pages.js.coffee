# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  g3 = jsnx.Graph()
  queue = []

  add_node = (node) ->
    queue.push node
    g3.add_nodes_from [node]

  add_node(root_node)

  color = d3.scale.category20()
  jsnx.draw(g3,
    element: '#graph',
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
