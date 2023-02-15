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
        <xsl:variable name="date" select="concat(tokenize(@EFFECTIVE_DATE,'-')[2],'_',tokenize(@EFFECTIVE_DATE,'-')[1])" />
        <xsl:variable name="summary-amt-path" select="concat($output,'Schedule - ', $schedule-code, ' - ', $date, ' data - summary-amt.xml')" />
        <xsl:variable name="summary-drugtype-path" select="concat($output,'Schedule - ', $schedule-code, ' - ', $date, ' data - summary-drugtype.xml')" />
        <xsl:variable name="superli-report-path" select="concat($output,'Schedule - ', $schedule-code, ' - ', $date, ' data - superli-report.xml')" />

        <!-- Create Superli Report PBS XML v2 document -->
        <xsl:result-document href="{$superli-report-path}">
            <elements>
                <xsl:for-each-group select="Item[not(@PROGRAM_CODE = 'EP')]" group-by="DRUG_NAME">
                    <xsl:sort select="DRUG_NAME" />
                    <xsl:variable name="DRUG_NAME" select="DRUG_NAME" />
                    <drug>
                        <xsl:attribute name="Drug_Name"><xsl:value-of select="$DRUG_NAME" /></xsl:attribute>
                        <xsl:attribute name="Number_of_Items"><xsl:value-of select="count(current-group())" /></xsl:attribute>
                        <xsl:variable name="content-item">
                            <xsl:for-each-group select="current-group()" group-by="@PBS_CODE">
                                <xsl:sort select="@PBS_CODE" />
                                <xsl:value-of select="if(position()!=last()) then concat(@PBS_CODE,' ') else @PBS_CODE" />
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
                <xsl:for-each-group select="Item[not(@PROGRAM_CODE = 'EP')]" group-by="@PROGRAM_CODE">
                    <xsl:sort select="@PROGRAM_CODE" />
                    <xsl:variable name="PROGRAM_CODE" select="@PROGRAM_CODE" />
                    <program>
                        <xsl:attribute name="Type"><xsl:value-of select="$PROGRAM_CODE" /></xsl:attribute>
                        <xsl:attribute name="Drugs"><xsl:value-of select="count(distinct-values(current-group()/DRUG_NAME))" /></xsl:attribute>
                        <xsl:attribute name="Item_Codes"><xsl:value-of select="count(distinct-values(current-group()/@PBS_CODE))" /></xsl:attribute>
                        <xsl:attribute name="Item_Codes-Brands"><xsl:value-of select="count(current-group())" /></xsl:attribute>
                        <xsl:variable name="content-item">
                            <xsl:for-each-group select="current-group()" group-by="@PBS_CODE">
                                <xsl:sort select="@PBS_CODE" />
                                <xsl:value-of select="if(position()!=last()) then concat(@PBS_CODE,' ') else @PBS_CODE" />
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
                <xsl:for-each select="Item[not(@PROGRAM_CODE = 'EP')]">
                    <xsl:variable name="PBS_CODE" select="@PBS_CODE" />
                    <item>
                        <xsl:attribute name="DRUG_NAME"><xsl:value-of select="DRUG_NAME/text()" /></xsl:attribute>
                        <xsl:attribute name="LI_DRUG_NAME"><xsl:value-of select="LI_DRUG_NAME/text()" /></xsl:attribute>
                        <xsl:attribute name="LI_FORM"><xsl:value-of select="LI_FORM/text()" /></xsl:attribute>
                        <xsl:attribute name="SCHEDULE_FORM"><xsl:value-of select="SCHEDULE_FORM/text()" /></xsl:attribute>
                        <xsl:attribute name="PBS_CODE"><xsl:value-of select="$PBS_CODE" /></xsl:attribute>
                        <xsl:attribute name="BRAND_NAME"><xsl:value-of select="BRAND_NAME/text()" /></xsl:attribute>
                    </item>
                </xsl:for-each>
            </elements>
        </xsl:result-document>
    </xsl:template>

</xsl:stylesheet>
