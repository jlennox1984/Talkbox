<?php
require 'config.inc.php';


class talkbox{


	function showword(){
	global  $DBI;
	$sql="SELECT phases FROM phases";
	$result = pg_query($DBI, $sql) or die("Error in query: $query." . pg_last_error($connection));
	$cols=3;
if(pg_num_rows($result)==0){
     die('No results returned!');
}

echo "<table>";
$i = 0;//indexing variable

while($row = pg_fetch_array($result)){
     if($i%$cols == 0)echo "<tr>\r\n";
     echo "<td><a href='#' onclick=sayit('{$row['phases']}')>{$row['phases']}</a></td>";
     if($i%$cols == $cols -1)echo "</tr>\r\n";
$i++;
}

if($i%2){echo "<td>&nbsp;</td><td>&nbsp;</td>";}
echo "</tr></table>";
}
	function showpict(){
	global  $DBI;
	global $path_picts;
        $sql="SELECT phases,filename FROM phases";
        $result = pg_query($DBI, $sql) or die("Error in query: $query." . pg_last_error($connection));
        $rows= pg_num_rows($result);
//	$rows=$items;
        print "<table name='picts'>";
	echo "items->$rows";
	if ($rows > 0){
		for ($i=0; $i<$rows; $i++){
		$row=pg_fetch_row($result,$i);
		
		
		print "<td><a img src='".$path_picts."/".$row[1]."' name='".$row[0]."' alt='".$row[0]."' ></td>";
			
		}	

	}
	print "</table>";
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
