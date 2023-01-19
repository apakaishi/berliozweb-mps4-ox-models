<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output omit-xml-declaration="yes" />

  <xsl:template match="/">
    <xsl:text>uriid,title,description,labels,status, error message,time spent</xsl:text>
    <xsl:apply-templates select="edit-uris/edit-uri"/>
  </xsl:template>

  <xsl:template match="metadata">
    <xsl:value-of select="'&#xa;'"/>
    <xsl:value-of select="uriid"/>       <xsl:text>,</xsl:text>
    <xsl:value-of select="title"/>       <xsl:text>,</xsl:text>
    <xsl:value-of select="description"/>        <xsl:text>,</xsl:text>
    <xsl:text>"</xsl:text><xsl:value-of select="labels"/>      <xsl:text>",</xsl:text>
    <xsl:value-of select="status"/>       <xsl:text>,</xsl:text>
    <xsl:text>"</xsl:text><xsl:value-of select="error-msg"/>       <xsl:text>",</xsl:text>
    <xsl:value-of select="time-spent-milliseconds"/>
  </xsl:template>

</xsl:stylesheet>