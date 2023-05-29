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
            <xsl:variable name="program_code" select="@program_code" />
            <xsl:variable name="pbs_code" select="@pbs_code" />
            <xsl:variable name="name" select="@li_item_id" />
            <xsl:variable name="program-path" select="concat($edition-path,'',$program_code,'/')" />
            <xsl:variable name="pbs-path" select="concat($program-path,'Items/',$pbs_code,'/')" />
            <xsl:variable name="path" select="concat($output, $pbs-path, $name,'.psml')" />

            <xsl:variable name="title-pbs-code" select="concat('PBS code: ',$pbs_code)" />

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
                            <property name="program-code" title="Program code" value="{$program_code}" datatype="string"/>
                            <property name="pbs-code" title="PBS code" value="{$pbs_code}" datatype="string"/>
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
                                <xref frag="default"  reversetitle="" reversefrag="documents" reverselink="true" reversetype="none" display="document" type="none" href="{concat('xml/',$name,'.xml')}" urititle="{concat('XML document',$pbs_code)}" mediatype="text/xml"><xsl:value-of select="concat('XML document: ',$pbs_code)" /></xref>
                            </property>
                            <xsl:for-each select="item-increases/item-increase[@res_code]">
                                <property name="{concat(@res_code,'-document')}" title="{concat(@res_code,' document')}" datatype="xref">
                                    <xref frag="default"  reversetitle="" reversefrag="documents" reverselink="true" reversetype="none" display="document" type="none" href="{concat('Restrictions/', @res_code,'.psml')}" urititle="{@res_code}" mediatype="text/xml"><xsl:value-of select="@res_code" /></xref>
                                </property>
                            </xsl:for-each>
                            <xsl:for-each select="ItemRestrictionRltd">
                                <property name="{concat(@res_code,'-document')}" title="{concat(@res_code,' document')}" datatype="xref">
                                    <xref frag="default"  reversetitle="" reversefrag="documents" reverselink="true" reversetype="none" display="document" type="none" href="{concat('Restrictions/', @res_code,'.psml')}" urititle="{@res_code}" mediatype="text/xml"><xsl:value-of select="@res_code" /></xref>
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
                          <xsl:variable name="pbs_concept_id" select="pbs_concept_id[1]" />
                          <xsl:if test="$pbs_concept_id!=''">
                              <properties-fragment id="Item-ConceptID-{$pbs_concept_id}">
                                  <xsl:for-each select="child::*">
                                      <property name="{local-name()}" title="{local-name()}" value="{.}" datatype="string"/>
                                  </xsl:for-each>
                              </properties-fragment>
                          </xsl:if>
                       </xsl:for-each>
                    </section>

                    <section id="item-increases" title="item-increases">
                        <xsl:for-each select="item-increases/item-increase">
                            <xsl:variable name="res_code" select="@res_code" />
                            <xsl:variable name="type" select="if(child::*[name()='maximum_quantity_units']) then 'maximum_quantity_units' else 'number_of_repeats'" />
                            <properties-fragment id="item-increase-{$type}">
                                <xsl:for-each select="child::*[not(name()='RestrictionText')]">
                                    <property name="{local-name()}" title="{local-name()}" value="{.}" datatype="string"/>
                                </xsl:for-each>
                            </properties-fragment>

                            <xsl:for-each select="RestrictionText">
                                <properties-fragment id="RestrictionText-{$res_code}-{$type}">
                                    <xsl:for-each select="child::*[not(name()='RstrctnPrscrbngTxtRltd')]">
                                        <property name="{local-name()}" title="{local-name()}" value="{.}" datatype="string"/>
                                    </xsl:for-each>
                                </properties-fragment>

                                <xsl:if test="RstrctnPrscrbngTxtRltd">
                                    <xsl:for-each select="RstrctnPrscrbngTxtRltd">
                                        <xsl:variable name="prescribing_text_id" select="@prescribing_text_id" />
                                        <properties-fragment id="res_code-{$res_code}-RstrctnPrscrbngTxtRltd-{$prescribing_text_id}-{$type}">
                                            <xsl:for-each select="@*|PrescribingTxt/child::*[not(name()='Indication' or name()='Criteria' or name()='complex_authority_rqrd_ind')]">
                                                <property name="{local-name()}" title="{local-name()}" value="{.}" datatype="string"/>
                                            </xsl:for-each>
                                        </properties-fragment>
                                        <xsl:if test="PrescribingTxt/Indication">
                                            <xsl:for-each select="PrescribingTxt/Indication">
                                                <properties-fragment id="res_code-{$res_code}-Indication-{$prescribing_text_id}-{$type}">
                                                    <xsl:for-each select="child::*">
                                                        <property name="{local-name()}" title="{local-name()}" value="{.}" datatype="string"/>
                                                    </xsl:for-each>
                                                </properties-fragment>
                                            </xsl:for-each>
                                        </xsl:if>

                                        <xsl:if test="PrescribingTxt/Criteria">
                                            <xsl:for-each select="PrescribingTxt/Criteria">
                                                <xsl:variable name="criteria-id" select="$prescribing_text_id" />
                                                <properties-fragment id="res_code-{$res_code}-Criteria-{$criteria-id}-{$type}">
                                                    <xsl:for-each select="@*|child::*[not(name()='CriteriaParameterRltd')]">
                                                        <property name="{local-name()}" title="{local-name()}" value="{.}" datatype="string"/>
                                                    </xsl:for-each>
                                                </properties-fragment>

                                                <xsl:if test="CriteriaParameterRltd">
                                                    <xsl:for-each select="CriteriaParameterRltd">
                                                        <properties-fragment id="res_code-{$res_code}-CriteriaParameterRltd-{$criteria-id}-Parameter-{@parameter_prescribing_txt_id}-{$type}">
                                                            <xsl:for-each select="@*|PrescribingTxt/child::*[not(name()='complex_authority_rqrd_ind' or fn:name()='assessment_type_code')]">
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

                    <section id="ItemPrescribingTxtRltd" title="ItemPrescribingTxtRltd">
                        <xsl:for-each select="ItemPrescribingTxtRltd">
                            <xsl:variable name="prescribing_txt_id" select="@prescribing_txt_id" />
                            <properties-fragment id="ItemPrescribingTxtRltd-{$prescribing_txt_id}">
                                <property name="prescribing_txt_id" title="prescribing_txt_id" value="{$prescribing_txt_id}" datatype="string"/>
                            </properties-fragment>

                            <xsl:for-each select="PrescribingTxt">
                                <properties-fragment id="PrescribingTxt-{$prescribing_txt_id}">
                                    <xsl:for-each select="child::*">
                                        <property name="{local-name()}" title="{local-name()}" value="{.}" datatype="string"/>
                                    </xsl:for-each>
                                </properties-fragment>
                            </xsl:for-each>
                        </xsl:for-each>
                    </section>
                    <section id="ItemRestrictionRltd" title="ItemRestrictionRltd">
                        <xsl:for-each select="ItemRestrictionRltd">
                            <xsl:variable name="res_code" select="@res_code" />
                            <properties-fragment id="ItemRestrictionRltd-{$res_code}">
                                <xsl:for-each select="@*|child::*[name()='restriction_indicator']">
                                    <property name="{local-name()}" title="{local-name()}" value="{.}" datatype="string"/>
                                </xsl:for-each>
                            </properties-fragment>

                            <xsl:for-each select="RestrictionText">
                                <properties-fragment id="RestrictionText-{$res_code}">
                                    <xsl:for-each select="child::*[not(name()='RstrctnPrscrbngTxtRltd')]">
                                        <property name="{local-name()}" title="{local-name()}" value="{.}" datatype="string"/>
                                    </xsl:for-each>
                                </properties-fragment>

                                <xsl:if test="RstrctnPrscrbngTxtRltd">
                                    <xsl:for-each select="RstrctnPrscrbngTxtRltd">
                                        <xsl:variable name="prescribing_text_id" select="@prescribing_text_id" />
                                        <properties-fragment id="res_code-{$res_code}-RstrctnPrscrbngTxtRltd-{$prescribing_text_id}">
                                            <xsl:for-each select="@*|PrescribingTxt/child::*[not(name()='Indication' or name()='Criteria' or name()='complex_authority_rqrd_ind')]">
                                                <property name="{local-name()}" title="{local-name()}" value="{.}" datatype="string"/>
                                            </xsl:for-each>
                                        </properties-fragment>
                                        <xsl:if test="PrescribingTxt/Indication">
                                            <xsl:for-each select="PrescribingTxt/Indication">
                                                <properties-fragment id="res_code-{$res_code}-Indication-{$prescribing_text_id}">
                                                    <xsl:for-each select="child::*">
                                                        <property name="{local-name()}" title="{local-name()}" value="{.}" datatype="string"/>
                                                    </xsl:for-each>
                                                </properties-fragment>
                                            </xsl:for-each>
                                        </xsl:if>

                                        <xsl:if test="PrescribingTxt/Criteria">
                                            <xsl:for-each select="PrescribingTxt/Criteria">
                                                <xsl:variable name="criteria-id" select="$prescribing_text_id" />
                                                <properties-fragment id="res_code-{$res_code}-Criteria-{$criteria-id}">
                                                    <xsl:for-each select="@*|child::*[not(name()='CriteriaParameterRltd')]">
                                                        <property name="{local-name()}" title="{local-name()}" value="{.}" datatype="string"/>
                                                    </xsl:for-each>
                                                </properties-fragment>

                                                <xsl:if test="CriteriaParameterRltd">
                                                    <xsl:for-each select="CriteriaParameterRltd">
                                                        <properties-fragment id="res_code-{$res_code}-CriteriaParameterRltd-{$criteria-id}-Parameter-{@parameter_prescribing_txt_id}">
                                                            <xsl:for-each select="@*|PrescribingTxt/child::*[not(name()='complex_authority_rqrd_ind' or fn:name()='assessment_type_code')]">
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
