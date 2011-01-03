<?php
include './functions.php';
$sd = new sd();
$sd->auth();
//include("config.inc.php"); // Includes the db and form info.
if (!isset($_POST['submit'])) { // If the form has not been submitted.
	echo "<form action=\"user_reg.php\" method=\"POST\">";
	echo "<table>";
	echo "<tr>";
	echo "<td colspan=\"2\">Register:</td>";
	echo "</tr>";
	echo "<tr>";
	echo "<td width=\"50%\">Username:</td><td width=\"50%\"><input name=\"username\" size=\"18\" type=\"text\" />";
	echo "</tr>";
	echo "<tr>";
	echo "<td width=\"50%\">Password:</td><td width=\"50%\"><input name=\"password\" size=\"18\" type=\"text\" />";
	echo "</tr>";
	echo "<tr>";
	echo "<td width=\"50%\">Email:</td><td width=\"50%\"><input name=\"email\" size=\"18\" type=\"text\" />";
	echo "</tr>";
	echo "<tr>";
	echo "<td colspan=\"2\"><input type=\"submit\" name=\"submit\" value=\"submit\"</td>";
	echo "</tr>";
	echo "</table>";
	echo "</form>";
} else { // The form has been submitted.
	$username = form($_POST['username']);
	$password = md5($_POST['password']); // Encrypts the password.
	$email = form($_POST['email']);
 
	if (($username == "") || ($password == "") || ($email == "")) { // Checks for blanks.
		exit("There was a field missing, please correct the form.");
	}
 
	$q = mysql_query("SELECT * FROM `sd_user` WHERE username = '$username' OR email = '$email'") or die (mysql_error()); // mySQL Query
	$r = mysql_num_rows($q); // Checks to see if anything is in the db.
 
	if ($r > 0) { // If there are users with the same username/email.
		exit("That username/email is already registered!");
	} else {
		mysql_query("INSERT INTO `sd_user` (username,password,email) VALUES ('$username','$password','$email')") or die (mysql_error()); // Inserts the user.
		header("Location: login.php"); // Back to login.
	}
}
mysql_close($db_connect); // Closes the connection.
?>