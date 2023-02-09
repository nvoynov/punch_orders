# domain faces generator

require_relative "domain"
require "punch"
require "erb"
include Punch

domain = build_domain
sample = DATA.read
@model = domain.services.map{|m| Factory.decorate(:service, m)}

renderer = ERB.new(sample, trim_mode: "-")
puts renderer.result

__END__

actions = ActionsHolder.object

# dummy
class Hello < Action
  action :get, "/hello"
  def call
    "Hello, World!"
  end
end
actions << Hello

<% @model.each do |model| %>
class <%= model.const %>Action < Action
<% query = model.name.match?(/^query/) -%>
<% proxy = model.name.gsub('_', '-') -%>
<% if query -%>
  include LinksHelper
  action :get, "<%= proxy %>"
<% else -%>
  action :post, "<%= proxy %>"
<% end -%>
  origin <%= model.const %>

  def arguments
<% if query -%>
    @page_number = params.fetch('page_number', '0').to_i
    @page_size = params.fetch('page_size', '25').to_i
    where = params.fetch('where', [])
    order = params.fetch('order', {})
    kwargs = {
      where: where,
      order: order,
      page_number: @page_number,
      page_size: @page_size
    }
    [[], kwargs, nil]
<% else -%>
    required = %w|<%= model.params.reject(&:default?).map{|par| "#{par.name}"}.join(' ') %>|
    missed!(required)
    kwargs = {}
<% model.params.each do |param| -%>
    <%= param.name %> = params.fetch('<%= param.name %>')
<% if param.sentry? && (!%w|string uuid|.include?(param.sentry.to_s.downcase) ) -%>
    # <%= param.name %> = coerce('<%= param.sentry %>', <%= param.name %>)
<% end -%>
    kwarg.store(:<%= param.name %>, <%= param.name %>)
<% end -%>
    kwargs.compact!
    [[], kwargs, nil]
<% end -%>
  end
<% if query -%>

  def present(result)
    data, more = result
    [data, links(more)]
  end
<% end -%>
end
actions << <%= model.const %>Action
<% end %>
