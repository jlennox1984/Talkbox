<?php
include "functions.php";
$tb= new talkbox();
$board=9999;
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
		$tb->showhistory($board);
	?> 
<hr>

<iframe id='voiceframe<?php echo $board?>' class="main"/>

<div id="slider"></div>

</body>
</html>
