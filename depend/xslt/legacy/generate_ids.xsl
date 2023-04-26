<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:db="http://docbook.org/ns/docbook"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
  xmlns:xi="http://www.w3.org/2001/XInclude"
  xmlns:opentopic-i18n="http://www.idiominc.com/opentopic/i18n"
  xmlns:opentopic-index="http://www.idiominc.com/opentopic/index"
  xmlns:opentopic="http://www.idiominc.com/opentopic"
  xmlns:opentopic-func="http://www.idiominc.com/opentopic/exsl/function"
  xmlns:date="http://exslt.org/dates-and-times">

  <xsl:variable name="quot">"</xsl:variable>
  <xsl:variable name="apos">'</xsl:variable>

  <xsl:template match="/">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="processing-instruction()">
    <xsl:copy/>
  </xsl:template>

  <xsl:template match="db:*">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:if test="self::db:sect1">
        <xsl:choose>
          <xsl:when test="@xml:id">
            <xsl:attribute name="xml:id"><xsl:call-template name="check-for-leading-number"/></xsl:attribute>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="xml:id">section_<xsl:value-of select="generate-id()"/></xsl:attribute>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:if>
      <xsl:if test="self::db:table">
        <xsl:choose>
          <xsl:when test="@xml:id">
            <xsl:attribute name="xml:id"><xsl:call-template name="check-for-leading-number"/></xsl:attribute>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="xml:id">table_<xsl:value-of select="generate-id()"/></xsl:attribute>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:if>
      <xsl:if test="self::db:figure">
        <xsl:choose>
          <xsl:when test="@xml:id">
            <xsl:attribute name="xml:id"><xsl:call-template name="check-for-leading-number"/></xsl:attribute>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="xml:id">figure_<xsl:value-of select="generate-id()"/></xsl:attribute>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:if>
      <xsl:if test="self::db:procedure">
        <xsl:choose>
          <xsl:when test="@xml:id">
            <xsl:attribute name="xml:id"><xsl:call-template name="check-for-leading-number"/></xsl:attribute>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="xml:id">procedure_<xsl:value-of select="generate-id()"/></xsl:attribute>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:if>
      <xsl:if test="self::db:info">
        <xsl:choose>
          <xsl:when test="@xml:id">
            <xsl:attribute name="xml:id"><xsl:call-template name="check-for-leading-number"/></xsl:attribute>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="xml:id">info_<xsl:value-of select="generate-id()"/></xsl:attribute>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:if>
      <xsl:if test="self::db:bridgehead">
        <xsl:choose>
          <xsl:when test="@xml:id">
            <xsl:attribute name="xml:id"><xsl:call-template name="check-for-leading-number"/></xsl:attribute>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="xml:id">bridgehead_<xsl:value-of select="generate-id()"/></xsl:attribute>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:if>
      <xsl:if test="self::db:listitem">
        <xsl:choose>
          <xsl:when test="@xml:id">
            <xsl:attribute name="xml:id"><xsl:call-template name="check-for-leading-number"/></xsl:attribute>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="xml:id">listitem_<xsl:value-of select="generate-id()"/></xsl:attribute>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:if>
      <xsl:choose>
        <xsl:when test="@linkend">
          <xsl:attribute name="linkend"><xsl:call-template name="check-for-leading-number-linkend"/></xsl:attribute>
        </xsl:when>      
      </xsl:choose>
     <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="db:section">
        <xsl:copy>
          <xsl:copy-of select="@*"/>
          <xsl:choose>
            <xsl:when test="@xml:id">
              <xsl:attribute name="xml:id"><xsl:call-template name="check-for-leading-number"/></xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
              <xsl:attribute name="xml:id">section_<xsl:value-of select="generate-id()"/></xsl:attribute>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:apply-templates></xsl:apply-templates>
        </xsl:copy>
  </xsl:template>

  <xsl:template name="check-for-leading-number-linkend">  
    <xsl:variable name="link" select="@linkend"/>
    <xsl:variable name="link_2">
      <xsl:choose>
        <xsl:when test="contains($link, 'section_')">
          <xsl:value-of select="substring-after($link, 'section_')"/>
        </xsl:when>
        <xsl:when test="contains($link, 'table_')">
          <xsl:value-of select="substring-after($link, 'table_')"/>
        </xsl:when>
        <xsl:when test="contains($link, 'figure_')">
          <xsl:value-of select="substring-after($link, 'figure_')"/>
        </xsl:when>
        <xsl:when test="contains($link, 'informaltable_')">
          <xsl:value-of select="substring-after($link, 'informaltable_')"/>
        </xsl:when>
        <xsl:when test="contains($link, 'listitem_')">
          <xsl:value-of select="substring-after($link, 'listitem_')"/>
        </xsl:when>
        <xsl:when test="contains($link, 'itemizedlist_')">
          <xsl:value-of select="substring-after($link, 'itemizedlist_')"/>
        </xsl:when>
        <xsl:when test="contains($link, 'orderedlist_')">
          <xsl:value-of select="substring-after($link, 'orderedlist_')"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$link"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    
    <xsl:variable name="lead_value" select="substring($link_2, 1, 1)"/>  
    <xsl:attribute name="linkend">
      <xsl:choose>
        <xsl:when test="
          contains($lead_value, '0') or
          contains($lead_value, '1') or
          contains($lead_value, '2') or
          contains($lead_value, '3') or
          contains($lead_value, '4') or
          contains($lead_value, '5') or
          contains($lead_value, '6') or
          contains($lead_value, '7') or
          contains($lead_value, '8') or
          contains($lead_value, '9')">
          <xsl:text>a_</xsl:text><xsl:value-of select="$link_2"/>
        </xsl:when>
        <xsl:otherwise><xsl:value-of select="$link_2"/></xsl:otherwise>
      </xsl:choose>  
    </xsl:attribute>
  </xsl:template>
  

