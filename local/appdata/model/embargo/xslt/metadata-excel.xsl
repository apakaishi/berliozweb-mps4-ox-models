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
                <xsl:for-each select="root/section[@id='sheet2']/body[heading2/text() = '2019-test']/table/row[1]/cell">
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
                <xsl:for-each select="root/section/body[heading2/text() = '2019-test']/table[1]/row[position()>1]">
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
        <root>
            <xsl:attribute name="count" select="count($data/root/document)" />
            <xsl:for-each select="$data/root/document">
                <xsl:variable name="title" select="if(normalize-space(prop[@column-name='title']/text())='#N/A') then '' else prop[@column-name='title']/text()" />
                <xsl:variable name="filename" select="prop[@column-name='Name']/text()" />
                <xsl:variable name="description" select="prop[@column-name='Description']/text()" />
                <xsl:variable name="short-path" select="substring-after(prop[@column-name='Path']/text(),'data_site_embargo\')" />
                <xsl:variable name="date_year" select="prop[@column-name='Year']/text()" />
                <xsl:variable name="date_month-count" select="string-length(prop[@column-name='Month']/text())" />
                <xsl:variable name="date_month" select="if($date_month-count = 1) then concat('0', prop[@column-name='Month']/text()) else prop[@column-name='Month']/text()" />
                <xsl:variable name="publication" select="normalize-space(translate(translate(replace(lower-case(normalize-space(prop[@column-name='publication']/text())),'update',''),'&#40;',''),'&#41;',''))"/>
                <xsl:variable name="simulate-publication-year" select="if(prop[@column-name='Month']/text() = '1') then $date_year - 1 else $date_year" />
                <xsl:variable name="simulate-publication-month" select="if(prop[@column-name='Month']/text() = '1') then '12' else prop[@column-name='Month']/text() - 1" />
                <xsl:variable name="simulate-publication-month-formatted" select="if(string-length(string($simulate-publication-month)) = 1) then concat('0',$simulate-publication-month) else $simulate-publication-month" />
                <xsl:variable name="simulate-publication" select="concat($simulate-publication-year,'-',$simulate-publication-month-formatted,'-01')" />

                <xsl:variable name="publication-day" select="if(string-length(tokenize(substring-after($publication,'published '),' ')[1]) = 1) then concat('0',tokenize(substring-after($publication,'published '),' ')[1]) else tokenize(substring-after($publication,'published '),' ')[1]" />
                <xsl:variable name="publication-month" select="tokenize(substring-after($publication,'published '),' ')[2]" />
                <xsl:variable name="publication-year" select="tokenize(substring-after($publication,'published '),' ')[3]" />

                <xsl:variable name="month-text" select="if($publication-month = 'january') then '01'
                                        else if($publication-month = 'february') then '02'
                                        else if($publication-month = 'march') then '03'
                                        else if($publication-month = 'april') then '04'
                                        else if($publication-month = 'may') then '05'
                                        else if($publication-month = 'june') then '06'
                                        else if($publication-month = 'july') then '07'
                                        else if($publication-month = 'august') then '08'
                                        else if($publication-month = 'september') then '09'
                                        else if($publication-month = 'october') then '10'
                                        else if($publication-month = 'november') then '11'
                                        else if($publication-month = 'december') then '12'
                                        else ''" />

                <xsl:variable name="publication-text" select="concat($publication-year,'-',$month-text,'-',$publication-day)" />

                <xsl:variable name="validation-data-publication" select="if($publication = '#n/a') then $simulate-publication else $publication-text" />

                <xsl:variable name="date-folder" select="$short-path" />

                <xsl:variable name="path" select="concat($base,'final/META-INF/',$date-folder,'/',$filename,'.psml')" />

                <xsl:result-document href="{$path}">
                    <document version="current" level="metadata">
                        <documentinfo>
                            <uri title="{$title}">
                                <displaytitle><xsl:value-of select="$title" /></displaytitle>
                                <description><xsl:value-of select="$description" /></description>
                                <labels>restricted</labels>
                            </uri>
                        </documentinfo>
                        <fragmentinfo/>
                        <metadata>
                            <properties>
                                <property name="year" title="Year" datatype="select" value="{$date_year}"/>
                                <property name="year_month" title="Month (YYYY-MM)" value="{concat($date_year,'-',$date_month)}"/>
                                <property name="publish_date" title="Publish Date" datatype="date" value="{$validation-data-publication}"/>
                            </properties>
                        </metadata>
                    </document>
                </xsl:result-document>

            </xsl:for-each>
        </root>

    </xsl:template>

</xsl:stylesheet>


