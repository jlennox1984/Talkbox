function loadvoicebox(){
 var str= document.getElementById("tts1").value;
 document.getElementById('voiceframe').src='engine.php?str=' +str;
 document.getElementById('voiceframe').style.width='0px';
 document.getElementById('voiceframe').style.height='0px';
 document.getElementById('voiceframe').style.display='block';

	
}
function sayit(id){
	var str= document.getElementById(+id).value;

 document.getElementById('voiceframe').src='engine.php?str=' +str;
 document.getElementById('voiceframe').style.width='0px';
 document.getElementById('voiceframe').style.height='0px';
 document.getElementById('voiceframe').style.display='block';

}
