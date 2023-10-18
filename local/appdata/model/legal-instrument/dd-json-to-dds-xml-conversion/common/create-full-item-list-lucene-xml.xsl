<?xml version="1.0" encoding="utf-8"?>
<!--
  This is a transformation Json document to XML

  @author Adriano Akaishi
  @date 14/09/2022
  @copyright Allette Systems Pty Ltd
-->

<xsl:stylesheet
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:xs="http://www.w3.org/2001/XMLSchema"
        xmlns:fn="http://www.w3.org/2005/xpath-functions"
        exclude-result-prefixes="xs fn" version="2.0">

    <xsl:import href="keys-document.xsl" />
    <xsl:param name="schedule-code" />

    <xsl:output method="xml" encoding="UTF-8" indent="yes" omit-xml-declaration="yes" />

    <xsl:template match="root">

        <Schedule>
            <xsl:attribute name="schedule_code"><xsl:value-of select="$schedule-code"/></xsl:attribute>
            <xsl:for-each select="Schedule/element/child::*[not(name() ='effective_year' or name() ='schedule_code')]">
                <xsl:attribute name="{local-name()}"><xsl:value-of select="."/></xsl:attribute>
            </xsl:for-each>
            <xsl:for-each select="Item/element[supply_only_indicator = 'Y']">
                <xsl:sort select="drug_name"/>
                <xsl:variable name="mp" select="tokenize(@li_item_id,'_')[3]" />
                <xsl:variable name="mpp" select="tokenize(@li_item_id,'_')[4]" />
                <xsl:variable name="tpp" select="tokenize(@li_item_id,'_')[5]" />
                <xsl:variable name="pbs_code" select="@pbs_code" />
                <xsl:variable name="li_item_id" select="@li_item_id" />

                <Item>
                    <xsl:copy-of select="@*[not(name()='schedule_code')]" />
                    <xsl:variable name="mp-r" select="key('amt-items', ($mp,$li_item_id,$schedule-code))" />
                    <xsl:variable name="mpp-r" select="key('amt-items', ($mpp,$li_item_id,$schedule-code))" />
                    <xsl:variable name="tpp-r" select="key('amt-items-no-concept-id', ('MPUU',$li_item_id,$schedule-code))" />
                    <xsl:variable name="mpuu-r" select="key('amt-items-no-concept-id', ('MPUU',$li_item_id,$schedule-code))" />

                    <xsl:if test="$mp-r != ''">
                        <AmtItems>
                            <xsl:for-each select="key('amt-items', ($mp,$li_item_id,$schedule-code))">
                                <xsl:element name="pbs_concept_id"><xsl:value-of select="pbs_concept_id" /></xsl:element>
                                <xsl:element name="concept_type_code"><xsl:value-of select="concept_type_code" /></xsl:element>
                                <xsl:if test="amt_code"><xsl:element name="amt_code"><xsl:value-of select="amt_code" /></xsl:element></xsl:if>
                                <xsl:if test="preferred_term"><xsl:element name="preferred_term"><xsl:value-of select="preferred_term" /></xsl:element></xsl:if>
                            </xsl:for-each>
                        </AmtItems>
                    </xsl:if>
                    <xsl:if test="$mpp-r != ''">
                        <AmtItems>
                            <xsl:for-each select="key('amt-items', ($mpp,$li_item_id,$schedule-code))">
                                <xsl:element name="pbs_concept_id"><xsl:value-of select="pbs_concept_id" /></xsl:element>
                                <xsl:element name="concept_type_code"><xsl:value-of select="concept_type_code" /></xsl:element>
                                <xsl:if test="amt_code"><xsl:element name="amt_code"><xsl:value-of select="amt_code" /></xsl:element></xsl:if>
                                <xsl:if test="preferred_term"><xsl:element name="preferred_term"><xsl:value-of select="preferred_term" /></xsl:element></xsl:if>
                            </xsl:for-each>
                        </AmtItems>
                    </xsl:if>
                    <xsl:if test="$tpp-r != ''">
                        <AmtItems>
                            <xsl:for-each select="key('amt-items', ($tpp,$li_item_id,$schedule-code))">
                                <xsl:element name="pbs_concept_id"><xsl:value-of select="pbs_concept_id" /></xsl:element>
                                <xsl:element name="concept_type_code"><xsl:value-of select="concept_type_code" /></xsl:element>
                                <xsl:if test="amt_code"><xsl:element name="amt_code"><xsl:value-of select="amt_code" /></xsl:element></xsl:if>
                                <xsl:if test="preferred_term"><xsl:element name="preferred_term"><xsl:value-of select="preferred_term" /></xsl:element></xsl:if>
                            </xsl:for-each>
                        </AmtItems>
                    </xsl:if>
                    <xsl:if test="$mpuu-r != ''">
                        <AmtItems>
                            <xsl:for-each select="key('amt-items-no-concept-id', ('MPUU',$li_item_id,$schedule-code))">
                                <xsl:element name="pbs_concept_id"><xsl:value-of select="pbs_concept_id" /></xsl:element>
                                <xsl:element name="concept_type_code"><xsl:value-of select="concept_type_code" /></xsl:element>
                                <xsl:if test="amt_code"><xsl:element name="amt_code"><xsl:value-of select="amt_code" /></xsl:element></xsl:if>
                                <xsl:if test="preferred_term"><xsl:element name="preferred_term"><xsl:value-of select="preferred_term" /></xsl:element></xsl:if>
                            </xsl:for-each>
                        </AmtItems>
                    </xsl:if>

                    <xsl:copy-of select="*[not(name()='caution_indicator' or name()='note_indicator')]" />

                    <xsl:element name="prescriber_code">
                        <xsl:for-each select="key('Prescriber', ($pbs_code,$schedule-code))">
                            <xsl:value-of select="if(position()!= last()) then concat(prescriber_code, ' ') else prescriber_code" />
                        </xsl:for-each>
                    </xsl:element>

                    <ItemDispensingRule>
                        <xsl:for-each-group select="key('item-dispensing-rule-relationships', ($li_item_id,$schedule-code))" group-by="dispensing_rule_mnem">
                            <xsl:element name="{dispensing_rule_mnem}">
                                <xsl:for-each select="child::*[not(name()='li_item_id' or name()='schedule_code' or name()='dispensing_rule_mnem')]">
                                   <xsl:element name="{name()}"><xsl:value-of select="."/></xsl:element>
                                </xsl:for-each>
                            </xsl:element>
                       </xsl:for-each-group>
                    </ItemDispensingRule>

                    <xsl:variable name="item-rel" select="key('item-atc-relationships', ($pbs_code,$schedule-code))/atc_code" />
                    <ItemATC>
                        <ATCCodeGeneral>
                            <xsl:variable name="atc_actual_code" select="$item-rel" />
                            <xsl:variable name="atc_actual_level" select="key('atc-codes', ($atc_actual_code,$schedule-code))/atc_level" />
                            <xsl:variable name="atc_actual_parent_code" select="key('atc-codes', ($atc_actual_code,$schedule-code))/atc_parent_code" />
                            <xsl:variable name="atc_actual_parent_code_01" select="key('atc-codes', ($atc_actual_parent_code,$schedule-code))/atc_parent_code" />
                            <xsl:variable name="atc_actual_parent_code_02" select="key('atc-codes', ($atc_actual_parent_code_01,$schedule-code))/atc_parent_code" />
                            <xsl:variable name="atc_actual_parent_code_03" select="key('atc-codes', ($atc_actual_parent_code_02,$schedule-code))/atc_parent_code" />

                            <xsl:variable name="atc_code-5" select="if($atc_actual_level = 5) then key('atc-codes', ($atc_actual_code,$schedule-code))/atc_code else ''" />
                            <xsl:variable name="atc_code-4" select="if($atc_actual_level = 5) then key('atc-codes', ($atc_actual_parent_code,$schedule-code))/atc_code
                                                                 else if($atc_actual_level = 4) then key('atc-codes', ($atc_actual_code,$schedule-code))/atc_code else ''" />

                            <xsl:variable name="atc_code-3" select="if($atc_actual_level = 5) then key('atc-codes', ($atc_actual_parent_code_01,$schedule-code))/atc_code
                                                                 else if($atc_actual_level = 4) then key('atc-codes', ($atc_actual_parent_code,$schedule-code))/atc_code
                                                                 else if($atc_actual_level = 3) then key('atc-codes', ($atc_actual_code,$schedule-code))/atc_code else ''" />

                            <xsl:variable name="atc_code-2" select="if($atc_actual_level = 5) then key('atc-codes', ($atc_actual_parent_code_02,$schedule-code))/atc_code
                                                                 else if($atc_actual_level = 4) then key('atc-codes', ($atc_actual_parent_code_01,$schedule-code))/atc_code
                                                                 else if($atc_actual_level = 3) then key('atc-codes', ($atc_actual_parent_code,$schedule-code))/atc_code
                                                                 else if($atc_actual_level = 2) then key('atc-codes', ($atc_actual_code,$schedule-code))/atc_code else ''" />

                            <xsl:variable name="atc_code-1" select="if($atc_actual_level = 5) then key('atc-codes', ($atc_actual_parent_code_03,$schedule-code))/atc_code
                                                                 else if($atc_actual_level = 4) then key('atc-codes', ($atc_actual_parent_code_02,$schedule-code))/atc_code
                                                                 else if($atc_actual_level = 3) then key('atc-codes', ($atc_actual_parent_code_01,$schedule-code))/atc_code
                                                                 else if($atc_actual_level = 2) then key('atc-codes', ($atc_actual_parent_code,$schedule-code))/atc_code
                                                                 else if($atc_actual_level = 1) then key('atc-codes', ($atc_actual_code,$schedule-code))/atc_code else ''" />

                            <xsl:attribute name="atc_code"><xsl:value-of select="$atc_actual_code" /></xsl:attribute>

                            <ATC>
                                <xsl:attribute name="atc_level"><xsl:value-of select="key('atc-codes', ($atc_code-1,$schedule-code))/atc_level" /></xsl:attribute>
                                <xsl:attribute name="atc_code"><xsl:value-of select="key('atc-codes', ($atc_code-1,$schedule-code))/atc_code" /></xsl:attribute>
                                <xsl:attribute name="atc_description"><xsl:value-of select="key('atc-codes', ($atc_code-1,$schedule-code))/atc_description" /></xsl:attribute>
                            </ATC>
                            <ATC>
                                <xsl:attribute name="atc_level"><xsl:value-of select="key('atc-codes', ($atc_code-2,$schedule-code))/atc_level" /></xsl:attribute>
                                <xsl:attribute name="atc_code"><xsl:value-of select="key('atc-codes', ($atc_code-2,$schedule-code))/atc_code" /></xsl:attribute>
                                <xsl:attribute name="atc_description"><xsl:value-of select="key('atc-codes', ($atc_code-2,$schedule-code))/atc_description" /></xsl:attribute>
                            </ATC>
                            <ATC>
                                <xsl:attribute name="atc_level"><xsl:value-of select="key('atc-codes', ($atc_code-3,$schedule-code))/atc_level" /></xsl:attribute>
                                <xsl:attribute name="atc_code"><xsl:value-of select="key('atc-codes', ($atc_code-3,$schedule-code))/atc_code" /></xsl:attribute>
                                <xsl:attribute name="atc_description"><xsl:value-of select="key('atc-codes', ($atc_code-3,$schedule-code))/atc_description" /></xsl:attribute>
                            </ATC>
                            <xsl:if test="number($atc_actual_level) gt 3">
                                <ATC>
                                    <xsl:attribute name="atc_level"><xsl:value-of select="key('atc-codes', ($atc_code-4,$schedule-code))/atc_level" /></xsl:attribute>
                                    <xsl:attribute name="atc_code"><xsl:value-of select="key('atc-codes', ($atc_code-4,$schedule-code))/atc_code" /></xsl:attribute>
                                    <xsl:attribute name="atc_description"><xsl:value-of select="key('atc-codes', ($atc_code-4,$schedule-code))/atc_description" /></xsl:attribute>
                                </ATC>
                                <xsl:if test="number($atc_actual_level) = 5">
                                    <ATC>
                                        <xsl:attribute name="atc_level"><xsl:value-of select="key('atc-codes', ($atc_code-5,$schedule-code))/atc_level" /></xsl:attribute>
                                        <xsl:attribute name="atc_code"><xsl:value-of select="key('atc-codes', ($atc_code-5,$schedule-code))/atc_code" /></xsl:attribute>
                                        <xsl:attribute name="atc_description"><xsl:value-of select="key('atc-codes', ($atc_code-5,$schedule-code))/atc_description" /></xsl:attribute>
                                    </ATC>
                                </xsl:if>
                            </xsl:if>
                        </ATCCodeGeneral>
                    </ItemATC>

                    <xsl:variable name="item-icreases-r" select="key('item-increases', ($pbs_code,$schedule-code))" />
                    <xsl:if test="$item-icreases-r != ''">
                        <xsl:element name=" ItemIncreases">
                            <xsl:for-each select="key('item-increases', ($pbs_code,$schedule-code))">
                                <xsl:element name=" ItemIncrease">
                                    <xsl:if test="res_code"><xsl:attribute name="res_code" select="res_code" /></xsl:if>
