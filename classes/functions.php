<?php
require 'config.inc.php';


class talkbox{

function talkboxheader(){
		$header='<link rel="stylesheet" type="text/css" href="cake/css/cake.generic.css" />
        <link rel="stylesheet" type="text/css" href="css/talkbox.css" />
         <link rel="stylesheet" type="text/css" href="jqueryui/css/smoothness/jquery-ui-1.7.2.custom.css">      
        <script type="text/javascript" src="../js/talkbox.js"></script>
	<script type="text/javascript" src="../js/prototype/prototype.js"></script> 
                <script type="text/javascript" src="../js/scriptaculous/scriptaculous.js"></script> 
                <script type="text/javascript" src="../js/AutoComplete.js"></script> 
                <link rel="stylesheet" type="text/css" href="assets/style.css"></link> 
        
';
print $header;
}
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
     print "<td><a href='#' onclick=sayit('{$row['id']}')>{$row['phases']}</a></td>'\r\n";
     if($i%$cols == $cols -1)echo "</tr>\r\n";
$i++;
}

if($i%2){echo "<td>&nbsp;</td><td>&nbsp;</td>";}
echo "</tr></table>";
}
function showhistory(){ 
        global  $DBI;
	$mode='history';
        $sql="SELECT phase,id FROM history";
        $result = pg_query($DBI, $sql) or die("Error in query: $query." . pg_last_error($connection));
        $cols=6;
if(pg_num_rows($result)==0){
     die('No results returned!');
}

echo "<table border='0'>";
$i = 0;//indexing variable

while($row = pg_fetch_array($result)){
     if($i%$cols == 0)echo "<tr>\r\n";
     print "<td><a href='#'  onclick=sayit('{$row['id']}',$mode)>{$row['phase']}</a></td>\r\n";
     if($i%$cols == $cols -1)echo "</tr>\r\n";
$i++;
}

if($i%2){echo "<td>&nbsp;</td><td>&nbsp;</td>";}
echo "</tr></table>";
$this->getphases('history');

}


	function showpict(){
	global  $DBI;
	$mode='main';
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
     print " <td><table border='0'><tr><td> <img src=\"".$path_pics."/".$row['filename']."\"  onclick=sayit('{$row['id']},\'main'/)>
		<tr><td><a href='#'  onclick=sayit('{$row['id']}','$mode')>{$row['phases']}</a></td></table>
			</td>\r\n";
     if($i%$cols == $cols -1)
	echo "</tr>\r\n";
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
 function getphases($type){
	 
 	global  $DBI;
	$sql;
	//print "Mode $type\r\n";
       if($type=='main'){

	 $sql="SELECT id, phases,filename ,paraphase FROM phases";	
     }
	elseif($type=='history'){
	$sql="SELECT id,phase AS phases FROM history";
	}
	   $result = pg_query($DBI, $sql) or die("Error in query: $query." . pg_last_error($connection));
        $rows= pg_num_rows($result);
        pg_close($DBI);	

        //        $row=pg_fetch_row($result,$i);
                


        //for($i=0; $i<$rows; $i++){        
		
             while($row=pg_fetch_array($result)){

	       $phase=$row['phases'];

       	if($type=='main'){
			$paraphase=$row['paraphase'];	
			 	if($paraphase ==''){
       				  $verb=$phase;
			        }else{
      				  $verb=$row['paraphase'];

		}

	}elseif($type=='history'){
		$paraphase='';
		$verb=$phase;
}
		
        $verb;
  
     	
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
	$this->getphases('main');
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
 
print "<h2> Volume: $vol</h2>";
echo "<table><tr>";
 	for ($i=1; $i <=10;$i++){
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
