import consumer from "./consumer"

consumer.subscriptions.create("QuestionsChannel", {
    received(data) {
        const template = require('./handlebars/question.hbs')

        $('.questions').append(template(data))
    }
});
