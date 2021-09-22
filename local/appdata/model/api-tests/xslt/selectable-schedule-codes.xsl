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
    <selectable-table>
      <headers>
        <header>
          <value>SCHEDULE_CODE</value>
          <text>Schedule Code</text>
        </header>
        <header>
          <value>EFFECTIVE_DATE</value>
          <text>Effective Date</text>
        </header>
      </headers>
      <values>
        <value>
         <SCHEDULE_CODE>3013</SCHEDULE_CODE>
         <EFFECTIVE_DATE>2021-07-01</EFFECTIVE_DATE>
        </value>
        <value>
          <SCHEDULE_CODE>2992</SCHEDULE_CODE>
          <EFFECTIVE_DATE>2021-06-01</EFFECTIVE_DATE>
        </value>
      </values>
    </selectable-table>
  </xsl:template>


</xsl:stylesheet>
