# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery ->
       $('#schedule').dataTable({
         "sDom": '<"top"><"top><"bottom"><"center">p<"center"><"bottom"><"clear">'
         });

jQuery ->
      $('#stuclasses').dataTable({
         "order": [[ 2, "asc" ]],"sDom": '<"top">f<"top><"bottom">lp<"bottom">'
         }).columnFilter({sPlaceHolder: "head:before",aoColumns: [ {type: "select" },
                  { type: "text" },null,null,null,{type: "select" },null,null,null,{type: "text" },null,null,null
            ]});








