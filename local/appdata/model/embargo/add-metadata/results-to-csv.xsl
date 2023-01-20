<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output omit-xml-declaration="yes" />

  <xsl:param name="result-add-metadata"/>
  <xsl:param name="result-edit-uri"/>
  <xsl:variable name="result-add-metadata-file" select="document(resolve-uri($result-add-metadata, base-uri()))"/>
  <xsl:variable name="result-edit-uri-file" select="document(resolve-uri($result-edit-uri, base-uri()))"/>

  <xsl:template match="/">

    <xsl:variable name="metadatas-input" select="inputs/metadatas/metadata"/>
    <xsl:variable name="edits-input" select="inputs/edit-uris/edit-uri"/>
    <xsl:variable name="metadatas-result" select="$result-add-metadata-file//metadatas/metadata"/>
    <xsl:variable name="edits-result" select="$result-edit-uri-file//edit-uris/edit-uri"/>
    <!-- create headers -->
    <xsl:text>uriid,title,description,labels,year,year-month,publish date,status (Add Metadata), error message (Add Metadata),time spent (Add Metadata),status (Edit URI), error message (Edit URI), time spent (Edit URI)</xsl:text>
    <!-- create each row -->
    <xsl:for-each select="$edits-input">
      <xsl:variable name="position" select="position()"/>
      <!-- add break line -->
      <xsl:value-of select="'&#xa;'"/>
      <!-- common value -->
      <xsl:value-of select="uriid"/>       <xsl:text>,</xsl:text>
      <!-- add input edit uris -->
      <xsl:apply-templates select="." mode="input"/>
      <!-- add input add metadatas -->
      <xsl:apply-templates select="$metadatas-input[$position]" mode="input"/>
      <!-- add result edit uris -->
      <xsl:apply-templates select="$edits-result[$position]" mode="result"/>
      <!-- add result add metadatas -->
      <xsl:apply-templates select="$metadatas-result[$position]" mode="result"/>
    </xsl:for-each>


<!--    <xsl:apply-templates select="edit-uris/edit-uri"/>-->
  </xsl:template>

  <xsl:template match="edit-uri" mode="input">
    <xsl:value-of select="title"/>       <xsl:text>,</xsl:text>
    <xsl:value-of select="description"/>        <xsl:text>,</xsl:text>
    <xsl:text>"</xsl:text><xsl:value-of select="labels"/>      <xsl:text>",</xsl:text>
  </xsl:template>

  <xsl:template match="metadata" mode="input">
    <xsl:value-of select="properties/property[@name='year']/@value"/>       <xsl:text>,</xsl:text>
    <xsl:value-of select="properties/property[@name='year_month']/@value"/>       <xsl:text>,</xsl:text>
    <xsl:value-of select="properties/property[@name='publish_date']/@value"/>       <xsl:text>,</xsl:text>
  </xsl:template>

  <xsl:template match="edit-uri" mode="result">
    <xsl:value-of select="status"/>       <xsl:text>,</xsl:text>
    <xsl:text>"</xsl:text><xsl:value-of select="error-msg"/>       <xsl:text>",</xsl:text>
    <xsl:value-of select="time-spent-milliseconds"/>       <xsl:text>,</xsl:text>
  </xsl:template>

  <xsl:template match="metadata" mode="result">
    <xsl:value-of select="status"/>       <xsl:text>,</xsl:text>
    <xsl:text>"</xsl:text><xsl:value-of select="error-msg"/>       <xsl:text>",</xsl:text>
    <xsl:value-of select="time-spent-milliseconds"/>
  </xsl:template>
</xsl:stylesheet>