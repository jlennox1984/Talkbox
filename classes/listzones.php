<?php
  include 'functions.php';
  $sd=new sd();
  $sd->auth();
  ?>
  
<html>
	<head>
		<title> List zones</title>
		
		
		<script type="text/javascript" src="../../js/main.js"></script>
		<?php $sd->show_simple_header();?>
		</head>
		
		<body>
			<?php
			include "config.inc.php";
			$query="select zone_id,zone_title from zones";
		     $result=mysql_query($query, $db);		 
			 	?>
				<div id='ctlpanel' style="float:right;font-family:Times New Roman,Times,serif;font-size:9px;"> <a href="addzone.php">Add New Zone</a></div>

		<form name='control'>
		<table summary='main'>
			<tr><td valign='top'>
		<table name="zones"  width='74px' summary="zones"> 
		<tr>		<td class='data'> Zone Number</td>
			<td class='data'>Zone region</td>
			<td class='data'>Controls</td>
			<td class='data'>Delete</td>
		</tr>
		
		
			<?php
			$count=mysql_num_rows($result);
			$i='0';
			while ($i < $count){
		
			$zone_title=mysql_result($result,$i,"zone_title");
			$zone_id=mysql_result($result,$i,"zone_id");
				echo ("<tr><td class='data'> ".$zone_id. " <td class='data'>" .$zone_title. "</td> <td class='data'> <a href='#' onclick='editzonewindow($zone_id)'> edit</a></td><td class='data'><a href='deletezone.php?zid=$zone_id'>Delete</a></tr>");
			$i++;
			}
			?>
			</table>
			</td>
</html>
