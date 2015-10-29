class SClass < ActiveRecord::Base
  has_and_belongs_to_many :users



  def updateSchedule

  end

def self.deleteAll()
    SClass.delete_all
  end

 def self.getAllClasses()
      allClasses = SClass.all
      class_array = []
      update_array = []
     agent = Mechanize.new
     page = agent.get('https://rain.gsw.edu/sched201602.htm')
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
          SClass.find_by(:CRN => a[:CRN]).update(:CRN => a[:CRN],
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
        elsif SClass.validCRN?(a[:CRN])
          SClass.create(a)
        end
        if SClass.validCRN?(a[:CRN]) == false
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

def SClass.validCRN? string
    true if Float(string) rescue false
end

end
