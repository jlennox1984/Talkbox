<?php
$url=$_REQUEST['url'];
//$id=$_REQUEST[id];

?>
<html>
<head>
	<title> Test</title>

</head>
	<body>
		the url is: <?php echo $url;?>
		<div id="test">
		<?php echo $url?>
			<iframe width="100%" height="700" scrolling="auto" src="<?php echo $url?>"></iframe>
		</div>
	</body>
</html>
