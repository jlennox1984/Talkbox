<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
  "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <title>Google Maps JavaScript API Example</title>
    <script src="http://maps.google.com/maps?file=api&amp;v=2&amp;key=ABQIAAAA7WifngjNQxEXnosdgbAdxRTlAGJwJB3dH7AAB6QZqfA-80E6fhRXQfzlVCW6t-GNbFNENXLv2Ybgcw"
      type="text/javascript"></script>
    <script type="text/javascript">

    //<![CDATA[


    function load() {
      if (GBrowserIsCompatible()) {
        var map = new GMap2(document.getElementById("map"));
        map.setCenter(new GLatLng(37.4419, -122.1419), 13);
	map.addControl(new GSmallMapControl());
  
    }



   GEvent.addListener(map, 'click',
        function(overlay, point) {
            if (point) {
                document.getElementById('field_latitude').value = point.y;
                document.getElementById('field_longitude').value = point.x;
            }
        }
  )
}; 
   
 function boot(){
        setTimeout('load();',3000);
        }
    
//]]>
    </script>
  </head>
  <body onload="boot()" onunload="GUnload()">
    <div id="map" style="width: 500px; height: 300px"></div>
	<input id="field_latitude" size="20">
<input id="field_longitude" size="20">


  </body>
</html>
