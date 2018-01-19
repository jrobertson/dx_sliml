#!/usr/bin/env ruby

# file: dx_sliml.rb

require 'dynarex'


class DxSliml

  attr_reader :to_xslt, :to_html, :to_xml

  def initialize(sliml=nil, dynarex=nil, dx: dynarex, fields: nil)

    
    if sliml.nil? and fields.nil? then
      
      if dx then
        
        @dx = dx.is_a?(Dynarex) ? dx : Dynarex.new(dx)    
        # fetch the fields from the schema
        fields = @dx.schema[/\(([^\)]+)/,1].split(/,\s/)
        
      else
        raise 'RxSliml: please enter a sliml string or an array of fields'
      end
      
    else
      @dx = dx.is_a?(Dynarex) ? dx : Dynarex.new(dx)    
    end
    
    
    
    sliml ||= create_sliml(fields)
    @sliml = sliml    
       
    sliml.gsub!(/\{[^\}]+/) do |x|
      x.gsub(/["']?(\S*)\$(\w+)([^"']*)["']?/,'\'\1{\2}\3\'')
    end
    
    xml = LineTree.new(sliml).to_xml declaration: false, pretty: true
    
    @recxsl = xml.gsub(/\$(\w+)/, '<xsl:value-of select="\1"/>')
    
    @to_xslt = build_html_xslt
    xml_xslt = build_xml_xslt

    #jr190316 xslt  = Nokogiri::XSLT(@to_xslt)
    #jr190316 @to_html = xslt.transform(Nokogiri::XML(@dx.to_xml))
    @to_html = Rexslt.new(@to_xslt, dx.to_xml).to_s
    @to_xml = Rexslt.new(xml_xslt, dx.to_xml).to_xml

  end

  def to_sliml()
    
    @sliml
    
  end


  private

  def build_html_xslt()

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
  
  def build_xml_xslt()

    schema = @dx.schema
    rootname, recname = schema.split('/').map{|x| x[/\w+/]}

    xml = RexleBuilder.new
    raw_a = xml.xsl_stylesheet(xmlns_xsl: \
                     "http://www.w3.org/1999/XSL/Transform", version: "1.0") do
      xml.xsl_output(method: "xml", indent: "yes", \
                                              :"omit-xml-declaration" => "yes")

      xml.xsl_template(match: rootname) do

              xml.xsl_apply_templates(select: 'records/' + recname)

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
  
  def create_sliml(fields)
    
    lines = ['dl']
    lines << fields.map {|field| "  dt %s:\n  dd $%s\n" % ([field.to_s]*2) }
    lines.join("\n")
    
  end  

end