<?php

include 'functions.php';
 $talkbox= new talkbox();

#include 'config.inc.php';

?>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<HTML>
<head>


	<title>MWDS talkbox Alpha 1.0</title>
   <link href='../css/servicedesk.css' rel='stylesheet' media='screen' type='text/css'>
	<link rel="stylesheet" href="css/demos.css" media="screen" type="text/css">
	<style type="text/css">
	/* CSS for the demo. CSS needed for the scripts are loaded dynamically by the scripts */
	h1{
		margin-top:0px;
	}
	#northContent{
		background-color:#c4dcfb;
		border-left :0px;
    height: 40px
	}
	#menuBarContainer{
		width:100%;
	}
	h3{
		margin-top:30px;
	}
	.DHTMLSuite_paneContent .paneContentInner p{	/* A div inside .DHTMLSuite_paneContent. Add styling to it in case you want some padding */
		margin-top:0px;
	}
	html,body{
		width:100%;
		height:100%;
		margin:0px;
		padding:0px;
		font:7px;
		
	}
	
	#by_dhtmlgoodies{
		position:absolute;
		right:10px;
		top:2px;
	}
	#by_dhtmlgoodies img{
		border:0px;
	}
  //new css//
  div.splash_header{
  font-family:"Times New Roman", Times, serif;
	font-size:9px;
}
span.gmap_logo{
  float:right;
  padding:25px,25px,25px,25px;
  font-family:Times New Roman,Times,serif;
font-size:9px;
font-color:#6f6868;
height:35px;

} 
div.header_splash{
 font-family:Times New Roman,Times,serif;
font-size:9px;
font-color:#6f6868;
}
span.gmap_logo_header{
float:right;
font-family:Times New Roman,Times,serif;
font-size:9px;
font-color:#6f6868;
height:35px;
}
img{
border:0px;
}
</style>
<link rel="stylesheet" type="text/css" href="cake/css/cake.generic.css" />
<script type="text/javascript" src="../js/ajax.js"></script>
	<script type="text/javascript">
	var DHTML_SUITE_THEME = 'blue';	// SPecifying gray theme
	</script>
	<script type="text/javascript" src="../js/dhtml-suite-for-applications-without-comments.js"></script>
	<script type="text/javascript" src="../js/dtree.js"></script>
	<script type="text/javascript" src="../js/servicedesk.js"></script>
		<script type="text/javascript" src="../js/talkbox.js"></script>

</head>
<?php
// Include the class for tts
include 'tts/googleTTSphp.class.php';


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
//$ds->setJqueryLocation('Path to jquery file...')
//$ds->setJplayerLocation('Path to  jplayer plugin for jquery file...')
//$ds->setJqueryHotkeyLocation('Path to hotkey plugin for jquery file...')

// This is a method in GoogleTTSHTML wich adds tracks to help user go to next,previous tracks.
//$ds->helpSoundAtStart();



// setInput can contain array, string and a htmlwebpage (use file_get_contents('http://blahblah.com') forexample).
// This input will get readup to the user when visiting the page.
if(isset($_POST["tts1"])){
	$tts1= $_POST["tts1"];
	$ds->setInput(array($tts1));
}else{
	$tts1="";
	$ds->setInput(array("Welcome to Talk Box"));
}
/*		$ds->setInput(array("
	 PHP  is a widely-used general-purpose scripting language that is especially suited for Web development and can be embedded into HTML.
	 If you are new to PHP and want to get some idea of how it works, try the introductory tutorial. After that, check out the online manual,
	 and the example archive sites and some of the other resources available in the links section.
	 Ever wondered how popular PHP is? see the Netcraft Survey.
	", "Thank you for using Google Text To Speech library."));
*/



// Example readup of a whole html page. True must come as seccond arguement since this is html.
#$ds->setInput(file_get_contents('http://phpro.org/'),true);




// Downloads the Mp3, If the text is large,
// NOTE! the first time it will take some time before they are downloaded and page is ready. When done, they will not need to be downloaded and page will load fast.
$ds->downloadMP3();
	?>
	<?php echo $ds->getCoreScriptIncludes() /* Only include one time, even if you have many class instances... */?>
<?php echo $ds->getJavaScript() /* Gets javascript for this instance ($ds here...) */?>
</head>

<body>
<!-- START DATASOURCES FOR THE PANES -->
<div id="westContent">
	<!-- Added by J.Moncrieff for Slienceit November 23,2009 -->	 

