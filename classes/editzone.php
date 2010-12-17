<?php
include 'functions.php';
$sd= new sd();
$sd->auth();
//  include 'config.inc.php';
	$zid=$_REQUEST['zid'];
//	$zid=2;
	$query="SELECT zone_title,zone_title_fr FROM zones where zone_id=$zid";
	$result=mysql_query($query,$db);
	$zone_title=mysql_result($result,0,"zone_title");
	$zone_title_fr=mysql_result($result,0,"zone_title_fr");
	
	
	if(isset($_POST['submit'])){
	$zone_title_= mysql_escape_string($_POST['title']);
	$zone_title_= mysql_escape_string($_POST['title_fr']);
	
	$sql="UPDATE zones SET zone_title,zone_title_fr where zone_id=$zid";
	$result=mysql_query($sql,$db);
	
	}
?>

<html>
	<head>
		<script type="text/javascript" src="../js/main.js"/>		
		<title>Edit zones</title>
		<?php $sd->show_simple_header();?>
		</head>
		<body>
		<h1> Edit zone  <?php echo $zone_title. ',' .$zid ?></h1>
	<form name="edit zone" id="edit_zone" method="post" action="editzone_update.php">
	<input type='hidden' name='zid' value="<?php echo $zid?>">
				<table summary="edit form">
					<tr><td><input type="text" name='title_en' id="title_en" value="<?php echo "$zone_title"?>"> </td></tr>
					<tr><td><input type="text" name='title_fr' id="title_fr" value="<?php echo "$zone_title_fr"?>"></td></tr>
					<tr><td><input type="submit" name="submit" value="submit"/></td></tr>
				</table>	
			</form>
			</body>
			</html>
		
