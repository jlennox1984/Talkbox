<?php
  include 'functions.php';
  $sd=new sd();
  $sd->auth();
  $zid=$_REQUEST['zid'];	
  $prefix=$_REQUEST['prefix'];
  global $db;
  $sql="DELETE FROM postalcodes WHERE postalcode_id='$prefix' AND zone_id='$zid'";
  $result=mysql_query($sql,$db);
  //  echo $sql;
  header("location:postalcodes.php?zid=$zid");?>
  
?>