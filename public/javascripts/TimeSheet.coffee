tableWrite = (yearMonth) ->
  monthControl = $('#monthControl')
  monthControl.children('p').html (yearMonth.replace '/', '年') + '月'

  $.ajax(
    url: '/timesheet/' + yearMonth.replace '/', '-'
    dataType: 'json'
    type: 'GET'
  ).done (obj)->
    $('#tsTable').empty()
    tsData = []
    tsData.push '<tbody><tr><th width="5%">入力</th><th width="5%">日付</th><th width="5%">曜日</th><th width="10%">勤怠</th><th width="10%">始業時間</th><th width="10%">終業時間</th><th width="10%">休憩時間</th><th width="10%">深夜休憩</th><th>連絡事項</th><th width="10%">承認</th></tr>'
    tmp = yearMonth.split '/'
    daysOfMonth = new Date(tmp[0], tmp[1], 0).getDate() + 1
    i = 0
    for day in [1...daysOfMonth]
      current = obj[i]
      countDay = new Date(tmp[0], tmp[1]-1, day).getDay() # Date.monthが0~11なので-1して指定する
      subData = ['<td>', day, '</td>', '<td>', ('日月火水木金土')[countDay], '</td>'].join ''

      if current && current.day is day
        if current.author
          tsData.push '<tr><td>〆</td>'
        else
          tsData.push '<tr><td class="addRecord">入力</td>' # 入力ボタン
        tsData.push subData
        tsData.push '<td>', current.attendance, '</td>' # 勤怠
        tsData.push '<td>', current.opening, '</td>' # 始業時間
        tsData.push '<td>', current.closing, '</td>' # 終業時間
        tsData.push '<td>', current.breakTime, '</td>' # 休憩時間
        tsData.push '<td>', current.nightBreak, '</td>' # 深夜休憩時間
        tsData.push '<td>', current.note, '</td>' # 連絡事項
        tsData.push '<td>', current.author, '</td></tr>' # 承認
        i++
      else
        tsData.push '<tr><td class="addRecord">入力</td>', subData, '<td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr>'
    tsData.push '</tbody>'
    $('#tsTable').append tsData.join ''

    # 土日祝日にも色を付けたほうがいいかな？

    today = new Date()
    thisYearMonth = today.getFullYear() + '/' + (today.getMonth() + 1)
    if thisYearMonth is yearMonth
      $('#tsTable tbody tr').eq(today.getDate()).css 'background-color', '#aaffaa'

showInput = (day) ->
  $('#day').val day
  $('#lightbox, #inputform').addClass 'show'

hiddenInput = ->
  $('#lightbox, #inputform').removeClass 'show'
  $('.optional').val ''
  $('#inputform select option').eq(0).attr 'selected', '出勤'

addMonth = (yearMonth, addmon) ->
  tmpArray = yearMonth.split '/'
  tmp = parseInt(tmpArray[0]) * 12 + parseInt(tmpArray[1]) + parseInt(addmon)
  tmpArray[1] = tmp % 12
  tmpArray[1] = 12 if parseInt(tmpArray[1]) is 0
  tmpArray[0] = (tmp - parseInt(tmpArray[1])) / 12
  $('#yearMonth').val tmpArray.join '/'
  return tmpArray.join '/'

sendRecord = ->
  yearMonth = $('#day').val().split '/'
  query =
    day: $('#day').val()
    attendance: $('#attendance').val()

  query['opening'] = $('#opening').val() if $('#opening').val()
  query['closing'] = $('#closing').val() if $('#closing').val()
  query['breakTime'] = $('#breakTime').val() if $('#breakTime').val()
  query['nightBreak'] = $('#nightBreak').val() if $('#nightBreak').val()
  query['note'] = $('#note').val() if $('#note').val()

  $.ajax(
    type: 'post'
    url: '/timesheet/'
    data: query
  ).done ->
    hiddenInput()
    tableWrite yearMonth[0] + '/' + yearMonth[1]

deleteRecord = ->
  yearMonth = $('#day').val().split '/'
  $.ajax(
    type: 'post'
    url: '/timesheet/'
    data:
      day: $('#day').val()
      delFlag: true
  ).done ->
    hiddenInput()
    tableWrite yearMonth[0] + '/' + yearMonth[1]

$ ->
  tmpDate = new Date()
  yearMonth = tmpDate.getFullYear() + '/' + (tmpDate.getMonth() + 1)
  $('#yearMonth').val yearMonth
  tableWrite yearMonth

  $('#backMonth').on 'click', ->
    tableWrite addMonth($('#yearMonth').val(), -1)

  $('#nextMonth').on 'click', ->
    tableWrite addMonth($('#yearMonth').val(), 1)

  $('#tsTable').on 'click', '.addRecord', ->
    showInput(yearMonth + '/' + $(@).next().text())

###
  2013/8/2 一旦完成
  2013/8/20 onClick=""を排除、その他リファクタリング
###