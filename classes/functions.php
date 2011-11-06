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
	function showword($bid){
	global  $DBI;
	$sql="SELECT phases,id FROM phases WHERE boards_id='$bid'";
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
        $sql="SELECT phase,id,type FROM history";
        $result = pg_query($DBI, $sql) or die("Error in query: $query." . pg_last_error($connection));
        $cols=6;
if(pg_num_rows($result)==0){
     die('No results returned!');
}

echo "<table border='0'>";
$i = 0;//indexing variable

while($row = pg_fetch_array($result)){
		$mode=$row['type'];
		$id=$row['id'];
	     if($i%$cols == 0)echo "<tr>\r\n";
	     print "<td><table><tr><td>\r\n
			<a href='#'  onclick=sayit('$id',$mode)>{$row['phase']}</a></td>\r\n
				</tr>
				";
			
				if($mode=='tts'){
					print"<tr><td class='msgcommon' id='$id'> <a href='#' onclick='savephase($id);'>Save phase as common Phase</a>
						 </td></tr>";
						}
				print "</table> ";
     if($i%$cols == $cols -1)echo "</tr>\r\n";
$i++;
}

if($i%2){echo "<td>&nbsp;</td><td>&nbsp;</td>";}
echo "</tr></table>";
$this->getphases('history');

}

function savephase($hid){
//hid=history id


	global $DBI;
	$sql="SELECT  phase FROM history where history.id=$hid";
	 $result = pg_query($DBI, $sql) or die("Error in query: $query." . pg_last_error($connection));
		while($row = pg_fetch_array($result)){
			$phase=$row['phase'];
			$date=date('Y-m-d H:i:s');
			//INSERT IN TO MAIN PHASES//
			$SQL="INSERT INTO phases(phases,modified,created) VALUES('$phase','$date','$date')";
			 $result = pg_query($DBI, $SQL) or die("Error in query: $SQL." . pg_last_error($DBI));
			//UPDATE MODE IN HISTORY//
			$SQL="UPDATE history SET type='main' where id='$hid'";
			 $result = pg_query($DBI, $SQL) or die("Error in query: $SQL." . pg_last_error($DBI));

 	}			
}




	function showpict($bid){
	global  $DBI;
	$mode='main';
	 $path_pics="../pics";
        $sql="SELECT id,phases,paraphase,filename FROM phases WHERE boards_id='$bid'";
        $result = pg_query($DBI, $sql) or die("Error in query: $query." . pg_last_error($connection));
	// echo $sql;
	       $cols=6;
	if(pg_num_rows($result)==0){
    	 die('No results returned!');
}

echo "<table>";
$i = 0;//indexing variable
 //GET $path_pics
	$path_pics=$this->getconfig(path_pics);
//$path_pics="http://demo.mwds.ca/talkbox/pics/";
while($row = pg_fetch_array($result)){
     if($i%$cols == 0)echo "<tr>\r\n";
     print " <td><table border='0'><tr><td> <img src=\"".$path_pics."/".$row['filename']."\" width='125px' height='76px' onclick=sayit('{$row['id']},\'main'/)>
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
 function getphases($type,$bid){
	 
 	global  $DBI;
	$sql;
	//print "Mode $type\r\n";
       if($type=='main'||$type=='tts'){

		 $sql="SELECT id, phases,filename ,paraphase FROM phases WHERE boards_id='$bid'";	
     }
	elseif($type=='history'){
		$sql="SELECT id,phase AS phases FROM history";
	}
	//	echo $sql;
	   $result = pg_query($DBI, $sql) or die("Error in query: $query." . pg_last_error($connection));
        $rows= pg_num_rows($result);
        pg_close($DBI);	

        //        $row=pg_fetch_row($result,$i);
                


        //for($i=0; $i<$rows; $i++){        
		
             while($row=pg_fetch_array($result)){

	       $phase=$row['phases'];

       	if($type=='main'||$type=='tts'){
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
 
	function showphases($bid){
        global $cfg_level;
	
        if($cfg_level==0){
        $this->showword($bid);	
        }
        elseif($cfg_level==1){
        $this->showpict($bid);
	$this->getphases('main',$bid);
		}
	}
	
	function storehisory($phase,$mode){
	global $DBI;
	$TS=date('Y-m-d H:i:s');
	if($phase !=''){
	$SQL="INSERT INTO history (phase,time,type) VALUES ('$phase','$TS','$mode')";
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

        function showboardindex(){
        global  $DBI;
        $sql="SELECT name,id FROM boards";
        $result = pg_query($DBI, $sql) or die("Error in query: $query." . pg_last_error($connection));
        $cols=6;
if(pg_num_rows($result)==0){
     die('No results returned!');
}
	print "<table border='0'><tr><th> Borad </th><th> Delete </th><th> Edit </th>";
$i = 0;//indexing variable
	
while($row = pg_fetch_array($result)){
     if($i%$cols == 0)echo "<tr>\r\n";
    	 print "<td>{$row['name']} </td> <td> <a href='deleteboard.php?bid={$row['id']}'> Delete <a/>  </td>
			<td> <a href='editborad.php?bid={$row['id']}'> Edit</a>\r\n";
    	 if($i%$cols == $cols -1)echo "</tr>\r\n";
	$i++;
}

	if($i%2){echo "<td>&nbsp;</td><td>&nbsp;</td>";}
	echo "</tr></table>";
	}

}

?>
