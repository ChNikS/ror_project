editAnswer = (e) ->
  e.preventDefault()
  $(this).hide()
  answer_id = $(this).data('answerId')
  $('form#edit-answer-' + answer_id).show()

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

createAnswer = (answer) ->
  $('.answers').append(JST['templates/answer']({ answer: answer, user: gon.user }))

deleteAnswer = (answer) ->
  $("#answer-#{ answer.id }").remove()

updateAnswer = (answer) ->
  elem = $("#answer_body-#{ answer.id }") 
  elem.html(answer.body)
    
$(document).ready ->
  $(document).on('click', '.edit-answer-link', editAnswer)
  $(document).on('ajax:success', '.voting', voting)
  $(document).on('ajax:error', '.messages', voteError)

  questionId = $('.question_comments').data('commentableId')
  PrivatePub.subscribe "/questions/#{ questionId }/answers", (data, channel) ->
    console.log(data)
    answer = $.parseJSON(data['answer'])
    switch data['method']
      when 'delete' then deleteAnswer(answer)
      when 'update' then updateAnswer(answer)
      else createAnswer(answer)

