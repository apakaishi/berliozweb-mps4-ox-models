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
        <xsl:for-each select="$data/root/document[ends-with(prop[@column-name='Folder'], concat('/embargo/',prop[@column-name='Publish Date']))
                or ends-with(prop[@column-name='Folder'], concat('/embargo/',tokenize(prop[@column-name='Publish Date'],'-')[1],'-',tokenize(prop[@column-name='Publish Date'],'-')[2]))]">
         <!--   <xsl:variable name="pos" select="position()" /> -->
            <xsl:variable name="date-folder" select="concat(tokenize(prop[@column-name='Publish Date']/text(),'-')[1],'/',tokenize(prop[@column-name='Publish Date']/text(),'-')[2])" />
            <xsl:variable name="filename" select="prop[@column-name='File name']/text()" />
            <xsl:variable name="Publish_Date" select="prop[@column-name='Publish Date']/text()" />
            <xsl:variable name="publish_date_year" select="tokenize(prop[@column-name='Publish Date']/text(),'-')[1]" />
            <xsl:variable name="publish_date_month" select="tokenize(prop[@column-name='Publish Date']/text(),'-')[2]" />

            <xsl:variable name="path" select="concat($base,'final/META-INF/',$date-folder,'/',$filename,'.psml')" />

            <xsl:result-document href="{$path}">
                <document version="current" level="metadata">
                    <documentinfo>
                        <uri title="{@title}">
                            <displaytitle><xsl:value-of select="@title" /></displaytitle>
                            <labels>restricted</labels>
                        </uri>
                    </documentinfo>
                    <fragmentinfo/>
                    <metadata>
                        <properties>
                            <property name="year" title="Year" datatype="select" value="{$publish_date_year}"/>
                            <property name="year_month" title="Month (YYYY-MM)" value="{concat($publish_date_year,'-',$publish_date_month)}"/>
                            <property name="publish_date" title="Publish Date" datatype="date" value="{$Publish_Date}"/>
                        </properties>
                    </metadata>
                </document>
            </xsl:result-document>

        </xsl:for-each>
    </xsl:template>

</xsl:stylesheet>


