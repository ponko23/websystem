// Generated by CoffeeScript 1.6.3
var editOn, editSave;

editOn = function() {
  $('.edit').attr('readOnly', false);
  $('#profileEdit').attr({
    value: '保存',
    onclick: 'editSave()'
  });
  return $('#reset').css('display', 'block');
};

editSave = function() {
  $('.edit').attr('readOnly', true);
  $('#profileEdit').attr({
    value: '編集',
    onclick: 'editOn()'
  });
  return $('#reset').css('display', 'none');
};
