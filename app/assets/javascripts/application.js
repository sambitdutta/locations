// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require tether.min
//= require bootstrap.min
//= require select2.min
//= require jquery.tokeninput.js
//= require ol.min

var drawMap = (function () {

    function initMap(elem, latitude, longitude) {

        var pointFeature = new ol.Feature(new ol.geom.Point([latitude, longitude]));

//        var dragInteraction = new ol.interaction.Modify({
//            features: new ol.Collection([pointFeature]),
//            style: null
//        });

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
            target: elem,
            view: new ol.View({
                center: [latitude, longitude],
                zoom: 5
            })
        });
        
//        map.addInteraction(dragInteraction)

//        pointFeature.on('change', function () {
//
//
//            console.log('Feature Moved To:' + this.getGeometry().getCoordinates());
//
//            latitude.val(this.getGeometry().getCoordinates()[0]);
//            longitude.val(this.getGeometry().getCoordinates()[1]);
//
//
//        }, pointFeature);

    }

    return {
        initMap: initMap
    };

})();





