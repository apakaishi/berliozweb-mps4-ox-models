<?xml version="1.0" encoding="utf-8"?>
<!--
  This stylesheet transform API prepared in a specific groupings

  @author Adriano Akaishi
  @date 30/11/2021
  @copyright Allette Systems Pty Ltd
-->
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:mps="http://www.pageseeder.com/mps/function"
                exclude-result-prefixes="#all">


    <!-- Brand Substitution Group -->
    <xsl:variable name="brand-sub-group">
        <grouping>
            <xsl:for-each-group select="data/item" group-by="LI_DRUG_NAME">
                <xsl:variable name="drug" select="LI_DRUG_NAME/text()" />
                <drug>
                    <xsl:attribute name="value" select="$drug" />
                    <xsl:for-each-group select="current-group()" group-by="LI_FORM">
                        <xsl:variable name="form" select="LI_FORM/text()" />
                        <form>
                            <xsl:attribute name="value" select="$form" />
                            <xsl:for-each-group select="current-group()" group-by="PBS_CODE">
                                <xsl:variable name="item-code" select="PBS_CODE/text()" />
                                <item>
                                    <xsl:attribute name="code" select="$item-code" />
                                    <xsl:variable name="distinct-brand-sub-group">
                                        <xsl:for-each-group select="current-group()" group-by="BRAND_SUBSTITUTION">
                                            <xsl:sort select="BRAND_SUBSTITUTION" />
                                            <xsl:variable name="pos" select="position()" />
                                            <xsl:value-of select="if($pos != last()) then concat(BRAND_SUBSTITUTION/text(), ',') else BRAND_SUBSTITUTION/text()" />
                                        </xsl:for-each-group>
                                    </xsl:variable>
                                    <xsl:attribute name="distinct-brand-sub-group" select="$distinct-brand-sub-group" />
                                    <xsl:variable name="pos-brand-sub">
                                        <brand-subs>
                                            <xsl:for-each select="tokenize($distinct-brand-sub-group,',')">
                                                <brand-sub>
                                                    <xsl:variable name="pos" select="position()" />
                                                    <xsl:variable name="equiv" select="if($pos = 1) then 'a'
                                                                    else if($pos = 2) then 'b'
                                                                    else if($pos = 3) then 'c' else ''" />
                                                    <xsl:attribute name="pos" select="$pos"/>
                                                    <xsl:attribute name="equiv" select="$equiv"/>
                                                    <xsl:attribute name="value" select="."/>
                                                </brand-sub>
                                            </xsl:for-each>
                                        </brand-subs>
                                    </xsl:variable>
                                    <xsl:for-each-group select="current-group()" group-by="BRAND_NAME">
                                        <xsl:variable name="brand" select="BRAND_NAME/text()" />
                                        <xsl:variable name="brand-substitution" select="BRAND_SUBSTITUTION/text()" />
                                        <brand>
                                            <xsl:attribute name="value" select="$brand" />
                                            <xsl:attribute name="brand-substitution" select="$brand-substitution" />
                                            <xsl:variable name="group" select="$pos-brand-sub/brand-subs/brand-sub[@value = $brand-substitution]/@equiv" />
                                            <xsl:attribute name="group" select="$group" />
                                        </brand>
                                    </xsl:for-each-group>
                                </item>
                            </xsl:for-each-group>
                        </form>
                    </xsl:for-each-group>
                </drug>
            </xsl:for-each-group>
        </grouping>
    </xsl:variable>

    <!-- Grouping S100 -->
    <xsl:variable name="s100">
        <grouping>
            <xsl:for-each-group select="data/item" group-by="LI_DRUG_NAME">
                <xsl:variable name="drug" select="LI_DRUG_NAME/text()" />
                <drug>
                    <xsl:attribute name="value" select="$drug" />
                    <xsl:variable name="distinct-program-code-form">
                        <xsl:for-each-group select="current-group()" group-by="PROGRAM_CODE">
                            <xsl:variable name="pos" select="position()" />
                            <xsl:value-of select="if($pos != last()) then concat(PROGRAM_CODE/text(), ' | ') else PROGRAM_CODE/text()" />
                        </xsl:for-each-group>
                    </xsl:variable>
                    <xsl:attribute name="distinct-program-code" select="$distinct-program-code-form" />
                    <xsl:for-each-group select="current-group()" group-by="LI_FORM">
                        <xsl:variable name="form" select="LI_FORM/text()" />
                        <form>
                            <xsl:attribute name="value" select="$form" />
                            <xsl:variable name="distinct-restrictions-code">
                                <restrictions>
                                    <xsl:for-each-group select="current-group()" group-by="RESTRICTIONS">
                                        <xsl:variable name="content" select="RESTRICTIONS/text()" />
                                        <xsl:choose>
                                            <xsl:when test="contains($content,',')">
                                                <xsl:for-each select="tokenize($content,',')">
                                                    <xsl:variable name="formatted-content" select="if (string-length(.) &lt; 5) then concat('0',.) else ." />
                                                    <restriction>
                                                        <xsl:attribute name="value" select="$formatted-content" />
                                                    </restriction>
                                                </xsl:for-each>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <restriction>
                                                    <xsl:attribute name="value" select="$content" />
                                                </restriction>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:for-each-group>
                                </restrictions>
                            </xsl:variable>
                            <xsl:variable name="distinct-restrictions-code-sort">
                                <xsl:for-each-group select="$distinct-restrictions-code/restrictions/restriction[not(contains(@value, ','))]" group-by="@value">
                                    <xsl:sort select="@value" />
                                    <xsl:variable name="restriction" select="if(starts-with(@value,'0')) then substring(@value,2) else @value" />
                                    <xsl:variable name="pos" select="position()" />
                                    <xsl:value-of select="if($pos != last()) then concat($restriction, ',') else $restriction" />
                                </xsl:for-each-group>
                            </xsl:variable>
                            <xsl:attribute name="circumstances" select="$distinct-restrictions-code-sort" />
                            <xsl:variable name="distinct-program-code">
                                <xsl:for-each-group select="current-group()" group-by="PROGRAM_CODE">
                                    <xsl:variable name="pos" select="position()" />
                                    <xsl:value-of select="if($pos != last()) then concat(PROGRAM_CODE/text(), ',') else PROGRAM_CODE/text()" />
                                </xsl:for-each-group>
                            </xsl:variable>
                            <xsl:attribute name="distinct-program-code" select="$distinct-program-code" />
                            <xsl:for-each-group select="current-group()" group-by="PBS_CODE">
                                <xsl:variable name="item-code" select="PBS_CODE/text()" />
                                <item>
                                    <xsl:attribute name="code" select="$item-code" />
                                    <xsl:attribute name="restriction_type" select="BENEFIT_TYPE_CODE/text()" />
                                    <xsl:variable name="distinct-restrictions-code-prescriber">
                                        <restrictions>
                                            <xsl:for-each-group select="current-group()" group-by="RESTRICTIONS">
                                                <xsl:variable name="content" select="RESTRICTIONS/text()" />
                                                <xsl:choose>
                                                    <xsl:when test="contains($content,',')">
                                                        <xsl:for-each select="tokenize($content,',')">
                                                            <xsl:variable name="formatted-content" select="if (string-length(.) &lt; 5) then concat('0',.) else ." />
                                                            <restriction>
                                                                <xsl:attribute name="value" select="$formatted-content" />
                                                            </restriction>
                                                        </xsl:for-each>
                                                    </xsl:when>
                                                    <xsl:otherwise>
                                                        <restriction>
                                                            <xsl:attribute name="value" select="$content" />
                                                        </restriction>
                                                    </xsl:otherwise>
                                                </xsl:choose>
                                            </xsl:for-each-group>
                                        </restrictions>
                                    </xsl:variable>

                                    <xsl:variable name="distinct-restrictions-code-prescriber-sort">
                                        <xsl:for-each-group select="$distinct-restrictions-code-prescriber/restrictions/restriction[not(contains(@value, ','))]" group-by="@value">
                                            <xsl:sort select="@value" />
                                            <xsl:variable name="restriction" select="if(starts-with(@value,'0')) then substring(@value,2) else @value" />
                                            <xsl:variable name="pos" select="position()" />
                                            <xsl:value-of select="if($pos != last()) then concat($restriction, ',') else $restriction" />
                                        </xsl:for-each-group>
                                    </xsl:variable>

                                    <xsl:attribute name="circumstances" select="$distinct-restrictions-code-prescriber-sort" />

                                    <xsl:variable name="distinct-program-code">
                                        <xsl:for-each-group select="current-group()" group-by="PROGRAM_CODE">
                                            <xsl:variable name="pos" select="position()" />
                                            <xsl:value-of select="if($pos != last()) then concat(PROGRAM_CODE/text(), ' | ') else PROGRAM_CODE/text()" />
                                        </xsl:for-each-group>
                                    </xsl:variable>
                                    <xsl:attribute name="distinct-program-code" select="$distinct-program-code" />
                                    <xsl:attribute name="benefit_type" select="BENEFIT_TYPE_CODE/text()" />
                                </item>
                            </xsl:for-each-group>
                        </form>
                    </xsl:for-each-group>
                </drug>
            </xsl:for-each-group>
        </grouping>
    </xsl:variable>

</xsl:stylesheet>