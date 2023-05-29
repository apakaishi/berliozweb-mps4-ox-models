<?xml version="1.0" encoding="utf-8"?>
<!--
  This is a counting of elements - General and by Program-Code

  @author Adriano Akaishi
  @date 14/09/2022
  @copyright Allette Systems Pty Ltd
-->

<xsl:stylesheet
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:xs="http://www.w3.org/2001/XMLSchema"
        xmlns:as="https://allette.com.au"
        xmlns:fn="http://www.w3.org/2005/xpath-functions"
        exclude-result-prefixes="xs as fn" version="2.0">

    <xsl:param name="schedule-code" />
    <xsl:param name="folder" />
    <xsl:param name="edition-type" />

    <xsl:variable name="base" select="replace(replace(base-uri(),'file:', 'file://'), 'data-processed/full-items-document.xml', '')" />
    <xsl:variable name="output" select="concat($base,$folder,'/')" />
    <xsl:variable name="sch-path" select="concat($output,'Schedule-',$schedule-code,'/')" />
    <xsl:variable name="edition-path" select="concat($sch-path,'Edition-',$edition-type,'/')" />

    <xsl:output method="xml" encoding="UTF-8" indent="yes" omit-xml-declaration="yes" />

    <xsl:template match="Schedule">

        <xsl:variable name="data-count">
            <Schedule>
                <xsl:attribute name="Item"><xsl:value-of select="count(Item)" /></xsl:attribute>
                <xsl:attribute name="RestrictionText-unique"><xsl:value-of select="count(distinct-values(Item/ItemRestrictionRltd/RestrictionText))" /></xsl:attribute>
                <xsl:attribute name="RestrictionText-ref"><xsl:value-of select="count(Item/ItemRestrictionRltd/RestrictionText)" /></xsl:attribute>
                <xsl:attribute name="PrescribingTxt-unique"><xsl:value-of select="count(distinct-values(Item/descendant::PrescribingTxt))" /></xsl:attribute>
                <xsl:attribute name="PrescribingTxt-ref"><xsl:value-of select="count(Item/descendant::PrescribingTxt)" /></xsl:attribute>
                <xsl:attribute name="Indication-unique"><xsl:value-of select="count(distinct-values(Item/descendant::Indication))" /></xsl:attribute>
                <xsl:attribute name="Indication-ref"><xsl:value-of select="count(Item/descendant::Indication)" /></xsl:attribute>
                <xsl:attribute name="Criteria-unique"><xsl:value-of select="count(distinct-values(Item/descendant::Criteria))" /></xsl:attribute>
                <xsl:attribute name="Criteria-ref"><xsl:value-of select="count(Item/descendant::Criteria)" /></xsl:attribute>
                <xsl:attribute name="ItemRestrictionRltd-unique"><xsl:value-of select="count(distinct-values(Item/descendant::ItemRestrictionRltd))" /></xsl:attribute>
                <xsl:attribute name="ItemRestrictionRltd-ref"><xsl:value-of select="count(Item/descendant::ItemRestrictionRltd)" /></xsl:attribute>
                <xsl:attribute name="ItemPrescribingTxtRltd-unique"><xsl:value-of select="count(distinct-values(Item/descendant::ItemPrescribingTxtRltd))" /></xsl:attribute>
                <xsl:attribute name="ItemPrescribingTxtRltd-ref"><xsl:value-of select="count(Item/descendant::ItemPrescribingTxtRltd)" /></xsl:attribute>
                <xsl:attribute name="RstrctnPrscrbngTxtRltd-unique"><xsl:value-of select="count(distinct-values(Item/descendant::RstrctnPrscrbngTxtRltd))" /></xsl:attribute>
                <xsl:attribute name="RstrctnPrscrbngTxtRltd-ref"><xsl:value-of select="count(Item/descendant::RstrctnPrscrbngTxtRltd)" /></xsl:attribute>
                <xsl:attribute name="CriteriaParameterRltd-unique"><xsl:value-of select="count(distinct-values(Item/descendant::CriteriaParameterRltd))" /></xsl:attribute>
                <xsl:attribute name="CriteriaParameterRltd-ref"><xsl:value-of select="count(Item/descendant::CriteriaParameterRltd)" /></xsl:attribute>
                <RestrictionText>
                    <xsl:attribute name="as:Caution-unique"><xsl:value-of select="count(distinct-values(Item/ItemRestrictionRltd/RestrictionText[caution_indicator/text() = 'Y']))" /></xsl:attribute>
                    <xsl:attribute name="as:Caution-ref"><xsl:value-of select="count(Item/ItemRestrictionRltd/RestrictionText[caution_indicator/text() = 'Y'])" /></xsl:attribute>
                    <xsl:attribute name="as:Note-unique"><xsl:value-of select="count(distinct-values(Item/ItemRestrictionRltd/RestrictionText[note_indicator/text() = 'Y']))" /></xsl:attribute>
                    <xsl:attribute name="as:Note-ref"><xsl:value-of select="count(Item/ItemRestrictionRltd/RestrictionText[note_indicator/text() = 'Y'])" /></xsl:attribute>
                    <xsl:attribute name="as:Restriction-unique"><xsl:value-of select="count(distinct-values(Item/ItemRestrictionRltd/RestrictionText[caution_indicator/text() = 'N' and note_indicator/text() = 'N']))" /></xsl:attribute>
                    <xsl:attribute name="as:Restriction-ref"><xsl:value-of select="count(Item/ItemRestrictionRltd/RestrictionText[caution_indicator/text() = 'N' and note_indicator/text() = 'N'])" /></xsl:attribute>
                </RestrictionText>
                <PrescribingTxt>
                    <xsl:attribute name="PRESCRIBING_TYPE-ADMINISTRATIVE_ADVICE-unique"><xsl:value-of select="count(distinct-values(Item/descendant::PrescribingTxt[prescribing_type/text()='ADMINISTRATIVE_ADVICE']))" /></xsl:attribute>
                    <xsl:attribute name="PRESCRIBING_TYPE-ADMINISTRATIVE_ADVICE-ref"><xsl:value-of select="count(Item/descendant::PrescribingTxt[prescribing_type/text()='ADMINISTRATIVE_ADVICE'])" /></xsl:attribute>
                    <xsl:attribute name="PRESCRIBING_TYPE-PRESCRIBING_INSTRUCTIONS-unique"><xsl:value-of select="count(distinct-values(Item/descendant::PrescribingTxt[prescribing_type/text()='PRESCRIBING_INSTRUCTIONS']))" /></xsl:attribute>
                    <xsl:attribute name="PRESCRIBING_TYPE-PRESCRIBING_INSTRUCTIONS-ref"><xsl:value-of select="count(Item/descendant::PrescribingTxt[prescribing_type/text()='PRESCRIBING_INSTRUCTIONS'])" /></xsl:attribute>
                    <xsl:attribute name="PRESCRIBING_TYPE-PARAMETER-unique"><xsl:value-of select="count(distinct-values(Item/descendant::PrescribingTxt[prescribing_type/text()='PARAMETER']))" /></xsl:attribute>
                    <xsl:attribute name="PRESCRIBING_TYPE-PARAMETER-ref"><xsl:value-of select="count(Item/descendant::PrescribingTxt[prescribing_type/text()='PARAMETER'])" /></xsl:attribute>
                    <xsl:attribute name="PRESCRIBING_TYPE-CRITERIA-unique"><xsl:value-of select="count(distinct-values(Item/descendant::PrescribingTxt[prescribing_type/text()='CRITERIA']))" /></xsl:attribute>
                    <xsl:attribute name="PRESCRIBING_TYPE-CRITERIA-ref"><xsl:value-of select="count(Item/descendant::PrescribingTxt[prescribing_type/text()='CRITERIA'])" /></xsl:attribute>
                    <xsl:attribute name="PRESCRIBING_TYPE-LEGACY_SCHEDULE_TEXT-unique"><xsl:value-of select="count(distinct-values(Item/descendant::PrescribingTxt[prescribing_type/text()='LEGACY_SCHEDULE_TEXT']))" /></xsl:attribute>
                    <xsl:attribute name="PRESCRIBING_TYPE-LEGACY_SCHEDULE_TEXT-ref"><xsl:value-of select="count(Item/descendant::PrescribingTxt[prescribing_type/text()='LEGACY_SCHEDULE_TEXT'])" /></xsl:attribute>
                    <xsl:attribute name="PRESCRIBING_TYPE-LEGACY_LI_TEXT-unique"><xsl:value-of select="count(distinct-values(Item/descendant::PrescribingTxt[prescribing_type/text()='LEGACY_LI_TEXT']))" /></xsl:attribute>
                    <xsl:attribute name="PRESCRIBING_TYPE-LEGACY_LI_TEXT-ref"><xsl:value-of select="count(Item/descendant::PrescribingTxt[prescribing_type/text()='LEGACY_LI_TEXT'])" /></xsl:attribute>
                    <xsl:attribute name="PRESCRIBING_TYPE-CAUTION-unique"><xsl:value-of select="count(distinct-values(Item/descendant::PrescribingTxt[prescribing_type/text()='CAUTION']))" /></xsl:attribute>
                    <xsl:attribute name="PRESCRIBING_TYPE-CAUTION-ref"><xsl:value-of select="count(Item/descendant::PrescribingTxt[prescribing_type/text()='CAUTION'])" /></xsl:attribute>
                    <xsl:attribute name="PRESCRIBING_TYPE-INDICATION-unique"><xsl:value-of select="count(distinct-values(Item/descendant::PrescribingTxt[prescribing_type/text()='INDICATION']))" /></xsl:attribute>
                    <xsl:attribute name="PRESCRIBING_TYPE-INDICATION-ref"><xsl:value-of select="count(Item/descendant::PrescribingTxt[prescribing_type/text()='INDICATION'])" /></xsl:attribute>
                    <xsl:attribute name="PRESCRIBING_TYPE-FOREWORD-unique"><xsl:value-of select="count(distinct-values(Item/descendant::PrescribingTxt[prescribing_type/text()='FOREWORD']))" /></xsl:attribute>
                    <xsl:attribute name="PRESCRIBING_TYPE-FOREWORD-ref"><xsl:value-of select="count(Item/descendant::PrescribingTxt[prescribing_type/text()='FOREWORD'])" /></xsl:attribute>
                </PrescribingTxt>
                <xsl:for-each-group select="Item" group-by="@program_code">
                    <xsl:sort select="@program_code" />
                    <xsl:variable name="program_code" select="@program_code" />
                    <Program>
                        <xsl:attribute name="program_code"><xsl:value-of select="$program_code" /></xsl:attribute>
                        <xsl:attribute name="Item"><xsl:value-of select="count(current-group())" /></xsl:attribute>
                        <xsl:attribute name="Item-unique"><xsl:value-of select="count(distinct-values(current-group()))" /></xsl:attribute>
                        <xsl:attribute name="RestrictionText-unique"><xsl:value-of select="count(distinct-values(current-group()/ItemRestrictionRltd/RestrictionText))" /></xsl:attribute>
                        <xsl:attribute name="RestrictionText-ref"><xsl:value-of select="count(current-group()/ItemRestrictionRltd/RestrictionText)" /></xsl:attribute>
                        <xsl:attribute name="PrescribingTxt-unique"><xsl:value-of select="count(distinct-values(current-group()/descendant::PrescribingTxt))" /></xsl:attribute>
                        <xsl:attribute name="PrescribingTxt-ref"><xsl:value-of select="count(current-group()/descendant::PrescribingTxt)" /></xsl:attribute>
                        <xsl:attribute name="Indication-unique"><xsl:value-of select="count(distinct-values(current-group()/descendant::Indication))" /></xsl:attribute>
                        <xsl:attribute name="Indication-ref"><xsl:value-of select="count(current-group()/descendant::Indication)" /></xsl:attribute>
                        <xsl:attribute name="Criteria-unique"><xsl:value-of select="count(distinct-values(current-group()/descendant::Criteria))" /></xsl:attribute>
                        <xsl:attribute name="Criteria-ref"><xsl:value-of select="count(current-group()/descendant::Criteria)" /></xsl:attribute>
                        <xsl:attribute name="ItemRestrictionRltd-unique"><xsl:value-of select="count(distinct-values(current-group()/descendant::ItemRestrictionRltd))" /></xsl:attribute>
                        <xsl:attribute name="ItemRestrictionRltd-ref"><xsl:value-of select="count(current-group()/descendant::ItemRestrictionRltd)" /></xsl:attribute>
                        <xsl:attribute name="ItemPrescribingTxtRltd-unique"><xsl:value-of select="count(distinct-values(current-group()/descendant::ItemPrescribingTxtRltd))" /></xsl:attribute>
                        <xsl:attribute name="ItemPrescribingTxtRltd-ref"><xsl:value-of select="count(current-group()/descendant::ItemPrescribingTxtRltd)" /></xsl:attribute>
                        <xsl:attribute name="RstrctnPrscrbngTxtRltd-unique"><xsl:value-of select="count(distinct-values(current-group()/descendant::RstrctnPrscrbngTxtRltd))" /></xsl:attribute>
                        <xsl:attribute name="RstrctnPrscrbngTxtRltd-ref"><xsl:value-of select="count(current-group()/descendant::RstrctnPrscrbngTxtRltd)" /></xsl:attribute>
                        <xsl:attribute name="CriteriaParameterRltd-unique"><xsl:value-of select="count(distinct-values(current-group()/descendant::CriteriaParameterRltd))" /></xsl:attribute>
                        <xsl:attribute name="CriteriaParameterRltd-ref"><xsl:value-of select="count(current-group()/descendant::CriteriaParameterRltd)" /></xsl:attribute>
                        <RestrictionText>
                            <xsl:attribute name="as:CAUTION-unique"><xsl:value-of select="count(distinct-values(current-group()/ItemRestrictionRltd/RestrictionText[caution_indicator/text() = 'Y']))" /></xsl:attribute>
                            <xsl:attribute name="as:CAUTION-ref"><xsl:value-of select="count(current-group()/ItemRestrictionRltd/RestrictionText[caution_indicator/text() = 'Y'])" /></xsl:attribute>
                            <xsl:attribute name="as:NOTE-unique"><xsl:value-of select="count(distinct-values(current-group()/ItemRestrictionRltd/RestrictionText[note_indicator/text() = 'Y']))" /></xsl:attribute>
                            <xsl:attribute name="as:NOTE-ref"><xsl:value-of select="count(current-group()/ItemRestrictionRltd/RestrictionText[note_indicator/text() = 'Y'])" /></xsl:attribute>
                            <xsl:attribute name="as:RESTRICTION-unique"><xsl:value-of select="count(distinct-values(current-group()/ItemRestrictionRltd/RestrictionText[caution_indicator/text() = 'N' and note_indicator/text() = 'N']))" /></xsl:attribute>
                            <xsl:attribute name="as:RESTRICTION-ref"><xsl:value-of select="count(current-group()/ItemRestrictionRltd/RestrictionText[caution_indicator/text() = 'N' and note_indicator/text() = 'N'])" /></xsl:attribute>
                        </RestrictionText>
                        <PrescribingTxt>
                            <xsl:attribute name="PRESCRIBING_TYPE-ADMINISTRATIVE_ADVICE-unique"><xsl:value-of select="count(distinct-values(current-group()/descendant::PrescribingTxt[prescribing_type/text()='ADMINISTRATIVE_ADVICE']))" /></xsl:attribute>
                            <xsl:attribute name="PRESCRIBING_TYPE-ADMINISTRATIVE_ADVICE-ref"><xsl:value-of select="count(current-group()/descendant::PrescribingTxt[prescribing_type/text()='ADMINISTRATIVE_ADVICE'])" /></xsl:attribute>
                            <xsl:attribute name="PRESCRIBING_TYPE-PRESCRIBING_INSTRUCTIONS-unique"><xsl:value-of select="count(distinct-values(current-group()/descendant::PrescribingTxt[prescribing_type/text()='PRESCRIBING_INSTRUCTIONS']))" /></xsl:attribute>
                            <xsl:attribute name="PRESCRIBING_TYPE-PRESCRIBING_INSTRUCTIONS-ref"><xsl:value-of select="count(current-group()/descendant::PrescribingTxt[prescribing_type/text()='PRESCRIBING_INSTRUCTIONS'])" /></xsl:attribute>
                            <xsl:attribute name="PRESCRIBING_TYPE-PARAMETER-unique"><xsl:value-of select="count(distinct-values(current-group()/descendant::PrescribingTxt[prescribing_type/text()='PARAMETER']))" /></xsl:attribute>
                            <xsl:attribute name="PRESCRIBING_TYPE-PARAMETER-ref"><xsl:value-of select="count(current-group()/descendant::PrescribingTxt[prescribing_type/text()='PARAMETER'])" /></xsl:attribute>
                            <xsl:attribute name="PRESCRIBING_TYPE-CRITERIA-unique"><xsl:value-of select="count(distinct-values(current-group()/descendant::PrescribingTxt[prescribing_type/text()='CRITERIA']))" /></xsl:attribute>
                            <xsl:attribute name="PRESCRIBING_TYPE-CRITERIA-ref"><xsl:value-of select="count(current-group()/descendant::PrescribingTxt[prescribing_type/text()='CRITERIA'])" /></xsl:attribute>
                            <xsl:attribute name="PRESCRIBING_TYPE-LEGACY_SCHEDULE_TEXT-unique"><xsl:value-of select="count(distinct-values(current-group()/descendant::PrescribingTxt[prescribing_type/text()='LEGACY_SCHEDULE_TEXT']))" /></xsl:attribute>
                            <xsl:attribute name="PRESCRIBING_TYPE-LEGACY_SCHEDULE_TEXT-ref"><xsl:value-of select="count(current-group()/descendant::PrescribingTxt[prescribing_type/text()='LEGACY_SCHEDULE_TEXT'])" /></xsl:attribute>
                            <xsl:attribute name="PRESCRIBING_TYPE-LEGACY_LI_TEXT-unique"><xsl:value-of select="count(distinct-values(current-group()/descendant::PrescribingTxt[prescribing_type/text()='LEGACY_LI_TEXT']))" /></xsl:attribute>
                            <xsl:attribute name="PRESCRIBING_TYPE-LEGACY_LI_TEXT-ref"><xsl:value-of select="count(current-group()/descendant::PrescribingTxt[prescribing_type/text()='LEGACY_LI_TEXT'])" /></xsl:attribute>
                            <xsl:attribute name="PRESCRIBING_TYPE-CAUTION-unique"><xsl:value-of select="count(distinct-values(current-group()/descendant::PrescribingTxt[prescribing_type/text()='CAUTION']))" /></xsl:attribute>
                            <xsl:attribute name="PRESCRIBING_TYPE-CAUTION-ref"><xsl:value-of select="count(current-group()/descendant::PrescribingTxt[prescribing_type/text()='CAUTION'])" /></xsl:attribute>
                            <xsl:attribute name="PRESCRIBING_TYPE-INDICATION-unique"><xsl:value-of select="count(distinct-values(current-group()/descendant::PrescribingTxt[prescribing_type/text()='INDICATION']))" /></xsl:attribute>
                            <xsl:attribute name="PRESCRIBING_TYPE-INDICATION-ref"><xsl:value-of select="count(current-group()/descendant::PrescribingTxt[prescribing_type/text()='INDICATION'])" /></xsl:attribute>
                            <xsl:attribute name="PRESCRIBING_TYPE-FOREWORD-unique"><xsl:value-of select="count(distinct-values(current-group()/descendant::PrescribingTxt[prescribing_type/text()='FOREWORD']))" /></xsl:attribute>
                            <xsl:attribute name="PRESCRIBING_TYPE-FOREWORD-ref"><xsl:value-of select="count(current-group()/descendant::PrescribingTxt[prescribing_type/text()='FOREWORD'])" /></xsl:attribute>
                        </PrescribingTxt>
                    </Program>
                </xsl:for-each-group>
            </Schedule>
        </xsl:variable>

        <xsl:for-each select="$data-count/Schedule">
            <xsl:variable name="schedule-path" select="concat($sch-path,'index.psml')" />
            <xsl:variable name="schedule-title" select="concat('Schedule: ', $schedule-code)" />
            <xsl:result-document href="{$schedule-path}" method="xml">
                <document type="analysis" version="current" level="portable">
                    <documentinfo>
                        <uri documenttype="analysis" title="{$schedule-title}">
                            <displaytitle><xsl:value-of select="$schedule-title" /></displaytitle>
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
                            <heading level="1"><xsl:value-of select="$schedule-title" /></heading>
                        </fragment>
                    </section>
                    <section id="schedule-analysis" title="Schedule">
                        <properties-fragment id="schedule-analysis">
                            <xsl:for-each select="@*">
                                <xsl:variable name="title" select="translate(local-name(),'-',' ')" />
                                <property name="{local-name()}" title="{$title}" value="{.}" datatype="string"/>
                            </xsl:for-each>
                        </properties-fragment>
                    </section>
                    <section id="restriction-text-analysis" title="Restriction Text">
                        <properties-fragment id="restriction-text-analysis">
                            <xsl:for-each select="RestrictionText/@*">
                                <xsl:variable name="title" select="translate(local-name(),'-',' ')" />
                                <property name="{local-name()}" title="{$title}" value="{.}" datatype="string"/>
                            </xsl:for-each>
                        </properties-fragment>
                    </section>
                    <section id="prescribing-text-analysis" title="Prescribing Text">
                        <properties-fragment id="prescribing-text-analysis">
                            <xsl:for-each select="PrescribingTxt/@*">
                                <xsl:variable name="title" select="translate(local-name(),'-',' ')" />
                                <property name="{local-name()}" title="{$title}" value="{.}" datatype="string"/>
                            </xsl:for-each>
                        </properties-fragment>
                    </section>
                </document>
            </xsl:result-document>


            <xsl:for-each select="Program">
                <xsl:variable name="program-path" select="concat($edition-path,@program_code,'/index.psml')" />
                <xsl:variable name="program-title" select="concat('Program code: ',@program_code)" />
                <xsl:result-document href="{$program-path}" method="xml">
                    <document type="analysis" version="current" level="portable">
                        <documentinfo>
                            <uri documenttype="analysis" title="{$program-title}">
                                <displaytitle><xsl:value-of select="$program-title" /></displaytitle>
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
                                <heading level="1"><xsl:value-of select="$program-title" /></heading>
                            </fragment>
                        </section>
                        <section id="program-analysis" title="Program">
                            <properties-fragment id="program-analysis">
                                <xsl:for-each select="@*">
                                    <xsl:variable name="title" select="translate(local-name(),'-',' ')" />
                                    <property name="{local-name()}" title="{$title}" value="{.}" datatype="string"/>
                                </xsl:for-each>
                            </properties-fragment>
                        </section>
                        <section id="restriction-text-analysis" title="Restriction Text">
                            <properties-fragment id="restriction-text-analysis">
                                <xsl:for-each select="RestrictionText/@*">
                                    <xsl:variable name="title" select="translate(local-name(),'-',' ')" />
                                    <property name="{local-name()}" title="{$title}" value="{.}" datatype="string"/>
                                </xsl:for-each>
                            </properties-fragment>
                        </section>
                        <section id="prescribing-text-analysis" title="Prescribing Text">
                            <properties-fragment id="prescribing-text-analysis">
                                <xsl:for-each select="PrescribingTxt/@*">
                                    <xsl:variable name="title" select="translate(local-name(),'-',' ')" />
                                    <property name="{local-name()}" title="{$title}" value="{.}" datatype="string"/>
                                </xsl:for-each>
                            </properties-fragment>
                        </section>
                    </document>
                </xsl:result-document>
            </xsl:for-each>
        </xsl:for-each>

    </xsl:template>

</xsl:stylesheet>
