<?php
include "functions.php";
$tb= new talkbox();
?>

<H1> Not a page just a relay<H1>
<?php
$VOL=$_REQUEST['vol'];
 $tb->updateconfig('vol',$VOL);
?>
