<?xml version="1.0" encoding="utf-8"?>
<!--
  This is a report documents following the analysis of PBS XML v2

  @author Adriano Akaishi
  @date 21/02/2023
  @copyright Allette Systems Pty Ltd
-->

<xsl:stylesheet
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:xs="http://www.w3.org/2001/XMLSchema"
        xmlns:fn="http://www.w3.org/2005/xpath-functions"
        exclude-result-prefixes="xs fn" version="2.0">


    <xsl:output method="xml" encoding="UTF-8" indent="yes" omit-xml-declaration="yes" />

    <xsl:template match="Schedule">
        <xsl:text>[</xsl:text>

        <xsl:for-each select="Item">
            <xsl:text>{</xsl:text>

            <xsl:for-each select="@*">
                <xsl:text>"</xsl:text><xsl:value-of select="local-name()" /><xsl:text>": "</xsl:text><xsl:value-of select="." /><xsl:text>",</xsl:text>
            </xsl:for-each>
            <xsl:text>"MP_CONCEPT_ID": "</xsl:text><xsl:value-of select="amt-items[CONCEPT_TYPE_CODE='MP']/PBS_CONCEPT_ID" /><xsl:text>",</xsl:text>
            <xsl:text>"MP_AMT_CODE": "</xsl:text><xsl:value-of select="amt-items[CONCEPT_TYPE_CODE='MP']/AMT_CODE" /><xsl:text>",</xsl:text>
            <xsl:text>"MPP_CONCEPT_ID": "</xsl:text><xsl:value-of select="amt-items[CONCEPT_TYPE_CODE='MPP']/PBS_CONCEPT_ID" /><xsl:text>",</xsl:text>
            <xsl:text>"MPP_AMT_CODE": "</xsl:text><xsl:value-of select="amt-items[CONCEPT_TYPE_CODE='MPP']/AMT_CODE" /><xsl:text>",</xsl:text>
            <xsl:text>"TPP_CONCEPT_ID": "</xsl:text><xsl:value-of select="amt-items[CONCEPT_TYPE_CODE='TPP']/PBS_CONCEPT_ID" /><xsl:text>",</xsl:text>
            <xsl:text>"TPP_AMT_CODE": "</xsl:text><xsl:value-of select="amt-items[CONCEPT_TYPE_CODE='TPP']/AMT_CODE" /><xsl:text>",</xsl:text>
            <xsl:text>"MPUU_CONCEPT_ID": "</xsl:text><xsl:value-of select="amt-items[CONCEPT_TYPE_CODE='MPUU']/PBS_CONCEPT_ID" /><xsl:text>",</xsl:text>
            <xsl:text>"MPUU_AMT_CODE": "</xsl:text><xsl:value-of select="amt-items[CONCEPT_TYPE_CODE='MPUU']/AMT_CODE" /><xsl:text>",</xsl:text>
            <xsl:for-each select="child::*[name()='DRUG_NAME' or name()='LI_DRUG_NAME' or name()='LI_FORM' or name()='SCHEDULE_FORM'
                            or name()='BRAND_NAME' or name()='MANNER_OF_ADMINISTRATION' or name()='MAXIMUM_QUANTITY_UNITS' or name()='PACK_SIZE'
                            or name()='NUMBER_OF_REPEATS' or name()='MANUFACTURER_CODE' or name()='SUPPLY_ONLY_INDICATOR' or name()='BRAND_SUBSTITUTION_GROUP_CODE'
                            or name()='PRESCRIBER_CODE']">
                <xsl:text>"</xsl:text><xsl:value-of select="local-name()" /><xsl:text>": "</xsl:text><xsl:value-of select="." /><xsl:text>"</xsl:text>
                <xsl:choose>
                    <xsl:when test="position() != last()">,</xsl:when>
                    <xsl:otherwise></xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>

            <xsl:choose>
                <xsl:when test="position() != last()">},</xsl:when>
                <xsl:otherwise>}</xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
        <xsl:text>]</xsl:text>
    </xsl:template>

</xsl:stylesheet>
