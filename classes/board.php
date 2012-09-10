<?php
include "functions.php";
$tb= new talkbox();
$board=$_REQUEST['bid'];
$name=$tb->getbroardname($board);

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
<?php if($board !=20){
	echo '<div ALIGN="right" STYLE="color: #00000000; margin-right: 3cm; "><a href="#" onclick="return popitup(\'board.php?bid=20\');"> VERBS</a> </div>
';
}
?>
<?php
$recallmode=$tb->getconfig('recall');
print "\n Recallmnode->$recallmode";

<input type='hidden' name='recall' value='`>
 
<h2> <?php echo $name?> </h2>

<?php


$tb->showphases($board); 
$tb->volctl();
?>
<!--<a href=# onclick='storyboaron();'> Story borad on </a> -->
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









