$(document).on('turbolinks:load', function(){
    $('.question').on('click', '.edit-question-link', function(e) {
        e.preventDefault()
        var questionId = $(this).data('questionId')
        $('form#question-id-' + questionId).removeClass('hidden')
    })
});
