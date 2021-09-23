<?xml version="1.0" encoding="utf-8"?>
<!--
  This schematron validates a PSML document.

  The schematron rules can be used to enforce additional constraints required
  by the application.
--><sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron">
  <!-- declaring an namespace -->
  <sch:ns prefix="ex" uri="http://namespace-example.com"/>
  <sch:title>Trainning Practice</sch:title>

  <sch:phase id="assert">
    <sch:active pattern="pattern-1"/>
  </sch:phase>

  <sch:phase id="report">
    <sch:active pattern="pattern-2"/>
  </sch:phase>

  <sch:phase id="both">
    <sch:active pattern="pattern-1"/>
    <sch:active pattern="pattern-2"/>
  </sch:phase>

  <!-- BELOW ARE EXAMPLES ONLY WHICH SHOULD BE MODIFIED FOR YOUR DOCUMENTS -->
  <sch:pattern name="Asserting" id="pattern-1">
    <sch:title>Assert</sch:title>
    <sch:rule context="root-element/child::*[position() = 2]">
      <sch:assert test="name() = 'second-child-element'" id="assert-1">Second child element name is not 'second-child-element', instead, it is <sch:name/>.</sch:assert>
    </sch:rule>
  </sch:pattern>

  <sch:pattern name="Reporting" id="pattern-2">
    <sch:title>Report</sch:title>
    <sch:rule context="root-element">
      <sch:report test="not(empty-element/text())" id="report-1"><sch:name path="./empty-element"/> is empty</sch:report>
    </sch:rule>
  </sch:pattern>

  <sch:pattern name="Attribute check">
    <sch:rule context="root-element/participants/name">
      <sch:report diagnostics="d1" test="@id &gt; 1">The @id of the Name elements in Participants cannot be greater than 1.</sch:report>
    </sch:rule>
  </sch:pattern>

  <sch:diagnostics>
    <sch:diagnostic id="d1"> The value of @id is <sch:value-of select="@id"/>.</sch:diagnostic>
  </sch:diagnostics>
  <!--
  <sch:pattern name="working with key - 1" id="pattern-3">
    <sch:title>Key Set</sch:title>
    <sch:rule context="rarticipants">
      <sch:assert test="@nbr-participants = count(name)">The
        number of Name elements must match the value of
        @nbr-participants.</sch:assert>
      <sch:key name="participant" path="name/@id"/>
    </sch:rule>

    <sch:rule context="team/member">
      <sch:assert test="key( 'participant', text() )">The
        Member of a Team must exist as a Name in Participants.
      </sch:assert>
    </sch:rule>
  </sch:pattern>
  -->
  <!--
<sch:pattern name="working with key - 2" id="pattern-4">
  <sch:title>Key Set</sch:title>
  <sch:rule context="root-element/first-child-element">
    <sch:assert test="@code" id="assert-1">First child element does not have code.</sch:assert>
    <sch:key name="codes" path="@code"/>
  </sch:rule>
<sch:rule context="root-element/first-child-element/grand-children">
    <sch:assert test="key('codes', @code)">This grand childrens has the same code of a child element.</sch:assert>
  </sch:rule>

  </sch:pattern>
-->
</sch:schema>