<?php
  include 'functions.php';
  $sd=new sd();
  $sd->auth();
  $zid=$_REQUEST['zid'];	
  $prefix=$_REQUEST['prefix'];
  global $db;
  //Delete zone;
  $sql="DELETE FROM zones WHERE zone_id=$zid";
  $result=mysql_query($sql,$db);
  //Delete postalcodess for the zone 
  $sql="DELETE FROM postalcodes WHERE zone_id='$zid'";
  $result=mysql_query($sql,$db);
  //  echo $sql;
   header("location:listzones.php");
   ?>