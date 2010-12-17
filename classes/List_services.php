
<html>
<body>
			<?php
			include "config.inc.php";
			$query="select service_id,service,description from services";
		     $result=mysql_query($query, $db);		 
			 	?>
		
		<h1>Services</h1>
				<form name='control'>
		<table id="main" summary='main'>
			<tr><td>
						<table name="Services" summary="Services"> 
		<tr>
		<td>Service</td>
		<td> Description</td>
		<td> Controls
		<br>Edit/Delete</td>
		</tr>
		

			<?php
			$count=mysql_num_rows($result);
			$i='0';
			while ($i < $count){
		
			$service_id=mysql_result($result, $i,"service_id");
			$service=mysql_result($result,$i,"service");
			$serv_desc=mysql_result($result, $i,"description");
			
				echo ("<tr> <td class='data'> ".$service. " <td class='data'>" .$serv_desc. "</td> <td class='controls'><a href=\"#\" 
				onclick=\"paneSplitter.addContent('south', new DHTMLSuite.paneSplitterContentModel( { id:'Editserv".$i."',htmlElementId:'south".$i."',contentUrl:'editservice.php?servid=".$service_id."',title:'Edit Service',tabTitle:'Edit Service $service' ,closable:true } ) );paneSplitter.showContent('Editserv".$i."');
				paneSplitter.addContent('east', new DHTMLSuite.paneSplitterContentModel( { id:'Agencies".$i."',htmlElementId:'east".$i."',contentUrl:'agency_lookup.php?sid=".$service_id."',title:'Edit Agencies  relationships',tabTitle:'Edit Agencies  relationships ' ,closable:true } ) );paneSplitter.showContent('Agencies".$i."')
				\"> Edit</a></td>  <td> <input type='radio' value='del_$service_id'></form></td> </tr>" );
				
			
			$i++;
			}
			?>
			
		</table>
		</td>
			</tr>
			</table>
			</form>
		</body>
		
		
