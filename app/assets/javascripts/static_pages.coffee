# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery ->
        $('#stuclasses').dataTable()
         bJQueryUI: true
         bProcessing: true
         bServerSide: true
         sAjaxSource: $('#s_classes').data('source')
