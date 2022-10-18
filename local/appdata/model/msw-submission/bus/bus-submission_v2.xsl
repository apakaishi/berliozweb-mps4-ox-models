<?xml version="1.0" encoding="utf-8"?>
  <!--
    This stylesheet Preparing a Simple Example PBS XML v3

    @author Adriano Akaishi
    @date 09/08/2019
    @copyright Allette Systems Pty Ltd
  -->

<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				              xmlns:fn="http://www.pageseeder.com/function"
							  xmlns:xs="http://www.w3.org/2001/XMLSchema"
                              exclude-result-prefixes="#all">

  <xsl:import href="util/function.xsl" />
  <xsl:param name="output-folder" />

  <xsl:output method="xml" encoding="UTF-8" indent="yes" />

  <xsl:variable name="base" select="substring-before(replace(base-uri(),'file:', 'file://'),'data/workbook.xml')" />
  <xsl:variable name="output" select="concat($base,$output-folder,'/')" />

  <xsl:template match="/">
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="root">
	<xsl:variable name="folder" select="$output" />

    <xsl:for-each select="row[case-id!='']">

  	  <xsl:variable name="case-id" select="normalize-space(lower-case(case-id/text()))" />
      <xsl:variable name="filename" select="concat($case-id,'-',fn:format-yyyy-mm-dd(meeting-date/text()),'.psml')" />
	    <xsl:variable name="path-report" select="concat($folder,$filename)" />
	    <xsl:variable name="drug-name" select="fn:clean-white-spaces(drug-name)"/>
		  <xsl:variable name="brand-names" select="fn:clean-white-spaces(brand-names)"/>
		  <xsl:variable name="sponsors" select="fn:clean-white-spaces(sponsors)"/>
			<xsl:variable name="purpose" select="fn:clean-white-spaces(purpose)"/>

			<!-- The PSML title cannot be bigger than 250 -->
	    <xsl:variable name="title" select="substring($drug-name, 1, 250)"/>

	  <xsl:result-document method="xml" href="{$path-report}">
	    <!--
	  	    PSML document template for drug
		 -->
		 <document type="drug" version="current" level="portable">
		    <documentinfo>
		  	   <uri mediatype="application/vnd.pageseeder.psml+xml" documenttype="drug" docid="{$case-id}" title="{$title}">
				  <displaytitle><xsl:value-of select="$title" /></displaytitle>
				  <labels>current</labels>
			   </uri>
		    </documentinfo>
		    <metadata/>
		    <section id="content">
		 	   <properties-fragment id="submission">
				   <!--Variables split content -->
				   <xsl:variable name="list-date" select="if(listed-date!='') then fn:format-yyyy-mm-dd(listed-date/text()) else ''" />

				   <property name="case-id" title="Case id" value="{$case-id}" datatype="string" />
				   <property name="pbac-outcome-status" title="PBAC Outcome Status" value="{pbac-outcome-status}" datatype="string" />
				   <property name="meeting-date" title="Meeting date" value="{fn:format-yyyy-mm-dd(meeting-date/text())}" datatype="date" />
				   <property name="listed-date" title="Listed date" value="{$list-date}" datatype="date" />
				   <property name="drug-name" title="Drug name" value="{$drug-name}" datatype="string" />
				   <property name="brand-names" title="Brand Names" count="n" datatype="string">
					 <xsl:for-each select="tokenize($brand-names, ',')">
					   <value><xsl:value-of select="." /></value>
					 </xsl:for-each>
				   </property>
				   <property name="sponsors" title="Sponsor" value="{$sponsors}" datatype="string"/>
				   <property name="manubookcode" title="Manubookcode" value=""  datatype="string"/>
				   <property name="purpose" title="Purpose" count="n" datatype="string">
					  <value><xsl:value-of select="$purpose" /></value>
				   </property>
				   <property name="type-listing" title="Type listing" value="{fn:clean-white-spaces(type-listing)}" datatype="string" />
				   <property name="submission-type" title="Submission type" value="{fn:clean-white-spaces(submission-type)}" datatype="string" />

				   <property name="comment" title="Comment" value="{comment}" datatype="string" />
				   <!--Property review in Template-->
				   <property name="related-medicines" title="Related Medicines" datatype="xref" multiple="true">
					 <xsl:if test="related-medicines != ''">
					   <xsl:for-each select="tokenize(related-medicines, ',')">
						 <xsl:variable name="related-medicine-doc-id" select="replace(., '[^a-zA-Z0-9]', '')"/>
						   <xsl:if test="$related-medicine-doc-id != ''">
							 <xref frag="default" reversefrag="application" reversetitle="" reverselink="true" reversetype="none" display="document"
										type="none" docid="{$related-medicine-doc-id}" urititle="{$drug-name}"
										urilabels="current" mediatype="application/vnd.pageseeder.psml+xml" documenttype="drug"><xsl:value-of select="$drug-name" /></xref>
						   </xsl:if>
						</xsl:for-each>
					  </xsl:if>
				   </property>
				   <property name="public-summary-document" title="Public summary document" datatype="link"/>
		       </properties-fragment>
			   <properties-fragment id="steps">
				   <xsl:variable name="step1-label" select="'Submission received for'" />
				   <xsl:variable name="step-5-pricing-offer-package-received" select="if(step-5-pricing-offer-package-received != '' or step-5-pricing-offer-package-received!= 'pending') then fn:verify-data-for-format-date(step-5-pricing-offer-package-received/text()) else ''" />

				   <property name="step-numbers" title="Number Of Steps" value="8" datatype="string" />
				   <property name="step-1-label" title="Step 1 - label" value="{$step1-label}" datatype="string" />
				   <property name="step-1-status" title="Step 1 - status" value="{if(step-1-status) then step-1-status else 'active'}" datatype="string" />
				   <property name="step-2-label" title="Step 2 - label" value="Opportunity for consumer comment" datatype="string" />
				   <property name="step-2-status" title="Step 2 - status" value="{if(step-2-status) then step-2-status else 'pending'}" datatype="string" />
				   <property name="step-2-open-date" title="Step 2 - Open Date" value="{fn:format-yyyy-mm-dd(step-2-open-date/text())}" datatype="date" />
				   <property name="step-2-closed-date" title="Step 2 - Closed Date" value="{fn:format-yyyy-mm-dd(step-2-closed-date/text())}" datatype="date"/>
				   <property name="step-2-see-url" title="Step 2 - See URL" datatype="link">
				     <xsl:if test="step-2-see-url/text()">
							 <!-- TODO the text and href should come form the uriid. but currently it is not working in this way.-->
						   <link href="{step-2-see-url/text()}"><xsl:value-of select="step-2-see-url-title/text()"/></link>
						 </xsl:if>
				   </property>
				   <property name="step-3-label" title="Step 3 - label" value="PBAC meeting" datatype="string" />
				   <property name="step-3-status" title="Step 3 - status" value="{if(step-3-status) then step-3-status else 'pending'}" datatype="string" />
				   <property name="step-4-label" title="Step 4 - label" value="PBAC outcome published" datatype="string" />
				   <property name="step-4-status" title="Step 4 - status" value="{if(step-4-status) then step-4-status else 'pending'}" datatype="string" />
				   <property name="step-4-notice-pricing-received-date" title="Step 4 - Notice of intent for pricing received:" value="{fn:verify-data-for-format-date(step-4-notice-pricing-received-date/text())}" datatype="date" />
				   <property name="step-4-notice-pricing-exception-applied"      title="Step 4 - Notice of intent - Exception applied"  value="false"      datatype="string"/>
				   <property name="step-4-see-url" title="Step 4 - See URL" datatype="link"/>
				   <property name="step-5-label" title="Step 5 - label" value="Lodgement of required documentation" datatype="string" />
				   <property name="step-5-status" title="Step 5 - status" value="{if(step-5-status) then step-5-status else 'pending'}" datatype="string" />
				   <property name="step-5-pricing-offer-package-received" title="Step 5 - Applicant’s pricing offer package received" value="{$step-5-pricing-offer-package-received}" datatype="date" />
				   <property name="step-5-pricing-offer-package-status" title="Step 5 - Applicant’s pricing offer package status" value="{step-5-pricing-offer-package-status}" datatype="string" />
				   <property name="step-6-label" title="Step 6 - label" value="Agreement to listing arrangements" datatype="string" />
				   <property name="step-6-status" title="Step 6 - status" value="{if(step-6-status) then step-6-status else 'pending'}" datatype="string" />
				   <property name="step-6-commence-date" title="Step 6 - Commence Date" value="{fn:verify-data-for-format-date(step-6-commence-date/text())}" datatype="date" />
				   <property name="step-6-terms-of-listing" title="Step 6 - Terms of listing" value="{step-6-terms-of-listing}" datatype="string" />
				   <property name="step-7-label" title="Step 7 - label" value="Government processes" datatype="string" />
				   <property name="step-7-status" title="Step 7 - status" value="{if(step-7-status) then step-7-status else 'pending'}" datatype="string" />
				   <property name="step-7-commence-date" title="Step 7 - Commence Date" value="{fn:verify-data-for-format-date(step-7-commence-date/text())}" datatype="date"/>
				   <property name="step-8-label" title="Step 8 - label" value="Medicine listed on the PBS" datatype="string" />
				   <property name="step-8-status" title="Step 8 - status" value="{if(step-8-status) then step-8-status else 'pending'}" datatype="string"/>
				   <property name="step-8-see-url" title="Step 8 - See URL" datatype="link"/>
			   </properties-fragment>
			   <properties-fragment id="not-proceeding">
				    <property name="not-proceeding" title="Not Proceeding" value="false" datatype="string" />
				    <property name="not-proceeding-date" title="Not Proceeding Date" value="" datatype="date" />
				    <property name="not-proceeding-message" title="Not Proceeding Message" value="The pharmaceutical company has advised that it is not proceeding in the PBS listing process at this time. The process for listing this medicine has ceased." datatype="string"/>
			   </properties-fragment>
			   <properties-fragment id="submission-withdrawn">
				    <xsl:variable name="message" select="'false'" />

				    <property name="submission-withdrawn" title="Submission Withdrawn" value="{$message}" datatype="string" />
				    <property name="submission-withdrawn-date" title="Submission Withdrawn Date" value="" datatype="date"/>
				    <property name="submission-withdrawn-message" title="Submission Withdrawn Message" value="The pharmaceutical company has withdrawn their submission for this medicine prior to the medicine being considered at the PBAC meeting. The process for listing this medicine has ceased." datatype="string"/>
			   </properties-fragment>
			   <properties-fragment id="inactive">
				    <xsl:variable name="status-inactive" select="'false'" />
				    <xsl:variable name="inactive-period" select="'0'" />
				    <xsl:variable name="inactive-message" select="'No activity by the pharmaceutical company has been recorded for this medicine for six(6) months. The process for listing is considered inactive.'" />

				    <property name="inactive" title="Is inactive" value="{$status-inactive}" datatype="string" />
				    <property name="inactive-period" title="Inactive for more than" value="{$inactive-period}" datatype="string" />
				    <property name="inactive-date" title="When get inactive" value="" datatype="date" />
				    <property name="inactive-message" title="Inactive Message" value="{$inactive-message}" datatype="string"/>
			   </properties-fragment>
			   <properties-fragment id="msw-process-not-applicable">
				 	 <property name="msw-process-not-applicable" title="MSW Process Not Applicable" value="false" datatype="string" />
				  	 <property name="msw-process-not-applicable-message" title="MSW Process Not Applicable Message" value="The processes outlined in the MSW are not applicable to this medicine. Please contact pbs@health.gov.au or 1800 020 613 for further information." datatype="string" />
			   </properties-fragment>
			   <properties-fragment id="item-index">
				     <property name="drug-name-text" title="Drug name text" value="{$drug-name}" datatype="string" />
					 <property name="brand-names-text" title="Brand Names text" count="n" datatype="string">
						 <xsl:for-each select="tokenize($brand-names, ',')">
							 <value><xsl:value-of select="." /></value>
						 </xsl:for-each>
					 </property>
					 <property name="sponsor-text" title="Sponsor text" value="{$sponsors}" datatype="string"/>
					 <property name="purpose-text" title="Purpose text" count="n" datatype="string">
					   <value><xsl:value-of select="$purpose" /></value>
					 </property>
					 <property name="pbac-outcome-status-text" title="PBAC Outcome Status text" value="{pbac-outcome-status}" datatype="string" />
			   </properties-fragment>
			</section>
		    <section id="template-version" lockstructure="true" edit="false">
		  	   <properties-fragment id="template-version">
					 <property datatype="string" name="template-version" title="Template Version" value=".9.16" />
					 <property datatype="string" name="template-date" title="Last updated" value="2021-10-25" />
			   </properties-fragment>
			</section>
		 </document>
	   </xsl:result-document>
	  </xsl:for-each>
  </xsl:template>


</xsl:stylesheet>
