<?xml version="1.0" encoding="utf-8"?>
<!--

  @author Adriano Akaishi
  @date 25/10/2021
  @copyright Allette Systems Pty Ltd
-->

<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:mps="http://www.pageseeder.com/mps/function"
                exclude-result-prefixes="#all">

    <xsl:import href="variables.xsl" />

    <xsl:output method="xml" encoding="UTF-8" indent="yes"  />

    <!-- Grouping S100 -->
    <xsl:variable name="s100">
        <grouping>
            <xsl:for-each-group select="data/item" group-by="LI_DRUG_NAME">
                <xsl:variable name="drug" select="LI_DRUG_NAME/text()" />
                <drug>
                    <xsl:attribute name="value" select="$drug" />
                    <xsl:variable name="distinct-program-code-form">
                        <xsl:for-each-group select="current-group()" group-by="PROGRAM_CODE">
                            <xsl:variable name="pos" select="position()" />
                            <xsl:value-of select="if($pos != last()) then concat(PROGRAM_CODE/text(), ' | ') else PROGRAM_CODE/text()" />
                        </xsl:for-each-group>
                    </xsl:variable>
                    <xsl:attribute name="distinct-program-code" select="$distinct-program-code-form" />
                    <xsl:for-each-group select="current-group()" group-by="LI_FORM">
                        <xsl:variable name="form" select="LI_FORM/text()" />
                        <form>
                            <xsl:attribute name="value" select="$form" />
                            <xsl:variable name="distinct-restrictions-code">
                                <restrictions>
                                    <xsl:for-each-group select="current-group()" group-by="RESTRICTIONS">
                                        <xsl:variable name="content" select="RESTRICTIONS/text()" />
                                        <xsl:choose>
                                            <xsl:when test="contains($content,',')">
                                                <xsl:for-each select="tokenize($content,',')">
                                                    <xsl:variable name="formatted-content" select="if (string-length(.) &lt; 5) then concat('0',.) else ." />
                                                    <restriction>
                                                        <xsl:attribute name="value" select="$formatted-content" />
                                                    </restriction>
                                                </xsl:for-each>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <restriction>
                                                    <xsl:attribute name="value" select="$content" />
                                                </restriction>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:for-each-group>
                                </restrictions>
                            </xsl:variable>
                            <xsl:variable name="distinct-restrictions-code-sort">
                                <xsl:for-each-group select="$distinct-restrictions-code/restrictions/restriction[not(contains(@value, ','))]" group-by="@value">
                                    <xsl:sort select="@value" />
                                    <xsl:variable name="restriction" select="if(starts-with(@value,'0')) then substring(@value,2) else @value" />
                                    <xsl:variable name="pos" select="position()" />
                                    <xsl:value-of select="if($pos != last()) then concat($restriction, ',') else $restriction" />
                                </xsl:for-each-group>
                            </xsl:variable>
                            <xsl:attribute name="circumstances" select="$distinct-restrictions-code-sort" />
                            <xsl:variable name="distinct-program-code">
                                <xsl:for-each-group select="current-group()" group-by="PROGRAM_CODE">
                                    <xsl:variable name="pos" select="position()" />
                                    <xsl:value-of select="if($pos != last()) then concat(PROGRAM_CODE/text(), ',') else PROGRAM_CODE/text()" />
                                </xsl:for-each-group>
                            </xsl:variable>
                            <xsl:attribute name="distinct-program-code" select="$distinct-program-code" />
                            <xsl:for-each-group select="current-group()" group-by="PBS_CODE">
                                <xsl:variable name="item-code" select="PBS_CODE/text()" />
                                <item>
                                    <xsl:attribute name="code" select="$item-code" />
                                    <xsl:attribute name="restriction_type" select="BENEFIT_TYPE_CODE/text()" />
                                    <xsl:variable name="distinct-restrictions-code-prescriber">
                                        <restrictions>
                                            <xsl:for-each-group select="current-group()" group-by="RESTRICTIONS">
                                                <xsl:variable name="content" select="RESTRICTIONS/text()" />
                                                <xsl:choose>
                                                    <xsl:when test="contains($content,',')">
                                                        <xsl:for-each select="tokenize($content,',')">
                                                            <xsl:variable name="formatted-content" select="if (string-length(.) &lt; 5) then concat('0',.) else ." />
                                                            <restriction>
                                                                <xsl:attribute name="value" select="$formatted-content" />
                                                            </restriction>
                                                        </xsl:for-each>
                                                    </xsl:when>
                                                    <xsl:otherwise>
                                                        <restriction>
                                                            <xsl:attribute name="value" select="$content" />
                                                        </restriction>
                                                    </xsl:otherwise>
                                                </xsl:choose>
                                            </xsl:for-each-group>
                                        </restrictions>
                                    </xsl:variable>

                                    <xsl:variable name="distinct-restrictions-code-prescriber-sort">
                                        <xsl:for-each-group select="$distinct-restrictions-code-prescriber/restrictions/restriction[not(contains(@value, ','))]" group-by="@value">
                                            <xsl:sort select="@value" />
                                            <xsl:variable name="restriction" select="if(starts-with(@value,'0')) then substring(@value,2) else @value" />
                                            <xsl:variable name="pos" select="position()" />
                                            <xsl:value-of select="if($pos != last()) then concat($restriction, ',') else $restriction" />
                                        </xsl:for-each-group>
                                    </xsl:variable>

                                    <xsl:attribute name="circumstances" select="$distinct-restrictions-code-prescriber-sort" />

                                    <xsl:variable name="distinct-program-code">
                                        <xsl:for-each-group select="current-group()" group-by="PROGRAM_CODE">
                                            <xsl:variable name="pos" select="position()" />
                                            <xsl:value-of select="if($pos != last()) then concat(PROGRAM_CODE/text(), ' | ') else PROGRAM_CODE/text()" />
                                        </xsl:for-each-group>
                                    </xsl:variable>
                                    <xsl:attribute name="distinct-program-code" select="$distinct-program-code" />
                                    <xsl:attribute name="benefit_type" select="BENEFIT_TYPE_CODE/text()" />
                                </item>
                            </xsl:for-each-group>
                        </form>
                    </xsl:for-each-group>
                </drug>
            </xsl:for-each-group>
        </grouping>
    </xsl:variable>

    <xsl:variable name="added-groupings">
        <data>
            <xsl:for-each select="data/item">
                <xsl:variable name="drug" select="LI_DRUG_NAME/text()" />
                <xsl:variable name="form" select="LI_FORM/text()" />
                <xsl:variable name="item" select="PBS_CODE/text()" />

                <item>
                    <xsl:copy-of select="*[not(name()='RESTRICTIONS' or name()='MAX_PRESCRIBABLE_UNIT_OF_USE' or name()='NUMBER_OF_REPEATS')]" />

                    <!-- S100 grouping rules -->
                    <xsl:variable name="grouping_4_drug" select="$s100/grouping/drug[@value=$drug]/@distinct-program-code" />
                    <xsl:variable name="grouping_4_form" select="$s100/grouping/drug[@value=$drug]/form[@value=$form]/@distinct-program-code" />
                    <xsl:variable name="grouping_4_item" select="$s100/grouping/drug[@value=$drug]/form[@value=$form]/item[@code=$item]/@distinct-program-code" />
                    <xsl:variable name="prescriber" select="concat(PRESCRIBER/text(),'P')" />

                    <!-- S100 rules -->
                    <xsl:variable name="S100" select="if(mps:is-HSD-code($grouping_4_drug)= true()) then 'D(100)' (:Rule D1:)
                                            else if(mps:is-EFC-code($grouping_4_drug)= true()) then 'D(100)' (:Rule D2:)
                                            else if(mps:is-Growth-Hormone-code($grouping_4_drug)= true()) then 'D(100)' (:Rule D3:)
                                            else if(mps:is-IVF-code($grouping_4_drug)= true()) then 'D(100)' (:Rule D4:)
                                            else if(mps:is-Botulinium-Toxin-code($grouping_4_drug)= true()) then 'D(100)' (:Rule D5:)
                                            else if(mps:is-Opiate-Dependence-code($grouping_4_drug)= true()) then 'D(100)' (:Rule D6:)
                                            else if(mps:is-ParaQuad-code($grouping_4_drug)= true()) then 'D(100)' (:Rule D7:)
                                            else if(mps:is-HSD-code($grouping_4_drug)= false() and mps:is-HSD-code($grouping_4_form)= true()) then 'PB(100)' (:Rule PB1:)
                                            else if(mps:is-EFC-code($grouping_4_drug)= false() and mps:is-EFC-code($grouping_4_form)= true()) then 'PB(100)' (:Rule PB2:)
                                            else if(mps:is-Growth-Hormone-code($grouping_4_drug)= false() and mps:is-Growth-Hormone-code($grouping_4_form)= true()) then 'PB(100)' (:Rule PB3:)
                                            else if(mps:is-IVF-code($grouping_4_drug)= false() and mps:is-IVF-code($grouping_4_form)= true()) then 'PB(100)' (:Rule PB4:)
                                            else if(mps:is-Botulinium-Toxin-code($grouping_4_drug)= false() and mps:is-Botulinium-Toxin-code($grouping_4_form)= true()) then 'PB(100)' (:Rule PB5:)
                                            else if(mps:is-Opiate-Dependence-code($grouping_4_drug)= false() and mps:is-Opiate-Dependence-code($grouping_4_form)= true()) then 'PB(100)' (:Rule PB6:)
                                            else if(mps:is-ParaQuad-code($grouping_4_drug)= false() and mps:is-ParaQuad-code($grouping_4_form)= true()) then 'PB(100)' (:Rule PB7:)
                                            else if(mps:is-HSD-code($grouping_4_drug)= false() and mps:is-HSD-code($grouping_4_form)= false() and mps:is-dual-list-s100-with($grouping_4_form, 'GE')= true() and mps:is-HSD-code($grouping_4_item)= true()) then 'C(100)' (:Rule C1:)
                                            else if(mps:is-EFC-code($grouping_4_drug)= false() and mps:is-EFC-code($grouping_4_form)= false() and mps:is-dual-list-s100-with($grouping_4_form, 'GE')= true() and mps:is-EFC-code($grouping_4_item)= true()) then 'C(100)' (:Rule C2:)
                                            else if(mps:is-Growth-Hormone-code($grouping_4_drug)= false() and mps:is-Growth-Hormone-code($grouping_4_form)= false() and mps:is-dual-list-s100-with($grouping_4_form, 'GE')= true() and mps:is-Growth-Hormone-code($grouping_4_item)= true()) then 'C(100)' (:Rule C3:)
                                            else if(mps:is-IVF-code($grouping_4_drug)= false() and mps:is-IVF-code($grouping_4_form)= false() and mps:is-dual-list-s100-with($grouping_4_form, 'GE')= true() and mps:is-IVF-code($grouping_4_item)= true()) then 'C(100)' (:Rule C4:)
                                            else if(mps:is-Botulinium-Toxin-code($grouping_4_drug)= false() and mps:is-Botulinium-Toxin-code($grouping_4_form)= false() and mps:is-dual-list-s100-with($grouping_4_form, 'GE')= true() and mps:is-Botulinium-Toxin-code($grouping_4_item)= true()) then 'C(100)' (:Rule C5:)
                                            else if(mps:is-Opiate-Dependence-code($grouping_4_drug)= false() and mps:is-Opiate-Dependence-code($grouping_4_form)= false() and mps:is-dual-list-s100-with($grouping_4_form, 'GE')= true() and mps:is-Opiate-Dependence-code($grouping_4_item)= true()) then 'C(100)' (:Rule C6:)
                                            else if(mps:is-ParaQuad-code($grouping_4_drug)= false() and mps:is-ParaQuad-code($grouping_4_form)= false() and mps:is-dual-list-s100-with($grouping_4_form, 'GE')= true() and mps:is-ParaQuad-code($grouping_4_item)= true()) then 'C(100)' (:Rule C7:)
                                            else if(mps:is-db-only($grouping_4_drug)= true()) then concat('D(',$prescriber,')') (:Rule PresBagD1:)
                                            else if(mps:is-db-only($grouping_4_drug)= false() and mps:is-db-only($grouping_4_form)= true()) then concat('PB(',$prescriber,')') (:Rule PresBagPB1:)
                                            else if(mps:is-db-only($grouping_4_drug)= false() and mps:is-db-only($grouping_4_form)= true() and mps:is-dual-list-s100-with($grouping_4_form, 'GE')= true() and mps:is-db-only($grouping_4_item)= true()) then concat('C(',$prescriber,')') (:Rule PresBagC1:)
                                            else ''" />

                    <RESTRICTIONS><xsl:value-of select="if(mps:is-db-only($grouping_4_drug)= true() or
                                (mps:is-db-only($grouping_4_drug)= false() and mps:is-db-only($grouping_4_form))= true() or
                                (mps:is-db-only($grouping_4_drug)= false() and mps:is-db-only($grouping_4_form)= true() and mps:is-dual-list-s100-with($grouping_4_form, 'GE')= true() and mps:is-db-only($grouping_4_item)= true()))
                                    then concat('See Note 4 [',RESTRICTIONS/text(),']') else RESTRICTIONS/text()"/></RESTRICTIONS>
                    <MAX_PRESCRIBABLE_UNIT_OF_USE><xsl:value-of select="if(mps:is-db-only($grouping_4_drug)= true() or
                                (mps:is-db-only($grouping_4_drug)= false() and mps:is-db-only($grouping_4_form))= true() or
                                (mps:is-db-only($grouping_4_drug)= false() and mps:is-db-only($grouping_4_form)= true() and mps:is-dual-list-s100-with($grouping_4_form, 'GE')= true() and mps:is-db-only($grouping_4_item)= true()))
                                    then concat('See Note 4 [',MAX_PRESCRIBABLE_UNIT_OF_USE/text(),']') else MAX_PRESCRIBABLE_UNIT_OF_USE/text()"/></MAX_PRESCRIBABLE_UNIT_OF_USE>
                    <NUMBER_OF_REPEATS><xsl:value-of select="if(mps:is-db-only($grouping_4_drug)= true() or
                                (mps:is-db-only($grouping_4_drug)= false() and mps:is-db-only($grouping_4_form))= true() or
                                (mps:is-db-only($grouping_4_drug)= false() and mps:is-db-only($grouping_4_form)= true() and mps:is-dual-list-s100-with($grouping_4_form, 'GE')= true() and mps:is-db-only($grouping_4_item)= true()))
                                    then concat('See Note 4 [',NUMBER_OF_REPEATS/text(),']') else NUMBER_OF_REPEATS/text()"/></NUMBER_OF_REPEATS>
                    <xsl:element name="S100"><xsl:value-of select="$S100" /></xsl:element>
                </item>
            </xsl:for-each>
        </data>
    </xsl:variable>

    <!--    <xsl:attribute name="is-dual-listing-s100-with-ge" select="mps:is-dual-list-s100-with($drugtypecodes/drugtypecodes, 'GE')" />
-->

    <xsl:template match="/">
        <main>
            <!--<xsl:copy-of select="$s100" />-->
            <xsl:copy-of select="$added-groupings" />
        </main>
    </xsl:template>

</xsl:stylesheet>


