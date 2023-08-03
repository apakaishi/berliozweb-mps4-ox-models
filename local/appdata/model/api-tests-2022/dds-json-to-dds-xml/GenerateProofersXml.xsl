<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
                exclude-result-prefixes="xs xd" version="2.0">

    <!-- GenerateProofersXml.xslt
        
        Input: DDS-XML document
        Output: XML document with 4 forms of the restrictions for each item, to help proofreaders.
                It has various levels of headings. It retains some fields, to help with searches. 
        
        Form 1: The LI text of the RestrictionText element
        Form 2: The Schedule text of the RestrictionText element
        Form 3: The text taken from the top-level PrescribingText of each restriction, with AND or OR interposed
        Form 4: The text taken from the lowest level Prescribing texts, using lists and "or" and "and" for the low-level,
           and AND and OR at the top-level. 
           
      -->
    <xsl:param name="edition-type" />

    <xsl:output method="xml" encoding="UTF-8" indent="yes" />

    <xsl:template match="Schedule">
        <proof-text>
            <xsl:if test="Item/@program_code or Item/program_code">
                <xsl:attribute name="programCode" select="(Item/@program_code | Item/program_code)[1]"/>
            </xsl:if>
            <xsl:if test="@schedule_code or schedule_code">
                <xsl:attribute name="scheduleCode" select="(@schedule_code | schedule_code)[1]"/>
            </xsl:if>
            <xsl:attribute name="edition" select="$edition-type"/>
            <xsl:apply-templates/>
        </proof-text>
    </xsl:template>

    <xsl:template match="RestrictionTxt | RestrictionText">
        
        <xsl:variable name="sortedRestriction" as="element()">
            <xsl:apply-templates select="."   mode="sort-restriction" /> 
        </xsl:variable>
        
        <xsl:copy select="$sortedRestriction"> 
            <xsl:sequence select="@*"/>
            <div>
                <H1>
                    <xsl:value-of select="
                            concat(
                            if (note_indicator = 'Y') then
                                'Note '
                            else
                                if (caution_indicator = 'Y') then
                                    'Caution '
                                else
                                    'Restriction ',
                            restriction_number)"/>
                </H1>
                <P>Treatment Phase: <xsl:value-of select="treatment_phase"/></P>

                <P>Authority Method: <xsl:value-of select="authority_method"/></P>

                <P>Treatment-Of Code: <xsl:value-of select="treatment_of_code"/></P>
            </div>
            <div>
                <H2>LI HTML TEXT</H2>
                <block label="LI">
                    <HTML_TEXT>
                        <xsl:variable name="content">
                            <xsl:value-of disable-output-escaping="yes" select="li_html_text"/>
                        </xsl:variable>
                        <xsl:analyze-string select="$content" regex="([&lt;])([ 1-9])">
                            <xsl:matching-substring>
                                <xsl:value-of select="concat(translate(regex-group(1),'&lt;','&lt;'),regex-group(2))"/>
                            </xsl:matching-substring>
                            <xsl:non-matching-substring>
                                <xsl:value-of disable-output-escaping="yes" select="."/>
                            </xsl:non-matching-substring>
                        </xsl:analyze-string>
                    </HTML_TEXT>
                </block>
            </div>
            <div>
                <H2>SCHEDULE HTML TEXT</H2>
                <block label="SCHEDULE">
                    <HTML_TEXT>
                        <xsl:variable name="content">
                            <xsl:value-of disable-output-escaping="yes" select="schedule_html_text"/>
                        </xsl:variable>
                        <xsl:analyze-string select="$content" regex="([&lt;])([ 1-9])">
                            <xsl:matching-substring>
                                <xsl:value-of select="concat(translate(regex-group(1),'&lt;','&lt;'),regex-group(2))"/>
                            </xsl:matching-substring>
                            <xsl:non-matching-substring>
                                <xsl:value-of disable-output-escaping="yes" select="."/>
                            </xsl:non-matching-substring>
                        </xsl:analyze-string>
                    </HTML_TEXT>
                </block>
            </div>
            <div>
                <H2>CONSTRUCTED FROM CRITERIA</H2>
                <HTML_TEXT>

                    <P>
                        <xsl:value-of select="treatment_phase"/>
                    </P>

                    <xsl:for-each select="RstrctnPrscrbngTxtRltd">

                        <xsl:sort select="@pt_position"  data-type="number"/>
                        <xsl:for-each select="PrescribingTxt[not(prescribing_type = 'PARAMETER')]">

                            <block label="{prescribing_type}">
                                <xsl:variable name="is-criteria-but-not-last-criteria" select="
                                        prescribing_type = 'CRITERIA' and
                                        ../following-sibling::*[1][self::RstrctnPrscrbngTxtRltd]/PrescribingTxt[1]/prescribing_type = 'CRITERIA'"/>
                                <P>
                                    <xsl:value-of select="prescribing_txt"/>
                                    <xsl:choose>
                                        <xsl:when
                                            test="normalize-space(../../criteria_relationship) = 'ALL'">

                                            <xsl:if test="$is-criteria-but-not-last-criteria">
                                                <B> AND </B>
                                            </xsl:if>
                                        </xsl:when>
                                        <xsl:when test="
                                                normalize-space(../../criteria_relationship) = 'ANY' or normalize-space(../../criteria_relationship) = 'ONE_OF'">

                                            <xsl:if test="$is-criteria-but-not-last-criteria">
                                                <B> OR </B>
                                            </xsl:if>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:if test="$is-criteria-but-not-last-criteria">
                                                <xsl:message>Unhandled restriction parameter
                                                  relationship: '<xsl:value-of
                                                  select="../../criteria_relationship"
                                                  />'</xsl:message>
                                            </xsl:if>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </P>
                            </block>
                        </xsl:for-each>
                    </xsl:for-each>
                </HTML_TEXT>

            </div>
            <div>
                <H2>CONSTRUCTED FROM PARAMETERS</H2>
                <block label="PARAMETERS">
                    <HTML_TEXT>

                        <P>
                            <xsl:value-of select="treatment_phase"/>
                        </P>

                        <xsl:for-each select="RstrctnPrscrbngTxtRltd">
                            <xsl:sort select="@pt_position"  data-type="number"/>


                            <xsl:for-each select="PrescribingTxt">
                                <xsl:variable name="is-not-last-criteria" select="
                                        ../following-sibling::*[1][self::RstrctnPrscrbngTxtRltd]/PrescribingTxt[1]/prescribing_type = 'CRITERIA'"/>
                                <xsl:choose>
                                    <xsl:when test="prescribing_type = 'CRITERIA'">
                                        <xsl:if test="
                                                not(parent::*/preceding-sibling::*[1])
                                                or not(parent::*/preceding-sibling::*[1]/PrescribingTxt[prescribing_type = 'CRITERIA'])
                                                ">
                                            <H3>CRITERIA</H3>
                                        </xsl:if>
                                        <xsl:for-each select="Criteria">
                                            <UL>
                                                <xsl:for-each select="CriteriaParameterRltd">
                                                    <xsl:sort select="@pt_position"   data-type="number"/>
                                                  <xsl:for-each select="PrescribingTxt">
                                                  <xsl:variable name="is-not-last-nested-criteria"
                                                  select="../following-sibling::*[1][self::CriteriaParameterRltd]"/>

                                                  <xsl:if
                                                  test="$is-not-last-nested-criteria and ancestor::Criteria[1]/parameter_relationship = 'ONE_OF'">
                                                  <P>
                                                  <B>Either:</B>
                                                  </P>
                                                  </xsl:if>
                                                  <LI>
                                                  <xsl:value-of select="prescribing_txt"/>
                                                  <xsl:choose>
                                                  <xsl:when
                                                  test="ancestor::Criteria[1]/parameter_relationship = 'ANY'">
                                                  <xsl:if test="$is-not-last-nested-criteria">
                                                  <B> or </B>
                                                  </xsl:if>
                                                  </xsl:when>
                                                  <xsl:when
                                                  test="ancestor::Criteria[1]/parameter_relationship = 'ALL'">

                                                  <xsl:if test="$is-not-last-nested-criteria">
                                                  <B> and </B>
                                                  </xsl:if>
                                                  </xsl:when>
                                                  <xsl:when
                                                  test="ancestor::Criteria[1]/parameter_relationship = 'ONE_OF'">
                                                  <xsl:if test="$is-not-last-nested-criteria">
                                                  <B> or</B>
                                                  </xsl:if>
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <xsl:message>Unhandled criteria-parameter
                                                  relationship: '<xsl:value-of
                                                  select="ancestor::Criteria[1]/parameter_relationship"
                                                  />'</xsl:message>
                                                  </xsl:otherwise>
                                                  </xsl:choose>
                                                  </LI>

                                                  </xsl:for-each>

                                                </xsl:for-each>
                                            </UL>
                                            <xsl:if test="
                                                (ancestor::*/criteria_relationship = 'ANY' or ancestor::*/criteria_relationship = 'ONE_OF')">
                                                <xsl:if test="$is-not-last-criteria">
                                                  <P>
                                                  <B> EITHER </B>
                                                  </P>
                                                </xsl:if>
                                            </xsl:if>
                                            <xsl:choose>
                                                <xsl:when test="
                                                    ancestor::*/criteria_relationship = 'ALL'">

                                                  <xsl:if test="$is-not-last-criteria">
                                                  <P>
                                                  <B> AND </B>
                                                  </P>
                                                  </xsl:if>
                                                </xsl:when>
                                                <xsl:when test="
                                                    ancestor::*/criteria_relationship = 'ANY'">

                                                  <xsl:if test="$is-not-last-criteria">
                                                  <P>
                                                  <B> OR </B>
                                                  </P>
                                                  </xsl:if>
                                                </xsl:when>
                                                <xsl:when test="
                                                    (ancestor::*/criteria_relationship = 'ANY' or ancestor::*/criteria_relationship = 'ONE_OF')">

                                                  <xsl:if test="$is-not-last-criteria">
                                                  <P>
                                                  <B> OR </B>
                                                  </P>
                                                  </xsl:if>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                  <xsl:message>Unhandled restriction parameter
                                                  relationship: '<xsl:value-of
                                                      select="ancestor::*/criteria_relationship"
                                                  />'</xsl:message>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:for-each>

                                    </xsl:when>
                                    <xsl:when test="starts-with(prescribing_type, 'IND')">
                                        <H3>INDICATION</H3>
                                        <P>
                                            <xsl:value-of select="prescribing_txt"/>
                                        </P>
                                    </xsl:when>
                                    <xsl:when test="
                                            prescribing_type = 'PRESCRIBING_INSTRUCTIONS'
                                            and
                                            (not(parent::*/preceding-sibling::*[1])
                                            or not(parent::*/preceding-sibling::*[1]/PrescribingTxt[prescribing_type = 'PRESCRIBING_INSTRUCTIONS'])
                                            )">
                                        <H3>PRESCRIBING INSTRUCTIONS</H3>

                                        <P>
                                            <xsl:value-of select="prescribing_txt"/>
                                        </P>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <P>
                                            <xsl:value-of select="prescribing_txt"/>
                                        </P>
                                    </xsl:otherwise>
                                </xsl:choose>

                            </xsl:for-each>

                        </xsl:for-each>
                    </HTML_TEXT>
                </block>
            </div>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="Item">
        <!-- BECAUSE li_item_id are not uniques due to mistake -->
        <xsl:if test="not(preceding-sibling::Item/@li_item_id = @li_item_id)">
            <xsl:copy>
                <xsl:sequence select="@*"/>
                <xsl:attribute name="manufacturer_code"><xsl:value-of select="manufacturer_code" /></xsl:attribute>
                <section>
                    <H1>
                        <xsl:value-of select="
                                concat(parent::*/@schedule_code, ' (',
                                parent::*/@revision_number, ') ',
                                @program_code, ' ',
                                @pbs_code, ' ''',
                                li_drug_name, ''' ')"/>
                    </H1>

                    <xsl:apply-templates select="ItemIncreases/ItemIncrease[@res_code][1]"/>
                    <xsl:apply-templates select="
                            *[contains(name(), 'Rltd')]
                            [restriction_indicator = 'Y' or not(restriction_indicator)]"/>
                    <xsl:apply-templates
                        select="*[contains(name(), 'Rltd')][restriction_indicator and not(restriction_indicator = 'Y')]"/>


                </section>
            </xsl:copy>
        </xsl:if>
    </xsl:template>


    <xsl:template match="ItemRestrictionRltd">
        <xsl:copy>
            <xsl:sequence select="@*"/>

            <xsl:apply-templates select="(RestrictionTxt | RestrictionText)"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="ItemIncreases/ItemIncrease[@res_code]">
        <xsl:element name="ItemRestrictionRltd">
            <xsl:attribute name="benefit_type_code" select="benefit_type_code" />
            <xsl:copy-of select="@*" />

            <xsl:apply-templates select="(RestrictionTxt | RestrictionText)"/>
        </xsl:element>
    </xsl:template>


    <xsl:template match="
            prescribing_txt_id | prescribing_type | complex_authority_rqrd_ind |
            drug_name | li_drug_name | schedule_form | brand_name"/>

    <!-- for now, we suppress these - not handled -->
    <xsl:template match="ItemPrescribingTxtRltd"/>

    <!--  Default rule -->
    <xsl:template match="*">
        <xsl:copy>
            <xsl:sequence select="@*"/>

            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>

<!-- ================MODE SORT RESTRICTION================================ -->
    
    <xsl:template match="RstrctnPrscrbngTxtRltd" mode="sort-restriction">
        
        <xsl:copy>
            <xsl:sequence select="@*"/>
            <xsl:apply-templates select="node() except RstrctnPrscrbngTxtRltd" mode="sort-restriction" />
            
            <xsl:for-each select="RstrctnPrscrbngTxtRltd"> 
                <xsl:sort select="@pt_position"  data-type="number"/>
                <xsl:apply-templates select="." mode="sort-restriction" />
            </xsl:for-each>
        
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="CriteriaParameterRltd" mode="sort-restriction">
        
        <xsl:copy>
            <xsl:sequence select="@*"/>
            <xsl:apply-templates select="node() except CriteriaParameterRltd" mode="sort-restriction" />
            
            <xsl:for-each select="CriteriaParameterRltd"> 
                <xsl:sort select="@pt_position"  data-type="number"/>
                <xsl:apply-templates select="." mode="sort-restriction" />
            </xsl:for-each>
            
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="node()" mode="sort-restriction">
        <xsl:choose>
            <xsl:when test="self::element()"> 
                <xsl:copy>
                    <xsl:sequence select="@*"/>
                    
                    <xsl:apply-templates mode="sort-restriction"/>
                </xsl:copy>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy  />
            </xsl:otherwise>
        </xsl:choose>
        
    </xsl:template>

</xsl:stylesheet>
