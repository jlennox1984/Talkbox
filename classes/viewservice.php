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
		<tr><td>	<a href="editservice.php?id=<?php echo $sid?>">Edit</a>
	</td>
	<td>	<a href="deleteservice.php?id=<?php echo $sid?>">Delete</a>
	</td>
	<td><b> Language</b></td>
	<td><a href='#' onclick='show_eng();'>English</a></td>
	<td><a href='#' onclick='show_fr();'>French</a></td>
	</tr>
	
		</table>
	 <div id="eng_edit" style="display:inline; border:1px">	
	<table width='100%'>	
	<tr>
		<td>
			<h1><?php $sd->get_service_name($sid);?></h1>
		</td>
		<td align='left'>
			<br>
			<?php $sd->get_service_image($sid)?>
			
		</td>
	</table>
		
		<hr>
		Description
		<br>
		<?php $sd->get_service_desc($sid)?>
</div>
	<div id="fr_edit" style="display:none; border:1px;">
		<table width='100%'>
		<tr>
			<td>
				<h1><?php $sd->get_service_name_fr($sid);?></h1>
				</td>
				<td align='left'>
					<br>
			<?php $sd->get_service_image($sid)?>
			
					
				</td>
		</table>
		
		<hr>
		Description
		<br>
		
		<?php $sd->get_service_desc_fr($sid)?>
		</div>
		
	</body>
	</html>

