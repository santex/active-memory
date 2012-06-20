{
 "_id": "_design/~~CITYPAIR~~",
 "views": {
 "foo": {
 "map" : "function(doc) { if( doc._id.match('^~~MARKET~~[_]')) { var prefix = doc['marketId']; if(prefix) { emit(prefix, null); }}}"
 ,"reduce" : "function(keys, values, rereduce) { var unique_labels = {}; values.forEach(function(label) { if(!unique_labels[label]) { unique_labels[label] = true; } }); return unique_labels; }"
 },
 "bar": {
 "map" : "function(doc){ emit(doc._id, doc.marketId, doc._rev)}" ,
 "reduce" : "function(keys, values, rereduce) { var unique_labels = {}; values.forEach(function(label) { if(!unique_labels[label]) { unique_labels[label] = true; } }); return unique_labels; }"
 },
 "baz": {
 "map" : "function(doc){ emit(doc._id,doc.isoweek,doc.month,doc.date,doc.caller.length)}"
 ,"reduce" : "function(keys, values, rereduce) { var unique_labels = {}; values.forEach(function(label) { if(!unique_labels[label]) { unique_labels[label] = true; } }); return unique_labels; }"
 },
 "marketId":{
 "map" : "function(doc) { if( doc._id.match('^~~MARKET~~[_]')) { var prefix = doc['marketId']; if(prefix) { emit(prefix, 1); }}}"
 ,"reduce" : "function(keys, values, rereduce) { var unique_labels = {}; values.forEach(function(label) { if(!unique_labels[label]) { unique_labels[label] = true; } }); return unique_labels; }"
 },
 "isoweek":{
 "map" : "function(doc) { if( doc._id.match('^~~MARKET~~[_]')) { var prefix = doc['isoweek']; if(prefix) { emit(prefix,null); }}}"
 ,"reduce" : "function(keys, values, rereduce) { var unique_labels = {}; values.forEach(function(label) { if(!unique_labels[label]) { unique_labels[label] = true; } }); return unique_labels; }"
 },
 "month":{
 "map" : "function(doc) { if( doc._id.match('^~~MARKET~~[_]')) { var prefix = doc['month']; if(prefix) { emit(prefix, null); }}}"
 ,"reduce" : "function(keys, values, rereduce) { var unique_labels = {}; values.forEach(function(label) { if(!unique_labels[label]) { unique_labels[label] = true; } }); return unique_labels; }"
 },
 "date":{
 "map" : "function(doc) { if( doc._id.match('^~~MARKET~~[_]')) { var prefix = doc['date'];  var av = {}; av['markers']=doc.markers; if(doc.markers[11].priceComponent[0]) { av[markers]=doc.markers; av['price']=doc.markers[11].priceComponent[0]; } if(prefix.length>0 && av.length>0) { emit(prefix,av);}}}"
 ,"reduce" : "function(keys, values, rereduce) { var unique_labels = {}; values.forEach(function(label) { if(!unique_labels[label]) { unique_labels[label] = true; } }); return unique_labels; }"
 },
 "service":{
 "map" : "function(doc) { if( doc._id.match('^~~MARKET~~[_]')) { var prefix = doc['date']; var av = doc['service'];  if(prefix.length>0 && av.length>0) { emit(prefix, av);}}}"
 ,"reduce" : "function(keys, values, rereduce) { var unique_labels = {}; values.forEach(function(label) { if(!unique_labels[label]) { unique_labels[label] = true; } }); return unique_labels; }"
 },
 "price":{
 "map" : "function(doc) { if( doc._id.match('^~~MARKET~~[_]')) { var prefix = doc['date']; var av = doc.price; if(prefix.length>0) { emit(prefix, av);}}}"
 ,"reduce" : "function(keys, values, rereduce) { var unique_labels = {}; values.forEach(function(label) { if(!unique_labels[label]) { unique_labels[label] = true; } }); return unique_labels; }"
 },
 "currentAvail":{
 "map" : "function(doc) { if( doc._id.match('^~~MARKET~~[_]')) { var prefix = doc['date'];  var av = doc['currentAvail']; if(prefix.length>0 && av.length>0) { emit(prefix,av);}}}"
 ,"reduce" : "function(keys, values, rereduce) { var unique_labels = {}; values.forEach(function(label) { if(!unique_labels[label]) { unique_labels[label] = true; } }); return unique_labels; }"
 },
 "flightNr":{
 "map" : "function(doc) { if( doc._id.match('^~~MARKET~~[_]')) { var prefix = doc['flightNr'];   var av = doc['currentAvail']; if(prefix.length>0 && av.length>0) { emit(prefix,av);}}}"
 ,"reduce" : "function(keys, values, rereduce) { var unique_labels = {}; values.forEach(function(label) { if(!unique_labels[label]) { unique_labels[label] = true; } }); return unique_labels; }"
 },
 "markers":{
 "map" : "function(doc) { if( doc._id.match('^~~MARKET~~[_]') && doc.markers.length > 0) { for(var idx in doc.markers) { emit(doc.markers[idx], null); }}}"
 ,"reduce" : "function(keys, values, rereduce) { var unique_labels = {}; values.forEach(function(label) { if(!unique_labels[label]) { unique_labels[label] =label.length; } }); return unique_labels; }" 
 },
 "tag":{
 "map" : "function(doc) { if( doc._id.match('^~~MARKET~~[_]') && doc.markers.length > 0) { for(var idx in doc.markers) { emit(doc.markers[idx], null); }}}"
 ,"reduce" : "function(keys, values, rereduce) { var unique_labels = {}; values.forEach(function(label) { if(!unique_labels[label]) { unique_labels[label] = true; } }); return unique_labels; }"
 }
 }
 
}

