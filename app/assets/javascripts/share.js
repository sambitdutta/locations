if (typeof $ == 'undefined')
    throw new Error('jQuery id required');

$(function () {

    var shareForm = function (event) {

        var url = $(event.target).data('url');
        var modalContent = $("#myModal .modal-content");
        var modal = $("#myModal");


        function bindSelect2(followers) {

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
            var map = $("#map");
            var latitude = $("#location_latitude");
            var longitude = $("#location_longitude");

            bindSelect2(followers);

            drawMap(latitude, longitude);

            modal.modal({
                show: true,
                keyboard: false,
                backdrop: 'static'
            });
        }



        function drawMap(latitude, longitude) {

            var pointFeature = new ol.Feature(new ol.geom.Point([0, 0]));

            var dragInteraction = new ol.interaction.Modify({
                features: new ol.Collection([pointFeature]),
                style: null
            });

            var map = new ol.Map({
                layers: [
                    new ol.layer.Tile({
                        source: new ol.source.TileJSON({
                            url: 'http://api.tiles.mapbox.com/v3/mapbox.geography-class.jsonp'
                        })
                    }),
                    new ol.layer.Vector({
                        source: new ol.source.Vector({
                            features: [pointFeature]
                        }),
                        style: new ol.style.Style({
                            image: new ol.style.Icon(({
                                src: 'http://openlayers.org/en/v3.8.2/examples/data/icon.png'
                            }))
                        })
                    })
                ],
                target: 'share-map',
                view: new ol.View({
                    center: [0, 0],
                    zoom: 3
                })
            });
            map.addInteraction(dragInteraction)

            pointFeature.on('change', function () {


                console.log('Feature Moved To:' + this.getGeometry().getCoordinates());
                
                latitude.val(this.getGeometry().getCoordinates()[0]);
                longitude.val(this.getGeometry().getCoordinates()[1]);


            }, pointFeature);

        }

        modalContent.load(url, loadContent);

    };

    $(document).on("click", "button#shareLocation", shareForm);

    //$("button#shareLocation").click(shareForm.bind(this));

});





