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
                            <xsl:variable name="mp" select="tokenize(li_item_id/text(),'_')[3]" />
                            <xsl:variable name="mpp" select="tokenize(li_item_id/text(),'_')[4]" />
                            <xsl:variable name="tpp" select="tokenize(li_item_id/text(),'_')[5]" />
                            <xsl:attribute name="li_item_id_no_pig"><xsl:value-of select="concat(tokenize(li_item_id/text(),'_')[1],'_',
                                                                            $mp ,'_',$mpp ,'_', $tpp)" /></xsl:attribute>
                            <xsl:for-each select="child::*[name()='li_item_id' or name()='program_code'
                                   or name()='pbs_code' or name()='benefit_type_code' or name()='schedule_code']">
                                <xsl:if test="self::*[name()='li_item_id' or name()='program_code']">
                                    <xsl:attribute name="{local-name()}"><xsl:value-of select="." /></xsl:attribute>
                                </xsl:if>
                                <xsl:if test="self::*[name()='pbs_code']">
                                    <xsl:variable name="count" select="string-length(.)" />
                                    <xsl:attribute name="{local-name()}">
                                        <xsl:value-of select="if($count = 3) then concat('000',.)
                                                                else if ($count = 4) then concat('00',.)
                                                                else if ($count = 5) then concat('0',.) else ." />
                                    </xsl:attribute>
                                    <xsl:attribute name="{concat(local-name(),'-count')}"><xsl:value-of select="$count" /></xsl:attribute>
                                </xsl:if>
                                <xsl:if test="self::*[name()='benefit_type_code' or name()='schedule_code']">
                                    <xsl:attribute name="{local-name()}"><xsl:value-of select="." /></xsl:attribute>
                                </xsl:if>
                            </xsl:for-each>

                            <xsl:for-each select="child::*[not(name()='li_item_id' or name()='program_code'
                                    or name()='pbs_code' or name()='benefit_type_code' or name()='schedule_code')]">
                                <xsl:element name="{local-name()}"><xsl:value-of select="." /></xsl:element>
                            </xsl:for-each>
                        </xsl:element>
                    </xsl:for-each>
                </Item>
            </xsl:variable>

            <xsl:variable name="xml-content">
                <Item>
                    <xsl:for-each select="$xml-add-drugs/Item/element">
                        <xsl:sort select="@li_item_id_no_pig"  />
                        <xsl:variable name="pbs_code" select="@pbs_code" />
                        <element>
                            <xsl:variable name="pbs_code-count" select="@pbs_code-count" />
                            <xsl:for-each select="@*[not(name()='li_item_id_no_pig' or name()='pbs_code-count')]">
                                <xsl:choose>
                                    <xsl:when test="local-name() = 'pbs_code'">
                                        <xsl:attribute name="pbs_code"><xsl:value-of select="if($pbs_code-count = '3') then substring($pbs_code,4,3)
                                                                    else if ($pbs_code-count = '4') then substring($pbs_code,3,4)
                                                                    else if ($pbs_code-count = '5') then substring($pbs_code,2,5)
                                                                    else $pbs_code" /></xsl:attribute>
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
