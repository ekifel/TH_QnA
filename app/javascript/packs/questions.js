$(document).on('turbolinks:load', function(){
    $('.question').on('click', '.edit-question-link', function(e) {
        e.preventDefault()
        var questionId = $(this).data('questionId')
        $('form#question-id-' + questionId).removeClass('hidden')
    })

    $('.question .rate-actions').on('ajax:success', function(e) {
        const rateable = e.detail[0]

        rating = rateable.rating
        id = rateable.id
        result = "Question's rating: " + rating

        $('.question .question-rating').html(result)
    })
});
