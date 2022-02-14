<?xml version="1.0" encoding="utf-8"?>
<!--
  Schematron to validate the xml generated from the spreadsheet.

  @author Valerie Ku
  @date 22/10/2021
  @copyright Allette Systems Pty Ltd
-->
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron"
            xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
            xmlns:xs="http://www.w3.org/2001/XMLSchema">
  <sch:title>Validate </sch:title>

  <sch:ns prefix = "af" uri = "http://www.allette.com.au"/>

  <sch:let name="case-id-column"      value="'case id'" />
  <sch:let name="meeting-date-column"   value="'meeting date'" />
  <sch:let name="pbac-outcome-status-column"          value="'pbac outcome status'" />
  <sch:let name="drug-name-column"  value="'drug name'" />
  <sch:let name="brand-names-column"         value="'brand names'" />
  <sch:let name="sponsors-column"     value="'sponsors'" />
  <sch:let name="purpose-column"     value="'purpose'" />
  <sch:let name="type-listing-column"  value="'type listing'" />
  <sch:let name="submission-type-column"         value="'submission type'" />
  <sch:let name="comment-column"     value="'comment'" />
  <sch:let name="resubmission-column"     value="'resubmission'" />
  <sch:let name="related-medicine-column"   value="'related medicines'" />
  <sch:let name="status-column" value="'status'" />
  <sch:let name="step-1-status-column"   value="'step 1 status'" />
  <sch:let name="step-2-status-column"          value="'step 2 status'" />
  <sch:let name="step-2-open-date-column"          value="'step 2 open date'" />
  <sch:let name="step-2-closed-date-column"     value="'step 2 closed date'" />
  <sch:let name="step-2-see-url-column"       value="'step 2 see url'" />
  <sch:let name="step-2-see-url-title-column"       value="'step 2 see url title'" />

<!--  <sch:pattern id="test">-->
<!--    &lt;!&ndash;-->
<!--    &ndash;&gt;-->
<!--    <sch:rule context="/">-->
<!--      <sch:assert test="root" flag="ALERT">-->
<!--        <sch:value-of select="'root does not exist'"/>-->
<!--      </sch:assert>-->
<!--      <sch:report test="root" flag="ALERT">-->
<!--        <sch:value-of select="'root exists'"/>-->
<!--      </sch:report>-->
<!--    </sch:rule>-->

