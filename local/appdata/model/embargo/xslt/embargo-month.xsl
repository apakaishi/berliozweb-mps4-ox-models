<?xml version="1.0" encoding="utf-8"?>
<!--
  This stylesheet creates the metadata document for binary files.

  @author Adriano Akaishi
  @date 03/11/2022
  @copyright Allette Systems Pty Ltd
-->

<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                exclude-result-prefixes="#all">

    <xsl:param name="title" />
    <xsl:param name="type" />
    <xsl:param name="embargo-folder" />
    <xsl:param name="publish_date" />
    <xsl:param name="publish_date_year" />
    <xsl:param name="publish_date_month" />

    <xsl:variable name="publish_date_year_folder" select="if($publish_date_month = 12) then $publish_date_year + 1 else $publish_date_year" />
    <xsl:variable name="publish_date_month_folder" select="if($publish_date_month = 12) then '01' else $publish_date_month + 1" />
    <xsl:variable name="publication-month-changed" select="if(string-length(string($publish_date_month_folder)) = 1) then concat('0',string($publish_date_month_folder)) else $publish_date_month_folder" />

    <xsl:variable name="reference-doc" select="if($type = 'simple') then 'files/resources/document.xml' else 'files/list-files.xml'" />

    <xsl:variable name="base" select="replace(replace(base-uri(),'file:', 'file://'), $reference-doc, '')" />

    <xsl:variable name="month-text" select="if($publication-month-changed = 01) then 'January'
                                        else if($publication-month-changed = 02) then 'February'
                                        else if($publication-month-changed = 03) then 'March'
                                        else if($publication-month-changed = 04) then 'April'
                                        else if($publication-month-changed = 05) then 'May'
                                        else if($publication-month-changed = 06) then 'June'
                                        else if($publication-month-changed = 07) then 'July'
                                        else if($publication-month-changed = 08) then 'August'
                                        else if($publication-month-changed = 09) then 'September'
                                        else if($publication-month-changed = 10) then 'October'
                                        else if($publication-month-changed = 11) then 'November'
                                        else if($publication-month-changed = 12) then 'December'
                                        else ''" />

    <xsl:variable name="title-doc" select="concat($month-text,' ',$publish_date_year_folder)" />
    <xsl:variable name="title-year-doc" select="$publish_date_year_folder" />
    <xsl:variable name="filename" select="concat(lower-case($month-text),'-',$publish_date_year_folder,'.psml')" />
    <xsl:variable name="filename-year" select="concat($publish_date_year_folder,'.psml')" />
    <xsl:variable name="path" select="concat($base,$embargo-folder,$publish_date_year_folder,'/',$publication-month-changed,'/',$filename)" />
    <xsl:variable name="path-year" select="concat($base,$embargo-folder,$publish_date_year_folder,'/',$filename-year)" />

    <xsl:output method="xml" encoding="UTF-8" indent="yes" />

    <xsl:template match="/">
        <xsl:value-of select="$path" />
        <xsl:value-of select="$path-year" />
        <!-- Year document -->
        <xsl:result-document href="{$path-year}">
            <document type="embargo_month" version="current" level="portable">
                <documentinfo>
                    <uri documenttype="embargo_month" title="{$title-year-doc}">
                        <displaytitle><xsl:value-of select="$title-year-doc" /></displaytitle>
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
                        <heading level="1"><xsl:value-of select="$title-year-doc" /></heading>
                        <para>
                            <bold>Page last updated:</bold>
                            <placeholder name="date">date</placeholder>
                        </para>
                    </fragment>
                </section>
                <section id="content" title="Content" fragmenttype="default,embed">
                    <fragment id="2">
                        <para>
                            <inline label="showsearchresults-embargo"><xsl:value-of select="$publish_date_year_folder" /></inline>
                        </para>
                    </fragment>
                </section>
            </document>
        </xsl:result-document>

        <!-- Month document-->
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
                <section id="title" title="Title" fragmenttype="default" overwrite="false">
                    <fragment id="1">
                        <heading level="1"><xsl:value-of select="$title-doc" /></heading>
                        <para>
                            <bold>Page last updated:</bold>
                            <placeholder name="date">date</placeholder>
                        </para>
                    </fragment>
                </section>
                <section id="content" title="Content" fragmenttype="default,embed" overwrite="false">
                    <fragment id="2">
                        <para>
                            <inline label="showsearchresults-embargo"><xsl:value-of select="concat($publish_date_year_folder, '-', $publication-month-changed)" /></inline>
                        </para>
                    </fragment>
                </section>
            </document>
        </xsl:result-document>
    </xsl:template>

</xsl:stylesheet>
