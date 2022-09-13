<xsl:transform version="2.0"
               xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
               exclude-result-prefixes="#all">

  <xsl:output indent="yes" method="xml" encoding="utf-8" />

  <xsl:param name="sort-comments"/>
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="comments">
    <xsl:copy>
      <xsl:choose>
        <xsl:when test="$sort-comments = 'true'">
          <xsl:apply-templates select="comment">
            <xsl:sort select="@lastmodified" order="ascending" data-type="text"/>
          </xsl:apply-templates>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="comment"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:copy>
  </xsl:template>

</xsl:transform>