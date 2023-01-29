<!--
  This is a keys used to prepare the document

  @author Adriano Akaishi
  @date 14/09/2022
  @copyright Allette Systems Pty Ltd
-->

<xsl:stylesheet
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        version="2.0">

    <xsl:key name="amt-items" match="amt-items/element" composite="yes">
        <xsl:sequence select="PBS_CONCEPT_ID"/>
        <xsl:sequence select="LI_ITEM_ID"/>
        <xsl:sequence select="SCHEDULE_CODE"/>
    </xsl:key>

    <xsl:key name="amt-items-no-concept-id" match="amt-items/element" composite="yes">
        <xsl:sequence select="CONCEPT_TYPE_CODE"/>
        <xsl:sequence select="LI_ITEM_ID"/>
        <xsl:sequence select="SCHEDULE_CODE"/>
    </xsl:key>

    <xsl:key name="ItemPrescribingTxtRltd" match="ItemPrescribingTxtRltd/element" composite="yes">
        <xsl:sequence select="PBS_CODE"/>
        <xsl:sequence select="SCHEDULE_CODE"/>
    </xsl:key>

    <xsl:key name="PrescribingTxt" match="PrescribingTxt/element" composite="yes">
        <xsl:sequence select="PRESCRIBING_TXT_ID"/>
        <xsl:sequence select="SCHEDULE_CODE"/>
    </xsl:key>

    <xsl:key name="Prescriber" match="prescribers/element" composite="yes">
        <xsl:sequence select="PBS_CODE"/>
        <xsl:sequence select="SCHEDULE_CODE"/>
    </xsl:key>

    <xsl:key name="Criteria" match="Criteria/element" composite="yes">
        <xsl:sequence select="CRITERIA_PRESCRIBING_TXT_ID"/>
        <xsl:sequence select="SCHEDULE_CODE"/>
    </xsl:key>

    <xsl:key name="CriteriaParameterRltd" match="CriteriaParameterRltd/element" composite="yes">
        <xsl:sequence select="CRITERIA_PRESCRIBING_TXT_ID"/>
        <xsl:sequence select="SCHEDULE_CODE"/>
    </xsl:key>

    <xsl:key name="Indication" match="Indication/element" composite="yes">
        <xsl:sequence select="INDICATION_PRESCRIBING_TXT_ID"/>
        <xsl:sequence select="SCHEDULE_CODE"/>
    </xsl:key>

    <xsl:key name="ItemRestrictionRltd" match="ItemRestrictionRltd/element" composite="yes">
        <xsl:sequence select="PBS_CODE"/>
        <xsl:sequence select="SCHEDULE_CODE"/>
    </xsl:key>

    <xsl:key name="RestrictionText" match="RestrictionText/element" composite="yes">
        <xsl:sequence select="RES_CODE"/>
        <xsl:sequence select="SCHEDULE_CODE"/>
    </xsl:key>

    <xsl:key name="RstrctnPrscrbngTxtRltd" match="RstrctnPrscrbngTxtRltd/element" composite="yes">
        <xsl:sequence select="RES_CODE"/>
        <xsl:sequence select="SCHEDULE_CODE"/>
    </xsl:key>

    <xsl:key name="summary-item" match="summary-of-changes/items/element" composite="yes">
        <xsl:sequence select="table"/>
        <xsl:sequence select="LI_ITEM_ID"/>
    </xsl:key>

    <xsl:key name="amt-item" match="summary-of-changes/amt-items/element" composite="yes">
        <xsl:sequence select="table"/>
        <xsl:sequence select="LI_ITEM_ID"/>
        <xsl:sequence select="PBS_CONCEPT_ID"/>
        <xsl:sequence select="AMT_CODE"/>
    </xsl:key>

    <xsl:key name="items-prescribing" match="summary-of-changes/items-prescribing/element" composite="yes">
        <xsl:sequence select="table"/>
        <xsl:sequence select="PBS_CODE"/>
        <xsl:sequence select="PRESCRIBING_TXT_ID"/>
    </xsl:key>

    <xsl:key name="prescribings" match="summary-of-changes/prescribings/element" composite="yes">
        <xsl:sequence select="table"/>
        <xsl:sequence select="PRESCRIBING_TXT_ID"/>
    </xsl:key>

    <xsl:key name="criterias" match="summary-of-changes/criterias/element" composite="yes">
        <xsl:sequence select="table"/>
        <xsl:sequence select="CRITERIA_PRESCRIBING_TXT_ID"/>
    </xsl:key>

    <xsl:key name="criterias-parameter" match="summary-of-changes/criterias-parameter/element" composite="yes">
        <xsl:sequence select="table"/>
        <xsl:sequence select="CRITERIA_PRESCRIBING_TXT_ID"/>
        <xsl:sequence select="PARAMETER_PRESCRIBING_TXT_ID"/>
    </xsl:key>

    <xsl:key name="indications" match="summary-of-changes/indications/element" composite="yes">
        <xsl:sequence select="table"/>
        <xsl:sequence select="INDICATION_PRESCRIBING_TXT_ID"/>
    </xsl:key>

    <xsl:key name="items-restriction" match="summary-of-changes/items-restriction/element" composite="yes">
        <xsl:sequence select="table"/>
        <xsl:sequence select="RES_CODE"/>
        <xsl:sequence select="PBS_CODE"/>
    </xsl:key>

    <xsl:key name="restrictions" match="summary-of-changes/restrictions/element" composite="yes">
        <xsl:sequence select="table"/>
        <xsl:sequence select="RES_CODE"/>
    </xsl:key>

    <xsl:key name="restrictions-prescribing" match="summary-of-changes/restrictions-prescribing/element" composite="yes">
        <xsl:sequence select="table"/>
        <xsl:sequence select="RES_CODE"/>
        <xsl:sequence select="PRESCRIBING_TEXT_ID"/>
    </xsl:key>

</xsl:stylesheet>