<?xml version="1.0" encoding="utf-8"?>
<!--
  This stylesheet creates the metadata document for binary files.

  @author Adriano Akaishi
  @date 03/11/2022
  @copyright Allette Systems Pty Ltd
-->

<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" exclude-result-prefixes="#all">

  <xsl:param name="title" />
  <xsl:param name="data_type" />
  <xsl:param name="type" />
  <xsl:param name="embargo-folder" />
  <xsl:param name="current_date" />
  <xsl:param name="current_date_year" />
  <xsl:param name="current_date_month" />

  <xsl:variable name="publish_date" select="format-date(current-date(), '[Y0001]-[M01]-[D01]')"/>

  <xsl:variable name="reference-doc" select="if($type = 'simple') then 'files/resources/document.xml' else 'files/list-files.xml'" />

  <xsl:variable name="base" select="replace(replace(base-uri(),'file:', 'file://'), $reference-doc, '')" />

  <xsl:variable name="month-text" select="if($current_date_month = 01) then 'January'
                                        else if($current_date_month = 02) then 'February'
                                        else if($current_date_month = 03) then 'March'
                                        else if($current_date_month = 04) then 'April'
                                        else if($current_date_month = 05) then 'May'
                                        else if($current_date_month = 06) then 'June'
                                        else if($current_date_month = 07) then 'July'
                                        else if($current_date_month = 08) then 'August'
                                        else if($current_date_month = 09) then 'September'
                                        else if($current_date_month = 10) then 'October'
                                        else if($current_date_month = 11) then 'November'
                                        else if($current_date_month = 12) then 'December'
                                        else ''" />

  <xsl:variable name="title-doc" select="concat($month-text,' ',$current_date_year)" />
  <xsl:variable name="title-year-doc" select="$current_date_year" />
  <xsl:variable name="filename" select="concat(lower-case($month-text),'-',$current_date_year,'.psml')" />
  <xsl:variable name="filename-year" select="concat($current_date_year,'.psml')" />
  <xsl:variable name="path" select="concat($base,$embargo-folder,$current_date_year,'/',$current_date_month,'/',$filename)" />
  <xsl:variable name="path-year" select="concat($base,$embargo-folder,$current_date_year,'/',$filename-year)" />

  <xsl:output method="xml" encoding="UTF-8" indent="yes" />

  <xsl:template match="/">

    <!-- Year document -->
    <xsl:result-document href="{$path-year}">
      <document type="embargo_year" version="current" level="portable">
        <documentinfo>
          <uri documenttype="embargo_year" title="{$title-year-doc}">
            <displaytitle>
              <xsl:value-of select="$title-year-doc" />
            </displaytitle>
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
            <heading level="1">
              <xsl:value-of select="$title-year-doc" />
            </heading>
            <para>
              <bold>Page last updated:</bold>
              <placeholder name="date">date</placeholder>
            </para>
          </fragment>
        </section>
        <section id="content" title="Content" fragmenttype="default,embed">
          <fragment id="2">
            <para>Please select a month to see the Embargo files</para>
          </fragment>
        </section>
      </document>
    </xsl:result-document>

    <!-- Month document-->
    <xsl:result-document href="{$path}">
      <document type="embargo_month" version="current" level="portable">
        <documentinfo>
          <uri documenttype="embargo_month" title="{$title-doc}">
            <displaytitle>
              <xsl:value-of select="$title-doc" />
            </displaytitle>
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
            <heading level="1">
              <xsl:value-of select="$title-doc" />
            </heading>
            <para>
              <bold>Page last updated:</bold>
              <placeholder name="date">date</placeholder>
            </para>
          </fragment>
        </section>
        <section id="content" title="Content" fragmenttype="default,embed" overwrite="false">
          <fragment id="2">
            <para>--- Add references to files here ---</para>
          </fragment>
          <fragment id="3">
            <para>
              <xref frag="default" docid="api-beta-document" display="document" config="default" type="none" labels="no-publication" urititle="PBS API Beta" urilabels="restricted" mediatype="application/vnd.pageseeder.psml+xml" documenttype="default">PBS API Beta</xref>
              <br/>
              <xref frag="default" docid="api-sqlite-document" display="document" config="default" type="none" labels="no-publication" urititle="PBS SQLite Beta" urilabels="restricted" mediatype="application/vnd.pageseeder.psml+xml" documenttype="default">PBS SQLite Beta</xref>
            </para>
          </fragment>
        </section>
      </document>
    </xsl:result-document>

  </xsl:template>

</xsl:stylesheet>
