// Generated by CoffeeScript 1.6.3
var addMonth, deleteRecord, hiddenInput, sendRecord, showInput, tableWrite;

tableWrite = function(yearMonth) {
  var monthControl;
  monthControl = $('#monthControl');
  monthControl.children('p').html((yearMonth.replace('/', '年')) + '月');
  return $.ajax({
    url: '/timesheet/' + yearMonth.replace('/', '-'),
    dataType: 'json',
    type: 'GET'
  }).done(function(obj) {
    var countDay, current, day, daysOfMonth, i, subData, thisYearMonth, tmp, today, tsData, _i;
    $('#tsTable').empty();
    tsData = [];
    tsData.push('<tbody><tr><th width="5%">入力</th><th width="5%">日付</th><th width="5%">曜日</th><th width="10%">勤怠</th><th width="10%">始業時間</th><th width="10%">終業時間</th><th width="10%">休憩時間</th><th width="10%">深夜休憩</th><th>連絡事項</th><th width="10%">承認</th></tr>');
    tmp = yearMonth.split('/');
    daysOfMonth = new Date(tmp[0], tmp[1], 0).getDate() + 1;
    i = 0;
    for (day = _i = 1; 1 <= daysOfMonth ? _i < daysOfMonth : _i > daysOfMonth; day = 1 <= daysOfMonth ? ++_i : --_i) {
      current = obj[i];
      countDay = new Date(tmp[0], tmp[1] - 1, day).getDay();
      subData = ['<td>', day, '</td>', '<td>', '日月火水木金土'[countDay], '</td>'].join('');
      if (current && current.day === day) {
        if (current.author) {
          tsData.push('<tr><td>〆</td>');
        } else {
          tsData.push('<tr><td class="addRecord">入力</td>');
        }
        tsData.push(subData);
        tsData.push('<td>', current.attendance, '</td>');
        tsData.push('<td>', current.opening, '</td>');
        tsData.push('<td>', current.closing, '</td>');
        tsData.push('<td>', current.breakTime, '</td>');
        tsData.push('<td>', current.nightBreak, '</td>');
        tsData.push('<td>', current.note, '</td>');
        tsData.push('<td>', current.author, '</td></tr>');
        i++;
      } else {
        tsData.push('<tr><td class="addRecord">入力</td>', subData, '<td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr>');
      }
    }
    tsData.push('</tbody>');
    $('#tsTable').append(tsData.join(''));
    today = new Date();
    thisYearMonth = today.getFullYear() + '/' + (today.getMonth() + 1);
    if (thisYearMonth === yearMonth) {
      return $('#tsTable tbody tr').eq(today.getDate()).css('background-color', '#aaffaa');
    }
  });
};

showInput = function(day) {
  $('#day').val(day);
  return $('#lightbox, #inputform').addClass('show');
};

hiddenInput = function() {
  $('#lightbox, #inputform').removeClass('show');
  $('.optional').val('');
  return $('#inputform select option').eq(0).attr('selected', '出勤');
};

addMonth = function(yearMonth, addmon) {
  var tmp, tmpArray;
  tmpArray = yearMonth.split('/');
  tmp = parseInt(tmpArray[0]) * 12 + parseInt(tmpArray[1]) + parseInt(addmon);
  tmpArray[1] = tmp % 12;
  if (parseInt(tmpArray[1]) === 0) {
    tmpArray[1] = 12;
  }
  tmpArray[0] = (tmp - parseInt(tmpArray[1])) / 12;
  $('#yearMonth').val(tmpArray.join('/'));
  return tmpArray.join('/');
};

sendRecord = function() {
  var query, yearMonth;
  yearMonth = $('#day').val().split('/');
  query = {
    day: $('#day').val(),
    attendance: $('#attendance').val()
  };
  if ($('#opening').val()) {
    query['opening'] = $('#opening').val();
  }
  if ($('#closing').val()) {
    query['closing'] = $('#closing').val();
  }
  if ($('#breakTime').val()) {
    query['breakTime'] = $('#breakTime').val();
  }
  if ($('#nightBreak').val()) {
    query['nightBreak'] = $('#nightBreak').val();
  }
  if ($('#note').val()) {
    query['note'] = $('#note').val();
  }
  return $.ajax({
    type: 'post',
    url: '/timesheet/',
    data: query
  }).done(function() {
    hiddenInput();
    return tableWrite(yearMonth[0] + '/' + yearMonth[1]);
  });
};

deleteRecord = function() {
  var yearMonth;
  yearMonth = $('#day').val().split('/');
  return $.ajax({
    type: 'post',
    url: '/timesheet/',
    data: {
      day: $('#day').val(),
      delFlag: true
    }
  }).done(function() {
    hiddenInput();
    return tableWrite(yearMonth[0] + '/' + yearMonth[1]);
  });
};

$(function() {
  var tmpDate, yearMonth;
  tmpDate = new Date();
  yearMonth = tmpDate.getFullYear() + '/' + (tmpDate.getMonth() + 1);
  $('#yearMonth').val(yearMonth);
  tableWrite(yearMonth);
  $('#backMonth').on('click', function() {
    return tableWrite(addMonth($('#yearMonth').val(), -1));
  });
  $('#nextMonth').on('click', function() {
    return tableWrite(addMonth($('#yearMonth').val(), 1));
  });
  return $('#tsTable').on('click', '.addRecord', function() {
    return showInput(yearMonth + '/' + $(this).next().text());
  });
});

/*
  2013/8/2 一旦完成
  2013/8/20 onClick=""を排除、その他リファクタリング
*/

