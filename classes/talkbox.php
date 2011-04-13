<?php
include "functions.php";
$tb= new talkbox();
?>
<html>
<head>
<title> </title>
	<link rel="stylesheet" type="text/css" href="cake/css/cake.generic.css" />
	<script type="text/javascript" src="../js/talkbox.js"></script>

</head>

<body>
<h2>
Phases
<?php
$tb->showphases(); 
?>
<hr>
<form name="Talkbox" method="post" action="">
<input name="tts1"  id="tts1" value="" >
<input type="button" onclick="loadvoicebox();"  value="TALK">
<iframe id='voiceframe'/>
</body>

</html>









