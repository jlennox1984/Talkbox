<?php
include 'config.inc.php';
?>
<html>
<head>
<title>Who locations in London</title>
<script src="http://maps.google.com/maps?file=api&v=2&key=ABQIAAAA7WifngjNQxEXnosdgbAdxRTlAGJwJB3dH7AAB6QZqfA-80E6fhRXQfzlVCW6t-GNbFNENXLv2Ybgcw" type="text/javascript"></script>
<script type="text/javascript">
//<![CDATA[

var map = new GMap2(document.getElementById("map"));
map.addControl(new GLargeMapControl());
map.addControl(new GMapTypeControl());
map.addControl(new GScaleControl());
map.setCenter(new GLatLng(51.512161, -0.14110), 11, G_NORMAL_MAP);

// Creates a marker whose info window displays the given number
function createMarker(point, number)
{
var marker = new GMarker(point);
// Show this markers index in the info window when it is clicked
var html = number;
GEvent.addListener(marker, "click", function() {marker.openInfoWindowHtml(html);});
return marker;
};
</script>
</head>
<body>
<p><strong>Who-locations in London</strong></p>
<div id="map" style="width: 800px; height: 600px"></div> 

