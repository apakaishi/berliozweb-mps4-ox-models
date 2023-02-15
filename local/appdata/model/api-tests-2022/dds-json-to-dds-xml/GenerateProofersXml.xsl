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

    <xsl:template match="Schedule">
        <proof-text>
            <xsl:if test="Item/@PROGRAM_CODE or Item/PROGRAM_CODE">
                <xsl:attribute name="programCode" select="(Item/@PROGRAM_CODE | Item/PROGRAM_CODE)[1]"/>
            </xsl:if>
            <xsl:if test="@SCHEDULE_CODE or SCHEDULE_CODE">
                <xsl:attribute name="scheduleCode" select="(@SCHEDULE_CODE | SCHEDULE_CODE)[1]"/>
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
                            if (NOTE_INDICATOR = 'Y') then
                                'Note '
                            else
                                if (CAUTION_INDICATOR = 'Y') then
                                    'Caution '
                                else
                                    'Restriction ',
                            RESTRICTION_NUMBER)"/>
                </H1>
                <P>Treatment Phase: <xsl:value-of select="TREATMENT_PHASE"/></P>

                <P>Authority Method: <xsl:value-of select="AUTHORITY_METHOD"/></P>

                <P>Treatment-Of Code: <xsl:value-of select="TREATMENT_OF_CODE"/></P>
            </div>
            <div>
                <H2>LI HTML TEXT</H2>
                <block label="LI">
                    <HTML_TEXT>
                        <xsl:value-of disable-output-escaping="yes" select="LI_HTML_TEXT"/>
                    </HTML_TEXT>
                </block>
            </div>
            <div>
                <H2>SCHEDULE HTML TEXT</H2>
                <block label="SCHEDULE">
                    <HTML_TEXT>
                        <xsl:value-of disable-output-escaping="yes" select="SCHEDULE_HTML_TEXT"/>
                    </HTML_TEXT>
                </block>
            </div>
            <div>
                <H2>CONSTRUCTED FROM CRITERIA</H2>
                <HTML_TEXT>

                    <P>
                        <xsl:value-of select="TREATMENT_PHASE"/>
                    </P>

                    <xsl:for-each select="RstrctnPrscrbngTxtRltd">

                        <xsl:sort select="@PT_POSITION"  data-type="number"/>
                        <xsl:for-each select="PrescribingTxt[not(PRESCRIBING_TYPE = 'PARAMETER')]">

                            <block label="{PRESCRIBING_TYPE}">
                                <xsl:variable name="is-criteria-but-not-last-criteria" select="
                                        PRESCRIBING_TYPE = 'CRITERIA' and
                                        ../following-sibling::*[1][self::RstrctnPrscrbngTxtRltd]/PrescribingTxt[1]/PRESCRIBING_TYPE = 'CRITERIA'"/>
                                <P>
                                    <xsl:value-of select="PRESCRIBING_TXT"/>
                                    <xsl:choose>
                                        <xsl:when
                                            test="normalize-space(../../CRITERIA_RELATIONSHIP) = 'ALL'">

                                            <xsl:if test="$is-criteria-but-not-last-criteria">
                                                <B> AND </B>
                                            </xsl:if>
                                        </xsl:when>
                                        <xsl:when test="
                                                normalize-space(../../CRITERIA_RELATIONSHIP) = 'ANY' or normalize-space(../../CRITERIA_RELATIONSHIP) = 'ONE_OF'">

                                            <xsl:if test="$is-criteria-but-not-last-criteria">
                                                <B> OR </B>
                                            </xsl:if>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:if test="$is-criteria-but-not-last-criteria">
                                                <xsl:message>Unhandled restriction parameter
                                                  relationship: '<xsl:value-of
                                                  select="../../CRITERIA_RELATIONSHIP"
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
                            <xsl:value-of select="TREATMENT_PHASE"/>
                        </P>

                        <xsl:for-each select="RstrctnPrscrbngTxtRltd">
                            <xsl:sort select="@PT_POSITION"  data-type="number"/>


                            <xsl:for-each select="PrescribingTxt">
                                <xsl:variable name="is-not-last-criteria" select="
                                        ../following-sibling::*[1][self::RstrctnPrscrbngTxtRltd]/PrescribingTxt[1]/PRESCRIBING_TYPE = 'CRITERIA'"/>
                                <xsl:choose>
                                    <xsl:when test="PRESCRIBING_TYPE = 'CRITERIA'">
                                        <xsl:if test="
                                                not(parent::*/preceding-sibling::*[1])
                                                or not(parent::*/preceding-sibling::*[1]/PrescribingTxt[PRESCRIBING_TYPE = 'CRITERIA'])
                                                ">
                                            <H3>CRITERIA</H3>
                                        </xsl:if>
                                        <xsl:for-each select="Criteria">
                                            <UL>
                                                <xsl:for-each select="CriteriaParameterRltd">
                                                    <xsl:sort select="@PT_POSITION"   data-type="number"/>
                                                  <xsl:for-each select="PrescribingTxt">
                                                  <xsl:variable name="is-not-last-nested-criteria"
                                                  select="../following-sibling::*[1][self::CriteriaParameterRltd]"/>

                                                  <xsl:if
                                                  test="$is-not-last-nested-criteria and ancestor::Criteria[1]/PARAMETER_RELATIONSHIP = 'ONE_OF'">
                                                  <P>
                                                  <B>Either:</B>
                                                  </P>
                                                  </xsl:if>
                                                  <LI>
                                                  <xsl:value-of select="PRESCRIBING_TXT"/>
                                                  <xsl:choose>
                                                  <xsl:when
                                                  test="ancestor::Criteria[1]/PARAMETER_RELATIONSHIP = 'ANY'">
                                                  <xsl:if test="$is-not-last-nested-criteria">
                                                  <B> or </B>
                                                  </xsl:if>
                                                  </xsl:when>
                                                  <xsl:when
                                                  test="ancestor::Criteria[1]/PARAMETER_RELATIONSHIP = 'ALL'">

                                                  <xsl:if test="$is-not-last-nested-criteria">
                                                  <B> and </B>
                                                  </xsl:if>
                                                  </xsl:when>
                                                  <xsl:when
                                                  test="ancestor::Criteria[1]/PARAMETER_RELATIONSHIP = 'ONE_OF'">
                                                  <xsl:if test="$is-not-last-nested-criteria">
                                                  <B> or</B>
                                                  </xsl:if>
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <xsl:message>Unhandled criteria-parameter
                                                  relationship: '<xsl:value-of
                                                  select="ancestor::Criteria[1]/PARAMETER_RELATIONSHIP"
                                                  />'</xsl:message>
                                                  </xsl:otherwise>
                                                  </xsl:choose>
                                                  </LI>

                                                  </xsl:for-each>

                                                </xsl:for-each>
                                            </UL>
                                            <xsl:if test="
                                                (ancestor::*/CRITERIA_RELATIONSHIP = 'ANY' or ancestor::*/CRITERIA_RELATIONSHIP = 'ONE_OF')">
                                                <xsl:if test="$is-not-last-criteria">
                                                  <P>
                                                  <B> EITHER </B>
                                                  </P>
                                                </xsl:if>
                                            </xsl:if>
                                            <xsl:choose>
                                                <xsl:when test="
                                                    ancestor::*/CRITERIA_RELATIONSHIP = 'ALL'">

                                                  <xsl:if test="$is-not-last-criteria">
                                                  <P>
                                                  <B> AND </B>
                                                  </P>
                                                  </xsl:if>
                                                </xsl:when>
                                                <xsl:when test="
                                                    ancestor::*/CRITERIA_RELATIONSHIP = 'ANY'">

                                                  <xsl:if test="$is-not-last-criteria">
                                                  <P>
                                                  <B> OR </B>
                                                  </P>
                                                  </xsl:if>
                                                </xsl:when>
                                                <xsl:when test="
                                                    (ancestor::*/CRITERIA_RELATIONSHIP = 'ANY' or ancestor::*/CRITERIA_RELATIONSHIP = 'ONE_OF')">

                                                  <xsl:if test="$is-not-last-criteria">
                                                  <P>
                                                  <B> OR </B>
                                                  </P>
                                                  </xsl:if>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                  <xsl:message>Unhandled restriction parameter
                                                  relationship: '<xsl:value-of
                                                      select="ancestor::*/CRITERIA_RELATIONSHIP"
                                                  />'</xsl:message>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:for-each>

                                    </xsl:when>
                                    <xsl:when test="starts-with(PRESCRIBING_TYPE, 'IND')">
                                        <H3>INDICATION</H3>
                                        <P>
                                            <xsl:value-of select="PRESCRIBING_TXT"/>
                                        </P>
                                    </xsl:when>
                                    <xsl:when test="
                                            PRESCRIBING_TYPE = 'PRESCRIBING_INSTRUCTIONS'
                                            and
                                            (not(parent::*/preceding-sibling::*[1])
                                            or not(parent::*/preceding-sibling::*[1]/PrescribingTxt[PRESCRIBING_TYPE = 'PRESCRIBING_INSTRUCTIONS'])
                                            )">
                                        <H3>PRESCRIBING INSTRUCTIONS</H3>

                                        <P>
                                            <xsl:value-of select="PRESCRIBING_TXT"/>
                                        </P>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <P>
                                            <xsl:value-of select="PRESCRIBING_TXT"/>
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
        <!-- BECAUSE LI_ITEM_ID are not uniques due to mistake -->
        <xsl:if test="not(preceding-sibling::Item/@LI_ITEM_ID = @LI_ITEM_ID)">
            <xsl:copy>
                <xsl:sequence select="@*"/>
                <xsl:attribute name="MANUFACTURER_CODE"><xsl:value-of select="MANUFACTURER_CODE" /></xsl:attribute>
                <section>
                    <H1>
                        <xsl:value-of select="
                                concat(parent::*/@SCHEDULE_CODE, ' (',
                                parent::*/@REVISION_NUMBER, ') ',
                                @PROGRAM_CODE, ' ',
                                @PBS_CODE, ' ''',
                                LI_DRUG_NAME, ''' ')"/>
                    </H1>

                    <xsl:apply-templates select="
                            *[contains(name(), 'Rltd')]
                            [RESTRICTION_INDICATOR = 'Y' or not(RESTRICTION_INDICATOR)]"/>
                    <xsl:apply-templates
                        select="*[contains(name(), 'Rltd')][RESTRICTION_INDICATOR and not(RESTRICTION_INDICATOR = 'Y')]"/>

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


    <xsl:template match="
            PRESCRIBING_TXT_ID | PRESCRIBING_TYPE | COMPLEX_AUTHORITY_RQRD_IND |
            DRUG_NAME | LI_DRUG_NAME | SCHEDULE_FORM | BRAND_NAME"/>

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
                <xsl:sort select="@PT_POSITION"  data-type="number"/>
                <xsl:apply-templates select="." mode="sort-restriction" />
            </xsl:for-each>
        
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="CriteriaParameterRltd" mode="sort-restriction">
        
        <xsl:copy>
            <xsl:sequence select="@*"/>
            <xsl:apply-templates select="node() except CriteriaParameterRltd" mode="sort-restriction" />
            
            <xsl:for-each select="CriteriaParameterRltd"> 
                <xsl:sort select="@PT_POSITION"  data-type="number"/>
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
