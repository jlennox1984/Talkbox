<?php
/*Service Desk
 * Copyright Moncrieff Web Design Studios (2009) GPL
 *config.inc.php
 * Author-> Jeffrey Dean Moncrieff
 */

$dhost='localhost';
$username="postgres";
$pass="";
$password=$pass;
//$db=mysql_connect($dhost, $username, $pass)or die     ('Error connecting to mysql');
$dbname='speachbox';
$DBI=pg_connect("dbname=$dbname user=$username  password=$password host=localhost ");
$db=$DBI;
$database=$dbname;
$cfg_level=1;
$abs_path="/var/www/devel.mwds.ca/web/talkbox2/";
$pic_path="/var/www/devel.mwds.info/web/talkbox2/pics"
?>
