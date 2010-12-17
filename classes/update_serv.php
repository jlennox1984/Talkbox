<?php
/*Service Desk
 * Copyright Moncrieff Web Design Studios (2009) GPL
 *Save Routine for Zones's
 * Author-> Jeffrey Dean Moncrieff
 */
header("Content-type: text/html; charset=utf-8");

  include 'functions.php';
  $sd=new sd();
    $sd->auth();
	$sid=$_REQUEST['id'];
	$serice_name_raw=$_REQUEST['service'];
	$service_desc_raw=$_REQUEST['desc_en'];
	$service_name_fr_raw=$_REQUEST['service_fr'];
	$service_desc_fr_raw=$_REQUEST['desc_fr'];
	$type=$_REQUEST['type'];
	$logo=$_FILE['image'];

	///Clean
	$serice_name=addslashes($serice_name_raw);
	$service_desc=addslashes($service_desc_raw);
	$service_name_fr=addslashes($service_name_fr_raw);
	$service_desc_fr=addslashes($service_desc_fr_raw);

	//IF NEW SERVICE//
	  if($type=='new'){
	   $sql="INSERT INTO services(service)VALUES('$service_name')";
	   $result=mysql_query($sql,$db);
	   $sid=mysql_insert_id($db);
	   };

if($type=='edit'){
  $sid=$_POST['id'];//SERVICE  ID
  }

	$sql="UPDATE services SET service='$serice_name',description='$service_desc',service_fr='$service_name_fr',description_fr='$service_desc_fr' where service_id=$sid";
	$result=mysql_query($sql,$db);
//	echo $sql;

//UPLOAD New Image
	
$target_path_serv = $target_path_serv . basename( $_FILES['logo']['name']);

if(move_uploaded_file($_FILES['logo']['tmp_name'], $target_path)) {
    echo "The file ".  basename( $_FILES['logo']['name']).
    " has been uploaded";
} else{
    echo "There was an error uploading the file, please try again!";
}
	if($logo !=''){
		$sql="UPDATE services SET images='$logo' where service_id=$sid";
		$result=mysql_query($sql,$db);
	}

	header("location:viewservice.php?id=$sid");
	?>


