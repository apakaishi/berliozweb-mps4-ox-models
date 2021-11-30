<?xml version="1.0"?>
<xsl:stylesheet
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:math="http://www.w3.org/2005/xpath-functions/math"
        xmlns:xs="http://www.w3.org/2001/XMLSchema"
        exclude-result-prefixes="xs math" version="1.0">

    <xsl:param name="type" />

    <xsl:output indent="yes" omit-xml-declaration="yes" />

    <xsl:template match="data">
        <xsl:variable name="json-data">
            <data>
                <xsl:text>
                    {
                    "content":
                </xsl:text>
                <xsl:value-of select="." />
                <xsl:text>}</xsl:text>
            </data>
        </xsl:variable>
        <my-document>
            <xsl:apply-templates select="json-to-xml($json-data/data/.)" />
        </my-document>
    </xsl:template>

    <xsl:template match="array[@key='content']"
                  xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
       <!-- <xsl:element name="{concat($type,'s')}">-->
            <xsl:apply-templates select="map" />
        <!--</xsl:element>-->
    </xsl:template>

    <xsl:template match="map[ancestor::map]"
                  xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
        <xsl:element name="{$type}">
            <xsl:apply-templates select="*" />
        </xsl:element>
    </xsl:template>

    <xsl:template match="number|string|null"
                  xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
        <xsl:element name="{self::*/@key}">
            <xsl:attribute name="type"><xsl:value-of select="local-name()" /></xsl:attribute>
            <xsl:value-of select="." />
        </xsl:element>
    </xsl:template>

</xsl:stylesheet>