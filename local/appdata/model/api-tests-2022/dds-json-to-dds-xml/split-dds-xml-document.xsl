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

    <xsl:param name="schedule-code" />
    <xsl:param name="folder" />
    <xsl:param name="edition-type" />

    <xsl:variable name="base" select="replace(replace(base-uri(),'file:', 'file://'), 'data-processed/full-items-document.xml', '')" />
    <xsl:variable name="output" select="concat($base,$folder,'/')" />
    <xsl:variable name="sch-path" select="concat('Schedule-',$schedule-code,'/')" />
    <xsl:variable name="edition-path" select="concat($sch-path,'Edition-',$edition-type,'/')" />

    <xsl:output method="xml" encoding="UTF-8" indent="yes" omit-xml-declaration="yes" />

    <xsl:template match="Schedule">

        <xsl:for-each select="Item">
            <xsl:variable name="PROGRAM_CODE" select="@PROGRAM_CODE" />
            <xsl:variable name="PBS_CODE" select="@PBS_CODE" />
            <xsl:variable name="name" select="@LI_ITEM_ID" />
            <xsl:variable name="program-path" select="concat($edition-path,'',$PROGRAM_CODE,'/')" />
            <xsl:variable name="pbs-path" select="concat($program-path,'Items/',$PBS_CODE,'/')" />
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
