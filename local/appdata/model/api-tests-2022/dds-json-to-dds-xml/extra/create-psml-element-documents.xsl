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
                        <property name="schedule_code" title="schedule_code" value="{$schedule-code}" datatype="string"/>
                        <xsl:for-each select="Schedule/*[schedule_code=$schedule-code]/child::*[not(name()='schedule_code')]">
                            <property name="{local-name()}" title="{local-name()}" value="{.}" datatype="string"/>
                        </xsl:for-each>
                    </properties-fragment>
                </section>
            </document>
        </xsl:result-document>

        <!-- Indication documents -->
        <xsl:for-each select="Indication/*[schedule_code=$schedule-code]">
            <xsl:variable name="indication_prescribing_txt_id" select="indication_prescribing_txt_id" />
            <xsl:variable name="path-indications" select="concat($path-base,'PrescribingText/Indications/',$indication_prescribing_txt_id,'.psml')" />
            <xsl:variable name="title-indication" select="concat('Indication: ',$indication_prescribing_txt_id)" />

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
                            <xsl:for-each select="child::*[not(name()='schedule_code')]">
                                <property name="{local-name()}" title="{local-name()}" value="{.}" datatype="string"/>
                            </xsl:for-each>
                        </properties-fragment>
                    </section>
                </document>
            </xsl:result-document>
        </xsl:for-each>

        <!-- Criteria documents -->
        <xsl:for-each select="Criteria/*[schedule_code=$schedule-code]">
            <xsl:variable name="criteria_prescribing_txt_id" select="criteria_prescribing_txt_id" />
            <xsl:variable name="path-criterias" select="concat($path-base,'PrescribingText/Criterias/',$criteria_prescribing_txt_id,'.psml')" />
            <xsl:variable name="title-criteria" select="concat('Criteria: ',$criteria_prescribing_txt_id)" />

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
                            <xsl:for-each select="child::*[not(name()='schedule_code')]">
                                <property name="{local-name()}" title="{local-name()}" value="{.}" datatype="string"/>
                            </xsl:for-each>
                        </properties-fragment>
                    </section>
                    <xsl:variable name="has-criteria-parameter" select="key('CriteriaParameterRltd', ($criteria_prescribing_txt_id,$schedule-code))/parameter_prescribing_txt_id" />
                    <xsl:if test="$has-criteria-parameter != ''">
                        <section id="parameter" title="Parameter">
                            <xsl:for-each-group select="key('CriteriaParameterRltd', ($criteria_prescribing_txt_id,$schedule-code))" group-by="pt_position">
                                <xsl:sort select="pt_position" />
                                <xsl:variable name="parameter_prescribing_txt_id" select="parameter_prescribing_txt_id" />
                                <xsl:variable name="pt_position" select="pt_position" />
                                <properties-fragment id="{concat('parameter-',$parameter_prescribing_txt_id)}">
                                    <property name="pt_position" title="pt_position" value="{$pt_position}" datatype="string"/>
                                    <property name="parameter_prescribing_txt_id" title="parameter_prescribing_txt_id" datatype="xref">
                                        <xref frag="default"  reversetitle="" reversefrag="documents" reverselink="true" reversetype="none" display="document" type="none" href="{concat('../',$parameter_prescribing_txt_id,'.psml')}"><xsl:value-of select="$parameter_prescribing_txt_id" /></xref>
                                    </property>
                                </properties-fragment>
                            </xsl:for-each-group>
                        </section>
                    </xsl:if>
                </document>
            </xsl:result-document>
        </xsl:for-each>

        <!-- Prescribing Text documents-->
        <xsl:for-each select="PrescribingTxt/*[schedule_code=$schedule-code]">
            <xsl:variable name="prescribing_txt_id" select="prescribing_txt_id" />
            <xsl:variable name="path-pt" select="concat($path-base,'PrescribingText/',$prescribing_txt_id,'.psml')" />
            <xsl:variable name="title-prescribing-txt" select="concat('Prescribing Text: ',$prescribing_txt_id)" />

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
                            <xsl:for-each select="child::*[not(name()='schedule_code')]">
                                <property name="{local-name()}" title="{local-name()}" value="{.}" datatype="string"/>
                            </xsl:for-each>
                        </properties-fragment>
                    </section>

                    <xsl:variable name="has-prescribing-text-indication" select="key('Indication', ($prescribing_txt_id,$schedule-code))/indication_prescribing_txt_id" />
                    <xsl:if test="$has-prescribing-text-indication != ''">
                        <section id="indication" title="Indication">
                            <xsl:for-each select="key('Indication', ($prescribing_txt_id,$schedule-code))">
                                <xsl:variable name="indication_prescribing_txt_id" select="indication_prescribing_txt_id" />
                                <properties-fragment id="{concat('indication-',$indication_prescribing_txt_id)}">
                                    <property name="indication_prescribing_txt_id" title="indication_prescribing_txt_id" value="{$indication_prescribing_txt_id}" datatype="string"/>
                                    <xsl:if test="episodicity"><property name="episodicity" title="episodicity" value="{episodicity}" datatype="string"/></xsl:if>
                                    <xsl:if test="severity"><property name="severity" title="severity" value="{severity}" datatype="string"/></xsl:if>
                                    <xsl:if test="condition"><property name="condition" title="condition" value="{condition}" datatype="string"/></xsl:if>
                                </properties-fragment>
                            </xsl:for-each>
                        </section>
                    </xsl:if>

                    <xsl:variable name="has-prescribing-text-criteria" select="key('Criteria', ($prescribing_txt_id,$schedule-code))/criteria_prescribing_txt_id" />
                    <xsl:if test="$has-prescribing-text-criteria != ''">
                        <section id="criteria" title="Criteria">
                            <xsl:for-each select="key('Criteria', ($prescribing_txt_id,$schedule-code))">
                                <xsl:variable name="criteria_prescribing_txt_id" select="criteria_prescribing_txt_id" />
                                <properties-fragment id="{concat('criteria-',$criteria_prescribing_txt_id)}">
                                    <property name="criteria_prescribing_txt_id" title="criteria_prescribing_txt_id" value="{criteria_prescribing_txt_id}" datatype="string"/>
                                    <property name="criteria_type" title="criteria_type" value="{criteria_type}" datatype="string"/>
                                    <property name="parameter_relationship" title="parameter_relationship" value="{parameter_relationship}" datatype="string"/>
                                </properties-fragment>
                            </xsl:for-each>
                        </section>
                    </xsl:if>
                </document>
            </xsl:result-document>
        </xsl:for-each>

        <!-- Restriction documents -->
        <xsl:for-each select="RestrictionText/*[schedule_code=$schedule-code]">
            <xsl:variable name="res_code" select="res_code" />
            <xsl:variable name="path-restrictions" select="concat($path-base,'Restrictions/',$res_code,'.psml')" />
            <xsl:variable name="title-restriction" select="concat('Restriction: ',$res_code)" />

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
                            <xsl:for-each select="child::*[not(name()='schedule_code')]">
                                <property name="{local-name()}" title="{local-name()}" value="{.}" datatype="string"/>
                            </xsl:for-each>
                        </properties-fragment>
                    </section>

                    <xsl:variable name="has-restriction-prescribing-text" select="key('RstrctnPrscrbngTxtRltd', ($res_code,$schedule-code))/prescribing_text_id" />
                    <xsl:if test="$has-restriction-prescribing-text != ''">
                        <section id="prescring-text" title="Prescribing Text">
                            <xsl:for-each select="key('RstrctnPrscrbngTxtRltd', ($res_code,$schedule-code))">
                                <xsl:variable name="prescribing_text_id" select="prescribing_text_id" />
                                <properties-fragment id="{concat('prescribing-text-',$prescribing_text_id)}">
                                    <xsl:for-each select="child::*[not(name()='res_code' or name()='prescribing_text_id' or name()='schedule_code')]">
                                        <property name="pt_position" title="pt_position" value="{pt_position}" datatype="string"/>
                                    </xsl:for-each>
                                    <property name="prescribing_text_id" title="prescribing_text_id" datatype="xref">
                                        <xref frag="default"  reversetitle="" reversefrag="documents" reverselink="true" reversetype="none" display="document" type="none" href="{concat('../PrescribingText/',$prescribing_text_id,'.psml')}"><xsl:value-of select="$prescribing_text_id" /></xref>
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
