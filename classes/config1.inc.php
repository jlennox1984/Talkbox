<?php
$dhost='localhost';
$username='jdmonc';
$pass='omar0220';
$password=$pass; 
$db=mysql_connect($dhost, $username, $pass)or die     ('Error connecting to mysql');
$dbname='service_desk';
$database=$dbname;
mysql_select_db($dbname);
$map_key='ABQIAAAA7WifngjNQxEXnosdgbAdxRTlAGJwJB3dH7AAB6QZqfA-80E6fhRXQfzlVCW6t-GNbFNENXLv2Ybgcw'; //Google MapS API KEY
$debug='1';
$web_path='http://localhost/ocsc/cms/images'; //public portal path
/*
function form($data) { // Prevents SQL Injection
   global $db;
   $data = ereg_replace("[\'\")(;|`,<>]", "", $data);
   $data = mysql_real_escape_string(trim($data), $db);
   return stripslashes($data);
} */
?>