class FailureSection < SitePrism::Section
  element   :name,      '.jasmine-description a'
  elements  :messages,  '.jasmine-messages .jasmine-result-message'

  def to_s
    "#{name.text} : #{messages.map(&:text).join("\n")}"
  end
end

class JasminePage < SitePrism::Page
  set_url            "/SpecRunner.html"
  set_url_matcher  %r(/SpecRunner.html)

  element  :finished_time, '.jasmine-duration'

  sections :failures, FailureSection, '.jasmine-spec-detail.jasmine-failed'

  def finished?
    finished_time.text.include? 'finished in'
  end
end