<div class="dtree">

	<p><a href="javascript: d.openAll();">open all</a> | <a href="javascript: d.closeAll();">close all</a></p>

	<script type="text/javascript">
		

	d = new dTree('d');
 
        d.add(0,-1,'Service Desk 1.0');
<?php
//require 'config.inc.php';/* Variables from my database include file */
	// Node(id, pid, name, url, title, target, isopen, img ,target) 
		
		$constr="dbname=speachbox  user=root  password=5373988";
		$DBI =pg_connect($constr);
		$query = "SELECT orderno, parentid, title, name,url,img,pane FROM folders";
		$result = pg_exec($DBI,$query) or die ("Fail Query");
		while ($row = pg_fetch_array($result)) {
		extract($row);
		echo("
	     d.add($orderno,$parentid,'$name','$url','$title','$img','$pane','$pane');
	");
}
pg_close();
?>
       
    
	    document.write(d);
		//-->
		

	</script>
</div>
</div>

<div id="northContent">
<div id="logo">
	<img src="../images/mwds_logo.png" height="20px" id="MWDS Logo" alt="MWDS Logo">
<div style="float:right;font-family:Times New Roman,Times,serif;font-size:9px;"><a href='logout.php'>Logout</a></div>

<!-- <div id="menuBarContainer"><div id="innerDiv"></div><div id="rightDiv"></div></div></div>-->
<div id="center">
<table border="0" width="100%" height='80' summary="logo"> 
    <tr> 
        <td> 
        	<img src="images/mwds_logo.png" width="207" height='80'  alt="logo"> 
		

</tr> 
</table> 
<center><h2>  Welcome Talk BOX</h2></center>
<hr>

	<h3> please select say it on the left menu for para Phases</h3>
	
	<div align="center"> 
	        <p> please select say it on the left menu for para Phases</p>
	</div> 
  <hr>
  <div class='header_splash'>
  &copy; Moncrieff Web Design Studios ,(2009) (GPL)
  
  </div>

</div>
<!--
<div id="center3">
	<p>Below, you can see some of the methods available for the pane splitter widget:</p>
	<ul>
		<li><a href="#" onclick='paneSplitter.addContent("west", new DHTMLSuite.paneSplitterContentModel( { id:"newWestPane",htmlElementId:"center5",contentUrl:"includes/article3.html",refreshAfterSeconds:10,title:"Center pane 4",tabTitle: "From server 2",closable:true } ) );paneSplitter.showContent("newWestPane")'>Add some external content to the west pane</a> - <b>Methods: addContent and showContent</b></li>
		<li><a href="#" onclick='paneSplitter.reloadContent("newWestPane");return false'>Reload content </a> ( The content you added to the west pane - first link - <b>Method: reloadContent</b>) </li>
	</ul>
	<ul>
		<li><a href="#" onclick='if(!paneSplitter.isUrlLoadedInPane("eastContent2","includes/article2.html"))paneSplitter.loadContent("eastContent2","includes/article2.html",15);paneSplitter.showContent("eastContent2");return false'>Load content </a> ( refreshes it's self after 15 seconds - <b>Methods: loadContent and showContent</b> )</li>
		<li><a href="#" onclick='paneSplitter.setRefreshAfterSeconds("eastContent2",0);paneSplitter.showContent("eastContent2");return false'>Clear refresh rate </a> ( for the content added by the link above - <b>Method: setRefreshAfterSeconds</b> )</a></li>
	</ul>
	<ul>
		<li><a href="#" onclick='paneSplitter.deleteContentById("eastContent2");return false'>Delete </a> (content with id "eastContent2" - <b>Method: deleteContentById</b>)</li>
		<li><a href="#" onclick='paneSplitter.deleteContentByIndex("east",0);return false'>Delete by index </a> (First content in east pane - <b>Method: deleteContentByIndex</b>)</li>
	</ul>
	<ul>
		<li><a href="#" onclick="paneSplitter.hidePane('west');return false">Hide west pane</a></li>
		<li><a href="#" onclick="paneSplitter.showPane('west');return false">Show west pane</a></li>
	</ul>
	<ul>
		<li><a href="#" onclick="paneSplitter.hidePane('east');return false">Hide east pane</a></li>
		<li><a href="#" onclick="paneSplitter.showPane('east');return false">Show east pane</a></li>
	</ul>
	<ul>
		<li><a href="#" onclick="paneSplitter.hidePane('south');return false">Hide south pane</a></li>
		<li><a href="#" onclick="paneSplitter.showPane('south');return false">Show south pane</a></li>
	</ul>
	<ul>
		<li><a href="#" onclick="paneSplitter.hidePane('north');return false">Hide north pane</a></li>
		<li><a href="#" onclick="paneSplitter.showPane('north');return false">Show north pane</a></li>
	</ul>
	<ul>
		<li><a href="#" onclick="paneSplitter.setContentTabTitle('eastContent','New tab title');return false">New tab title of east pane</a> (the setContentTabTitle method)</li>
		<li><a href="#" onclick="paneSplitter.setContentTitle('eastContent','New title');return false">New title in heading - east pane</a> ( the setContentTitle method)</li>
	</ul>
	<ul>
		<li><a href="#" onclick="paneSplitter.closeAllClosableTabs('center');return false">Close all closable tabs in the center pane</a> (the closeAllClosableTabs method)</li>
		<li><a href="#" onclick="paneSplitter.collapsePane('west');return false">Collapse west pane</li>
		<li><a href="#" onclick="paneSplitter.expandPane('west');return false">Expand west pane</li>
	</ul>
	<p>For more info, please see this <a href="#" onclick="openPage('center','tutPaneSplitter','includes/tutorial-paneSplitter.inc','Tutorial - Pane splitter','Pane splitter tutorial');return false">Tutorial</a> or the
	class documentation.</p>
</div>
-->
<div id="southContent"> 
<center><p>Talk BOX</p></center>
<hr>

<form name="Talkbox" method="post" action="<?php $_SERVER['self']?>">
<input name="tts1" value="<?php echo $tts1?>">
<input type="submit" name="submit" value="TALK">
</form>
<?php echo $ds->getPlayerDiv() /*Only include one time, even if you have many class instances. This div is needed and can be included anywhere on your page. */ ?>
</div>

<!-- END DATASOURCES -->
<script type="text/javascript">

/* STEP 1 */
/* Create the data model for the panes */
var paneModel = new DHTMLSuite.paneSplitterModel( { collapseButtonsInTitleBars:true } );
DHTMLSuite.commonObj.setCssCacheStatus(false)
var paneWest = new DHTMLSuite.paneSplitterPaneModel( { position : "west", id:"westPane",size:200,minSize:100,maxSize:300,scrollbars:true,callbackOnCollapse:'callbackFunction',callbackOnExpand:'callbackFunction',callbackOnShow:'callbackFunction',callbackOnHide:'callbackFunction',callbackOnSlideIn:'callbackFunction',callbackOnSlideOut:'callbackFunction',callbackOnResize:'callBackFunctionResizePane' } );
paneWest.addContent( new DHTMLSuite.paneSplitterContentModel( { id:"westContent",htmlElementId:'westContent',title:'Navgation Menu',tabTitle:'Menu' } ) );

//var paneEast = new DHTMLSuite.paneSplitterPaneModel( { position : "east", id:"eastPane",size:150,minSize:100,maxSize:200,callbackOnCollapse:'callbackFunction',callbackOnCloseContent:'callbackFunction',callbackOnBeforeCloseContent:'validateCloseContent' } );
//paneEast.addContent( new DHTMLSuite.paneSplitterContentModel( { id:"eastContent",htmlElementId:'eastContent',title:'East',tabTitle: 'Tab 1' } ) );


var paneSouth = new DHTMLSuite.paneSplitterPaneModel( { position : "south", id:"southPane",size:200,minSize:50,maxSize:400,scrollbars:true,resizable:true,callbackOnCollapse:'callbackFunction' } );
paneSouth.addContent( new DHTMLSuite.paneSplitterContentModel( { id:"southContent",htmlElementId:'southContent',title:' ', tabTitle:'Home',closable:false} ) );

var paneNorth = new DHTMLSuite.paneSplitterPaneModel( { position : "north", id:"northPane",size:40,scrollbars:false,resizable:false } );
paneNorth.addContent( new DHTMLSuite.paneSplitterContentModel( { id:"northContent",htmlElementId:'northContent',title:'' } ) );

var paneCenter = new DHTMLSuite.paneSplitterPaneModel( { position : "center", id:"centerPane",size:150,minSize:100,maxSize:200,callbackOnCloseContent:'callbackFunction',callbackOnTabSwitch:'callbackFunction' } );
paneCenter.addContent( new DHTMLSuite.paneSplitterContentModel( { id: 'center',htmlElementId:'center',title:'Welcome',tabTitle: 'Welcome',closable:false } ) );
//paneCenter.addContent( new DHTMLSuite.paneSplitterContentModel( { id:'center3', htmlElementId:'center3',title:'center pane',tabTitle: 'Pane splitter' } ) );


paneModel.addPane(paneSouth);
//paneModel.addPane(paneEast);
paneModel.addPane(paneNorth);
paneModel.addPane(paneWest);
paneModel.addPane(paneCenter);



/* STEP 2 */
/* Create the pane object */
var paneSplitter = new DHTMLSuite.paneSplitter();
paneSplitter.addModel(paneModel);	// Add the data model to the pane splitter
paneSplitter.init();	// Add the data model to the pane splitter

/* callbackOnBeforeCloseContent call back function for the east pane */
function validateCloseContent(modelObj,action,contentObj)
{
	var confirmMessage = 'Click OK to verify that you want to close pane';
	if(contentObj)confirmMessage = confirmMessage + ' ' + contentObj.title;
	confirmMessage = confirmMessage +' ?';
	confirmMessage= confirmMessage + '\n\nThis is a custom function defined to be a callback for the event\ncallbackOnBeforeCloseContent';
	return confirm(confirmMessage);
}

// This function opens a new tab - called by the menu items
function openPage(position,id,contentUrl,title,tabTitle,closable,onCompleteJsCode)
{
	var inputArray = new Array();
	inputArray['id'] = id;
	inputArray['position'] = position;
	inputArray['contentUrl'] = contentUrl;
	inputArray['title'] = title;
	inputArray['tabTitle'] = tabTitle;
	inputArray['closable'] = closable;
	// if(inputArray['position']=='center')inputArray['displayRefreshButton'] = true;
	if(!paneSplitter.addContent(position, new DHTMLSuite.paneSplitterContentModel( inputArray ),onCompleteJsCode )){
	};
	paneSplitter.showContent(id);

}
/* This is a demo for a call back function for the panes */
function callbackFunction(modelObj,action,contentObj)
{
	self.status = 'Event "' + action + '" triggered for pane with id "' + modelObj.id + (contentObj?'" - content id: ' + contentObj.id:'');
}


function callBackFunctionResizePane(modelObj,action,contentObj)
{
	var size = paneSplitter.getSizeOfPaneInPixels(modelObj.getPosition());
	self.status = 'Pane ' + modelObj.getPosition() + ' has been resized to ' + size.width + ' x ' + size.height + ' pixels';
}

function openClassDocumentation()
{
	var docWin = window.open('../doc/js_docs_out/index.html');
	docWin.focus();

}
function helpwin()
{
	newwindow = window.open('/help/', 'name', 'height=400,width=400 , scrollbars=yes ,status=yes ,resizable=yes  ');
	if (window.focus) {
		newwindow.focus()
	}
	
}
</script>
<!--
<ul id="menuModel" style="display:none">
	
	<li id="50002"><a href="#">Documentation</a>
		<ul width="150">
			
					<li id="500022"><a href="#" onclick='javascript:helpwin()'>help</a></li>
			
	</li>
</ul>

 This is the datasource for menu items which are added dynamically to the menu

<script type="text/javascript">


	var menuModel = new DHTMLSuite.menuModel();


	menuModel.addItemsFromMarkup('menuModel');
	menuModel.setMainMenuGroupWidth(00);
	menuModel.init();

	var menuBar = new DHTMLSuite.menuBar();
	menuBar.addMenuItems(menuModel);


	menuBar.setTarget('innerDiv');

	menuBar.init();

	DHTMLSuite.configObj.resetCssPath();
</script> -->

<script type="text/javascript">
// This is only for the demo in ordre to display different colors for the different themes //

var bgColor = '#c4dcfb';	// Default blue color
if(DHTML_SUITE_THEME=='gray')bgColor='#d8d8d8';
document.getElementById('northContent').style.backgroundColor=bgColor;
if(document.all)DHTMLSuite.commonObj.correctPng('dhtmlSuiteLogo');
</script>

</script>
</body>
</html>
