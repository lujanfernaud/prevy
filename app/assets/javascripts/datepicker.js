// Code needed for Bootstrap 3 Datepicker.
// https://eonasdan.github.io/bootstrap-datetimepicker/

$(function () {
    $('#datetimepicker1').datetimepicker({
        format: 'dddd, MMMM D, YYYY - HH:mm'
    });
    $('#datetimepicker2').datetimepicker({
        format: 'dddd, MMMM D, YYYY - HH:mm',
        useCurrent: false //Important! See issue #1075
    });
    $("#datetimepicker1").on("dp.change", function (e) {
        $('#datetimepicker2').data("DateTimePicker").minDate(e.date);
    });
    $("#datetimepicker2").on("dp.change", function (e) {
        $('#datetimepicker1').data("DateTimePicker").maxDate(e.date);
    });
});
