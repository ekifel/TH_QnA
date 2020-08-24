$(document).on('turbolinks:load', function(){
   $('.answers').on('click', '.edit-answer-link', function(e) {
       e.preventDefault()
       var answerId = $(this).data('answerId')
       $('form#edit-answer-' + answerId).removeClass('hidden')
   })
});
