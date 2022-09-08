<?xml version="1.0" encoding="utf-8"?>
<!--
  Create agenda documents

  @author Adriano Akaishi
  @date 11/04/2022
  @copyright Allette Systems Pty Ltd
-->

<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main"
                exclude-result-prefixes="#all">

    <xsl:output method="xml" encoding="UTF-8" indent="yes"  />

    <xsl:template match="/">
        <xsl:variable name="cols">
            <root>
                <xsl:for-each select="root/section[@id='sheet2']/body[heading2/text() = 'search-developer-website(2)']/table/row[1]/cell">
                    <col>
                        <xsl:attribute name="pos" select="position()" />
                        <xsl:value-of select="if(contains(.,'Document Date')) then 'Publish Date' else ." />
                    </col>
                </xsl:for-each>
            </root>
        </xsl:variable>

        <xsl:variable name="data">
            <root>
              <xsl:variable name="cells" select="count($cols/root/col) + 1" />
              <xsl:for-each select="root/section/body[heading2/text() = 'search-developer-website(2)']/table[1]/row[position()>1]">
                  <document>
                      <xsl:attribute name="title" select="cell[position() = $cols/root/col[text()='Title']/@pos]/text()" />
                      <xsl:for-each select="cell[position() lt $cells]">
                          <xsl:variable name="pos" select="position()" />
                          <prop>
                              <xsl:attribute name="pos" select="position()" />
                              <xsl:attribute name="column-name" select="$cols/root/col[@pos = $pos]/text()" />
                              <xsl:value-of select="." />
                          </prop>
                      </xsl:for-each>
                  </document>
              </xsl:for-each>
            </root>
        </xsl:variable>

        <xsl:copy-of select="$data" />

        <xsl:variable name="base" select="substring-before(replace(base-uri(),'file:','file://'),'workbook.xml')" />
        <xsl:for-each select="$data/root/document">
          <xsl:variable name="pos" select="position()" />
          <xsl:variable name="date-folder" select="concat(tokenize(prop[@column-name='Publish Date']/text(),'-')[1],'/',tokenize(prop[@column-name='Publish Date']/text(),'-')[2])" />
          <xsl:variable name="date-folder-link" select="prop[@column-name='Publish Date']/text()" />
          <xsl:variable name="host-search" select="'https://data.pbs.gov.au/search/embargo.html?question='" />\
          <xsl:variable name="host-path" select="'https://dev.pbs.gov.au/content/embargo/'" />\
          <xsl:variable name="host-uriid" select="'https://dev.pbs.gov.au/ps/page/developer-website/uri/'" />
          <xsl:variable name="month" select="tokenize(prop[@column-name='Folder']/text(),'/')[last()]" />
          <xsl:variable name="filename" select="prop[@column-name='File name']/text()" />
          <xsl:variable name="uriid" select="prop[@column-name='URIID']/text()" />

          <xsl:variable name="path" select="concat($base,'final/',$date-folder,'/',$filename,'-',$pos,'.psml')" />
          <xsl:result-document href="{$path}">
              <document version="current" level="portable" type="embargo">
                  <documentinfo>
                      <uri title="{@title}" documenttype="embargo">
                          <displaytitle><xsl:value-of select="@title" /></displaytitle>
                          <labels><xsl:value-of select="'embargo'" /></labels>
                      </uri>
                  </documentinfo>
                  <fragmentinfo/>
                  <metadata>
                      <properties>
                          <xsl:for-each select="prop[not(@column-name='Title' or @column-name='Publish Date')]">
                              <property name="{lower-case(replace(@column-name,' ','_'))}" title="{@column-name}" datatype="string" value="{text()}"/>
                          </xsl:for-each>
                          <property name="url_path" title="URL-Path" datatype="string" value="{concat($host-path,$month,'/',$filename)}"/>
                          <property name="url_uriid" title="URL-URIID" datatype="string" value="{concat($host-uriid,$uriid)}"/>
                          <property name="url_uriid_link"
                                    datatype="link"
                                    title="URL-URIID(Link)">
                              <link href="{concat($host-uriid,$uriid)}" frag="default"><xsl:value-of select="$uriid" /></link>
                          </property>
                          <property name="date" title="Date" value="" datatype="date" />
                      </properties>
                  </metadata>
                  <section id="title">
                      <fragment id="1">
                          <heading level="1">
                              <xsl:value-of select="@title" />
                          </heading>
                      </fragment>
                  </section>
                  <section id="properties">
                      <properties-fragment id="2">
                          <property name="publish_date"
                                    datatype="link"
                                    title="Publish Date">
                              <link href="{concat($host-search,$date-folder-link)}" frag="default"><xsl:value-of select="$date-folder-link" /></link>
                          </property>
                          <property name="url_path_link"
                                    datatype="link"
                                    title="URL-Path(Link)">
                              <link href="{concat($host-path,$month,'/',$filename)}" frag="default"><xsl:value-of select="$filename" /></link>
                          </property>
                      </properties-fragment>
                  </section>
              </document>
          </xsl:result-document>
        </xsl:for-each>
    </xsl:template>

</xsl:stylesheet>


