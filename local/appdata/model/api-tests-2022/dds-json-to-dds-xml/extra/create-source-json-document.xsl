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
            <xsl:text>"MP_CONCEPT_ID": "</xsl:text><xsl:value-of select="AmtItems[concept_type_code='MP']/pbs_concept_id" /><xsl:text>",</xsl:text>
            <xsl:text>"MP_AMT_CODE": "</xsl:text><xsl:value-of select="AmtItems[concept_type_code='MP']/amt_code" /><xsl:text>",</xsl:text>
            <xsl:text>"MPP_CONCEPT_ID": "</xsl:text><xsl:value-of select="AmtItems[concept_type_code='MPP']/pbs_concept_id" /><xsl:text>",</xsl:text>
            <xsl:text>"MPP_AMT_CODE": "</xsl:text><xsl:value-of select="AmtItems[concept_type_code='MPP']/amt_code" /><xsl:text>",</xsl:text>
            <xsl:text>"TPP_CONCEPT_ID": "</xsl:text><xsl:value-of select="AmtItems[concept_type_code='TPP']/pbs_concept_id" /><xsl:text>",</xsl:text>
            <xsl:text>"TPP_AMT_CODE": "</xsl:text><xsl:value-of select="AmtItems[concept_type_code='TPP']/amt_code" /><xsl:text>",</xsl:text>
            <xsl:text>"MPUU_CONCEPT_ID": "</xsl:text><xsl:value-of select="AmtItems[concept_type_code='MPUU']/pbs_concept_id" /><xsl:text>",</xsl:text>
            <xsl:text>"MPUU_AMT_CODE": "</xsl:text><xsl:value-of select="AmtItems[concept_type_code='MPUU']/amt_code" /><xsl:text>",</xsl:text>
            <xsl:for-each select="child::*[name()='drug_name' or name()='li_drug_name' or name()='li_form' or name()='schedule_form'
                            or name()='brand_name' or name()='manner_of_administration' or name()='maximum_quantity_units' or name()='pack_size'
                            or name()='number_of_repeats' or name()='manufacturer_code' or name()='supply_only_indicator' or name()='brand_substitution_group_code'
                            or name()='prescriber_code']">
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
