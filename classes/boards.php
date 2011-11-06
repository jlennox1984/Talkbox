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
	 <div id="container">

		<div class="actions">
		<h3>Actions</h3>
		<ul>
		<li><a href="addboard.php">New Board</a></li>
		</ul>
	</div>
		<h2>Boards</h2>
	<div id="content">

	<?php
		$tb->showboardindex();
	?>
	</div>
	</div>
	</body>
</html>
