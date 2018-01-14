class HelpArticlePresenter < BasePresenter
  attr_reader :content, :sections, :title

  def initialize(url, section_id="")
    @section_id = section_id
    @url = url
    @sections = Array.new
  end

  def text_to_id(str="")
    str = str.gsub(" ", "-")
    str = str.gsub(/[^0-9a-z-]/i, '')
    str.downcase
  end

  def set_title(title="")
    pp title
    @title = title
  end

  def set_section(heading="", content="")
    section_id = text_to_id(heading)
    @sections.push({
      :id => section_id,
      :heading => heading,
      :content => content,
      :url => "/%s/%s" % [@url, section_id] 
    }) 
  end

  def current_section
    section = @sections[0]
    @sections.each do |s|
      if s[:id].eql? @section_id
        section = s
      end
    end
    return section
  end

end
