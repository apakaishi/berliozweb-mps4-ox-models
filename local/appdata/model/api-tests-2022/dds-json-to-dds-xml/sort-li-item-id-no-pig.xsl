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
        exclude-result-prefixes="xs" version="3.0">

    <xsl:param name="schedule-code" />

    <xsl:output method="xml" encoding="UTF-8" indent="yes" omit-xml-declaration="yes" />

    <xsl:template match="root">
        <root>
            <xsl:variable name="xml-add-drugs">
                <Item>
                    <xsl:for-each select="Item/element">
                        <xsl:element name="{self::*/local-name()}">
                            <xsl:variable name="MP" select="tokenize(LI_ITEM_ID/text(),'_')[3]" />
                            <xsl:variable name="MPP" select="tokenize(LI_ITEM_ID/text(),'_')[4]" />
                            <xsl:variable name="TPP" select="tokenize(LI_ITEM_ID/text(),'_')[5]" />
                            <xsl:attribute name="LI_ITEM_ID_no_PIG"><xsl:value-of select="concat(tokenize(LI_ITEM_ID/text(),'_')[1],'_',
                                                                            $MP ,'_',$MPP ,'_', $TPP)" /></xsl:attribute>
                            <xsl:for-each select="child::*[name()='LI_ITEM_ID' or name()='PROGRAM_CODE'
                                   or name()='PBS_CODE' or name()='BENEFIT_TYPE_CODE' or name()='SCHEDULE_CODE']">
                                <xsl:if test="self::*[name()='LI_ITEM_ID' or name()='PROGRAM_CODE']">
                                    <xsl:attribute name="{local-name()}"><xsl:value-of select="." /></xsl:attribute>
                                </xsl:if>
                                <xsl:if test="self::*[name()='PBS_CODE']">
                                    <xsl:variable name="count" select="string-length(.)" />
                                    <xsl:attribute name="{local-name()}">
                                        <xsl:value-of select="if($count = 3) then concat('000',.)
                                                                else if ($count = 4) then concat('00',.)
                                                                else if ($count = 5) then concat('0',.) else ." />
                                    </xsl:attribute>
                                    <xsl:attribute name="{concat(local-name(),'-count')}"><xsl:value-of select="$count" /></xsl:attribute>
                                </xsl:if>
                                <xsl:if test="self::*[name()='BENEFIT_TYPE_CODE' or name()='SCHEDULE_CODE']">
                                    <xsl:attribute name="{local-name()}"><xsl:value-of select="." /></xsl:attribute>
                                </xsl:if>
                            </xsl:for-each>

                            <xsl:for-each select="child::*[not(name()='LI_ITEM_ID' or name()='PROGRAM_CODE'
                                    or name()='PBS_CODE' or name()='BENEFIT_TYPE_CODE' or name()='SCHEDULE_CODE')]">
                                <xsl:element name="{local-name()}"><xsl:value-of select="." /></xsl:element>
                            </xsl:for-each>
                        </xsl:element>
                    </xsl:for-each>
                </Item>
            </xsl:variable>

            <xsl:variable name="xml-content">
                <Item>
                    <xsl:for-each select="$xml-add-drugs/Item/element">
                        <xsl:sort select="@LI_ITEM_ID_no_PIG"  />
                        <xsl:variable name="PBS_CODE" select="@PBS_CODE" />
                        <element>
                            <xsl:variable name="PBS_CODE-count" select="@PBS_CODE-count" />
                            <xsl:for-each select="@*[not(name()='LI_ITEM_ID_no_PIG' or name()='PBS_CODE-count')]">
                                <xsl:choose>
                                    <xsl:when test="local-name() = 'PBS_CODE'">
                                        <xsl:attribute name="PBS_CODE"><xsl:value-of select="if($PBS_CODE-count = '3') then substring($PBS_CODE,4,3)
                                                                    else if ($PBS_CODE-count = '4') then substring($PBS_CODE,3,4)
                                                                    else if ($PBS_CODE-count = '5') then substring($PBS_CODE,2,5)
                                                                    else $PBS_CODE" /></xsl:attribute>
                                    </xsl:when>
                                    <xsl:otherwise><xsl:attribute name="{local-name()}"><xsl:value-of select="." /></xsl:attribute></xsl:otherwise>
                                </xsl:choose>
                            </xsl:for-each>
                            <xsl:for-each select="child::*">
                                <xsl:element name="{local-name()}"><xsl:value-of select="." /></xsl:element>
                            </xsl:for-each>
                        </element>
                    </xsl:for-each>
                </Item>
            </xsl:variable>

            <xsl:copy-of select="$xml-content" />

            <xsl:for-each select="*[not(name()='Item')]">
              <xsl:copy-of select="self::*" />
            </xsl:for-each>
        </root>

    </xsl:template>

</xsl:stylesheet>
