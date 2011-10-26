<?php
require 'config.inc.php';


class talkbox{


	function showword(){
	global  $DBI;
	$sql="SELECT phases,id FROM phases";
	$result = pg_query($DBI, $sql) or die("Error in query: $query." . pg_last_error($connection));
	$cols=6;
if(pg_num_rows($result)==0){
     die('No results returned!');
}

echo "<table border='0'>";
$i = 0;//indexing variable

while($row = pg_fetch_array($result)){
     if($i%$cols == 0)echo "<tr>\r\n";
     echo "<td><a href='#' onclick=sayit('{$row['id']}')>{$row['phases']}</a></td>";
     if($i%$cols == $cols -1)echo "</tr>\r\n";
$i++;
}

if($i%2){echo "<td>&nbsp;</td><td>&nbsp;</td>";}
echo "</tr></table>";
}
	function showpict(){
	global  $DBI;
	 $path_pics="../pics";
        $sql="SELECT id,phases,paraphase,filename FROM phases";
        $result = pg_query($DBI, $sql) or die("Error in query: $query." . pg_last_error($connection));
       $cols=6;
	if(pg_num_rows($result)==0){
    	 die('No results returned!');
}

echo "<table>";
$i = 0;//indexing variable
$path_pics="http://demo.mwds.ca/talkbox/pics/";
while($row = pg_fetch_array($result)){
     if($i%$cols == 0)echo "<tr>\r\n";
     echo " <td><table border='0'><tr><td> <img src=\"".$path_pics."/".$row['filename']."\"  onclick=sayit('{$row['id']}')>
		<tr><td><a href='#' onclick=sayit('{$row['id']}')>{$row['phases']}</a></td></table>
			</td>\r\n";
     if($i%$cols == $cols -1)echo "</tr>\r\n";
$i++;
}

if($i%2){echo "<td>&nbsp;</td><td>&nbsp;</td>";}
print "</tr></table>\r\n";

}
function getconfig($key){
	global $DBI;
	$SQL="SELECT value FROM config where key='$key'";
	$result = pg_query($DBI, $SQL) or die("Error in query: $query." . pg_last_error($connection));
		while($row=pg_fetch_array($result)){
	
			$value=$row['value'];
}
return $value;
}

function updateconfig($key,$value){
 global $DBI;
	$SQL="UPDATE config SET value = $value WHERE key='$key'";
	 $result = pg_query($DBI, $SQL) or die("Error in query: $SQL." . pg_last_error($DBI));

}
 function getphases(){
	 
 	global  $DBI;
        $sql="SELECT id, phases,filename ,paraphase FROM phases";	
        $result = pg_query($DBI, $sql) or die("Error in query: $query." . pg_last_error($connection));
        $rows= pg_num_rows($result);
        pg_close($DBI);	

        //        $row=pg_fetch_row($result,$i);
                


        //for($i=0; $i<$rows; $i++){        
		
             while($row=pg_fetch_array($result)){

	       $phase=$row['phases'];
        $paraphase=$row['paraphase'];

        $verb;
        if($paraphase !=''){
         $verb=$paraphase;
        }else{
        $verb=$phase;
}
     	
                print "<input type='hidden' class='phases' id='{$row[0]}' value='{$verb}' />\r\n";
	
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
	
	function storehisory($phase){
	global $DBI;
	$TS=date('Y-m-d H:i:s');
	if($phase !=''){
	$SQL="INSERT INTO history (phase,time) VALUES ('$phase','$TS')";
	 $result = pg_query($DBI, $SQL) or die("Error in query: $SQL." . pg_last_error($DBI));
}
	}
function volctl(){

$i=1;
//Get vol key
$vol=0;
$vol=$this->getconfig('vol');
 
echo "<h1>Volume Control level $vol</h1>";
echo "<table><tr>";
 	for ($i=1; $i <=11;$i++){
	echo "<td>";
		$val=$i*10;
		if($vol==$i){	
			echo " $val <input type='radio' name='volctl' value='$val'  onclick='savevol($i)' checked> </td>";
		}else{
			 echo " $val <input type='radio' name='volctl' value='$val'   onclick='savevol($i)'> </td>";
		}
		
	}
	echo "</tr></table>";
	

}
}
