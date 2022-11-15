<?xml version="1.0" encoding="utf-8"?>
<!--
  This stylesheet create embargo month documents since 01-2012

  @author Adriano Akaishi
  @date 03/11/2022
  @copyright Allette Systems Pty Ltd
-->

<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                exclude-result-prefixes="#all">

    <xsl:param name="title" />
    <xsl:param name="embargo-folder" />
    <xsl:param name="publish_date" />
    <xsl:param name="publish_date_year" />
    <xsl:param name="publish_date_month" />

    <xsl:variable name="publish_date_year_folder" select="if($publish_date_month = 12) then $publish_date_year + 1 else $publish_date_year" />
    <xsl:variable name="publish_date_month_folder" select="if($publish_date_month = 12) then '01' else $publish_date_month + 1" />
    <xsl:variable name="publication-month-changed" select="if(string-length(string($publish_date_month_folder)) = 1) then concat('0',string($publish_date_month_folder)) else $publish_date_month_folder" />

    <xsl:variable name="month-actual" select="if($publication-month-changed = 01) then 1
                                        else if($publication-month-changed = 02) then 2
                                        else if($publication-month-changed = 03) then 3
                                        else if($publication-month-changed = 04) then 4
                                        else if($publication-month-changed = 05) then 5
                                        else if($publication-month-changed = 06) then 6
                                        else if($publication-month-changed = 07) then 7
                                        else if($publication-month-changed = 08) then 8
                                        else if($publication-month-changed = 09) then 9
                                        else if($publication-month-changed = 10) then 10
                                        else if($publication-month-changed = 11) then 11
                                        else if($publication-month-changed = 12) then 12
                                        else ''"/>

    <xsl:variable name="base" select="replace(replace(base-uri(),'file:', 'file://'), 'files/resources/document.xml', '')" />

    <xsl:output method="xml" encoding="UTF-8" indent="yes" />

    <xsl:template match="/">
        <root>
            <xsl:for-each select="2012 to $publish_date_year_folder">
            <xsl:variable name="year-value" select="." />

            <xsl:variable name="title-doc-year" select="$year-value" />
            <xsl:variable name="filename-year" select="concat($year-value,'.psml')" />
            <xsl:variable name="publish_date_year" select="$year-value" />
            <xsl:variable name="path-year" select="concat($base,$embargo-folder,$year-value,'/',$filename-year)" />

            <xsl:result-document href="{$path-year}">
                <document type="embargo_month" version="current" level="portable">
                    <documentinfo>
                        <uri documenttype="embargo_month" title="{$title-doc-year}">
                            <displaytitle><xsl:value-of select="$title-doc-year" /></displaytitle>
                            <labels>restricted</labels>
                        </uri>
                    </documentinfo>
                    <fragmentinfo/>
                    <metadata>
                        <properties>
                            <property name="date" title="Date" value="{$publish_date}" datatype="date"/>
                        </properties>
                    </metadata>
                    <section id="title" title="Title" fragmenttype="default">
                        <fragment id="1">
                            <heading level="1"><xsl:value-of select="$title-doc-year" /></heading>
                            <para>
                                <bold>Page last updated:</bold>
                                <placeholder name="date">date</placeholder>
                            </para>
                        </fragment>
                    </section>
                    <section id="content" title="Content" fragmenttype="default,embed">
                        <fragment id="2">
                            <para>
                                <inline label="showsearchresults-embargo"><xsl:value-of select="$publish_date_year" /></inline>
                            </para>
                        </fragment>
                    </section>
                </document>
            </xsl:result-document>

            <xsl:variable name="month-analysis" select="if($year-value = $publish_date_year_folder) then $month-actual else 12" />
            <xsl:for-each select="1 to $month-analysis">
                <xsl:variable name="month-value" select="." />
                <xsl:variable name="month-data" select="if(string-length(string($month-value)) = 1) then concat('0',$month-value) else $month-value" />
                <xsl:variable name="month-text" select="if($month-value = 1) then 'January'
                                                            else if($month-value = 2) then 'February'
                                                            else if($month-value = 3) then 'March'
                                                            else if($month-value = 4) then 'April'
                                                            else if($month-value = 5) then 'May'
                                                            else if($month-value = 6) then 'June'
                                                            else if($month-value = 7) then 'July'
                                                            else if($month-value = 8) then 'August'
                                                            else if($month-value = 9) then 'September'
                                                            else if($month-value = 10) then 'October'
                                                            else if($month-value = 11) then 'November'
                                                            else 'December'" />

                <xsl:variable name="title-doc" select="concat($month-text,' ',$year-value)" />
                <xsl:variable name="filename" select="concat(lower-case($month-text),'-',$year-value,'.psml')" />
                <xsl:variable name="publish_date_year_month" select="concat($year-value,'-',$month-data)" />
                <xsl:variable name="path" select="concat($base,$embargo-folder,$year-value,'/',$month-data,'/',$filename)" />

                <test><xsl:value-of select="$path" /></test>

                <xsl:result-document href="{$path}">
                    <document type="embargo_month" version="current" level="portable">
                        <documentinfo>
                            <uri documenttype="embargo_month" title="{$title-doc}">
                                <displaytitle><xsl:value-of select="$title-doc" /></displaytitle>
                                <labels>restricted</labels>
                            </uri>
                        </documentinfo>
                        <fragmentinfo/>
                        <metadata>
                            <properties>
                                <property name="date" title="Date" value="{$publish_date}" datatype="date"/>
                            </properties>
                        </metadata>
                        <section id="title" title="Title" fragmenttype="default">
                            <fragment id="1">
                                <heading level="1"><xsl:value-of select="$title-doc" /></heading>
                                <para>
                                    <bold>Page last updated:</bold>
                                    <placeholder name="date">date</placeholder>
                                </para>
                            </fragment>
                        </section>
                        <section id="content" title="Content" fragmenttype="default,embed">
                            <fragment id="2">
                                <para>
                                    <inline label="showsearchresults-embargo"><xsl:value-of select="$publish_date_year_month" /></inline>
                                </para>
                            </fragment>
                        </section>
                    </document>
                </xsl:result-document>

            </xsl:for-each>
        </xsl:for-each>
        </root>
    </xsl:template>

</xsl:stylesheet>
