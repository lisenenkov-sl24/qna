import consumer from "./consumer"

document.addEventListener('turbolinks:load', function() {
    const questions = $('table.questions');
    if(questions.length){
        consumer.subscriptions.create('QuestionsChannel', {
            received: function (data) {
                let received_json = JSON.parse(data);
                console.log(received_json);
                if(received_json.action == 'create'){
                    questions.append(received_json.data)
                }
            }
        })
    }
});
