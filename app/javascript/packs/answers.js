$(document).on('turbolinks:load', function(){
   $('.answers').on('click', '.edit-answer-link', function(e) {
       e.preventDefault()
       var answerId = $(this).data('answerId')
       $('form#edit-answer-' + answerId).removeClass('hidden')
   })

    $('.answers .rate-actions').on('ajax:success', function(e) {
        const rateable = e.detail[0]

        rating = rateable.rating
        id = rateable.id
        result = "Answer's rating: " + rating

        $('.answers #answer-id-'+ id +' .answer-rating').html(result)
    })
});
