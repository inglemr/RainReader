module SessionsHelper

	def log_in(user)
		session[:user_id] = user.id
	end

	def log_out
		forget(current_user)
		session.delete(:user_id)
		@current_user = nil
	end

	def logged_in?
		!current_user.nil?
	end

	def remember(user)
		user.remember
		cookies.permanent.signed[:user_id] = user.id
		cookies.permanent[:remember_token] = user.remember_token
	end

 	def current_user
    	if (user_id = session[:user_id])
     	 @current_user ||= User.find_by(id: user_id)
   		elsif (user_id = cookies.signed[:user_id])
      		user = User.find_by(id: user_id)
      		if user && user.authenticated?(cookies[:remember_token])
        		log_in user
       			@current_user = user
      		end
    	end
  end

  def current_user?(user)
    user == current_user
  end

  def forget(user)
  	user.forget
  	cookies.delete(:user_id)
  	cookies.delete(:remember_token)
  end

  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  def store_location
    session[:forwarding_url] = request.url if request.get?
  end


  def getSchedule(user, update = false)
    updateTime = 24.hours.ago.to_datetime
    if user.classUpdateTime
      updateTime = user.classUpdateTime
    end
    if user.gswid && user.gswpin && ((updateTime <= 24.hours.ago.to_datetime) || update)
      mechanize = Mechanize.new
      mechanize.follow_meta_refresh = true
      page = mechanize.get('https://rain.gsw.edu/prod8x/twbkwbis.P_WWWLogin')
      form = page.form('loginform')
      form.sid = current_user.gswid
      form.PIN = current_user.gswpin
      button = form.button_with(:value => 'Login')
      page = mechanize.submit(form, button)
      if page.uri.to_s == "https://rain.gsw.edu/prod8x/twbkwbis.P_ValLogin"
        current_user.s_classes.delete_all
        flash.now[:danger] = "GSW Credentials are incorrect!"
     else
      page = page.link_with(:text => 'Student Services').click
      page = page.link_with(:text => 'Registration').click
      page = page.link_with(:text => 'Concise Student Schedule').click
      tableXpath = "//table[2]/tr"
      table = page.parser.xpath(tableXpath)
      $i = 2
      begin
          classHash = Hash.new
          classHash[:CRN] = page.parser.xpath(tableXpath + '[' + $i.to_s + ']/td[1]/text()').text
          classHash[:Course] = page.parser.xpath(tableXpath + '[' + $i.to_s + ']/td[2]/text()').text
          classHash[:Title] = page.parser.xpath(tableXpath + '[' + $i.to_s + ']/td[3]/text()').text
          classHash[:Campus] = page.parser.xpath(tableXpath + '[' + $i.to_s + ']/td[4]/text()').text
          classHash[:Credits] = page.parser.xpath(tableXpath + '[' + $i.to_s + ']/td[5]/text()').text
          classHash[:StartDate] = page.parser.xpath(tableXpath + '[' + $i.to_s + ']/td[7]/text()').text
          classHash[:EndDate]= page.parser.xpath(tableXpath + '[' + $i.to_s + ']/td[8]/text()').text
          classHash[:Days] = page.parser.xpath(tableXpath + '[' + $i.to_s + ']/td[9]/text()').text
          classHash[:Time] = page.parser.xpath(tableXpath + '[' + $i.to_s + ']/td[10]/text()').text
          classHash[:Location] = page.parser.xpath(tableXpath + '[' + $i.to_s + ']/td[11]/text()').text
          classHash[:Instructor] = page.parser.xpath(tableXpath + '[' + $i.to_s + ']/td[12]/text()').text
          if user.s_classes.find_by(:CRN => classHash[:CRN])
            user.s_classes.find_by(:CRN => classHash[:CRN]).update(:CRN => classHash[:CRN],
                                        :Course =>  classHash[:Course],
                                        :Title => classHash[:Title],
                                        :Campus => classHash[:Campus],
                                        :Credits => classHash[:Credits],
                                        :StartDate => classHash[:StartDate],
                                        :EndDate => classHash[:EndDate],
                                        :Days => classHash[:Days],
                                        :Time => classHash[:Time],
                                        :Location => classHash[:Location],
                                        :Instructor => classHash[:Instructor])
          else
          @class = user.s_classes.create!(:CRN => classHash[:CRN],
                                        :Course =>  classHash[:Course],
                                        :Title => classHash[:Title],
                                        :Campus => classHash[:Campus],
                                        :Credits => classHash[:Credits],
                                        :StartDate => classHash[:StartDate],
                                        :EndDate => classHash[:EndDate],
                                        :Days => classHash[:Days],
                                        :Time => classHash[:Time],
                                        :Location => classHash[:Location],
                                        :Instructor => classHash[:Instructor])
          end
          $i += 1
      end while $i < table.size
      user.classUpdateTime = DateTime.now
      user.save
      flash.now[:notice] = "Schedule Refreshed"
      puts "worked"
    end
    else
    end
  end

  def getAllClasses()
      agent = Mechanize.new
      page = agent.get('https://rain.gsw.edu/sched201508.htm')

      page.parser.xpath("//font/table")



  end

end
