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

    <xsl:param name="schedule-code" />
    <xsl:param name="folder" />
    <xsl:param name="edition-type" />

    <xsl:variable name="base" select="replace(replace(base-uri(),'file:', 'file://'), 'data-processed/full-items-document.xml', '')" />
    <xsl:variable name="output" select="concat($base,$folder,'/')" />
    <xsl:variable name="sch-path" select="concat('Schedule-',$schedule-code,'/')" />
    <xsl:variable name="edition-path" select="concat($sch-path,'Edition-',$edition-type,'/')" />

    <xsl:output method="xml" encoding="UTF-8" indent="yes" omit-xml-declaration="yes" />

    <xsl:template match="Schedule">

        <xsl:for-each select="Item">
            <xsl:variable name="PROGRAM_CODE" select="@PROGRAM_CODE" />
            <xsl:variable name="PBS_CODE" select="@PBS_CODE" />
            <xsl:variable name="name" select="@LI_ITEM_ID" />
            <xsl:variable name="program-path" select="concat($edition-path,'',$PROGRAM_CODE,'/')" />
            <xsl:variable name="pbs-path" select="concat($program-path,'Items/',$PBS_CODE,'/')" />
            <xsl:variable name="path" select="concat($output, $pbs-path, $name,'.psml')" />

            <xsl:variable name="title-pbs-code" select="concat('PBS code: ',$PBS_CODE)" />

            <xsl:result-document href="{$path}">
                <document type="stage_1" version="current" level="portable">
                    <documentinfo>
                        <uri documenttype="stage_1" title="{$title-pbs-code}">
                            <displaytitle><xsl:value-of select="$title-pbs-code" /></displaytitle>
                            <labels>item</labels>
                        </uri>
                    </documentinfo>
                    <metadata>
                        <properties>
                            <property name="version" title="version" value="0.1" datatype="string"/>
                            <property name="schedule-code" title="Schedule code" value="{$schedule-code}" datatype="string"/>
                            <property name="edition" title="Edition" value="{$edition-type}" datatype="string"/>
                            <property name="program-code" title="Program code" value="{$PROGRAM_CODE}" datatype="string"/>
                            <property name="pbs-code" title="PBS code" value="{$PBS_CODE}" datatype="string"/>
                        </properties>
                    </metadata>
                    <section id="title">
                        <fragment id="title">
                            <heading level="1"><xsl:value-of select="$title-pbs-code" /></heading>
                        </fragment>
                    </section>
                    <section id="documents" title="Documents">
                        <properties-fragment id="documents">
                            <property name="xml-document" title="XML document" datatype="xref">
                                <xref frag="default"  reversetitle="" reversefrag="documents" reverselink="true" reversetype="none" display="document" type="none" href="{concat('xml/',$name,'.xml')}" urititle="{concat('XML document',$PBS_CODE)}" mediatype="text/xml"><xsl:value-of select="concat('XML document: ',$PBS_CODE)" /></xref>
                            </property>
                            <xsl:for-each select="ItemRestrictionRltd">
                                <property name="{concat(@RES_CODE,'-document')}" title="{concat(@RES_CODE,' document')}" datatype="xref">
                                    <xref frag="default"  reversetitle="" reversefrag="documents" reverselink="true" reversetype="none" display="document" type="none" href="{concat('Restrictions/', @RES_CODE,'.psml')}" urititle="{@RES_CODE}" mediatype="text/xml"><xsl:value-of select="@RES_CODE" /></xref>
                                </property>
                            </xsl:for-each>
                        </properties-fragment>
                    </section>
                    <section id="schedules" title="schedules">
                        <properties-fragment id="schedules">
                            <xsl:for-each select="parent::Schedule/@*">
                                <property name="{local-name()}" title="{local-name()}" value="{.}" datatype="string"/>
                            </xsl:for-each>
                        </properties-fragment>
                    </section>
                    <section id="Item" title="Item">
                        <properties-fragment id="Item">
                            <xsl:for-each select="child::*[not(name()='amt-items' or name()='ItemPrescribingTxtRltd' or name()='ItemRestrictionRltd')]|@*">
                                <property name="{local-name()}" title="{local-name()}" value="{.}" datatype="string"/>
                            </xsl:for-each>
                        </properties-fragment>
                    </section>
                    <section id="amt-items" title="amt-items">
                        <xsl:for-each select="amt-items">
                          <xsl:variable name="PBS_CONCEPT_ID" select="PBS_CONCEPT_ID" />
                          <properties-fragment id="Item-AMT-{$PBS_CONCEPT_ID}">
                              <xsl:for-each select="child::*">
                                <property name="{local-name()}" title="{local-name()}" value="{.}" datatype="string"/>
                             </xsl:for-each>
                          </properties-fragment>
                        </xsl:for-each>
                    </section>
                    <section id="ItemPrescribingTxtRltd" title="ItemPrescribingTxtRltd">
                        <xsl:for-each select="ItemPrescribingTxtRltd">
                            <xsl:variable name="PRESCRIBING_TXT_ID" select="@PRESCRIBING_TXT_ID" />
                            <properties-fragment id="ItemPrescribingTxtRltd-{$PRESCRIBING_TXT_ID}">
                                <property name="PRESCRIBING_TXT_ID" title="PRESCRIBING_TXT_ID" value="{$PRESCRIBING_TXT_ID}" datatype="string"/>
                            </properties-fragment>

                            <xsl:for-each select="PrescribingTxt">
                                <properties-fragment id="PrescribingTxt-{$PRESCRIBING_TXT_ID}">
                                    <xsl:for-each select="child::*">
                                        <property name="{local-name()}" title="{local-name()}" value="{.}" datatype="string"/>
                                    </xsl:for-each>
                                </properties-fragment>
                            </xsl:for-each>
                        </xsl:for-each>
                    </section>
                    <section id="ItemRestrictionRltd" title="ItemRestrictionRltd">
                        <xsl:for-each select="ItemRestrictionRltd">
                            <xsl:variable name="RES_CODE" select="@RES_CODE" />
                            <properties-fragment id="ItemRestrictionRltd-{$RES_CODE}">
                                <xsl:for-each select="@*|child::*[name()='RESTRICTION_INDICATOR']">
                                    <property name="{local-name()}" title="{local-name()}" value="{.}" datatype="string"/>
                                </xsl:for-each>
                            </properties-fragment>

                            <xsl:for-each select="RestrictionText">
                                <properties-fragment id="RestrictionText-{$RES_CODE}">
                                    <xsl:for-each select="child::*[not(name()='RstrctnPrscrbngTxtRltd')]">
                                        <property name="{local-name()}" title="{local-name()}" value="{.}" datatype="string"/>
                                    </xsl:for-each>
                                </properties-fragment>

                                <xsl:if test="RstrctnPrscrbngTxtRltd">
                                    <xsl:for-each select="RstrctnPrscrbngTxtRltd">
                                        <xsl:variable name="PRESCRIBING_TEXT_ID" select="@PRESCRIBING_TEXT_ID" />
                                        <properties-fragment id="RES_CODE-{$RES_CODE}-RstrctnPrscrbngTxtRltd-{$PRESCRIBING_TEXT_ID}">
                                            <xsl:for-each select="@*|PrescribingTxt/child::*[not(name()='Indication' or name()='Criteria' or name()='COMPLEX_AUTHORITY_RQRD_IND')]">
                                                <property name="{local-name()}" title="{local-name()}" value="{.}" datatype="string"/>
                                            </xsl:for-each>
                                        </properties-fragment>
                                        <xsl:if test="PrescribingTxt/Indication">
                                            <xsl:for-each select="PrescribingTxt/Indication">
                                                <properties-fragment id="RES_CODE-{$RES_CODE}-Indication-{$PRESCRIBING_TEXT_ID}">
                                                    <xsl:for-each select="child::*">
                                                        <property name="{local-name()}" title="{local-name()}" value="{.}" datatype="string"/>
                                                    </xsl:for-each>
                                                </properties-fragment>
                                            </xsl:for-each>
                                        </xsl:if>

                                        <xsl:if test="PrescribingTxt/Criteria">
                                            <xsl:for-each select="PrescribingTxt/Criteria">
                                                <xsl:variable name="criteria-id" select="$PRESCRIBING_TEXT_ID" />
                                                <properties-fragment id="RES_CODE-{$RES_CODE}-Criteria-{$criteria-id}">
                                                    <xsl:for-each select="@*|child::*[not(name()='CriteriaParameterRltd')]">
                                                        <property name="{local-name()}" title="{local-name()}" value="{.}" datatype="string"/>
                                                    </xsl:for-each>
                                                </properties-fragment>

                                                <xsl:if test="CriteriaParameterRltd">
                                                    <xsl:for-each select="CriteriaParameterRltd">
                                                        <properties-fragment id="RES_CODE-{$RES_CODE}-CriteriaParameterRltd-{$criteria-id}">
                                                            <xsl:for-each select="@*|PrescribingTxt/child::*[not(name()='COMPLEX_AUTHORITY_RQRD_IND' or fn:name()='ASSESSMENT_TYPE_CODE')]">
                                                                <property name="{local-name()}" title="{local-name()}" value="{.}" datatype="string"/>
                                                            </xsl:for-each>
                                                        </properties-fragment>
                                                    </xsl:for-each>
                                                </xsl:if>
                                            </xsl:for-each>
                                        </xsl:if>
                                    </xsl:for-each>
                                </xsl:if>
                            </xsl:for-each>
                        </xsl:for-each>
                    </section>
                </document>
            </xsl:result-document>
        </xsl:for-each>
    </xsl:template>

</xsl:stylesheet>
