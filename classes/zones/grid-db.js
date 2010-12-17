function captureEvents(observable) {
    Ext.util.Observable.capture(
        observable,
        function(eventName) {
            console.info(eventName);
        },
        this
    );		
}
Ext.onReady(function(){
 
	// create the data store
	var store = new Ext.data.JsonStore({
		url: 'data_grid1.php',
		fields: [
			{name: 'id', type: 'int'},
			'agency'
		]
	});
 
	// load data from the url ( data.php )
	store.load();
 
	// create the Grid
	var grid = new Ext.grid.GridPanel({
		store: store,
		columns: [
			{id:'agency',header: 'ID', width: 30, sortable: true, dataIndex: 'id'},
			{header: 'agency', width: 100, sortable: true, dataIndex: 'agency'}],
		stripeRows: true,
		height:250,
		width:500,
		title:'DB Grid'
	});
 
	// render grid
	captureEvents('grid');
	
	grid.render('grid');
 
});
