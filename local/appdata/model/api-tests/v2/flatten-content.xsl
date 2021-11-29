<?xml version="1.0" encoding="utf-8"?>
<!--

  @author Adriano Akaishi
  @date 25/10/2021
  @copyright Allette Systems Pty Ltd
-->

<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                exclude-result-prefixes="#all">

    <xsl:output method="xml" encoding="UTF-8" indent="yes"  />

    <xsl:variable name="flatted">
        <data>
            <xsl:for-each select="my-document/item/item">
                <xsl:variable name="body-content">
                    <xsl:copy-of select="*[not(name()='PRESCRIBERS')]" />
                </xsl:variable>
                <xsl:choose>
                    <xsl:when test="contains(PRESCRIBERS/text(),',')">
                        <xsl:variable name="prescriber-text" select="PRESCRIBERS/text()" />
                        <xsl:for-each select="tokenize($prescriber-text,',')">
                            <xsl:if test="normalize-space(.)!=''">
                                <item>
                                    <xsl:copy-of select="$body-content" />
                                    <PRESCRIBER><xsl:value-of select="." /></PRESCRIBER>
                                </item>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:copy-of select="self::*" />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </data>
    </xsl:variable>

    <xsl:template match="/">
        <xsl:copy-of select="$flatted" />
    </xsl:template>

</xsl:stylesheet>


