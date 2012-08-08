<?php
/*Talkbox
 * Copyright Moncrieff Web Design Studios (2009) GPL
 *config.inc.php
 * Author-> Jeffrey Dean Moncrieff
 */

$dhost='localhost';
$username="postgres";
$pass="postgres"
;


$password=$pass;
//$db=mysql_connect($dhost, $username, $pass)or die     ('Error connecting to mysql');
$dbname='talkbox';

$DBI=pg_connect("dbname=$dbname user=$username  password=$password host=localhost");
$db=$DBI;
$database=$dbname;
$cfg_level=1;
$abs_path="/var/www/";
$pic_path="/var/www/pics";
$TBUrl='http://localhost/classes';
$audiodir="/var/www/classes/tts/mp3_tts";
?>
