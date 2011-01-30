<?php
/*Service Desk
 * Copyright Moncrieff Web Design Studios (2009) GPL
 *config.inc.php
 * Author-> Jeffrey Dean Moncrieff
 */

$dhost='localhost';
$username="jeff";
$pass="1771";
$password=$pass;
//$db=mysql_connect($dhost, $username, $pass)or die     ('Error connecting to mysql');
$dbname='speachbox';
$DBI=pg_connect("dbname=$dbname user=$username  password=$password host=localhost ");
$db=$DBI;
$database=$dbname;
$cfg_level=0;
?>
