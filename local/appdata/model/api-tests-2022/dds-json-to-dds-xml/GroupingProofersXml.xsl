<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
                exclude-result-prefixes="xs xd" version="2.0">

    <xsl:template match="proof-text">
        <proof-text>
            <xsl:sequence select="@*"/>
            <xsl:for-each-group select="Item" group-by="@PBS_CODE">
               <Item>
                 <xsl:sequence select="@*"/>
                 <xsl:apply-templates />
               </Item>  
            </xsl:for-each-group> 
        </proof-text>
    </xsl:template>

    <xsl:template match="node()|@*">
      <xsl:copy>
         <xsl:apply-templates select="node()|@*"/>
      </xsl:copy>
    </xsl:template>    

</xsl:stylesheet>
