<?php
  include 'functions.php';
  $sd=new sd();
  $sd->auth();
  $sid=$_REQUEST['id'];
  global $db;
  global $debug;
  //Delete zone;
  $sql="DELETE FROM services WHERE service_id=$sid";
  $result=mysql_query($sql,$db);
  if($debug=='1'){
   echo 'here is the sql:',$sql;
  }
  if($debug=='0'){
    header("location:blank.php");
}

 ?>