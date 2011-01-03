<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<HTML>
<HEAD>
	<?
	$keywords = "DHTML Suite for applications,pane splitter,Ajax widget,DHTML framework";
	@include($_SERVER['DOCUMENT_ROOT']."/config/metatags.inc");
	?>	
	<title>DHTML Suite for Applications - Pane Splitter</title>
	<link rel="stylesheet" href="../css/demos.css" media="screen" type="text/css">
	<style type="text/css">
	/* CSS for the demo. CSS needed for the scripts are loaded dynamically by the scripts */
	h1{
		margin-top:0px;
	}
	#northContent{
		background-color:#c4dcfb;
		border-left:0px;
	}
	#menuBarContainer{
		width:99%;
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
	}
	#by_dhtmlgoodies{
		position:absolute;
		right:10px;
		top:2px;	
	}
	#by_dhtmlgoodies img{
		border:0px;
	}
	</style>
<!--	<script type="text/javascript" src="http://www.google.com/jsapi?key=ABQIAAAA7WifngjNQxEXnosdgbAdxRTlAGJwJB3dH7AAB6QZqfA-80E6fhRXQfzlVCW6t-GNbFNENXLv2Ybgcw"></script>-->
	<script type="text/javascript" src="../js/ajax.js"></script>

                     <script type="text/javascript">
			var DHTML_SUITE_THEME = 'blue';	// SPecifying gray theme
	</script>	
	<script type="text/javascript" src="../js/dhtml-suite-for-applications.js"></script>

</head>
<body>
<!-- START DATASOURCES FOR THE PANES -->

	<!-- START DATASOURCES FOR THE PANES -->
<div id="westContent">
	<!-- Added by J.Moncrieff for Slienceit November 23,2009 -->	 

<div class="dtree">
<script type="text/javascript" src="../js/dtree.js"></script>

	<p><a href="javascript: d.openAll();">open all</a> | <a href="javascript: d.closeAll();">close all</a></p>

	<script type="text/javascript">
		<!--
	d = new dTree('d');
        d.add(0,-1,'Your Documents');
