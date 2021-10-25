<?xml version="1.0"?>
<xsl:transform version="2.0"
               xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
               exclude-result-prefixes="#all">

  <xsl:output indent="yes" method="xml" encoding="utf-8" />

  <xsl:variable name="header-cols" select="/workbook/worksheet/row[@position='1']/col"/>

    <!-- Main template -->
  <xsl:template match="/">
    <xsl:apply-templates select="*" />
  </xsl:template>

  <xsl:template match="workbook">
    <root>
      <xsl:apply-templates select="worksheet/*" />
    </root>
  </xsl:template>

  <!-- ignore header row -->
  <xsl:template match="row[@position='1']"/>

  <xsl:template match="col">
    <xsl:variable name="col-ref" select="@ref"/>
    <xsl:variable name="new-col-name" select="translate($header-cols[@ref=$col-ref]/text(), ' ', '_')"/>
    <xsl:choose>
      <xsl:when test="contains($new-col-name,'-date') and contains(.,'-')">
        <xsl:variable name="day" select="tokenize(.,'-')[last()]" />
        <xsl:variable name="month" select="tokenize(.,'-')[2]" />
        <xsl:variable name="year" select="tokenize(.,'-')[1]" />
        <xsl:element name="{$new-col-name}">
          <xsl:value-of select="concat($day,'/',$month,'/',$year)" />
        </xsl:element>
      </xsl:when>
      <xsl:when test="contains($new-col-name,'Meeting_last_considered_at') and contains(.,'-')">
        <xsl:variable name="month" select="substring(format-date(.,'[MNn]'),1,3)" />
        <xsl:variable name="year" select="substring(tokenize(.,'-')[1],3)" />
        <xsl:element name="{$new-col-name}">
          <xsl:value-of select="concat($month,'-',$year)" />
        </xsl:element>
      </xsl:when>
      <xsl:otherwise>
        <xsl:element name="{$new-col-name}">
          <xsl:apply-templates />
        </xsl:element>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*" />
      <xsl:apply-templates />
    </xsl:copy>
  </xsl:template>
</xsl:transform>
