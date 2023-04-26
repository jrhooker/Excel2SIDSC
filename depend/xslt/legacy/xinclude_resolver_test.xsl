<?xml version="1.0" encoding="UTF-8"?><xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:exsl="http://exslt.org/common" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:ng="http://docbook.org/docbook-ng" xmlns:db="http://docbook.org/ns/docbook" xmlns:xi="http://www.w3.org/2001/XInclude" xmlns:xml="http://www.w3.org/XML/1998/namespace" exclude-result-prefixes="db ng exsl" version="2.0">
    
    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="processing-instruction()">
        <xsl:param name="path_value"></xsl:param>
        <xsl:copy/>
    </xsl:template>
    
    <xsl:template match="@*|node()">
        <xsl:param name="path_value"></xsl:param>
        <xsl:copy>
            <xsl:message>path value = <xsl:value-of select="$path_value"></xsl:value-of></xsl:message>
            <xsl:apply-templates select="@*|node()"><xsl:with-param name="path_value" select="$path_value"/></xsl:apply-templates>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="db:imagedata">
        <xsl:param name="path_value"></xsl:param>
        <xsl:copy>           
            <xsl:copy-of select="@*"></xsl:copy-of>
            <xsl:attribute name="fileref">
                <xsl:value-of select="$path_value"/><xsl:value-of select="@fileref"/>
            </xsl:attribute>
            <xsl:message>path value = <xsl:value-of select="$path_value"></xsl:value-of></xsl:message>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="xi:include">
        <xsl:param name="path_value"></xsl:param>        
        <xsl:variable name="id_value">          
            <xsl:value-of select="@xpointer"/>
        </xsl:variable>               
        <xsl:variable name="appended_path_value">
            <xsl:choose>
                <xsl:when test="contains(@href, '/') and string-length($path_value) &gt; 1">
                    <xsl:value-of select="$path_value"/><xsl:call-template name="form-image-path"><xsl:with-param name="href" select="@href"></xsl:with-param></xsl:call-template>
                </xsl:when>
                <xsl:when test="string-length($path_value) &gt; 1">
                    <xsl:value-of select="$path_value"/>
                </xsl:when>
                <xsl:otherwise></xsl:otherwise>
            </xsl:choose>           
        </xsl:variable>        
        <xsl:for-each select="document(@href,/)">
            <xsl:message>path value = <xsl:value-of select="$path_value"></xsl:value-of></xsl:message>
            <xsl:apply-templates select="//*[@xml:id=$id_value]"><xsl:with-param name="path_value" select="$appended_path_value"/></xsl:apply-templates>
        </xsl:for-each>
    </xsl:template>
    
    <!-- Add default footers -->
    
    <xsl:template match="db:info">
        <xsl:param name="path_value"></xsl:param>
        <xsl:element name="info" namespace="http://docbook.org/ns/docbook">
            <xsl:copy-of select="@*"/>
            <xsl:message>path value = <xsl:value-of select="$path_value"></xsl:value-of></xsl:message>
            <xsl:apply-templates ><xsl:with-param name="path_value" select="$path_value"/></xsl:apply-templates>
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
    
    <xsl:template name="form-image-path">
        <xsl:param name="href"></xsl:param>
        <xsl:param name="reformed_path"></xsl:param>
        <xsl:param name="count" select="1"></xsl:param>
        <xsl:variable name="tokenized_path" select="tokenize($href, '/')"/>
        <xsl:variable name="total" select="count($tokenized_path)"></xsl:variable>
        <xsl:message>Count: <xsl:value-of select="$count"/></xsl:message>
        <xsl:choose>
            <xsl:when test="$count = $total"><xsl:value-of select="$reformed_path"/></xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="form-image-path">
                    <xsl:with-param name="reformed_path"><xsl:text>/</xsl:text><xsl:value-of select="$reformed_path"/></xsl:with-param>
                    <xsl:with-param name="count" select="$count + 1"></xsl:with-param>
                    <xsl:with-param name="href" select="$href"></xsl:with-param>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    
</xsl:stylesheet>