<!--  </sch:pattern>-->

  <sch:pattern id="has-columns">
    <!--
    -->
    <sch:rule context="root/*[not(position()= (0, last()))]">
      <sch:let name="row-number"   value="position()" />
      <sch:let name="case-id" value="*[af:same-characters(name(), $case-id-column)]"/>
      <sch:assert test="$case-id" flag="ALERT">
        <sch:value-of select="af:message-column-not-found($row-number, $case-id-column, $case-id)"/>
      </sch:assert>
      <sch:assert test="af:column-exist(., $meeting-date-column)" flag="ALERT">
        <sch:value-of select="af:message-column-not-found($row-number, $meeting-date-column, $case-id)"/>
      </sch:assert>
      <sch:assert test="af:column-exist(., $pbac-outcome-status-column)" flag="ALERT">
        <sch:value-of select="af:message-column-not-found($row-number, $pbac-outcome-status-column, $case-id)"/>
      </sch:assert>
      <sch:assert test="af:column-exist(., $drug-name-column)" flag="ALERT">
        <sch:value-of select="af:message-column-not-found($row-number, $drug-name-column, $case-id)"/>
      </sch:assert>
      <sch:assert test="af:column-exist(., $brand-names-column)" flag="ALERT">
        <sch:value-of select="af:message-column-not-found($row-number, $brand-names-column, $case-id)"/>
      </sch:assert>
      <sch:assert test="af:column-exist(., $sponsors-column)" flag="ALERT">
        <sch:value-of select="af:message-column-not-found($row-number, $sponsors-column, $case-id)"/>
      </sch:assert>
      <sch:assert test="af:column-exist(., $purpose-column)" flag="ALERT">
        <sch:value-of select="af:message-column-not-found($row-number, $purpose-column, $case-id)"/>
      </sch:assert>
      <sch:assert test="af:column-exist(., $type-listing-column)" flag="ALERT">
        <sch:value-of select="af:message-column-not-found($row-number, $type-listing-column, $case-id)"/>
      </sch:assert>
      <sch:assert test="af:column-exist(., $submission-type-column)" flag="ALERT">
        <sch:value-of select="af:message-column-not-found($row-number, $submission-type-column, $case-id)"/>
      </sch:assert>
      <sch:assert test="af:column-exist(., $comment-column)" flag="ALERT">
        <sch:value-of select="af:message-column-not-found($row-number, $comment-column, $case-id)"/>
      </sch:assert>
      <sch:assert test="af:column-exist(., $resubmission-column)" flag="ALERT">
        <sch:value-of select="af:message-column-not-found($row-number, $resubmission-column, $case-id)"/>
      </sch:assert>
      <sch:assert test="af:column-exist(., $related-medicine-column)" flag="ALERT">
        <sch:value-of select="af:message-column-not-found($row-number, $related-medicine-column, $case-id)"/>
      </sch:assert>
      <sch:assert test="af:column-exist(., $step-1-status-column)" flag="ALERT">
        <sch:value-of select="af:message-column-not-found($row-number, $step-1-status-column, $case-id)"/>
      </sch:assert>
      <sch:assert test="af:column-exist(., $step-2-status-column)" flag="ALERT">
        <sch:value-of select="af:message-column-not-found($row-number, $step-2-status-column, $case-id)"/>
      </sch:assert>

      <sch:let name="step-2-open-date" value="*[af:same-characters(name(), $step-2-open-date-column)]"/>
      <sch:assert test="$step-2-open-date" flag="ALERT">
        <sch:value-of select="af:message-column-not-found($row-number, $step-2-open-date-column, $case-id)"/>
      </sch:assert>
      <sch:assert test="matches($step-2-open-date/text(), '^[0-9]{1,2}/[0-9]{1,2}/[0-9]{4}$')" flag="WARNING">
        Date format should be DD/MM/YYYY <sch:value-of select="$step-2-open-date"/> at row <sch:value-of select="position()"/>
      </sch:assert>

      <sch:let name="step-2-closed-date" value="*[af:same-characters(name(), $step-2-closed-date-column)]"/>
      <sch:assert test="$step-2-closed-date" flag="ALERT">
        <sch:value-of select="af:message-column-not-found($row-number, $step-2-closed-date-column, $case-id)"/>
      </sch:assert>
      <sch:assert test="matches($step-2-closed-date/text(), '^[0-9]{1,2}/[0-9]{1,2}/[0-9]{4}$')" flag="WARNING">
        Date format should be DD/MM/YYYY <sch:value-of select="$step-2-closed-date"/> at row <sch:value-of select="position()"/>
      </sch:assert>

      <!-- It is not working yet -->
      <sch:let name="step-2-see-url" value="*[af:same-characters(name(), $step-2-see-url-column)]"/>
      <sch:let name="step-2-see-url-title" value="*[af:same-characters(name(), $step-2-see-url-title-column)]"/>

      <sch:assert test="(not($step-2-see-url/text()) and not($step-2-see-url-title/text()))
      or ($step-2-see-url and $step-2-see-url-title)" flag="ALERT">
        <sch:value-of select="concat('Invalid step 2 see url href/title',$step-2-see-url/text())"/>
      </sch:assert>

    </sch:rule>
  </sch:pattern>

  <xsl:function name="af:message-column-not-found" as="xs:string">
    <xsl:param name="row-number" as="xs:string"/>
    <xsl:param name="column-name" as="xs:string"/>
    <xsl:param name="case-id" as="element()?"/>
    <xsl:variable name="temp-case-id" select="if ($case-id) then $case-id/text() else 'unknown'"/>
    <xsl:value-of select="concat('Column ', $column-name, ' not found in row ', $row-number, ' and case-id ', $temp-case-id, '.')"/>
  </xsl:function>

  <xsl:function name="af:column-exist" as="xs:boolean">
    <xsl:param name="row-element" as="element()"/>
    <xsl:param name="column-name" as="xs:string"/>
<!--    <xsl:message>Column Exist: <xsl:value-of select="$column-name"/></xsl:message>-->
<!--    <xsl:message>Result: <xsl:value-of select="count($row-element/*[af:same-characters(name(), $column-name)])=1"/></xsl:message>-->
    <xsl:sequence select="count($row-element/*[af:same-characters(name(), $column-name)])=1"/>
  </xsl:function>

  <xsl:function name="af:same-characters" as="xs:boolean">
    <xsl:param name="value-01" as="xs:string"/>
    <xsl:param name="value-02" as="xs:string"/>
<!--    <xsl:message> Same characters <xsl:value-of select="$value-01"/> | <xsl:value-of select="$value-02"/></xsl:message>-->
    <xsl:sequence select="replace(lower-case($value-01), '[^a-z0-9]', '') = replace(lower-case($value-02), '[^a-z0-9]', '')"/>
  </xsl:function>
</sch:schema>