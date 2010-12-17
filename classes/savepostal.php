<?php
  include 'functions.php';
  $sd=new sd();
  $sd->auth();
  $zid=$_REQUEST['zid'];	
  global $db;
 $postalcode_prefix_raw=$_REQUEST['postal_prefix'];
$postalcode_prefix=strtoupper($postalcode_prefix_raw);
  $sql="INSERT INTO postalcodes (`postalcode_id`,`zone_id`)VALUES('$postalcode_prefix','$zid')";
  $result=mysql_query($sql,$db);
  //  echo $sql;
header("location:postalcodes.php?zid=$zid");?>
  