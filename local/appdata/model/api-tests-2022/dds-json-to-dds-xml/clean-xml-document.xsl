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
        exclude-result-prefixes="xs fn" version="3.0">

    <xsl:output indent="yes" omit-xml-declaration="yes" />

    <xsl:variable name="base" select="replace(replace(base-uri(),'file:', 'file://'), 'files/list-files.xml', '')" />
    <xsl:variable name="base-input" select="concat($base,'xml/')" />
    <xsl:variable name="folder-xml-cleaned" select="concat($base,'/xml-data/')" />

    <xsl:output method="xml" encoding="UTF-8" indent="yes" />

    <xsl:template match="files">
        <root>
            <xsl:for-each select="file">
                <xsl:variable name="filename-input" select="concat(substring-before(tokenize(@short-path,'/')[last()],'.json'),'.xml')" />
                <xsl:variable name="path" select="document(concat($base-input,$filename-input))" />
                <xsl:variable name="filename" select="substring-before(tokenize(@short-path,'/')[last()],'.json')" />
                <xsl:variable name="element-name" select="if($filename = 'items') then 'Item'
                                                            else if($filename = 'schedules') then 'Schedule'
                                                            else if($filename = 'items-restrictions-relationships') then 'ItemRestrictionRltd'
                                                            else if($filename = 'items-prescribing-text-relationships') then 'ItemPrescribingTxtRltd'
                                                            else if($filename = 'restrictions') then 'RestrictionText'
                                                            else if($filename = 'restrictions-prescribing-text-relationships') then 'RstrctnPrscrbngTxtRltd'
                                                            else if($filename = 'prescribing-text') then 'PrescribingTxt'
                                                            else if($filename = 'criteria') then 'Criteria'
                                                            else if($filename = 'criteria-parameters-relationships') then 'CriteriaParameterRltd'
                                                            else if($filename = 'indications') then 'Indication'
                                                            else $filename" />

                <xsl:apply-templates select="$path" mode="full">
                    <xsl:with-param name="element-name" select="$element-name" />
                </xsl:apply-templates>
            </xsl:for-each>
        </root>
    </xsl:template>

    <xsl:template match="fn:array">
        <xsl:param name="element-name" />
        <root>
            <xsl:apply-templates select="*">
                <xsl:with-param name="element-name" select="$element-name" />
            </xsl:apply-templates>
        </root>
    </xsl:template>

    <xsl:template match="fn:array" mode="full">
        <xsl:param name="element-name" />
        <xsl:element name="{$element-name}">
            <xsl:apply-templates select="*" mode="full" />
        </xsl:element>
    </xsl:template>

    <xsl:template match="fn:map">
        <xsl:param name="element-name" />
        <xsl:element name="{$element-name}">
            <xsl:apply-templates />
        </xsl:element>
    </xsl:template>

    <xsl:template match="fn:map" mode="full">
        <element>
            <xsl:apply-templates />
        </element>
    </xsl:template>

    <xsl:template match="fn:number|fn:string">
        <xsl:if test="not(@key = 'EFFECTIVE_YEAR')">
            <xsl:element name="{@key}">
                <xsl:value-of select="." />
            </xsl:element>
        </xsl:if>
    </xsl:template>

    <xsl:template match="fn:null">
        <xsl:choose>
            <xsl:when test="@key = 'MAXIMUM_PRESCRIBABLE_PACK' or @key = 'NUMBER_OF_REPEATS' or @key = 'MANUFACTURER_CODE' or @key = 'PACK_SIZE'">
                <xsl:element name="{@key}">
                    <xsl:value-of select="0" />
                </xsl:element>
            </xsl:when>
            <xsl:otherwise></xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="text()" />

</xsl:stylesheet>
