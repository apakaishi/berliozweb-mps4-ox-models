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

    <xsl:param name="folder" />

    <xsl:variable name="base" select="substring-before(replace(base-uri(),'file:', 'file://'), '/part2-items')" />
    <xsl:variable name="output" select="concat($base,'/',$folder,'/master/legalinst/')" />

    <xsl:output method="xml" encoding="UTF-8" indent="yes" omit-xml-declaration="yes" />

    <xsl:variable name="li_drug_name_initial">
        <drugs>
            <xsl:for-each-group select="Schedule/Item" group-by="substring(li_drug_name,1,1)">
                <xsl:sort select="li_drug_name" />
                <xsl:variable name="initial-char" select="substring(li_drug_name,1,1)" />
                <xsl:element name="{$initial-char}">
                    <xsl:for-each-group select="current-group()" group-by="li_drug_name">
                        <xsl:variable name="mp" select="if(AmtItems[concept_type_code='MP']/pbs_concept_id != '') then AmtItems[concept_type_code='MP']/pbs_concept_id else drug_name"/>
                        <li_drug_name>
                            <xsl:attribute name="mp"><xsl:value-of select="$mp" /></xsl:attribute>
                            <xsl:attribute name="mp-initial"><xsl:value-of select="substring($mp,1,1)" /></xsl:attribute>
                            <xsl:attribute name="name"><xsl:value-of select="li_drug_name" /></xsl:attribute>
                            <xsl:for-each-group select="current-group()" group-by="li_form">
                                <xsl:sort select="li_form" />
                                <xsl:variable name="mpuu" select="if(AmtItems[concept_type_code='MPUU']/pbs_concept_id != '') then AmtItems[concept_type_code='MPUU']/pbs_concept_id else li_form"/>
                                <li_form>
                                    <xsl:attribute name="mpuu"><xsl:value-of select="$mpuu" /></xsl:attribute>
                                    <xsl:value-of select="li_form" />
                                </li_form>
                            </xsl:for-each-group>
                        </li_drug_name>
                    </xsl:for-each-group>
                </xsl:element>
            </xsl:for-each-group>
        </drugs>
    </xsl:variable>

    <xsl:template match="Schedule">
        <xsl:copy-of select="$li_drug_name_initial" />
        <xsl:variable name="schedule-code" select="@schedule_code" />
        <xsl:variable name="effectivedate" select="@effective_date" />

        <xsl:variable name="path-version-document" select="concat($output, 'legalinst-version.psml')" />
        <xsl:variable name="path-schedule1-part2-document" select="concat($output, 'li-schedule-1-part2.psml')" />

        <xsl:result-document href="{$path-version-document}">
            <document type="legalinst_master" status="New Listing" level="portable">
                <documentinfo>
                    <uri documenttype="legalinst_master" title="master">
                        <displaytitle>master</displaytitle>
                        <labels>master</labels>
                    </uri>
                </documentinfo>
                <metadata/>
                <section id="title" overwrite="false" edit="false">
                    <fragment id="title">
                        <heading level="1">version</heading>
                    </fragment>
                </section>
                <section id="metadata" title="Metadata" overwrite="true" edit="false">
                    <properties-fragment id="metadata">
                        <property name="effective-date" value="{$effectivedate}"/>
                        <property name="dd-api" value="{$schedule-code}"/>
                    </properties-fragment>
                </section>
                <section id="links" title="Links" overwrite="true" edit="false">
                    <xref-fragment id="links">
                        <blockxref frag="default" reversefrag="links" reversetitle="" reverselink="true" reversetype="none" display="document" type="embed"
                                   href="/ps/mps/legalinst/master/legalinst/li-schedule-1-part2.psml" mediatype="application/vnd.pageseeder.psml+xml">Schedule 1 - Part 2</blockxref>
                    </xref-fragment>
                </section>
            </document>
        </xsl:result-document>

        <xsl:result-document href="{$path-schedule1-part2-document}">
            <document type="legalinst_schedule" status="New Listing" level="portable">
                <documentinfo>
                    <uri documenttype="legalinst_schedule" title="Schedule 1 - Part 2">
                        <displaytitle>Schedule 1 - Part 2</displaytitle>
                        <labels>sch1</labels>
                    </uri>
                </documentinfo>
                <metadata>
                    <properties>
                        <property name="status" value="current"/>
                        <property name="effectiveDate" value="{$effectivedate}"/>
                        <property name="dd-api" value="{$schedule-code}"/>
                        <property name="schedule" value="1"/>
                    </properties>
                </metadata>
                <section id="final" title="Drug List">
                    <xref-fragment id="final">
                        <xsl:for-each select="$li_drug_name_initial/drugs/child::*">
                            <blockxref frag="default" reversefrag="final" reversetitle="" reverselink="true" reversetype="none" display="document" type="embed"
                                       href="{concat('/ps/mps/legalinst/master/legalinst/li-schedule-1-part2/',local-name(),'.psml')}" mediatype="application/vnd.pageseeder.psml+xml"><xsl:value-of select="local-name()"/></blockxref>
                        </xsl:for-each>
                    </xref-fragment>
                </section>
            </document>
        </xsl:result-document>

        <xsl:for-each select="$li_drug_name_initial/drugs/child::*">
            <xsl:variable name="initial-drug-name-path" select="concat($output, 'li-schedule-1-part2/',local-name(),'.psml')" />
            <xsl:result-document href="{$initial-drug-name-path}">
                <document type="legalinst_drug_list" status="New Listing" level="portable">
                    <documentinfo>
                        <uri documenttype="legalinst_drug_list" title="{local-name()}">
                            <displaytitle><xsl:value-of select="local-name()" /></displaytitle>
                            <labels>sch1</labels>
                        </uri>
                    </documentinfo>
                    <metadata>
                        <properties>
                            <property name="effectiveDate" value="{$effectivedate}"/>
                            <property name="ddapi" value="{$schedule-code}"/>
                            <property name="schedule" value="1"/>
                        </properties>
                    </metadata>
                    <section id="final" lockstructure="true" title="Schedule 1 - Part 2 (Current)" edit="true" overwrite="false">
                        <xref-fragment id="final">
                            <xsl:for-each select="child::*" >
                                <blockxref frag="default" reversefrag="final" reversetitle="" reverselink="true" reversetype="none" display="document" type="embed"
                                           href="{concat('/ps/mps/legalinst/master/legalinst/li-schedule-1-part2/',@mp-initial,'/',@mp,'.psml')}"
                                           mediatype="application/vnd.pageseeder.psml+xml"><xsl:value-of select="@name" /></blockxref>
                            </xsl:for-each>
                        </xref-fragment>
                    </section>
                </document>
            </xsl:result-document>

            <xsl:for-each select="li_drug_name">
                <xsl:variable name="drug-name-path" select="concat($output, 'li-schedule-1-part2/',@mp-initial,'/',@mp,'.psml')" />
                <xsl:variable name="mp-initial" select="@mp-initial" />
                <xsl:variable name="mp" select="@mp" />
                <xsl:variable name="content-form">
                    <xsl:for-each select="li_form">
                        <final>
                            <blockxref frag="final" reversefrag="final" reversetitle="" reverselink="true" reversetype="none" display="document" type="embed"
                                       href="{concat('/ps/mps/legalinst/master/legalinst/li-schedule-1-part2/',$mp-initial,'/',$mp,'/',@mpuu,'.psml')}"
                                       mediatype="application/vnd.pageseeder.psml+xml"><xsl:value-of select="." /></blockxref>
                        </final>
                        <draft>
                            <blockxref frag="draft" reversefrag="draft" reversetitle="" reverselink="true" reversetype="none" display="document" type="embed"
                                       href="{concat('/ps/mps/legalinst/master/legalinst/li-schedule-1-part2/',$mp-initial,'/',$mp,'/',@mpuu,'.psml')}"
                                       mediatype="application/vnd.pageseeder.psml+xml"><xsl:value-of select="." /></blockxref>
                        </draft>
                    </xsl:for-each>
                </xsl:variable>
                <xsl:result-document href="{$drug-name-path}">
                    <document type="legalinst_drug" status="New Listing" level="portable">
                        <documentinfo>
                            <uri documenttype="legalinst_drug" title="{@name}">
                                <displaytitle><xsl:value-of select="@name" /></displaytitle>
                                <labels>sch1</labels>
                            </uri>
                        </documentinfo>
                        <metadata>
                            <properties>
                                <property name="effectiveDate" value="{$effectivedate}"/>
                                <property name="ddapi" value="{$schedule-code}"/>
                                <property name="schedule" value="1"/>
                                <property name="drug" value="{.}"/>
                                <property name="mp" value="{@mp}"/>
                            </properties>
                        </metadata>
                        <section id="final" lockstructure="true" title="Schedule 1 - Part 2 (Current)" edit="true" overwrite="false">
                            <xref-fragment id="final">
                                <xsl:copy-of select="$content-form/final/*" />
                            </xref-fragment>
                        </section>
                        <section id="draft" lockstructure="true" title="Schedule 1 - Part 2 (System generated)" edit="false" overwrite="true">
                            <xref-fragment id="draft">
                                <xsl:copy-of select="$content-form/draft/*" />
                            </xref-fragment>
                        </section>
                    </document>
                </xsl:result-document>
            </xsl:for-each>
        </xsl:for-each>

        <xsl:for-each-group select="Item" group-by="drug_name">
            <xsl:variable name="mp" select="if(AmtItems[concept_type_code='MP']/pbs_concept_id != '') then AmtItems[concept_type_code='MP']/pbs_concept_id else drug_name"/>
            <xsl:variable name="li_drug_name" select="li_drug_name" />

            <xsl:for-each-group select="current-group()" group-by="li_form">
                <xsl:sort select="li_form" order="ascending" />
                <xsl:variable name="li_form" select="li_form"/>
                <xsl:variable name="mpp" select="if(AmtItems[concept_type_code='MPP']/pbs_concept_id != '') then AmtItems[concept_type_code='MPP']/pbs_concept_id else schedule_form"/>
                <xsl:variable name="mpuu" select="if(AmtItems[concept_type_code='MPUU']/pbs_concept_id != '') then AmtItems[concept_type_code='MPUU']/pbs_concept_id else $li_form"/>
                <xsl:variable name="startsMPConceptId" select="substring($mp,1,1)"/>

                <xsl:variable name="path" select="concat($output, 'li-schedule-1-part2/',$startsMPConceptId,'/' ,$mp,'/',$mpuu,'.psml')" />
                <xsl:result-document href="{$path}">

                    <document type="legalinst" status="New Listing" level="portable">
                        <documentinfo>
                            <uri documenttype="legalinst" title="{$li_form}">
                                <displaytitle><xsl:value-of select="$li_form" /></displaytitle>
                                <labels>sch1</labels>
                            </uri>
                        </documentinfo>
                        <metadata>
                            <properties>
                                <property name="effectiveDate" value="{$effectivedate}"/>
                                <property name="pbsxml" value="{$schedule-code}"/>
                                <property name="schedule" value="1"/>
                                <property name="drug" value="{$li_drug_name}"/>
                                <property name="mp" value="{$mp}"/>
                                <property name="mpp" value="{$mpp}"/>
                            </properties>
                        </metadata>
                        <xsl:variable name="content">
                            <xsl:for-each-group select="current-group()" group-by="brand_name">
                                <xsl:variable name="brand_name" select="brand_name"/>

                                <xsl:for-each-group select="current-group()" group-by="prescriber_code">
                                    <xsl:variable name="prescriber_code">
                                        <xsl:for-each select="tokenize(prescriber_code,' ')">
                                            <xsl:value-of select="if(position()!= last()) then concat(.,'P ') else concat(.,'P')" />
                                        </xsl:for-each>
                                    </xsl:variable>

                                    <xsl:variable name="restriction">
                                        <xsl:for-each-group select="current-group()/ItemRestrictionRltd/RestrictionText/treatment_of_code" group-by="text()">
                                            <xsl:value-of select="if(position()!= last()) then concat(concat('C',.),' ') else concat('C',.)" />
                                        </xsl:for-each-group>
                                    </xsl:variable>

                                    <row>
                                        <cell role="drug"><xsl:value-of select="$li_drug_name"/></cell>
                                        <cell role="form"><xsl:value-of select="$li_form"/></cell>
                                        <cell role="moa"><xsl:value-of select="manner_of_administration"/></cell>
                                        <cell role="brand"><xsl:value-of select="$brand_name"/></cell>
                                        <cell role="manu"><xsl:value-of select="manufacturer_code"/></cell>
                                        <cell role="prescriber"><xsl:value-of select="$prescriber_code" /></cell>
                                        <cell role="cir"><xsl:value-of select="$restriction"/></cell>
                                        <cell role="pur"/>
                                        <cell role="maxqty"><xsl:value-of select="maximum_quantity_units"/></cell>
                                        <cell role="numrpt"><xsl:value-of select="number_of_repeats"/></cell>
                                        <cell role="packsize"><xsl:value-of select="pack_size"/></cell>
                                        <cell role="detqty"/>
                                        <cell role="s100"/>
                                    </row>
                                </xsl:for-each-group>
                            </xsl:for-each-group>
                        </xsl:variable>

                        <section id="final" lockstructure="true" title="Schedule 1 - Part 2 (Current)" edit="true" overwrite="false">
                            <fragment id="final">
                                <table role="li-schedule-1-part2">
                                    <row part="header">
                                        <cell role="drug">Listed Drug</cell>
                                        <cell role="form">Form</cell>
                                        <cell role="moa">Manner of Administration</cell>
                                        <cell role="brand">Brand</cell>
                                        <cell role="manu">Responsible Person</cell>
                                        <cell role="prescriber">Authorised Prescriber</cell>
                                        <cell role="cir">Circumstances</cell>
                                        <cell role="pur">Purposes</cell>
                                        <cell role="maxqty">Maximum Quantity</cell>
                                        <cell role="numrpt">Number of Repeats</cell>
                                        <cell role="packsize">Pack Quantity</cell>
                                        <cell role="detqty">Determined Quantity</cell>
                                        <cell role="s100">Section 100/ Prescriber Bag only</cell>
                                    </row>
                                    <xsl:copy-of select="$content" />
                                </table>
                            </fragment>
                        </section>
                        <section id="draft" lockstructure="true" title="Schedule 1 - Part 2 (System generated)" edit="false" overwrite="true">
                            <fragment id="draft">
                                <table role="li-schedule-1-part2">
                                    <row part="header">
                                        <cell role="drug">Listed Drug</cell>
                                        <cell role="form">Form</cell>
                                        <cell role="moa">Manner of Administration</cell>
                                        <cell role="brand">Brand</cell>
                                        <cell role="manu">Responsible Person</cell>
                                        <cell role="prescriber">Authorised Prescriber</cell>
                                        <cell role="cir">Circumstances</cell>
                                        <cell role="pur">Purposes</cell>
                                        <cell role="maxqty">Maximum Quantity</cell>
                                        <cell role="numrpt">Number of Repeats</cell>
                                        <cell role="packsize">Pack Quantity</cell>
                                        <cell role="detqty">Determined Quantity</cell>
                                        <cell role="s100">Section 100/ Prescriber Bag only</cell>
                                    </row>
                                    <xsl:copy-of select="$content" />
                                </table>
                            </fragment>
                        </section>
                    </document>
                </xsl:result-document>
            </xsl:for-each-group>
        </xsl:for-each-group>
    </xsl:template>
</xsl:stylesheet>
