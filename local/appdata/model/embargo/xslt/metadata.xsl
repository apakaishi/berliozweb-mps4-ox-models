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
    <xsl:param name="data_type" />
    <xsl:param name="metadata-folder" />
    <xsl:param name="publish_date" />
    <xsl:param name="current_date" />
    <xsl:param name="current_date_year" />
    <xsl:param name="original_file" />

    <xsl:variable name="base" select="replace(replace(base-uri(),'file:', 'file://'), 'files/resources/document.xml', '')" />
    <xsl:variable name="path" select="concat($base,$metadata-folder,$original_file,'.psml')" />

    <xsl:variable name="label" select="if($data_type = '' or $data_type = '_chemoc') then 'restricted,embargo' else 'restricted'" />
    <xsl:variable name="description" select="if($data_type = '_chemoc') then 'Chemotherapy'
                                    else if($data_type = '_sqlite') then 'SQLite'
                                    else if($data_type = '_offline') then 'Offline API' else ''" />

    <xsl:output method="xml" encoding="UTF-8" indent="yes" />

    <xsl:template match="/">

        <xsl:result-document href="{$path}">
            <document version="current" level="metadata">
                <documentinfo>
                    <uri title="{$title}">
                        <displaytitle><xsl:value-of select="$title" /></displaytitle>
                        <description><xsl:value-of select="$description" /></description>
                        <labels><xsl:value-of select="$label" /></labels>
                    </uri>
                </documentinfo>
                <fragmentinfo/>
                <metadata>
                    <properties>
                        <property name="year" title="Year" datatype="select" value="{$current_date_year}"/>
                        <property name="year_month" title="Month (YYYY-MM)" value="{$current_date}"/>
                        <property name="publish_date" title="Publish Date" datatype="date" value="{$publish_date}"/>
                    </properties>
                </metadata>
            </document>
        </xsl:result-document>
    </xsl:template>

</xsl:stylesheet>
