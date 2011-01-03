<?php
  include 'config.inc.php';
  $sql="SELECT lat AS latitude,lng as longitude ,address,agency FROM agency";
  $arr = array();
$rs = mysql_query($sql);

while($obj = mysql_fetch_object($rs))
{
$arr[] = $obj;
}
print json_encode($arr);
?>