<?php
include 'config.inc.php';
$debug=0;
global $DBI;
// get name
$name=addslashes($_REQUEST['boardname']);
//time Stampe
$TS=date('Y-m-d H:i:s');
	// gets last folder id
 	$sql= "SELECT folderid FROM folders ORDER BY folderid DESC";
	$result = pg_query($DBI, $sql) or die("Error in query: $query." . pg_last_error($connection));
	$lastfid=pg_fetch_result($result,0,0);
	$NEWFID=$lastfid +1;
		//INSERT BOARD//
		$sql= "INSERT INTO boards (name,fid,created,modified) values ('$name','$NEWFID','$TS','$TS')";
		$result = pg_query($DBI, $sql) or die("Error in query: $sql." . pg_last_error($connection));

		//GET BORAD ID OF INSERT
		$sql= "SELECT id FROM boards ORDER BY id DESC";
        	$result = pg_query($DBI, $sql) or die("Error in query: $query." . pg_last_error($connection));
	        $boardid=pg_fetch_result($result,0,0);
		// GET LAST ORDER 
		$sql= "SELECT folders.orderno FROM folders WHERE folders.parentid='4' ORDER BY folders.orderno DESC";
        $result = pg_query($DBI, $sql) or die("Error in query: $query." . pg_last_error($connection));
        $orderno=pg_fetch_result($result,0,0);
	$NEWorderno=$order +1;
	
		//INSERT FOLDER//
		$sql= "INSERT INTO folders (orderno,parentid,name,title,url,pane) values(
		'$NEWorderno','7','$name','$name','./wrapperboard.php?bid=$boardid','center')";
		$result = pg_query($DBI, $sql) or die("Error in query: $sql." . pg_last_error($connection));
		
		if($debug==1){
	echo 'name=' .$name;
	echo "last folder id=".$lastfid;
	echo "new Folder id =".$NEWFID;
	echo "time stamp= " .$TS;
	echo "Borard ID= " .$boardid;	
	echo "SQL EQ \r\n" .$sql;
	}else
	header("location:boards.php");
?>
	
