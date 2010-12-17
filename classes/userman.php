<?php
/*Service Desk
 * Copyright Moncrieff Web Design Studios (2009) GPL
 *User manager
 * Author-> Jeffrey Dean Moncrieff
 */
 include 'functions.php';
 $sd=new sd();
// $sd->auth();
 ?>
 <html>
 	<head>
 		<?php $sd->show_simple_header();?>
		
				
 	</head>
	<body>
		<h1>User Manager</h1>
<hr>

<table>
<tr>
<td width='35%' valign='top'> 
<iframe name='usermanager_list' frameborder='no'  width='200px' height='700px' src='usermanager_list.php'></iframe>
</td>	
<td>
	<iframe name='usermanager_win' frameborder='no' width='700px' height='700px' src='blank.php'></iframe>
</td>
</tr>	
</table>

	</body>
 </html>
