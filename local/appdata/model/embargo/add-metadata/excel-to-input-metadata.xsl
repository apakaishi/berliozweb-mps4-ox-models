<?xml version="1.0"?>
<xsl:transform version="2.0"
               xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
               exclude-result-prefixes="#all">

  <xsl:output indent="yes" method="xml" encoding="utf-8"/>

  <xsl:variable name="header-cols" select="/workbook/worksheet[@title='metadata']/row[@position='1']/col"/>
  <xsl:variable name="uriid-col-ref" select="$header-cols[lower-case(text()) = 'uriid']/@ref"/>
  <xsl:variable name="title-col-ref" select="$header-cols[lower-case(text()) = 'title']/@ref"/>
  <xsl:variable name="data-type-col-ref" select="$header-cols[lower-case(text()) = 'path']/@ref"/>
  <xsl:variable name="year-col-ref" select="$header-cols[lower-case(text()) = 'year']/@ref"/>
  <xsl:variable name="year-month-col-ref" select="$header-cols[lower-case(text()) = 'month']/@ref"/>
  <xsl:variable name="publish-date-col-ref" select="$header-cols[lower-case(text()) = 'pub-date']/@ref"/>

  <!-- Main template -->
  <xsl:template match="/">
    <xsl:apply-templates select="*"/>
  </xsl:template>

  <xsl:template match="workbook">
    <metadatas>
      <xsl:apply-templates select="worksheet[@title='metadata']/*"/>
    </metadatas>
  </xsl:template>

  <!-- ignore header row -->
  <xsl:template match="row[@position='1']"/>

  <xsl:template match="row[not(@position='1')]">
    <xsl:variable name="uriid" select="col[@ref=$uriid-col-ref]"/>
<!--    <xsl:if test="matches($uriid, '^\d+$')">-->
      <metadata>
        <xsl:variable name="data-type" select="col[@ref=$data-type-col-ref]"/>
        <uriid><xsl:value-of select="$uriid"/></uriid>
        <title><xsl:value-of select="col[@ref=$title-col-ref]"/></title>
        <description><xsl:value-of select="$data-type"/></description>
        <xsl:choose>
          <xsl:when test="lower-case($data-type) = ('embargo', '_chemoc')">
            <labels>restricted,embargo</labels>
          </xsl:when>
          <xsl:otherwise>
            <labels>restricted</labels>
          </xsl:otherwise>
        </xsl:choose>
        <properties>
          <xsl:variable name="year" select="col[@ref=$year-col-ref]"/>
          <xsl:variable name="month" select="format-number(col[@ref=$year-month-col-ref], '#00')"/>
          <property name="year" type="string" title="Year" value="{$year}"/>
          <property name="year_month" type="string" title="Year" value="{concat($year, '-', $month)}"/>
          <property name="publish_date" type="date" title="Publish Date" value="{col[@ref=$publish-date-col-ref]}"/>
        </properties>
      </metadata>
<!--    </xsl:if>-->
  </xsl:template>

  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>
</xsl:transform>
