function loadvoicebox(clas){

	var mode='tts'
	 var str= document.getElementById("tts1").value;
 	document.getElementById('voiceframe').src='engine.php?str=' +str+'&mode='+mode;
 	document.getElementById('voiceframe').style.width='0px';
	 document.getElementById('voiceframe').style.height='0px';
	 document.getElementById('voiceframe').style.display='block';	
}
function sayit(id,mode){
	var str=document.getElementById(+id).value;
	 document.getElementById('voiceframe').src='engine.php?mode='+mode+'&str='+str;
	 document.getElementById('voiceframe').style.width='0px';
 	document.getElementById('voiceframe').style.height='0px';
	 document.getElementById('voiceframe').style.display='block';
 
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
function savevol(str){
	httpObject = getHTTPObject();
//if (httpObject != null) {
	httpObject.open("GET", "savevol.php?vol="+str)
	httpObject.send(null);

//	}
}

function savephase(hid){
	 httpObject = getHTTPObject();
        var sel = document.getElementById("item"+hid);
	var board=sel.options[sel.selectedIndex].value;
	alert(board);
	var methods="?hid="+hid+"&board="+board;
	alert(methods);
	httpObject.open("GET", "savephase.php"+methods);
        httpObject.send(null);
	
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
    

