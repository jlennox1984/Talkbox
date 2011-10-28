function loadvoicebox(){
var mode='main'
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
