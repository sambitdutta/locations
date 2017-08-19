if (typeof $ == 'undefined')
    throw new Error('jQuery id required');

$(function () {

    var shareForm = function (event) {
        console.log(event.target);
        var url = $(event.target).data('url');
        var modalContent = $("#myModal .modal-content");
        var modal = $("#myModal");


        function bindSelect2(followers) {
            console.log(followers.length);

//            followers.select2({
//                ajax: {
//                    url: "/people",
//                    dataType: "json",
//                    data: function (term, page) {
//                        return {
//                            q: term // search term
//                        };
//                    },
//                    processResults: function (data, page) {
//                        return {
//                            results: $.map(data, function (p, i) {
//                                return {
//                                    id: p.id,
//                                    text: p.username
//
//                                }
//                            })
//                        }
//                    }
//                }
//            });

            followers.tokenInput(function () {
                return "/people"
            }, {
                method: 'GET',
                minChars: 3,
                queryParam: 'q',
                theme: 'facebook',
                preventDuplicates: true,
                tokenValue: 'id',
                tokenDelimiter: ',',
                hintText: "Type in a search term to find followers",
                onAdd: function (item) {
                    
                }
            });
        }

        function loadContent(response) {

            var followers = $("#location_follower_ids");
            bindSelect2(followers);

            modal.modal({
                show: true,
                keyboard: false,
                backdrop: 'static'
            });
        }

        modalContent.load(url, loadContent);

    };

    $(document).on("click", "button#shareLocation", shareForm);

    //$("button#shareLocation").click(shareForm.bind(this));

});





