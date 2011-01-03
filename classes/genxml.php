<?php
// Start XML file, create parent node
include 'config.inc.php';
$dom = new DOMDocument("1.0");
$node = $dom->createElement("markers");
$parnode = $dom->appendChild($node); 
$agncyid=$_REQUEST['agencyid'];
// Select all the rows in the markers table

$query = "SELECT *  FROM agency WHERE agencyid=$agncyid";
$result = mysql_query($query,$db);
if (!$result) {  
  die('Invalid query: ' . mysql_error());
} 

header("Content-type: text/xml"); 

// Iterate through the rows, adding XML nodes for each

//while ($row = @mysql_fetch_assoc($result)){  
  
	$count=mysql_num_rows($result);
			$i='0';
  // ADD TO XML DOCUMENT NODE  
  		while ($i < $count){
      $name=mysql_result($result,$i,'agency');
      $bilingual=mysql_result($result,$i,'bilingual_');
      $address=mysql_result($result,$i,'address');
      $lat=mysql_result($result,$i,'lat');
     $lng=mysql_result($result,$i,'lng');
     // Create xml docunment
     
  $node = $dom->createElement("marker");  
  $newnode = $parnode->appendChild($node);   
  $newnode->setAttribute("name",$name);
  $newnode->setAttribute("label",$i);//label ie 1 ,2,3
  $newnode->setAttribute('bilingual_', $bilingual);//type
  $newnode->setAttribute("address",$address);  
  $newnode->setAttribute("lat", $lat);  
  $newnode->setAttribute("lng",$lng); 
$i++;
} 

echo $dom->saveXML();


?>