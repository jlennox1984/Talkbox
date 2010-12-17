<?php
include 'functions.php';
$sd= new sd();
$sd->auth();
?>
<html>
	<head>
		<title> List Postal code</title>
		<?php $sd->show_simple_header();?>
		
		</head>
		<body>
			<?php
			
			$zid=$_REQUEST['zid'];
			
			include "config.inc.php";
			$query="select postalcode_id from postalcodes where zone_id=$zid" ;
		     $result=mysql_query($query, $db);		 
			 	?>
		
		<h1>Postal Codes</h1>
		<div id='ctlpanel' style="float:right;font-family:Times New Roman,Times,serif;font-size:9px;"> <a href="addpostalcode.php?zid=<?php echo $zid;?>">Add Postalcode</a></div>
		<table name="postal codes" summary="Postal code"> 
				<?php
			$count=mysql_num_rows($result);
			$i='0';
			while ($i < $count){
		
			$postal_prefix=mysql_result($result,$i,"postalcode_id");
				
				echo ("<tr> <td> ".$postal_prefix. " </td><td> <a href='postalcode_delete.php?prefix=$postal_prefix&zid=$zid'>Delete</td> </tr>" );
				
			
			$i++;
			}
			$sql2="select zone_title from zones where zone_id=$zid";
			$result1=mysql_query($sql2,$db);
			$zone_title=mysql_result($result1,0,"zone_title");
				
		
			?>
			
		</table>
		</body>
		
		