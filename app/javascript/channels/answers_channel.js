import consumer from "./consumer"

$(document).on('turbolinks:load', function() {
    consumer.subscriptions.create({ channel: "AnswersChannel", question_id: gon.question_id }, {
        received(data) {
            if (gon.current_user != null && gon.current_user.id == data['answer']['user_id']) {
                return
            }

            $('#question-' + gon.question_id + '-answers .answers').append(data['template'])
        }
    })
})
