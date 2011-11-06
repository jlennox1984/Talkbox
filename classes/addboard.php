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
	<h2> New Board</h2>
         <div id="container">
		<form method='post' action='saveborad.php'>
		<h3> Name:</h3> <input type='text' name='boardname'>
			<input type='submit'>

