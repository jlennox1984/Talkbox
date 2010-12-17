<?php
/*
 *   Example file, this is how you use it in your main application!
 *
 *   Copyright (C) <2010>  Petter Kjelkenes <kjelkenes@gmail.com>
 *   Website HTTP://PKJ.NO
 *
 */

// Include the class
include 'googleTTSphp.class.php';


// Start the HTML instance, this provides features such as javascript implementions and functions already configured. You may also use GoogleTTS if you do not want html specific features.
$ds = new GoogleTTSHTML;

// Set the path to where mp3s will get cached / stored.
$ds->setStorageFolder('mp3_tts/');


// Set language.
$ds->setLang('en'); // Not needed, because en is default.

// We choose to play the sound files automatically when users load the screen.
$ds->setAutoPlay(true);

// You can choose custom paths or modify the location to jquery, jplayer and hotkey.
// if you forexample already included the jquery earlier you set setJqueryLocation('') to empty like that. It will then not include it.
#$ds->setJqueryLocation('Path to jquery file...')
#$ds->setJplayerLocation('Path to  jplayer plugin for jquery file...')
#$ds->setJqueryHotkeyLocation('Path to hotkey plugin for jquery file...')

// This is a method in GoogleTTSHTML wich adds tracks to help user go to next,previous tracks.
$ds->helpSoundAtStart();


// setInput can contain array, string and a htmlwebpage (use file_get_contents('http://blahblah.com') forexample).
// This input will get readup to the user when visiting the page.


$ds->setInput(array("
 PHP  is a widely-used general-purpose scripting language that is especially suited for Web development and can be embedded into HTML.
 If you are new to PHP and want to get some idea of how it works, try the introductory tutorial. After that, check out the online manual,
 and the example archive sites and some of the other resources available in the links section.
 Ever wondered how popular PHP is? see the Netcraft Survey.
", "Thank you for using Google Text To Speech library."));


// Example readup of a whole html page. True must come as seccond arguement since this is html.
#$ds->setInput(file_get_contents('http://phpro.org/'),true);




// Downloads the Mp3, If the text is large,
// NOTE! the first time it will take some time before they are downloaded and page is ready. When done, they will not need to be downloaded and page will load fast.
$ds->downloadMP3();




?>

<html>
<head>
<title>Test, example file!</title>
<?php echo $ds->getCoreScriptIncludes() /* Only include one time, even if you have many class instances... */?>
<?php echo $ds->getJavaScript() /* Gets javascript for this instance ($ds here...) */?>
</head>

<body>
<p>Testing this shit is cool!</p>
<?php echo $ds->getPlayerDiv() /*Only include one time, even if you have many class instances. This div is needed and can be included anywhere on your page. */ ?>
</body>

</html>
