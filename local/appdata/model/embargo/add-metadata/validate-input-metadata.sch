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

  <sch:pattern id="has-columns">
    <sch:rule context="metadatas/metadata">
      <sch:assert test="uriid" flag="ALERT">Column uriid does not exist.</sch:assert>
      <sch:assert test="matches(uriid/text(), '^\d+$')" flag="ALERT">Uriid is not valid <sch:value-of select="uriid/text()"/> .</sch:assert>
      <sch:assert test="properties/property[@name='year']" flag="ALERT">Column year does not exist.</sch:assert>
      <sch:assert test="properties/property[@name='year_month']" flag="ALERT">Column year_month does not exist.</sch:assert>
      <sch:assert test="properties/property[@name='publish_date']" flag="ALERT">Column publish_date does not exist.</sch:assert>
    </sch:rule>
    <sch:rule context="edit-uris/edit-uris">
      <sch:assert test="uriid" flag="ALERT">Column uriid does not exist.</sch:assert>
      <sch:assert test="matches(uriid/text(), '^\d+$')" flag="ALERT">Uriid is not valid <sch:value-of select="uriid/text()"/> .</sch:assert>
      <sch:assert test="title" flag="ALERT">Column title does not exist.</sch:assert>
      <sch:assert test="description" flag="ALERT">Column description does not exist.</sch:assert>
      <sch:assert test="labels" flag="ALERT">Column labels does not exist.</sch:assert>
    </sch:rule>
  </sch:pattern>

</sch:schema>