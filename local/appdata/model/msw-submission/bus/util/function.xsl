<?xml version="1.0" encoding="utf-8"?>
<!--
  This stylesheet Preparing a Simple Example PBS XML v3

  @author Adriano Akaishi
  @date 09/08/2019
  @copyright Allette Systems Pty Ltd
-->

<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fn="http://www.pageseeder.com/function"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                exclude-result-prefixes="#all">


  <xsl:function name="fn:verify-data-for-format-date">
    <xsl:param name="date-to-verify" as="xs:string?"/>
    <xsl:choose>
        <xsl:when test="$date-to-verify = '' or starts-with($date-to-verify,'N/A') or starts-with($date-to-verify,'Withdrawn') or starts-with($date-to-verify,'Awaiting')">
            <xsl:value-of select="''" />
        </xsl:when>
        <xsl:otherwise>
            <xsl:value-of select="fn:format-yyyy-mm-dd($date-to-verify)" />
        </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

        <!--
         Content format could be:
         - 01-01-2020 or 01/01/2020
         - 01-Jan-20 or 01/Jan/20
        -->
  <xsl:function name="fn:format-yyyy-mm-dd">
    <xsl:param name="content" as="xs:string?"/>
    <xsl:choose>
        <xsl:when test="matches($content, '^[0-9]{2}[-\\/]{1}[0-9]{2}[-\\/]{1}[0-9]{4}$')">
            <xsl:variable name="date-tokens" select="tokenize($content,'/|-')"/>
            <xsl:variable name="day" select="$date-tokens[1]" />
            <xsl:variable name="month" select="$date-tokens[2]" />
            <xsl:variable name="year" select="$date-tokens[last()]" />
            <xsl:value-of select="concat($year,'-',$month,'-',$day)" />
        </xsl:when>
        <xsl:when test="matches($content, '^[0-9]{2}[-\\/]{1}[a-zA-Z]{3}[-\\/]{1}[0-9]{2}$')">
            <xsl:variable name="date-tokens" select="tokenize($content,'/|-')"/>
            <xsl:variable name="day" select="$date-tokens[1]" />
            <xsl:variable name="month" select="$date-tokens[2]" />
            <xsl:variable name="year" select="$date-tokens[last()]" />
            <xsl:value-of select="concat('20', $year,'-',fn:get-numeric-month($month),'-',$day)" />
        </xsl:when>
        <xsl:otherwise>
            <xsl:value-of select="$content" />
        </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

  <xsl:function name="fn:get-numeric-month" as="xs:string">
    <xsl:param name="month" as="xs:string"/>
    <xsl:choose>
        <xsl:when test="lower-case($month) = ('jan', 'january')"><xsl:value-of select="'01'"/></xsl:when>
        <xsl:when test="lower-case($month) = ('feb', 'february')"><xsl:value-of select="'02'"/></xsl:when>
        <xsl:when test="lower-case($month) = ('mar', 'march')"><xsl:value-of select="'03'"/></xsl:when>
        <xsl:when test="lower-case($month) = ('apr', 'april')"><xsl:value-of select="'04'"/></xsl:when>
        <xsl:when test="lower-case($month) = ('may', 'may')"><xsl:value-of select="'05'"/></xsl:when>
        <xsl:when test="lower-case($month) = ('jun', 'june')"><xsl:value-of select="'06'"/></xsl:when>
        <xsl:when test="lower-case($month) = ('jul', 'july')"><xsl:value-of select="'07'"/></xsl:when>
        <xsl:when test="lower-case($month) = ('aug', 'august')"><xsl:value-of select="'08'"/></xsl:when>
        <xsl:when test="lower-case($month) = ('sep', 'september')"><xsl:value-of select="'09'"/></xsl:when>
        <xsl:when test="lower-case($month) = ('oct', 'october')"><xsl:value-of select="'10'"/></xsl:when>
        <xsl:when test="lower-case($month) = ('nov', 'november')"><xsl:value-of select="'11'"/></xsl:when>
        <xsl:when test="lower-case($month) = ('dec', 'decembre')"><xsl:value-of select="'12'"/></xsl:when>
    </xsl:choose>
  </xsl:function>
</xsl:stylesheet>