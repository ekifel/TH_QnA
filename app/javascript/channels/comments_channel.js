import consumer from "./consumer"

$(document).on('turbolinks:load', function() {
    consumer.subscriptions.create({ channel: "CommentsChannel", question_id: gon.question_id }, {
        received(data) {
            if (gon.current_user != null && gon.current_user.id == data['user_id']) { return }

            if (data['commentable_type'] == 'Question') {
                $('#question-'+ gon.question_id +' .comments').prepend("<p>"+ data['body'] + "</p>")
            } else {
                $('.answers #answer-id-'+ data['commentable_id'] +' .comments').prepend("<p>"+ data['body'] + "</p>")
            }
        }
    });
});
