<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:excel="urn:schemas-microsoft-com:office:spreadsheet"
    xmlns:o="urn:schemas-microsoft-com:office:office"
    xmlns:x="urn:schemas-microsoft-com:office:excel"
    xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"
    xmlns:html="http://www.w3.org/TR/REC-html40" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format" 
    xmlns:math = "http://exslt.org/math" version="2.0">

    <xsl:param name="first-row" select="2"/>

    <xsl:include href="conversionFunctions.xsl"/>

    <xsl:output method="xml" media-type="text/xml" indent="yes" encoding="UTF-8"
        doctype-public="-//Atmel//DTD DITA SIDSC Register//EN"
        doctype-system="atmel-sidsc-register.dtd"/>

    <xsl:variable name="registers" select="/ss:Workbook/ss:Worksheet[@ss:Name = 'Registers']/ss:Table/ss:Row"/>
    
    <xsl:variable name="register-count" select="count($registers)"/>

    <xsl:template match="/">
        <xsl:message>Found <xsl:value-of select="count($registers)"/> registers.</xsl:message>
        <xsl:call-template name="create-registers">
            <xsl:with-param name="starting-value" select="$first-row"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="create-ditamap">
        <xsl:element name="map">
            <xsl:element name="title">Title</xsl:element>
            <xsl:call-template name="create-topicrefs">
                <xsl:with-param name="starting-value" select="3"/>
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
                            <xsl:element name="registerSize">
                                <xsl:variable name="bit-count">
                                    <xsl:choose>
                                        <xsl:when test="$registers[$starting-value]/ss:Cell[3]/@ss:MergeDown">
                                            <xsl:value-of select="$registers[$starting-value]/ss:Cell[3]/@ss:MergeDown"/>
                                        </xsl:when>
                                        <xsl:otherwise>1</xsl:otherwise>
                                    </xsl:choose>
                                </xsl:variable>
                                
                                <xsl:call-template name="find-register-size">
                                    <xsl:with-param name="total-bit-count" select="number($bit-count)"/>
                                    <xsl:with-param name="starting-value" select="$starting-value"/>
                                </xsl:call-template>
                            </xsl:element>
                            <xsl:element name="registerResetValue"/>
                            <xsl:element name="bitOrder"/>
                            <xsl:element name="resetTrig"/>
                        </xsl:element>
                    </xsl:element>
                </xsl:element>
                <xsl:choose>
                    <xsl:when
                        test="normalize-space($registers[$starting-value]/ss:Cell[3]/@ss:MergeDown)">
                        <xsl:call-template name="create-bitfields">
                            <xsl:with-param name="total-bit-count"
                                select="$registers[$starting-value]/ss:Cell[3]/@ss:MergeDown + 1"/>
                            <xsl:with-param name="starting-value" select="$starting-value"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>    <!-- When there's only a single bitfield -->                    
                        <xsl:call-template name="create-bitfields">
                            <xsl:with-param name="total-bit-count"
                                select="1"/>
                            <xsl:with-param name="starting-value" select="$starting-value"/><!-- Starting value is the first line of the register -->
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:element>
        </xsl:result-document>
    </xsl:template>

    <xsl:template name="create-bitfields">
        <xsl:param name="starting-value"/>
        <xsl:param name="current-bit-count" select="0"/>
        <xsl:param name="total-bit-count"/>        
        <xsl:choose>
            <xsl:when test="number($total-bit-count) = 1">
                <xsl:variable name="starting-cell">
                    <xsl:choose>
                        <xsl:when test="$current-bit-count = 0">5</xsl:when>
                        <xsl:otherwise>1</xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:element name="bitField">
                    <xsl:attribute name="id"
                        select="concat(normalize-space($registers[number($starting-value) + number($current-bit-count)]/ss:Cell[number($starting-cell)]), '_', $current-bit-count)"/>
                    <xsl:element name="bitFieldName">
                        <xsl:value-of
                            select="normalize-space($registers[number($starting-value) + number($current-bit-count)]/ss:Cell[number($starting-cell)])"
                        />
                    </xsl:element>
                    <xsl:element name="bitFieldBriefDescription"/>
                    <xsl:element name="bitFieldBody">
                        <xsl:element name="bitFieldDescription">                                                    
                          <!--  <xsl:for-each select="tokenize($registers[number($starting-value) + number($current-bit-count)]/ss:Cell[number($starting-cell) + 16], '\n\r?')[.]">
                                <xsl:element name="codeblock"><xsl:sequence select="."></xsl:sequence></xsl:element>
                            </xsl:for-each>   -->        
                            
                            <xsl:variable name="paragraphs">
                                <xsl:choose>
                                    <xsl:when test="string-length(normalize-space($registers[number($starting-value) + number($current-bit-count)]/ss:Cell[number($starting-cell) + 16])) &gt; 1">
                                        <xsl:value-of select="$registers[number($starting-value) + number($current-bit-count)]/ss:Cell[number($starting-cell) + 16]"/>   
                                    </xsl:when>
                                    <!--<xsl:when test="string-length(normalize-space($registers[number($starting-value) + number($current-bit-count)]/ss:Cell[preceding-sibling::ss:Cell[@ss:Index='20'][1]])) &gt; 1">
                                        <xsl:value-of select="$registers[number($starting-value) + number($current-bit-count)]/ss:Cell[preceding-sibling::ss:Cell[@ss:Index='20'][1]]"/>   
                                    </xsl:when>-->
                                </xsl:choose>                                
                            </xsl:variable>
                            
                            <xsl:variable name="description-lines" select="tokenize($paragraphs, '\n\r?')[.]"/>
                            
                            <xsl:call-template name="generate-content">
                                <xsl:with-param name="count" select="1"></xsl:with-param>
                                <xsl:with-param name="data" select="$description-lines"></xsl:with-param>    
                            </xsl:call-template>    
                            
                        </xsl:element>
                        <xsl:element name="bitFieldProperties">
                            <xsl:element name="bitFieldPropset">
                                <xsl:element name="bitWidth">
                                    <xsl:value-of
                                        select="normalize-space($registers[number($starting-value) + number($current-bit-count)]/ss:Cell[number($starting-cell) + 1])"
                                    />
                                </xsl:element>
                                <xsl:element name="bitOffset">
                                    <xsl:value-of
                                        select="normalize-space($registers[number($starting-value) + number($current-bit-count)]/ss:Cell[number($starting-cell) + 2])"
                                    />
                                </xsl:element>
                                <xsl:element name="bitFieldAccess">
                                    <xsl:value-of
                                        select="normalize-space($registers[number($starting-value) + number($current-bit-count)]/ss:Cell[number($starting-cell) + 3])"
                                    />
                                </xsl:element>
                                <xsl:element name="bitFieldReset">
                                    <xsl:element name="bitFieldResetValue">
                                        <xsl:if
                                            test="string-length(normalize-space($registers[number($starting-value) + number($current-bit-count)]/ss:Cell[number($starting-cell) + 13])) &gt; 0">
                                            <xsl:choose>
                                                <xsl:when
                                                    test="contains(normalize-space($registers[number($starting-value) + number($current-bit-count)]/ss:Cell[number($starting-cell) + 13]), 'b')">
                                                    <xsl:value-of
                                                        select="substring-after(normalize-space($registers[number($starting-value) + number($current-bit-count)]/ss:Cell[number($starting-cell) + 13]), 'b')"
                                                    />
                                                </xsl:when>
                                                <xsl:when
                                                    test="contains(normalize-space($registers[number($starting-value) + number($current-bit-count)]/ss:Cell[number($starting-cell) + 13]), '0x')">
                                                   <xsl:call-template name="math:base-convert">
                                                       <xsl:with-param name="from-base">16</xsl:with-param>
                                                       <xsl:with-param name="to-base">2</xsl:with-param>
                                                       <xsl:with-param name="value" select="number(substring-after(normalize-space($registers[number($starting-value) + number($current-bit-count)]/ss:Cell[number($starting-cell) + 13]), '0x'))"></xsl:with-param>
                                                   </xsl:call-template>
                                                </xsl:when>                                                
                                                <xsl:otherwise>
                                                    <xsl:value-of
                                                        select="normalize-space($registers[number($starting-value) + number($current-bit-count)]/ss:Cell[number($starting-cell) + 13])"
                                                    />
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:if>
                                    </xsl:element>
                                </xsl:element>
                            </xsl:element>
                        </xsl:element>
                    </xsl:element>
                </xsl:element>
            </xsl:when>
            <xsl:when test="$current-bit-count &lt; $total-bit-count">
                <xsl:variable name="starting-cell">
                    <xsl:choose>
                        <xsl:when test="$current-bit-count = 0">5</xsl:when>
                        <xsl:otherwise>1</xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:element name="bitField">
                    <xsl:attribute name="id"
                        select="concat(normalize-space($registers[number($starting-value) + number($current-bit-count)]/ss:Cell[number($starting-cell)]), '_', $current-bit-count)"/>
                    <xsl:element name="bitFieldName">
                        <xsl:value-of
                            select="normalize-space($registers[number($starting-value) + number($current-bit-count)]/ss:Cell[number($starting-cell)])"
                        />
                    </xsl:element>
                    <xsl:element name="bitFieldBriefDescription"/>
                    <xsl:element name="bitFieldBody">
                        <xsl:element name="bitFieldDescription">
                            
                            <xsl:variable name="paragraphs">
                                <xsl:choose>
                                    <xsl:when test="string-length(normalize-space($registers[number($starting-value) + number($current-bit-count)]/ss:Cell[number($starting-cell) + 16])) &gt; 1">
                                        <xsl:value-of select="$registers[number($starting-value) + number($current-bit-count)]/ss:Cell[number($starting-cell) + 16]"/>   
                                    </xsl:when>
                                    <!--<xsl:when test="string-length(normalize-space($registers[number($starting-value) + number($current-bit-count)]/ss:Cell[preceding-sibling::ss:Cell[@ss:Index='20'][1]])) &gt; 1">
                                        <xsl:value-of select="$registers[number($starting-value) + number($current-bit-count)]/ss:Cell[preceding-sibling::ss:Cell[@ss:Index='20'][1]]"/>   
                                    </xsl:when>-->
                                </xsl:choose>                                
                            </xsl:variable>
                           
                            <xsl:variable name="description-lines" select="tokenize($paragraphs, '\n\r?')[.]"/>
                         
                            <xsl:call-template name="generate-content">
                                <xsl:with-param name="count" select="1"></xsl:with-param>
                                <xsl:with-param name="data" select="$description-lines"></xsl:with-param>    
                            </xsl:call-template>    
                            
                        </xsl:element>
                        <xsl:element name="bitFieldProperties">
                            <xsl:element name="bitFieldPropset">
                                <xsl:element name="bitWidth">
                                    <xsl:value-of
                                        select="normalize-space($registers[number($starting-value) + number($current-bit-count)]/ss:Cell[number($starting-cell) + 1])"
                                    />
                                </xsl:element>
                                <xsl:element name="bitOffset">
                                    <xsl:value-of
                                        select="normalize-space($registers[number($starting-value) + number($current-bit-count)]/ss:Cell[number($starting-cell) + 2])"
                                    />
                                </xsl:element>
                                <xsl:element name="bitFieldAccess">
                                    <xsl:value-of
                                        select="normalize-space($registers[number($starting-value) + number($current-bit-count)]/ss:Cell[number($starting-cell) + 3])"
                                    />
                                </xsl:element>
                                <xsl:element name="bitFieldReset">
                                    <xsl:element name="bitFieldResetValue">
                                        <xsl:if
                                            test="string-length(normalize-space($registers[number($starting-value) + number($current-bit-count)]/ss:Cell[number($starting-cell) + 13])) &gt; 0">
                                            <xsl:choose>
                                                <xsl:when
                                                    test="contains(normalize-space($registers[number($starting-value) + number($current-bit-count)]/ss:Cell[number($starting-cell) + 13]), 'b')">
                                                    <xsl:value-of
                                                        select="substring-after(normalize-space($registers[number($starting-value) + number($current-bit-count)]/ss:Cell[number($starting-cell) + 13]), 'b')"
                                                    />
                                                </xsl:when>
                                                <xsl:when
                                                    test="contains(normalize-space($registers[number($starting-value) + number($current-bit-count)]/ss:Cell[number($starting-cell) + 13]), '0x')">
                                                    <xsl:call-template name="math:base-convert">
                                                        <xsl:with-param name="from-base">16</xsl:with-param>
                                                        <xsl:with-param name="to-base">2</xsl:with-param>
                                                        <xsl:with-param name="value" select="number(substring-after(normalize-space($registers[number($starting-value) + number($current-bit-count)]/ss:Cell[number($starting-cell) + 13]), '0x'))"></xsl:with-param>
                                                    </xsl:call-template>
                                                </xsl:when>        
                                                <xsl:otherwise>
                                                    <xsl:value-of
                                                        select="normalize-space($registers[number($starting-value) + number($current-bit-count)]/ss:Cell[number($starting-cell) + 13])"
                                                    />
                                                </xsl:otherwise>
                                            </xsl:choose>
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
                    <xsl:with-param name="starting-value" select="$starting-value"/>
                </xsl:call-template>
            </xsl:when>
            
        </xsl:choose>
        
     </xsl:template>

