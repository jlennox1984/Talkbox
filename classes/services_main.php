<?php
  include'functions.php';
  $sd = new sd();
  $sd->auth();

  ?>
<html>
	<head>
		<title></title>
		<?php $sd->show_simple_header();?>
</head>

	<body>
		<h1>Services</h1>
		<hr>
			<table>
				<tr>
					<td>
							<a href="#" onclick="loadiframeserv('addnewservice.php');"> New Service</a>
					</td>
				</tr>
		</table>
		<table summary="panel" height='1000%' width="100%">
		<!-- Left pane-->		<tr height="600" valign='top'><td valign='top' width='20%'> <div id='data1'><?php $sd->get_services_list_header(); $sd->get_services_list(); $sd->endtbl(); ?></div>
		<!--Right pane-->
		</td> <td width='300%' height='300%'> <iframe frameborder='no' id='viewservice' name='viewservice' src='blank.php' width='100%' height='300%'></iframe></td>

		</tr>
		<tr>
		</tr>


		</table>
	</body>

</html>
