<?xml version="1.0" encoding="UTF-8"?>
<!--
   (C) Allette Systems 2021  Any use for PBS allowed
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">

  <xsl:output method="xml" encoding="UTF-8" indent="yes" />

  <xsl:template match="/">
    <selectable-table item-key="SCHEDULE_CODE">
      <headers>
        <header text="Schedule Code" value="SCHEDULE_CODE"/>
        <header text="Effective Date" value="EFFECTIVE_DATE"/>
      </headers>
      <values>
        <xsl:for-each select="csv/item">
          <xsl:sort select="@EFFECTIVE_DATE" order="descending"/>
          <value SCHEDULE_CODE="{@SCHEDULE_CODE}" EFFECTIVE_DATE="{@EFFECTIVE_DATE}"/>
        </xsl:for-each>
      </values>
    </selectable-table>
  </xsl:template>


</xsl:stylesheet>
