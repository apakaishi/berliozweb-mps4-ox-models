<!--
  This is a keys used to prepare the document

  @author Adriano Akaishi
  @date 14/09/2022
  @copyright Allette Systems Pty Ltd
-->

<xsl:stylesheet
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        version="2.0">

    <xsl:key name="item-atc-relationships" match="item-atc-relationships/element" composite="yes">
        <xsl:sequence select="pbs_code"/>
        <xsl:sequence select="schedule_code"/>
    </xsl:key>

    <xsl:key name="item-dispensing-rule-relationships" match="item-dispensing-rule-relationships/element" composite="yes">
        <xsl:sequence select="li_item_id"/>
        <xsl:sequence select="schedule_code"/>
    </xsl:key>

    <xsl:key name="atc-codes" match="atc-codes/element" composite="yes">
        <xsl:sequence select="atc_code"/>
        <xsl:sequence select="schedule_code"/>
    </xsl:key>

    <xsl:key name="item-increases" match="item-increases/element" composite="yes">
        <xsl:sequence select="pbs_code"/>
        <xsl:sequence select="schedule_code"/>
    </xsl:key>

    <xsl:key name="amt-items" match="amt-items/element" composite="yes">
        <xsl:sequence select="pbs_concept_id"/>
        <xsl:sequence select="li_item_id"/>
        <xsl:sequence select="schedule_code"/>
    </xsl:key>

    <xsl:key name="amt-items-no-concept-id" match="amt-items/element" composite="yes">
        <xsl:sequence select="concept_type_code"/>
        <xsl:sequence select="li_item_id"/>
        <xsl:sequence select="schedule_code"/>
    </xsl:key>

    <xsl:key name="ItemPrescribingTxtRltd" match="ItemPrescribingTxtRltd/element" composite="yes">
        <xsl:sequence select="pbs_code"/>
        <xsl:sequence select="schedule_code"/>
    </xsl:key>

    <xsl:key name="PrescribingTxt" match="PrescribingTxt/element" composite="yes">
        <xsl:sequence select="prescribing_txt_id"/>
        <xsl:sequence select="schedule_code"/>
    </xsl:key>

    <xsl:key name="Prescriber" match="prescribers/element" composite="yes">
        <xsl:sequence select="pbs_code"/>
        <xsl:sequence select="schedule_code"/>
    </xsl:key>

    <xsl:key name="Criteria" match="Criteria/element" composite="yes">
        <xsl:sequence select="criteria_prescribing_txt_id"/>
        <xsl:sequence select="schedule_code"/>
    </xsl:key>

    <xsl:key name="CriteriaParameterRltd" match="CriteriaParameterRltd/element" composite="yes">
        <xsl:sequence select="criteria_prescribing_txt_id"/>
        <xsl:sequence select="schedule_code"/>
    </xsl:key>

    <xsl:key name="Indication" match="Indication/element" composite="yes">
        <xsl:sequence select="indication_prescribing_txt_id"/>
        <xsl:sequence select="schedule_code"/>
    </xsl:key>

    <xsl:key name="ItemRestrictionRltd" match="ItemRestrictionRltd/element" composite="yes">
        <xsl:sequence select="pbs_code"/>
        <xsl:sequence select="schedule_code"/>
    </xsl:key>

    <xsl:key name="RestrictionText" match="RestrictionText/element" composite="yes">
        <xsl:sequence select="res_code"/>
        <xsl:sequence select="schedule_code"/>
    </xsl:key>

    <xsl:key name="RstrctnPrscrbngTxtRltd" match="RstrctnPrscrbngTxtRltd/element" composite="yes">
        <xsl:sequence select="res_code"/>
        <xsl:sequence select="schedule_code"/>
    </xsl:key>

    <xsl:key name="extemporaneous-preparation" match="extemporaneous-preparations/element" composite="yes">
        <xsl:sequence select="pbs_code"/>
        <xsl:sequence select="schedule_code"/>
    </xsl:key>

    <xsl:key name="standard-formula-preparations" match="standard-formula-preparations/element" composite="yes">
        <xsl:sequence select="pbs_code"/>
        <xsl:sequence select="schedule_code"/>
    </xsl:key>

    <xsl:key name="extemporaneous-standard-formula" match="extemporaneous-prep-sfp-relationships/element" composite="yes">
        <xsl:sequence select="sfp_pbs_code"/>
        <xsl:sequence select="schedule_code"/>
    </xsl:key>

</xsl:stylesheet>