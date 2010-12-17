<?php
include("config.inc.php"); // Includes the db and form info.
session_destroy(); // end  the session.
if ($_SESSION['logged'] != 1) { // There was no session found!
	header("Location: login.php"); // Goes to login page.
	exit(); // Stops the rest of the script.
}