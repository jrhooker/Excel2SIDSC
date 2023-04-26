<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
    xmlns:docbook="http://docbook.org/ns/docbook" xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:svg="http://www.w3.org/2000/svg" xmlns:mml="http://www.w3.org/1998/Math/MathML"
    xmlns:dbx="http://sourceforge.net/projects/docbook/defguide/schema/extra-markup"
    xmlns:ditaarch="http://dita.oasis-open.org/architecture/2005/"
    xmlns:xi="http://www.w3.org/2001/XInclude" xmlns:html="http://www.w3.org/1999/xhtml"
    exclude-result-prefixes="xsl docbook xlink svg mml dbx xi html">

    <xsl:output method="xml" media-type="text/xml" indent="yes" encoding="UTF-8"/>

    <xsl:variable name="quot">"</xsl:variable>
    <xsl:variable name="apos">'</xsl:variable>

    <xsl:template match="/">
        <reg-doc
            xsi:noNamespaceSchemaLocation="/pkg/xmlmind/xmlmind_3.6.2.dist/xmlmind/addon/PMC-Sierra/PMC_RDA3.1/xsds_3_1/reg_doc.xsd"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xmlns:xsd="http://www.w3.org/2001/XMLSchema">
            <xsl:apply-templates/>
        </reg-doc>
    </xsl:template>

    <!-- Remove processing instructions -->

    <xsl:template match="processing-instruction()"/>

    <xsl:template match="docbook:sect1">
        <xsl:call-template name="generate_iso"/>
        <xsl:element name="block">
            <xsl:element name="registers">
                <xsl:for-each select="//docbook:table[contains(@xml:id, 'fieldtable-')]">
                    <xsl:element name="register">
                        <xsl:attribute name="status">show</xsl:attribute>
                        <xsl:element name="reg_address"/>
                        <xsl:element name="reg_name">
                            <xsl:value-of
                                select="substring-after(normalize-space(preceding-sibling::docbook:itemizedlist[1]/docbook:listitem[contains(., 'Name:')][1]), 'Name: ')"
                            />
                        </xsl:element>
                        <xsl:element name="reg_mnemonic">
                            <xsl:value-of
                                select="normalize-space(preceding-sibling::docbook:para[1])"/>
                        </xsl:element>
                        <xsl:element name="reg_description">
                            <xsl:element name="paragraph">
                            <xsl:value-of
                                select="substring-after(normalize-space(preceding-sibling::docbook:itemizedlist[1]/docbook:listitem[contains(., 'Description:')][1]), 'Description: ')"
                            />
                            </xsl:element>
                        </xsl:element>
                        <reg_bits>
                            <xsl:for-each select="docbook:tgroup/docbook:tbody/docbook:row">
                                <xsl:element name="reg_bit">
                                    <xsl:attribute name="status">show</xsl:attribute>
                                    <xsl:element name="bit_position"><xsl:value-of select="docbook:entry[1]"/></xsl:element>
                                    <xsl:element name="bit_type">
                                        <xsl:call-template name="set_bit_type"></xsl:call-template>
                                        <xsl:value-of select="normalize-space(docbook:entry[3])"/>
                                    </xsl:element>
                                    <xsl:element name="bit_name"><xsl:value-of select="docbook:entry[2]"/></xsl:element>
                                    <xsl:element name="bit_default"><xsl:call-template name="find_bit_default"></xsl:call-template></xsl:element>
                                    <xsl:element name="bit_description"><xsl:apply-templates select="docbook:entry[4]/*"/></xsl:element>
                                </xsl:element>
                            </xsl:for-each>
                        </reg_bits>
                    </xsl:element>
                </xsl:for-each>
            </xsl:element>
        </xsl:element>
    </xsl:template>

    <xsl:template match="docbook:info"/>


    <xsl:template match="docbook:para | docbook:caption">
        <xsl:element name="paragraph">            
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="docbook:para[@role='BLANK']"/>   
    
    <xsl:template match="docbook:title">
        <xsl:choose>
            <xsl:when
                test="parent::docbook:section | parent::docbook:appendix | parent::docbook:preface | parent::docbook:table | parent::docbook:example | parent::docbook:figure"/>
            <xsl:otherwise>
                <xsl:element name="title">
                    <xsl:attribute name="class">- topic/title </xsl:attribute>
                    <xsl:call-template name="attribute_manager"/>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="docbook:title" mode="resource_list">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="docbook:abstract">
        <xsl:element name="shortdesc">
            <xsl:attribute name="class">- topic/shortdesc </xsl:attribute>
            <xsl:call-template name="attribute_manager"/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="docbook:bridgehead">
        <xsl:element name="paragraph">            
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="docbook:sect5">
        <xsl:element name="section">
            <xsl:attribute name="id">
                <xsl:call-template name="id_processing"/>
            </xsl:attribute>
            <xsl:attribute name="class">- topic/section </xsl:attribute>
            <xsl:call-template name="attribute_manager"/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="docbook:table">
        <xsl:choose>
            <xsl:when test="ancestor::docbook:table">
                <xsl:element name="p">
                    <xsl:call-template name="attribute_manager"/>
                    <xsl:element name="table">
                        <xsl:if test="@xml:id">
                            <xsl:attribute name="id">
                                <xsl:call-template name="id_processing"/>
                            </xsl:attribute>
                        </xsl:if>
                        <xsl:attribute name="class">- topic/table </xsl:attribute>
                        <xsl:attribute name="otherprops">
                            <xsl:number format="1" level="any"/>
                        </xsl:attribute>
                        <!--<xsl:call-template name="topic_title"/>-->
                        <xsl:apply-templates/>
                    </xsl:element>
                </xsl:element>
                <xsl:call-template name="externalize-tfooters"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="table">
                    <xsl:if test="@xml:id">
                        <xsl:attribute name="id">
                            <xsl:call-template name="id_processing"/>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:attribute name="class">- topic/table </xsl:attribute>
                    <xsl:call-template name="attribute_manager"/>
                    <!--<xsl:call-template name="topic_title"/>-->
                    <xsl:apply-templates/>
                </xsl:element>
                <xsl:call-template name="externalize-tfooters"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="docbook:informaltable|docbook:entrytbl">
        <xsl:choose>
            <xsl:when test="ancestor::docbook:table">
                <xsl:element name="p">
                    <xsl:call-template name="attribute_manager"/>
                    <xsl:element name="table">
                        <xsl:if test="@xml:id">
                            <xsl:attribute name="id">
                                <xsl:call-template name="id_processing"/>
                            </xsl:attribute>
                        </xsl:if>
                        <xsl:attribute name="class">- topic/table </xsl:attribute>
                        <xsl:element name="title"/>
                        <xsl:apply-templates/>
                    </xsl:element>
                </xsl:element>
                <xsl:call-template name="externalize-tfooters"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="table">
                    <xsl:if test="@xml:id">
                        <xsl:attribute name="id">
                            <xsl:call-template name="id_processing"/>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:attribute name="class">- topic/table </xsl:attribute>
                    <xsl:call-template name="attribute_manager"/>
                    <xsl:element name="title"/>
                    <xsl:apply-templates/>
                </xsl:element>
                <xsl:call-template name="externalize-tfooters"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="docbook:tgroup">
        <xsl:element name="tgroup">
            <xsl:attribute name="class">- topic/tgroup </xsl:attribute>
            <xsl:attribute name="cols">
                <xsl:value-of select="@cols"/>
            </xsl:attribute>
            <xsl:call-template name="attribute_manager"/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="docbook:tbody">
        <xsl:element name="tbody">
            <xsl:attribute name="class">- topic/tbody </xsl:attribute>
            <xsl:call-template name="attribute_manager"/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="docbook:thead">
        <xsl:element name="thead">
            <xsl:attribute name="class">- topic/thead </xsl:attribute>
            <xsl:call-template name="attribute_manager"/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="docbook:tfoot">
        <!-- tfoots are not part of the DITA CALS table spec, so we're moving the content outside the table with the externalize-tfooters template  -->
        <!-- 
        <xsl:element name="tfoot">
            <xsl:attribute name="class">- topic/tfoot </xsl:attribute>
            <xsl:call-template name="attribute_manager"/>
            <xsl:apply-templates/>
        </xsl:element>  -->
    </xsl:template>

    <xsl:template match="docbook:row">
        <xsl:choose>
            <xsl:when test="(ancestor::docbook:informaltable) and (ancestor::docbook:thead)">
                <xsl:element name="row">
                    <xsl:attribute name="class">- topic/row </xsl:attribute>
                    <xsl:call-template name="attribute_manager"/>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="(ancestor::docbook:informaltable) and (ancestor::docbook:tbody)">
                <xsl:element name="row">
                    <xsl:attribute name="class">- topic/row </xsl:attribute>
                    <xsl:call-template name="attribute_manager"/>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="(ancestor::docbook:table) and (ancestor::docbook:thead)">
                <xsl:element name="row">
                    <xsl:attribute name="class">- topic/row </xsl:attribute>
                    <xsl:call-template name="attribute_manager"/>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="(ancestor::docbook:table) and (ancestor::docbook:tbody)">
                <xsl:element name="row">
                    <xsl:attribute name="class">- topic/row </xsl:attribute>
                    <xsl:call-template name="attribute_manager"/>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="(ancestor::docbook:entrytbl) and (ancestor::docbook:thead)">
                <xsl:element name="row">
                    <xsl:attribute name="class">- topic/row </xsl:attribute>
                    <xsl:call-template name="attribute_manager"/>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="(ancestor::docbook:entrytbl) and (ancestor::docbook:tbody)">
                <xsl:element name="row">
                    <xsl:attribute name="class">- topic/row </xsl:attribute>
                    <xsl:call-template name="attribute_manager"/>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="row">
                    <xsl:attribute name="class">- topic/row </xsl:attribute>
                    <xsl:call-template name="attribute_manager"/>
                    <xsl:apply-templates/>
                    <xsl:element name="entry">
                        <xsl:attribute name="class">- topic/entry </xsl:attribute>
                        <!--Missing options in the docbook:row
                        template -->
                        <xsl:call-template name="attribute_manager"/>
                    </xsl:element>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="docbook:entry">
        <xsl:choose>
            <xsl:when test="(ancestor::node() = docbook:simpletable)">
                <xsl:element name="entry">
                    <xsl:if test="@nameend">
                        <xsl:copy-of select="@nameend"/>
                    </xsl:if>
                    <xsl:if test="@namest">
                        <xsl:copy-of select="@namest"/>
                    </xsl:if>
                    <xsl:if test="@morerows">
                        <xsl:copy-of select="@morerows"/>
                    </xsl:if>
                    <xsl:attribute name="class">- topic/entry </xsl:attribute>
                    <xsl:call-template name="attribute_manager"/>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="entry">
                    <xsl:if test="@nameend">
                        <xsl:copy-of select="@nameend"/>
                    </xsl:if>
                    <xsl:if test="@namest">
                        <xsl:copy-of select="@namest"/>
                    </xsl:if>
                    <xsl:if test="@morerows">
                        <xsl:copy-of select="@morerows"/>
                    </xsl:if>
                    <xsl:if test="@spanname">
                        <xsl:copy-of select="@spanname"/>
                    </xsl:if>
                    <xsl:attribute name="class">- topic/entry </xsl:attribute>
                    <xsl:call-template name="attribute_manager"/>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="docbook:colspec">
        <xsl:element name="colspec">
            <xsl:copy-of select="@*"/>
            <xsl:if test="@colwidth">
                <xsl:choose>
                    <xsl:when test="contains(@colwidth, 'in')">
                        <xsl:attribute name="colwidth">
                            <xsl:value-of select="@colwidth"/>
                        </xsl:attribute>
                    </xsl:when>
                    <xsl:when test="contains(@colwidth, 'cm')">
                        <xsl:attribute name="colwidth">
                            <xsl:value-of select="@colwidth"/>
                        </xsl:attribute>
                    </xsl:when>
                    <xsl:when test="contains(@colwidth, 'mm')">
                        <xsl:attribute name="colwidth">
                            <xsl:value-of select="@colwidth"/>
                        </xsl:attribute>
                    </xsl:when>
                    <xsl:when test="contains(@colwidth, 'px')">
                        <xsl:attribute name="colwidth">
                            <xsl:value-of select="@colwidth"/>
                        </xsl:attribute>
                    </xsl:when>
                </xsl:choose>
            </xsl:if>
            <xsl:attribute name="class">- topic/colspec </xsl:attribute>
            <xsl:call-template name="attribute_manager"/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="docbook:spanspec">
        <xsl:element name="spanspec">
            <xsl:copy-of select="@*"/>
            <xsl:attribute name="class">- topic/spanspec </xsl:attribute>
            <xsl:call-template name="attribute_manager"/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template
        match="docbook:caution | docbook:warning | docbook:note | docbook:tip | docbook:important">
        <xsl:element name="note">
            <xsl:attribute name="class">- topic/note </xsl:attribute>
            <xsl:call-template name="attribute_manager"/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="docbook:code | docbook:command | docbook:filename">
        <xsl:element name="codeph">
            <xsl:attribute name="class">- topic/ph pr-d/codeph </xsl:attribute>
            <xsl:call-template name="attribute_manager"/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="docbook:example">
        <xsl:element name="example">
            <xsl:attribute name="id">
                <xsl:call-template name="id_processing"/>
            </xsl:attribute>
            <xsl:attribute name="class">- topic/example </xsl:attribute>
            <xsl:call-template name="attribute_manager"/>
            <!--<xsl:call-template name="topic_title"/>-->
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="docbook:footnote">
        <xsl:element name="fn">
            <xsl:attribute name="id">
                <xsl:call-template name="id_processing"/>
            </xsl:attribute>
            <xsl:attribute name="class">- topic/fn </xsl:attribute>
            <xsl:call-template name="attribute_manager"/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="docbook:footnoteref">
        <xsl:element name="xref">
            <xsl:copy-of select="@*"/>
            <xsl:attribute name="class">- topic/fn </xsl:attribute>
            <xsl:call-template name="attribute_manager"/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="docbook:figure">
        <xsl:choose>
            <!-- For some odd reason someone embedded a bunch of tables in figures -->
            <xsl:when test="descendant::docbook:table or descendant::docbook:informaltable">
                <xsl:for-each
                    select="descendant::docbook:table |  descendant::docbook:informaltable">
                    <xsl:element name="table">
                        <xsl:for-each select="@*">
                            <xsl:if test="name() = 'xml:id'">
                                <xsl:attribute name="id">
                                    <xsl:value-of select="."/>
                                </xsl:attribute>
                            </xsl:if>
                            <xsl:if test="not(name() = 'xml:id')">
                                <xsl:copy/>
                            </xsl:if>
                        </xsl:for-each>
                        <xsl:for-each select="parent::docbook:figure/@*">
                            <xsl:if test="name() = 'xml:id'">
                                <xsl:attribute name="id">
                                    <xsl:value-of select="."/>
                                </xsl:attribute>
                            </xsl:if>
                            <xsl:if test="not(name() = 'xml:id')">
                                <xsl:copy/>
                            </xsl:if>
                        </xsl:for-each>
                        <xsl:if test="@xml:id">
                            <xsl:attribute name="id">
                                <xsl:call-template name="id_processing"/>
                            </xsl:attribute>
                        </xsl:if>
                        <xsl:call-template name="attribute_manager_figuretables"/>
                        <xsl:element name="title">
                            <xsl:apply-templates select="parent::docbook:figure/docbook:title"/>
                        </xsl:element>
                        <xsl:apply-templates select="./*"/>
                    </xsl:element>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="fig">
                    <xsl:if test="@xml:id">
                        <xsl:attribute name="id">
                            <xsl:call-template name="id_processing"/>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:attribute name="class">- topic/fig </xsl:attribute>
                    <xsl:call-template name="attribute_manager"/>
                    <!--<xsl:call-template name="topic_title"/>-->
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>

    <xsl:template match="docbook:mediaobject | docbook:imageobject">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="docbook:imagedata">
        <xsl:element name="image">
            <xsl:attribute name="class">- topic/image </xsl:attribute>
            <xsl:attribute name="placement">break</xsl:attribute>
            <xsl:call-template name="attribute_manager"/>
            <xsl:if test="@width or @depth">
                <xsl:choose>
                    <xsl:when test="contains(@width, 'in')">
                        <xsl:variable name="temp" select="substring-before(@width, 'in')"/>
                        <xsl:attribute name="width"><xsl:value-of select="number($temp) * 72"
                            />px</xsl:attribute>
                    </xsl:when>
                    <xsl:when test="contains(@width, 'cm')">
                        <xsl:variable name="temp" select="substring-before(@width, 'cm')"/>
                        <xsl:attribute name="width"><xsl:value-of select="number($temp) * 39"
                            />px</xsl:attribute>
                    </xsl:when>
                    <xsl:when test="contains(@width, 'mm')">
                        <xsl:variable name="temp" select="substring-before(@width, 'mm')"/>
                        <xsl:attribute name="width"><xsl:value-of select="number($temp) * 3.9"
                            />px</xsl:attribute>
                    </xsl:when>
                    <xsl:when test="@width">
                        <xsl:variable name="temp" select="@width"/>
                        <xsl:attribute name="width"><xsl:value-of select="number($temp)"
                            />px</xsl:attribute>
                    </xsl:when>
                    <xsl:when test="contains(@depth, 'in')">
                        <xsl:variable name="temp" select="substring-before(@depth, 'in')"/>
                        <xsl:attribute name="height"><xsl:value-of select="number($temp) * 72"
                            />px</xsl:attribute>
                    </xsl:when>
                    <xsl:when test="contains(@depth, 'cm')">
                        <xsl:variable name="temp" select="substring-before(@depth, 'cm')"/>
                        <xsl:attribute name="height"><xsl:value-of select="number($temp) * 39"
                            />px</xsl:attribute>
                    </xsl:when>
                    <xsl:when test="contains(@depth, 'mm')">
                        <xsl:variable name="temp" select="substring-before(@depth, 'mm')"/>
                        <xsl:attribute name="height"><xsl:value-of select="number($temp) * 3.9"
                            />px</xsl:attribute>
                    </xsl:when>
                    <xsl:when test="@depth">
                        <xsl:variable name="temp" select="@depth"/>
                        <xsl:attribute name="height"><xsl:value-of select="number($temp)"
                            />px</xsl:attribute>
                    </xsl:when>
                </xsl:choose>
            </xsl:if>
            <xsl:attribute name="href" select="@fileref"/>
            <!-- <xsl:attribute name="href">
                <xsl:choose>
                    <xsl:when test="contains(@fileref, '../../../')">
                        <xsl:value-of select="substring-after(@fileref, '../../../')"/>
                    </xsl:when>
                    <xsl:when test="contains(@fileref, '../../')">
                        <xsl:value-of select="substring-after(@fileref, '../../')"/>
                    </xsl:when>
                    <xsl:when test="contains(@fileref, '../')">
                        <xsl:value-of select="substring-after(@fileref, '../')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="@fileref"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute> -->
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="docbook:index | docbook:indexdiv"/>

    <xsl:template match="docbook:indexentry">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="docbook:primary">
        <xsl:element name="indexterm">
            <xsl:attribute name="class">- topic/indexterm </xsl:attribute>
            <xsl:call-template name="attribute_manager"/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="docbook:secondary">
        <xsl:element name="indexterm">
            <xsl:attribute name="class">- topic/indexterm </xsl:attribute>
            <xsl:call-template name="attribute_manager"/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="docbook:tertiary">
        <xsl:element name="indexterm">
            <xsl:attribute name="class">- topic/indexterm </xsl:attribute>
            <xsl:call-template name="attribute_manager"/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="docbook:inlinemediaobject">
        <xsl:for-each select="docbook:imageobject/docbook:imagedata">
            <xsl:element name="image">
                <xsl:attribute name="class">- topic/image </xsl:attribute>
                <xsl:attribute name="placement">inline</xsl:attribute>
                <xsl:attribute name="href" select="@fileref"/>
                <!--<xsl:attribute name="href">
                    <xsl:choose>
                        <xsl:when test="contains(@fileref, '../../../')">
                            <xsl:value-of select="substring-after(@fileref, '../../../')"/>
                        </xsl:when>
                        <xsl:when test="contains(@fileref, '../../')">
                            <xsl:value-of select="substring-after(@fileref, '../../')"/>
                        </xsl:when>
                        <xsl:when test="contains(@fileref, '../')">
                            <xsl:value-of select="substring-after(@fileref, '../')"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="@fileref"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:attribute>-->
                <xsl:call-template name="attribute_manager"/>
                <xsl:if test="@width or @depth">
                    <xsl:choose>
                        <xsl:when test="contains(@width, 'in')">
                            <xsl:attribute name="width"><xsl:value-of
                                    select="number(substring-before(@width, 'in')) * 200"
                                />px</xsl:attribute>
                        </xsl:when>
                        <xsl:when test="contains(@width, 'cm')">
                            <xsl:attribute name="width"><xsl:value-of
                                    select="number(substring-before(@width, 'cm')) * 70"
                                />px</xsl:attribute>
                        </xsl:when>
                        <xsl:when test="contains(@width, 'mm')">
                            <xsl:attribute name="width"><xsl:value-of
                                    select="number(substring-before(@width, 'mm')) * 7"
                                />px</xsl:attribute>
                        </xsl:when>
                        <xsl:when test="contains(@depth, 'in')">
                            <xsl:attribute name="height"><xsl:value-of
                                    select="number(substring-before(@width, 'in')) * 200"
                                />px</xsl:attribute>
                        </xsl:when>
                        <xsl:when test="contains(@depth, 'cm')">
                            <xsl:attribute name="height"><xsl:value-of
                                    select="number(substring-before(@width, 'cm')) * 70"
                                />px</xsl:attribute>
                        </xsl:when>
                        <xsl:when test="contains(@depth, 'mm')">
                            <xsl:attribute name="height"><xsl:value-of
                                    select="number(substring-before(@width, 'mm')) * 7"
                                />px</xsl:attribute>
                        </xsl:when>
                    </xsl:choose>
                </xsl:if>
                <xsl:apply-templates/>
            </xsl:element>
        </xsl:for-each>
    </xsl:template>

    <!-- The XMLmind paste-from-word feature seems to turn bulleted lists in  a whole bunch of lists 
     with a single bullet each. The following templates or itemizedlist and orderedlist re-create 
     the original list. -->

    <xsl:template match="docbook:itemizedlist">
        <xsl:choose>
            <xsl:when test="count(child::docbook:listitem) &gt; 1">
                <xsl:element name="ul">
                    <xsl:call-template name="attribute_manager"/>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:when
                test="preceding-sibling::docbook:itemizedlist[count(child::docbook:listitem) = 1]"/>
            <xsl:otherwise>
                <xsl:element name="ul">
                    <xsl:call-template name="attribute_manager"/>
                    <xsl:call-template name="itemizedlist-master-processor"/>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="docbook:orderedlist">       
                    <xsl:apply-templates/>               
    </xsl:template>

    <xsl:template match="docbook:substeps">      
            <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="docbook:orderedlist/docbook:title | docbook:substeps/docbook:title"/>

    <xsl:template match="docbook:procedure">     
            <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="docbook:listitem | docbook:step | docbook:member">   
                    <xsl:apply-templates/>                
    </xsl:template>

    <xsl:template match="docbook:phrase">      
            <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="docbook:emphasis">       
                    <xsl:apply-templates/>                
    </xsl:template>

    <xsl:template match="docbook:programlisting">       
            <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="docbook:remark">
        
    </xsl:template>

    <xsl:template match="docbook:simplelist">      
            <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="docbook:subscript">     
            <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="docbook:superscript">      
            <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="docbook:subtitle"/>

    <xsl:template match="docbook:symbol">     
            <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="docbook:variablelist">      
            <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="docbook:varlistentry">
        <xsl:element name="paragraph">         
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="docbook:varlistentry/docbook:term">       
            <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="docbook:varlistentry/docbook:listitem">       
            <xsl:apply-templates/>        
    </xsl:template>

    <xsl:template match="docbook:trademark">
                   <xsl:apply-templates/>
    </xsl:template>

    <!-- Cross refertences are tricky. In particular, we need to detect if the xref is to the current file, and if so avoid adding the filename. -->

 

    <xsl:template match="docbook:procedure/docbook:title"/>

    <!-- INFO element -->

    <xsl:template match="docbook:info/docbook:title">
        <xsl:element name="title">
            <xsl:attribute name="class">- topic/title </xsl:attribute>
            <xsl:call-template name="attribute_manager"/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="@colwidth">
        <xsl:attribute name="colwidth">
            <xsl:value-of select="substring-before(@colwidth, 'in') * 92"/>
        </xsl:attribute>
    </xsl:template>

    <xsl:template name="generate_prolog">
        <!-- <xsl:if test="@xml:id">
            <xsl:element name="prolog">
                <xsl:attribute name="class">- topic/prolog </xsl:attribute>
                <xsl:element name="data">
                    <xsl:attribute name="class">- topic/data </xsl:attribute>
                    <xsl:attribute name="type">pdf_name</xsl:attribute>
                    <xsl:attribute name="id"><xsl:value-of select="@xml:id"/></xsl:attribute>
                </xsl:element>
            </xsl:element>
        </xsl:if> -->
    </xsl:template>

    <xsl:template match="docbook:info/*"/>

    <xsl:template match="docbook:remark" mode="resource_list"/>

    <!-- Manage attributes -->

    <xsl:template name="attribute_manager">
        <xsl:for-each select="@*">
            <xsl:choose>
                <xsl:when test="name(.) = 'audience'">
                    <xsl:attribute name="audience">
                        <xsl:value-of select="translate(., ';', ' ')"/>
                    </xsl:attribute>
                </xsl:when>
                <xsl:when test="name(.) = 'arch'">
                    <xsl:attribute name="product">
                        <xsl:value-of select="translate(., ';', ' ')"/>
                    </xsl:attribute>
                </xsl:when>
                <xsl:when test="name(.) = 'document'">
                    <xsl:attribute name="props">
                        <xsl:value-of select="translate(., ';', ' ')"/>
                    </xsl:attribute>
                </xsl:when>
                <xsl:when test="name(.) = 'role'">
                    <xsl:attribute name="otherprops">
                        <xsl:value-of select="translate(., ';', ' ')"/>
                    </xsl:attribute>
                </xsl:when>
            </xsl:choose>
        </xsl:for-each>
        <xsl:if test="@xml:id">
            <xsl:attribute name="id">
                <xsl:call-template name="id_processing"/>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>

    <!-- for some bizarre reason, someone nested a bunch of tables in figure elements. This is just me busting them out. -->

    <xsl:template name="attribute_manager_figuretables">
        <xsl:for-each select="parent::docbook:figure/@*">
            <xsl:choose>
                <xsl:when test="name(.) = 'audience'">
                    <xsl:attribute name="audience">
                        <xsl:value-of select="translate(., ';', ' ')"/>
                    </xsl:attribute>
                </xsl:when>
                <xsl:when test="name(.) = 'arch'">
                    <xsl:attribute name="product">
                        <xsl:value-of select="translate(., ';', ' ')"/>
                    </xsl:attribute>
                </xsl:when>
                <xsl:when test="name(.) = 'document'">
                    <xsl:attribute name="props">
                        <xsl:value-of select="translate(., ';', ' ')"/>
                    </xsl:attribute>
                </xsl:when>
                <xsl:when test="name(.) = 'role'">
                    <xsl:attribute name="otherprops">
                        <xsl:value-of select="translate(., ';', ' ')"/>
                    </xsl:attribute>
                </xsl:when>
            </xsl:choose>
        </xsl:for-each>
        <xsl:call-template name="id_processing"/>
    </xsl:template>

    <!-- manage tfooters, which are not allowed in the DITA version of CALS tables. Call this template immediately after processing the table itself -->

    <xsl:template name="externalize-tfooters">
        <xsl:for-each select="descendant::docbook:tfoot/docbook:row/docbook:entry">
            <xsl:apply-templates/>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="id_processing">
        <xsl:param name="link">default</xsl:param>
        <xsl:variable name="link_2">
            <xsl:choose>
                <xsl:when test="$link = 'default'">
                    <xsl:value-of select="@xml:id"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$link"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:choose>
            <xsl:when test="contains($link_2, 'section_')">
                <xsl:value-of select="substring-after($link_2, 'section_')"/>
            </xsl:when>
            <xsl:when test="contains($link_2, 'table_')">
                <xsl:value-of select="substring-after($link_2, 'table_')"/>
            </xsl:when>
            <xsl:when test="contains($link_2, 'figure_')">
                <xsl:value-of select="substring-after($link_2, 'figure_')"/>
            </xsl:when>
            <xsl:when test="contains($link_2, 'informaltable_')">
                <xsl:value-of select="substring-after($link_2, 'informaltable_')"/>
            </xsl:when>
            <xsl:when test="contains($link_2, 'listitem_')">
                <xsl:value-of select="substring-after($link_2, 'listitem_')"/>
            </xsl:when>
            <xsl:when test="contains($link_2, 'itemizedlist_')">
                <xsl:value-of select="substring-after($link_2, 'itemizedlist_')"/>
            </xsl:when>
            <xsl:when test="contains($link_2, 'orderedlist_')">
                <xsl:value-of select="substring-after($link_2, 'orderedlist_')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$link_2"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- Process itemized listed to remove the sheer volume of single-item lists found in projects converted from Word -->
    <!-- The following template should grab any following siblings of the current itemizedlist  and process them as a part of the curret list. -->

    <xsl:template name="itemizedlist-master-processor">
        <xsl:variable name="itemizedlists"
            select="docbook:listitem | following-sibling::docbook:itemizedlist[count(child::docbook:listitem) = 1]/docbook:listitem"/>
        <xsl:apply-templates select="$itemizedlists"/>
    </xsl:template>

    <xsl:template name="orderedlist-master-processor">
        <xsl:variable name="orderedlists"
            select="docbook:listitem | following-sibling::docbook:orderedlist[count(child::docbook:listitem) = 1]/docbook:listitem"/>
        <xsl:apply-templates select="$orderedlists"/>
    </xsl:template>


    <xsl:template name="generate_iso">
        <xsl:element name="iso_data">
            <xsl:element name="title">
                <xsl:value-of select="substring-before(docbook:title, ' Register Details')"/>
            </xsl:element>
        </xsl:element>
    </xsl:template>

