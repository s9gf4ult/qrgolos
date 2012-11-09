module SectionsHelper
  def activate_section_twitt(twitt)
    tid = if twitt.is_a?(Twitt); then twitt.id else twitt end
    "/sections/twitt/#{tid}/activate"
  end
end
