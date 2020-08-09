import consumer from "./consumer"

global.subscribe_question_details = function () {
    const question = $('div.question');
    const questionId = question.data('id');
    consumer.subscriptions.create({channel: 'AnswersChannel', question: questionId}, {
        received: function (data) {
            let received_json = JSON.parse(data);
            console.log(received_json);
            if (received_json.action == 'create') {
                if (!$('.answers .answer[data-id=' + received_json.id + ']').empty()) {
                    return
                }

                if($('.answers .new-answer').empty()) {
                    $('.answers').append(received_json.data)
                }else {
                    $('.answers .new-answer').before(received_json.data)
                }
            }
        }
    });
    consumer.subscriptions.create({channel: 'CommentsChannel', question: questionId}, {
        received: function (data) {
            let received_json = JSON.parse(data);
            console.log(received_json);
            if (received_json.action == 'create') {
                let parentNode = null;
                if (received_json.parent.type == 'Question') {
                    parentNode = $('.question');
                } else if (received_json.parent.type == 'Answer') {
                    parentNode = $('.answer[data-id=' + received_json.parent.id + ']');
                } else {
                    return
                }

                if (parentNode.is('.comments .comment[data-id=' + received_json.id + ']')) {
                    return
                }
                $('.comments .list', parentNode).append(received_json.data);
            }
        }
    });
}
