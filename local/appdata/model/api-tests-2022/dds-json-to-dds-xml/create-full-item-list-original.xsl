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

    <xsl:import href="common/keys-document-original.xsl" />
    <xsl:param name="schedule-code" />

    <xsl:output method="xml" encoding="UTF-8" indent="yes" omit-xml-declaration="yes" />

    <xsl:template match="root">

        <schedules>
            <xsl:attribute name="schedule-code"><xsl:value-of select="$schedule-code"/></xsl:attribute>
            <xsl:for-each select="schedules/element/child::*[not(name() ='schedule-code')]">
                <xsl:attribute name="{local-name()}"><xsl:value-of select="."/></xsl:attribute>
            </xsl:for-each>
            <xsl:for-each select="items/element">
                <xsl:variable name="MP" select="tokenize(li_item_id/text(),'_')[3]" />
                <xsl:variable name="MPP" select="tokenize(li_item_id/text(),'_')[4]" />
                <xsl:variable name="TPP" select="tokenize(li_item_id/text(),'_')[5]" />
                <xsl:variable name="pbs_code" select="pbs_code/text()" />
                <xsl:variable name="li_item_id" select="li_item_id/text()" />

                <items>
                    <xsl:copy-of select="@*" />
                    <amt-items>
                        <xsl:for-each select="key('amt-items', ($MP,$li_item_id,$schedule-code))">
                            <xsl:for-each select="child::*">
                                <xsl:attribute name="{local-name()}"><xsl:value-of select="."/></xsl:attribute>
                            </xsl:for-each>
                        </xsl:for-each>
                    </amt-items>
                    <amt-items>
                        <xsl:for-each select="key('amt-items', ($MPP,$li_item_id,$schedule-code))">
                            <xsl:for-each select="child::*">
                                <xsl:attribute name="{local-name()}"><xsl:value-of select="."/></xsl:attribute>
                            </xsl:for-each>
                        </xsl:for-each>
                    </amt-items>
                    <amt-items>
                        <xsl:for-each select="key('amt-items', ($TPP,$li_item_id,$schedule-code))">
                            <xsl:for-each select="child::*">
                                <xsl:attribute name="{local-name()}"><xsl:value-of select="."/></xsl:attribute>
                            </xsl:for-each>
                        </xsl:for-each>
                    </amt-items>
                    <amt-items>
                        <xsl:for-each select="key('amt-items-no-concept-id', ('MPUU',$li_item_id,$schedule-code))">
                            <xsl:for-each select="child::*">
                                <xsl:attribute name="{local-name()}"><xsl:value-of select="."/></xsl:attribute>
                            </xsl:for-each>
                        </xsl:for-each>
                    </amt-items>

                    <xsl:element name="item-increases">
                        <xsl:for-each select="key('item-increases', ($pbs_code,$schedule-code))">
                            <xsl:element name="item-increase">
                                <xsl:for-each select="child::*[not(name()='schedule_code')]">
                                    <xsl:attribute name="{local-name()}"><xsl:value-of select="."/></xsl:attribute>
                                </xsl:for-each>
                            </xsl:element>
                        </xsl:for-each>
                    </xsl:element>

                    <xsl:copy-of select="*" />
                    <!--
                    <xsl:element name="increases">
                      <xsl:for-each select="key('item-increases', ($pbs_code,$schedule-code))">
                         <xsl:element name="increase">
                           <xsl:variable name="type" select="if(increase_type='NUMBER_OF_REPEATS') then 'number_of_repeats' else 'maximum_quantity_units'" />
                           <xsl:variable name="value" select="increase_value" />
                           <xsl:element name="benefit_type_code"><xsl:value-of select="benefit_type_code"/></xsl:element>
                           <xsl:element name="{$type}"><xsl:value-of select="$value"/></xsl:element>
                         </xsl:element>
                      </xsl:for-each>
                    </xsl:element> -->
                    <xsl:element name="prescribers">
                      <xsl:for-each select="key('Prescriber', ($pbs_code,$schedule-code))">
                         <xsl:element name="prescriber">
                            <xsl:for-each select="child::*">
                               <xsl:attribute name="{local-name()}"><xsl:value-of select="."/></xsl:attribute>
                            </xsl:for-each>
                         </xsl:element>
                      </xsl:for-each>
                    </xsl:element>

                    <xsl:for-each select="key('items-prescribing-text-relationships', ($pbs_code,$schedule-code))">
                        <xsl:variable name="PRESCRIBING_TXT_REL_ID" select="prescribing_txt_id" />
                        <items-prescribing-text-relationships>
                            <xsl:attribute name="prescribing_txt_id"><xsl:value-of select="$PRESCRIBING_TXT_REL_ID" /></xsl:attribute>
                            <xsl:for-each select="child::*[not(name()='prescribing_txt_id')]">
                                <xsl:attribute name="{local-name()}"><xsl:value-of select="."/></xsl:attribute>
                            </xsl:for-each>
                            <prescribing-text>
                                <xsl:for-each select="key('prescribing-text', ($PRESCRIBING_TXT_REL_ID,$schedule-code))">
                                    <xsl:for-each select="child::*">
                                        <xsl:attribute name="{local-name()}"><xsl:value-of select="."/></xsl:attribute>
                                    </xsl:for-each>
                                </xsl:for-each>

                                <xsl:variable name="CRITERIA_PRESCRIBING_TEXT_ID" select="key('criteria', ($PRESCRIBING_TXT_REL_ID,$schedule-code))/criteria_prescribing_txt_id" />
                                <xsl:if test="$CRITERIA_PRESCRIBING_TEXT_ID != ''">
                                    <criteria>
                                        <xsl:attribute name="criteria_prescribing_txt_id"><xsl:value-of select="$CRITERIA_PRESCRIBING_TEXT_ID" /></xsl:attribute>
                                        <xsl:for-each select="key('criteria', ($PRESCRIBING_TXT_REL_ID,$schedule-code))">
                                            <xsl:for-each select="child::*">
                                                <xsl:attribute name="{local-name()}"><xsl:value-of select="."/></xsl:attribute>
                                            </xsl:for-each>
                                        </xsl:for-each>


                                        <xsl:for-each-group select="key('criteria-parameters-relationships', ($CRITERIA_PRESCRIBING_TEXT_ID,$schedule-code))" group-by="pt_position">
                                            <xsl:variable name="PARAMETER_PRESCRIBING_TXT_REL_ID" select="parameter_prescribing_txt_id" />
                                            <criteria-parameters-relationships>
                                                <xsl:for-each select="child::*">
                                                    <xsl:attribute name="{local-name()}"><xsl:value-of select="."/></xsl:attribute>
                                                </xsl:for-each>
                                                <prescribing-text>
                                                    <xsl:for-each select="key('prescribing-text', ($PARAMETER_PRESCRIBING_TXT_REL_ID,$schedule-code))">
                                                        <xsl:for-each select="child::*">
                                                            <xsl:attribute name="{local-name()}"><xsl:value-of select="."/></xsl:attribute>
                                                        </xsl:for-each>
                                                    </xsl:for-each>
                                                </prescribing-text>
                                            </criteria-parameters-relationships>
                                        </xsl:for-each-group>
                                    </criteria>
                                </xsl:if>
                                <xsl:variable name="has-INDICATION_ID" select="key('indications', ($PRESCRIBING_TXT_REL_ID,$schedule-code))/indication_prescribing_txt_id" />
                                <xsl:if test="$has-INDICATION_ID != ''">
                                    <indications>
                                        <xsl:for-each select="key('indications', ($PRESCRIBING_TXT_REL_ID,$schedule-code))">
                                            <xsl:for-each select="child::*">
                                                <xsl:attribute name="{local-name()}"><xsl:value-of select="."/></xsl:attribute>
                                            </xsl:for-each>
                                        </xsl:for-each>
                                    </indications>
                                </xsl:if>
                            </prescribing-text>
                        </items-prescribing-text-relationships>
                    </xsl:for-each>


                    <xsl:variable name="has-RESTRICTION_TXT_REL" select="key('items-restrictions-relationships', ($pbs_code,$schedule-code))/res_code" />

                    <xsl:if test="$has-RESTRICTION_TXT_REL != ''">

                        <xsl:for-each select="key('items-restrictions-relationships', ($pbs_code,$schedule-code))">
                            <xsl:variable name="res_code" select="res_code" />
                            <items-restrictions-relationships>
                                <xsl:for-each select="child::*">
                                    <xsl:attribute name="{local-name()}"><xsl:value-of select="."/></xsl:attribute>
                                </xsl:for-each>
                                <xsl:variable name="has-RESTRICTION_TXT" select="key('restrictions', ($res_code,$schedule-code))/res_code" />

                                <xsl:if test="$has-RESTRICTION_TXT != ''">
                                    <restrictions>
                                        <xsl:for-each select="key('restrictions', ($res_code,$schedule-code))">
                                            <xsl:for-each select="child::*">
                                                <xsl:attribute name="{local-name()}"><xsl:value-of select="."/></xsl:attribute>
                                            </xsl:for-each>
                                        </xsl:for-each>

                                        <xsl:variable name="has-RESTRICTION_ID_PRESCRIBING_TEXT" select="key('restrictions-prescribing-text-relationships', ($res_code,$schedule-code))/res_code" />

                                        <xsl:if test="$has-RESTRICTION_ID_PRESCRIBING_TEXT != ''">

                                            <xsl:for-each select="key('restrictions-prescribing-text-relationships', ($res_code,$schedule-code))">
                                                <xsl:variable name="RES_PRESCRIBING_TEXT_ID" select="prescribing_text_id" />
                                                <restrictions-prescribing-text-relationships>
                                                    <xsl:for-each select="child::*">
                                                        <xsl:attribute name="{local-name()}"><xsl:value-of select="."/></xsl:attribute>
                                                    </xsl:for-each>
                                                    <xsl:variable name="has-RESTRICTION_PRESCRIBING_TEXT_ID" select="key('prescribing-text', ($RES_PRESCRIBING_TEXT_ID,$schedule-code))/prescribing_txt_id" />

                                                    <xsl:if test="$has-RESTRICTION_PRESCRIBING_TEXT_ID != ''">
                                                        <prescribing-text>
                                                            <xsl:variable name="RES_PRESCRIBING_TEXT_ID" select="key('prescribing-text', ($RES_PRESCRIBING_TEXT_ID,$schedule-code))/prescribing_txt_id" />

                                                            <xsl:for-each select="key('prescribing-text', ($RES_PRESCRIBING_TEXT_ID,$schedule-code))">
                                                                <xsl:for-each select="child::*">
                                                                    <xsl:attribute name="{local-name()}"><xsl:value-of select="."/></xsl:attribute>
                                                                </xsl:for-each>
                                                            </xsl:for-each>

                                                            <xsl:variable name="CRITERIA_PRESCRIBING_TEXT_ID" select="key('criteria', ($RES_PRESCRIBING_TEXT_ID,$schedule-code))/criteria_prescribing_txt_id" />
                                                            <xsl:if test="$CRITERIA_PRESCRIBING_TEXT_ID != ''">
                                                                <criteria>
                                                                    <xsl:for-each select="key('criteria', ($RES_PRESCRIBING_TEXT_ID,$schedule-code))">
                                                                        <xsl:for-each select="child::*">
                                                                            <xsl:attribute name="{local-name()}"><xsl:value-of select="."/></xsl:attribute>
                                                                        </xsl:for-each>
                                                                    </xsl:for-each>

                                                                    <xsl:for-each-group select="key('criteria-parameters-relationships', ($CRITERIA_PRESCRIBING_TEXT_ID,$schedule-code))" group-by="pt_position">
                                                                        <xsl:variable name="PARAMETER_PRESCRIBING_TXT_REL_ID" select="parameter_prescribing_txt_id" />
                                                                        <criteria-parameters-relationships>
                                                                            <xsl:for-each select="child::*">
                                                                                <xsl:attribute name="{local-name()}"><xsl:value-of select="."/></xsl:attribute>
                                                                            </xsl:for-each>
                                                                            <prescribing-text>
                                                                                <xsl:for-each select="key('prescribing-text', ($PARAMETER_PRESCRIBING_TXT_REL_ID,$schedule-code))">
                                                                                    <xsl:for-each select="child::*">
                                                                                        <xsl:attribute name="{local-name()}"><xsl:value-of select="."/></xsl:attribute>
                                                                                    </xsl:for-each>
                                                                                </xsl:for-each>
                                                                            </prescribing-text>
                                                                        </criteria-parameters-relationships>
                                                                    </xsl:for-each-group>
                                                                </criteria>
                                                            </xsl:if>
                                                            <xsl:variable name="has-INDICATION_ID" select="key('indications', ($RES_PRESCRIBING_TEXT_ID,$schedule-code))/indication_prescribing_txt_id" />
                                                            <xsl:if test="$has-INDICATION_ID != ''">
                                                                <indications>
                                                                    <xsl:for-each select="key('indications', ($RES_PRESCRIBING_TEXT_ID,$schedule-code))">
                                                                        <xsl:for-each select="child::*">
                                                                            <xsl:attribute name="{local-name()}"><xsl:value-of select="."/></xsl:attribute>
                                                                        </xsl:for-each>
                                                                    </xsl:for-each>
                                                                </indications>
                                                            </xsl:if>
                                                        </prescribing-text>
                                                    </xsl:if>
                                                </restrictions-prescribing-text-relationships>
                                            </xsl:for-each>
                                        </xsl:if>
                                    </restrictions>
                                </xsl:if>
                            </items-restrictions-relationships>
                        </xsl:for-each>
                    </xsl:if>
                </items>
            </xsl:for-each>
        </schedules>
    </xsl:template>

</xsl:stylesheet>
