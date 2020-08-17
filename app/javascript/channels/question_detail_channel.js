import consumer from "./consumer"

global.subscribe_question_details = function () {
    const question = $('div.question');
    const questionId = question.data('id');
    consumer.subscriptions.create({channel: 'AnswersChannel', question: questionId}, {
        received: function (data) {
            if (data.action == 'create') {
                if ($('.answers .answer[data-id=' + data.id + ']').length > 0) {
                    return
                }

                if ($('.answers .new-answer').length) {
                    $('.answers .new-answer').before(data.data)
                } else {
                    $('.answers').append(data.data)
                }
            }
        }
    });
    consumer.subscriptions.create({channel: 'CommentsChannel', question: questionId}, {
        received: function (data) {
            if (data.action == 'create') {
                let parentNode = null;
                if (data.parent.type == 'Question') {
                    parentNode = $('.question');
                } else if (data.parent.type == 'Answer') {
                    parentNode = $('.answer[data-id=' + data.parent.id + ']');
                } else {
                    return
                }

                if (parentNode.is('.comments .comment[data-id=' + data.id + ']')) {
                    return
                }
                $('.comments .list', parentNode).append(data.data);
            }
        }
    });
}
