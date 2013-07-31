# CoffeeScript
$ ->  
  #URIを切り分けて配列を作成、不要要素を削除、配列が空ならホームにいる
  aryUri = location.pathname.split('/')
  #現在地を取得
  currentUrl = aryUri.pop()
  currentUrl = aryUri.pop() if currentUrl is "" || currentUrl is "index.html"
  return if currentUrl is ""
  #LINKに使う基準URLを生成
  myUrl = "http://#{location.host}/"
  #ナビゲーション文字を設定
  mono = ' > '

  pankuzu = []
  pankuzu.push mono
  aryUri.shift()
  for i in aryUri
    myUrl += "#{i}/"
    xhr = new XMLHttpRequest()
    xhr.open 'GET', myUrl, false
    xhr.send(null)
    while xhr.readyState isnt 4 && xhr.status isnt 200
      continue
    #タイトルタグの間のの文字列を取得する
    titleScr = /<title>(.*)<\/title>/
    titleStr = titleScr.exec(xhr.responseText)[1]
    pankuzu.push "<a href=\"#{myUrl}\">", titleStr, "</a>", mono
  pankuzu.push $('title').html()
  $('#pankuzu').append pankuzu.join ''

slideview = () ->
  $('#inputform').addclass('show')
  