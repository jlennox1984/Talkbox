<?php
  include 'functions.php';
global $db;
	$zoneid=$_REQUEST['zid'];
	$title_en_raw=$_REQUEST['title_en'];
	$title_fr_raw=$_REQUEST['title_fr'];
	//Clean Values
		$title_en=addslashes($title_en_raw);
		$title_fr=addslashes($title_fr_raw);
			
		$sql="UPDATE  zones SET zone_title='$title_en',zone_tile_fr='$title_fr' WERE zone_id=$zoneid";
		$result=mysql_query($sql,$db);
		echo $sql;
			header("location:editzone.php?zid=$zoneid");
?>