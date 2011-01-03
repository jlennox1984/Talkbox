<?php error_reporting (E_ALL ^ E_NOTICE);
include("config.inc.php"); // Includes the db and form info.
include('functions.php'); 
$sd=new sd();
session_start(); // Starts the session.

if ($_SESSION['logged'] == 1) { // User is already logged in.
	header("Location:index2.php"); // Goes to main page.
	exit(); // Stops the rest of the script.
} else {
	if (!isset($_POST['submit'])) { // The form has not been submitted.
		echo "<head>";
		echo "<link href='../css/servicedesk.css' rel='stylesheet' media='screen' type='text/css'>";
		echo "</head>";
		echo "<h1> Login</h1><hr><p class='login'> Please enter your username and password to login to  Service Desk</p>";
		echo "<form action=\"login.php\" method=\"POST\">";
		echo "<table>";
		echo "<tr>";
		echo "</tr>";
		echo "<tr>";
		echo "<td width=\"50%\"><p class='login'> Username:</td><td width=\"50%\"><input name=\"username\" size=\"18\" type=\"text\" />";
		echo "</tr>";
		echo "<tr>";
		echo "<td width=\"50%\"><p class='login'> Password:</td><td width=\"50%\"><input name=\"password\" size=\"18\" type=\"text\" />";
		echo "</tr>";
		echo "<tr>";
		echo "<td colspan=\"2\"><input type=\"submit\" name=\"submit\" value=\"submit\"</td>";
		echo "</tr>";
		echo "</table>";
		echo "</form>";
	} else {
		$username = $sd->form_data($_POST['username']);
		$password = md5($_POST['password']); // Encrypts the password.
 
		$q = mysql_query("SELECT * FROM `sd_user` WHERE username = '$username' AND password = '$password'") or die (mysql_error()); // mySQL query
		$r = mysql_num_rows($q); // Checks to see if anything is in the db. 
 
		if ($r == 1) { // There is something in the db. The username/password match up.
			$_SESSION['logged'] = 1; // Sets the session.
			header("Location: index2.php"); // Goes to main page.
			exit(); // Stops the rest of the script.
		} else { // Invalid username/password.
			exit("Incorrect username/password!"); // Stops the script with an error message.
		}
	}
}
?>