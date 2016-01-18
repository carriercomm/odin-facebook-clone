module ApplicationHelper
	def include_active(expected_url)
		if current_page?(expected_url)
			"active"
		end
	end

end
