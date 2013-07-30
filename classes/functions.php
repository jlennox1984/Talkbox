<?php
require 'config.inc.php';


class talkbox{

function talkboxheader(){
		$header='<link rel="stylesheet" type="text/css" href="cake/css/cake.generic.css" />
        <link rel="stylesheet" type="text/css" href="css/talkbox.css" />
        <link rel="stylesheet" type="text/css" href="jqueryui/css/smoothness/jquery-ui-1.7.2.custom.css">
          <script type="text/javascript" src="../js/talkbox.js"></script>
	<script type="text/javascript" src="../js/ajax.js"></script>
	<script type="text/javascript" src="../js/prototype/prototype.js"></script> 
	        <script type="text/javascript" src="../js/scriptaculous/scriptaculous.js"></script> 
                <script type="text/javascript" src="../js/AutoComplete.js"></script> 
               
		<link rel="stylesheet" type="text/css" href="assets/style.css"></link>	
		<script type="text/javascript">
			var tooltipObj = new DHTMLSuite.dynamicTooltip(); // Create ONE tooltip object.
	</script> 


 
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
     print "<td><a href='#' onclick=sayit('{$row['id']}',$bid')>{$row['phases']}</a></td>'\r\n";
     if($i%$cols == $cols -1)echo "</tr>\r\n";
$i++;
}

if($i%2){echo "<td>&nbsp;</td><td>&nbsp;</td>";}
echo "</tr></table>";
}
function getboardselect($hid,$type){
	global $DBI;
	$SQL="SELECT  id,name FROM boards";
	print "</tr><td> <div id=\"commit$hid\" class=\"commitmsg\"> <select id='item$hid'>\r\n";
	 $result = pg_query($DBI, $SQL) or die("Error in query: $SQL." . pg_last_error($DBI));
	while($row = pg_fetch_array($result)){
		print "<option value='".$row['id']."'> ".$row['name']." </optiom>\n";
	}	
		if($type=='history'){
		print "</td>\r\n <td>  <div id=\"commit$hid\" class=\"commitmsg\">  
		<input  id=\"button$hid\"  type=\"button\"  value=\"COMMIT\" onclick=\"savephase($hid);\">  </button>  
		\r\n </div>
			</td>
		</div>
	</tr> ";
	}elseif($type=="phasewriter"){

                print "</td>\r\n <td>  <div id=\"commit$hid\" class=\"commitmsg\">  
                <input  id=\"button$hid\"  type=\"button\"  value=\"COMMIT\" onclick=\"savephasewriter($hid);\">  </button>  
                \r\n </div>
                        </td>
                </div>
        </tr> ";

	}
}
function showhistory($board){ 
        global  $DBI;
	$mode='history';
        $sql="SELECT phase,id,type FROM history ORDER BY id";
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
			<a href='#'  onclick=sayit('$id','$mode','$board')>{$row['phase']}</a></td>\r\n
				</tr>
				";
			
				if($mode=='tts'){
				// print"<tr><td class='msgcommon' id='$id'> <a href='#' onclick='savephase($id);'>Save phase as common Phase</a>
		$this->getboardselect($id,'history');					
}
				print "</table> ";
     if($i%$cols == $cols -1)echo "</tr>\r\n";
$i++;
}

if($i%2){echo "<td>&nbsp;</td><td>&nbsp;</td>";}
//echo "</tr></table>";
$this->getphases('history');

}
function updateconfig($key,$value){
	global $DBI;
		$SQL="UPDATE config  SET value='$value'  WHERE key='$key'";
		$result = pg_query($DBI, $SQL) or die("Error in query: $SQL." . pg_last_error($DBI));

}
function savephase($hid,$board){
//hid=history id


	global $DBI;
	$sql="SELECT  phase FROM history where history.id=$hid";
	 $result = pg_query($DBI, $sql) or die("Error in query: $query." . pg_last_error($connection));
		while($row = pg_fetch_array($result)){
			$phase=$row['phase'];
			$date=date('Y-m-d H:i:s');
			//INSERT IN TO MAIN PHASES//
			$SQL="INSERT INTO phases(phases,boards_id,modified,created) VALUES('$phase','$board','$date','$date')";
			 $result = pg_query($DBI, $SQL) or die("Error in query: $SQL." . pg_last_error($DBI));
			//UPDATE MODE IN HISTORY//
			$SQL="UPDATE history SET type='main' where id='$hid'";
			 $result = pg_query($DBI, $SQL) or die("Error in query: $SQL." . pg_last_error($DBI));

 	}			
}
function savephasewriter($phase,$board,$series){
	global $DBI;
	 $date=date('Y-m-d H:i:s');
	//INSERT IN TO MAIN PHASES//

		 $SQL="INSERT INTO phases(phases,boards_id,modified,created) VALUES('$phase','$board','$date','$date')";
		$result = pg_query($DBI, $SQL) or die("Error in query: $SQL." . pg_last_error($DBI));
		print "SQL EQ: ".$SQL;
		//UPDATE STATUS
		$SQL="UPDATE storyboard SET status='SAVED' WHERE series='$series' ";
		$result = pg_query($DBI, $SQL) or die("Error in query: $SQL." . pg_last_error($DBI));

}


