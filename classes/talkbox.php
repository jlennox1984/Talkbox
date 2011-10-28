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
<h2>
Phases
<?php
$tb->showphases(); 
$tb->volctl();
?>

<hr>
<form name="Talkbox" method="post" action="">
<input name="tts1"  id="tts1" value="" >
<script type="text/javascript">
	new AutoComplete('tts1', 'assets/ac.php?s=', {
		delay: 0.25
	});
</script>

<input type="button" onclick="loadvoicebox();"  value="TALK">
<iframe id='voiceframe'/>
<div id="slider"></div>
</body>

</html>









