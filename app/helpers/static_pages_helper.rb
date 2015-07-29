module StaticPagesHelper
  def getSchedule
    mechanize = Mechanize.new
    mechanize.follow_meta_refresh = true
    page = mechanize.get('https://rain.gsw.edu/prod8x/twbkwbis.P_WWWLogin')
    form = page.form('loginform')
    form.sid = current_user.gswid
    form.PIN = current_user.gswpin
    button = form.button_with(:value => 'Login')
    page = mechanize.submit(form, button)
    page = page.link_with(:text => 'Student Services').click
    page = page.link_with(:text => 'Registration').click
    page = page.link_with(:text => 'Concise Student Schedule').click
    table = page.parser.xpath('//table/tbody/tr[2]')
    details = table.collect do |row|
      detail = {}
      [
        [:title, 'td[3]/text()']
      ].each do |name, xpath|
    row.at_xpath(xpath).to_s
    page.title
    end
    end
  end
end
