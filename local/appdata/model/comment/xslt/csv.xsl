<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output omit-xml-declaration="yes" />

  <xsl:template match="/">
    <xsl:variable name="first-comment" select="//comments/comment[1]"/>
    <xsl:choose>
      <xsl:when test="$first-comment">
        <xsl:for-each select="$first-comment/@*"><xsl:value-of select="name()"/> <xsl:text>,</xsl:text></xsl:for-each>
      </xsl:when>
      <xsl:otherwise><xsl:text>commentid,title,content,contenttype,labels,properties,notify,type,status,error-msg,time-spent-milliseconds</xsl:text></xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates select="//comments/comment"/>
  </xsl:template>

  <xsl:template match="comment">
    <xsl:value-of select="'&#xa;'"/>
    <xsl:for-each select="@*">
      <xsl:value-of select="."/>       <xsl:text>,</xsl:text>
    </xsl:for-each>
  </xsl:template>
</xsl:stylesheet>