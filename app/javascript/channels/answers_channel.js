import consumer from "./consumer"

$(document).on('turbolinks:load', function() {
    consumer.subscriptions.create({ channel: "AnswersChannel", question_id: gon.question_id }, {
        received(data) {
            data.is_answer_owner = gon.user_id === data.answer.user_id
            if (data.is_answer_owner) { return }
            const template = require('./templates/answer.hbs')
            data.is_question_owner = gon.user_id === gon.question_owner_id
            $('#question-' + gon.question_id + '-answers').append(template(data))
        }
    })
})
