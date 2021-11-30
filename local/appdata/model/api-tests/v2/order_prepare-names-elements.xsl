<?xml version="1.0" encoding="utf-8"?>
<!--
  This stylesheet modify the names and order elements analysis

  @author Adriano Akaishi
  @date 30/11/2021
  @copyright Allette Systems Pty Ltd
-->

<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                exclude-result-prefixes="#all">

    <xsl:output method="xml" encoding="UTF-8" indent="yes"  />

    <xsl:variable name="final-document">
        <data>
            <xsl:for-each select="data/item">
                <item>
                    <Listed-Drug><xsl:value-of select="LI_DRUG_NAME/text()" /></Listed-Drug>
                    <Form><xsl:value-of select="LI_FORM/text()" /></Form>
                    <Manner-of-Administration><xsl:value-of select="MANNER_OF_ADMINISTRATION/text()" /></Manner-of-Administration>
                    <Schedule-Equivalent><xsl:value-of select="SCHEDULE-EQUIVALENT/text()" /></Schedule-Equivalent>
                    <Brand><xsl:value-of select="BRAND_NAME/text()" /></Brand>
                    <Responsable-Person><xsl:value-of select="MANUFACTURER_CODE/text()" /></Responsable-Person>
                    <MANUFACTURER_NAME><xsl:value-of select="MANUFACTURER_NAME/text()" /></MANUFACTURER_NAME>
                    <ITEM-CODE><xsl:value-of select="PBS_CODE/text()" /></ITEM-CODE>
                    <PROGRAM_CODE><xsl:value-of select="PROGRAM_CODE/text()" /></PROGRAM_CODE>
                    <Authorised-Prescriber><xsl:value-of select="PRESCRIBERS/text()" /></Authorised-Prescriber> <!-- TODO: Grouping -->
                    <RESTRICTIONS><xsl:value-of select="RESTRICTIONS/text()" /></RESTRICTIONS>
                    <Circumstances><xsl:value-of select="''" /></Circumstances> <!-- TODO: Grouping -->
                    <Purposes><xsl:value-of select="''" /></Purposes> <!-- TODO: Grouping/Analysis -->
                    <Max-Quantity><xsl:value-of select="MAX_PRESCRIBABLE_UNIT_OF_USE/text()" /></Max-Quantity>
                    <Number-of-Repeats><xsl:value-of select="NUMBER_OF_REPEATS/text()" /></Number-of-Repeats>
                    <BENEFIT_TYPE_CODE><xsl:value-of select="BENEFIT_TYPE_CODE/text()" /></BENEFIT_TYPE_CODE>
                    <Pack-Quantity><xsl:value-of select="PACK_SIZE/text()" /></Pack-Quantity>
                    <Determined-Quantity><xsl:value-of select="''" /></Determined-Quantity>
                    <BRAND_SUBSTITUTION><xsl:value-of select="BRAND_SUBSTITUTION/text()" /></BRAND_SUBSTITUTION>
                    <Section-100-only><xsl:value-of select="S100/text()" /></Section-100-only>
                </item>
            </xsl:for-each>
        </data>
    </xsl:variable>

    <xsl:template match="/">
        <my-document>
            <xsl:copy-of select="$final-document" />
        </my-document>
    </xsl:template>

</xsl:stylesheet>


