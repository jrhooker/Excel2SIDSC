<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:excel="urn:schemas-microsoft-com:office:spreadsheet"
    xmlns:o="urn:schemas-microsoft-com:office:office"
    xmlns:x="urn:schemas-microsoft-com:office:excel"
    xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"
    xmlns:html="http://www.w3.org/TR/REC-html40" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format" version="2.0">

    <xsl:output method="xml" media-type="text/xml" indent="yes" encoding="UTF-8"
        doctype-public="-//Atmel//DTD DITA Map//EN" doctype-system="map.dtd"/>
    
    <xsl:param name="first-row" select="2"/>

    <xsl:variable name="registers" select="/ss:Workbook/ss:Worksheet[@ss:Name = 'Registers']/ss:Table/ss:Row"/>
    <xsl:variable name="register-count" select="count($registers)"/>

    <xsl:template match="/">
        <xsl:call-template name="create-ditamap"/>      
    </xsl:template>

    <xsl:template name="create-ditamap">
        <xsl:element name="map">
            <xsl:element name="title">Title</xsl:element>
            <xsl:call-template name="create-topicrefs">
                <xsl:with-param name="starting-value" select="$first-row"/>
            </xsl:call-template>
        </xsl:element>
    </xsl:template>

    <xsl:template name="create-registers">
        <xsl:param name="starting-value"/>
        <xsl:if test="$starting-value &lt;= $register-count">
            <xsl:if test="$registers[$starting-value]/ss:Cell[1][not(@ss:Index &gt; 0)]">
                <xsl:call-template name="create-register">
                    <xsl:with-param name="starting-value" select="$starting-value"/>
                </xsl:call-template>
            </xsl:if>
            <xsl:call-template name="create-registers">
                <xsl:with-param name="starting-value" select="$starting-value + 1"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

    <xsl:template name="create-register">
        <xsl:param name="starting-value"/>
        <xsl:result-document
            href="{concat(normalize-space($registers[$starting-value]/ss:Cell[3]), '.xml')}">
            <xsl:element name="register">
                <xsl:attribute name="id"
                    select="normalize-space($registers[$starting-value]/ss:Cell[3])"/>
                <xsl:element name="registerName">
                    <xsl:value-of select="normalize-space($registers[$starting-value]/ss:Cell[3])"/>
                </xsl:element>
                <xsl:element name="registerNameMore">
                    <xsl:element name="registerNameFull">
                        <xsl:value-of
                            select="normalize-space($registers[$starting-value]/ss:Cell[3])"/>
                    </xsl:element>
                </xsl:element>

                <xsl:element name="registerBody">
                    <xsl:element name="registerDescription">
                        <xsl:value-of
                            select="normalize-space($registers[$starting-value]/ss:Cell[4])"/>
                    </xsl:element>
                    <xsl:element name="registerProperties">
                        <xsl:element name="registerPropset">
                            <xsl:element name="addressOffset">
                                <xsl:value-of
                                    select="normalize-space($registers[$starting-value]/ss:Cell[2])"
                                />
                            </xsl:element>
                            <xsl:element name="registerSize"
                                ><!-- Looks like we need to add up the bitfields for this --></xsl:element>
                            <xsl:element name="registerResetValue">
                                <xsl:value-of
                                    select="normalize-space($registers[$starting-value]/ss:Cell[18])"
                                />
                            </xsl:element>
                            <xsl:element name="bitOrder"/>
                            <xsl:element name="resetTrig"/>
                        </xsl:element>
                    </xsl:element>
                </xsl:element>
                <xsl:choose>
                    <xsl:when test="normalize-space($registers[$starting-value]/ss:Cell[3]/@ss:MergeDown)">
                        <xsl:call-template name="create-bitfields">
                            <xsl:with-param name="total-bit-count"
                                select="$registers[$starting-value]/ss:Cell[3]/@ss:MergeDown"/>
                            <xsl:with-param name="starting-value" select="$starting-value"/>
                        </xsl:call-template>
                    </xsl:when>
                </xsl:choose>
            </xsl:element>
        </xsl:result-document>
    </xsl:template>

    <xsl:template name="create-bitfields">
        <xsl:param name="starting-value"/>
        <xsl:param name="current-bit-count" select="0"/>
        <xsl:param name="total-bit-count"/>
        <xsl:if test="$current-bit-count &lt;= $total-bit-count">
        <xsl:variable name="starting-cell">
            <xsl:choose>
                <xsl:when test="$current-bit-count = 0">5</xsl:when>
                <xsl:otherwise>1</xsl:otherwise>
            </xsl:choose>           
        </xsl:variable>            
            <xsl:element name="bitField">
                <xsl:element name="bitFieldName"><xsl:value-of select="normalize-space($registers[number($starting-value) + number($current-bit-count)]/ss:Cell[number($starting-cell)])"/></xsl:element>
              <xsl:element name="bitFieldBriefDescription"></xsl:element>
              <xsl:element name="bitFieldBody">
                  <xsl:element name="bitFieldDescription">
                      <xsl:element name="p">
                          <xsl:value-of select="$registers[$starting-value]/ss:Cell[number($starting-cell) + 16]"/>
                      </xsl:element>                      
                  </xsl:element>
                  <xsl:element name="bitFieldProperties">
                      <xsl:element name="bitFieldPropset">
                          <xsl:element name="bitWidth"><xsl:value-of select="normalize-space($registers[number($starting-value) + number($current-bit-count)]/ss:Cell[number($starting-cell) + 1])"/></xsl:element>
                          <xsl:element name="bitOffset"><xsl:value-of select="normalize-space($registers[number($starting-value) + number($current-bit-count)]/ss:Cell[number($starting-cell) + 2])"/></xsl:element>
                          <xsl:element name="bitFieldAccess"><xsl:value-of select="normalize-space($registers[number($starting-value) + number($current-bit-count)]/ss:Cell[number($starting-cell) + 3])"/></xsl:element>
                          <xsl:element name="bitFieldReset">
                              <xsl:element name="bitFieldResetValue">
                                  <xsl:if test="string-length(normalize-space($registers[number($starting-value) + number($current-bit-count)]/ss:Cell[number($starting-cell) +13])) &gt; 0">
                                      <xsl:value-of select="normalize-space($registers[number($starting-value) + number($current-bit-count)]/ss:Cell[number($starting-cell) +13])"/>
                                  </xsl:if>
                              </xsl:element>
                          </xsl:element>
                      </xsl:element>
                  </xsl:element>                  
              </xsl:element>
            </xsl:element>
            <xsl:call-template name="create-bitfields">
                <xsl:with-param name="total-bit-count" select="$total-bit-count"/>
                <xsl:with-param name="current-bit-count" select="$current-bit-count + 1"/>
                <xsl:with-param name="starting-value" select="$starting-value"></xsl:with-param>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>


    <xsl:template name="create-topicrefs">
        <xsl:param name="starting-value"/>
        <xsl:if test="$starting-value &lt;= $register-count">
            <xsl:if test="$registers[$starting-value]/ss:Cell[1][not(@ss:Index &gt; 0)]">
                <xsl:element name="topicref">
                    <xsl:attribute name="href"
                        select="concat(normalize-space($registers[$starting-value]/ss:Cell[3]), '.xml')"
                    />
                </xsl:element>
            </xsl:if>
            <xsl:text>               
</xsl:text>
            <xsl:call-template name="create-topicrefs">
                <xsl:with-param name="starting-value" select="$starting-value + 1"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>
