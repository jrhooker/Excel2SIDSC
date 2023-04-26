<?xml version="1.0" encoding="UTF-8"?><xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:exsl="http://exslt.org/common" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:ng="http://docbook.org/docbook-ng" xmlns:db="http://docbook.org/ns/docbook" xmlns:xi="http://www.w3.org/2001/XInclude" xmlns:xml="http://www.w3.org/XML/1998/namespace" exclude-result-prefixes="db ng exsl" version="1.0">
    
    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="processing-instruction()">
        <xsl:copy/>
    </xsl:template>
    
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="xi:include">     
        <xsl:variable name="id_value">          
            <xsl:value-of select="@xpointer"/>
        </xsl:variable>
        <xsl:for-each select="document(@href,/)">
            <xsl:apply-templates select="//*[@xml:id=$id_value]"/>
        </xsl:for-each>
    </xsl:template>
    
    <!-- Add default footers -->
    
    <xsl:template match="db:info">
        <xsl:element name="info" namespace="http://docbook.org/ns/docbook">
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
            <xsl:choose>
                <xsl:when test="db:pmc_footertext"/>
                <xsl:otherwise>
                    <xsl:element name="pmc_footertext" namespace="http://docbook.org/ns/docbook">
                        <xsl:attribute name="audience">PMCInternal</xsl:attribute>Proprietary and
                        Confidential to PMC-Sierra, Inc.</xsl:element>
                    <xsl:element name="pmc_footertext" namespace="http://docbook.org/ns/docbook">
                        <xsl:attribute name="audience">all_customers</xsl:attribute>Proprietary and
                        Confidential to PMC-Sierra, Inc., and for its customers' internal
                        use.</xsl:element>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:element>
    </xsl:template>
    
</xsl:stylesheet>