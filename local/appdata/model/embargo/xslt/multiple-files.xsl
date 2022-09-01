<?xml version="1.0" encoding="utf-8"?>
<!--
  This stylesheet Conversion of new PSML shell documents - Multiple documents upload - ZIP(Format)

  @author Adriano Akaishi
  @date 08/08/2022
  @copyright Allette Systems Pty Ltd
-->

<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                exclude-result-prefixes="#all">

    <xsl:param name="title" />
    <xsl:param name="publish_date" />

    <xsl:variable name="base" select="replace(replace(base-uri(),'file:', 'file://'), 'files/list-files.xml', '')" />

    <xsl:output method="xml" encoding="UTF-8" indent="yes" />

    <xsl:template match="files">

        <xsl:for-each select="file">

            <xsl:variable name="date-folder" select="concat(tokenize($publish_date,'-')[1],'/',tokenize($publish_date,'-')[2])" />
            <xsl:variable name="host-search" select="'https://data.pbs.gov.au/search/embargo.html?question='" />
            <xsl:variable name="host-path" select="'https://dev.pbs.gov.au/content/embargo/'" />
            <xsl:variable name="folder" select="concat('/ps/developer/website/website/content/embargo/',$publish_date)" />
            <xsl:variable name="month" select="tokenize($publish_date,'-')[2]" />
            <xsl:variable name="short-path" select="translate(@short-path,'/','\')" />
            <xsl:variable name="name" select="tokenize($short-path,'\\')[last()]" />
            <xsl:variable name="filename" select="substring-before(tokenize($short-path,'\\')[last()],'.')" />
            <xsl:variable name="media-type" select="if(ends-with($name,'.docx')) then 'application/docx'
                                                 else if(ends-with($name,'.pdf')) then 'application/pdf'
                                                 else if(ends-with($name,'.zip')) then 'application/zip' else 'not-allowed' " />
            <xsl:if test="$media-type != 'not-allowed'">
                <xsl:variable name="path" select="concat('../final/output/',$date-folder,'/',$filename,'.psml')" />
                <xsl:result-document href="{$path}">
                    <document version="current" level="portable" type="embargo">
                        <documentinfo>
                            <uri title="{concat($publish_date,' ',$title)}" documenttype="embargo">
                                <displaytitle><xsl:value-of select="concat($publish_date,' ',$title)" /></displaytitle>
                                <labels><xsl:value-of select="'embargo'" /></labels>
                            </uri>
                        </documentinfo>
                        <fragmentinfo/>
                        <metadata>
                            <properties>
                                <property name="last_modified" title="Last modified" datatype="string" value=""/>
                                <property name="folder" title="Folder" datatype="string" value="{$folder}"/>
                                <property name="filename" title="Filename" datatype="string" value="{$name}"/>
                                <property name="media_type" title="Media Type" datatype="string" value="{$media-type}"/>
                                <property name="url_path" title="URL-Path" datatype="string" value="{concat($host-path,$month,'/',$name)}"/>
                                <property name="url_uriid" title="URL-URIID" datatype="string" value="{''}"/>
                                <property name="url_uriid_link"
                                          datatype="link"
                                          title="URL-URIID(Link)">
                                </property>
                                <property name="date" title="Date" value="" datatype="date" />
                            </properties>
                        </metadata>
                        <section id="title">
                            <fragment id="1">
                                <heading level="1">
                                    <xsl:value-of select="concat($publish_date,' ',$title)" />
                                </heading>
                            </fragment>
                        </section>
                        <section id="properties">
                            <properties-fragment id="2">
                                <property name="publish_date"
                                          datatype="link"
                                          title="Publish Date">
                                    <link href="{concat($host-search,$publish_date)}" frag="default"><xsl:value-of select="$publish_date" /></link>
                                </property>
                                <property name="url_path_link"
                                          datatype="link"
                                          title="URL-Path(Link)">
                                    <link href="{concat($host-path,$month,'/',$name)}" frag="default"><xsl:value-of select="$name" /></link>
                                </property>
                            </properties-fragment>
                        </section>
                    </document>
                </xsl:result-document>
            </xsl:if>

        </xsl:for-each>

    </xsl:template>

</xsl:stylesheet>

