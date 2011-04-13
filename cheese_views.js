var couchapp = require('couchapp'),
    fs = require('fs');

des_doc = {
    _id: '_design/app',
    views: {},
    lists: {},
    templates: {}
}

module.exports = des_doc;

des_doc.views.by_each_day = {
    map: function(doc) {
	     var date = new Date(doc.created_at);
	     var month = date.getMonth();
	     var day = date.getDate();
	     var dayOfWeek = date.getDay();
	     var timestamp = new Date(2010, month, day, 0,0,0);
	     timestamp = timestamp.getTime();
	     emit(timestamp, null);
	 },
    reduce: "_count"
}

des_doc.views.by_day_of_week = {
    map: function(doc) {
	     var date = new Date(doc.created_at);
	     emit(Date.getDay(date), null);
	 },
    reduce: "_count"
}

des_doc.views.by_user = {
    map: function(doc) {
	     emit(doc.user.name, null);
	 },
    reduce: "_count"
}

des_doc.lists.all = function(head, req) {
    var row;
    start({
	"headers" : {
	    "Content-Type": "text/plain"
	}
    });
    while(row = getRow()) {
	send(row.key + ": " + row.value);
	send("\n");
    }
}


// sortowanie po wartościach
des_doc.lists.best_writers = function(head, req) {
    var row;
    var rows = [];
    start({
	"headers": {
	    "Content-Type": "text/plain"
	}
    });
    while(row = getRow()) 
	rows.push(row);

    rows.sort(function(a,b) {
	return b.value - a.value;
    });
    
    rows.map(function(row) {
	send(JSON.stringify(row));
	send("\n");
    });
}

// wąsata wizualizacja
des_doc.lists.tweets = function(head,req) {
    var mustache = require('templates/mustache');
    var template = this.templates['tweets_flot.html'];

    var row;
    var rows = [];
    start({
	"headers" : {
	    "Content-Type": "text/html"
	}
    });
    while(row = getRow()) {
	rows.push({key: row.key, value: row.value});
    }
    var view = {rows: rows};
    var html = mustache.to_html(template,view);
    return html;
}

des_doc.templates.mustache = fs.readFileSync('templates/mustache.js', 'UTF-8');
des_doc.templates['tweets_flot.html'] = fs.readFileSync('templates/tweets_flot.html.mustache', 'UTF-8');

// couchapp push cheese_views.js http://sigma.ug.edu.pl:14017/infochimps/
