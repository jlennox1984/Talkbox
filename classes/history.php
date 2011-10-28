<?php
include "functions.php";
$tb= new talkbox();
?>
<html>
<head>
<title> </title>
        <?php
        // Show scripts 
        $tb->talkboxheader();
?>
        
</head>

<body>
	<center>
		 <H3> History</H3>
	</center>
	<hr>

	<?php
		$tb->volctl();
		$tb->showhistory();
	?>
<iframe id='voiceframe'/>
<div id="slider"></div>

</body>
</html>
