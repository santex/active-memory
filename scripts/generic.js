{
  "_id": "_design/generic",
  "views": {
    "user": {
      "map" : "function(doc) { if(doc['user']) { var prefix = doc['user'];   if(prefix) {  emit(prefix, null); }}}"
       ,"reduce" : "function(keys, values, rereduce) {  var unique_labels = {};  values.forEach(function(label) {    if(!unique_labels[label]) {     unique_labels[label] = label.length;    }  });  return unique_labels; }"
    },
     "bar": {
      "map" : "function(doc){ emit(doc._id, doc.user, doc._rev)}" ,
      "reduce" : "function(keys, values, rereduce) {  var unique_labels = {};  values.forEach(function(label) {    if(!unique_labels[label]) {     unique_labels[label] = label.length;    }  });  return unique_labels; }"
    },
     "baz": {
      "map" : "function(doc){ emit(doc._id,doc.data.isoweek,doc.data.month,doc.data.date,doc.caller.length)}"
     ,"reduce" : "function(keys, values, rereduce) {  var unique_labels = {};  values.forEach(function(label) {    if(!unique_labels[label]) {     unique_labels[label] = label.length;    }  });  return unique_labels; }"
    },
     "user":{
      "map" : "function(doc) { if(doc['user']) { var prefix = doc['user'];   if(prefix) {  emit(prefix, doc.data.query); }}}"
     ,"reduce" : "function(keys, values, rereduce) {  var unique_labels = {};  values.forEach(function(label) {    if(!unique_labels[label]) {     unique_labels[label] = label.length;    }  });  return unique_labels; }"
    },
     "base":{
      "map" : "function(doc) { if(doc.data) { var prefix = doc.data.base;   if(prefix) {  emit(prefix, doc.data.query); }}}"
     ,"reduce" : "function(keys, values, rereduce) {  var unique_labels = {};  values.forEach(function(label) {    if(!unique_labels[label]) {     unique_labels[label] = label.length;    }  });  return unique_labels; }"
    },
     "query":{
      "map" : "function(doc) { if(doc.data) { var prefix = doc.data;   if(prefix) {  emit(prefix, doc.data.query); }}}"
     ,"reduce" : "function(keys, values, rereduce) {  var unique_labels = {};  values.forEach(function(label) {    if(!unique_labels[label]) {     unique_labels[label] = label.length;    }  });  return unique_labels; }"
    },
     "month":{
      "map" : "function(doc) { if(doc.data['month']) { var prefix = doc.data;   if(prefix) {  emit(prefix, doc.data); }}}"
     ,"reduce" : "function(keys, values, rereduce) {  var unique_labels = {};  values.forEach(function(label) {    if(!unique_labels[label]) {     unique_labels[label] = label.length;    }  });  return unique_labels; }"
    },
    "date":{
      "map" : "function(doc) { if(doc.data['date']) { var prefix = doc.data.date;   if(prefix.length>0) {  emit(prefix,doc.data.date);}}}"
     ,"reduce" : "function(keys, values, rereduce) {  var unique_labels = {};  values.forEach(function(label) {    if(!unique_labels[label]) {     unique_labels[label] = label.length;    }  });  return unique_labels; }"
    },
     "markers":{
      "map" : "function(doc) { if(doc.data.markers.length > 0) { for(var idx in doc.data.markers) { emit(doc.data.markers[idx], null); }}}"
     ,"reduce" : "function(keys, values, rereduce) {  var unique_labels = {};  values.forEach(function(label) {    if(!unique_labels[label]) {     unique_labels[label] = label.length;    }  });  return unique_labels; }"

    },
     "tag":{
      "map" : "function(doc) { if(doc.data.query.length > 0) { for(var idx in doc.data.query) { emit(doc.data.query[idx], null); }}}"
 ,"reduce" : "function(keys, values, rereduce) {  var unique_labels = {};  values.forEach(function(label) {    if(!unique_labels[label]) {     unique_labels[label] = label.length;    }  });  return unique_labels; }"
    }
  }
  
}