<xsl:template name="generate-content">
    <xsl:param name="count"/>
    <xsl:param name="data"/>
    <xsl:variable name="data-count" select="count($data)" />
    <xsl:choose>
        <xsl:when test="not(contains($data[$count], '|')) and not(contains($data[$count], '-------'))">            
            <xsl:element name="p"><xsl:value-of select="$data[$count]"/></xsl:element>           
            <xsl:if test="$data-count - $count &gt;= 1">
                <xsl:call-template name="generate-content">
                    <xsl:with-param name="count" select="$count + 1"/>
                    <xsl:with-param name="data" select="$data"/>
                </xsl:call-template>
            </xsl:if>
        </xsl:when>
        <xsl:when test="contains($data[$count], '|') and not(contains($data[$count - 1], '|')) and contains($data[$count + 1], '-----') ">           
            <xsl:message>Found one with a header row!</xsl:message>
             <xsl:element name="simpletable">  
                <xsl:call-template name="generate-header-rows">
                    <xsl:with-param name="count" select="$count"/>
                    <xsl:with-param name="data" select="$data"/>
                </xsl:call-template>               
            </xsl:element>
            <xsl:call-template name="generate-content">
                <xsl:with-param name="count" select="$count + 1"/>
                <xsl:with-param name="data" select="$data"/>
            </xsl:call-template>
        </xsl:when>
        <xsl:when test="contains($data[$count], '|') and not(contains($data[$count - 1], '|')) and not(contains($data[$count - 1], '-----'))">           
            <xsl:message>Found one without a header row!</xsl:message>
            <xsl:element name="simpletable">  
                <xsl:call-template name="generate-stable-rows">
                    <xsl:with-param name="count" select="$count"/>
                    <xsl:with-param name="data" select="$data"/>
                </xsl:call-template>               
            </xsl:element>
            <xsl:call-template name="generate-content">
                <xsl:with-param name="count" select="$count + 1"/>
                <xsl:with-param name="data" select="$data"/>
            </xsl:call-template>
        </xsl:when>      
        <xsl:otherwise>
            <xsl:message>Ball change!</xsl:message>
            <xsl:if test="$data-count - $count &gt;= 1">
                <xsl:call-template name="generate-content">
                    <xsl:with-param name="count" select="$count + 1"/>
                    <xsl:with-param name="data" select="$data"/>
                </xsl:call-template>
            </xsl:if>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>
    
    <xsl:template name="generate-stable-rows">
        <!-- Once this template has been kicked off it should just continue to run until it runs out of rows to process. Every single row will also be processed by the main template, but 
        only the first row with the | character will trigger the creation of a table. When this template fails to detect a | in the next row, it just dies. -->
        <xsl:param name="count"/>
        <xsl:param name="data"/>      
        <xsl:variable name="strow" select="tokenize($data[$count], '\|')"/> 
        <xsl:element name="strow">
            <xsl:for-each select="$strow">
                <xsl:element name="stentry">
                    <xsl:value-of select="."/>
                </xsl:element>
            </xsl:for-each>
        </xsl:element>     
        <xsl:choose>
            <xsl:when test="count($data) &gt;= $count and contains($data[$count + 1], '|') ">
                <!-- Test to see if this is a header row by checking to confirm that it is the first row to have separators and the following row is just - or _  -->
                <xsl:message>Found a follow-up row</xsl:message>
                <xsl:call-template name="generate-stable-rows">
                    <xsl:with-param name="data" select="$data"/>
                    <xsl:with-param name="count" select="$count + 1"/>
                </xsl:call-template>      
            </xsl:when>          
        </xsl:choose>
      
    </xsl:template>
    
    <xsl:template name="generate-header-rows">
        <!-- Once this template has been kicked off it should just continue to run until it runs out of rows to process. Every single row will also be processed by the main template, but 
        only the first row with the | character will trigger the creation of a table. When this template fails to detect a | in the next row, it just dies. -->
        <xsl:param name="count"/>
        <xsl:param name="data"/>      
        <xsl:variable name="strow" select="tokenize($data[$count], '\|')"/> 
        <xsl:element name="sthead">
            <xsl:for-each select="$strow">
                <xsl:element name="stentry">
                    <xsl:value-of select="."/>
                </xsl:element>
            </xsl:for-each>
        </xsl:element>     
        <xsl:choose>
            <xsl:when test="count($data) &gt;= $count and contains($data[$count + 1], '|') ">
                <xsl:call-template name="generate-stable-rows">
                    <xsl:with-param name="data" select="$data"/>
                    <xsl:with-param name="count" select="$count + 1"/>
                </xsl:call-template>      
            </xsl:when>    
            <xsl:when test="count($data) + 1 &gt;= $count and contains($data[$count + 1], '-') ">
                <xsl:call-template name="generate-stable-rows">
                    <xsl:with-param name="data" select="$data"/>
                    <xsl:with-param name="count" select="$count + 2"/>
                </xsl:call-template>      
            </xsl:when>      
        </xsl:choose>        
    </xsl:template>


    <xsl:template name="find-register-size">
    <!--Steps:
        1. Pass through all the bits once, creating a string that is colon and / separated collection of  hash of the offset and bit width.
        2. Once all the bits are processed, tokenize the string on the / and sort them to make the highest offset go first.
        3. Add the highest offset to the width of its bit and use it to determine the widith of the register. -->
        <xsl:param name="starting-value"/>
        <xsl:param name="current-bit-count" select="0"/>
        <xsl:param name="total-bit-count"/>
        <xsl:param name="collected-bits"/>
        <xsl:choose>
            <xsl:when test="$current-bit-count &lt;= $total-bit-count">
                <xsl:variable name="starting-cell">
                    <xsl:choose>
                        <xsl:when test="$current-bit-count = 0">5</xsl:when>
                        <xsl:otherwise>1</xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:variable name="temp-collected-bits"
                    select="concat($collected-bits, '/', normalize-space($registers[number($starting-value) + number($current-bit-count)]/ss:Cell[number($starting-cell) + 2]), ':', normalize-space($registers[number($starting-value) + number($current-bit-count)]/ss:Cell[number($starting-cell) + 1]))"/>
                <xsl:call-template name="find-register-size">
                    <xsl:with-param name="total-bit-count" select="$total-bit-count"/>
                    <xsl:with-param name="current-bit-count" select="$current-bit-count + 1"/>
                    <xsl:with-param name="starting-value" select="$starting-value"/>
                    <xsl:with-param name="collected-bits" select="$temp-collected-bits"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="determine-bit-size">
                    <xsl:with-param name="bit-hash" select="$collected-bits"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="determine-bit-size">
        <xsl:param name="current-bit" select="1"/>
        <xsl:param name="bit-hash"/>
        <xsl:param name="current-high">0:0</xsl:param>
        <xsl:variable name="bits-hashed" select="tokenize(substring-after($bit-hash, '/'), '/')"/>
        <!-- prune the leading \ from the hash and tokenize the rest. -->
        <xsl:variable name="hash-count" select="count($bits-hashed)"/>
        <xsl:choose>
            <xsl:when test="$current-bit &gt; $hash-count">               
                <xsl:call-template name="add-bit-total">
                    <xsl:with-param name="current-high" select="$current-high"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when
                        test="number(substring-before($bits-hashed[$current-bit], ':')) &gt;= number(substring-before($current-high, ':'))">
                        <xsl:call-template name="determine-bit-size">
                            <xsl:with-param name="current-high" select="$bits-hashed[$current-bit]"/>
                            <xsl:with-param name="current-bit" select="$current-bit + 1"/>
                            <xsl:with-param name="bit-hash" select="$bit-hash"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="determine-bit-size">
                            <xsl:with-param name="current-high" select="$current-high"/>
                            <xsl:with-param name="current-bit" select="$current-bit + 1"/>
                            <xsl:with-param name="bit-hash" select="$bit-hash"/>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="add-bit-total">
        <xsl:param name="current-high"/>
        <xsl:variable name="bit-total"
            select="number(substring-before($current-high, ':')) + number(substring-after($current-high, ':'))"/>
        <xsl:choose>
            <xsl:when test="number($bit-total) &gt; 32">63</xsl:when>
            <xsl:when test="number($bit-total) &gt; 16">31</xsl:when>
            <xsl:when test="number($bit-total) &gt; 8">15</xsl:when>
            <xsl:when test="number($bit-total) &gt; 1">7</xsl:when>
            <xsl:otherwise>NO SIZE|<xsl:value-of select="number(substring-before($current-high, ':'))"/>|<xsl:value-of select="number(substring-after($current-high, ':'))"/>|</xsl:otherwise>
        </xsl:choose>
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
