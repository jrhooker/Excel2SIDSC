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
      <xsl:if test="self::db:sect1 | self::db:sect2 | self::db:sect3 | self::db:sect4 | self::db:sect5 | self::db:section">       
            <xsl:attribute name="xml:id">section_<xsl:call-template name="replaceID"/>_<xsl:value-of select="generate-id()"/></xsl:attribute>         
      </xsl:if>
      <xsl:if test="self::db:table">
        <xsl:attribute name="xml:id">table_<xsl:call-template name="replaceID"/>_<xsl:value-of select="generate-id()"/></xsl:attribute>     
      </xsl:if>
      <xsl:if test="self::db:figure">
        <xsl:attribute name="xml:id">figure_<xsl:call-template name="replaceID"/>_<xsl:value-of select="generate-id()"/></xsl:attribute>     
      </xsl:if>
      <xsl:if test="self::db:procedure">
        <xsl:attribute name="xml:id">procedure_<xsl:call-template name="replaceID"/>_<xsl:value-of select="generate-id()"/></xsl:attribute>     
      </xsl:if>
      <xsl:if test="self::db:info">
        <xsl:attribute name="xml:id">info_<xsl:call-template name="replaceID"/>_<xsl:value-of select="generate-id()"/></xsl:attribute>     
      </xsl:if>
      <xsl:choose>
        <xsl:when test="@linkend">
          <xsl:attribute name="linkend"><xsl:call-template name="replaceLinkend"><xsl:with-param name="linkend" select="@linkend"></xsl:with-param></xsl:call-template></xsl:attribute>
        </xsl:when>      
      </xsl:choose>
     <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>

  <xsl:template name="replaceID">     
      <xsl:choose>
        <xsl:when test="not(child::db:title)">
          <xsl:value-of select="@xml:id"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="translate(child::db:title[1], '!@#$%^&amp;*()+=;:&lt;&gt;,?/ ', '____________________')"/>
        </xsl:otherwise>
      </xsl:choose>    
  </xsl:template>
  
  <xsl:template name="replaceLinkend">
    <xsl:param name="linkend"></xsl:param>
    <xsl:variable name="currentNode" select="//db:*[@xml:id = $linkend]"></xsl:variable>
    <xsl:variable name="title" select="//db:*[@xml:id = $linkend]/db:title"></xsl:variable>
    <xsl:variable name="idvalue" select="//db:*[@xml:id = $linkend]/generate-id()"></xsl:variable>
    <xsl:for-each select="//db:*[@xml:id = $linkend]">
    <xsl:if test="self::db:sect1 | self::db:sect2 | self::db:sect3 | self::db:sect4 | self::db:sect5 | self::db:section">       
      <xsl:text>section_</xsl:text><xsl:value-of select="translate($title, '!@#$%^&amp;*()+=;:&lt;&gt;,?/ ', '____________________')"/><xsl:text>_</xsl:text><xsl:value-of select="$idvalue"/>       
    </xsl:if>
    <xsl:if test="self::db:table">
      <xsl:text>>table_</xsl:text><xsl:value-of select="translate($title, '!@#$%^&amp;*()+=;:&lt;&gt;,?/ ', '____________________')"/><xsl:text>_</xsl:text><xsl:value-of select="$idvalue"/>
    </xsl:if>
    <xsl:if test="self::db:figure">
      <xsl:text>figure_</xsl:text><xsl:value-of select="translate($title, '!@#$%^&amp;*()+=;:&lt;&gt;,?/ ', '____________________')"/><xsl:text>_</xsl:text><xsl:value-of select="$idvalue"/>
    </xsl:if>
    <xsl:if test="self::db:procedure">
      <xsl:text>procedure_</xsl:text><xsl:value-of select="translate($title, '!@#$%^&amp;*()+=;:&lt;&gt;,?/ ', '____________________')"/><xsl:text>_</xsl:text><xsl:value-of select="$idvalue"/>
    </xsl:if>
    <xsl:if test="self::db:info">
      <xsl:text>info_</xsl:text><xsl:value-of select="translate($title, '!@#$%^&amp;*()+=;:&lt;&gt;,?/ ', '____________________')"/><xsl:text>_</xsl:text><xsl:value-of select="$idvalue"/>
    </xsl:if>
    </xsl:for-each>     
  </xsl:template>

</xsl:stylesheet>
