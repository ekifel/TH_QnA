import consumer from "./consumer"

consumer.subscriptions.create("QuestionsChannel", {
    received(data) {
        if (gon.current_user != null && gon.current_user.id == data['user_id']) { return }

        var questionTitle = "<h2><a href='questions/" + data['id'] + "'>"+ data['title'] +"</a></h2>"
        var questionBody = "<b>" + data['body'] + "</b>"

        $('.questions').append(questionTitle + questionBody)
    }
});
