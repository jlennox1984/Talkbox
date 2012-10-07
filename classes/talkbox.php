<?php
include "functions.php";
$tb= new talkbox();
$board=0;
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
<script type="text/javascript">
function init() {
        shortcut.add("Alt+r", function() {
			recallon();
		});

        shortcut.add("Alt+o", function() {
				recalloff();
			});
        
                }
        
        </script>

	
</head>

<body>
<h2>
Phases
<?php
$tb->showphases($board); 
$tb->volctl();
?>

<hr>
<form name="Talkbox" method="post" action="">
<input name="tts1"  id="tts1" value="" onblur="loadvoicebox(0);"/>
<script type="text/javascript">
	new AutoComplete('tts1', 'assets/ac.php?s=', {
		delay: 0.25
	});
</script>

<input type="button" onclick="loadvoicebox();"  value="TALK"/>
<iframe id='voiceframe<?php echo $board?>' class="main"/>
<div id="slider"></div>
</body>

</html>









