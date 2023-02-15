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

    <xsl:import href="../common/keys-document.xsl" />
    <xsl:param name="schedule-code" />
    <xsl:param name="folder" />
    <xsl:param name="edition-type" />

    <xsl:variable name="base" select="replace(replace(base-uri(),'file:', 'file://'), 'data-processed/cleaned-document.xml', '')" />
    <xsl:variable name="output" select="concat($base,$folder,'/')" />
    <xsl:variable name="sch-path" select="concat($output,'Schedule-',$schedule-code,'/')" />
    <xsl:variable name="path-base" select="concat($sch-path,'Edition-',$edition-type,'/')" />

    <xsl:output method="xml" encoding="UTF-8" indent="yes" omit-xml-declaration="yes" />

    <xsl:template match="root">

        <!-- Schedule document -->
        <xsl:variable name="path-schedule" select="concat($path-base,'schedule.psml')" />
        <xsl:variable name="title-schedule" select="concat('Schedule: ',$schedule-code)" />
        <xsl:result-document href="{$path-schedule}" method="xml">
            <document type="extra_stage" version="current" level="portable">
                <documentinfo>
                    <uri documenttype="extra_stage" title="{$title-schedule}">
                        <displaytitle><xsl:value-of select="$title-schedule" /></displaytitle>
                        <labels>schedule</labels>
                    </uri>
                </documentinfo>
                <metadata>
                    <properties>
                        <property name="version" title="version" value="0.1" datatype="string"/>
                    </properties>
                </metadata>
                <section id="title">
                    <fragment id="title">
                        <heading level="1"><xsl:value-of select="$title-schedule" /></heading>
                    </fragment>
                </section>
                <section id="content" title="Schedule">
                    <properties-fragment id="1">
                        <property name="SCHEDULE_CODE" title="SCHEDULE_CODE" value="{$schedule-code}" datatype="string"/>
                        <xsl:for-each select="Schedule/*[SCHEDULE_CODE=$schedule-code]/child::*[not(name()='SCHEDULE_CODE')]">
                            <property name="{local-name()}" title="{local-name()}" value="{.}" datatype="string"/>
                        </xsl:for-each>
                    </properties-fragment>
                </section>
            </document>
        </xsl:result-document>

        <!-- Indication documents -->
        <xsl:for-each select="Indication/*[SCHEDULE_CODE=$schedule-code]">
            <xsl:variable name="INDICATION_PRESCRIBING_TXT_ID" select="INDICATION_PRESCRIBING_TXT_ID" />
            <xsl:variable name="path-indications" select="concat($path-base,'PrescribingText/Indications/',$INDICATION_PRESCRIBING_TXT_ID,'.psml')" />
            <xsl:variable name="title-indication" select="concat('Indication: ',$INDICATION_PRESCRIBING_TXT_ID)" />

            <xsl:result-document href="{$path-indications}" method="xml">
                <document type="extra_stage" version="current" level="portable">
                    <documentinfo>
                        <uri documenttype="extra_stage" title="{$title-indication}">
                            <displaytitle><xsl:value-of select="$title-indication" /></displaytitle>
                            <labels>indication</labels>
                        </uri>
                    </documentinfo>
                    <metadata>
                        <properties>
                            <property name="version" title="version" value="0.1" datatype="string"/>
                            <property name="schedule-code" title="Schedule code" value="{$schedule-code}" datatype="string"/>
                            <property name="edition" title="Edition" value="{$edition-type}" datatype="string"/>
                        </properties>
                    </metadata>
                    <section id="title">
                        <fragment id="title">
                            <heading level="1"><xsl:value-of select="$title-indication" /></heading>
                        </fragment>
                    </section>
                    <section id="content" title="Indication">
                        <properties-fragment id="1">
                            <xsl:for-each select="child::*[not(name()='SCHEDULE_CODE')]">
                                <property name="{local-name()}" title="{local-name()}" value="{.}" datatype="string"/>
                            </xsl:for-each>
                        </properties-fragment>
                    </section>
                </document>
            </xsl:result-document>
        </xsl:for-each>

        <!-- Criteria documents -->
        <xsl:for-each select="Criteria/*[SCHEDULE_CODE=$schedule-code]">
            <xsl:variable name="CRITERIA_PRESCRIBING_TXT_ID" select="CRITERIA_PRESCRIBING_TXT_ID" />
            <xsl:variable name="path-criterias" select="concat($path-base,'PrescribingText/Criterias/',$CRITERIA_PRESCRIBING_TXT_ID,'.psml')" />
            <xsl:variable name="title-criteria" select="concat('Criteria: ',$CRITERIA_PRESCRIBING_TXT_ID)" />

            <xsl:result-document href="{$path-criterias}" method="xml">
                <document type="extra_stage" version="current" level="portable">
                    <documentinfo>
                        <uri documenttype="extra_stage" title="{$title-criteria}">
                            <displaytitle><xsl:value-of select="$title-criteria" /></displaytitle>
                            <labels>criteria</labels>
                        </uri>
                    </documentinfo>
                    <metadata>
                        <properties>
                            <property name="version" title="version" value="0.1" datatype="string"/>
                            <property name="schedule-code" title="Schedule code" value="{$schedule-code}" datatype="string"/>
                            <property name="edition" title="Edition" value="{$edition-type}" datatype="string"/>
                        </properties>
                    </metadata>
                    <section id="title">
                        <fragment id="title">
                            <heading level="1"><xsl:value-of select="$title-criteria" /></heading>
                        </fragment>
                    </section>
                    <section id="content" title="Criteria">
                        <properties-fragment id="1">
                            <xsl:for-each select="child::*[not(name()='SCHEDULE_CODE')]">
                                <property name="{local-name()}" title="{local-name()}" value="{.}" datatype="string"/>
                            </xsl:for-each>
                        </properties-fragment>
                    </section>
                    <xsl:variable name="has-criteria-parameter" select="key('CriteriaParameterRltd', ($CRITERIA_PRESCRIBING_TXT_ID,$schedule-code))/PARAMETER_PRESCRIBING_TXT_ID" />
                    <xsl:if test="$has-criteria-parameter != ''">
                        <section id="parameter" title="Parameter">
                            <xsl:for-each-group select="key('CriteriaParameterRltd', ($CRITERIA_PRESCRIBING_TXT_ID,$schedule-code))" group-by="PT_POSITION">
                                <xsl:sort select="PT_POSITION" />
                                <xsl:variable name="PARAMETER_PRESCRIBING_TXT_ID" select="PARAMETER_PRESCRIBING_TXT_ID" />
                                <xsl:variable name="PT_POSITION" select="PT_POSITION" />
                                <properties-fragment id="{concat('parameter-',$PARAMETER_PRESCRIBING_TXT_ID)}">
                                    <property name="PT_POSITION" title="PT_POSITION" value="{$PT_POSITION}" datatype="string"/>
                                    <property name="PARAMETER_PRESCRIBING_TXT_ID" title="PARAMETER_PRESCRIBING_TXT_ID" datatype="xref">
                                        <xref frag="default"  reversetitle="" reversefrag="documents" reverselink="true" reversetype="none" display="document" type="none" href="{concat('../',$PARAMETER_PRESCRIBING_TXT_ID,'.psml')}"><xsl:value-of select="$PARAMETER_PRESCRIBING_TXT_ID" /></xref>
                                    </property>
                                </properties-fragment>
                            </xsl:for-each-group>
                        </section>
                    </xsl:if>
                </document>
            </xsl:result-document>
        </xsl:for-each>

        <!-- Prescribing Text documents-->
        <xsl:for-each select="PrescribingTxt/*[SCHEDULE_CODE=$schedule-code]">
            <xsl:variable name="PRESCRIBING_TXT_ID" select="PRESCRIBING_TXT_ID" />
            <xsl:variable name="path-pt" select="concat($path-base,'PrescribingText/',$PRESCRIBING_TXT_ID,'.psml')" />
            <xsl:variable name="title-prescribing-txt" select="concat('Prescribing Text: ',$PRESCRIBING_TXT_ID)" />

            <xsl:result-document href="{$path-pt}" method="xml">
                <document type="extra_stage" version="current" level="portable">
                    <documentinfo>
                        <uri documenttype="extra_stage" title="{$title-prescribing-txt}">
                            <displaytitle><xsl:value-of select="$title-prescribing-txt" /></displaytitle>
                            <labels>prescribing_text</labels>
                        </uri>
                    </documentinfo>
                    <metadata>
                        <properties>
                            <property name="version" title="version" value="0.1" datatype="string"/>
                            <property name="schedule-code" title="Schedule code" value="{$schedule-code}" datatype="string"/>
                            <property name="edition" title="Edition" value="{$edition-type}" datatype="string"/>
                        </properties>
                    </metadata>
                    <section id="title">
                        <fragment id="title">
                            <heading level="1"><xsl:value-of select="$title-prescribing-txt" /></heading>
                        </fragment>
                    </section>
                    <section id="content" title="Prescribing Text">
                        <properties-fragment id="1">
                            <xsl:for-each select="child::*[not(name()='SCHEDULE_CODE')]">
                                <property name="{local-name()}" title="{local-name()}" value="{.}" datatype="string"/>
                            </xsl:for-each>
                        </properties-fragment>
                    </section>

                    <xsl:variable name="has-prescribing-text-indication" select="key('Indication', ($PRESCRIBING_TXT_ID,$schedule-code))/INDICATION_PRESCRIBING_TXT_ID" />
                    <xsl:if test="$has-prescribing-text-indication != ''">
                        <section id="indication" title="Indication">
                            <xsl:for-each select="key('Indication', ($PRESCRIBING_TXT_ID,$schedule-code))">
                                <xsl:variable name="INDICATION_PRESCRIBING_TXT_ID" select="INDICATION_PRESCRIBING_TXT_ID" />
                                <properties-fragment id="{concat('indication-',$INDICATION_PRESCRIBING_TXT_ID)}">
                                    <property name="INDICATION_PRESCRIBING_TXT_ID" title="INDICATION_PRESCRIBING_TXT_ID" value="{$INDICATION_PRESCRIBING_TXT_ID}" datatype="string"/>
                                    <xsl:if test="EPISODICITY"><property name="EPISODICITY" title="EPISODICITY" value="{EPISODICITY}" datatype="string"/></xsl:if>
                                    <xsl:if test="SEVERITY"><property name="SEVERITY" title="SEVERITY" value="{SEVERITY}" datatype="string"/></xsl:if>
                                    <xsl:if test="CONDITION"><property name="CONDITION" title="CONDITION" value="{CONDITION}" datatype="string"/></xsl:if>
                                </properties-fragment>
                            </xsl:for-each>
                        </section>
                    </xsl:if>

                    <xsl:variable name="has-prescribing-text-criteria" select="key('Criteria', ($PRESCRIBING_TXT_ID,$schedule-code))/CRITERIA_PRESCRIBING_TXT_ID" />
                    <xsl:if test="$has-prescribing-text-criteria != ''">
                        <section id="criteria" title="Criteria">
                            <xsl:for-each select="key('Criteria', ($PRESCRIBING_TXT_ID,$schedule-code))">
                                <xsl:variable name="CRITERIA_PRESCRIBING_TXT_ID" select="CRITERIA_PRESCRIBING_TXT_ID" />
                                <properties-fragment id="{concat('criteria-',$CRITERIA_PRESCRIBING_TXT_ID)}">
                                    <property name="CRITERIA_PRESCRIBING_TXT_ID" title="CRITERIA_PRESCRIBING_TXT_ID" value="{CRITERIA_PRESCRIBING_TXT_ID}" datatype="string"/>
                                    <property name="CRITERIA_TYPE" title="CRITERIA_TYPE" value="{CRITERIA_TYPE}" datatype="string"/>
                                    <property name="PARAMETER_RELATIONSHIP" title="PARAMETER_RELATIONSHIP" value="{PARAMETER_RELATIONSHIP}" datatype="string"/>
                                </properties-fragment>
                            </xsl:for-each>
                        </section>
                    </xsl:if>
                </document>
            </xsl:result-document>
        </xsl:for-each>

        <!-- Restriction documents -->
        <xsl:for-each select="RestrictionText/*[SCHEDULE_CODE=$schedule-code]">
            <xsl:variable name="RES_CODE" select="RES_CODE" />
            <xsl:variable name="path-restrictions" select="concat($path-base,'Restrictions/',$RES_CODE,'.psml')" />
            <xsl:variable name="title-restriction" select="concat('Restriction: ',$RES_CODE)" />

            <xsl:result-document href="{$path-restrictions}" method="xml">
                <document type="extra_stage" version="current" level="portable">
                    <documentinfo>
                        <uri documenttype="extra_stage" title="{$title-restriction}">
                            <displaytitle><xsl:value-of select="$title-restriction" /></displaytitle>
                            <labels>restriction</labels>
                        </uri>
                    </documentinfo>
                    <metadata>
                        <properties>
                            <property name="version" title="version" value="0.1" datatype="string"/>
                            <property name="schedule-code" title="Schedule code" value="{$schedule-code}" datatype="string"/>
                            <property name="edition" title="Edition" value="{$edition-type}" datatype="string"/>
                        </properties>
                    </metadata>
                    <section id="title">
                        <fragment id="title">
                            <heading level="1"><xsl:value-of select="$title-restriction" /></heading>
                        </fragment>
                    </section>
                    <section id="content" title="Restriction">
                        <properties-fragment id="1">
                            <xsl:for-each select="child::*[not(name()='SCHEDULE_CODE')]">
                                <property name="{local-name()}" title="{local-name()}" value="{.}" datatype="string"/>
                            </xsl:for-each>
                        </properties-fragment>
                    </section>

                    <xsl:variable name="has-restriction-prescribing-text" select="key('RstrctnPrscrbngTxtRltd', ($RES_CODE,$schedule-code))/PRESCRIBING_TEXT_ID" />
                    <xsl:if test="$has-restriction-prescribing-text != ''">
                        <section id="prescring-text" title="Prescribing Text">
                            <xsl:for-each select="key('RstrctnPrscrbngTxtRltd', ($RES_CODE,$schedule-code))">
                                <xsl:variable name="PRESCRIBING_TEXT_ID" select="PRESCRIBING_TEXT_ID" />
                                <properties-fragment id="{concat('prescribing-text-',$PRESCRIBING_TEXT_ID)}">
                                    <xsl:for-each select="child::*[not(name()='RES_CODE' or name()='PRESCRIBING_TEXT_ID' or name()='SCHEDULE_CODE')]">
                                        <property name="PT_POSITION" title="PT_POSITION" value="{PT_POSITION}" datatype="string"/>
                                    </xsl:for-each>
                                    <property name="PRESCRIBING_TEXT_ID" title="PRESCRIBING_TEXT_ID" datatype="xref">
                                        <xref frag="default"  reversetitle="" reversefrag="documents" reverselink="true" reversetype="none" display="document" type="none" href="{concat('../PrescribingText/',$PRESCRIBING_TEXT_ID,'.psml')}"><xsl:value-of select="$PRESCRIBING_TEXT_ID" /></xref>
                                    </property>
                                </properties-fragment>
                            </xsl:for-each>
                        </section>
                    </xsl:if>
                </document>
            </xsl:result-document>
        </xsl:for-each>

    </xsl:template>

</xsl:stylesheet>
