i<?php
require 'config.inc.php';


class talkbox{


	function showword(){
	global  $DBI;
	$sql="SELECT phases,filename FROM phases";
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
	

	function showpict(){
	global  $DBI;
        $sql="SELECT phases,filename FROM phases";
        $result = pg_query($DBI, $sql) or die("Error in query: $query." . pg_last_error($connection));
        $rows= pg_num_rows($result);
//	$rows=$items;
        print "<table name='picts'>";
	echo "items->$rows";
	if ($rows > 0){
		for ($i=0; $i<$rows; $i++){
		$row=$pg_fetch_row($result,$i);
		
		
	//	print "<td><a img src=".$path_picts."/".$row[1]." name=".$row[0]." ></td>";
			
		}	

	}	
	}


        function showphases(){
        global $cfg_level;
        if($cfg_level==0){
        $this->showword();
        }
        elseif($cfg_level==1){
        $this->showpict();
        }
}

}
