function loadvoicebox(board){


	var mode='tts'
	 var str= document.getElementById("tts1").value;
	//alert (str);
 	document.getElementById('voiceframe'+board).src='engine.php?str=' +str+'&mode='+mode;
 	document.getElementById('voiceframe'+board).style.width='0px';
	document.getElementById('voiceframe'+board).style.height='0px';
	document.getElementById('voiceframe'+board).style.display='block';	
	//Clear text Box
	var tmp= document.getElementById("tts1");
	tmp.value='';
}
function sayit(id,mode,board){
	var str=document.getElementById(+id).value;
	 document.getElementById('voiceframe'+board).src='engine.php?mode='+mode+'&str='+str;

	 document.getElementById('voiceframe'+board).style.width='0px';
 	document.getElementById('voiceframe'+board).style.height='0px';
	 document.getElementById('voiceframe'+board).style.display='block';
	 //Clear text Box
        document.getElementById('voiceframe'+board).value='';
}
 // Get the HTTP Object
    function getHTTPObject(){
        if (window.ActiveXObject) return new ActiveXObject("Microsoft.XMLHTTP");
            else if (window.XMLHttpRequest) return new XMLHttpRequest();
        else {
            alert("Ajax not supported.");
            return null;
        }
    }
	function so_clearInnerHTML(obj) {
	// perform a shallow clone on obj
	nObj = obj.cloneNode(false);
	// insert the cloned object into the DOM before the original one
	obj.parentNode.insertBefore(nObj,obj);
	// remove the original object
	obj.parentNode.removeChild(obj);
}
function savevol(str){
	httpObject = getHTTPObject();
//if (httpObject != null) {
	httpObject.open("GET", "relays.php?action=vol&vol="+str)
	httpObject.send(null);
//	 alert(str);
	 document.getElementById('volind').innerHTML=+str;

//	}
}
function savephasewriter(id){

	var str=document.getElementById(+id).value;
	alert('string eq:' +str);
	 var sel = document.getElementById("item"+id);
	 var board=sel.options[sel.selectedIndex].value;
	alert('board eq: ' +board); 
	var method="?action=savephasewriter&phase="+str+"&board="+board+'&series='+id;
	httpObject = getHTTPObject();
//if (httpObject != null) {
        httpObject.open("GET", "relays.php"+method);
        httpObject.send(null);

}
 function recordon(){
	
 httpObject = getHTTPObject();
	//if (httpObject != null) {
	
        httpObject.open("GET", "relays.php?action=recordon")
	httpObject.send(null);
		alert('RECORD ON');
		document.getElementById('recmods').innerHTML=' <a href=\"#\" onclick=\"return recordoff();\"> RECORD OFF<a>'	

	
	
}

 function recordoff(){

 httpObject = getHTTPObject();
        //if (httpObject != null) {

        httpObject.open("GET", "relays.php?action=recordoff")
        httpObject.send(null);
                alert('RECORD OFF');
                document.getElementById('recmods').innerHTML=' <a href=\"#\" onclick=\"return recordon();\"> RECORD ON<a>'



}
function deletestory(sid){
	 httpObject = getHTTPObject();
        //if (httpObject != null) {

        httpObject.open("GET", "relays.php?action=delstory&sid="+sid)
        httpObject.send(null);
                alert('DELETE STORY');
		document.getElementById('row'+sid).innerHTML='';
}
function savephase(hid){
	 httpObject = getHTTPObject();
        var sel = document.getElementById("item"+hid);
	var board=sel.options[sel.selectedIndex].value;
//	alert(board);
	var methods="?action=savephase&hid="+hid+"&board="+board;
//	alert(methods);
	httpObject.open("GET", "relays.php"+methods);
	 document.getElementById('commit'+hid).innerHTML="SAVED";
	
	document.getElementById('button'+hid).style.visibility='hidden'; // hide 

       httpObject.send(null);
	
}

function popitup(url) {
	newwindow=window.open(url,'name','height=200,width=150');
	if (window.focus) {newwindow.focus()}
	return false;
}
function runScript(e) {
    if (e.keyCode == 13) {
	this.loadvoicebox();
	alert('test');
	readCookie('lpac');
	
    }
}
function noNumbers(e)
{
var keynum
var keychar
var numcheck

if(window.event) // IE
{
keynum = e.keyCode
}
else if(e.which) // Netscape/Firefox/Opera
{
keynum = e.which
}
keychar = String.fromCharCode(keynum)
numcheck = /\d/
return !numcheck.test(keychar)
}

//var obj;
//var TAB = 9;
function catchTAB(evt,elem)
{
  obj = elem;
  var keyCode;
  if ("which" in evt)
  {// NN4 & FF &amp; Opera
    keyCode=evt.which;
  } else if ("keyCode" in evt)
  {// Safari & IE4+
    keyCode=evt.keyCode;
  } else if ("keyCode" in window.event)
  {// IE4+
    keyCode=window.event.keyCode;
  } else if ("which" in window.event)
  {
    keyCode=evt.which;
  } else  {    alert("the browser don't support");  }

  if (keyCode == TAB)
  {
    obj.value = obj.value + "\t";
    alert("TAB was pressed");
    setTimeout("obj.focus()",1);// the focus is set back to the text input
  }
return false;
}


  $(function () {
        $('.bubbleInfo').each(function () {
            var distance = 10;
            var time = 250;
            var hideDelay = 500;

            var hideDelayTimer = null;

            var beingShown = false;
            var shown = false;
            var trigger = $('.trigger', this);
            var info = $('.popup', this).css('opacity', 0);


            $([trigger.get(0), info.get(0)]).mouseover(function () {
                if (hideDelayTimer) clearTimeout(hideDelayTimer);
                if (beingShown || shown) {
                    // don't trigger the animation again
                    return;
                } else {
                    // reset position of info box
                    beingShown = true;

                    info.css({
                        top: -90,
                        left: -33,
                        display: 'block'
                    }).animate({
                        top: '-=' + distance + 'px',
                        opacity: 1
                    }, time, 'swing', function() {
                        beingShown = false;
                        shown = true;
                    });
                }

                return false;
            }).mouseout(function () {
                if (hideDelayTimer) clearTimeout(hideDelayTimer);
                hideDelayTimer = setTimeout(function () {
                    hideDelayTimer = null;
                    info.animate({
                        top: '-=' + distance + 'px',
                        opacity: 0
                    }, time, 'swing', function () {
                        shown = false;
                        info.css('display', 'none');
                    });

                }, hideDelay);

                return false;
            });
        });
    });
    

