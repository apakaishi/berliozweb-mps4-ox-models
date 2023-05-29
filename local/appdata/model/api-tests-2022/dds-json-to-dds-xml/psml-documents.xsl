<?xml version="1.0" encoding="utf-8"?>
<!--
  Converter PSML documents with respective elements.

  @author Adriano Akaishi
  @date 26/04/2023
  @copyright Allette Systems Pty Ltd
-->

<xsl:stylesheet
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:xs="http://www.w3.org/2001/XMLSchema"
        xmlns:fn="http://www.w3.org/2005/xpath-functions"
        exclude-result-prefixes="xs fn" version="3.0">

    <xsl:param name="schedule-code" />

    <xsl:output indent="yes" omit-xml-declaration="yes" />

    <xsl:variable name="base" select="replace(replace(base-uri(),'file:', 'file://'), 'data-processed/full-items-document.xml', '')" />

    <xsl:output method="xml" encoding="UTF-8" indent="yes" />

    <xsl:template match="schedules">
        <xsl:variable name="root-folder" select="concat($base,'/final/data/root/')" />

        <!-- Schedule document-->
        <xsl:variable name="sch-path" select="concat($root-folder,'schedule.psml')" />
        <xsl:variable name="sch-title" select="concat(@effective_date,' [',@schedule_code,']')" />
        <xsl:result-document href="{$sch-path}">
            <document type="schedule" version="current" level="portable">
                <documentinfo>
                    <uri documenttype="schedule" title="{$sch-title}">
                        <displaytitle><xsl:value-of select="$sch-title" /></displaytitle>
                    </uri>
                </documentinfo>
                <metadata>
                    <properties>
                        <property name="version" title="version" value="0.1" datatype="string"/>
                        <property name="schedule-code" title="Schedule code" value="{$schedule-code}" datatype="string"/>
                    </properties>
                </metadata>
                <section id="title">
                    <fragment id="title">
                        <heading level="1"><xsl:value-of select="$sch-title" /></heading>
                    </fragment>
                </section>
                <section id="schedules" title="schedules">
                    <properties-fragment id="schedules">
                      <xsl:for-each select="@*[not(name()='start_tsp' or name()='effective_year')]">
                          <property name="{local-name()}" title="{local-name()}" value="{.}" datatype="string"/>
                      </xsl:for-each>
                    </properties-fragment>
                </section>
                <section id="xml" title="PBS XML">
                    <fragment id="1">
                        <preformat role="lang-xml">
                            <xsl:value-of select="concat('&lt;','schedules','&gt;')" /><xsl:text>&#xA;</xsl:text>
                            <xsl:for-each select="@*">
                                <xsl:value-of select="concat('  &lt;',local-name(),'&gt;',.,'&lt;/',local-name(),'&gt;')" /><xsl:text>&#xA;</xsl:text>
                            </xsl:for-each>
                            <xsl:value-of select="concat('&lt;/','schedules','&gt;')" />
                        </preformat>
                    </fragment>
                </section>
            </document>
        </xsl:result-document>


        <xsl:variable name="prescribers-folder" select="concat($root-folder,'prescribers/')" />
        <xsl:for-each-group select="descendant::prescriber" group-by="@prescriber_code">

        <!-- Prescribers-->
            <xsl:variable name="prescriber-code" select="@prescriber_code" />
            <xsl:variable name="prescriber-path" select="concat($prescribers-folder,@prescriber_code,'.psml')" />
            <xsl:variable name="prescriber-title" select="@prescriber_type" />
            <xsl:result-document href="{$prescriber-path}">
                <document type="program" version="current" level="portable">
                    <documentinfo>
                        <uri documenttype="program" title="{$prescriber-title}">
                            <displaytitle><xsl:value-of select="$prescriber-title" /></displaytitle>
                        </uri>
                    </documentinfo>
                    <metadata>
                        <properties>
                            <property name="version" title="version" value="0.1" datatype="string"/>
                            <property name="schedule-code" title="Schedule code" value="{$schedule-code}" datatype="string"/>
                        </properties>
                    </metadata>
                    <section id="title">
                        <fragment id="title">
                            <heading level="1"><xsl:value-of select="$prescriber-title" /></heading>
                        </fragment>
                    </section>
                    <section id="prescriber" title="prescriber">
                        <properties-fragment id="prescriber">
                            <xsl:for-each select="@*[not(name()='pbs_code' or name()='schedule_code')]">
                                <property name="{local-name()}" title="{local-name()}" value="{.}" datatype="string"/>
                            </xsl:for-each>
                        </properties-fragment>
                    </section>
                    <section id="xml" title="PBS XML">
                        <fragment id="1">
                            <preformat role="lang-xml">
                                <xsl:value-of select="concat('&lt;','prescriber','&gt;')" /><xsl:text>&#xA;</xsl:text>
                                <xsl:for-each select="@*[not(name()='pbs_code')]">
                                    <xsl:value-of select="concat('  &lt;',local-name(),'&gt;',.,'&lt;/',local-name(),'&gt;')" /><xsl:text>&#xA;</xsl:text>
                                </xsl:for-each>
                                <xsl:value-of select="concat('&lt;/','prescriber','&gt;')" />
                            </preformat>
                        </fragment>
                    </section>
                </document>
            </xsl:result-document>
        </xsl:for-each-group>

            <xsl:variable name="amt-items-folder" select="concat($root-folder,'amt-items/')" />
            <xsl:for-each-group select="descendant::amt-items" group-by="@pbs_concept_id">

            <!-- drugs list-->

            <xsl:variable name="pbs_concept_id" select="@pbs_concept_id" />
            <xsl:variable name="concept_type_code" select="@concept_type_code" />
            <xsl:variable name="amt_code" select="@amt_code" />

            <xsl:variable name="amt-items-path" select="concat($amt-items-folder,$concept_type_code,'/',@pbs_concept_id,'.psml')" />
            <xsl:variable name="amt-items-title" select="substring(@preferred_term,1,230)" />
            <xsl:result-document href="{$amt-items-path}">
                <document type="amt_items" version="current" level="portable">
                    <documentinfo>
                        <uri documenttype="amt_items" title="{$amt-items-title}">
                            <displaytitle><xsl:value-of select="$amt-items-title" /></displaytitle>
                        </uri>
                    </documentinfo>
                    <metadata>
                        <properties>
                            <property name="version" title="version" value="0.1" datatype="string"/>
                            <property name="schedule-code" title="Schedule code" value="{$schedule-code}" datatype="string"/>
                        </properties>
                    </metadata>
                    <section id="title">
                        <fragment id="title">
                            <heading level="1"><xsl:value-of select="$amt-items-title" /></heading>
                        </fragment>
                    </section>
                    <section id="amt-items" title="amt-items">
                        <properties-fragment id="amt-items">
                            <xsl:for-each select="@*[not(name()='li_item_id')]">
                                <property name="{local-name()}" title="{local-name()}" value="{.}" datatype="string"/>
                            </xsl:for-each>
                        </properties-fragment>
                    </section>
                    <section id="xml" title="PBS XML">
                        <fragment id="1">
                            <preformat role="lang-xml">
                                <xsl:value-of select="concat('&lt;','amt-items','&gt;')" /><xsl:text>&#xA;</xsl:text>
                                <xsl:for-each select="@*[not(name()='li_item_id')]">
                                    <xsl:value-of select="concat('  &lt;',local-name(),'&gt;',.,'&lt;/',local-name(),'&gt;')" /><xsl:text>&#xA;</xsl:text>
                                </xsl:for-each>
                                <xsl:value-of select="concat('&lt;/','amt-items','&gt;')" />
                            </preformat>
                        </fragment>
                    </section>
                </document>
            </xsl:result-document>
        </xsl:for-each-group>


        <xsl:variable name="prescribing-text-folder" select="concat($root-folder,'prescribing-text/')" />
        <xsl:for-each-group select="descendant::prescribing-text" group-by="@prescribing_txt_id">

            <!-- prescribing text-->
            <xsl:variable name="prescribing_txt_id" select="@prescribing_txt_id" />
            <xsl:variable name="prescribing_type" select="@prescribing_type" />

            <xsl:variable name="prescribing-text-path" select="concat($prescribing-text-folder,$prescribing_type,'/',@prescribing_txt_id,'.psml')" />
            <xsl:variable name="prescribing-text-title" select="$prescribing_txt_id" />
            <xsl:result-document href="{$prescribing-text-path}">
                <document type="prescribing_text" version="current" level="portable">
                    <documentinfo>
                        <uri documenttype="prescribing_text" title="{$prescribing-text-title}">
                            <displaytitle><xsl:value-of select="$prescribing-text-title" /></displaytitle>
                        </uri>
                    </documentinfo>
                    <metadata>
                        <properties>
                            <property name="version" title="version" value="0.1" datatype="string"/>
                            <property name="schedule-code" title="Schedule code" value="{$schedule-code}" datatype="string"/>
                        </properties>
                    </metadata>
                    <section id="title">
                        <fragment id="title">
                            <heading level="1"><xsl:value-of select="$prescribing-text-title" /></heading>
                        </fragment>
                    </section>
                    <xsl:if test="child::*">
                        <section id="{child::*/local-name()}" title="{child::*/local-name()}">
                            <properties-fragment id="{child::*/local-name()}">
                                <property name="{child::*/local-name()}" title="{child::*/local-name()}"  multiple="true" datatype="xref">
                                    <xsl:for-each select="child::*">
                                        <xref frag="default"  reversetitle="" reversefrag="documents" reverselink="true" reversetype="none"
                                              display="document" type="none" href="{concat('../prescribing-text/',@prescribing_type,'/', @prescribing_txt_id,'.psml')}"
                                              urititle="{@prescribing_txt_id}" mediatype="text/xml"><xsl:value-of select="@prescribing_txt_id" /></xref>
                                    </xsl:for-each>
                                </property>
                            </properties-fragment>
                        </section>
                    </xsl:if>
                    <section id="prescribing-text" title="prescribing-text">
                        <properties-fragment id="prescribing-text">
                            <xsl:for-each select="@*[not(name()='schedule_code')]">
                                <property name="{local-name()}" title="{local-name()}" value="{.}" datatype="string"/>
                            </xsl:for-each>
                        </properties-fragment>
                    </section>
                    <section id="xml" title="PBS XML">
                        <fragment id="1">
                            <preformat role="lang-xml">
                                <xsl:value-of select="concat('&lt;','prescribing-text','&gt;')" /><xsl:text>&#xA;</xsl:text>
                                <xsl:for-each select="@*[not(name()='schedule_code')]">
                                    <xsl:value-of select="concat('  &lt;',local-name(),'&gt;',.,'&lt;/',local-name(),'&gt;')" /><xsl:text>&#xA;</xsl:text>
                                </xsl:for-each>
                                <xsl:value-of select="concat('&lt;/','prescribing-text','&gt;')" />
                            </preformat>
                        </fragment>
                    </section>
                </document>
            </xsl:result-document>
        </xsl:for-each-group>

        <xsl:variable name="item-increases-folder" select="concat($root-folder,'item-increases/')" />
        <xsl:for-each-group select="descendant::item-increase" group-by="@pbs_code">
            <xsl:variable name="pbs-code" select="@pbs_code" />
            <xsl:for-each-group select="current-group()" group-by="@increase_type">
                <xsl:variable name="increase_type" select="@increase_type" />

                <xsl:variable name="item-increases-path" select="concat($item-increases-folder,$pbs-code,'-',$increase_type,'.psml')" />
                <xsl:variable name="item-increases-title" select="concat($pbs-code,' - ',$increase_type)" />
                <xsl:result-document href="{$item-increases-path}">
                    <document type="item_increases" version="current" level="portable">
                        <documentinfo>
                            <uri documenttype="item_increases" title="{$item-increases-title}">
                                <displaytitle><xsl:value-of select="$item-increases-title" /></displaytitle>
                            </uri>
                        </documentinfo>
                        <metadata>
                            <properties>
                                <property name="version" title="version" value="0.1" datatype="string"/>
                                <property name="schedule-code" title="Schedule code" value="{$schedule-code}" datatype="string"/>
                            </properties>
                        </metadata>
                        <section id="title">
                            <fragment id="title">
                                <heading level="1"><xsl:value-of select="$item-increases-title" /></heading>
                            </fragment>
                        </section>
                        <xsl:if test="@res_code">
                            <section id="restrictions" title="restrictions">
                               <properties-fragment id="restrictions-{@res_code}">
                                    <property name="restrictions" title="restrictions"  multiple="true" datatype="xref">
                                        <xref frag="default"  reversetitle="" reversefrag="documents" reverselink="true" reversetype="none"
                                              display="document" type="none" href="{concat('../restrictions/',@res_code,'.psml')}"
                                              urititle="{@res_code}" mediatype="text/xml"><xsl:value-of select="@res_code" /></xref>
                                    </property>
                                </properties-fragment>
                            </section>
                        </xsl:if>
                        <section id="item-increases" title="item-increases">
                            <properties-fragment id="item-increases">
                                <xsl:for-each select="@*[not(name()='schedule_code')]">
                                    <property name="{local-name()}" title="{local-name()}" value="{.}" datatype="string"/>
                                </xsl:for-each>
                            </properties-fragment>
                        </section>
                        <section id="xml" title="PBS XML">
                            <fragment id="1">
                                <preformat role="lang-xml">
                                    <xsl:value-of select="concat('&lt;','item-increases','&gt;')" /><xsl:text>&#xA;</xsl:text>
                                    <xsl:for-each select="@*[not(name()='schedule_code')]">
                                        <xsl:value-of select="concat('  &lt;',local-name(),'&gt;',.,'&lt;/',local-name(),'&gt;')" /><xsl:text>&#xA;</xsl:text>
                                    </xsl:for-each>
                                    <xsl:value-of select="concat('&lt;/','item-increases','&gt;')" />
                                </preformat>
                            </fragment>
                        </section>
                    </document>
                </xsl:result-document>
            </xsl:for-each-group>
        </xsl:for-each-group>

        <xsl:variable name="restrictions-folder" select="concat($root-folder,'restrictions/')" />
        <xsl:for-each-group select="descendant::restrictions" group-by="@res_code">

            <!-- restrictions-->

            <xsl:variable name="res_code" select="@res_code" />

            <xsl:variable name="restrictions-path" select="concat($restrictions-folder,@res_code,'.psml')" />
            <xsl:variable name="restrictions-title" select="$res_code" />
            <xsl:result-document href="{$restrictions-path}">
                <document type="restrictions" version="current" level="portable">
                    <documentinfo>
                        <uri documenttype="restrictions" title="{$restrictions-title}">
                            <displaytitle><xsl:value-of select="$restrictions-title" /></displaytitle>
                        </uri>
                    </documentinfo>
                    <metadata>
                        <properties>
                            <property name="version" title="version" value="0.1" datatype="string"/>
                            <property name="schedule-code" title="Schedule code" value="{$schedule-code}" datatype="string"/>
                        </properties>
                    </metadata>
                    <section id="title">
                        <fragment id="title">
                            <heading level="1"><xsl:value-of select="$restrictions-title" /></heading>
                        </fragment>
                    </section>
                    <xsl:if test="restrictions-prescribing-text-relationships">
                      <section id="prescribing-text" title="prescribing-text">
                         <xsl:for-each select="restrictions-prescribing-text-relationships/prescribing-text">
                             <properties-fragment id="prescribing-text-{@prescribing_txt_id}">
                                 <property name="pt_position" title="pt_position" value="{parent::restrictions-prescribing-text-relationships/@pt_position}" datatype="string"/>
                                 <property name="prescribing_type" title="prescribing_type" value="{@prescribing_type}" datatype="string"/>
                                 <property name="prescribing-text" title="prescribing-text"  multiple="true" datatype="xref">
                                    <xref frag="default"  reversetitle="" reversefrag="documents" reverselink="true" reversetype="none"
                                         display="document" type="none" href="{concat('../prescribing-text/',@prescribing_type,'/', @prescribing_txt_id,'.psml')}"
                                         urititle="{@prescribing_txt_id}" mediatype="text/xml"><xsl:value-of select="@prescribing_txt_id" /></xref>
                                 </property>
                          </properties-fragment>
                        </xsl:for-each>
                      </section>
                    </xsl:if>
                    <section id="item-restrictions" title="items-restrictions">
                        <properties-fragment id="item-restrictions">
                            <property name="benefit_type_code" title="benefit_type_code" value="{parent::items-restrictions-relationships/@benefit_type_code}" datatype="string"/>
                            <property name="restriction_indicator" title="restriction_indicator" value="{parent::items-restrictions-relationships/@restriction_indicator}" datatype="string"/>
                        </properties-fragment>
                    </section>
                    <section id="restrictions" title="restrictions">
                        <properties-fragment id="restrictions">
                            <xsl:for-each select="@*[not(name()='schedule_code')]">
                                <property name="{local-name()}" title="{local-name()}" value="{.}" datatype="string"/>
                            </xsl:for-each>
                        </properties-fragment>
                    </section>
                    <section id="xml" title="PBS XML">
                        <fragment id="1">
                            <preformat role="lang-xml">
                                <xsl:value-of select="concat('&lt;','restrictions','&gt;')" /><xsl:text>&#xA;</xsl:text>
                                <xsl:for-each select="@*[not(name()='schedule_code')]">
                                    <xsl:value-of select="concat('  &lt;',local-name(),'&gt;',.,'&lt;/',local-name(),'&gt;')" /><xsl:text>&#xA;</xsl:text>
                                </xsl:for-each>
                                <xsl:value-of select="concat('&lt;/','restrictions','&gt;')" />
                            </preformat>
                        </fragment>
                    </section>
                </document>
            </xsl:result-document>
        </xsl:for-each-group>

        <xsl:variable name="program-folder" select="concat($root-folder,'program/')" />

        <xsl:for-each-group select="items" group-by="program_code/text()">

            <!-- Program code-->

            <xsl:variable name="program-code" select="program_code/text()" />
            <xsl:variable name="program-path" select="concat($program-folder,$program-code,'.psml')" />
            <xsl:variable name="program-title" select="$program-code" />

            <xsl:result-document href="{$program-path}">
                <document type="program" version="current" level="portable">
                    <documentinfo>
                        <uri documenttype="program" title="{$program-title}">
                            <displaytitle><xsl:value-of select="$program-title" /></displaytitle>
                        </uri>
                    </documentinfo>
                    <metadata>
                        <properties>
                            <property name="version" title="version" value="0.1" datatype="string"/>
                            <property name="schedule-code" title="Schedule code" value="{$schedule-code}" datatype="string"/>
                        </properties>
                    </metadata>
                    <section id="title">
                        <fragment id="title">
                            <heading level="1"><xsl:value-of select="$program-title" /></heading>
                        </fragment>
                    </section>
                    <section id="programs" title="drugs">
                        <properties-fragment id="programs">
                           <property name="program_code" title="program_code" value="{$program-code}" datatype="string"/>
                        </properties-fragment>
                    </section>
                    <!--
                    <section id="items" title="items">
                        <properties-fragment id="items">
                          <xsl:for-each-group select="current-group()" group-by="li_item_id/text()">
                            <property name="{li_item_id/text()}" title="{concat(li_drug_name/text(),' document')}" datatype="xref">
                                <xref frag="default"  reversetitle="" reversefrag="documents" reverselink="true" reversetype="none"
                                      display="document" type="none" href="{concat($program-code,'/', li_drug_name/text(),'.psml')}"
                                      urititle="{li_drug_name/text()}" mediatype="text/xml"><xsl:value-of select="li_drug_name/text()" /></xref>
                            </property>
                          </xsl:for-each-group>
                        </properties-fragment>
                    </section> -->
                </document>
            </xsl:result-document>

            <xsl:for-each-group select="current-group()" group-by="li_item_id/text()">
                <!-- Items per program code-->

                <xsl:variable name="li_item_id" select="li_item_id/text()" />
                <xsl:variable name="item-title" select="li_drug_name/text()" />
                <xsl:variable name="item-path" select="concat($program-folder,$program-code,'/',$li_item_id,'.psml')" />
                <xsl:result-document href="{$item-path}">
                    <document type="item" version="current" level="portable">
                        <documentinfo>
                            <uri documenttype="item" title="{$item-title}">
                                <displaytitle><xsl:value-of select="$item-title" /></displaytitle>
                            </uri>
                        </documentinfo>
                        <metadata>
                            <properties>
                                <property name="version" title="version" value="0.1" datatype="string"/>
                                <property name="schedule-code" title="Schedule code" value="{$schedule-code}" datatype="string"/>
                            </properties>
                        </metadata>
                        <section id="title">
                            <fragment id="title">
                                <heading level="1"><xsl:value-of select="$item-title" /></heading>
                            </fragment>
                        </section>
                        <section id="amt-items" title="amt-items">
                            <properties-fragment id="amt-items">
                                <property name="amt-items" title="amt items"  multiple="true" datatype="xref">
                                  <xsl:for-each select="amt-items">
                                        <xref frag="default"  reversetitle="" reversefrag="documents" reverselink="true" reversetype="none"
                                              display="document" type="none" href="{concat('../../amt-items/',@concept_type_code,'/', @pbs_concept_id,'.psml')}"
                                              urititle="{@pbs_concept_id}" mediatype="text/xml"><xsl:value-of select="@preferred_term" /></xref>
                                  </xsl:for-each>
                                </property>
                            </properties-fragment>
                        </section>
                        <section id="prescribers" title="prescribers">
                            <properties-fragment id="prescribers">
                                <property name="prescribers" title="Prescribers"  multiple="true" datatype="xref">
                                    <xsl:for-each select="prescribers/prescriber">
                                        <xref frag="default"  reversetitle="" reversefrag="documents" reverselink="true" reversetype="none"
                                              display="document" type="none" href="{concat('../../prescribers/', @prescriber_code,'.psml')}"
                                              urititle="{@prescriber_code}" mediatype="text/xml"><xsl:value-of select="@prescriber_code" /></xref>
                                    </xsl:for-each>
                                </property>
                            </properties-fragment>
                        </section>
                        <section id="prescribing-text" title="prescribing-text">
                            <properties-fragment id="prescribing-text">
                                <xsl:if test="items-prescribing-text-relationships">
                                  <property name="prescribing-text" title="prescribing-text"  multiple="true" datatype="xref">
                                      <xsl:for-each select="items-prescribing-text-relationships/prescribing-text">
                                         <xref frag="default"  reversetitle="" reversefrag="documents" reverselink="true" reversetype="none"
                                              display="document" type="none" href="{concat('../../prescribing-text/',@prescribing_type,'/', @prescribing_txt_id,'.psml')}"
                                              urititle="{@prescribing_txt_id}" mediatype="text/xml"><xsl:value-of select="@prescribing_txt_id" /></xref>
                                      </xsl:for-each>
                                  </property>
                                </xsl:if>
                            </properties-fragment>
                        </section>
                        <section id="restrictions" title="restrictions">
                            <properties-fragment id="restrictions">
                                <xsl:if test="items-restrictions-relationships">
                                  <property name="restrictions" title="restrictions"  multiple="true" datatype="xref">
                                      <xsl:for-each select="items-restrictions-relationships/restrictions">
                                          <xref frag="default"  reversetitle="" reversefrag="documents" reverselink="true" reversetype="none"
                                                display="document" type="none" href="{concat('../../restrictions/', @res_code,'.psml')}"
                                                urititle="{@res_code}" mediatype="text/xml"><xsl:value-of select="@res_code" /></xref>
                                      </xsl:for-each>
                                  </property>
                                </xsl:if>
                            </properties-fragment>
                        </section>
                        <section id="item-increases" title="item-increases">
                            <properties-fragment id="item-increases">
                                <xsl:if test="item-increases/item-increase">
                                    <property name="item-increases" title="item-increases"  multiple="true" datatype="xref">
                                        <xsl:for-each select="item-increases/item-increase">
                                            <xref frag="default"  reversetitle="" reversefrag="documents" reverselink="true" reversetype="none"
                                                  display="document" type="none" href="{concat('../../item-increases/', @pbs_code,'-',@increase_type,'.psml')}"
                                                  urititle="{concat(@pbs_code,' - ',@increase_type)}" mediatype="text/xml"><xsl:value-of select="concat(@pbs_code,' - ',@increase_type)" /></xref>
                                        </xsl:for-each>
                                    </property>
                                </xsl:if>
                            </properties-fragment>
                        </section>
                        <section id="items" title="items">
                            <properties-fragment id="items">
                                <xsl:for-each select="child::*[not(name()='amt-items' or name()='prescribers' or name()='items-prescribing-text-relationships' or name()='items-restrictions-relationships')]">
                                    <property name="{local-name()}" title="{local-name()}" value="{.}" datatype="string"/>
                                </xsl:for-each>
                            </properties-fragment>
                        </section>
                        <section id="xml" title="PBS XML">
                            <fragment id="1">
                                <preformat role="lang-xml">
                                    <xsl:value-of select="concat('&lt;','items','&gt;')" /><xsl:text>&#xA;</xsl:text>
                                    <xsl:for-each select="child::*[not(name()='amt-items' or name()='prescribers' or name()='items-prescribing-text-relationships' or name()='items-restrictions-relationships')]">
                                        <xsl:value-of select="concat('  &lt;',local-name(),'&gt;',.,'&lt;/',local-name(),'&gt;')" /><xsl:text>&#xA;</xsl:text>
                                    </xsl:for-each>
                                    <xsl:value-of select="concat('&lt;/','items','&gt;')" />
                                </preformat>
                            </fragment>
                        </section>
                    </document>
                </xsl:result-document>
            </xsl:for-each-group>
        </xsl:for-each-group>

    </xsl:template>

    <xsl:template match="text()" />

</xsl:stylesheet>
