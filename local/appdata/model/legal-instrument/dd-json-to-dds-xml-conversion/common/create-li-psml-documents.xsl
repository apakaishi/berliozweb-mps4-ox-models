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
    <xsl:variable name="output" select="concat($base,'/',$folder,'/')" />

    <xsl:output method="xml" encoding="UTF-8" indent="yes" omit-xml-declaration="yes" />

    <xsl:variable name="references">
        <xsl:for-each select="Schedule">
            <xsl:variable name="effective-date" select="@effective_date" />
            <xsl:variable name="schedule_code"  select="@schedule_code" />
            <xsl:for-each-group select="Item" group-by="drug_name">
                <xsl:variable name="mp" select="if(AmtItems[concept_type_code='MP']/pbs_concept_id != '') then AmtItems[concept_type_code='MP']/pbs_concept_id else drug_name"/>
                <xsl:variable name="effective_date" select="@effective_date" />
                <xsl:for-each-group select="current-group()" group-by="li_form">
                    <xsl:sort select="li_form" order="descending" />
                    <blockxref frag="default" reversefrag="content" reversetitle="" reverselink="true" reversetype="none" display="document" type="embed" href="{concat('/ps/mps/li/documents/',$effective-date,'/schedule-',$schedule_code,'/li/li-schedule-1/',$mp,'.psml')}"
                               urititle="{drug_name}" urilabels="Sch1" documenttype="li"><xsl:value-of select="drug_name" /></blockxref>
                </xsl:for-each-group>
            </xsl:for-each-group>
        </xsl:for-each>
    </xsl:variable>

    <xsl:template match="Schedule">
        <xsl:variable name="schedule-code" select="@schedule_code" />
        <xsl:variable name="edition-type"  select="@edition-type" />
        <xsl:variable name="effectivedate" select="@effective_date" />
        <xsl:variable name="sch-path" select="concat($effectivedate,'/schedule-',$schedule-code,'/')" />

        <xsl:variable name="path-document" select="concat($output, $sch-path, 'li/li-schedule-1.psml')" />

        <xsl:result-document href="{$path-document}">
            <document type="li" version="current" level="portable">
                <documentinfo>
                    <uri documenttype="li">
                        <displaytitle>li-schedule-1.psml</displaytitle>
                    </uri>
                </documentinfo>
                <section id="content">
                    <xref-fragment id="content">
                        <xsl:copy-of select="$references" />
                    </xref-fragment>
                </section>
            </document>
        </xsl:result-document>

        <xsl:for-each-group select="Item" group-by="drug_name">
            <xsl:variable name="mp" select="if(AmtItems[concept_type_code='MP']/pbs_concept_id != '') then AmtItems[concept_type_code='MP']/pbs_concept_id else drug_name"/>
            <xsl:variable name="title" select="li_drug_name" />

            <xsl:variable name="program_code" select="@program_code" />
            <xsl:variable name="pbs_code" select="@pbs_code" />
            <xsl:variable name="path" select="concat($output, $sch-path, 'li/li-schedule-1/', $mp,'.psml')" />

            <xsl:result-document href="{$path}">
                <document type="li" version="current" level="portable">
                    <documentinfo>
                        <uri documenttype="li" title="{$title}">
                            <displaytitle><xsl:value-of select="$title" /></displaytitle>
                            <labels>Sch1</labels>
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
                    <section id="{$mp}">
                        <fragment id="{$mp}">
                            <table role="li-schedule-1">
                                <row>
                                    <hcell><para>Drug</para></hcell>
                                    <hcell><para>Form</para></hcell>
                                    <hcell><para>MoA</para></hcell>
                                    <hcell><para>Brand</para></hcell>
                                    <hcell><para>Manufacturer</para></hcell>
                                    <hcell><para>Prescriber</para></hcell>
                                    <hcell><para>Circumstances</para></hcell>
                                    <hcell><para>Purposes</para></hcell>
                                    <hcell><para>MaxQuantity</para></hcell>
                                    <hcell><para>NumberOfRepeats</para></hcell>
                                    <hcell><para>PackSize</para></hcell>
                                    <hcell><para>DetQty</para></hcell>
                                    <hcell><para>S100</para></hcell>
                                </row>
                                <xsl:for-each-group select="current-group()" group-by="li_form">
                                    <xsl:sort select="li_form" order="descending" />
                                    <xsl:variable name="li_form" select="li_form"/>
                                    <xsl:variable name="tpp" select="if(AmtItems[concept_type_code='TPP']/pbs_concept_id != '') then AmtItems[concept_type_code='TPP']/pbs_concept_id else li_form"/>

                                    <xsl:for-each-group select="current-group()" group-by="brand_name">
                                        <xsl:variable name="brand_name" select="brand_name"/>

                                        <!-- <xsl:for-each-group select="current-group()" group-by="@pbs_code">
                                             <xsl:variable name="pbs_code" select="@pbs_code"/>-->

                                        <xsl:for-each-group select="current-group()" group-by="prescriber_code">
                                            <xsl:variable name="prescriber_code" select="prescriber_code"/>

                                            <xsl:variable name="restriction">
                                                <xsl:for-each-group select="current-group()/ItemRestrictionRltd/RestrictionText/treatment_of_code" group-by="text()">
                                                    <xsl:value-of select="if(position()!= last()) then concat(concat('C',.),' ') else concat('C',.)" />
                                                </xsl:for-each-group>
                                            </xsl:variable>

                                            <row role="{$tpp}">
                                                <cell><xsl:value-of select="li_drug_name" /></cell>
                                                <cell><xsl:value-of select="$li_form" /></cell>
                                                <cell><xsl:value-of select="manner_of_administration" /></cell>
                                                <cell><xsl:value-of select="$brand_name" /></cell>
                                                <cell><xsl:value-of select="manufacturer_code" /></cell>
                                                <cell><xsl:value-of select="$prescriber_code" /><inline label="item"><xsl:value-of select="concat($pbs_code,'(',program_code,')')" /></inline></cell>
                                                <cell><xsl:value-of select="$restriction" /></cell>
                                                <cell><xsl:value-of select="''" /></cell>
                                                <cell><xsl:value-of select="maximum_quantity_units" /></cell>
                                                <cell><xsl:value-of select="number_of_repeats" /></cell>
                                                <cell><xsl:value-of select="pack_size" /></cell>
                                                <cell><xsl:value-of select="''" /></cell>
                                                <cell><xsl:value-of select="''" /></cell>
                                            </row>
                                        </xsl:for-each-group>
                                    </xsl:for-each-group>
                                    <!--</xsl:for-each-group>-->
                                </xsl:for-each-group>
                            </table>
                        </fragment>
                    </section>
                </document>
            </xsl:result-document>
        </xsl:for-each-group>
    </xsl:template>
</xsl:stylesheet>
