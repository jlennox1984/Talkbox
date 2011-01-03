<?php
//include("config.inc.php"); // Includes the db and form info.
session_start();
session_unset(); // Destroys the session.
session_destroy();

	header("Location: ../login.php"); // Goes to login page..

?>