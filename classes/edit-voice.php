<?php
include "functions.php";
$tb= new talkbox();
$voice=$tb->getconfig('voice');

?>
<html>
<head>

        

<title> </title>
        <script type="text/javascript" src="../js/talkbox.js"></script>
        
</head>

<body text="#00000">

        <div id="header1" style="float:left; text-align: right; color: red;" > Voice-> </div>
 <div id="voicestatus" style="float: left; text-align: right; color: #1B8EE0;"><?php print $voice ?></div>
<br>
	<h1 style="float: left; text-align: left;" text="#00000"> Change voice <hr>
       

 <select id="voice" onchange="editvoice(this.value)">
	<?php
		exec(" ls /usr/share/festival/voices/english/ ", $output);

      			foreach ($output as &$tmp){
				print "<option value=\"$tmp\"> $tmp </option>\n";
			}
	?>
</h1>
	</body>
	</html>		 
