/**
 * @author jeff
 */


tooltipObj = new DHTMLSuite.dynamicTooltip();	// Create ONE tooltip object.

function addnewserv(url){
	newwindow = window.open(url, 'name', 'height=400,width=400 , scrollbars=yes ,status=yes ,resizable=yes  ');
	if (window.focus) {
		newwindow.focus()
	}
}
function agency_lang(serviceid,agencyid){
	var str1='agency_langprops.php?service_id='+serviceid
	var str2='&agency_id='+agencyid;
	var file=str1+str2;
	console.log('Our Debug Infomation')
	console.log('the Service id is' ,serviceid);
	console.log('the Agency id is' ,agencyid);
	console.log('Our File is' ,file);
	window.frames['langprops'].window.location.replace(file);
}   
   function addagency_services() {
   	  var ni = document.getElementById('agency_Services');
  var numi = document.getElementById('theValue');
  var num = (document.getElementById('theValue').value -1)+ 2;
  numi.value = num;
  var newdiv = document.createElement('div');
  var divIdName = 'serv'+num+'Div';
  newdiv.setAttribute('id',divIdName);
  newdiv.innerHTML = 'Element Number '+num+' has been added! <a href=\'#\' onclick=\'removeElement('+divIdName+')\'>Remove the div "'+divIdName+'"</a>';
  ni.appendChild(newdiv);
}

function removeElement(divNum) {
  var d = document.getElementById('Servies');
  var olddiv = document.getElementById(divNum);
  d.removeChild(olddiv);
}


function loadiframe(file){
	window.frames['dataframe'].window.location.replace(file);
		document.getElementById("viewagency").style.display='inline';	
}
function loadiframeserv(file){
	window.frames['viewservice'].window.location.replace(file);
	document.getElementById("viewservice").style.display = 'inline';
	console.log('Our file  for load Iframe services');
	console.log('Our File is' ,file);
	
}
	function agencylangserv(file){
		var file='agencylangprop.php?agency=';
		var agency = document.ctl.agency_ctl.value;
		window.frames['agency_serv_prop'].window.location.replace(file+agency);
		
}

function usermanwin(file){
	parent.window.frames['usermanager_win'].window.location.replace(file);
	if (window.focus) {
		parent.usermanager_win.focus()
	}

}
function reloadusermanager(file){
parent.window.frames['usermanager_list'].window.location.replace(file);
	if (window.focus) {
		parent.usermanager_win.focus()
	}	
}
function show_fr(){
	document.getElementById("fr_edit").style.display='inline'
    document.getElementById("eng_edit").style.display='none'
}

function show_eng(){
	document.getElementById("eng_edit").style.display='inline'
    document.getElementById("fr_edit").style.display='none'
}
	function editzonewindow(zone){
		var file = 'editzone.php?zid='+zone;
		var file1= 'postalcodes.php?zid='+zone;
		parent.window.frames['viewzone'].window.location.replace(file);
		parent.window.frames['viewpostalcode'].window.location.replace(file1);
		parent.document.getElementById('editzonepane').style.display='inline';
		//debuging 
		console.log('Edit zone window there is two calls');
		console.log('The Zone is' , zone);
		console.log('editzone call' , file);
		console.log('Postal code edit' , file1);
	}
	


function changepass(){
	document.getElementById("passwd").style.display='inline'
	
}
