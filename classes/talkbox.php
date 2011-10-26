<?php
include "functions.php";
$tb= new talkbox();
?>
<html>
<head>
<title> </title>
	<link rel="stylesheet" type="text/css" href="cake/css/cake.generic.css" />
	<link rel="stylesheet" type="text/css" href="css/talkbox.css" />
	 <link rel="stylesheet" type="text/css" href="jqueryui/css/smoothness/jquery-ui-1.7.2.custom.css">	
	<script type="text/javascript" src="../js/talkbox.js"></script>
	
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
<input type="button" onclick="loadvoicebox();"  value="TALK">
<iframe id='voiceframe'/>
<div id="slider"></div>
</body>

</html>









