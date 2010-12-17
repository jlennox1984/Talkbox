<?php
include "../config.inc.php";

$query="select agency from agency join agency_svcs on agency.agency_id = agency_svcs.agency_id  where agency_svcs.service_id=7";
$result=mysql_query($query,$db);


$data = array();
 
	while ($row=mysql_fetch_object($result))
	{
		$data [] = $row;
	}
 
	echo json_encode($data);
?>