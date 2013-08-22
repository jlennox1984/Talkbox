<?php
include "../config.inc.php";
require "../functions.php";
$tb= new talkbox();

header("Content-Type:audio/mpeg");
header("Server:translation");

// define the temporary directory
// and where audio files will be written to after conversion
global $tmpdir;
$serverroot = $_SERVER['DOCUMENT_ROOT'];
global $audiodir;
//REQUESTS ADDED BY JEFF
//$LANG=$_REQUEST['lang'];
$LANG="en";
$speech_raw=trim($_REQUEST['q']);
$md5=$_REQUEST['md5'];
 print "output $speech_raw";
 $_POST["make_audio"]=true;

$save_mp3=true;
$audioweb=true;
// if the Text-To-Speech button was click, process the data

if (isset($audioweb)) {
/**
if(isset($speech)){  
	$volume_scale = 50;
  	$save_mp3 = true;
	$show_audio = true;
	$_POST["make_audio"]=true;
print "Processed";
*/

//$speech = stripslashes(trim($_POST["speech"]));
$save_mp3=true;
$speech =stripslashes(trim($speech_raw));  
$speech = substr($speech, 0, 1024);
 // $volume_scale = intval($_POST["volume_scale"]);
  	// Moded 022811
//	$volume_scale=50;
	$vol=$tb->getconfig('vol');
	$volume_scale=$vol*10; 
 if ($volume_scale <= 0) { $volume_scale = 1; }
  if ($volume_scale > 100) { $volume_scale = 100; }
//  if (intval($_POST["save_mp3"]) == 1) { $save_mp3 = true; }

  // continue only if some text was entered for conversion
  if ($speech != "") {
    // current date (year, month, day, hours, mins, secs)
    $currentdate = date("ymdhis",time());
    // get micro seconds (discard seconds)
    list($usecs,$secs) = microtime();
    // unique file name
    $filename = "{$currentdate}{$usecs}";
    // other file names
    $speech_file = "{$tmpdir}/{$filename}";
    $wave_file = "{$audiodir}/{$filename}.wav";
    $mp3_file  = "{$audiodir}/{$filename}.mp3";

    // open the temp file for writing
    $fh = fopen($speech_file, "w+");
    if ($fh) {
      fwrite($fh, $speech);
      fclose($fh);
    }
	
    // if the speech file exists, use text2wave
   if (file_exists($speech_file)) {
      // create the text2wave command and execute it
   $voice=$tb->getconfig('voice');
        error_log("our voice is $voice");
        if($voice==''){
              $voice='voice_kal_diphone'; // default festival voice
        }  
 $text2wave_cmd = sprintf("text2wave -o %s -scale %d %s -eval '({$voice})'",$wave_file,$volume_scale,$speech_file);
	
    error_log($text2wave_cmd);
      exec($text2wave_cmd);

      // create an MP3 version?
      
        // create the lame command and execute it
      //$filenameNEW= 'mp3_tts/'.md5(trim(strtoupper($speech_raw)))."$voice.mp3";
      error_log("TXT Processer raw string->" .$speech_raw);
      //$filename= md5(trim(strtoupper($speech_raw)))."$voice.mp3";
      error_log("Txt Processer md5->".$md5);
      $filenameNEW=$audiodir. '/'.$md5;
        $lame_cmd = sprintf("lame --bitwidth 32 %s %s",$wave_file,$filenameNEW);
       error_log($lame_cmd);
	exec($lame_cmd);
        // delete the WAV file to conserve space
	  unlink($wave_file);
           
      // delete the temp speech file
      unlink($speech_file);

      // which file name and     public function setLang($l){type to use? WAV or MP3
      $listen_file = (($save_mp3 == true) ? basename($mp3_file) : basename($wave_file));
      $file_type = (($save_mp3 == true) ? "MP3" : "WAV");

      // show audio file link
      $show_audio = true;
    }
  }
} else {
  // default values
  $speech = "Hello there!";
  $volume_scale = $tb->getconfig('vol');
  $save_mp3 = true;
}
header("Content-Type: audio/mpeg");
header( "Content-Disposition: attachment; filename=".basename($filenameNEW));
header( "Content-Description: File Transfer");
@readfile($filenameNEW);
?>
