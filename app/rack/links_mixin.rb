# frozen_string_literal: true

# Links mixin for craeating links section of response
module LinksMixin
  Links = Struct.new(:page_number, :page_size, :this, :first, :prev, :next)

  def links(more)
    ptrn = "#{@request.path_info}?page_number=%i?page_size=#{@page_size}"
    Links.new(@page_number, @page_size).tap{|links|
      links.first= ptrn % 0
      links.this = ptrn % @page_number
      links.prev = ptrn % (@page_number - 1) if @page_number > 0
      links.next = ptrn % (@page_number + 1) if more
    }.to_h.reject{|_,v| v.nil?}
  end
end
