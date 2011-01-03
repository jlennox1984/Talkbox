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
global $debug;
//GET INPUTS
$type=$_REQUEST['type'];
$username=$_REQUEST['username'];
$firstname=$_REQUEST['firstname'];
$lastname=$_REQUEST['lastname'];
$tel=$_REQUEST['tel'];
$passwd=$_REQUEST['pass'];
$email=$_REQUEST['email'];
// RUN SOME CHECKS 
if($type=='new'){
	$sql="INSERT INTO sd_user (username,firstname,lastname,tel,email,password) VALUES('$username','$firstname','$lastname','$tel','$email',sha1('$passwd'))";
	$result=mysql_query($sql,$db);
	if($debug=='1'){
		echo '<br>',$sql,'<br>';
	 	
	}
	if($debug=='0'){
		$userid_next=$sd->mysql_next_id('sd_user');
		$userid=$userid_next-1;
		//echo 'the user:',$userid;
		header("location:userman_edit.php?id=$userid");
	}
}

if($type=='edit'){
$userid=$_REQUEST['userid'];

//DO UPDATE ROUTINE EXCULDING PASSWORD
$sql="UPDATE sd_user SET";
$sql.=" username ='$username',";
$sql.="firstname='$firstname',";
$sql.="lastname='$lastname',";
$sql.="tel='$tel'";
$sql.=" where user_id=$userid";
$result=mysql_query($sql,$db);

 
	if($debug=='1'){
		echo '<br>',$sql,'<br>';
	}
	//CHANGE PASSWORD//

if($passwd  !=''){
	$sql="UPDATE  sd_user  SET password=MD5('$passwd') where user_id=$userid";
	$result=mysql_query($sql,$db);
	if($debug=='1'){
		echo '<br> SET PASSWORD QUERY<br>',$sql,'<br>';
	}
}

//Header

if($debug=='0'){
	header("location:userman_edit.php?id=$userid");
	
}

}

 ?> 
<html>
	<head>
		<?php $sd->show_simple_header();?>
		
	</head>
	<body onload="reloadusermanager('usermanager_list.php');"></body>
</html>
 