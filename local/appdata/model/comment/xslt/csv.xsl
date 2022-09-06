<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output omit-xml-declaration="yes" />

  <xsl:template match="/">
    <xsl:variable name="first-publish" select="//publishes/publish[1]"/>
    <xsl:choose>
      <xsl:when test="$first-publish">
        <xsl:for-each select="$first-publish/@*"><xsl:value-of select="name()"/> <xsl:text>,</xsl:text></xsl:for-each>
      </xsl:when>
      <xsl:otherwise><xsl:text>project,group,member,target,type,log-level,status,error-msg,time-spent-milliseconds</xsl:text></xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates select="//publishes/publish"/>
  </xsl:template>

  <xsl:template match="publish">
    <xsl:value-of select="'&#xa;'"/>
    <xsl:for-each select="@*">
      <xsl:value-of select="."/>       <xsl:text>,</xsl:text>
    </xsl:for-each>
  </xsl:template>
</xsl:stylesheet>