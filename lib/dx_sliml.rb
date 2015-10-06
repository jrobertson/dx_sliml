#!/usr/bin/env ruby

# file: dx_sliml.rb

require 'dynarex'


class DxSliml

  attr_reader :to_xslt, :to_html

  def initialize(sliml, dx)

    @dx = dx.is_a?(Dynarex) ? dx : Dynarex.new(dx)
       
    sliml.gsub!(/\{[^\}]+/) do |x|
      x.gsub(/["']?(\S*)\$(\w+)([^"']*)["']?/,'\'\1{\2}\3\'')
    end
    
    xml = LineTree.new(sliml).to_xml declaration: false, pretty: true
    
    @recxsl = xml.gsub(/\$(\w+)/, '<xsl:value-of select="\1"/>')
    
    @to_xslt = build_xslt

    xslt  = Nokogiri::XSLT(@to_xslt)
    @to_html = xslt.transform(Nokogiri::XML(@dx.to_xml))

  end


  private

  def build_xslt()

    schema = @dx.schema
    rootname, recname = schema.split('/').map{|x| x[/\w+/]}

    xml = RexleBuilder.new
    raw_a = xml.xsl_stylesheet(xmlns_xsl: \
                     "http://www.w3.org/1999/XSL/Transform", version: "1.0") do
      xml.xsl_output(method: "xml", indent: "yes", \
                                              :"omit-xml-declaration" => "yes")

      xml.xsl_template(match: rootname) do
        xml.html do
          xml.head do
            xml.title(@dx.title) if @dx.summary[:title] 
          end 
          xml.body do
            xml.header do
              xml.xsl_apply_templates(select: 'summary')
            end
            xml.main do
              xml.xsl_apply_templates(select: 'records/' + recname)
            end
          end 
        end
      end

      xml.xsl_template(match: rootname + '/summary') do
        
        xml.dl do
          xml.xsl_for_each(select: '*') do
            xml.dt do
              xml.xsl_value_of(select: 'name()')
            end
            xml.dd do
              xml.xsl_value_of(select: '.')
            end
          end
        end
      end

      xml.xsl_template(match: 'records/' + recname) do

        xml.rec_template

      end

    end

    xml2 = Rexle.new(raw_a).xml(pretty: true).gsub('xsl_apply_templates',\
        'xsl:apply-templates').gsub('xsl_value_of','xsl:value-of').\
        gsub('xsl_template','xsl:template').\
        gsub('xmlns_xsl','xmlns:xsl').gsub('xsl_for_each','xsl:for-each').\
        gsub('xsl_','xsl:')

    xml2.sub('<rec_template/>', @recxsl)
  end

end
