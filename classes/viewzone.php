
<html>
	<head>
		<title> List zones</title>
		
		
		<script type="text/javascript" src="../../js/main.js"></script>
		
		</head>
		
		<body>
			<?php
			include "config.inc.php";
			$query="select zone_id,zone_title from zones";
		     $result=mysql_query($query, $db);		 
			 	?>
		<form name='control'>
		<table summary='main'>
			<tr><td valign='top'>
				<iframe src='listzones.php' width='300px' name="listzones" height="1000px" scrolling='no' frameborder='no'></iframe>
			</td>
			<td valign='top'>
				<div id='editzonepane' style='display:none;'>
				<iframe name='viewzone'  id='viewzone' scrolling='auto' width='600' height='auto' frameborder='no' src='blank.php'></iframe>
				<!-- postalcode-->
				<iframe name='viewpostalcode'  id='viewpostalcode'   height="300" scrolling='auto' frameborder='no' src='blank.php'></iframe>			
			  <!-- console iframe-->
			   <iframe name='console'  id='console'  style='display:none;'  height="300" scrolling='auto' frameborder='no' src='blank.php'></iframe>
			</div>
			</td></tr>
		</table>
		
		</body>
		
		