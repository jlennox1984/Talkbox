<?php
  include 'functions.php';
	 $sd= new sd();
	 	$agent_id=$_REQUEST['id'];
	     //$agent_id='3'; //test varable
		 
		 $sd->auth();
	
?>
<html><head>
	<?php $sd->show_simple_header();?>
	</head>
	<body>
		<div class="control_panel"> |<a href='agency_edit.php?agent_id=<?php echo $agent_id?>'> |Edit</a>| 
		|<a href='agency_delete.php?agency_id=<?php echo $agent_id?>'> Delete|</a> 
		<b> Language|</b> <a href='#' onclick='show_eng();'>English</a>|
		<a href='#' onclick='show_fr();'>French</a>

		</div>
		 <div id="eng_edit" style="display:inline; border:1px">
		<table name="title and pictre">
		<tr>
			<td valign='top'>
				<h3 class='agency'><?php $sd->get_agency_name($agent_id); ?></h3></td>
				
				</td>
				
		</table>
		<table summary='main' class='agencydesc'>
		<tr><td><div class="agency_address"><?php $sd->get_agency_address_block($agent_id);?><hr> </div></td>
		<td>		
		<?php $sd->get_agency_image($agent_id);?>
	</td>
				
		</tr>
		<tr><td><div><?php $sd->get_agency_desc_block($agent_id);?></div></td></tr>
		</table> <table>
		<tr valign='top'><td><div class="agency_list"><h3> services</h3><ul>
	 	<?php $sd->get_agency_services_list($agent_id);?></ul></p>
		</td> <td align='left'> <iframe name='langprops'  frameborder='no' src='blank.php' width='200' height='400'></iframe></td> <td>
				<td>
				
						<h3>Regions</h3><ul>
			<?php $sd->get_agency_zone_list($agent_id)?></ul>
		</tr>
		</td>
	</table>
		</div>
		<div id="fr_edit" style="display:none;  border:1px;">
			<h3 class='agency'><?php $sd->get_agency_name_fr($agent_id); ?></h3>
		<table summary='main' class='agencydesc'>
		<tr><td><div class="agency_address"><?php $sd->get_agency_address_block_fr($agent_id);?><hr></div></td>
		<td>		
		<?php $sd->get_agency_image($agent_id);?>
	</td>
		<tr><td><div><?php $sd->get_agency_desc_block_fr($agent_id);?></div>
		</table><table>
		<tr valign='top'><td><div class="agency_list"><h3> services</h3><ul>
	 	<?php $sd->get_agency_services_list_fr($agent_id);?></ul></p></div>
		</td>			<td>
								<h3>Regions</h3><ul>
			<?php $sd->get_agency_zone_list_fr($agent_id)?></ul></div>
		</div>
		</tr>
		</table>		
		</div>
		
	</body>
	
</html>
