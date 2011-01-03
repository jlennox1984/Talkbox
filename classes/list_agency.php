<?php
  include 'functions.php';
   $sd= new sd();  
?>
<html>
	<head>
		<script type="text/javascript" src="../js/ajax.js"></script> 
	<script type="text/javascript"> 
	var DHTML_SUITE_THEME = 'blue';	// SPecifying gray theme
	</script> 
	<script type="text/javascript" src="../js/dhtml-suite-for-applications-without-comments.js"></script> 

<script type="text/javascript" src="../js/servicedesk.js"></script>
	</head>
	<body>
		<table summary="Main">
			<tr><td class="listpane">
				<?php
				//Agency table//
					$sd->get_agency_list_header();
					$sd->get_agency_list();
					$sd->endtbl();
				?>