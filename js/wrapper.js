 Facebook Ajax Wrapper 
// http://www.collinchung.com/fAjax.js.txt

/*

var f = new fAjax(10000); // 10 second throttle period

f.queuePost("http://myserver.com/service", 
			null, 
			{	responseType: Ajax.FBML, 
				ondone: function(data) { document.getElementById('updateArea').setInnerFBML(data); }, 
				onerror: function() { document.getElementById().setTextValue("Error"); }, 
				expiry: 120, 
				delayTime: 20000});

f.queuePost("http://myserver.com/service2", 
			null, 
			{	responseType: Ajax.JSON, 
				ondone: function(data) { document.getElementById('updateArea2').setInnerText(data.count + ' records'); }, 
				onerror: function() { document.getElementById().setTextValue("Error"); }, 
				expiry: 30});

*/

fAjax = function(delayTime) {
	// throttle period, defaulted to 1 second
	this.delayTime = delayTime || 1000;

	// the cache object
	this.cache = {}; 

	// sync and queue for queued ajax requests
	this.sync = [];
	this.queue = [];
};

fAjax.prototype.clear = function(url) {
	if(this.cache[url] != null) {
		if(this.cache[url].requesting == true) {
			this.cache[url].request.abort();
			this.cache[url].request = null;

		}

		if(this.cache[url].timer != null) {
			clearTimeout(this.cache[url].timer);
		}
		
		this.cache[url] = null;
	}
};

/* Queued Ajax requests (like the one in jQuery's Ajax Queue plugin)
 * http://jquery.com/plugins/project/ajaxqueue
 * A new Ajax request won't be started until the previous queued 
 * request has finished.
 */
fAjax.prototype.queuePost = function(url, query, obj) {
	var that = this, queue_item = {url:url, query:query, obj:obj}, _ondone = obj.ondone, _onerror = obj.onerror;

	var queue_oncomplete = function(success, data) {		
		if(success == 'done') {
			_ondone(data);
		} else {
			_onerror(data);
		}

		// dequeue
		that.queue.shift();
		if(queued = that.queue[0]) { 
			that.post(queued.url, queued.query, queued.obj); 
			
		}
	}

	queue_item.obj.ondone = function(data) { queue_oncomplete('done', data); };
	queue_item.obj.onerror = function(data) { queue_oncomplete('error', data); };

	if((this.queue = this.queue.concat(queue_item)).length == 1) {
		this.post(queue_item.url, queue_item.query, queue_item.obj);

	}
};

/* Synced Ajax requests (like the one in jQuery's Ajax Queue plugin)
 * http://jquery.com/plugins/project/ajaxqueue
 * The Ajax request will happen as soon as you call this method, but
 * the callbacks (ondone/onerror) won't fire until all previous
 * synced requests have been completed.
 */
fAjax.prototype.syncPost = function(url, query, obj) {
	var that = this, pos = this.sync.length;
	
	this.sync[pos] = {ondone: obj.ondone, onerror: obj.onerror, syncing: true, result: null};
	
	var sync_oncomplete = function(success, data) {		
		that.sync[pos].result = data;
		that.sync[pos].syncing = false;
		
		if(pos == 0 || !that.sync[pos - 1]) {
			for(var i = pos; i < that.sync.length && that.sync[i].syncing == false; ++i) {
				that.sync[i]["on" + success](that.sync[i].result);
				that.sync[i] = null;

			}
		}
	}

	obj.ondone = function(data) { sync_oncomplete('done', data); };
	obj.onerror = function(data) { sync_oncomplete('error', data); };

	this.post(url, query, obj);
};

/* Ajax request wrapper, with (expiry-enabled) caching
 */
fAjax.prototype.post = function(url, query, obj) {
	var that = this;
	
	// Remove existing cached entries (based on the url)
	//   if the request is in progress but not complete, 
	//   or the throttled request has not been sent,
	//   or the cached response has expired
	if(this.cache[url] != null && (this.cache[url].requesting == true || this.cache[url].timer != null || this.cache[url].expiry < new Date()) ) {
		this.clear(url);

	}

	if(this.cache[url] == null) {
		this.cache[url] = {request: null, result: null, expiry: null, requesting: false, timer: null};

		this.cache[url].timer = setTimeout(
			function() {
				var ajax = new Ajax();
				ajax.responseType = obj.responseType;
				ajax.requireLogin = obj.requireLogin || false;

				ajax.ondone = function(data) {
					that.cache[url].requesting = false;
					that.cache[url].request = null;
					
					if(data) {
						that.cache[url].result = data;
						// default expiry is 30 minutes
						that.cache[url].expiry = (now = new Date()).setMinutes(now.getMinutes() + (obj.expiry || 30));
					}
					
					if(obj.ondone) {
						obj.ondone.apply(null, [data]);					
					}
						
				};
				
				ajax.onerror = function() {
					that.cache[url].requesting = false;
					that.cache[url].request = null;

					if(obj.onerror) {
						obj.onerror();						
					}					
				};

				that.cache[url].requesting = true;
				that.cache[url].request = ajax;
				that.cache[url].request.post(url, query);
				that.cache[url].timer = null;
			}, 			
			obj.delayTime || this.delayTime);
		
	} else if(this.cache[url] != null && this.cache[url].result != null) { 
		if(obj.ondone) {
			obj.ondone.apply(null, [this.cache[url].result]);
		}
		
	}
