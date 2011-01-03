<?php
/*Service Desk
 * Copyright Moncrieff Web Design Studios (2009) GPL
 *User Manager List
 * Author-> Jeffrey Dean Moncrieff
 */
include 'functions.php';
 $sd=new sd();
 $sd->auth();
 $sd->show_simple_header();
  ?>
 
 <html>
 	<head>
 		</head>
		<body>
			<table>
				<tr>
					<td>
						<a href='#' onclick="usermanwin('userman_new.php');"> New User</a>
											</td>
				</tr>
			</table>
			<?php $sd->userlist_manager();?>
			
			
	</body>	
</html>
			
