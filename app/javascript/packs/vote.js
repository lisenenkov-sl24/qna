$('turbolinks.load', function () {
    $('.voting').on('ajax:success', function (e) {
        let data = e.detail[0];
        let voted = $('.voted', this);
        let unvoted = $('.unvoted', this);
        console.log(voted.length)
        if (data.rate) {
            voted.removeClass('hidden');
            unvoted.addClass('hidden');
            $('.vote', voted).text(data.rate > 0 ? '+' : '-');
        } else {
            voted.addClass('hidden');
            unvoted.removeClass('hidden');
        }
        $('.rating', this).text(data.rating);
    }).on('ajax:error', function (e) {
        let error;
        try {
            error = e.detail[0].error;
        } catch {
            error = "Can't vote";
        }
        alert(error);
    });
})