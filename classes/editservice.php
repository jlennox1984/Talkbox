<?php
  include'functions.php';
  $sd=new sd();
    $sd->auth();
	$sid=$_REQUEST['id'];
	?>
	<html>
<?php $sd->show_simple_mce_header();?>
<body>
			<div class="control_panel"> <a href='#' onclick='javascript:history.back()'> back</a>
		 <table>
		 	<tr><td> <a href='#' onclick='javascript:show_fr()'> French</a></td>
			<td><a href='#' onclick='javascript:show_eng()'> English</a></td>
			</tr>
		 </table>
		</div>
<hr>
	<form name='service_edit' action='update_serv.php'>
	<table>
		<tr>
			<td>Picture:</td>
			<td><input type='file' name='image'></td>
		</tr>
	</table>


		<div id="eng_edit" style="display:inline; border:1px">
		<input type='hidden' name='id' value="<?php echo $sid;?>">
			<table>	<tr>
			<td>Name of service:</td> <td><input name='service' value="<?php $sd->get_service_name($sid);?>"></td>
		</tr>
		<tr><td colspan='2'> <h3> Description</h3></td></tr>
		<tr><td colspan='2'> <textarea id='elm2' cols='50' rows='7' name='desc_en'><?php $sd->get_service_desc($sid);?></textarea></td></tr>
	</table>
	</div>
		<div id="fr_edit" style="display:none; border:1px">
	<table>


		<td>Nom De service:</td> <td><input name='service_fr' value="<?php $sd->get_service_name_fr($sid);?>"></td>
		</tr>
		<tr><td colspan='2'> <h3> Description</h3></td></tr>
		<tr><td colspan='2'> <textarea id='tinymce_fr' cols='50' rows='7' name='desc_fr'><?php $sd->get_service_desc_fr($sid);?></textarea></td></tr>
		</table>
	</div>
	<table>
		<tr><td><input type='submit' name='submit' value='submit'></td></tr>
		</table>
		</form>
		</html>