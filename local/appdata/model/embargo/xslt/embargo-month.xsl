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
    <xsl:param name="embargo-folder" />
    <xsl:param name="publish_date" />
    <xsl:param name="publish_date_year" />
    <xsl:param name="publish_date_month" />

    <xsl:variable name="base" select="replace(replace(base-uri(),'file:', 'file://'), 'files/resources/document.xml', '')" />

    <xsl:variable name="month" select="tokenize($publish_date_month,'-')[last()]" />
    <xsl:variable name="month-text" select="if($month = '01') then 'January'
                                        else if($month = '02') then 'February'
                                        else if($month = '03') then 'March'
                                        else if($month = '04') then 'April'
                                        else if($month = '05') then 'May'
                                        else if($month = '06') then 'June'
                                        else if($month = '07') then 'July'
                                        else if($month = '08') then 'August'
                                        else if($month = '09') then 'September'
                                        else if($month = '10') then 'October'
                                        else if($month = '11') then 'November'
                                        else 'December'" />

    <xsl:variable name="title-doc" select="concat($month-text,' ',$publish_date_year)" />
    <xsl:variable name="filename" select="concat(lower-case($month-text),'-',$publish_date_year,'.psml')" />
    <xsl:variable name="path" select="concat($base,$embargo-folder,$filename)" />

    <xsl:output method="xml" encoding="UTF-8" indent="yes" />

    <xsl:template match="/">
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
                            <inline label="showsearchresults-embargo"><xsl:value-of select="$publish_date_month" /></inline>
                        </para>
                    </fragment>
                </section>
            </document>
        </xsl:result-document>
    </xsl:template>

</xsl:stylesheet>
