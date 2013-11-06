# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
#
page_suggestions = (query, process)->
  console.log(query)

$ ->
  $('#goto_page').on 'click', ->
    page_title = $('#page_title').val()
    window.location = "/#{wiki}/pages/#{page_title}"

  wiki = 'zawiki'
  $('.typeahead').typeahead
    name: 'pages',
    remote: "/#{wiki}/titles?q=%QUERY"
