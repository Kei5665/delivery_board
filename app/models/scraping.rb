class Scraping
  require 'mechanize'

  agent = Mechanize.new
  page = agent.get("https://www.walkerplus.com/event_list/ar0313106/taito/")
  elements = page.search('.m-mainlist-item__img')
  urls = []

  # aタグをすべて抽出し詳細ページのURLを抽出
  elements.each do |ele|
    urls << ele.get_attribute(:href)
  end

  # 抽出した詳細ページURLにアクセスし、データ取得
  urls.each do |url|

    page = agent.get(url)
    detail_page = agent.get(url + "data.html")
    price_page = agent.get(url + "price.html")

    title = detail_page.at('.m-detailheader-heading__ttl')&.inner_text
    place = detail_page.at('/html/body/div/div[1]/main/section[1]/div[4]/table/tr[1]/td')&.inner_text&.gsub(/[\r\n]/,"")&.gsub(" ", "")&.delete("[地図]")
    date = detail_page.at('/html/body/div/div[1]/main/section[1]/div[4]/table/tr[3]/td')&.inner_text&.gsub(/[\r\n]/,"")&.gsub(" ", "")
    time = detail_page.at('/html/body/div/div[1]/main/section[1]/div[4]/table/tr[4]/td')&.inner_text&.gsub(/[\r\n]/,"")&.gsub(" ", "")
    address = detail_page.at('/html/body/div/div[1]/main/section[1]/div[4]/table/tr[7]/td')&.inner_text&.gsub(/[\r\n]/,"")&.gsub(" ", "")
    price = price_page.at('.m-infotable__td')&.inner_text
    body = page.search('/html/body/div[1]/div[1]/main/section[1]/div[3]/div[2]/div[2]/p')&.inner_text&.gsub(/[\r\n]/,"")&.gsub(" ", "")

    p "#{detail_page.at('.m-detailheader-heading__ttl')&.inner_text}"
    p "#{detail_page.at('/html/body/div/div[1]/main/section[1]/div[4]/table/tr[1]/td')&.inner_text&.gsub(/[\r\n]/,"")&.gsub(" ", "")&.delete("[地図]")}"
    p "#{detail_page.at('/html/body/div/div[1]/main/section[1]/div[4]/table/tr[3]/td')&.inner_text&.gsub(/[\r\n]/,"")&.gsub(" ", "")}"
    p "#{detail_page.at('/html/body/div/div[1]/main/section[1]/div[4]/table/tr[4]/td')&.inner_text&.gsub(/[\r\n]/,"")&.gsub(" ", "")}"
    p "#{detail_page.at('/html/body/div/div[1]/main/section[1]/div[4]/table/tr[7]/td')&.inner_text&.gsub(/[\r\n]/,"")&.gsub(" ", "")}"
    p "#{price_page.at('.m-infotable__td')&.inner_text}"
    p "#{page.search('/html/body/div[1]/div[1]/main/section[1]/div[3]/div[2]/div[2]/p')&.inner_text&.gsub(/[\r\n]/,"")&.gsub(" ", "")}"

    post = Post.new
    post.title = title
    post.place = place
    post.date = date
    post.time = time
    post.address = address
    post.price = price
    post.body = body
    post.save!
  end
end