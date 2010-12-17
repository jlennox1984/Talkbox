
<html>
	<head>
		<title> List zones</title>
		
		
		<script type="text/javascript" src="../../js/main.js"></script>
		
		</head>
		
		<body>
			<?php
			include "../config.inc.php";
			$query="select zone_id,zone_title from zones";
		     $result=mysql_query($query, $db);		 
			 	?>
		<form name='control'>
		
		<table name="zones" summary="zones"> 
		<tr>		<td> Zone Number</td>
			<td>Zone region</td>
			<td>Controls</td>
			<td>Delete</td>
		</tr>
		
		
			<?php
			$count=mysql_num_rows($result);
			$i='0';
			while ($i < $count){
		
			$zone_title=mysql_result($result,$i,"zone_title");
			$zone_id=mysql_result($result,$i,"zone_id");
				
				echo (" <tr> <td> ".$zone_id. " <td>" .$zone_title. "</td> <td><a href=\"#\" 
				onclick=\"paneSplitter.addContent('south', new DHTMLSuite.paneSplitterContentModel( { id:'Editzone".$i."',htmlElementId:'south".$i."',contentUrl:'editzone.php?zid=".$zone_id."',title:'editzone',tabTitle:'Edit zone $zone_title' ,closable:true } ) );paneSplitter.showContent('Editzone".$i."')
				paneSplitter.addContent('east', new DHTMLSuite.paneSplitterContentModel( { id:'postalzone".$i."',htmlElementId:'east".$i."',contentUrl:'posalcodes.php?zid=".$zone_id."',title:'postal codes',tabTitle:'Edit Postal zone $zone_title' ,closable:true } ) );paneSplitter.showContent('postalzone".$i."')
				\"> Edit</a></td>  <td> <input type='radio' value='del_$zone_id'></form></td> </tr>" );
				
			
			$i++;
			}
			?>
			
		</table>
		
		</body>
		
		