/**
 * @author jeff
 */
function addnewserv(url){
	newwindow = window.open(url, 'name', 'height=800,width=800 , scrollbars=yes ,status=yes ,resizable=yes  ');
	if (window.focus) {
		newwindow.focus()
	}
}
