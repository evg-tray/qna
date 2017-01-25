# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
question_edit = ->
  $('.edit-question-link').click (e) ->
    e.preventDefault();
    $(this).hide();
    $('.edit_question').show();

$(document).ready(question_edit);
$(document).on('page:load', question_edit);
$(document).on('page:update', question_edit);