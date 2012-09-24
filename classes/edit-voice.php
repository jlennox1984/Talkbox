<?php
include "functions.php";
$tb= new talkbox();

?>
<html>
<head>

        

<title> </title>
        <script type="text/javascript" src="../js/talkbox.js"></script>
        
</head>

<body text="#00000">


	<h1 text="#00000"> Change voice <hr>
	</h1>
 <select id="voice" onchange="editvoice(this.value)">
	<?php
		exec(" ls /usr/share/festival/voices/english/ ", $output);

      			foreach ($output as &$tmp){
				print "<option value=\"$tmp\"> $tmp </option>\n";
			}
	?>
	</body>
	</html>		 
