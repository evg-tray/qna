# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
answer_edit = ->
  $('.edit-answer-link').click (e) ->
    e.preventDefault();
    $(this).hide();
    answer_id = $(this).data('answerId');
    $('#edit_answer_' + answer_id).show();

$(document).ready(answer_edit);
$(document).on('page:load', answer_edit);
$(document).on('page:update', answer_edit);