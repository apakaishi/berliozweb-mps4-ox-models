<?xml version="1.0" encoding="utf-8"?>
<!--

  @author Adriano Akaishi
  @date 25/10/2021
  @copyright Allette Systems Pty Ltd
-->

<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:pbs="http://schema.pbs.gov.au"
                xmlns:int="http://schema.pbs.gov.au/DoHA-Internal"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:dbk="http://docbook.org/ns/docbook"
                xmlns:skos="http://www.w3.org/2004/02/skos/core#"
                xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                xmlns:rwt="http://schema.pbs.gov.au/RWT/"
                exclude-result-prefixes="#all">

    <xsl:output method="xml" encoding="UTF-8" indent="yes"  />

    <xsl:variable name="items">
        <item>
            <xsl:for-each select="pbs:root/descendant::pbs:prescribing-rule[descendant::int:pharmaceutical-item-reference]">
                <xsl:variable name="benefit-type" select="@type" />
                <xsl:variable name="pbs-code" select="pbs:code" />
                <xsl:variable name="max-quantity" select="descendant::pbs:maximum-quantity[@reference='unit-of-use']" />
                <xsl:variable name="num-repeat" select="descendant::pbs:number-repeats" />
                <xsl:variable name="moa-ref" select="descendant::pbs:administration/pbs:moa-value" />
                <xsl:variable name="root" select="ancestor::pbs:root" />
                <xsl:variable name="moa" select="$root/descendant::skos:Concept[@rdf:about = $moa-ref]/skos:definition" />
                <xsl:variable name="member-of">
                    <xsl:for-each select="pbs:member-of-list/pbs:member-of">
                        <xsl:variable name="ref" select="substring-after(@xlink:href,'#')" />
                        <xsl:variable name="group-name" select="$root/descendant::pbs:group[@xml:id = $ref]/pbs:name" />
                        <xsl:value-of select="if(position()!= last()) then concat($group-name,',') else $group-name" />
                    </xsl:for-each>
                </xsl:variable>
                <xsl:variable name="prescribers-text">
                    <xsl:for-each select="tokenize($member-of,',')">
                        <xsl:variable name="type-prescribers" select="if(.='http://schema.pbs.gov.au/Group#medical') then 'M'
                                            else if(.='http://schema.pbs.gov.au/Group#dental') then 'D'
                                            else if(.='http://schema.pbs.gov.au/Group#nurse') then 'N'
                                            else if(.='http://schema.pbs.gov.au/Group#midwives') then 'W'
                                            else if(.='http://schema.pbs.gov.au/Group#optometrist') then 'O' else ''" />
                        <xsl:choose>
                            <xsl:when test="$type-prescribers != ''">
                                <xsl:value-of select="concat($type-prescribers,',')" />
                            </xsl:when>
                            <xsl:otherwise></xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each>
                </xsl:variable>
                <xsl:variable name="brand-substitution">
                    <xsl:for-each select="tokenize($member-of,',')">
                        <xsl:variable name="brand-s" select="if(starts-with(normalize-space(.),'GRP-')) then substring-after(normalize-space(.),'GRP-') else ''" />
                        <xsl:choose>
                            <xsl:when test="$brand-s != ''">
                                <xsl:value-of select="concat($brand-s,',')" />
                            </xsl:when>
                            <xsl:otherwise></xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each>
                </xsl:variable>

                <xsl:variable name="restrictions">
                    <xsl:for-each select="descendant::rwt:restriction-reference">
                        <xsl:variable name="ref" select="substring-after(@xlink:href,'#')" />
                        <xsl:variable name="restriction-code" select="$root/descendant::rwt:restriction[@xml:id = $ref]/pbs:code" />
                        <xsl:value-of select="if(position()!= last()) then concat($restriction-code,',') else $restriction-code" />
                    </xsl:for-each>
                </xsl:variable>


                <xsl:for-each select="descendant::pbs:mpp-reference">
                    <xsl:variable name="li-drugname-ref" select="substring-after(int:pharmaceutical-item-reference/@xlink:href,'#')" />
                    <xsl:variable name="mpp-ref" select="substring-after(@xlink:href,'#')" />
                    <xsl:for-each select="ancestor::*[1]/descendant::pbs:tpp-reference">
                        <xsl:variable name="tpp-ref" select="substring-after(@xlink:href,'#')" />
                        <xsl:variable name="tpp-content" select="$root/descendant::pbs:mpp[@xml:id = $mpp-ref]/pbs:tpp[@xml:id = $tpp-ref]"/>
                        <xsl:variable name="tpp-organisation-ref" select="substring-after($tpp-content/pbs:organisation-reference/@xlink:href,'#')" />
                        <xsl:variable name="pack-size" select="$tpp-content/pbs:pack-size" />
                        <xsl:variable name="brand-name" select="$tpp-content/dbk:subtitle" />
                        <xsl:variable name="org-ref" select="$root/descendant::pbs:organisation[@xml:id = $tpp-organisation-ref]" />
                        <xsl:variable name="man-code" select="$org-ref/pbs:code" />
                        <xsl:variable name="man-description" select="$org-ref/dbk:title" />

                        <item>
                            <LI_DRUG_NAME><xsl:value-of select="$root/descendant::int:pharmaceutical-item[@xml:id=$li-drugname-ref]/dbk:title" /></LI_DRUG_NAME>
                            <LI_FORM><xsl:value-of select="$root/descendant::int:pharmaceutical-item[@xml:id=$li-drugname-ref]/dbk:subtitle" /></LI_FORM>
                            <MANNER_OF_ADMINISTRATION><xsl:value-of select="$moa" /></MANNER_OF_ADMINISTRATION>
                            <BRAND_NAME><xsl:value-of select="$brand-name" /></BRAND_NAME>
                            <MANUFACTURER_CODE><xsl:value-of select="$man-code" /></MANUFACTURER_CODE>
                            <MANUFACTURER_NAME><xsl:value-of select="$man-description" /></MANUFACTURER_NAME>
                            <RESTRICTIONS><xsl:value-of select="$restrictions" /></RESTRICTIONS>
                            <PBS_CODE><xsl:value-of select="$pbs-code" /></PBS_CODE>
                            <PROGRAM_CODE><xsl:value-of select="ancestor::pbs:listings-list/pbs:info/pbs:code" /></PROGRAM_CODE>
                            <PRESCRIBERS><xsl:value-of select="$prescribers-text" /></PRESCRIBERS>
                            <MAX_PRESCRIBABLE_UNIT_OF_USE><xsl:value-of select="$max-quantity" /></MAX_PRESCRIBABLE_UNIT_OF_USE>
                            <NUMBER_OF_REPEATS><xsl:value-of select="$num-repeat" /></NUMBER_OF_REPEATS>
                            <BENEFIT_TYPE_CODE><xsl:value-of select="$benefit-type" /></BENEFIT_TYPE_CODE>
                            <PACK_SIZE><xsl:value-of select="$pack-size" /></PACK_SIZE>
                            <BRAND_SUBSTITUTION><xsl:value-of select="$brand-substitution" /></BRAND_SUBSTITUTION>
                        </item>
                    </xsl:for-each>
                </xsl:for-each>
            </xsl:for-each>
        </item>
    </xsl:variable>

    <xsl:variable name="ordered">
        <item>
            <xsl:for-each-group select="$items/item/item" group-by="LI_DRUG_NAME">
                <xsl:sort select="LI_DRUG_NAME" />
                <xsl:variable name="drug" select="LI_DRUG_NAME" />
                <xsl:variable name="count" select="count(ancestor::item/item[LI_DRUG_NAME/text() = $drug])" />
                <xsl:for-each-group select="current-group()" group-by="LI_FORM">
                    <xsl:sort select="LI_FORM" />
                    <xsl:variable name="form" select="LI_FORM" />
                    <xsl:for-each-group select="current-group()" group-by="MANUFACTURER_CODE">
                        <xsl:sort select="MANUFACTURER_CODE" />
                        <xsl:variable name="man-code" select="MANUFACTURER_CODE" />
                        <xsl:variable name="man-name" select="MANUFACTURER_NAME" />
                        <xsl:for-each-group select="current-group()" group-by="PBS_CODE">
                            <xsl:sort select="PBS_CODE" />
                            <xsl:variable name="item" select="PBS_CODE" />
                            <item>
                                <xsl:attribute name="count" select="$count" />
                                <LI_DRUG_NAME><xsl:value-of select="$drug" /></LI_DRUG_NAME>
                                <LI_FORM><xsl:value-of select="$form" /></LI_FORM>
                                <MANNER_OF_ADMINISTRATION><xsl:value-of select="MANNER_OF_ADMINISTRATION" /></MANNER_OF_ADMINISTRATION>
                                <BRAND_NAME><xsl:value-of select="BRAND_NAME" /></BRAND_NAME>
                                <MANUFACTURER_CODE><xsl:value-of select="$man-code" /></MANUFACTURER_CODE>
                                <MANUFACTURER_NAME><xsl:value-of select="$man-name" /></MANUFACTURER_NAME>
                                <RESTRICTIONS><xsl:value-of select="RESTRICTIONS" /></RESTRICTIONS>
                                <PBS_CODE><xsl:value-of select="$item" /></PBS_CODE>
                                <PROGRAM_CODE><xsl:value-of select="PROGRAM_CODE" /></PROGRAM_CODE>
                                <PRESCRIBERS><xsl:value-of select="PRESCRIBERS" /></PRESCRIBERS>
                                <MAX_PRESCRIBABLE_UNIT_OF_USE><xsl:value-of select="MAX_PRESCRIBABLE_UNIT_OF_USE" /></MAX_PRESCRIBABLE_UNIT_OF_USE>
                                <NUMBER_OF_REPEATS><xsl:value-of select="NUMBER_OF_REPEATS" /></NUMBER_OF_REPEATS>
                                <BENEFIT_TYPE_CODE><xsl:value-of select="BENEFIT_TYPE_CODE" /></BENEFIT_TYPE_CODE>
                                <PACK_SIZE><xsl:value-of select="PACK_SIZE" /></PACK_SIZE>
                                <BRAND_SUBSTITUTION><xsl:value-of select="BRAND_SUBSTITUTION" /></BRAND_SUBSTITUTION>
                             </item>
                       </xsl:for-each-group>
                    </xsl:for-each-group>
                </xsl:for-each-group>
            </xsl:for-each-group>
        </item>
    </xsl:variable>
    
    <xsl:template match="/">
        <my-document>
           <!-- <xsl:copy-of select="$items" />-->
            <xsl:copy-of select="$ordered" />
        </my-document>
    </xsl:template>

</xsl:stylesheet>


