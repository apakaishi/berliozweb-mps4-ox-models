<?xml version="1.0" encoding="utf-8"?>
<!--

  @author Adriano Akaishi
  @date 20/10/2021
  @copyright Allette Systems Pty Ltd
-->

<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                exclude-result-prefixes="#all">

    <xsl:output method="xml" encoding="UTF-8" indent="yes"  />

    <xsl:variable name="base" select="substring-before(replace(base-uri(),'file:', 'file://'),'files/items.xml')" />

    <!-- Collect all the documents PSML inside the psml folder in mode recursive-->
    <xsl:variable name="organisations" select="document(concat($base,'files/organisations.xml'))" />
    <xsl:variable name="item-amt" select="document(concat($base,'files/items-amts.xml'))" />
    <xsl:variable name="amt" select="document(concat($base,'files/amt.xml'))" />
    <xsl:variable name="item-atc" select="document(concat($base,'files/items-atcs.xml'))" />
    <xsl:variable name="prescriber" select="document(concat($base,'files/prescribers.xml'))" />
    <xsl:variable name="restriction" select="document(concat($base,'files/restrictions.xml'))" />
    <xsl:variable name="item-restriction" select="document(concat($base,'files/items-restrictions.xml'))" />

    <xsl:variable name="result">
        <my-document>
            <item>
                <xsl:for-each select="my-document/item/item">
                    <xsl:variable name="org-id" select="ORGANISATION_ID/text()" />
                    <xsl:variable name="item-code" select="PBS_CODE/text()" />
                    <xsl:variable name="mpp-id" select="PBS_MPP_ID/text()" />

                    <!-- AMT Analysis -->
                    <xsl:variable name="item-amt-mpp" select="$item-amt/my-document/items-amt/items-amt[PBS_CONCEPT_ID/text() = $mpp-id]" />
                    <xsl:variable name="amt-mpp" select="$amt/my-document/amt/amt[AMT_CODE/text() = $item-amt-mpp/AMT_CODE/text()]/PREFERRED_TERM/text()" />

                    <!-- Restrictions Analysis -->
                    <xsl:variable name="item-restriction-res-code">
                        <restrictions>
                            <xsl:for-each select="$item-restriction/my-document/items-restriction/items-restriction[PBS_CODE/text() = $item-code and contains(RES_CODE/text(),'_R')]">
                                <restriction><xsl:value-of select="RES_CODE/text()" /></restriction>
                            </xsl:for-each>
                        </restrictions>
                    </xsl:variable>

                    <xsl:variable name="restriction-benefit-type">
                        <xsl:for-each-group select="$item-restriction/my-document/items-restriction/items-restriction[PBS_CODE/text() = $item-code and contains(RES_CODE/text(),'_R')]" group-by="BENEFIT_TYPE_CODE">
                            <xsl:value-of select="if(position()!= last()) then concat(BENEFIT_TYPE_CODE/text(),',') else BENEFIT_TYPE_CODE/text()" />
                        </xsl:for-each-group>
                    </xsl:variable>

                    <xsl:variable name="restriction-treatment-of-codes">
                        <xsl:for-each select="$restriction/my-document/restriction/restriction[RES_CODE/text() = $item-restriction-res-code/restrictions/restriction]">
                            <xsl:value-of select="if(position()!= last()) then concat(TREATMENT_OF_CODE/text(),',') else TREATMENT_OF_CODE/text()" />
                        </xsl:for-each>
                    </xsl:variable>

                    <xsl:variable name="restriction-treatment-of-codes-grouping">
                        <xsl:for-each select="$restriction/my-document/restriction/restriction[RES_CODE/text() = $item-restriction-res-code/restrictions/restriction]">
                            <xsl:value-of select="if(position()!= last()) then concat(TREATMENT_OF_CODE/text(),' | ') else TREATMENT_OF_CODE/text()" />
                        </xsl:for-each>
                    </xsl:variable>

                    <!-- Used for specific groupings-->
                    <xsl:variable name="max-quantity" select="MAX_PRESCRIBABLE_UNIT_OF_USE/text()" />
                    <xsl:variable name="number-of-repeats" select="NUMBER_OF_REPEATS/text()" />
                    <xsl:variable name="program-code" select="PROGRAM_CODE/text()" />

                    <item>
                        <xsl:element name="LI_DRUG_NAME"><xsl:value-of select="LI_DRUG_NAME/text()" /></xsl:element>
                        <xsl:element name="LI_FORM"><xsl:value-of select="LI_FORM/text()" /></xsl:element>
                        <xsl:element name="MANNER_OF_ADMINISTRATION"><xsl:value-of select="MANNER_OF_ADMINISTRATION/text()" /></xsl:element>
                        <!--<xsl:element name="BioEq"><xsl:value-of select="BRAND_SUBSTITUTION_GROUP_CODE/text()" /></xsl:element>-->
                        <xsl:element name="BRAND_NAME"><xsl:value-of select="BRAND_NAME/text()" /></xsl:element>
                        <xsl:element name="MANUFACTURER_CODE"><xsl:value-of select="MANUFACTURER_CODE/text()" /></xsl:element>
                        <xsl:element name="MANUFACTURER_NAME"><xsl:value-of select="$organisations/my-document/organisation/organisation[ORGANISATION_ID/text()=$org-id]/NAME/text()" /></xsl:element>
                        <xsl:element name="RESTRICTIONS"><xsl:value-of select="$restriction-treatment-of-codes" /></xsl:element>
                        <xsl:element name="PBS_CODE"><xsl:value-of select="$item-code" /></xsl:element>
                        <xsl:element name="PROGRAM_CODE"><xsl:value-of select="$program-code" /></xsl:element>
                        <xsl:element name="PRESCRIBERS">
                            <xsl:for-each select="$prescriber/my-document/prescriber/prescriber[PBS_CODE/text()=$item-code]">
                                <xsl:value-of select="if(position()!=last()) then concat(PRESCRIBER_CODE/text(),',') else PRESCRIBER_CODE/text()" />
                            </xsl:for-each>
                        </xsl:element>
                        <xsl:element name="MAX_PRESCRIBABLE_UNIT_OF_USE"><xsl:value-of select="$max-quantity" /></xsl:element>
                        <xsl:element name="NUMBER_OF_REPEATS"><xsl:value-of select="$number-of-repeats" /></xsl:element>
                        <xsl:element name="BENEFIT_TYPE_CODE"><xsl:value-of select="$restriction-benefit-type" /></xsl:element>
                        <xsl:element name="PACK_SIZE"><xsl:value-of select="substring-after($amt-mpp,',')" /></xsl:element> <!-- Pharmaceutical Item - quantity-->
                        <xsl:element name="BRAND_SUBSTITUTION"><xsl:value-of select="if(normalize-space(BRAND_SUBSTITION_GROUP_ID/text())!='') then concat(BRAND_SUBSTITION_GROUP_ID/text(),',') else ''" /></xsl:element>
                    </item>
                </xsl:for-each>
            </item>
        </my-document>
    </xsl:variable>

    <xsl:template match="/">
        <xsl:copy-of select="$result" />
    </xsl:template>

</xsl:stylesheet>


