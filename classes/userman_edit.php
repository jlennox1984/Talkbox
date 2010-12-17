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
$usid=$_REQUEST['id'];
 	$sql="SELECT username,email,firstname,lastname,tel FROM sd_user WHERE user_id=$usid";
	//echo $sql;
	$result=mysql_query($sql,$db);
		$username=mysql_result($result,0,'username');
		$email=mysql_result($result,0,'email');
		$firstname=mysql_result($result,0,'firstname');
		$lastname=mysql_result($result,0,'lastname');
		$tel=mysql_result($result,0,'tel');
 ?>
 <html>
 	<head>
 		<?php $sd->show_simple_header();?>
		
				
 	</head>
	<body>
		<h1>Edit user for <?php echo $firstname ,$lastname?></h1>
<hr>
<form name='edituser' action='userman_update.php' method='post'>
	<input type='hidden' name='type' value='edit'>
	<input type='hidden' name='userid' value='<?php echo $usid?>'>
	<table>
		<tr><td>
			User Name:</td>
			<td><input type='text' name='username' value="<?php echo $username?>"></td>
			<td>First name</td><td><input type='text' name='firstname' value="<?php echo $firstname;?>"></td>
		</tr>
		<tr>
			<td>
				Last Name:</td> <td><input type='text' name='lastname' value="<?php echo $lastname;?>"></td>
			<td>
				Telephone#:</td> <td><input type='text' name='tel' value="<?php echo $tel;?>"></td>

		</tr>
		<tr>
			<td>
				<a href="#"  onclick='changepass(); return false;'> Change Password</a>
		</td>
		<td> Email:</td><td> <input type='text' name='email' value='<?php echo $email; ?>'></td>
		</tr>
		</table>
					<div id='passwd' style='display:none'></td></tr>
		<table>
						<tr><td>
							Password:</td><td><input type='text' name='pass' value=""></td></tr>
			</table>
					
		</div>
		</td>
		</tr>
		
		<tr>
			<td>
				<input type='submit'>
		</td>
		</tr>
			</table>
</form>
</body>
</html>