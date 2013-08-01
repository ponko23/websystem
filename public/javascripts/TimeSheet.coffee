tableWrite = (yearMonth) ->
  $('#monthControl > p').html (yearMonth.replace '/', '年') + '月'
  $('#monthControl > input:eq(0)').attr 'onClick', 'tableWrite("' + addMonth(yearMonth, -1) + '")'
  $('#monthControl > input:eq(1)').attr 'onClick', 'tableWrite("' + addMonth(yearMonth, 1) + '")'

  $.ajax
    url: '/timesheet/' + yearMonth.replace '/', '-'
    dataType: 'json'
    type: 'GET'
    success: (obj) ->
      $('#tsTable').empty()
      tsData = []
      tsData.push '<tbody><tr><th>入力</th><th>日付</th><th>曜日</th><th>勤怠</th><th>始業時間</th><th>終業時間</th><th>休憩時間</th><th>深夜休憩</th><th>連絡事項</th><th>承認</th></tr>'
      tmp = yearMonth.split '/'
      daysOfMonth = new Date(tmp[0], tmp[1], 0).getDate() + 1
      i = 0
      for day in [1...daysOfMonth]
        if obj[i] && obj[i].day is day && obj[i].author
          tsData.push '<tr><td>〆</td>'
        else
          tsData.push '<tr><td onClick="showInput(\'', yearMonth, '/', day, '\')">入力</td>' #/ 入力ボタン
        tsData.push '<td>', day, '</td>' ## 日付
        countDay = new Date(tmp[0], tmp[1]-1, day).getDay() # Date.monthが0~11なので-1して指定する
        tsData.push '<td>', ('日月火水木金土')[countDay], '</td>' # 曜日
        if obj[i] && obj[i].day is day
          tsData.push '<td>', obj[i].attendance, '</td>' # 勤怠
          tsData.push '<td>', obj[i].opening, '</td>' # 始業時間
          tsData.push '<td>', obj[i].closing, '</td>' # 終業時間
          tsData.push '<td>', obj[i].breakTime, '</td>' # 休憩時間
          tsData.push '<td>', obj[i].nightBreak, '</td>' # 深夜休憩時間
          tsData.push '<td>', obj[i].note, '</td>' # 連絡事項
          tsData.push '<td>', obj[i].author, '</td></tr>' # 承認
          i++
        else
          tsData.push '<td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr>'
      tsData.push '</tbody>'
      $('#tsTable').append tsData.join ''

showInput = (day) ->
  $('#day').val day
  $('#lightbox').addClass 'show'
  $('#inputform').addClass 'show'

hiddenInput = () ->
  $('#lightbox').removeClass 'show'
  $('#inputform').removeClass 'show'

addMonth = (yearMonth, addmon) ->
  tmpArray = yearMonth.split '/'
  tmp = parseInt(tmpArray[0]) * 12 + parseInt(tmpArray[1]) + parseInt(addmon)
  tmpArray[1] = tmp % 12
  tmpArray[1] = 12 if parseInt(tmpArray[1]) is 0
  tmpArray[0] = (tmp - parseInt(tmpArray[1])) / 12
  return tmpArray.join '/'

sendRecord = () ->
  yearMonth = $('#day').val().split '/'
  query =
    day: $('#day').val()
    attendance: $('#attendance').val()
  if $('#opening').val()
    query['opening'] = $('#opening').val()
  if $('#closing').val()
    query['closing'] = $('#closing').val()
  if $('#breakTime').val()
    query['breakTime'] = $('#breakTime').val()
  if $('#nightBreak').val()
    query['nightBreak'] = $('#nightBreak').val()
  if $('#note').val()
    query['note'] = $('#note').val()

  $.ajax
    type: 'post'
    url: '/timesheet/'
    data: query
    success: () ->
      hiddenInput()
      tableWrite yearMonth[0] + '/' + yearMonth[1]

deleteRecord = () ->
  yearMonth = $('#day').val().split '/'
  $.ajax
    type: 'post'
    url: '/timesheet/'
    data:
      day: $('#day').val()
      delFlag: true
    success: () ->
      hiddenInput()
      tableWrite yearMonth[0] + '/' + yearMonth[1]

$(document).ready ->
  tmpDate = new Date()
  tableWrite tmpDate.getFullYear() + '/' + (tmpDate.getMonth() + 1)