<xsl:template name="check-for-leading-number">  
  <xsl:variable name="link" select="@xml:id"/>
  <xsl:variable name="link_2">
  <xsl:choose>
    <xsl:when test="contains($link, 'section_')">
      <xsl:value-of select="substring-after($link, 'section_')"/>
    </xsl:when>
    <xsl:when test="contains($link, 'table_')">
      <xsl:value-of select="substring-after($link, 'table_')"/>
    </xsl:when>
    <xsl:when test="contains($link, 'figure_')">
      <xsl:value-of select="substring-after($link, 'figure_')"/>
    </xsl:when>
    <xsl:when test="contains($link, 'informaltable_')">
      <xsl:value-of select="substring-after($link, 'informaltable_')"/>
    </xsl:when>
    <xsl:when test="contains($link, 'listitem_')">
      <xsl:value-of select="substring-after($link, 'listitem_')"/>
    </xsl:when>
    <xsl:when test="contains($link, 'itemizedlist_')">
      <xsl:value-of select="substring-after($link, 'itemizedlist_')"/>
    </xsl:when>
    <xsl:when test="contains($link, 'orderedlist_')">
      <xsl:value-of select="substring-after($link, 'orderedlist_')"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$link"/>
    </xsl:otherwise>
  </xsl:choose>
  </xsl:variable>
  
  <xsl:variable name="lead_value" select="substring($link_2, 1, 1)"/>  
  <xsl:attribute name="xml:id">
  <xsl:choose>
    <xsl:when test="
      contains($lead_value, '0') or
      contains($lead_value, '1') or
      contains($lead_value, '2') or
      contains($lead_value, '3') or
      contains($lead_value, '4') or
      contains($lead_value, '5') or
      contains($lead_value, '6') or
      contains($lead_value, '7') or
      contains($lead_value, '8') or
      contains($lead_value, '9')">
      <xsl:text>a_</xsl:text><xsl:value-of select="$link_2"/>
    </xsl:when>
    <xsl:otherwise><xsl:value-of select="$link_2"/></xsl:otherwise>
  </xsl:choose>  
  </xsl:attribute>
</xsl:template>

</xsl:stylesheet>