<!--                                    <xsl:variable name="type" select="if(increase_type='NUMBER_OF_REPEATS') then 'number_of_repeats' else 'maximum_quantity_units'" />
                                    <xsl:variable name="value" select="increase_value" />-->
                                    <xsl:element name="benefit_type_code"><xsl:value-of select="benefit_type_code"/></xsl:element>
                                    <xsl:element name="increase_type"><xsl:value-of select="increase_type"/></xsl:element>
                                    <xsl:element name="increase_value"><xsl:value-of select="increase_value"/></xsl:element>
                                   <!-- <xsl:element name="{$type}"><xsl:value-of select="$value"/></xsl:element> -->

                                    <xsl:variable name="has-RESTRICTION" select="res_code" />
                                    <xsl:variable name="res_code" select="res_code" />

                                    <xsl:if test="$has-RESTRICTION != ''">
                                        <RestrictionText>
                                            <xsl:for-each select="key('RestrictionText', ($res_code,$schedule-code))">
                                                <xsl:if test="authority_method"><xsl:element name="authority_method"><xsl:value-of select="authority_method" /></xsl:element></xsl:if>
                                                <xsl:if test="treatment_of_code"><xsl:element name="treatment_of_code"><xsl:value-of select="treatment_of_code" /></xsl:element></xsl:if>
                                                <xsl:element name="restriction_number"><xsl:value-of select="restriction_number" /></xsl:element>
                                                <xsl:if test="li_html_text"><xsl:element name="li_html_text"><xsl:value-of select="li_html_text" /></xsl:element></xsl:if>
                                                <xsl:element name="schedule_html_text"><xsl:value-of select="schedule_html_text" /></xsl:element>
                                                <xsl:element name="note_indicator"><xsl:value-of select="note_indicator" /></xsl:element>
                                                <xsl:element name="caution_indicator"><xsl:value-of select="caution_indicator" /></xsl:element>
                                                <xsl:element name="complex_authority_rqrd_ind"><xsl:value-of select="complex_authority_rqrd_ind" /></xsl:element>
                                                <xsl:if test="assessment_type_code"><xsl:element name="assessment_type_code"><xsl:value-of select="assessment_type_code" /></xsl:element></xsl:if>
                                                <xsl:if test="criteria_relationship"><xsl:element name="criteria_relationship"><xsl:value-of select="criteria_relationship" /></xsl:element></xsl:if>
                                            </xsl:for-each>

                                            <xsl:variable name="has-RESTRICTION_ID_PRESCRIBING_TEXT" select="key('RstrctnPrscrbngTxtRltd', ($res_code,$schedule-code))/res_code" />

                                            <xsl:if test="$has-RESTRICTION_ID_PRESCRIBING_TEXT != ''">

                                                <xsl:for-each select="key('RstrctnPrscrbngTxtRltd', ($res_code,$schedule-code))">
                                                    <xsl:variable name="RES_PRESCRIBING_TEXT_ID" select="prescribing_text_id" />
                                                    <RstrctnPrscrbngTxtRltd>
                                                        <xsl:attribute name="prescribing_text_id"><xsl:value-of select="prescribing_text_id" /></xsl:attribute>
                                                        <xsl:attribute name="pt_position"><xsl:value-of select="pt_position" /></xsl:attribute>

                                                        <xsl:variable name="has-RESTRICTION_PRESCRIBING_TEXT_ID" select="key('PrescribingTxt', ($RES_PRESCRIBING_TEXT_ID,$schedule-code))/prescribing_txt_id" />

                                                        <xsl:if test="$has-RESTRICTION_PRESCRIBING_TEXT_ID != ''">
                                                            <PrescribingTxt>
                                                                <xsl:variable name="RES_PRESCRIBING_TEXT_ID" select="key('PrescribingTxt', ($RES_PRESCRIBING_TEXT_ID,$schedule-code))/prescribing_txt_id" />

                                                                <xsl:for-each select="key('PrescribingTxt', ($RES_PRESCRIBING_TEXT_ID,$schedule-code))">
                                                                    <xsl:element name="prescribing_type"><xsl:value-of select="prescribing_type" /></xsl:element>
                                                                    <xsl:element name="prescribing_txt"><xsl:value-of select="prescribing_txt" /></xsl:element>
                                                                    <xsl:element name="complex_authority_rqrd_ind"><xsl:value-of select="complex_authority_rqrd_ind" /></xsl:element>
                                                                    <xsl:if test="assessment_type_code"><xsl:element name="assessment_type_code"><xsl:value-of select="assessment_type_code" /></xsl:element></xsl:if>
                                                                </xsl:for-each>

                                                                <xsl:variable name="CRITERIA_PRESCRIBING_TEXT_ID" select="key('Criteria', ($RES_PRESCRIBING_TEXT_ID,$schedule-code))/criteria_prescribing_txt_id" />
                                                                <xsl:if test="$CRITERIA_PRESCRIBING_TEXT_ID != ''">
                                                                    <Criteria>
                                                                        <xsl:attribute name="CRITERIA_PRESCRIBING_TEXT_ID"><xsl:value-of select="$CRITERIA_PRESCRIBING_TEXT_ID" /></xsl:attribute>

                                                                        <xsl:for-each select="key('Criteria', ($RES_PRESCRIBING_TEXT_ID,$schedule-code))">
                                                                            <xsl:element name="criteria_type"><xsl:value-of select="criteria_type" /></xsl:element>
                                                                            <xsl:element name="parameter_relationship"><xsl:value-of select="parameter_relationship" /></xsl:element>
                                                                        </xsl:for-each>

                                                                        <xsl:for-each-group select="key('CriteriaParameterRltd', ($CRITERIA_PRESCRIBING_TEXT_ID,$schedule-code))" group-by="pt_position">
                                                                            <xsl:sort select="pt_position" />
                                                                            <xsl:variable name="PARAMETER_PRESCRIBING_TXT_REL_ID" select="parameter_prescribing_txt_id" />
                                                                            <CriteriaParameterRltd>
                                                                                <xsl:attribute name="parameter_prescribing_txt_id"><xsl:value-of select="parameter_prescribing_txt_id" /></xsl:attribute>
                                                                                <xsl:attribute name="pt_position"><xsl:value-of select="pt_position" /></xsl:attribute>
                                                                                <PrescribingTxt>
                                                                                    <xsl:for-each select="key('PrescribingTxt', ($PARAMETER_PRESCRIBING_TXT_REL_ID,$schedule-code))">
                                                                                        <xsl:element name="prescribing_type"><xsl:value-of select="prescribing_type" /></xsl:element>
                                                                                        <xsl:element name="prescribing_txt"><xsl:value-of select="prescribing_txt" /></xsl:element>
                                                                                        <xsl:element name="complex_authority_rqrd_ind"><xsl:value-of select="complex_authority_rqrd_ind" /></xsl:element>
                                                                                        <xsl:if test="assessment_type_code"><xsl:element name="assessment_type_code"><xsl:value-of select="assessment_type_code" /></xsl:element></xsl:if>
                                                                                    </xsl:for-each>
                                                                                </PrescribingTxt>
                                                                            </CriteriaParameterRltd>
                                                                        </xsl:for-each-group>
                                                                    </Criteria>
                                                                </xsl:if>
                                                                <xsl:variable name="has-INDICATION_ID" select="key('Indication', ($RES_PRESCRIBING_TEXT_ID,$schedule-code))/indication_prescribing_txt_id" />
                                                                <xsl:if test="$has-INDICATION_ID != ''">
                                                                    <Indication>
                                                                        <xsl:for-each select="key('Indication', ($RES_PRESCRIBING_TEXT_ID,$schedule-code))">
                                                                            <xsl:if test="episodicity"><xsl:element name="episodicity"><xsl:value-of select="episodicity" /></xsl:element></xsl:if>
                                                                            <xsl:if test="severity"><xsl:element name="severity"><xsl:value-of select="severity" /></xsl:element></xsl:if>
                                                                            <xsl:element name="condition"><xsl:value-of select="condition" /></xsl:element>
                                                                        </xsl:for-each>
                                                                    </Indication>
                                                                </xsl:if>
                                                            </PrescribingTxt>
                                                        </xsl:if>
                                                    </RstrctnPrscrbngTxtRltd>
                                                </xsl:for-each>
                                            </xsl:if>
                                        </RestrictionText>
                                    </xsl:if>

                                </xsl:element>
                            </xsl:for-each>
                        </xsl:element>
                    </xsl:if>

                    <xsl:for-each select="key('ItemPrescribingTxtRltd', ($pbs_code,$schedule-code))">
                        <xsl:variable name="PRESCRIBING_TXT_REL_ID" select="prescribing_txt_id" />
                        <ItemPrescribingTxtRltd>
                            <xsl:attribute name="prescribing_txt_id"><xsl:value-of select="$PRESCRIBING_TXT_REL_ID" /></xsl:attribute>
                            <PrescribingTxt>
                                <xsl:for-each select="key('PrescribingTxt', ($PRESCRIBING_TXT_REL_ID,$schedule-code))">
                                    <xsl:element name="prescribing_type"><xsl:value-of select="prescribing_type" /></xsl:element>
                                    <xsl:element name="prescribing_txt"><xsl:value-of select="prescribing_txt" /></xsl:element>
                                    <xsl:element name="complex_authority_rqrd_ind"><xsl:value-of select="complex_authority_rqrd_ind" /></xsl:element>
                                    <xsl:if test="assessment_type_code"><xsl:element name="assessment_type_code"><xsl:value-of select="assessment_type_code" /></xsl:element></xsl:if>
                                </xsl:for-each>

                                <xsl:variable name="CRITERIA_PRESCRIBING_TEXT_ID" select="key('Criteria', ($PRESCRIBING_TXT_REL_ID,$schedule-code))/CRITERIA_PRESCRIBING_TXT_ID" />
                                <xsl:if test="$CRITERIA_PRESCRIBING_TEXT_ID != ''">
                                    <Criteria>
                                        <xsl:attribute name="CRITERIA_PRESCRIBING_TEXT_ID"><xsl:value-of select="$CRITERIA_PRESCRIBING_TEXT_ID" /></xsl:attribute>

                                        <xsl:for-each select="key('Criteria', ($PRESCRIBING_TXT_REL_ID,$schedule-code))">
                                            <xsl:element name="criteria_type"><xsl:value-of select="criteria_type" /></xsl:element>
                                            <xsl:element name="parameter_relationship"><xsl:value-of select="parameter_relationship" /></xsl:element>
                                        </xsl:for-each>

                                        <xsl:for-each-group select="key('CriteriaParameterRltd', ($CRITERIA_PRESCRIBING_TEXT_ID,$schedule-code))" group-by="pt_position">
                                            <xsl:sort select="pt_position" />
                                            <xsl:variable name="PARAMETER_PRESCRIBING_TXT_REL_ID" select="parameter_prescribing_txt_id" />
                                            <CriteriaParameterRltd>
                                                <xsl:attribute name="parameter_prescribing_txt_id"><xsl:value-of select="parameter_prescribing_txt_id" /></xsl:attribute>
                                                <xsl:attribute name="pt_position"><xsl:value-of select="pt_position" /></xsl:attribute>
                                                <PrescribingTxt>
                                                    <xsl:for-each select="key('PrescribingTxt', ($PARAMETER_PRESCRIBING_TXT_REL_ID,$schedule-code))">
                                                        <xsl:element name="prescribing_type"><xsl:value-of select="prescribing_type" /></xsl:element>
                                                        <xsl:element name="prescribing_txt"><xsl:value-of select="prescribing_txt" /></xsl:element>
                                                        <xsl:element name="complex_authority_rqrd_ind"><xsl:value-of select="complex_authority_rqrd_ind" /></xsl:element>
                                                        <xsl:if test="assessment_type_code"><xsl:element name="assessment_type_code"><xsl:value-of select="assessment_type_code" /></xsl:element></xsl:if>
                                                    </xsl:for-each>
                                                </PrescribingTxt>
                                            </CriteriaParameterRltd>
                                        </xsl:for-each-group>
                                    </Criteria>
                                </xsl:if>
                                <xsl:variable name="has-INDICATION_ID" select="key('Indication', ($PRESCRIBING_TXT_REL_ID,$schedule-code))/indication_prescribing_txt_id" />
                                <xsl:if test="$has-INDICATION_ID != ''">
                                    <Indication>
                                        <xsl:for-each select="key('Indication', ($PRESCRIBING_TXT_REL_ID,$schedule-code))">
                                            <xsl:if test="episodicity"><xsl:element name="episodicity"><xsl:value-of select="episodicity" /></xsl:element></xsl:if>
                                            <xsl:if test="severity"><xsl:element name="severity"><xsl:value-of select="severity" /></xsl:element></xsl:if>
                                            <xsl:element name="condition"><xsl:value-of select="condition" /></xsl:element>
                                        </xsl:for-each>
                                    </Indication>
                                </xsl:if>
                            </PrescribingTxt>
                        </ItemPrescribingTxtRltd>
                    </xsl:for-each>


                    <xsl:variable name="has-RESTRICTION_TXT_REL" select="key('ItemRestrictionRltd', ($pbs_code,$schedule-code))/res_code" />

                    <xsl:if test="$has-RESTRICTION_TXT_REL != ''">

                        <xsl:for-each select="key('ItemRestrictionRltd', ($pbs_code,$schedule-code))">
                            <xsl:variable name="res_code" select="res_code" />
                            <ItemRestrictionRltd>
                                <xsl:attribute name="benefit_type_code"><xsl:value-of select="benefit_type_code" /></xsl:attribute>
                                <xsl:attribute name="res_code"><xsl:value-of select="$res_code" /></xsl:attribute>

                                <restriction_indicator><xsl:value-of select="restriction_indicator" /></restriction_indicator>

                                <xsl:variable name="has-RESTRICTION_TXT" select="key('RestrictionText', ($res_code,$schedule-code))/res_code" />

                                <xsl:if test="$has-RESTRICTION_TXT != ''">
                                    <RestrictionText>
                                        <xsl:for-each select="key('RestrictionText', ($res_code,$schedule-code))">
                                            <xsl:if test="authority_method"><xsl:element name="authority_method"><xsl:value-of select="authority_method" /></xsl:element></xsl:if>
                                            <xsl:if test="treatment_of_code"><xsl:element name="treatment_of_code"><xsl:value-of select="treatment_of_code" /></xsl:element></xsl:if>
                                            <xsl:element name="restriction_number"><xsl:value-of select="restriction_number" /></xsl:element>
                                            <xsl:if test="li_html_text"><xsl:element name="li_html_text"><xsl:value-of select="li_html_text" /></xsl:element></xsl:if>
                                            <xsl:element name="schedule_html_text"><xsl:value-of select="schedule_html_text" /></xsl:element>
                                            <xsl:element name="note_indicator"><xsl:value-of select="note_indicator" /></xsl:element>
                                            <xsl:element name="caution_indicator"><xsl:value-of select="caution_indicator" /></xsl:element>
                                            <xsl:element name="complex_authority_rqrd_ind"><xsl:value-of select="complex_authority_rqrd_ind" /></xsl:element>
                                            <xsl:if test="assessment_type_code"><xsl:element name="assessment_type_code"><xsl:value-of select="assessment_type_code" /></xsl:element></xsl:if>
                                            <xsl:if test="criteria_relationship"><xsl:element name="criteria_relationship"><xsl:value-of select="criteria_relationship" /></xsl:element></xsl:if>
                                        </xsl:for-each>

                                        <xsl:variable name="has-RESTRICTION_ID_PRESCRIBING_TEXT" select="key('RstrctnPrscrbngTxtRltd', ($res_code,$schedule-code))/res_code" />

                                        <xsl:if test="$has-RESTRICTION_ID_PRESCRIBING_TEXT != ''">

                                            <xsl:for-each select="key('RstrctnPrscrbngTxtRltd', ($res_code,$schedule-code))">
                                                <xsl:variable name="RES_PRESCRIBING_TEXT_ID" select="prescribing_text_id" />
                                                <RstrctnPrscrbngTxtRltd>
                                                    <xsl:attribute name="prescribing_text_id"><xsl:value-of select="prescribing_text_id" /></xsl:attribute>
                                                    <xsl:attribute name="pt_position"><xsl:value-of select="pt_position" /></xsl:attribute>

                                                    <xsl:variable name="has-RESTRICTION_PRESCRIBING_TEXT_ID" select="key('PrescribingTxt', ($RES_PRESCRIBING_TEXT_ID,$schedule-code))/prescribing_txt_id" />

                                                    <xsl:if test="$has-RESTRICTION_PRESCRIBING_TEXT_ID != ''">
                                                        <PrescribingTxt>
                                                            <xsl:variable name="RES_PRESCRIBING_TEXT_ID" select="key('PrescribingTxt', ($RES_PRESCRIBING_TEXT_ID,$schedule-code))/prescribing_txt_id" />

                                                            <xsl:for-each select="key('PrescribingTxt', ($RES_PRESCRIBING_TEXT_ID,$schedule-code))">
                                                                <xsl:element name="prescribing_type"><xsl:value-of select="prescribing_type" /></xsl:element>
                                                                <xsl:element name="prescribing_txt"><xsl:value-of select="prescribing_txt" /></xsl:element>
                                                                <xsl:element name="complex_authority_rqrd_ind"><xsl:value-of select="complex_authority_rqrd_ind" /></xsl:element>
                                                                <xsl:if test="assessment_type_code"><xsl:element name="assessment_type_code"><xsl:value-of select="assessment_type_code" /></xsl:element></xsl:if>
                                                            </xsl:for-each>

                                                            <xsl:variable name="CRITERIA_PRESCRIBING_TEXT_ID" select="key('Criteria', ($RES_PRESCRIBING_TEXT_ID,$schedule-code))/criteria_prescribing_txt_id" />
                                                            <xsl:if test="$CRITERIA_PRESCRIBING_TEXT_ID != ''">
                                                                <Criteria>
                                                                    <xsl:attribute name="CRITERIA_PRESCRIBING_TEXT_ID"><xsl:value-of select="$CRITERIA_PRESCRIBING_TEXT_ID" /></xsl:attribute>

                                                                    <xsl:for-each select="key('Criteria', ($RES_PRESCRIBING_TEXT_ID,$schedule-code))">
                                                                        <xsl:element name="criteria_type"><xsl:value-of select="criteria_type" /></xsl:element>
                                                                        <xsl:element name="parameter_relationship"><xsl:value-of select="parameter_relationship" /></xsl:element>
                                                                    </xsl:for-each>

                                                                    <xsl:for-each-group select="key('CriteriaParameterRltd', ($CRITERIA_PRESCRIBING_TEXT_ID,$schedule-code))" group-by="pt_position">
                                                                        <xsl:sort select="pt_position" />
                                                                        <xsl:variable name="PARAMETER_PRESCRIBING_TXT_REL_ID" select="parameter_prescribing_txt_id" />
                                                                        <CriteriaParameterRltd>
                                                                            <xsl:attribute name="parameter_prescribing_txt_id"><xsl:value-of select="parameter_prescribing_txt_id" /></xsl:attribute>
                                                                            <xsl:attribute name="pt_position"><xsl:value-of select="pt_position" /></xsl:attribute>
                                                                            <PrescribingTxt>
                                                                                <xsl:for-each select="key('PrescribingTxt', ($PARAMETER_PRESCRIBING_TXT_REL_ID,$schedule-code))">
                                                                                    <xsl:element name="prescribing_type"><xsl:value-of select="prescribing_type" /></xsl:element>
                                                                                    <xsl:element name="prescribing_txt"><xsl:value-of select="prescribing_txt" /></xsl:element>
                                                                                    <xsl:element name="complex_authority_rqrd_ind"><xsl:value-of select="complex_authority_rqrd_ind" /></xsl:element>
                                                                                    <xsl:if test="assessment_type_code"><xsl:element name="assessment_type_code"><xsl:value-of select="assessment_type_code" /></xsl:element></xsl:if>
                                                                                </xsl:for-each>
                                                                            </PrescribingTxt>
                                                                        </CriteriaParameterRltd>
                                                                    </xsl:for-each-group>
                                                                </Criteria>
                                                            </xsl:if>
                                                            <xsl:variable name="has-INDICATION_ID" select="key('Indication', ($RES_PRESCRIBING_TEXT_ID,$schedule-code))/indication_prescribing_txt_id" />
                                                            <xsl:if test="$has-INDICATION_ID != ''">
                                                                <Indication>
                                                                    <xsl:for-each select="key('Indication', ($RES_PRESCRIBING_TEXT_ID,$schedule-code))">
                                                                        <xsl:if test="episodicity"><xsl:element name="episodicity"><xsl:value-of select="episodicity" /></xsl:element></xsl:if>
                                                                        <xsl:if test="severity"><xsl:element name="severity"><xsl:value-of select="severity" /></xsl:element></xsl:if>
                                                                        <xsl:element name="condition"><xsl:value-of select="condition" /></xsl:element>
                                                                    </xsl:for-each>
                                                                </Indication>
                                                            </xsl:if>
                                                        </PrescribingTxt>
                                                    </xsl:if>
                                                </RstrctnPrscrbngTxtRltd>
                                            </xsl:for-each>
                                        </xsl:if>
                                    </RestrictionText>
                                </xsl:if>
                            </ItemRestrictionRltd>
                        </xsl:for-each>
                    </xsl:if>

                    <xsl:variable name="extemp-prep" select="key('extemporaneous-preparation', ($pbs_code,$schedule-code))" />
                    <xsl:variable name="stand-form-prep" select="key('standard-formula-preparations', ($pbs_code,$schedule-code))" />
                    <xsl:if test="$extemp-prep != ''">
                        <ExtemporaneousPreparation>
                            <xsl:for-each select="key('extemporaneous-preparation', ($pbs_code,$schedule-code))">
                                <xsl:element name="pbs_code"><xsl:value-of select="pbs_code" /></xsl:element>
                                <xsl:element name="preparation"><xsl:value-of select="preparation" /></xsl:element>
                                <xsl:element name="maximum_quantity"><xsl:value-of select="maximum_quantity" /></xsl:element>
                                <xsl:element name="maximum_quantity_unit"><xsl:value-of select="maximum_quantity_unit" /></xsl:element>
                            </xsl:for-each>
                        </ExtemporaneousPreparation>
                    </xsl:if>
                    <xsl:if test="$stand-form-prep != ''">
                        <StandardFormulaPreparation>
                            <xsl:for-each select="key('standard-formula-preparations', ($pbs_code,$schedule-code))">
                                <xsl:element name="pbs_code"><xsl:value-of select="pbs_code" /></xsl:element>
                                <xsl:element name="sfp_drug_name"><xsl:value-of select="sfp_drug_name" /></xsl:element>
                                <xsl:element name="sfp_reference"><xsl:value-of select="sfp_reference" /></xsl:element>
                                <xsl:element name="container_fee"><xsl:value-of select="container_fee" /></xsl:element>
                                <xsl:element name="dispensing_fee_max_quantity"><xsl:value-of select="dispensing_fee_max_quantity" /></xsl:element>
                                <xsl:element name="safety_net_price"><xsl:value-of select="safety_net_price" /></xsl:element>
                                <xsl:element name="maximum_patient_charge"><xsl:value-of select="maximum_patient_charge" /></xsl:element>
                                <xsl:element name="maximum_quantity_unit"><xsl:value-of select="maximum_quantity_unit" /></xsl:element>
                                <xsl:element name="maximum_quantity"><xsl:value-of select="maximum_quantity" /></xsl:element>
                            </xsl:for-each>
                            <xsl:for-each select="key('extemporaneous-standard-formula', ($pbs_code,$schedule-code))">
                                <xsl:element name="ex_prep_pbs_code"><xsl:value-of select="ex_prep_pbs_code" /></xsl:element>
                            </xsl:for-each>
                        </StandardFormulaPreparation>
                    </xsl:if>
                </Item>
            </xsl:for-each>
        </Schedule>
    </xsl:template>

</xsl:stylesheet>
