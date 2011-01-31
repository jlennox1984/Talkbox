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
	 $path_pics="../pics";
        $sql="SELECT id,phases,filename FROM phases";
        $result = pg_query($DBI, $sql) or die("Error in query: $query." . pg_last_error($connection));
       $cols=3;
	if(pg_num_rows($result)==0){
    	 die('No results returned!');
}

echo "<table>";
$i = 0;//indexing variable
$path_pics="http://devel.mwds.info/talkbox2/pics";
while($row = pg_fetch_array($result)){
     if($i%$cols == 0)echo "<tr>\r\n";
     echo " <td><table border=2><tr><td> <img src=\"".$path_pics."/".$row['filename']."\"  onclick=sayit('{$row['id']}')>
		<tr><td><a href='#' onclick=sayit('{$row['id']}')>{$row['phases']}</a></td></table>
			</td>\r\n";
     if($i%$cols == $cols -1)echo "</tr>\r\n";
$i++;
}

if($i%2){echo "<td>&nbsp;</td><td>&nbsp;</td>";}
print "</tr></table>\r\n";

}
 function getphases(){
	 
 	global  $DBI;
        $sql="SELECT id, phases,filename FROM phases";	
        $result = pg_query($DBI, $sql) or die("Error in query: $query." . pg_last_error($connection));
        $rows= pg_num_rows($result);
        pg_close($DBI);	

        //        $row=pg_fetch_row($result,$i);
                


        //for($i=0; $i<$rows; $i++){        
		
             while($row=pg_fetch_array($result)){

		
                print "<input type='hidden' class='phases' id='{$row[0]}' value='{$row['1']}' />\r\n";
	
	}
}
 
	function showphases(){
        global $cfg_level;
	
        if($cfg_level==0){
        $this->showword();
        }
        elseif($cfg_level==1){
        $this->showpict();
	$this->getphases();
		}
	}
}