function recordon(){
global $DBI;
	$SQL="UPDATE config SET value='ON' WHERE key='record'";
	 $result = pg_query($DBI, $SQL) or die("Error in query: $SQL." . pg_last_error($DBI));

}
function recordoff(){
global $DBI;
        $SQL="UPDATE config SET value='OFF' WHERE key='record'";
         $result = pg_query($DBI, $SQL) or die("Error in query: $SQL." . pg_last_error($DBI));
	//RESET ORDER//
	$SQL="UPDATE config SET value='0' WHERE key='recordorder'";
	$result = pg_query($DBI, $SQL) or die("Error in query: $SQL." . pg_last_error($DBI));
        
      }
function recallon(){
	global $DBI;
        $SQL="UPDATE config SET value='ON' WHERE key='recall'";
         $result = pg_query($DBI, $SQL) or die("Error in query: $SQL." . pg_last_error($DBI));

	}

function recalloff(){
	global $DBI;
        $SQL="UPDATE config SET value='OFF' WHERE key='recall";
         $result = pg_query($DBI, $SQL) or die("Error in query: $SQL." . pg_last_error($DBI));

}

function phasewriter($str){
global $DBI;
	//GET VARS//
	$order=$this->getconfig('recordorder');
	$series=$this->getconfig('recordseries');
	$ts=date('Y-m-d H:i:s');
	if($str !=''){
		//SERIES LOGIC 
		$NEWseries;	
			if($order==0){
				$NEWseries=$series+1;
				$this->updateconfig('recordseries',$NEWseries);
		}else{
			$NEWseries=$series;
		}
	
	
			
		$NEWorder=$order+1;
	
		$this->updateconfig('recordorder',$NEWorder);
		//SQL INSERT
		$SQL="INSERT INTO storyboard (orderno,phase,series,time) values('$NEWorder','$str','$NEWseries','$ts')";	
 		$result = pg_query($DBI, $SQL) or die("Error in query: $SQL." . pg_last_error($DBI));
	}
}

	function showpict($bid){
	global  $DBI;
	$mode='main';
	$recmode=$this->getconfig('record');
	$recallmode=$this->getconfig('recall');
	//test Log
		error_log("rec mode->" .$recmode);
		error_log("recall mode->" .$recallmode);

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
	$path_pics=$this->getconfig('path_pics');
	
//$path_pics="http://demo.mwds.ca/talkbox/pics/";
	while($row = pg_fetch_array($result)){
	  if($i%$cols == 0)echo "<tr>\r\n";
	  $link="<a href='#'  onclick=sayit('{$row['id']}','$mode','$bid')>{$row['phases']}";

	  if($row['filename'] !=''){
	    
	    print " <td><table border='0'><tr><td><a href='#'  onclick=sayit('{$row['id']}','$mode','$bid')> <img src=\"".$path_pics."/".$row['filename']."\" width='125px' height='76px' onclick=sayit('{$row['id']},'$mode','$bid')></a>
			<tr><td><a href='#' alt='{$row['paraphase']}'  onclick=sayit('{$row['id']}','$mode','$bid')>{$row['phases']}</a></td></table>
			</td>\r\n";
		} else{
		 print " <td> <table border='0'> <tr><td> <a href='#'  onclick=sayit('{$row['id']}','$mode','$bid')>{$row['phases']}</a></td></tr></table></td>\r\n";
		}

     if($i%$cols == $cols -1)
	echo "</tr>\r\n";
$i++;
}

if($i%2){echo "<td>&nbsp;</td><td>&nbsp;</td>";}
print "</tr></table>\r\n";
	if($recmode=='OFF'){
print "<div id=\"recmods\" align=\"right\" style=\"color: #00000000; font-size: 7px; margin-right: 3cm; \"><a href=\"#\" onclick=\"return recordon();\"> RECORD ON<a> </div>";
          }
	elseif($recmode=='ON'){
	print "<div id=\"recmods\" align=\"right\" style=\"color: #00000000; font-size: 7px; margin-right: 3cm; \"><a href=\"#\" onclick=\"return recordoff();\"> RECORD OFF<a> </div>";
	
 	}
         if($recallmode=='OFF'){
print "<div id=\"recallmods\" align=\"right\" style=\"color: #00000000; font-size: 7px; margin-right: 3cm; \"><a href=\"#\" onclick=\"return recallon();\"> RECALL ON<a> </div>";
          }

        elseif($recallmode=='ON'){
        print "<div id=\"recallmods\" align=\"right\" style=\"color: #00000000; font-size: 7px; margin-right: 3cm; \"><a href=\"#\" onclick=\"return recalloff();\"> RECALL  OFF<a> </div>";
	}

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
function getbroardname($bid){
global $DBI;
	 $SQL="SELECT name FROM boards WHERE id=$bid";
         $result = pg_query($DBI, $SQL) or die("Error in query: $SQL." . pg_last_error($connection));
                 $name=pg_fetch_result($result,0,0);
return $name;
}



 function getphases($type,$bid){
	 
 	global  $DBI;
	$sql;
	//print "Mode $type\r\n";
	print "<div class='output$bid'>";
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
  
     	
                print "<input type='hidden' name='phases' id='{$row[0]}' value='{$verb}' />\r\n";
	
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
	print $SQL;
}
	}
