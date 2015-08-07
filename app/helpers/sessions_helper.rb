module SessionsHelper

	def log_in(user)
		session[:user_id] = user.id
	end

	def log_out
		forget(current_user)
		session.delete(:user_id)
		@current_user = nil
	end

  def is_number? string
    true if Float(string) rescue false
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
            stuClass = SClass.find_by(:CRN => classHash[:CRN])
            stuClass.update(:Course =>  classHash[:Course],
                                        :Title => classHash[:Title],
                                        :Campus => classHash[:Campus],
                                        :Credits => classHash[:Credits],
                                        :StartDate => classHash[:StartDate],
                                        :EndDate => classHash[:EndDate],
                                        :Days => classHash[:Days],
                                        :Time => classHash[:Time],
                                        :Location => classHash[:Location],
                                        :Instructor => classHash[:Instructor])
            stuClass.save
            user.s_classes << stuClass
            user.save
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
      allClasses = SClass.all
      class_array = []
      update_array = []
     agent = Mechanize.new
     page = agent.get('https://rain.gsw.edu/sched201508.htm')
     $y = 1
      begin
        repeat = "font/" * $y
        xpath = "//body/"+ repeat +"table/tr"
        table = page.parser.xpath(xpath)
        $i = 1
          begin
            classHash = Hash.new
            closed =  page.parser.xpath(xpath + "[" + $i.to_s + "]/td[1]/b").text.strip #closed or not
            if closed == 'C'
              classHash[:open] = "Closed"
            else
              classHash[:open] = "Open"
            end

            classHash[:CRN] = page.parser.xpath(xpath + "[" + $i.to_s + "]/td[2]").text.strip
            classHash[:course_code] = page.parser.xpath(xpath + "[" + $i.to_s + "]/td[3]").text.strip
            classHash[:course_num] = page.parser.xpath(xpath + "[" + $i.to_s + "]/td[4]").text.strip
            classHash[:Title] = page.parser.xpath(xpath + "[" + $i.to_s + "]/td[5]").text.strip
            classHash[:term] = page.parser.xpath(xpath + "[" + $i.to_s + "]/td[6]").text.strip
            if classHash[:term] == "1"
              classHash[:term] = "Full"
            elsif classHash[:term] == "2"
              classHash[:term] = "First Half"
            elsif classHash[:term] == "3"
              classHash[:term] = "Second Half"
            elsif classHash[:term] == "I"
              classHash[:term] = "Full"
            end
            classHash[:Credits] = page.parser.xpath(xpath + "[" + $i.to_s + "]/td[7]").text.strip
            classHash[:open_seats] = page.parser.xpath(xpath + "[" + $i.to_s + "]/td[8]").text.strip
            classHash[:tot_seats] = page.parser.xpath(xpath + "[" + $i.to_s + "]/td[9]").text.strip
            classHash[:Days] = page.parser.xpath(xpath + "[" + $i.to_s + "]/td[10]").text.strip
            classHash[:Time] = page.parser.xpath(xpath + "[" + $i.to_s + "]/td[11]").text.strip
            if classHash[:Time] == ""
              classHash[:Time] = "Online"
            end
            classHash[:Location] = page.parser.xpath(xpath + "[" + $i.to_s + "]/td[12]").text.strip
            classHash[:Instructor] = page.parser.xpath(xpath + "[" + $i.to_s + "]/td[13]").text.strip

              tempClass = {:CRN => classHash[:CRN],
                                        :open => classHash[:open],
                                        :course_num => classHash[:course_num],
                                        :course_code => classHash[:course_code],
                                        :Title => classHash[:Title],
                                        :term => classHash[:term],
                                        :Credits => classHash[:Credits],
                                        :open_seats => classHash[:open_seats],
                                        :tot_seats => classHash[:tot_seats],
                                        :Days => classHash[:Days],
                                        :Time => classHash[:Time],
                                        :Location => classHash[:Location],
                                        :Instructor => classHash[:Instructor]}
              class_array.push tempClass




           $i += 1
          end while $i < (table.size + 1)
      $y += 1
    end while 0 < page.parser.xpath(xpath).size

    lastCRN = "";
    ActiveRecord::Base.transaction do
      class_array.each do |a|
        if allClasses.exists?(:CRN => a[:CRN])
          allClasses.find_by(:CRN => a[:CRN]).update(:CRN => a[:CRN],
                                        :open => a[:open],
                                        :course_num => a[:course_num],
                                        :course_code => a[:course_code],
                                        :Title => a[:Title],
                                        :term => a[:term],
                                        :Credits => a[:Credits],
                                        :open_seats => a[:open_seats],
                                        :tot_seats => a[:tot_seats],
                                        :Days => a[:Days],
                                        :Time => a[:Time],
                                        :Location => a[:Location],
                                        :Instructor => a[:Instructor])
        elsif is_number?(a[:CRN])
          SClass.create(a)
        end
        if is_number?(a[:CRN]) == false
              labClass = SClass.find_by(:CRN => lastCRN)
              if labClass
                labClass.update(:lab_time => a[:Time],
                              :lab_loc => a[:Location],
                              :loc_prof => a[:Instructor],
                              :lab_day => a[:Days])
                lastCRN = ""
              end
        else
          lastCRN = a[:CRN]
        end

    end
  end
end


def updateClassListIfNeeded()
   if SClass.all.size == 0 || SClass.first.updated_at > 5.minutes.ago.to_datetime
      getAllClasses()
    end
  end

end
