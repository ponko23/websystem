// Generated by CoffeeScript 1.6.3
var addMonth, deleteRecord, hiddenInput, sendRecord, showInput, tableWrite;

tableWrite = function(yearMonth) {
  $('#monthControl > p').html((yearMonth.replace('/', '年')) + '月');
  $('#monthControl > input:eq(0)').attr('onClick', 'tableWrite("' + addMonth(yearMonth, -1) + '")');
  $('#monthControl > input:eq(1)').attr('onClick', 'tableWrite("' + addMonth(yearMonth, 1) + '")');
  return $.ajax({
    url: '/timesheet/' + yearMonth.replace('/', '-'),
    dataType: 'json',
    type: 'GET',
    success: function(obj) {
      var countDay, day, daysOfMonth, i, tmp, tsData, _i;
      $('#tsTable').empty();
      tsData = [];
      tsData.push('<tbody><tr><th>入力</th><th>日付</th><th>曜日</th><th>勤怠</th><th>始業時間</th><th>終業時間</th><th>休憩時間</th><th>深夜休憩</th><th>連絡事項</th><th>承認</th></tr>');
      tmp = yearMonth.split('/');
      daysOfMonth = new Date(tmp[0], tmp[1], 0).getDate() + 1;
      i = 0;
      for (day = _i = 1; 1 <= daysOfMonth ? _i < daysOfMonth : _i > daysOfMonth; day = 1 <= daysOfMonth ? ++_i : --_i) {
        if (obj[i] && obj[i].day === day && obj[i].author) {
          tsData.push('<tr><td>〆</td>');
        } else {
          tsData.push('<tr><td onClick="showInput(\'', yearMonth, '/', day, '\')">入力</td>');
        }
        tsData.push('<td>', day, '</td>');
        countDay = new Date(tmp[0], tmp[1] - 1, day).getDay();
        tsData.push('<td>', '日月火水木金土'[countDay], '</td>');
        if (obj[i] && obj[i].day === day) {
          tsData.push('<td>', obj[i].attendance, '</td>');
          tsData.push('<td>', obj[i].opening, '</td>');
          tsData.push('<td>', obj[i].closing, '</td>');
          tsData.push('<td>', obj[i].breakTime, '</td>');
          tsData.push('<td>', obj[i].nightBreak, '</td>');
          tsData.push('<td>', obj[i].note, '</td>');
          tsData.push('<td>', obj[i].author, '</td></tr>');
          i++;
        } else {
          tsData.push('<td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr>');
        }
      }
      tsData.push('</tbody>');
      return $('#tsTable').append(tsData.join(''));
    }
  });
};

showInput = function(day) {
  $('#day').val(day);
  $('#lightbox').addClass('show');
  return $('#inputform').addClass('show');
};

hiddenInput = function() {
  $('#lightbox').removeClass('show');
  return $('#inputform').removeClass('show');
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
    data: query,
    success: function() {
      hiddenInput();
      return tableWrite(yearMonth[0] + '/' + yearMonth[1]);
    }
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
    },
    success: function() {
      hiddenInput();
      return tableWrite(yearMonth[0] + '/' + yearMonth[1]);
    }
  });
};

$(document).ready(function() {
  var tmpDate;
  tmpDate = new Date();
  return tableWrite(tmpDate.getFullYear() + '/' + (tmpDate.getMonth() + 1));
});
