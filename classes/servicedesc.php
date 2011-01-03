<?php
  include'functions.php';
  $sd=new sd();
    $sd->auth();
	$sid=$_REQUEST['id'];
	?>
	<html>
	<?php $sd->show_simple_header();?>
	<body>
		<table>
		<tr><td>	
	</td>	</tr>
		</table>
		<h1><?php $sd->get_service_name($sid);?></h1>
		<hr>
		Description
		<br>
		<?php $sd->get_service_desc($sid)?>
		
	</body>
	</html>
	