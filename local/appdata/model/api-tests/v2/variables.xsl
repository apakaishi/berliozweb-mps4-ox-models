<?xml version="1.0" encoding="utf-8"?>
<!--
  This stylesheet transform variable used to insert some information defined for client

  @author Adriano Akaishi
  @date 25/03/2020
  @copyright Allette Systems Pty Ltd
-->
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:mps="http://www.pageseeder.com/mps/function"
                exclude-result-prefixes="#all">

    <!-- Starts D(100)/PB(100) Rule-->
    <!-- Rule D1 -->
    <xsl:function name="mps:is-HSD-code" as="xs:boolean">
        <xsl:param name="dts" />

        <xsl:variable name="drugtypes" select="upper-case(string-join( distinct-values($dts), ' | '))"/>

        <xsl:choose>
            <xsl:when test="(
                        contains($drugtypes , 'HB' ) or
	                    contains($drugtypes , 'HS' ) or
                        contains($drugtypes , 'CA' )
                        )
                and not(
                        contains($drugtypes , 'CT' ) or
                        contains($drugtypes , 'DB' ) or
	                    contains($drugtypes , 'GE' ) or
	                    contains($drugtypes , 'GH' ) or
	                    contains($drugtypes , 'IF' ) or
	                    contains($drugtypes , 'IN' ) or
	                    contains($drugtypes , 'IP' ) or
	                    contains($drugtypes , 'MD' ) or
	                    contains($drugtypes , 'MF' ) or
	                    contains($drugtypes , 'PL' ) or
                        contains($drugtypes , 'PQ' ) or
	                    contains($drugtypes , 'R1' ) or
	                    contains($drugtypes , 'TY' ) or
	                    contains($drugtypes , 'TZ' )
                       )">
                <xsl:value-of select="true()" />
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="false()" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

    <!-- Rule D2 -->
    <xsl:function name="mps:is-EFC-code" as="xs:boolean">
        <xsl:param name="dts" />

        <xsl:variable name="drugtypes" select="upper-case(string-join( distinct-values($dts), ' | '))"/>

        <xsl:choose>
            <xsl:when test="(
                        contains($drugtypes , 'CT' ) or
	                    contains($drugtypes , 'IN' ) or
	                    contains($drugtypes , 'IP' ) or
	                    contains($drugtypes , 'TY' ) or
	                    contains($drugtypes , 'TZ' )
                        )
                and not(
                        contains($drugtypes , 'DB' ) or
	                    contains($drugtypes , 'GE' ) or
	                    contains($drugtypes , 'GH' ) or
	                    contains($drugtypes , 'IF' ) or
	                    contains($drugtypes , 'MD' ) or
	                    contains($drugtypes , 'MF' ) or
	                    contains($drugtypes , 'PL' ) or
                        contains($drugtypes , 'PQ' ) or
	                    contains($drugtypes , 'R1' ) or
                        contains($drugtypes , 'HB' ) or
	                    contains($drugtypes , 'HS' ) or
                        contains($drugtypes , 'CA' )
                       )">
                <xsl:value-of select="true()" />
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="false()" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

    <!-- Rule D3 -->
    <xsl:function name="mps:is-Growth-Hormone-code" as="xs:boolean">
        <xsl:param name="dts" />

        <xsl:variable name="drugtypes" select="upper-case(string-join( distinct-values($dts), ' | '))"/>

        <xsl:choose>
            <xsl:when test="(
	                    contains($drugtypes , 'GH' )
                        )
                and not(
                        contains($drugtypes , 'CT' ) or
	                    contains($drugtypes , 'IN' ) or
	                    contains($drugtypes , 'IP' ) or
	                    contains($drugtypes , 'TY' ) or
	                    contains($drugtypes , 'TZ' ) or
                        contains($drugtypes , 'DB' ) or
	                    contains($drugtypes , 'GE' ) or
	                    contains($drugtypes , 'IF' ) or
	                    contains($drugtypes , 'MD' ) or
	                    contains($drugtypes , 'MF' ) or
	                    contains($drugtypes , 'PL' ) or
                        contains($drugtypes , 'PQ' ) or
	                    contains($drugtypes , 'R1' ) or
                        contains($drugtypes , 'HB' ) or
	                    contains($drugtypes , 'HS' ) or
                        contains($drugtypes , 'CA' )
                       )">
                <xsl:value-of select="true()" />
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="false()" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

    <!-- Rule D4 -->
    <xsl:function name="mps:is-IVF-code" as="xs:boolean">
        <xsl:param name="dts" />

        <xsl:variable name="drugtypes" select="upper-case(string-join( distinct-values($dts), ' | '))"/>

        <xsl:choose>
            <xsl:when test="(
	                    contains($drugtypes , 'IF' )
                        )
                and not(
                        contains($drugtypes , 'CT' ) or
	                    contains($drugtypes , 'IN' ) or
	                    contains($drugtypes , 'GH' ) or
	                    contains($drugtypes , 'IP' ) or
	                    contains($drugtypes , 'TY' ) or
	                    contains($drugtypes , 'TZ' ) or
                        contains($drugtypes , 'DB' ) or
	                    contains($drugtypes , 'GE' ) or
	                    contains($drugtypes , 'MD' ) or
	                    contains($drugtypes , 'MF' ) or
	                    contains($drugtypes , 'PL' ) or
                        contains($drugtypes , 'PQ' ) or
	                    contains($drugtypes , 'R1' ) or
                        contains($drugtypes , 'HB' ) or
	                    contains($drugtypes , 'HS' ) or
                        contains($drugtypes , 'CA' )
                       )">
                <xsl:value-of select="true()" />
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="false()" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

    <!-- Rule D5 -->
    <xsl:function name="mps:is-Botulinium-Toxin-code" as="xs:boolean">
        <xsl:param name="dts" />

        <xsl:variable name="drugtypes" select="upper-case(string-join( distinct-values($dts), ' | '))"/>

        <xsl:choose>
            <xsl:when test="(
	                    contains($drugtypes , 'MF' )
                        )
                and not(
                        contains($drugtypes , 'CT' ) or
	                    contains($drugtypes , 'IN' ) or
	                    contains($drugtypes , 'IF' ) or
	                    contains($drugtypes , 'GH' ) or
	                    contains($drugtypes , 'IP' ) or
	                    contains($drugtypes , 'TY' ) or
	                    contains($drugtypes , 'TZ' ) or
                        contains($drugtypes , 'DB' ) or
	                    contains($drugtypes , 'GE' ) or
	                    contains($drugtypes , 'MD' ) or
	                    contains($drugtypes , 'PL' ) or
                        contains($drugtypes , 'PQ' ) or
	                    contains($drugtypes , 'R1' ) or
                        contains($drugtypes , 'HB' ) or
	                    contains($drugtypes , 'HS' ) or
                        contains($drugtypes , 'CA' )
                       )">
                <xsl:value-of select="true()" />
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="false()" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

    <!-- Rule D6 -->
    <xsl:function name="mps:is-Opiate-Dependence-code" as="xs:boolean">
        <xsl:param name="dts" />

        <xsl:variable name="drugtypes" select="upper-case(string-join( distinct-values($dts), ' | '))"/>

        <xsl:choose>
            <xsl:when test="(
	                    contains($drugtypes , 'MD' )
                        )
                and not(
                        contains($drugtypes , 'CT' ) or
	                    contains($drugtypes , 'IN' ) or
	                    contains($drugtypes , 'IF' ) or
	                    contains($drugtypes , 'GH' ) or
	                    contains($drugtypes , 'IP' ) or
	                    contains($drugtypes , 'TY' ) or
	                    contains($drugtypes , 'TZ' ) or
                        contains($drugtypes , 'DB' ) or
	                    contains($drugtypes , 'GE' ) or
	                    contains($drugtypes , 'MF' ) or
	                    contains($drugtypes , 'PL' ) or
                        contains($drugtypes , 'PQ' ) or
	                    contains($drugtypes , 'R1' ) or
                        contains($drugtypes , 'HB' ) or
	                    contains($drugtypes , 'HS' ) or
                        contains($drugtypes , 'CA' )
                       )">
                <xsl:value-of select="true()" />
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="false()" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

    <!-- Rule D7 -->
    <xsl:function name="mps:is-ParaQuad-code" as="xs:boolean">
        <xsl:param name="dts" />

        <xsl:variable name="drugtypes" select="upper-case(string-join( distinct-values($dts), ' | '))"/>

        <xsl:choose>
            <xsl:when test="(
                        contains($drugtypes , 'PQ' )
                        )
                and not(
                        contains($drugtypes , 'CT' ) or
	                    contains($drugtypes , 'MF' ) or
	                    contains($drugtypes , 'IN' ) or
	                    contains($drugtypes , 'IF' ) or
	                    contains($drugtypes , 'GH' ) or
	                    contains($drugtypes , 'IP' ) or
	                    contains($drugtypes , 'TY' ) or
	                    contains($drugtypes , 'TZ' ) or
                        contains($drugtypes , 'DB' ) or
	                    contains($drugtypes , 'GE' ) or
	                    contains($drugtypes , 'MD' ) or
	                    contains($drugtypes , 'PL' ) or
	                    contains($drugtypes , 'R1' ) or
                        contains($drugtypes , 'HB' ) or
	                    contains($drugtypes , 'HS' ) or
                        contains($drugtypes , 'CA' )
                       )">
                <xsl:value-of select="true()" />
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="false()" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

</xsl:stylesheet>
