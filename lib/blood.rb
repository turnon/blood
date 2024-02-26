# frozen_string_literal: true

require_relative 'blood/version'
require 'tree_html'
require 'set'
require 'cgi'

module Blood
  def self.source(mods)
    hier = Hash.new{ |h, k| h[k] = Set.new }
    mods.each do |mod|
      ances = mod.ancestors
      ances.each_with_index do |child, i|
        parent = ances[i + 1]
        hier[parent] << child
      end
    end
    Node.new(BasicObject, hier)
  end

  class Node
    include TreeHtml

    def initialize(mod, hier)
      @mod = mod
      @hier = hier
    end

    def label_for_tree_html
      name = ::CGI.escapeHTML(@mod.to_s)
      Class === @mod ? "<span class='hl'>#{name}</span>" : name
    end

    def children_for_tree_html
      children.map{ |sub| Node.new(sub, @hier) }
    end

    def css_for_tree_html
      '.hl{color: red;}'
    end

    private

    def children
      @hier[@mod].sort_by(&:to_s)
    end
  end
end
