editOn = ->
  $('.edit').attr 'readOnly', false
  $('#profileEdit').attr
    value: '保存'
    onclick: 'editSave()'
  $('#reset').css 'display', 'block'

editSave = ->
  $('.edit').attr 'readOnly', true
  $('#profileEdit').attr
    value: '編集'
    onclick: 'editOn()'
  $('#reset').css 'display', 'none'
