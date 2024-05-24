# frozen_string_literal: true

require_relative 'blood/version'
require 'tree_html'
require 'set'
require 'cgi'

module Blood
  def self.source(mods)
    hier = Hash.new{ |h, k| h[k] = Set.new }
    mods.each do |mod|
      # maybe [Class, [Module, Module], ...]
      ances = mod.ancestors.reduce([]) do |arr, a|
        next arr << a if Class === a
        arr << Modules.new unless Modules === arr[-1]
        arr[-1].add(a)
        arr
      end
      ances.each_with_index do |child, i|
        parent = ances[i + 1]
        hier[parent] << child
      end
    end
    Node.new(BasicObject, hier)
  end

  class Modules
    def add(mod)
      (@mods ||= []) << mod
    end

    def to_s
      @to_s ||= (@mods.count == 1 ? @mods[0].to_s : @mods.to_s)
    end

    alias_method :name, :to_s

    def hash
      to_s.hash
    end

    def eql?(other)
      to_s.eql?(other.to_s)
    end
  end

  class Node
    include TreeHtml

    def initialize(mod, hier)
      @mod = mod
      @hier = hier
    end

    def label_for_tree_html
      name = ::CGI.escapeHTML(@mod.name || @mod.to_s)
      Class === @mod ? "<span class='hl'>#{name}</span>" : name
    end

    NORMAL_NAME = /^[A-Z][A-Za-z0-9]*(::[A-Z][A-Za-z0-9]*)*$/

    if Module.method_defined?(:const_source_location)
      alias_method :raw_label_for_tree_html, :label_for_tree_html

      def label_for_tree_html
        return raw_label_for_tree_html if Modules === @mod
        return raw_label_for_tree_html unless @mod.name =~ NORMAL_NAME
        loc = Module.const_source_location(@mod.name)
        return raw_label_for_tree_html unless loc
        loc = ::CGI.escapeHTML(loc.join(':'))
        "#{raw_label_for_tree_html} <span class='sd'>#{loc}</span>"
      end
    end

    def children_for_tree_html
      children.map{ |sub| Node.new(sub, @hier) }
    end

    def css_for_tree_html
      '.hl{color: #cc342d;} .sd{color: #9e9e9e;}'
    end

    private

    def children
      @hier[@mod].sort_by(&:to_s)
    end
  end
end