<?php
require 'config.inc.php';/* Variables from my database include file */
	// Node(id, pid, name, url, title, target, isopen, img ,target) 
	
		$query = "SELECT orderno, parentid, title, name,url,img,pane FROM folders where type='content' ORDER BY folderid";
		$result = mysql_query($query, $db) or die ("Fail Query");
		while ($row = mysql_fetch_array($result)) {
		extract($row);
		echo("
	     d.add($orderno,$parentid,'$name','$url','$title','$img','$pane','$isopen','$pane');
	");
}

?>
               document.write(d);
		//-->
		
	</script>
 <!--End Modifcation -->

</div>
<div id="northContent">
<div id="logo">
	<img src="demo-images/dhtml-suite-logo.png" id="dhtmlSuiteLogo">
</div>

<div id="menuBarContainer"><div id="innerDiv"></div><div id="rightDiv"></div></div></div>
<div id="center">
	<h2>DHTML Suite for applications</h2>
                JHWW
<div id="southContent">This is the south content</div>
<div id="eastContent">
 <div id="searchwell"></div>

</div>
<div id="eastContent2">I'm also from the east</div>
<!-- END DATASOURCES -->
<script type="text/javascript">
/* STEP 1 */
/* Create the data model for the panes */
var paneModel = new DHTMLSuite.paneSplitterModel();
DHTMLSuite.commonObj.setCssCacheStatus(false)
var paneWest = new DHTMLSuite.paneSplitterPaneModel( { position : "west", id:"westPane",size:200,minSize:100,maxSize:300,scrollbars:true,callbackOnCollapse:'callbackFunction',callbackOnExpand:'callbackFunction',callbackOnShow:'callbackFunction',callbackOnHide:'callbackFunction',callbackOnSlideIn:'callbackFunction',callbackOnSlideOut:'callbackFunction',callbackOnResize:'callBackFunctionResizePane' } );
paneWest.addContent( new DHTMLSuite.paneSplitterContentModel( { id:"westContent",htmlElementId:'westContent',title:'Navagation Menu',tabTitle:'Menu ' } ) );

var paneEast = new DHTMLSuite.paneSplitterPaneModel( { position : "east", id:"eastPane",size:150,minSize:100,maxSize:200,callbackOnCollapse:'callbackFunction',callbackOnCloseContent:'callbackFunction',callbackOnBeforeCloseContent:'validateCloseContent' } );
paneEast.addContent( new DHTMLSuite.paneSplitterContentModel( { id:"eastContent",htmlElementId:'eastContent',title:'Admin Panel',tabTitle: 'Admin Manager' } ) );
paneEast.addContent( new DHTMLSuite.paneSplitterContentModel( { id:"eastContent2",htmlElementId:'eastContent2',title:'East 2',tabTitle:'Tab 2' } ) );



var paneSouth = new DHTMLSuite.paneSplitterPaneModel( { position : "south", id:"southPane", size:260,minSize:50,maxSize:530,resizable:true,callbackOnCollapse:'callbackFunction' } );
paneSouth.addContent( new DHTMLSuite.paneSplitterContentModel( { id:"southContent",tabTitle:'Home',htmlElementId:'southContent',title:'Home' } ) );

var paneNorth = new DHTMLSuite.paneSplitterPaneModel( { position : "north", id:"northPane",size:65,scrollbars:false,resizable:false,collapsable:false } );
paneNorth.addContent( new DHTMLSuite.paneSplitterContentModel( { id:"northContent",htmlElementId:'northContent',title:'' } ) );

var paneCenter = new DHTMLSuite.paneSplitterPaneModel( { position : "center", id:"centerPane",size:150,minSize:100,maxSize:200,callbackOnCloseContent:'callbackFunction',callbackOnTabSwitch:'callbackFunction' } );
paneCenter.addContent( new DHTMLSuite.paneSplitterContentModel( { id: 'center',htmlElementId:'center',title:'Emile Frame work',tabTitle: 'Welcome',closable:false } ) );
paneCenter.addContent( new DHTMLSuite.paneSplitterContentModel( { id:'center3', htmlElementId:'center3',title:'Pane splitter methods',tabTitle: 'Pane splitter' } ) );


paneModel.addPane(paneSouth);
paneModel.addPane(paneEast);
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

</script>

<ul id="menuModel" style="display:none">
	<li id="50000"jsFunction="saveWork()" itemIcon="../images/disk.gif"><a href="#" title="Open the file menu">File</a>
		<ul width="150">
			<li id="500001"><a href="#" title="Save your work">Save</a></li>
			<li id="500002"><a href="#">Save As</a></li>
			<li id="500004" itemType="separator"></li>
			<li id="500003"><a href="#">Open</a>
				<ul width="130">
					<li id="5000031"><a href="#">Project</a>	
					<li id="5000032"><a href="#">Template</a>	
					<li id="5000033"><a href="#">File</a>	
					
				</ul>
			</li>
		</ul>
	</li>	
	<li id="500011"><a href="#">Demos</a>
		<ul width="150">
			<li id="5000115" jsFunction="openPage('center','sliderWidget','includes/pane-splitter-slider-2.inc','Slider widget','Slider widget') "><a href="Javascript:paneSplitter.hidePane('west');"> Slider widget</a></li>
			<li id="5000120" jsFunction="openPage('center','textEdit','includes/pane-splitter-text-edit.php','Inline text edit','Inline Text Edit')"><a href="#">Inline text edit</a></li>
			<li id="5000111"><a href="#">Table widgets</a>
				<ul width="180">
					<li id="50001111" jsFunction="openPage('center','myTableWidget','includes/pane-splitter-table.inc','A table widget','A table widget')"><a href="#">A table(client sort)</a></li>	
					<li id="50001112" jsFunction="openPage('center','myTableWidgetServer','includes/pane-splitter-table-server.php','A table widget(Server sort)','A table widget(Server sort)')"><a href="#">A table (serverside sort)</a></li>	
				</UL>
			</li>
			<li id="5000112"><a href="#">Tab view demos</a>	
				<ul width="130">
					<li id="50001121" jsFunction="openPage('center','tabViewDemo','includes/pane-splitter-tabs.inc','Tab view demo','Tab view demo')"><a href="Javascript:paneSplitter.showPane('west');Javascript:paneSplitter.hidePane('east');">Tab demo</a></li>	
					<li id="50001122" jsFunction="openPage('center','tabViewDemo2','includes/pane-splitter-tabs2.inc','Tab view demo','Tab view demo')"><a href="#">Tab demo 2</a></li>	
				</ul>
			</li>
			<li id="5000119"><a href="#">Drag'n drop</a>
				<ul width="230"> 
					<li id="50001191" jsFunction="openPage('west','myFolderTree','includes/pane-drag-drop-folder-tree.inc','Drag\'n drop folder tree','Folder tree')"><a href="#">Drag'n drop folder tree</a></li>
					<li id="50001194" jsFunction="openPage('center','myFolderTree2','includes/pane-drag-drop-folder-tree-demo2.inc','Drag\'n drop folder tree','Folder tree')"><a href="#">Drag'n drop folder tree(center)</a></li>
					<li id="50001192" jsFunction="openPage('center','myDragDrop','includes/pane-splitter-dragdrop.inc','Drag\'n drop widget','Drag\'n drop')"><a href="#">Drag'n drop</a></li>
					<li id="50001193" jsFunction="openPage('center','myDragDrop','includes/pane-splitter-dragdrop3.inc','Drag\'n drop demo 2','Drag\'n drop demo 2',true);"><a href="#">Drag'n drop 2</a></li>
				</ul>					
			</li>
			<li id="5000123"><a href="#">Image effects</a>	
				<ul width="150">
					<li id="50001231" jsFunction="openPage('center','imageEnlarger','includes/pane-splitter-image-enlarger.inc','Image enlarger','Image enlarger')"><a href="#">Image enlarger</a></li>	
					<li id="50001232" jsFunction="openPage('center','floatingGallery','includes/pane-splitter-floating-gallery.inc','Floating gallery','Floating gallery')"><a href="#">Floating gallery</a></li>	
				</ul>
			</li>			
			<li id="5000116" jsFunction="openPage('center','ajaxTooltip','includes/pane-splitter-dyn-tooltip.inc','Dynamic tooltip','Dynamic tooltip')"><a href="#">Dynamic tooltip</a></li>	
			<li id="5000114" jsFunction="openPage('center','contextMenu','includes/pane-splitter-context-menu.inc','Context menu','Context menu')"><a href="#">Context menu</a></li>	
			<li id="5000121" jsFunction="openPage('center','infoPane','includes/pane-splitter-info-pane.inc','Info Pane','Info Pane')"><a href="#">Info pane</a></li>	
			<li id="5000122" jsFunction="openPage('center','modalMessage','includes/pane-splitter-modal-message.inc','Modal message','Modal message')"><a href="#">Modal Message</a></li>	
			<li id="5000124" jsFunction="openPage('center','calendar','includes/pane-splitter-calendar-1.php','Calendar','Calendar')"><a href="#">Calendar</a></li>	
			<li id="5000125" jsFunction="openPage('center','Window','includes/pane-splitter-window.php','Window','Window')"><a href="#">Window widget</a></li>	
			<li id="5000127" jsFunction="openPage('center','Color widgets','includes/pane-splitter-color-widget.php','Color widgets','Color widgets')"><a href="#">Color widgets</a></li>	
		</ul>			
	</li>
	<li id="50003" itemType="separator"></li>
	<li id="50002"><a href="#">Documentation</a>
		<ul width="150">
			<li id="500021"><a href="#">Tutorials</a>
				<ul width="150">
					<li id="5000211" jsFunction="openPage('center','tutAjaxTooltip','includes/tutorial-ajax-tooltip.inc','Tutorial - Dynamic tooltip','Dynamic tooltip')"><a href="#">Dynamic tooltip</a></li>			
					<li id="5000212" jsFunction="openPage('center','tutSlider','includes/tutorial-slider.inc','Tutorial - Slider','Slider')"><a href="#">Slider widget</a></li>			
					<li id="5000213" jsFunction="openPage('center','tutTextEdit','includes/tutorial-textEdit.inc','Tutorial - Text Edit','Text Edit')"><a href="#">Inline text edit</a></li>			
					<li id="5000214"><a href="#">Table widget</a>
						<ul width="190">
							<li id="50002141" jsFunction="openPage('center','tutTableWidget1','includes/tutorial-tableWidget1.inc','Tutorial - Table widget (sort data on client)','Table widget(client)')"><a href="#">Table widget(client sort)</a></li>
							<li id="50002142" jsFunction="openPage('center','tutTableWidget2','includes/tutorial-tableWidget2.inc','Tutorial - Table widget (sort data on server)','Table widget(server)')"><a href="#">Table widget(server sort)</a></li>
						</ul>
					</li>	
					<li id="5000215" jsFunction="openPage('center','tutMenuBar','includes/tutorial-menuBar.inc','Tutorial - Menu bar','Menu bar')"><a href="#">Menu bar</a></li>			
					<li id="5000216" jsFunction="openPage('center','tutPaneSplitter','includes/tutorial-paneSplitter.inc','Tutorial - Pane splitter','Pane splitter')"><a href="#">Pane splitter</a></li>			
					<li id="5000217" jsFunction="openPage('center','tutInfoPane','includes/tutorial-infoPane.inc','Tutorial - Info Pane','Info Pane')"><a href="#">Info Pane</a></li>			
					<li id="5000218" jsFunction="openPage('center','tutModalMessage','includes/tutorial-modalMessage.inc','Tutorial - Modal message','Modal message')"><a href="#">Modal message</a></li>
					<li id="5000219"><a href="#">Image effects</a>	
						<ul width="180">
							<li id="50002191" jsFunction="openPage('center','tutImageEnlarger','includes/tutorial-imageEnlarger.inc','Tutorial - Image enlarger','Image enlarger')"><a href="#">Image enlarger</a></li>			
							<li id="50002192" jsFunction="openPage('center','tutFloatingGallery','includes/tutorial-floatingGallery.inc','Tutorial - Floating gallery','Floating gallery')"><a href="#">Floating gallery</a></li>
						</ul>
					</li>	
					<li id="5000220" jsFunction="openPage('center','tutModalMessage','includes/tutorial-calendar.php','Tutorial - Calendar','Calendar')"><a href="#">Calendar</a></li>
					<li id="5000221" jsFunction="openPage('center','tutTabView','includes/tutorial-tabView.inc','Tutorial - Tab view','Tab view')"><a href="#">Tab view</a></li>
				</ul>
			</li>	
			<li id="500022" jsFunction="openClassDocumentation()"><a href="#">Classes</a></li>		
			<li id="500023" jsFunction="openPage('center','tutClassOverview','includes/pane-splitter-classes.inc','Classes - Overview','Classes - Overview')"><a href="#">Classes(overview)</a></li>
		</ul>
		<li id="6000"><a href="#"> Maps</a>
		<ul width="150">
<li id="6000220" jsFunction="openPage('center','Maps','google/mapframe.html','Gen Map','Maps')"><a href="#">Maps</a></li>

</ul>
	</li>
</ul>	
	
<!-- This is the datasource for menu items which are added dynamically to the menu -->
<ul id="additionalModel" style="display:none">
	<li id="60000"><a href="#">Internet Option</a></li>
	<li id="60001"><a href="#">Debug URL</a></li>
	<li id="60001"><a href="#">CVS</a>
		<ul width="100">
			<li id="600011"><a href="#">Check out</a></li>
			<li id="600012"><a href="#">Update</a></li>
		</ul>
	</li>		
</ul>
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
</script>		
<?
@include($_SERVER['DOCUMENT_ROOT']."/config/kontera.php");
?>	
<script type="text/javascript">
// This is only for the demo in ordre to display different colors for the different themes //

var bgColor = '#c4dcfb';	// Default blue color
if(DHTML_SUITE_THEME=='gray')bgColor='#d8d8d8';
document.getElementById('northContent').style.backgroundColor=bgColor;
if(document.all)DHTMLSuite.commonObj.correctPng('dhtmlSuiteLogo');
</script>
</body>
</html>
