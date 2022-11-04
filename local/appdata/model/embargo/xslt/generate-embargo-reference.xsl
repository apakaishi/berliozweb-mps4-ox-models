<?xml version="1.0" encoding="utf-8"?>
<!--
  This stylesheet creates reference document add n

  @author Adriano Akaishi
  @date 03/11/2022
  @copyright Allette Systems Pty Ltd
-->

<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                exclude-result-prefixes="#all">

    <xsl:param name="title" />
    <xsl:param name="type" />
    <xsl:param name="embargo-folder" />
    <xsl:param name="xref-folder" select="'/ps/data_source/website/website/embargo/'" />
    <xsl:param name="embargo-path" />
    <xsl:param name="publish_date" />
    <xsl:param name="publish_date_year" />
    <xsl:param name="publish_date_month" />
    <xsl:param name="original_file" />

    <xsl:variable name="reference-doc" select="if($type = 'simple') then 'files/resources/document.xml' else 'files/list-files.xml'" />

    <xsl:variable name="base" select="replace(replace(base-uri(),'file:', 'file://'), $reference-doc, '')" />
    <xsl:variable name="path" select="concat($base,$embargo-path)" />

    <xsl:variable name="title-content" select="'Embargo Content Archive'"/>
    <xsl:variable name="months" select="tokenize($publish_date_month,'/')[last()]" />
    <xsl:variable name="month-actual" select="if($months = '01') then 1
                                        else if($months = '02') then 2
                                        else if($months = '03') then 3
                                        else if($months = '04') then 4
                                        else if($months = '05') then 5
                                        else if($months = '06') then 6
                                        else if($months = '07') then 7
                                        else if($months = '08') then 8
                                        else if($months = '09') then 9
                                        else if($months = '10') then 10
                                        else if($months = '11') then 11
                                        else 12"/>

    <xsl:output method="xml" encoding="UTF-8" indent="yes" />

    <xsl:template match="/">
        <xsl:result-document href="{$path}">
            <document type="references" version="current" level="portable">
                <documentinfo>
                    <uri documenttype="references" title="{$title-content}">
                        <displaytitle><xsl:value-of select="$title-content" /></displaytitle>
                        <labels>restricted</labels>
                    </uri>
                    <publication id="embargo-content-archive" hostid="1" rooturiid="102458" title="Embargo Content Archive" defaultgroupid="24" type="default"/>
                </documentinfo>
                <metadata/>
                <section id="title" overwrite="false">
                    <fragment id="1">
                        <heading level="1"><xsl:value-of select="$title-content" /></heading>
                    </fragment>
                </section>
                <toc/>
                <section id="xrefs" edit="false">
                    <xref-fragment id="2">
                        <xsl:for-each select="2012 to $publish_date_year">
                            <xsl:sort select="." data-type="number" order="descending"/>
                             <xsl:variable name="year-value" select="." />

                            <xsl:variable name="title-doc-year" select="$year-value" />
                            <xsl:variable name="filename-year" select="concat($year-value,'.psml')" />
                            <xsl:variable name="publish_date_year" select="$year-value" />
                            <xsl:variable name="path-year" select="concat($xref-folder,$year-value,'/',$filename-year)" />

                            <blockxref frag="default" reversefrag="2" reversetitle="References" reverselink="true" reversetype="none" display="document"
                                       config="default" type="embed" href="{$path-year}"
                                       urititle="{$title-doc-year}" urilabels="restricted" mediatype="application/vnd.pageseeder.psml+xml"
                                       documenttype="embargo_month"><xsl:value-of select="$publish_date_year" /></blockxref>

                            <xsl:variable name="month-analysis" select="if($year-value = $publish_date_year) then $month-actual else 12" />
                            <xsl:for-each select="1 to $month-analysis">
                                <xsl:sort select="." data-type="number" order="descending"/>
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
                                <xsl:variable name="path" select="concat($xref-folder,$year-value,'/',$month-data,'/',$filename)" />

                                <blockxref frag="default" reversefrag="2" reversetitle="References" reverselink="true" reversetype="none" display="document"
                                           level="1" type="embed" href="{$path}"
                                           urititle="{$title-doc}" urilabels="restricted" mediatype="application/vnd.pageseeder.psml+xml"
                                           documenttype="embargo_month"><xsl:value-of select="$publish_date_year_month" /></blockxref>

                            </xsl:for-each>
                        </xsl:for-each>
                    </xref-fragment>
                </section>
            </document>
        </xsl:result-document>
    </xsl:template>

</xsl:stylesheet>
