module ApplicationHelper

  # Return a title on a per-page basis.
  def title
    base_title = "Aldrick &amp; Claire - Everything must go!"
    if @title.nil?
      base_title
    else
      "#{base_title} | #{@title}"
    end
  end
end

