<?xml version="1.0" encoding="UTF-8"?>
<!--

   extract-item-table.xsl

   INPUT: PBS V3 XML file
   OUTPUT:  CSV file like beta PBS API of early September 2021

   Fields with no equivalent have - - - -
   Names and IDs should be correct.  Prices may be dodgy.

   Version: 2021-09-14  Rick Jelliffe

-->
<!--
   (C) Allette Systems 2021  Any use for PBS allowed
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:pbs="http://schema.pbs.gov.au/"
    xmlns:pbsfun="http://schema.pbs.gov.au/" xmlns:p="http://pbs.gov.au/"
    xmlns:dbk="http://docbook.org/ns/docbook" xmlns:db="http://docbook.org/ns/docbook#"
    xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:dct="http://purl.org/dc/terms/"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:owl="http://www.w3.org/2002/07/owl#" xmlns:skos="http://www.w3.org/2004/02/skos/core#"
    xmlns:svg="http://www.w3.org/2000/svg" xmlns:ext="http://extension.schema.pbs.gov.au/"
    xmlns:xlink="http://www.w3.org/1999/xlink" exclude-result-prefixes="xs" version="2.0">

    <xsl:output method="text"/>

    <xsl:key name="mp" match="/pbs:root/pbs:drugs-list/pbs:mp" use='concat("#", @xml:id)'/>

    <xsl:key name="mpp" match="/pbs:root/pbs:drugs-list/pbs:mpp" use='concat("#", @xml:id)'/>

    <xsl:key name="tpp" match="/pbs:root/pbs:drugs-list/pbs:tpp" use='concat("#", @xml:id)'/>

    <xsl:key name="tpuu" match="/pbs:root/pbs:drugs-list/pbs:tpuu" use='concat("#", @xml:id)'/>

    <xsl:template match="/">
        <xsl:text>"SCHEDULE_CODE","LI_ITEM_ID","DRUG_NAME","LI_DRUG_NAME","LI_FORM","BRAND_NAME","PROGRAM_CODE","PBS_CODE",</xsl:text>
        <xsl:text>"BENEFIT_TYPE_CODE","CAUTION_INDICATOR","NOTE_INDICATOR","MANNER_OF_ADMINISTRATION","MAXIMUM_PRESCRIBABLE_PACK","NUMBER_OF_REPEATS","ORGANISATION_ID","MANUFACTURER_CODE",</xsl:text>
        <xsl:text>"MAX_PRESCRIBABLE_UNIT_OF_USE","PRICING_QUANTITY","PACK_NOT_TO_BE_BROKEN_IND","MARK_UP_CODE","DISPENSE_FEE_TYPE_CODE","DANGEROUS_DRUG_FEE_CODE","BRAND_PREMIUM","THERAPEUTIC_GROUP_PREMIUM",</xsl:text>
        <xsl:text>"CMNWLTH_PRICE_TO_PHARMACIST","CMNWLTH_DSP_PRICE_MAX_QTTY","TGM_PRICE_PHRMCST","TGM_DISP_PRICE_MAX_QTTY","MAN_PRICE_TO_PHARMACIST","MAN_DISPNSD_PRICE_MAX_QTTY","MAX_RECORD_VAL_FOR_SAFETY_NET","CLAIMED_PRICE",</xsl:text>
        <xsl:text>"DETERMINED_PRICE","DETERMINED_QTTY","SAFETY_NET_RESUPPLY_RULE_DAYS","SAFTEY_NET_RESUP_RULE_CNT_IND","EXTEMPORANEOUS_INDICATOR","EXTEMPORANEOUS_STANDARD","DOCTORS_BAG_GROUP_ID","SECTION100_ONLY_INDICATOR",</xsl:text>
        <xsl:text>"DOCTORS_BAG_ONLY_INDICATOR","BRAND_SUBSTITION_GROUP_ID","BRAND_SUBSTITUTION_GROUP_CODE","CONTINUED_DISPENSING_CODE","SUPPLY_ONLY_INDICATOR","SUPPLY_ONLY_DATE","NON_EFFECTIVE_DATE","WEIGHTED_AVG_DISCLOSED_PRICE",</xsl:text>
        <xsl:text>"PERCENTAGE_APPLIED","ORIGINATOR_BRAND_INDICATOR","PAPER_MED_CHART_ELIGIBLE_IND","ELECT_MED_CHART_ELIGIBLE_IND","HSPTL_MED_CHART_ELIGIBLE_IND","PACK_CONTENT","VIAL_CONTENT","INFUSIBLE_INDICATOR",</xsl:text>
        <xsl:text>"UNIT_OF_MEASURE","MAXIMUM_AMOUNT","PBS_PIG_ID","PBS_MP_ID","PBS_MPP_ID","PBS_TPP_ID","PBS_MPUU_ID","PBS_TPUU_ID"</xsl:text>
        <xsl:text>&#x0D;</xsl:text>

        <xsl:apply-templates select="/pbs:root/pbs:schedule/pbs:program"/>

    </xsl:template>

    <xsl:function name="pbsfun:get-dispensing-rule-for-program">
        <!-- TODO: adapted from V2 code -->
        <xsl:param name="code"/>

        <xsl:choose>
            <!--  WHAT IS THIS?? -->
            <!--
            <xsl:when test="$program/ancestor::pbs:listings-list/pbs:dispensing-rules-list/pbs:dispensing-rule/ext:default">
                <xsl:value-of select="$program/ancestor::pbs:listings-list/pbs:dispensing-rules-list/pbs:dispensing-rule[ext:default]/@about"/>
            </xsl:when>
            -->
            <xsl:when test='$code = "HB" or $code = "SZ" or $code = "CT"'>
                <xsl:text>rp-s94-public-s100</xsl:text>
            </xsl:when>
            <xsl:when test='$code = "CA"'>
                <xsl:text>rp-s90-cp-s100</xsl:text>
            </xsl:when>
            <xsl:when test='$code = "HS" or $code = "SY"'>
                <xsl:text>rp-s94-private-s100</xsl:text>
            </xsl:when>
            <xsl:when test='$code = "DB"'>
                <xsl:text>rp-np-nc-s90-cp</xsl:text>
            </xsl:when>
            <xsl:when test='$code = "R1"'>
                <xsl:text>rp-np-s90-cp</xsl:text>
            </xsl:when>
            <xsl:when test='$code = "PQ"'>
                <xsl:text>rp-np-nc-ds-assoc</xsl:text>
            </xsl:when>
            <xsl:when test='$code = "GH" or $code = "IF" or $code = "MD" or $code = "MF"'>
                <xsl:text>rp-np-nc-ds-manu</xsl:text>
            </xsl:when>
            <xsl:when test='$code = "IP"'>
                <xsl:text>in-s94-public</xsl:text>
            </xsl:when>
            <xsl:when test='$code = "IN"'>
                <xsl:text>in-s90-cp</xsl:text>
            </xsl:when>
            <xsl:when test='$code = "TZ"'>
                <xsl:text>in-s94-public</xsl:text>
            </xsl:when>
            <xsl:when test='$code = "TY"'>
                <xsl:text>in-s90-cp-sa</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>rp-s90-cp</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>


    <xsl:template match="pbs:program">

        <xsl:variable name="program-code" select="pbs:info/pbs:code"/>
        <xsl:variable name="dispensing-rule"
            select="pbsfun:get-dispensing-rule-for-program($program-code)"/>
        <xsl:variable name="fallback-dr-partial"
            select="
                concat(
                if (contains($dispensing-rule, '-s90')) then
                    '-s90'
                else
                    if (contains($dispensing-rule, '-s94')) then
                        '-s94'
                    else
                        if (contains($dispensing-rule, '-public')) then
                            '-public'
                        else
                            ''
                ,
                if (contains($dispensing-rule, '-cp')) then
                    '-cp'
                else
                    if (contains($dispensing-rule, '-private')) then
                        '-private'
                    else
                        ''
                ,
                if (contains($dispensing-rule, '-s100')) then
                    '-s100'
                else
                    ''
                )"/>


        <xsl:for-each select="pbs:prescribing-rule[pbs:ready-prepared | pbs:infusible]">

            <xsl:variable name="pbs-item-code" select="pbs:code"/>
            <xsl:variable name="benefit-type-rdf"
                select="pbs:benefit-types-list/pbs:benefit-type/@rdf:resource"/>
            <xsl:variable name="continued-dispensing"
                select="pbs:member-of-list/pbs:member-of[starts-with(@rdf:resource, 'http://pbs.gov.au/continued-dispensing')]/pbs:code"/>
            <xsl:variable name="preferred-term" select="pbs:preferred-term"/>


            <!-- * means pbs:ready-prepared or pbs:infusable -->
            <xsl:for-each select="*[pbs:product-listing]">
                <xsl:variable name="mpp" select="key('mpp', pbs:mpp-reference/@xlink:href)"
                    as="element()?"/>
                <xsl:variable name="mp" select="key('mp', pbs:mp-reference/@xlink:href)"
                    as="element()?"/>
                <xsl:variable name="tpp" select="key('tpp', pbs:tpp-reference/@xlink:href)" />

                <xsl:variable name="manner-of-administration"
                    select="pbs:member-of-list/pbs:member-of/pbs:code[@rdf:resource = 'http://pbs.gov.au/code/manner-of-administration']"/>
                <xsl:variable name="number-repeats" select="pbs:number-repeats/pbs:value"/>
                <xsl:variable name="maximum-pack"
                    select="pbs:maximum-prescribable[@rdf:resource = 'http://pbs.gov.au/reference/pack']/pbs:value"/>
                <xsl:variable name="unit-of-use"
                    select="pbs:maximum-prescribable[@rdf:resource = 'http://pbs.gov.au/reference/unit-of-use']/pbs:value"/>
                <xsl:variable name="pack-breakability"
                    select="pbs:member-of-list/pbs:member-of[starts-with(@rdf:resource, 'http://pbs.gov.au/pack-breakability')]/pbs:code"/>
                <xsl:variable name="safety-net-duration" select="pbs:safety-net/pbs:duration"/>
                <xsl:variable name="local-mpp-reference"
                    select="(pbs:mpp-reference/pbs:code[starts-with(@rdf:resource, 'http://snomed.info/sct/')])[1]"/>

                <xsl:for-each select="pbs:product-listing">

                    <!--"SCHEDULE_CODE","LI_ITEM_ID","DRUG_NAME","LI_DRUG_NAME","LI_FORM","BRAND_NAME","PROGRAM_CODE","PBS_CODE",-->
                    <xsl:call-template name="SCHEDULE_CODE"/>
                    <xsl:call-template name="LI_ITEM_ID">
                        <xsl:with-param name="pbs-item-code" select="$pbs-item-code"/>
                    </xsl:call-template>
                    <xsl:call-template name="DRUG_NAME">
                        <xsl:with-param name="mpp" select="$mpp"/>
                        <xsl:with-param name="mp" select="$mp"/>
                    </xsl:call-template>
                    <xsl:call-template name="LI_DRUG_NAME">
                        <xsl:with-param name="mpp" select="$mpp"/>
                        <xsl:with-param name="mp" select="$mp"/>
                    </xsl:call-template>
                    <xsl:call-template name="LI_FORM"/>
                    <!--
                    pbs:pharmaceutical-item[pbs:dr/pbs:block-container/dnk:para[1]
                    -->
                    <xsl:call-template name="BRAND_NAME"/>
                    <!--
                    pbs:drugs-list/pbs:tpuu/pbs:brand-name/pbs:value
                    -->
                    <xsl:call-template name="PROGRAM_CODE">
                        <xsl:with-param name="program-code" select="$program-code"/>
                    </xsl:call-template>
                    <xsl:call-template name="PBS_CODE">
                        <xsl:with-param name="pbs-item-code" select="$pbs-item-code"/>
                    </xsl:call-template>


                    <!--"BENEFIT_TYPE_CODE","CAUTION_INDICATOR","NOTE_INDICATOR","MANNER_OF_ADMINISTRATION","MAXIMUM_PRESCRIBABLE_PACK","NUMBER_OF_REPEATS","ORGANISATION_ID","MANUFACTURER_CODE",-->
                    <xsl:call-template name="BENEFIT_TYPE_CODE">
                        <xsl:with-param name="benefit-type-rdf" select="$benefit-type-rdf"/>
                    </xsl:call-template>
                    <xsl:call-template name="CAUTION_INDICATOR"/>
                    <xsl:call-template name="NOTE_INDICATOR"/>
                    <xsl:call-template name="MANNER_OF_ADMINISTRATION">
                        <xsl:with-param name="manner-of-administration"
                            select="$manner-of-administration"/>
                    </xsl:call-template>
                    <xsl:call-template name="MAXIMUM_PRESCRIBABLE_PACK">
                        <xsl:with-param name="maximum-pack" select="$maximum-pack"/>
                    </xsl:call-template>
                    <xsl:call-template name="NUMBER_OF_REPEATS">
                        <xsl:with-param name="number-repeats" select="$number-repeats"/>
                    </xsl:call-template>
                    <xsl:call-template name="ORGANISATION_ID"/>
                    <xsl:call-template name="MANUFACTURER_CODE"/>

                    <!--"MAX_PRESCRIBABLE_UNIT_OF_USE","PRICING_QUANTITY","PACK_NOT_TO_BE_BROKEN_IND","MARK_UP_CODE","DISPENSE_FEE_TYPE_CODE","DANGEROUS_DRUG_FEE_CODE","BRAND_PREMIUM","THERAPEUTIC_GROUP_PREMIUM",-->
                    <xsl:call-template name="MAX_PRESCRIBABLE_UNIT_OF_USE">
                        <xsl:with-param name="unit-of-use" select="$unit-of-use"/>
                    </xsl:call-template>
                    <xsl:call-template name="PRICING_QUANTITY"/>
                    <xsl:call-template name="PACK_NOT_TO_BE_BROKEN_IND">
                        <xsl:with-param name="pack-breakability" select="$pack-breakability"/>
                    </xsl:call-template>
                    <xsl:call-template name="MARK_UP_CODE"/>
                    <xsl:call-template name="DISPENSE_FEE_TYPE_CODE"/>
                    <xsl:call-template name="DANGEROUS_DRUG_FEE_CODE"/>
                    <xsl:call-template name="BRAND_PREMIUM">
                        <xsl:with-param name="dispensing-rule" select="$dispensing-rule"/>
                        <xsl:with-param name="fallback-dr-partial" select="$fallback-dr-partial"/>
                    </xsl:call-template>
                    <xsl:call-template name="THERAPEUTIC_GROUP_PREMIUM">
                        <xsl:with-param name="dispensing-rule" select="$dispensing-rule"/>
                        <xsl:with-param name="fallback-dr-partial" select="$fallback-dr-partial"/>
                    </xsl:call-template>

                    <!--"CMNWLTH_PRICE_TO_PHARMACIST","CMNWLTH_DSP_PRICE_MAX_QTTY","TGM_PRICE_PHRMCST","TGM_DISP_PRICE_MAX_QTTY","MAN_PRICE_TO_PHARMACIST","MAN_DISPNSD_PRICE_MAX_QTTY","MAX_RECORD_VAL_FOR_SAFETY_NET","CLAIMED_PRICE",-->
                    <xsl:call-template name="CMNWLTH_PRICE_TO_PHARMACIST">
                        <xsl:with-param name="dispensing-rule" select="$dispensing-rule"/>
                        <xsl:with-param name="fallback-dr-partial" select="$fallback-dr-partial"/>
                    </xsl:call-template>
                    <xsl:call-template name="CMNWLTH_DSP_PRICE_MAX_QTTY"/>
                    <xsl:call-template name="TGM_PRICE_PHRMCST"/>
                    <xsl:call-template name="TGM_DISP_PRICE_MAX_QTTY"/>
                    <xsl:call-template name="MAN_PRICE_TO_PHARMACIST">
                        <xsl:with-param name="dispensing-rule" select="$dispensing-rule"/>
                        <xsl:with-param name="fallback-dr-partial" select="$fallback-dr-partial"/>
                    </xsl:call-template>
                    <xsl:call-template name="MAN_DISPNSD_PRICE_MAX_QTTY">
                        <xsl:with-param name="dispensing-rule" select="$dispensing-rule"/>
                        <xsl:with-param name="fallback-dr-partial" select="$fallback-dr-partial"/>
                    </xsl:call-template>
                    <xsl:call-template name="MAX_RECORD_VAL_FOR_SAFETY_NET">
                        <xsl:with-param name="dispensing-rule" select="$dispensing-rule"/>
                        <xsl:with-param name="fallback-dr-partial" select="$fallback-dr-partial"/>
                    </xsl:call-template>
                    <xsl:call-template name="CLAIMED_PRICE"/>

                    <!--"DETERMINED_PRICE","DETERMINED_QTTY","SAFETY_NET_RESUPPLY_RULE_DAYS","SAFTEY_NET_RESUP_RULE_CNT_IND","EXTEMPORANEOUS_INDICATOR","EXTEMPORANEOUS_STANDARD","DOCTORS_BAG_GROUP_ID","SECTION100_ONLY_INDICATOR",-->
                    <xsl:call-template name="DETERMINED_PRICE"/>
                    <xsl:call-template name="DETERMINED_QTTY"/>
                    <xsl:call-template name="SAFETY_NET_RESUPPLY_RULE_DAYS">
                        <xsl:with-param name="safety-net-duration" select="$safety-net-duration"/>
                    </xsl:call-template>
                    <xsl:call-template name="SAFTEY_NET_RESUP_RULE_CNT_IND"/>
                    <xsl:call-template name="EXTEMPORANEOUS_INDICATOR"/>
                    <xsl:call-template name="EXTEMPORANEOUS_STANDARD"/>
                    <xsl:call-template name="DOCTORS_BAG_GROUP_ID"/>
                    <xsl:call-template name="SECTION100_ONLY_INDICATOR"/>

                    <!--"DOCTORS_BAG_ONLY_INDICATOR","BRAND_SUBSTITION_GROUP_ID","BRAND_SUBSTITUTION_GROUP_CODE","CONTINUED_DISPENSING_CODE","SUPPLY_ONLY_INDICATOR","SUPPLY_ONLY_DATE","NON_EFFECTIVE_DATE","WEIGHTED_AVG_DISCLOSED_PRICE",-->
                    <xsl:call-template name="DOCTORS_BAG_ONLY_INDICATOR"/>
                    <xsl:call-template name="BRAND_SUBSTITION_GROUP_ID"/>
                    <xsl:call-template name="BRAND_SUBSTITUTION_GROUP_CODE"/>
                    <xsl:call-template name="CONTINUED_DISPENSING_CODE">
                        <xsl:with-param name="continued-dispensing" select="$continued-dispensing"/>
                    </xsl:call-template>
                    <xsl:call-template name="SUPPLY_ONLY_INDICATOR"/>
                    <xsl:call-template name="SUPPLY_ONLY_DATE"/>
                    <xsl:call-template name="NON_EFFECTIVE_DATE"/>
                    <xsl:call-template name="WEIGHTED_AVG_DISCLOSED_PRICE"/>

                    <!--"PERCENTAGE_APPLIED","ORIGINATOR_BRAND_INDICATOR","PAPER_MED_CHART_ELIGIBLE_IND","ELECT_MED_CHART_ELIGIBLE_IND","HSPTL_MED_CHART_ELIGIBLE_IND","PACK_CONTENT","VIAL_CONTENT","INFUSIBLE_INDICATOR",-->
                    <xsl:call-template name="PERCENTAGE_APPLIED"/>
                    <xsl:call-template name="ORIGINATOR_BRAND_INDICATOR"/>
                    <xsl:call-template name="PAPER_MED_CHART_ELIGIBLE_IND"/>
                    <xsl:call-template name="ELECT_MED_CHART_ELIGIBLE_IND"/>
                    <xsl:call-template name="HSPTL_MED_CHART_ELIGIBLE_IND"/>
                    <xsl:call-template name="PACK_CONTENT"/>
                    <xsl:call-template name="VIAL_CONTENT"/>
                    <xsl:call-template name="INFUSIBLE_INDICATOR"/>

                    <!--"UNIT_OF_MEASURE","MAXIMUM_AMOUNT","PBS_PIG_ID","PBS_MP_ID","PBS_MPP_ID","PBS_TPP_ID","PBS_MPUU_ID","PBS_TPUU_ID"-->
                    <xsl:call-template name="UNIT_OF_MEASURE"/>
                    <xsl:call-template name="MAXIMUM_AMOUNT"/>
                    <xsl:call-template name="PBS_PIG_ID"/>
                    <xsl:call-template name="PBS_MP_ID">
                        <xsl:with-param name="mpp" select="$mpp"/>
                        <xsl:with-param name="mp" select="$mp"/>
                    </xsl:call-template>
                    <xsl:call-template name="PBS_MPP_ID">
                        <xsl:with-param name="local-mpp-reference" select="$local-mpp-reference"/>
                    </xsl:call-template>
                    <xsl:call-template name="PBS_TPP_ID" />
                    <xsl:call-template name="PBS_MPUU_ID"/>
                    <xsl:call-template name="PBS_TPUU_ID"/>
                    <xsl:text>&#x0D;</xsl:text>
                </xsl:for-each>
            </xsl:for-each>
        </xsl:for-each>

    </xsl:template>

    <!--SCHEDULE_CODE","LI_ITEM_ID","DRUG_NAME","LI_DRUG_NAME","LI_FORM","BRAND_NAME","PROGRAM_CODE","PBS_CODE",-->
    <xsl:template name="SCHEDULE_CODE">
        <!-- No schedule code in PBS XML -->
        <xsl:text>----</xsl:text>
        <xsl:text>,</xsl:text>
    </xsl:template>

    <xsl:template name="LI_ITEM_ID">
        <xsl:param name="pbs-item-code"/>
        <xsl:value-of select="$pbs-item-code"/>
        <xsl:text>_----:TBA,</xsl:text>
    </xsl:template>

    <xsl:template name="DRUG_NAME">
        <xsl:param name="mpp"/>
        <xsl:param name="mp"/>

        <xsl:choose>
            <xsl:when test="parent::pbs:infusible">
                <xsl:value-of
                    select="$mp/pbs:preferred-term[@rdf:resource = 'http://pbs.gov.au/clinical']"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="this-mp"
                    select="key('mp', $mpp/pbs:drug-references-list/pbs:mp-reference/@xlink:href)"/>
                <xsl:variable name="mp-term"
                    select="normalize-space($this-mp/pbs:preferred-term[@rdf:resource = 'http://pbs.gov.au/clinical'])"/>
                <xsl:value-of select="$mp-term"/>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:text>,</xsl:text>
    </xsl:template>

    <xsl:template name="LI_DRUG_NAME">
        <xsl:param name="mpp"/>
        <xsl:param name="mp"/>


        <xsl:choose>
            <xsl:when test="parent::pbs:infusible">
                <xsl:value-of
                    select="$mp/pbs:preferred-term[@rdf:resource = 'http://pbs.gov.au/legal']"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="this-mp"
                    select="key('mp', $mpp/pbs:drug-references-list/pbs:mp-reference/@xlink:href)"/>
                <xsl:value-of
                    select="normalize-space($this-mp/pbs:preferred-term[@rdf:resource = 'http://pbs.gov.au/legal'])"/>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:text>,</xsl:text>
    </xsl:template>

    <xsl:template name="LI_FORM">
        <xsl:text>,</xsl:text>
    </xsl:template>

    <xsl:template name="BRAND_NAME">
       <xsl:choose>
           <xsl:when test="parent::pbs:infusible">
               <xsl:value-of select="key('tpuu', pbs:tpuu-reference/@xlink:href)/pbs:brand-name/pbs:value"/>
           </xsl:when>
           <xsl:otherwise>
               <xsl:value-of select="key('tpp', pbs:tpp-reference/@xlink:href)/pbs:brand-name/pbs:value"/>
           </xsl:otherwise>
       </xsl:choose>
        <xsl:text>,</xsl:text>
    </xsl:template>

    <xsl:template name="PROGRAM_CODE">
        <xsl:param name="program-code"/>
        <xsl:value-of select="$program-code"/>
        <xsl:text>,</xsl:text>
    </xsl:template>

    <xsl:template name="PBS_CODE">
        <xsl:param name="pbs-item-code"/>
        <xsl:value-of select="$pbs-item-code"/>
        <xsl:text>,</xsl:text>
    </xsl:template>



    <!--"BENEFIT_TYPE_CODE","CAUTION_INDICATOR","NOTE_INDICATOR","MANNER_OF_ADMINISTRATION","MAXIMUM_PRESCRIBABLE_PACK","NUMBER_OF_REPEATS","ORGANISATION_ID","MANUFACTURER_CODE",-->
    <xsl:template name="BENEFIT_TYPE_CODE">
        <xsl:param name="benefit-type-rdf"/>
        <!-- TODO: check if these are correct -->
        <xsl:choose>
            <xsl:when test="ends-with($benefit-type-rdf, 'streamlined')">
                <xsl:text>S</xsl:text>
            </xsl:when>
            <xsl:when test="contains($benefit-type-rdf, 'authority')">
                <xsl:text>S</xsl:text>
            </xsl:when>
            <xsl:when test="contains($benefit-type-rdf, 'unrestricted')">
                <xsl:text>U</xsl:text>
            </xsl:when>
            <xsl:when test="contains($benefit-type-rdf, 'restricted')">
                <xsl:text>R</xsl:text>
            </xsl:when>
            <xsl:otherwise>U?</xsl:otherwise>
        </xsl:choose>
        <xsl:text>,</xsl:text>
    </xsl:template>

    <xsl:template name="CAUTION_INDICATOR">
        <xsl:text>,</xsl:text>
    </xsl:template>

    <xsl:template name="NOTE_INDICATOR">
        <xsl:text>,</xsl:text>
    </xsl:template>

    <xsl:template name="MANNER_OF_ADMINISTRATION">
        <xsl:param name="manner-of-administration"/>
        <xsl:value-of select="upper-case($manner-of-administration)"/>
        <xsl:text>,</xsl:text>
    </xsl:template>

    <xsl:template name="MAXIMUM_PRESCRIBABLE_PACK">
        <xsl:param name="maximum-pack"/>
        <xsl:value-of select="$maximum-pack"/>
        <xsl:text>,</xsl:text>
    </xsl:template>

    <xsl:template name="NUMBER_OF_REPEATS">
        <xsl:param name="number-repeats"/>
        <xsl:value-of select="$number-repeats"/>
        <xsl:text>,</xsl:text>
    </xsl:template>

    <xsl:template name="ORGANISATION_ID">
        <!-- Not found in PBS XML prescribing rule-->
        <xsl:text>,</xsl:text>
    </xsl:template>

    <xsl:template name="MANUFACTURER_CODE">
        <xsl:value-of select="pbs:code[@rdf:resource = 'http://pbs.gov.au/code/manufacturer']"/>
        <xsl:text>,</xsl:text>
    </xsl:template>


    <!--"MAX_PRESCRIBABLE_UNIT_OF_USE","PRICING_QUANTITY","PACK_NOT_TO_BE_BROKEN_IND","MARK_UP_CODE","DISPENSE_FEE_TYPE_CODE","DANGEROUS_DRUG_FEE_CODE","BRAND_PREMIUM","THERAPEUTIC_GROUP_PREMIUM",-->
    <xsl:template name="MAX_PRESCRIBABLE_UNIT_OF_USE">
        <xsl:param name="unit-of-use"/>
        <xsl:value-of select="$unit-of-use"/>
        <xsl:text>,</xsl:text>
    </xsl:template>

    <xsl:template name="PRICING_QUANTITY">
        <xsl:text>,</xsl:text>
    </xsl:template>

    <xsl:template name="PACK_NOT_TO_BE_BROKEN_IND">
        <xsl:param name="pack-breakability"/>
        <xsl:value-of
            select="
                if ($pack-breakability = 'not-breakable') then
                    'Y'
                else
                    'N'"/>
        <xsl:text>,</xsl:text>
    </xsl:template>

    <xsl:template name="MARK_UP_CODE">
        <xsl:text>,</xsl:text>
    </xsl:template>

    <xsl:template name="DISPENSE_FEE_TYPE_CODE">
        <xsl:text>,</xsl:text>
    </xsl:template>

    <xsl:template name="DANGEROUS_DRUG_FEE_CODE">
        <xsl:text>,</xsl:text>
    </xsl:template>

    <xsl:template name="BRAND_PREMIUM">
        <xsl:param name="dispensing-rule"/>
        <xsl:param name="fallback-dr-partial"/>


        <xsl:variable name="specific-price" as="element()?"
            select="pbs:manufacturer/pbs:dpmq/pbs:price[pbs:dispensing-rule-reference/pbs:code = $dispensing-rule]/pbs:contribution[pbs:type = 'contrib:brand-premium']"/>

        <xsl:variable name="fallback-price"
            select="pbs:manufacturer/pbs:dpmq/pbs:price[ends-with(pbs:dispensing-rule-reference/pbs:code, $fallback-dr-partial)][1]/pbs:contribution[pbs:type = 'contrib:brand-premium']"
            as="element()?"/>
        <xsl:variable name="price" as="element()?"
            select="
                if ($specific-price) then
                    $specific-price
                else
                    $fallback-price"/>


        <xsl:variable name="bp"
            select="$price/pbs:contribution[@rdf:resource = 'http://pbs.gov.au/contribution/brand']/pbs:amount"/>

        <xsl:value-of
            select="
                if ($bp) then
                    $bp
                else
                    '0'"/>
        <xsl:text>,</xsl:text>
    </xsl:template>

    <xsl:template name="THERAPEUTIC_GROUP_PREMIUM">
        <xsl:param name="dispensing-rule"/>
        <xsl:param name="fallback-dr-partial"/>
        <xsl:text>,</xsl:text>
    </xsl:template>


    <!--"CMNWLTH_PRICE_TO_PHARMACIST","CMNWLTH_DSP_PRICE_MAX_QTTY","TGM_PRICE_PHRMCST","TGM_DISP_PRICE_MAX_QTTY","MAN_PRICE_TO_PHARMACIST","MAN_DISPNSD_PRICE_MAX_QTTY","MAX_RECORD_VAL_FOR_SAFETY_NET","CLAIMED_PRICE",-->
    <xsl:template name="CMNWLTH_PRICE_TO_PHARMACIST">
        <xsl:param name="dispensing-rule"/>
        <xsl:param name="fallback-dr-partial"/>

        <xsl:variable name="specific-price" as="element()?"
            select="pbs:reimbursement/pbs:to-pharmacist/pbs:price[pbs:dispensing-rule-reference/pbs:code = $dispensing-rule]"/>

        <xsl:variable name="fallback-price"
            select="pbs:reimbursement/pbs:to-pharmacist//pbs:price[ends-with(pbs:dispensing-rule-reference/pbs:code, $fallback-dr-partial)][1]"
            as="element()?"/>
        <xsl:variable name="price" as="element()?"
            select="
                if ($specific-price) then
                    $specific-price
                else
                    $fallback-price"/>


        <xsl:value-of select="$price/pbs:amount"/>

        <xsl:text>,</xsl:text>
    </xsl:template>

    <xsl:template name="CMNWLTH_DSP_PRICE_MAX_QTTY">
        <xsl:text>,</xsl:text>
    </xsl:template>

    <xsl:template name="TGM_PRICE_PHRMCST">
        <xsl:text>,</xsl:text>
    </xsl:template>

    <xsl:template name="TGM_DISP_PRICE_MAX_QTTY">
        <xsl:text>,</xsl:text>
    </xsl:template>

    <xsl:template name="MAN_PRICE_TO_PHARMACIST">
        <xsl:param name="dispensing-rule"/>
        <xsl:param name="fallback-dr-partial"/>
        <!-- SEEMS WRONG:  pbs:pharmacist not to-pharmacist ??? -->

        <xsl:variable name="specific-price" as="element()?"
            select="pbs:manufacturer/pbs:to-pharmacist/pbs:price[pbs:dispensing-rule-reference/pbs:code = $dispensing-rule]"/>

        <xsl:variable name="fallback-price"
            select="pbs:manufacturer/pbs:to-pharmacist/pbs:price[ends-with(pbs:dispensing-rule-reference/pbs:code, $fallback-dr-partial)][1]"
            as="element()?"/>
        <xsl:variable name="price" as="element()?"
            select="
                if ($specific-price) then
                    $specific-price
                else
                    $fallback-price"/>

        <xsl:value-of
            select="
                if (parent::pbs:infusible) then
                    pbs:reimbursement/pbs:ex-manufacturer/pbs:amount
                else
                    $price/pbs:amount"/>
        <xsl:text>,</xsl:text>
    </xsl:template>

    <xsl:template name="MAN_DISPNSD_PRICE_MAX_QTTY">
        <xsl:param name="dispensing-rule"/>
        <xsl:param name="fallback-dr-partial"/>

        <xsl:variable name="specific-price" as="element()?"
            select="pbs:manufacturer/pbs:dpmq/pbs:price[pbs:dispensing-rule-reference/pbs:code = $dispensing-rule]"/>

        <xsl:variable name="fallback-price"
            select="pbs:manufacturer/pbs:dpmq/pbs:price[ends-with(pbs:dispensing-rule-reference/pbs:code, $fallback-dr-partial)][1]"
            as="element()?"/>
        <xsl:variable name="price" as="element()?"
            select="
                if ($specific-price) then
                    $specific-price
                else
                    $fallback-price"/>

        <xsl:value-of select="$price/pbs:amount"/>
        <xsl:text>,</xsl:text>
    </xsl:template>

    <xsl:template name="MAX_RECORD_VAL_FOR_SAFETY_NET">
        <xsl:param name="dispensing-rule"/>
        <xsl:param name="fallback-dr-partial"/>

        <xsl:variable name="specific-price"
            select="pbs:maximum-safety-net-value/pbs:price[pbs:dispensing-rule-reference/pbs:code = $dispensing-rule]"
            as="element()?"/>


        <xsl:variable name="fallback-price"
            select="pbs:maximum-safety-net-value/pbs:price[ends-with(pbs:dispensing-rule-reference/pbs:code, $fallback-dr-partial)][1]"
            as="element()?"/>

        <xsl:variable name="price" as="element()?"
            select="
                if ($specific-price) then
                    $specific-price
                else
                    $fallback-price"/>

        <xsl:value-of select="$price/pbs:amount"/>
        <xsl:text>,</xsl:text>
    </xsl:template>

    <!-- TODO: is this this? Or is it the special case for infusions for man price to pharmacist ?? -->
    <xsl:template name="CLAIMED_PRICE">
        <xsl:param name="dispensing-rule"/>

        <xsl:variable name="price" select="pbs:reimbursement/pbs:ex-manufacturer" as="element()?"/>

        <xsl:value-of select="$price/pbs:amount"/>
        <xsl:text>,</xsl:text>
    </xsl:template>


    <!--"DETERMINED_PRICE","DETERMINED_QTTY","SAFETY_NET_RESUPPLY_RULE_DAYS","SAFTEY_NET_RESUP_RULE_CNT_IND","EXTEMPORANEOUS_INDICATOR","EXTEMPORANEOUS_STANDARD","DOCTORS_BAG_GROUP_ID","SECTION100_ONLY_INDICATOR",-->
    <xsl:template name="DETERMINED_PRICE">
        <xsl:text>,</xsl:text>
    </xsl:template>

    <xsl:template name="DETERMINED_QTTY">
        <xsl:text>,</xsl:text>
    </xsl:template>

    <xsl:template name="SAFETY_NET_RESUPPLY_RULE_DAYS">
        <xsl:param name="safety-net-duration"/>
        <!-- TODO  convert P20D  to 20 -->
        <xsl:value-of select="$safety-net-duration"/>
        <xsl:text>,</xsl:text>
    </xsl:template>

    <xsl:template name="SAFTEY_NET_RESUP_RULE_CNT_IND">
        <xsl:text>,</xsl:text>
    </xsl:template>

    <xsl:template name="EXTEMPORANEOUS_INDICATOR">
        <xsl:text>,</xsl:text>
    </xsl:template>

    <xsl:template name="EXTEMPORANEOUS_STANDARD">
        <xsl:text>,</xsl:text>
    </xsl:template>

    <xsl:template name="DOCTORS_BAG_GROUP_ID">
        <xsl:text>,</xsl:text>
    </xsl:template>

    <xsl:template name="SECTION100_ONLY_INDICATOR">
        <xsl:text>,</xsl:text>
    </xsl:template>


    <!--"DOCTORS_BAG_ONLY_INDICATOR","BRAND_SUBSTITION_GROUP_ID","BRAND_SUBSTITUTION_GROUP_CODE","CONTINUED_DISPENSING_CODE","SUPPLY_ONLY_INDICATOR","SUPPLY_ONLY_DATE","NON_EFFECTIVE_DATE","WEIGHTED_AVG_DISCLOSED_PRICE",-->
    <xsl:template name="DOCTORS_BAG_ONLY_INDICATOR">
        <xsl:text>,</xsl:text>
    </xsl:template>

    <xsl:template name="BRAND_SUBSTITION_GROUP_ID">
        <xsl:text>,</xsl:text>
    </xsl:template>

    <xsl:template name="BRAND_SUBSTITUTION_GROUP_CODE">
        <xsl:text>,</xsl:text>
    </xsl:template>

    <xsl:template name="CONTINUED_DISPENSING_CODE">
        <xsl:param name="continued-dispensing"/>
        <xsl:value-of
            select="
                if ($continued-dispensing = 'eligible') then
                    'true'
                else
                    'false'"/>
        <xsl:text>,</xsl:text>
    </xsl:template>

    <xsl:template name="SUPPLY_ONLY_INDICATOR">
        <xsl:text>,</xsl:text>
    </xsl:template>

    <xsl:template name="SUPPLY_ONLY_DATE">
        <xsl:text>,</xsl:text>
    </xsl:template>

    <xsl:template name="NON_EFFECTIVE_DATE">
        <xsl:text>,</xsl:text>
    </xsl:template>

    <xsl:template name="WEIGHTED_AVG_DISCLOSED_PRICE">
        <xsl:text>,</xsl:text>
    </xsl:template>


    <!--"PERCENTAGE_APPLIED","ORIGINATOR_BRAND_INDICATOR","PAPER_MED_CHART_ELIGIBLE_IND","ELECT_MED_CHART_ELIGIBLE_IND","HSPTL_MED_CHART_ELIGIBLE_IND","PACK_CONTENT","VIAL_CONTENT","INFUSIBLE_INDICATOR",-->
    <xsl:template name="PERCENTAGE_APPLIED">
        <xsl:text>,</xsl:text>
    </xsl:template>

    <xsl:template name="ORIGINATOR_BRAND_INDICATOR">
        <xsl:text>,</xsl:text>
    </xsl:template>

    <xsl:template name="PAPER_MED_CHART_ELIGIBLE_IND">
        <xsl:text>,</xsl:text>
    </xsl:template>

    <xsl:template name="ELECT_MED_CHART_ELIGIBLE_IND">
        <xsl:text>,</xsl:text>
    </xsl:template>

    <xsl:template name="HSPTL_MED_CHART_ELIGIBLE_IND">
        <xsl:text>,</xsl:text>
    </xsl:template>

    <xsl:template name="PACK_CONTENT">
        <xsl:text>,</xsl:text>
    </xsl:template>

    <xsl:template name="VIAL_CONTENT">
        <xsl:if test="parent::pbs:infusible">
            <xsl:variable name="content"
                select="key('tpuu', pbs:tpuu-reference/@xlink:href)/pbs:content[starts-with(@rdf:resource, 'http://pbs.gov.au/reference/unit-of-measure')]"/>
            <xsl:value-of select="$content"/>
        </xsl:if>
        <xsl:text>,</xsl:text>
    </xsl:template>

    <xsl:template name="INFUSIBLE_INDICATOR">
        <!--  CHECK: is this really supposed to be the injectable indicator?  -->
        <xsl:value-of
            select="
                if (parent::pbs:infusible) then
                    'Y'
                else
                    'N'"/>
        <xsl:text>,</xsl:text>
    </xsl:template>


    <!--"UNIT_OF_MEASURE","MAXIMUM_AMOUNT","PBS_PIG_ID","PBS_MP_ID","PBS_MPP_ID","PBS_TPP_ID","PBS_MPUU_ID","PBS_TPUU_ID"-->
    <xsl:template name="UNIT_OF_MEASURE">
        <xsl:variable name="content"
            select="key('tpuu', pbs:tpuu-reference/@xlink:href)/pbs:content[starts-with(@rdf:resource, 'http://pbs.gov.au/reference/unit-of-measure')]"
            as="element()?"/>
        <xsl:value-of
            select="substring-after($content/@rdf:resource, 'http://pbs.gov.au/reference/unit-of-measure/')"/>
        <xsl:text>,</xsl:text>
    </xsl:template>

    <xsl:template name="MAXIMUM_AMOUNT">
        <xsl:text>,</xsl:text>
    </xsl:template>

    <xsl:template name="PBS_PIG_ID">
        <!-- Not available in PBS XML -->
        <xsl:text>----,</xsl:text>
    </xsl:template>

    <xsl:template name="PBS_MP_ID">
        <xsl:param name="mpp"/>
        <xsl:param name="mp"/>

        <xsl:choose>
            <xsl:when test="parent::pbs:infusible">
               <xsl:value-of
                    select="substring-before($mp/pbs:code[@rdf:resource = 'http://pbs.gov.au/Drug/MP'], 'P')"/>
            </xsl:when>
            <xsl:otherwise>

        <xsl:variable name="this-mp"
            select="key('mp', $mpp/pbs:drug-references-list/pbs:mp-reference/@xlink:href)"/>
        <xsl:value-of
            select="substring-before($this-mp/pbs:code[@rdf:resource = 'http://pbs.gov.au/Drug/MP'], 'P')"/>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:text>,</xsl:text>
    </xsl:template>

    <xsl:template name="PBS_MPP_ID">
        <xsl:param name="local-mpp-reference"/>
        <!-- TODO only 4. Is this the right source? -->
        <xsl:value-of select="substring($local-mpp-reference, 1, 4)"/>
        <xsl:text>,</xsl:text>
    </xsl:template>

    <xsl:template name="PBS_TPP_ID">
        <xsl:choose>
            <xsl:when test="parent::pbs:infusible">
                <xsl:variable name="my-tp" select="key('tpuu', pbs:tpuu-reference/@xlink:href)" />
                <xsl:value-of
                    select="substring(($my-tp/pbs:code[starts-with(@rdf:resource, 'http://snomed.info/sct/')])[1], 1, 4)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of
                    select="substring((pbs:tpp-reference/pbs:code[starts-with(@rdf:resource, 'http://snomed.info/sct/')])[1], 1, 4)"/>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:text>,</xsl:text>
    </xsl:template>

    <xsl:template name="PBS_MPUU_ID">
        <!-- No MPUU ID in PBS XML -->
        <xsl:text>----,</xsl:text>
    </xsl:template>

    <xsl:template name="PBS_TPUU_ID">
        <xsl:value-of select="pbs:tpuu-reference/pbs:code"/>
    </xsl:template>



</xsl:stylesheet>
