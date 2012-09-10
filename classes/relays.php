<?php
include "functions.php";
$tb= new talkbox();

// relays for talkbox

$action=$_REQUEST['action'];
		
		if($action=='vol'){
		$VOL=$_REQUEST['vol'];
		 $tb->updateconfig('vol',$VOL);

		} elseif ($action=='savephase'){
			$hid=$_REQUEST['hid'];
			$board=$_REQUEST['board'];
 			$tb-> savephase($hid,$board);
		}  elseif($action=='recordon'){
			$tb->recordon();
		}elseif ($action=='recordoff'){
			$tb->recordoff();
		}elseif($action=="delstory"){
			$sid=$_REQUEST['sid'];
			$tb->deletestoryboard($sid);
		}elseif($action=='savephasewriter'){
				$phase=$_REQUEST['phase'];
				$board=$_REQUEST['board'];
				$series=$_REQUEST['series'];
				$tb-> savephasewriter($phase,$board,$series);
		}elseif($action=='recallon'){
					
			$tb->updateconfig('recall' ,'ON');
		}elseif($action=='recalloff'){
			$tb->updateconfig('recall','OFF');
		}
?>


