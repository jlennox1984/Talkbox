<?php
/*Service Desk
 * Copyright Moncrieff Web Design Studios (2009) GPL
 *User manager
 * Author-> Jeffrey Dean Moncrieff
 */
 include 'functions.php';
 $sd=new sd();
$sd->auth();

global $db;
$user_id=$_REQUEST['id'];
//DELETE USER RECORD//
$sql="DELETE FROM sd_user WHERE user_id=$user_id";
$result=mysql_query($sql,$db);
//header("location:javascript(reloaduserman('usermanager_list'))");
?>
<html>
	<head>
		<script type='text/javascript'>
			function reloadlist(){
				parent.window.frames['manwindow'].reload;
			}
			</script>
			<title></title>
			</head>
			
			<body onload='reloadlist();'></body>
</html>
<?php
header("location:blank.php");
?>