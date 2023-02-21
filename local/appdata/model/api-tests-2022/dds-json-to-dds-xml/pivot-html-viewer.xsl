<?xml version="1.0" encoding="utf-8"?>
<!--
  This stylesheet transform openXML into XML Format to Outline Report

  @author Adriano Akaishi
  @date 5/12/2018
  @copyright Allette Systems Pty Ltd
-->

<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:param name="type" />
    <xsl:variable name="file" select="if($type ='error') then 'errors.json'
  												else ''" />

    <xsl:variable name="parameters-row" select="if($type ='error') then 'ERROR'
  												else ''" />

    <xsl:variable name="parameters-col" select="if($type ='error') then 'PBS CODE'
 												else ''" />

    <xsl:output method="html" version="5.0" encoding="UTF-8" indent="yes" />

    <xsl:template match="/">
        <html>
            <head>
                <title>Pivot Analyses</title>
                <!-- external libs from cdnjs -->
                <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/jquery/1.11.2/jquery.min.js"></script>
                <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/jqueryui/1.11.4/jquery-ui.min.js"></script>

                <!-- PivotTable.js libs from ../dist -->
                <link rel="stylesheet" type="text/css" href="css/pivot.css" />
                <script type="text/javascript" src="js/pivot.js"></script>
                <style>
                    body {font-family: Verdana;}
                </style>

                <!-- optional: mobile support with jqueryui-touch-punch -->
                <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/jqueryui-touch-punch/0.2.3/jquery.ui.touch-punch.min.js"></script>

            </head>
            <body>
                <script type="text/javascript">
                    function save() {
                    var data = document.getElementById('mytextarea').value;
                    var a = document.createElement('a');
                    with (a) {
                    href='data:text/cvs;charset=utf-8,' + encodeURIComponent(data);
                    download='csvfile.txt';
                    }
                    document.body.appendChild(a);
                    a.click();
                    document.body.removeChild(a);
                    }

                    // This example shows custom aggregators and sorters using
                    // the "Canadian Parliament 2012" dataset.

                    $(function(){
                    var tpl = $.pivotUtilities.aggregatorTemplates;

                    $.getJSON("data/<xsl:value-of select="$file" />", function(mps) {
                    $("#output").pivotUI(mps, {
                    rows: [<xsl:for-each select="tokenize($parameters-row,',')"><xsl:value-of select="if(position() = last()) then concat('&#34;',.,'&#34;') else concat('&#34;',.,'&#34;',',')" /></xsl:for-each>], cols: [<xsl:value-of select="concat('&#34;',tokenize($parameters-col,','),'&#34;')" />]

                    });
                    });
                    });
                </script>

                <div id="output" style="margin: 30px;"></div>

            </body>
        </html>

    </xsl:template>


</xsl:stylesheet>


