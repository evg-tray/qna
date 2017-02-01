votes = ->
  $('.question, .answers').bind 'ajax:success', (e, data, status, xhr) ->
    response = $.parseJSON(xhr.responseText)
    $('.' + response.name + '-votes-' + response.id + ' .rating').html(response.rating)
    if response.action == 'create'
      $('.' + response.name + '-up-down-' + response.id).addClass('hidden')
      $('.' + response.name + '-del-' + response.id).removeClass('hidden')
      $('.' + response.name + '-del-' + response.id + ' a').attr('href', "/votes/#{response.vote_id}")
    else
      $('.' + response.name + '-up-down-' + response.id).removeClass('hidden')
      $('.' + response.name + '-del-' + response.id).addClass('hidden')
      $('.' + response.name + '-del-' + response.id + ' a').attr('href', "#")
  #.bind 'ajax:error', (e, xhr, status, error) ->
    #response = $.parseJSON(xhr.responseText)
    #$.each errors, (index, value) ->
      #$('.answer-errors').append(value)

$(document).ready(votes);
$(document).on('page:load', votes);
$(document).on('page:update', votes);