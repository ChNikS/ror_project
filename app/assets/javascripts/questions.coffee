# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

voting = (e, data, status, xhr) ->
  votable = $.parseJSON(xhr.responseText)
  $('#votable-total-' + votable.votable_id).html( votable.total )
  if votable.user_voted
    $('#votable-already-links-' + votable.votable_id).removeClass('hidden')
    $('#votable-not-yet-links-' + votable.votable_id).addClass('hidden')
  else
    $('#votable-already-links-' + votable.votable_id).addClass('hidden')
    $('#votable-not-yet-links-' + votable.votable_id).removeClass('hidden')
  
voteError = (e, data, status, xhr) ->
  errors = $.parseJSON(xhr.responseText)
  $.each errors, (index, value) ->
    $('.messages').append(value)
    
$(document).ready ->
  $(document).on('ajax:success', '.voting', voting)
  $(document).on('ajax:error', '.messages', voteError)

  PrivatePub.subscribe '/questions', (data, channel) ->
    question = $.parseJSON(data['question'])
    console.log(data)
    $('.questions').append('<p><a href="/questions/'+question.id+'">' + question.title + '</a></p>')