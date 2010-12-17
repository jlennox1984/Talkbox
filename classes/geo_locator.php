<?php
require("config.inc.php");

define("MAPS_HOST", "maps.google.com");
define("KEY", "ABQIAAAA7WifngjNQxEXnosdgbAdxRTlAGJwJB3dH7AAB6QZqfA-80E6fhRXQfzlVCW6t-GNbFNENXLv2Ybgcw");

// Opens a connection to a MySQL server
$connection = mysql_connect("localhost", $username, $password);
if (!$connection) {
  die("Not connected : " . mysql_error());
}

// Set the active MySQL database
$db_selected = mysql_select_db($database, $connection);
if (!$db_selected) {
  die("Can\'t use db : " . mysql_error());
}

// Select all the rows in the markers table
//$query = "SELECT * FROM agency WHERE 1";
$query="SELECT agency_id,CONCAT_WS(',',address,city,province,postalcode) as address FROM agency;";
$result = mysql_query($query);
if (!$result) {
  die("Invalid query: " . mysql_error());
}

// Initialize delay in geocode speed
$delay = 0;
$base_url = "http://" . MAPS_HOST . "/maps/geo?output=xml" . "&key=" . KEY;

// Iterate through the rows, geocoding each address
while ($row = @mysql_fetch_assoc($result)) {
  $geocode_pending = true;

  while ($geocode_pending) {
    $address = $row["address"];
    $id = $row["agency_id"];
	$state=$row["province"];
	$city=$row["city"];
	$postalcode=$row["postal_code"];
	$address_main=$address+$city+$state+$postcode;
    $request_url = $base_url . "&q=" . urlencode($address);
    $xml = simplexml_load_file($request_url) or die("url not loading");

    $status = $xml->Response->Status->code;
    if (strcmp($status, "200") == 0) {
      // Successful geocode
      $geocode_pending = false;
      $coordinates = $xml->Response->Placemark->Point->coordinates;
      $coordinatesSplit = split(",", $coordinates);
      // Format: Longitude, Latitude, Altitude
      $lat = $coordinatesSplit[1];
      $lng = $coordinatesSplit[0];

      $query = sprintf("UPDATE agency" .
             " SET lat = '%s', lng = '%s' " .
             " WHERE agency_id = '$id' LIMIT 1;",
             mysql_real_escape_string($lat),
             mysql_real_escape_string($lng),
             mysql_real_escape_string($id));
      $update_result = mysql_query($query);
      if (!$update_result) {
        die("Invalid query: " . mysql_error());
      }
    } else if (strcmp($status, "620") == 0) {
      // sent geocodes too fast
      $delay += 100000;
    } else {
      // failure to geocode
      $geocode_pending = false;
      echo "Address " . $address . " failed to geocoded. ";
      echo "Received status " . $status . "
\n";
    }
    usleep($delay);
  }
}
if ($debug==1){
echo "<div class='debug'>";
echo "status code " .$status ;
echo "our query is" .$query ;
echo "</div>";
}
?>
