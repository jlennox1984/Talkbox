<?php
/*Service Desk
 * Copyright Moncrieff Web Design Studios (2009) GPL
 *config.inc.php
 * Author-> Jeffrey Dean Moncrieff
 */

$dhost='localhost';
$username='root';
$pass='5373988';
$password=$pass;
//$db=mysql_connect($dhost, $username, $pass)or die     ('Error connecting to mysql');
$dbname='speachbox';
$DBI=pg_connect("dbname=$dbname ,user=$username , password=$password host=localhost ");
$db=$DBI;
$database=$dbname;
mysql_select_db($dbname);
$map_key='ABQIAAAA7WifngjNQxEXnosdgbAdxRTM9x-3kAO0YveiIk8s-3ASCoIYphS6DGkDwBFgoAyCR0XB1gdOIOVFTA';


?>
