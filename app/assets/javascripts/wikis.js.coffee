# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
#
page_suggestions = (query, process)->
  console.log(query)

$ ->

  wiki = 'zawiki'
  $('.typeahead').typeahead
    name: 'pages',
    remote: "/#{wiki}/pages?q=%QUERY"

