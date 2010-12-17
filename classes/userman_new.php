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

 ?> 
 <html>
 	<head>
 		<?php $sd->show_simple_header();?>
		
				
 	</head>
	<body>
		<h1>New User</h1>
<hr>
<form name='edituser' action='userman_update.php' method='post'>
	<input type='hidden' name='type' value='new'>
	<table>
		<tr><td>
			User Name:</td>
			<td><input type='text' name='username' value=""></td>
			<td>First name</td><td><input type='text' name='firstname' value=""></td>
		</tr>
		<tr>
			<td>
				Last Name:</td> <td><input type='text' name='lastname' value=""></td>
			<td>
				Telephone#:</td> <td><input type='text' name='tel' value=""></td>

		</tr>
						<tr><td> Email:</td><td> <input type='text' name='email' value=''></td>
							
							<td>
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