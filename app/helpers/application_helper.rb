module ApplicationHelper
	def full_title(page_title= "")
		base_title = "Rain Reader"
		if(page_title.empty?)
			return base_title
		else
			return page_title + " | " + base_title
		end
	end
end
