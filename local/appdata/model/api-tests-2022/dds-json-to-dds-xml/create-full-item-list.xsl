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

    <xsl:import href="common/keys-document.xsl" />
    <xsl:param name="schedule-code" />

    <xsl:output method="xml" encoding="UTF-8" indent="yes" omit-xml-declaration="yes" />

    <xsl:template match="root">

        <Schedule>
            <xsl:attribute name="SCHEDULE_CODE"><xsl:value-of select="$schedule-code"/></xsl:attribute>
            <xsl:for-each select="Schedule/element/child::*[not(name() ='EFFECTIVE_YEAR' or name() ='SCHEDULE_CODE')]">
                <xsl:attribute name="{local-name()}"><xsl:value-of select="."/></xsl:attribute>
            </xsl:for-each>
            <xsl:for-each select="Item/element[not(@PROGRAM_CODE = 'EP')]">
                <xsl:variable name="MP" select="tokenize(@LI_ITEM_ID,'_')[3]" />
                <xsl:variable name="MPP" select="tokenize(@LI_ITEM_ID,'_')[4]" />
                <xsl:variable name="TPP" select="tokenize(@LI_ITEM_ID,'_')[5]" />
                <xsl:variable name="PBS_CODE" select="@PBS_CODE" />
                <xsl:variable name="LI_ITEM_ID" select="@LI_ITEM_ID" />

                <Item>
                    <xsl:copy-of select="@*[not(name()='SCHEDULE_CODE')]" />
                    <amt-items>
                        <xsl:for-each select="key('amt-items', ($MP,$LI_ITEM_ID,$schedule-code))">
                            <xsl:element name="PBS_CONCEPT_ID"><xsl:value-of select="PBS_CONCEPT_ID" /></xsl:element>
                            <xsl:element name="CONCEPT_TYPE_CODE"><xsl:value-of select="CONCEPT_TYPE_CODE" /></xsl:element>
                            <xsl:if test="AMT_CODE"><xsl:element name="AMT_CODE"><xsl:value-of select="AMT_CODE" /></xsl:element></xsl:if>
                            <xsl:if test="PREFERRED_TERM"><xsl:element name="PREFERRED_TERM"><xsl:value-of select="PREFERRED_TERM" /></xsl:element></xsl:if>
                        </xsl:for-each>
                    </amt-items>
                    <amt-items>
                        <xsl:for-each select="key('amt-items', ($MPP,$LI_ITEM_ID,$schedule-code))">
                            <xsl:element name="PBS_CONCEPT_ID"><xsl:value-of select="PBS_CONCEPT_ID" /></xsl:element>
                            <xsl:element name="CONCEPT_TYPE_CODE"><xsl:value-of select="CONCEPT_TYPE_CODE" /></xsl:element>
                            <xsl:if test="AMT_CODE"><xsl:element name="AMT_CODE"><xsl:value-of select="AMT_CODE" /></xsl:element></xsl:if>
                            <xsl:if test="PREFERRED_TERM"><xsl:element name="PREFERRED_TERM"><xsl:value-of select="PREFERRED_TERM" /></xsl:element></xsl:if>
                        </xsl:for-each>
                    </amt-items>
                    <amt-items>
                        <xsl:for-each select="key('amt-items', ($TPP,$LI_ITEM_ID,$schedule-code))">
                            <xsl:element name="PBS_CONCEPT_ID"><xsl:value-of select="PBS_CONCEPT_ID" /></xsl:element>
                            <xsl:element name="CONCEPT_TYPE_CODE"><xsl:value-of select="CONCEPT_TYPE_CODE" /></xsl:element>
                            <xsl:if test="AMT_CODE"><xsl:element name="AMT_CODE"><xsl:value-of select="AMT_CODE" /></xsl:element></xsl:if>
                            <xsl:if test="PREFERRED_TERM"><xsl:element name="PREFERRED_TERM"><xsl:value-of select="PREFERRED_TERM" /></xsl:element></xsl:if>
                        </xsl:for-each>
                    </amt-items>

                    <xsl:copy-of select="*[not(name()='CAUTION_INDICATOR' or name()='NOTE_INDICATOR')]" />

                    <xsl:for-each select="key('ItemPrescribingTxtRltd', ($PBS_CODE,$schedule-code))">
                        <xsl:variable name="PRESCRIBING_TXT_REL_ID" select="PRESCRIBING_TXT_ID" />
                        <ItemPrescribingTxtRltd>
                            <xsl:attribute name="PRESCRIBING_TXT_ID"><xsl:value-of select="$PRESCRIBING_TXT_REL_ID" /></xsl:attribute>
                            <PrescribingTxt>
                                <xsl:for-each select="key('PrescribingTxt', ($PRESCRIBING_TXT_REL_ID,$schedule-code))">
                                    <xsl:element name="PRESCRIBING_TYPE"><xsl:value-of select="PRESCRIBING_TYPE" /></xsl:element>
                                    <xsl:element name="PRESCRIBING_TXT"><xsl:value-of select="PRESCRIBING_TXT" /></xsl:element>
                                    <xsl:element name="COMPLEX_AUTHORITY_RQRD_IND"><xsl:value-of select="COMPLEX_AUTHORITY_RQRD_IND" /></xsl:element>
                                    <xsl:if test="ASSESSMENT_TYPE_CODE"><xsl:element name="ASSESSMENT_TYPE_CODE"><xsl:value-of select="ASSESSMENT_TYPE_CODE" /></xsl:element></xsl:if>
                                </xsl:for-each>

                                <xsl:variable name="CRITERIA_PRESCRIBING_TEXT_ID" select="key('Criteria', ($PRESCRIBING_TXT_REL_ID,$schedule-code))/CRITERIA_PRESCRIBING_TXT_ID" />
                                <xsl:if test="$CRITERIA_PRESCRIBING_TEXT_ID != ''">
                                    <Criteria>
                                        <xsl:attribute name="CRITERIA_PRESCRIBING_TEXT_ID"><xsl:value-of select="$CRITERIA_PRESCRIBING_TEXT_ID" /></xsl:attribute>

                                        <xsl:for-each select="key('Criteria', ($PRESCRIBING_TXT_REL_ID,$schedule-code))">
                                            <xsl:element name="CRITERIA_TYPE"><xsl:value-of select="CRITERIA_TYPE" /></xsl:element>
                                            <xsl:element name="PARAMETER_RELATIONSHIP"><xsl:value-of select="PARAMETER_RELATIONSHIP" /></xsl:element>
                                        </xsl:for-each>

                                        <xsl:for-each-group select="key('CriteriaParameterRltd', ($CRITERIA_PRESCRIBING_TEXT_ID,$schedule-code))" group-by="PT_POSITION">
                                            <xsl:sort select="PT_POSITION" />
                                            <xsl:variable name="PARAMETER_PRESCRIBING_TXT_REL_ID" select="PARAMETER_PRESCRIBING_TXT_ID" />
                                            <CriteriaParameterRltd>
                                                <xsl:attribute name="PARAMETER_PRESCRIBING_TXT_ID"><xsl:value-of select="PARAMETER_PRESCRIBING_TXT_ID" /></xsl:attribute>
                                                <xsl:attribute name="PT_POSITION"><xsl:value-of select="PT_POSITION" /></xsl:attribute>
                                                <PrescribingTxt>
                                                    <xsl:for-each select="key('PrescribingTxt', ($PARAMETER_PRESCRIBING_TXT_REL_ID,$schedule-code))">
                                                        <xsl:element name="PRESCRIBING_TYPE"><xsl:value-of select="PRESCRIBING_TYPE" /></xsl:element>
                                                        <xsl:element name="PRESCRIBING_TXT"><xsl:value-of select="PRESCRIBING_TXT" /></xsl:element>
                                                        <xsl:element name="COMPLEX_AUTHORITY_RQRD_IND"><xsl:value-of select="COMPLEX_AUTHORITY_RQRD_IND" /></xsl:element>
                                                        <xsl:if test="ASSESSMENT_TYPE_CODE"><xsl:element name="ASSESSMENT_TYPE_CODE"><xsl:value-of select="ASSESSMENT_TYPE_CODE" /></xsl:element></xsl:if>
                                                    </xsl:for-each>
                                                </PrescribingTxt>
                                            </CriteriaParameterRltd>
                                        </xsl:for-each-group>
                                    </Criteria>
                                </xsl:if>
                                <xsl:variable name="has-INDICATION_ID" select="key('Indication', ($PRESCRIBING_TXT_REL_ID,$schedule-code))/INDICATION_PRESCRIBING_TXT_ID" />
                                <xsl:if test="$has-INDICATION_ID != ''">
                                    <Indication>
                                        <xsl:for-each select="key('Indication', ($PRESCRIBING_TXT_REL_ID,$schedule-code))">
                                            <xsl:if test="EPISODICITY"><xsl:element name="EPISODICITY"><xsl:value-of select="EPISODICITY" /></xsl:element></xsl:if>
                                            <xsl:if test="SEVERITY"><xsl:element name="SEVERITY"><xsl:value-of select="SEVERITY" /></xsl:element></xsl:if>
                                            <xsl:element name="CONDITION"><xsl:value-of select="CONDITION" /></xsl:element>
                                        </xsl:for-each>
                                    </Indication>
                                </xsl:if>
                            </PrescribingTxt>
                        </ItemPrescribingTxtRltd>
                    </xsl:for-each>


                    <xsl:variable name="has-RESTRICTION_TXT_REL" select="key('ItemRestrictionRltd', ($PBS_CODE,$schedule-code))/RES_CODE" />

                    <xsl:if test="$has-RESTRICTION_TXT_REL != ''">

                        <xsl:for-each select="key('ItemRestrictionRltd', ($PBS_CODE,$schedule-code))">
                            <xsl:variable name="RES_CODE" select="RES_CODE" />
                            <ItemRestrictionRltd>
                                <xsl:attribute name="BENEFIT_TYPE_CODE"><xsl:value-of select="BENEFIT_TYPE_CODE" /></xsl:attribute>
                                <xsl:attribute name="RES_CODE"><xsl:value-of select="$RES_CODE" /></xsl:attribute>

                                <RESTRICTION_INDICATOR><xsl:value-of select="RESTRICTION_INDICATOR" /></RESTRICTION_INDICATOR>

                                <xsl:variable name="has-RESTRICTION_TXT" select="key('RestrictionText', ($RES_CODE,$schedule-code))/RES_CODE" />

                                <xsl:if test="$has-RESTRICTION_TXT != ''">
                                    <RestrictionText>
                                        <xsl:for-each select="key('RestrictionText', ($RES_CODE,$schedule-code))">
                                            <xsl:if test="AUTHORITY_METHOD"><xsl:element name="AUTHORITY_METHOD"><xsl:value-of select="AUTHORITY_METHOD" /></xsl:element></xsl:if>
                                            <xsl:if test="TREATMENT_OF_CODE"><xsl:element name="TREATMENT_OF_CODE"><xsl:value-of select="TREATMENT_OF_CODE" /></xsl:element></xsl:if>
                                            <xsl:element name="RESTRICTION_NUMBER"><xsl:value-of select="RESTRICTION_NUMBER" /></xsl:element>
                                            <xsl:if test="LI_HTML_TEXT"><xsl:element name="LI_HTML_TEXT"><xsl:value-of select="LI_HTML_TEXT" /></xsl:element></xsl:if>
                                            <xsl:element name="SCHEDULE_HTML_TEXT"><xsl:value-of select="SCHEDULE_HTML_TEXT" /></xsl:element>
                                            <xsl:element name="NOTE_INDICATOR"><xsl:value-of select="NOTE_INDICATOR" /></xsl:element>
                                            <xsl:element name="CAUTION_INDICATOR"><xsl:value-of select="CAUTION_INDICATOR" /></xsl:element>
                                            <xsl:element name="COMPLEX_AUTHORITY_RQRD_IND"><xsl:value-of select="COMPLEX_AUTHORITY_RQRD_IND" /></xsl:element>
                                            <xsl:if test="ASSESSMENT_TYPE_CODE"><xsl:element name="ASSESSMENT_TYPE_CODE"><xsl:value-of select="ASSESSMENT_TYPE_CODE" /></xsl:element></xsl:if>
                                            <xsl:if test="CRITERIA_RELATIONSHIP"><xsl:element name="CRITERIA_RELATIONSHIP"><xsl:value-of select="CRITERIA_RELATIONSHIP" /></xsl:element></xsl:if>
                                        </xsl:for-each>

                                        <xsl:variable name="has-RESTRICTION_ID_PRESCRIBING_TEXT" select="key('RstrctnPrscrbngTxtRltd', ($RES_CODE,$schedule-code))/RES_CODE" />

                                        <xsl:if test="$has-RESTRICTION_ID_PRESCRIBING_TEXT != ''">

                                            <xsl:for-each select="key('RstrctnPrscrbngTxtRltd', ($RES_CODE,$schedule-code))">
                                                <xsl:variable name="RES_PRESCRIBING_TEXT_ID" select="PRESCRIBING_TEXT_ID" />
                                                <RstrctnPrscrbngTxtRltd>
                                                    <xsl:attribute name="PRESCRIBING_TEXT_ID"><xsl:value-of select="PRESCRIBING_TEXT_ID" /></xsl:attribute>
                                                    <xsl:attribute name="PT_POSITION"><xsl:value-of select="PT_POSITION" /></xsl:attribute>

                                                    <xsl:variable name="has-RESTRICTION_PRESCRIBING_TEXT_ID" select="key('PrescribingTxt', ($RES_PRESCRIBING_TEXT_ID,$schedule-code))/PRESCRIBING_TXT_ID" />

                                                    <xsl:if test="$has-RESTRICTION_PRESCRIBING_TEXT_ID != ''">
                                                        <PrescribingTxt>
                                                            <xsl:variable name="RES_PRESCRIBING_TEXT_ID" select="key('PrescribingTxt', ($RES_PRESCRIBING_TEXT_ID,$schedule-code))/PRESCRIBING_TXT_ID" />

                                                            <xsl:for-each select="key('PrescribingTxt', ($RES_PRESCRIBING_TEXT_ID,$schedule-code))">
                                                                <xsl:element name="PRESCRIBING_TYPE"><xsl:value-of select="PRESCRIBING_TYPE" /></xsl:element>
                                                                <xsl:element name="PRESCRIBING_TXT"><xsl:value-of select="PRESCRIBING_TXT" /></xsl:element>
                                                                <xsl:element name="COMPLEX_AUTHORITY_RQRD_IND"><xsl:value-of select="COMPLEX_AUTHORITY_RQRD_IND" /></xsl:element>
                                                                <xsl:if test="ASSESSMENT_TYPE_CODE"><xsl:element name="ASSESSMENT_TYPE_CODE"><xsl:value-of select="ASSESSMENT_TYPE_CODE" /></xsl:element></xsl:if>
                                                            </xsl:for-each>

                                                            <xsl:variable name="CRITERIA_PRESCRIBING_TEXT_ID" select="key('Criteria', ($RES_PRESCRIBING_TEXT_ID,$schedule-code))/CRITERIA_PRESCRIBING_TXT_ID" />
                                                            <xsl:if test="$CRITERIA_PRESCRIBING_TEXT_ID != ''">
                                                                <Criteria>
                                                                    <xsl:attribute name="CRITERIA_PRESCRIBING_TEXT_ID"><xsl:value-of select="$CRITERIA_PRESCRIBING_TEXT_ID" /></xsl:attribute>

                                                                    <xsl:for-each select="key('Criteria', ($RES_PRESCRIBING_TEXT_ID,$schedule-code))">
                                                                        <xsl:element name="CRITERIA_TYPE"><xsl:value-of select="CRITERIA_TYPE" /></xsl:element>
                                                                        <xsl:element name="PARAMETER_RELATIONSHIP"><xsl:value-of select="PARAMETER_RELATIONSHIP" /></xsl:element>
                                                                    </xsl:for-each>

                                                                    <xsl:for-each-group select="key('CriteriaParameterRltd', ($CRITERIA_PRESCRIBING_TEXT_ID,$schedule-code))" group-by="PT_POSITION">
                                                                        <xsl:sort select="PT_POSITION" />
                                                                        <xsl:variable name="PARAMETER_PRESCRIBING_TXT_REL_ID" select="PARAMETER_PRESCRIBING_TXT_ID" />
                                                                        <CriteriaParameterRltd>
                                                                            <xsl:attribute name="PARAMETER_PRESCRIBING_TXT_ID"><xsl:value-of select="PARAMETER_PRESCRIBING_TXT_ID" /></xsl:attribute>
                                                                            <xsl:attribute name="PT_POSITION"><xsl:value-of select="PT_POSITION" /></xsl:attribute>
                                                                            <PrescribingTxt>
                                                                                <xsl:for-each select="key('PrescribingTxt', ($PARAMETER_PRESCRIBING_TXT_REL_ID,$schedule-code))">
                                                                                    <xsl:element name="PRESCRIBING_TYPE"><xsl:value-of select="PRESCRIBING_TYPE" /></xsl:element>
                                                                                    <xsl:element name="PRESCRIBING_TXT"><xsl:value-of select="PRESCRIBING_TXT" /></xsl:element>
                                                                                    <xsl:element name="COMPLEX_AUTHORITY_RQRD_IND"><xsl:value-of select="COMPLEX_AUTHORITY_RQRD_IND" /></xsl:element>
                                                                                    <xsl:if test="ASSESSMENT_TYPE_CODE"><xsl:element name="ASSESSMENT_TYPE_CODE"><xsl:value-of select="ASSESSMENT_TYPE_CODE" /></xsl:element></xsl:if>
                                                                                </xsl:for-each>
                                                                            </PrescribingTxt>
                                                                        </CriteriaParameterRltd>
                                                                    </xsl:for-each-group>
                                                                </Criteria>
                                                            </xsl:if>
                                                            <xsl:variable name="has-INDICATION_ID" select="key('Indication', ($RES_PRESCRIBING_TEXT_ID,$schedule-code))/INDICATION_PRESCRIBING_TXT_ID" />
                                                            <xsl:if test="$has-INDICATION_ID != ''">
                                                                <Indication>
                                                                    <xsl:for-each select="key('Indication', ($RES_PRESCRIBING_TEXT_ID,$schedule-code))">
                                                                        <xsl:if test="EPISODICITY"><xsl:element name="EPISODICITY"><xsl:value-of select="EPISODICITY" /></xsl:element></xsl:if>
                                                                        <xsl:if test="SEVERITY"><xsl:element name="SEVERITY"><xsl:value-of select="SEVERITY" /></xsl:element></xsl:if>
                                                                        <xsl:element name="CONDITION"><xsl:value-of select="CONDITION" /></xsl:element>
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
                </Item>
            </xsl:for-each>
        </Schedule>
    </xsl:template>

</xsl:stylesheet>
