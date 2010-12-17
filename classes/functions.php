<?php
require 'config.inc.php';


class talkbox{

	function showphases(){
	global  $DBI;
	$sql="SELECT phases FROM phases";
	$result = pg_query($DBI, $sql) or die("Error in query: $query." . pg_last_error($connection));
	$rows= pg_num_rows($result);
	pg_close($DBI);
	echo "<table>";
			
	if ($rows > 0){
		
	for($i=0; $i<$rows; $i++){	
		$row=pg_fetch_row($result,$i);
	
		print "<tr><td>"; 
		print $row[0];
		print "</td><td>SAY IT </td>";
		}
		print "</table>|";
			}else
			{
			print "<h2> There are no phases stored</h2>";
		}
	
	}	

}