function volctl(){

$i=1;
//Get vol key
$vol=0;
$vol=$this->getconfig('vol');
print "<h2> Volume: <div id=\"volind\"> $vol</div> </h2>";
echo "<table><tr>";
 	for ($i=1; $i <=10;$i++){
	echo "<td>";
		$val=$i*10;
		if($vol==$i){	
			echo " $i <input type='radio' name='volctl' value='$val'  onclick='savevol($i)' checked> </td>";
		}else{
			 echo " $i <input type='radio' name='volctl' value='$val'   onclick='savevol($i)'> </td>";
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

	function showstoryboard(){
	global $DBI;
	$board="33333";	
	//CREATE Table
		 print "
        <table>\b
        <tr><th>phase</th><th>method</th>\n 
        <tr>\n
		";      
		
	//GET SERIES
	$SQL="SELECT  DISTINCT ON (series) series,time,status FROM storyboard";
	$result = pg_query($DBI, $SQL) or die("Error in query: $SQL." . pg_last_error($DBI));
		while($row= pg_fetch_array($result)){
			$seriesno=$row['0'];
			$status=$row['2'];
		//GET PHASES AND BUILD INTO A STRING // 
			$SQL="SELECT phase FROM storyboard WHERE series='$seriesno' ORDER BY orderno ASC";
		//	print $SQL ."\n";
			$result1 = pg_query($DBI, $SQL) or die("Error in query: $SQL." . pg_last_error($DBI));
			$array=pg_fetch_all($result1);
		//	print_r($array); 
			print "
			<tr id=\"row$seriesno\">\n
			<td>"; 
				for($i = 0; $i < count($array); $i++){
				$output= implode(" ", $array[$i]);
			

			print  $output. " ";
			}
				print" </td>\n
			<td> <table> <tr><td>
				<a href='#' onclick=\"sayit('$seriesno','main','$board');\"> replay</a></td></tr>\n
				<tr><td> <a href='#' onclick=\"deletestory('$seriesno');\"> Delete</a></td></tr></table></td><td>\n";
				if($status !='SAVED'){
					$this-> getboardselect($seriesno,'phasewriter');
					}
				print "<t/d>
				</tr>\n
			";}
	
				
			
		 
	}
 function showstoryboardhidden(){
        global $DBI;
        //CREATE Table
            

        //GET SERIES
        $SQL="SELECT  DISTINCT ON (series) series,time FROM storyboard";
        $result = pg_query($DBI, $SQL) or die("Error in query: $SQL." . pg_last_error($DBI));
                while($row= pg_fetch_array($result)){
                        $seriesno=$row['0'];
                //GET PHASES AND BUILD INTO A STRING // 
                        $SQL="SELECT phase FROM storyboard WHERE series='$seriesno' ORDER BY orderno ASC";
                //      print $SQL ."\n";
                        $result1 = pg_query($DBI, $SQL) or die("Error in query: $SQL." . pg_last_error($DBI));
                        $array=pg_fetch_all($result1);
                //      print_r($array);
			print  "\n<input type='hidden' value =\""; 
                                for($i = 0; $i < count($array); $i++){
                                $output= implode(" ", $array[$i]);


                       			 print   $output. " ";
                        	}
			print "\" id=\"$seriesno\">\n";	
 			 }




        }

function deletestoryboard($series){
	global $DBI;
	
		$SQL="DELETE FROM storyboard WHERE series=$series";
		print $SQL;	
	 $result = pg_query($DBI, $SQL) or die("Error in query: $SQL" . pg_last_error($DBI));



	}
}
?>
