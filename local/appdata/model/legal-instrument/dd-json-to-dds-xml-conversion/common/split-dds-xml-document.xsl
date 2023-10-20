<?xml version="1.0" encoding="utf-8"?>
<!--
  This is a transformation Json document to XML

  @author Adriano Akaishi
  @date 14/09/2022
  @copyright Allette Systems Pty Ltd
-->

<xsl:stylesheet
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:xs="http://www.w3.org/2001/XMLSchema"
        xmlns:fn="http://www.w3.org/2005/xpath-functions"
        exclude-result-prefixes="xs fn" version="2.0">

    <xsl:param name="folder" />

    <xsl:variable name="base" select="substring-before(replace(base-uri(),'file:', 'file://'), '/part2-items')" />
    <xsl:variable name="output" select="concat($base,'/',$folder,'/')" />

    <xsl:output method="xml" encoding="UTF-8" indent="yes" omit-xml-declaration="yes" />

    <xsl:template match="Schedule">
        <xsl:variable name="effective-date" select="@effective_date" />
        <xsl:variable name="schedule-code"  select="@schedule_code" />
        <xsl:variable name="edition-type"  select="@edition-type" />

        <xsl:variable name="sch-path" select="concat($effective-date,'/Schedule-',$schedule-code,'/')" />
        <xsl:variable name="edition-path" select="concat($sch-path,'Edition-',$edition-type,'/')" />

        <xsl:for-each select="Item">
            <xsl:variable name="program_code" select="@program_code" />
            <xsl:variable name="pbs_code" select="@pbs_code" />
            <xsl:variable name="name" select="@li_item_id" />
            <xsl:variable name="program-path" select="concat($edition-path,'',$program_code,'/')" />
            <xsl:variable name="pbs-path" select="concat($program-path,'Items/',$pbs_code,'/')" />
            <xsl:variable name="path-xml" select="concat($output, $pbs-path, 'xml/', $name,'.xml')" />

            <xsl:result-document href="{$path-xml}">
                <Schedule>
                    <xsl:copy-of select="parent::Schedule/@*" />
                    <xsl:copy-of select="self::*" />
                </Schedule>
            </xsl:result-document>
        </xsl:for-each>
    </xsl:template>

</xsl:stylesheet>
