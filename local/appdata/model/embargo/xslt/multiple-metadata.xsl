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
    <xsl:param name="description" />
    <xsl:param name="metadata-folder" />
    <xsl:param name="publish_date" />
    <xsl:param name="publish_date_year" />
    <xsl:param name="publish_date_month" />
    <xsl:param name="original_file" />

    <xsl:variable name="publish_date_year_folder" select="if($publish_date_month = 12) then $publish_date_year + 1 else $publish_date_year" />
    <xsl:variable name="publish_date_month_folder" select="if($publish_date_month = 12) then '01' else $publish_date_month + 1" />
    <xsl:variable name="publication-month-changed" select="if(string-length(string($publish_date_month_folder)) = 1) then concat('0',string($publish_date_month_folder)) else $publish_date_month_folder" />

    <xsl:variable name="base" select="replace(replace(base-uri(),'file:', 'file://'), 'files/list-files.xml', '')" />

    <xsl:output method="xml" encoding="UTF-8" indent="yes" />

    <xsl:template match="files">

        <xsl:for-each select="file">
            <xsl:variable name="short-path" select="translate(@short-path,'/','\')" />
            <xsl:variable name="filename" select="tokenize($short-path,'\\')[last()]" />
            <xsl:variable name="path" select="concat($base,$metadata-folder,$publish_date_year_folder,'/',$publication-month-changed,'/',$filename,'.psml')" />

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
                            <property name="year" title="Year" datatype="select" value="{$publish_date_year_folder}"/>
                            <property name="year_month" title="Month (YYYY-MM)" value="{concat($publish_date_year_folder,'-',$publication-month-changed)}"/>
                            <property name="publish_date" title="Publish Date" datatype="date" value="{$publish_date}"/>
                        </properties>
                    </metadata>
                </document>
            </xsl:result-document>
        </xsl:for-each>
    </xsl:template>

</xsl:stylesheet>
