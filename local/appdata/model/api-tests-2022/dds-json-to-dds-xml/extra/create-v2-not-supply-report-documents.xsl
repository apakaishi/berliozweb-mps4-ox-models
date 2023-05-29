<?xml version="1.0" encoding="utf-8"?>
<!--
  This is a report documents following the analysis of PBS XML v2

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

    <xsl:variable name="base" select="replace(replace(base-uri(),'file:', 'file://'), 'data-processed/full-items-document.xml', '')" />
    <xsl:variable name="output" select="concat($base,$folder,'/')" />

    <xsl:output method="xml" encoding="UTF-8" indent="yes" omit-xml-declaration="yes" />

    <xsl:template match="Schedule">
        <xsl:variable name="date" select="concat(tokenize(@effective_date,'-')[2],'_',tokenize(@effective_date,'-')[1])" />
        <xsl:variable name="summary-amt-path" select="concat($output,'Schedule - ', $schedule-code, ' - ', $date, ' data - summary-amt-not-supply-only.xml')" />
        <xsl:variable name="summary-drugtype-path" select="concat($output,'Schedule - ', $schedule-code, ' - ', $date, ' data - summary-drugtype-not-supply-only.xml')" />
        <xsl:variable name="superli-report-path" select="concat($output,'Schedule - ', $schedule-code, ' - ', $date, ' data - superli-report-not-supply-only.xml')" />

        <!-- Create Superli Report PBS XML v2 document -->
        <xsl:result-document href="{$superli-report-path}">
            <elements>
                <xsl:for-each-group select="Item[supply_only_indicator='N']" group-by="drug_name">
                    <xsl:sort select="drug_name" />
                    <xsl:variable name="drug_name" select="drug_name" />
                    <drug>
                        <xsl:attribute name="Drug_Name"><xsl:value-of select="$drug_name" /></xsl:attribute>
                        <xsl:attribute name="Number_of_Items"><xsl:value-of select="count(current-group())" /></xsl:attribute>
                        <xsl:variable name="content-item">
                            <xsl:for-each-group select="current-group()" group-by="@pbs_code">
                                <xsl:sort select="@pbs_code" />
                                <xsl:value-of select="if(position()!=last()) then concat(@pbs_code,' ') else @pbs_code" />
                            </xsl:for-each-group>
                        </xsl:variable>
                        <xsl:attribute name="Items_Code"><xsl:value-of select="$content-item" /></xsl:attribute>
                    </drug>
                </xsl:for-each-group>
            </elements>
        </xsl:result-document>

        <!-- Create Summary Drugtype PBS XML v2 document -->
        <xsl:result-document href="{$summary-drugtype-path}">
            <elements>
                <xsl:for-each-group select="Item[supply_only_indicator='N']" group-by="@program_code">
                    <xsl:sort select="@program_code" />
                    <xsl:variable name="program_code" select="@program_code" />
                    <program>
                        <xsl:attribute name="Type"><xsl:value-of select="$program_code" /></xsl:attribute>
                        <xsl:attribute name="Drugs"><xsl:value-of select="count(distinct-values(current-group()/drug_name))" /></xsl:attribute>
                        <xsl:attribute name="Item_Codes"><xsl:value-of select="count(distinct-values(current-group()/@pbs_code))" /></xsl:attribute>
                        <xsl:attribute name="Item_Codes-Brands"><xsl:value-of select="count(current-group())" /></xsl:attribute>
                        <xsl:variable name="content-item">
                            <xsl:for-each-group select="current-group()" group-by="@pbs_code">
                                <xsl:sort select="@pbs_code" />
                                <xsl:value-of select="if(position()!=last()) then concat(@pbs_code,' ') else @pbs_code" />
                            </xsl:for-each-group>
                        </xsl:variable>
                        <xsl:attribute name="List"><xsl:value-of select="$content-item" /></xsl:attribute>
                    </program>
                </xsl:for-each-group>
            </elements>
        </xsl:result-document>

        <!-- Create Summary AMT PBS XML v2 document -->
        <xsl:result-document href="{$summary-amt-path}">
            <elements>
                <xsl:for-each select="Item[supply_only_indicator='N']">
                    <xsl:variable name="pbs_code" select="@pbs_code" />
                    <item>
                        <xsl:attribute name="drug_name"><xsl:value-of select="drug_name/text()" /></xsl:attribute>
                        <xsl:attribute name="li_drug_name"><xsl:value-of select="li_drug_name/text()" /></xsl:attribute>
                        <xsl:attribute name="li_form"><xsl:value-of select="li_form/text()" /></xsl:attribute>
                        <xsl:attribute name="schedule_form"><xsl:value-of select="schedule_form/text()" /></xsl:attribute>
                        <xsl:attribute name="pbs_code"><xsl:value-of select="$pbs_code" /></xsl:attribute>
                        <xsl:attribute name="brand_name"><xsl:value-of select="brand_name/text()" /></xsl:attribute>
                    </item>
                </xsl:for-each>
            </elements>
        </xsl:result-document>
    </xsl:template>

</xsl:stylesheet>
