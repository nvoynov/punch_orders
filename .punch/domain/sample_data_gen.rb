# domain faces generator

require_relative "domain"
require "punch"
include Punch

domain = build_domain
models = domain.services.map{|m| Factory.decorate(:service, m)}

require "erb"
require "fileutils"
include FileUtils

SAMPLE = '@@sample'.freeze
hashfu = proc{|text|
  head, *tail = text.lines
  tail.shift while tail.first == ?\n
  tail.pop(1) while tail.last == ?\n
  [head.strip, ERB.new(tail.join.strip, trim_mode: "-")]
}

samples = DATA.read
  .split(SAMPLE).map(&:strip).reject(&:empty?)
  .map(&hashfu)
  .to_h # => Hash<file, erb>

base = File.dirname(__FILE__)
dir = 'actions'

requirerb = []


models.each {|model|
  source = samples.keys[0] % {source: model.name}
  requirerb << "require_relative \"actions/#{File.basename(source, '.rb')}\""
  samples.each{|sample, renderer|
    source = sample % {source: model.name}
    loc = File.join(base, source)
    path = File.dirname(loc)
    # puts ">>> #{source}"
    @model = model
    makedirs path unless Dir.exist? path
    File.write(loc, renderer.result)
  }
}
loc = File.join(base, 'actions.rb')
File.write(loc, requirerb.join(?\n))

__END__

@@sample actions/%{source}.rb

require_relative "../config"

class <%= @model.const %>Action < Action
<% query = @model.name.match?(/^query/) -%>
<% proxy = @model.name.gsub('_', '-') -%>
<% if query -%>
  include LinksHelper
  action :get, "<%= proxy %>"
<% else -%>
  action :post, "<%= proxy %>"
<% end -%>
  origin <%= @model.const %>

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
    required = %w|<%= @model.params.reject(&:default?).map{|par| "#{par.name}"}.join(' ') %>|
    missed!(required)
    kwargs = {}
<% @model.params.each do |param| -%>
    <%= param.name %> = params.fetch('<%= param.name %>')
<% if param.sentry? && (!%w|string uuid|.include?(param.sentry.to_s.downcase) ) -%>
    # <%= param.name %> = coerce('<%= param.sentry %>', <%= param.name %>)
<% end -%>
    kwargs.store(:<%= param.name %>, <%= param.name %>)
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

ActionsHolder.object << <%= @model.const %>Action

@@sample test/actions/test_%{source}.rb

require_relative "../../test_helper"

describe <%= @model.const %>Action do
  it {
    # mock response
    # pass arguments
    # see result
  }
end
