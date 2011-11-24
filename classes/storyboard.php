<?php
include "functions.php";
$tb= new talkbox();
//$board=$_REQUEST['bid'];
$name="Storey Board";
$board='33333'
?>
<html>
<head>
<script type="text/javascript">
	var obj;
	var TAB=9;
</script>

<title> </title>
        <?php
	// Show scripts 
	$tb->talkboxheader();
?> 
	
</head>

<body>
<h2> <?php echo $name?> </h2>

<?php


$tb->showstoryboard();
$tb->volctl();
$tb->showstoryboardhidden();
?>
<hr>
<form name="Talkbox" method="post" action="">
<input name="tts1"  id="tts1" value="" onblur="loadvoicebox(<?php echo $board?>);"/>
<script type="text/javascript">
	new AutoComplete('tts1', 'assets/ac.php?s=', {
		delay: 0.25
	});
</script>

<input type="button" onclick="loadvoicebox(<?php echo $board?>);"  value="TALK"/>

<iframe id='voiceframe<?php echo $board?>' class="main"/>

<div id="slider"></div>
</body>

</html>









