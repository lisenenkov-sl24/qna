import consumer from "./consumer"

global.subscribe_question_list = function () {
    const questions = $('table.questions');
    if (questions.length) {
        consumer.subscriptions.create('QuestionsChannel', {
            received: function (data) {
                if (data.action == 'create') {
                    questions.append(data.data)
                }
            }
        })
    }
};