<xsl:template name="find_bit_default">
    <xsl:choose>
        <xsl:when test="docbook:entry[4]/docbook:para[contains(., 'Value After Reset:')]">
            <xsl:value-of select="normalize-space(substring-after(docbook:entry[4]/docbook:para[contains(., 'Value After Reset:')][1], 'Value After Reset:'))"/>            
        </xsl:when>
        <xsl:when test="docbook:entry[4]/docbook:para[contains(., 'Reset Value:')]">
            <xsl:value-of select="normalize-space(substring-after(docbook:entry[4]/docbook:para[contains(., 'Reset Value:')][1], 'Reset Value:'))"/>
        </xsl:when>
        <xsl:when test="docbook:entry[4]/docbook:para[contains(., 'Value:')]">
            <xsl:value-of select="normalize-space(substring-after(docbook:entry[4]/docbook:para[contains(., 'Value:')][1], 'Value:'))"/>
        </xsl:when>        
        <xsl:otherwise>UNKNOWN_NEEDS_MANUAL_FIX</xsl:otherwise>            
    </xsl:choose>
</xsl:template>

    <xsl:template name="set_bit_type">       
        <xsl:choose>
            <xsl:when test="contains(normalize-space(docbook:entry[3]), 'R/W')">
                <xsl:attribute name="action">config</xsl:attribute>
                <xsl:attribute name="side_effect">none</xsl:attribute>
            </xsl:when>
            <xsl:when test="contains(normalize-space(docbook:entry[3]), 'W')">
                <xsl:attribute name="action">config</xsl:attribute>
                <xsl:attribute name="side_effect">none</xsl:attribute>
            </xsl:when>
            <xsl:when test="contains(normalize-space(docbook:entry[3]), 'R')">
                <xsl:attribute name="action">status</xsl:attribute>
                <xsl:attribute name="side_effect">none</xsl:attribute>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>
