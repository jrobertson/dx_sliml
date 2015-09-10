# Transforming a Dynarex document to HTML using the DxSliml gem

    require 'dx_sliml'


    s = <<EOF
    dl
      dt from:
      dd $from

      dt to:
      dd $to

      dt subject:
      dd $subject
    EOF

    s2 =<<EOF
    <?dynarex schema='email[title]/messages(from, to, subject)' delimiter='#'?>
    title: Email for James
    -----------------------

    abc@ruby132.org     # james@jamesrobertson.eu # test 123
    info@gtdtoday.co.uk # james@jamesrobertson.eu # How to plan ahead (newsletter)
    a123456@aol.com     # info@jamesrobertson.eu  # hello

    EOF


    d = DxSliml.new s, Dynarex.new.import(s2)
    puts d.to_xslt
    puts d.to_html


XSLT output:

<pre>
&lt;?xml version='1.0' encoding='UTF-8'?&gt;
&lt;xsl:stylesheet xmlns:xsl='http://www.w3.org/1999/XSL/Transform' version='1.0'&gt;
  &lt;xsl:output method='xml' indent='yes' omit-xml-declaration='yes'/&gt;
  &lt;xsl:template match='email'&gt;
    &lt;html&gt;
      &lt;head&gt;
        &lt;title&gt;Email for James&lt;/title&gt;
      &lt;/head&gt;
      &lt;body&gt;
        &lt;header&gt;
          &lt;xsl:apply-templates select='summary'/&gt;
        &lt;/header&gt;
        &lt;main&gt;
          &lt;xsl:apply-templates select='records/messages'/&gt;
        &lt;/main&gt;
      &lt;/body&gt;
    &lt;/html&gt;
  &lt;/xsl:template&gt;
  &lt;xsl:template match='email/summary'&gt;
    &lt;dl&gt;
      &lt;xsl:for-each select='*'&gt;
        &lt;dt&gt;
          &lt;xsl:value-of select='name()'/&gt;
        &lt;/dt&gt;
        &lt;dd&gt;
          &lt;xsl:value-of select='.'/&gt;
        &lt;/dd&gt;
      &lt;/xsl:for-each&gt;
    &lt;/dl&gt;
  &lt;/xsl:template&gt;
  &lt;xsl:template match='records/messages'&gt;
    &lt;dl&gt;
  &lt;dt&gt;from:&lt;/dt&gt;
  &lt;dd&gt;&lt;xsl:value-of select="from"/&gt;&lt;/dd&gt;
  &lt;dt&gt;to:&lt;/dt&gt;
  &lt;dd&gt;&lt;xsl:value-of select="to"/&gt;&lt;/dd&gt;
  &lt;dt&gt;subject:&lt;/dt&gt;
  &lt;dd&gt;&lt;xsl:value-of select="subject"/&gt;&lt;/dd&gt;
&lt;/dl&gt;
  &lt;/xsl:template&gt;
&lt;/xsl:stylesheet&gt;
</pre>

HTML output:

<pre>
&lt;?xml version="1.0"?&gt;
&lt;html&gt;
  &lt;head&gt;
    &lt;title&gt;Email for James&lt;/title&gt;
  &lt;/head&gt;
  &lt;body&gt;
    &lt;header&gt;
      &lt;dl&gt;
        &lt;dt&gt;title&lt;/dt&gt;
        &lt;dd&gt;Email for James&lt;/dd&gt;
        &lt;dt&gt;recordx_type&lt;/dt&gt;
        &lt;dd&gt;dynarex&lt;/dd&gt;
        &lt;dt&gt;format_mask&lt;/dt&gt;
        &lt;dd&gt;[!from] [!to] [!subject]&lt;/dd&gt;
        &lt;dt&gt;schema&lt;/dt&gt;
        &lt;dd&gt;email[title]/messages(from, to, subject)&lt;/dd&gt;
        &lt;dt&gt;default_key&lt;/dt&gt;
        &lt;dd&gt;from&lt;/dd&gt;
      &lt;/dl&gt;
    &lt;/header&gt;
    &lt;main&gt;
      &lt;dl&gt;
        &lt;dt&gt;from:&lt;/dt&gt;
        &lt;dd&gt;abc@ruby132.org&lt;/dd&gt;
        &lt;dt&gt;to:&lt;/dt&gt;
        &lt;dd&gt;james@jamesrobertson.eu test 123&lt;/dd&gt;
        &lt;dt&gt;subject:&lt;/dt&gt;
        &lt;dd/&gt;
      &lt;/dl&gt;
      &lt;dl&gt;
        &lt;dt&gt;from:&lt;/dt&gt;
        &lt;dd&gt;info@gtdtoday.co.uk&lt;/dd&gt;
        &lt;dt&gt;to:&lt;/dt&gt;
        &lt;dd&gt;james@jamesrobertson.eu&lt;/dd&gt;
        &lt;dt&gt;subject:&lt;/dt&gt;
        &lt;dd&gt;How to plan ahead (newsletter)&lt;/dd&gt;
      &lt;/dl&gt;
      &lt;dl&gt;
        &lt;dt&gt;from:&lt;/dt&gt;
        &lt;dd&gt;a123456@aol.com&lt;/dd&gt;
        &lt;dt&gt;to:&lt;/dt&gt;
        &lt;dd&gt;info@jamesrobertson.eu&lt;/dd&gt;
        &lt;dt&gt;subject:&lt;/dt&gt;
        &lt;dd&gt;hello&lt;/dd&gt;
      &lt;/dl&gt;
    &lt;/main&gt;
  &lt;/body&gt;
&lt;/html&gt;
</pre>

## Resources

* dx_sliml https://rubygems.org/gems/dx_sliml

dxsliml dynarex html xslt
