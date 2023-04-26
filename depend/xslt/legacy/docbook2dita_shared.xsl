<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
    xmlns:db="http://docbook.org/ns/docbook" xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:svg="http://www.w3.org/2000/svg" xmlns:mml="http://www.w3.org/1998/Math/MathML"
    xmlns:dbx="http://sourceforge.net/projects/docbook/defguide/schema/extra-markup"
    xmlns:ditaarch="http://dita.oasis-open.org/architecture/2005/"
    xmlns:xi="http://www.w3.org/2001/XInclude" xmlns:html="http://www.w3.org/1999/xhtml"
    exclude-result-prefixes="xsl db xlink svg mml dbx xi html">

    <xsl:template match="db:info"/>

    <xsl:template name="generate_numbering">
        <!-- <xsl:number format="1. " level="multiple" count="child::db:section"/>  -->
    </xsl:template>

    <xsl:template name="topic_title">
        <xsl:for-each select="db:title">
            <xsl:choose>
                <xsl:when
                    test="parent::db:table | parent::db:figure | parent::db:example | parent::db:procedure | parent::db:preface">
                    <xsl:element name="title">
                        <xsl:attribute name="class">- topic/title </xsl:attribute>
                        <xsl:call-template name="attribute_manager"/>
                        <xsl:apply-templates/>
                    </xsl:element>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:element name="title">
                        <xsl:attribute name="class">- topic/title </xsl:attribute>
                        <xsl:call-template name="attribute_manager"/>
                        <xsl:call-template name="generate_numbering"/>
                        <xsl:apply-templates/>
                    </xsl:element>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="get_topic_title">
        <xsl:for-each select="db:title">
            <xsl:apply-templates/>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="get_index_topic_title">
        <xsl:for-each select="db:title">
            <xsl:value-of select="."/>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="db:para | db:caption">
        <xsl:element name="p">
            <xsl:attribute name="class">- topic/p </xsl:attribute>
            <xsl:call-template name="attribute_manager"/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="db:title">
        <xsl:choose>
            <xsl:when
                test="parent::db:section | parent::db:appendix | parent::db:preface | parent::db:table | parent::db:example | parent::db:figure"/>
            <xsl:otherwise>
                <xsl:element name="title">
                    <xsl:attribute name="class">- topic/title </xsl:attribute>
                    <xsl:call-template name="attribute_manager"/>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="db:title" mode="resource_list">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="db:abstract">
        <xsl:element name="shortdesc">
            <xsl:attribute name="class">- topic/shortdesc </xsl:attribute>
            <xsl:call-template name="attribute_manager"/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="db:bridgehead">
        <xsl:element name="p">
            <xsl:if test="@xml:id">
                <xsl:attribute name="id">
                    <xsl:call-template name="id_processing"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:attribute name="class">- topic/p </xsl:attribute>
            <xsl:call-template name="attribute_manager"/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="db:sect5">
        <xsl:element name="section">
            <xsl:attribute name="id">
                <xsl:call-template name="id_processing"/>
            </xsl:attribute>
            <xsl:attribute name="class">- topic/section </xsl:attribute>
            <xsl:call-template name="attribute_manager"/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="db:sect1">
        <xsl:element name="section">
            <xsl:attribute name="id">
                <xsl:call-template name="id_processing"/>
            </xsl:attribute>
            <xsl:attribute name="class">- topic/section </xsl:attribute>
            <xsl:call-template name="attribute_manager"/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="db:table">
        <xsl:choose>
            <xsl:when test="ancestor::db:table">
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
                        <xsl:call-template name="topic_title"/>
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
                    <xsl:call-template name="topic_title"/>
                    <xsl:apply-templates/>
                </xsl:element>
                <xsl:call-template name="externalize-tfooters"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="db:informaltable|db:entrytbl">
        <xsl:choose>
            <xsl:when test="ancestor::db:table">
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

    <xsl:template match="db:tgroup">
        <xsl:element name="tgroup">
            <xsl:attribute name="class">- topic/tgroup </xsl:attribute>
            <xsl:attribute name="cols">
                <xsl:value-of select="@cols"/>
            </xsl:attribute>
            <xsl:call-template name="attribute_manager"/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="db:tbody">
        <xsl:element name="tbody">
            <xsl:attribute name="class">- topic/tbody </xsl:attribute>
            <xsl:call-template name="attribute_manager"/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="db:thead">
        <xsl:element name="thead">
            <xsl:attribute name="class">- topic/thead </xsl:attribute>
            <xsl:call-template name="attribute_manager"/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="db:tfoot">
        <!-- tfoots are not part of the DITA CALS table spec, so we're moving the content outside the table with the externalize-tfooters template  -->
        <!-- 
        <xsl:element name="tfoot">
            <xsl:attribute name="class">- topic/tfoot </xsl:attribute>
            <xsl:call-template name="attribute_manager"/>
            <xsl:apply-templates/>
        </xsl:element>  -->
    </xsl:template>

    <xsl:template match="db:row">
        <xsl:choose>
            <xsl:when test="(ancestor::db:informaltable) and (ancestor::db:thead)">
                <xsl:element name="row">
                    <xsl:attribute name="class">- topic/row </xsl:attribute>
                    <xsl:call-template name="attribute_manager"/>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="(ancestor::db:informaltable) and (ancestor::db:tbody)">
                <xsl:element name="row">
                    <xsl:attribute name="class">- topic/row </xsl:attribute>
                    <xsl:call-template name="attribute_manager"/>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="(ancestor::db:table) and (ancestor::db:thead)">
                <xsl:element name="row">
                    <xsl:attribute name="class">- topic/row </xsl:attribute>
                    <xsl:call-template name="attribute_manager"/>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="(ancestor::db:table) and (ancestor::db:tbody)">
                <xsl:element name="row">
                    <xsl:attribute name="class">- topic/row </xsl:attribute>
                    <xsl:call-template name="attribute_manager"/>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="(ancestor::db:entrytbl) and (ancestor::db:thead)">
                <xsl:element name="row">
                    <xsl:attribute name="class">- topic/row </xsl:attribute>
                    <xsl:call-template name="attribute_manager"/>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="(ancestor::db:entrytbl) and (ancestor::db:tbody)">
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
                        <!--Missing options in the db:row
                        template -->
                        <xsl:call-template name="attribute_manager"/>
                    </xsl:element>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="db:entry">
        <xsl:choose>
            <xsl:when test="(ancestor::node() = db:simpletable)">
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

    <xsl:template match="db:colspec">
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

    <xsl:template match="db:spanspec">
        <xsl:element name="spanspec">
            <xsl:copy-of select="@*"/>
            <xsl:attribute name="class">- topic/spanspec </xsl:attribute>
            <xsl:call-template name="attribute_manager"/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="db:caution | db:warning | db:note | db:tip | db:important">
        <xsl:element name="note">
            <xsl:attribute name="class">- topic/note </xsl:attribute>
            <xsl:call-template name="attribute_manager"/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="db:code | db:command | db:filename">
        <xsl:element name="codeph">
            <xsl:attribute name="class">- topic/ph pr-d/codeph </xsl:attribute>
            <xsl:call-template name="attribute_manager"/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="db:example">
        <xsl:element name="example">
            <xsl:attribute name="id">
                <xsl:call-template name="id_processing"/>
            </xsl:attribute>
            <xsl:attribute name="class">- topic/example </xsl:attribute>
            <xsl:call-template name="attribute_manager"/>
            <xsl:call-template name="topic_title"/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="db:footnote">
        <xsl:element name="fn">
            <xsl:attribute name="id">
                <xsl:call-template name="id_processing"/>
            </xsl:attribute>
            <xsl:attribute name="class">- topic/fn </xsl:attribute>
            <xsl:call-template name="attribute_manager"/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="db:footnoteref">
        <xsl:element name="xref">
            <xsl:copy-of select="@*"/>
            <xsl:attribute name="class">- topic/fn </xsl:attribute>
            <xsl:call-template name="attribute_manager"/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="db:figure">
        <xsl:choose>
            <!-- For some odd reason someone embedded a bunch of tables in figures -->
            <xsl:when test="descendant::db:table or descendant::db:informaltable">
                <xsl:for-each select="descendant::db:table |  descendant::db:informaltable">
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
                        <xsl:for-each select="parent::db:figure/@*">
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
                            <xsl:apply-templates select="parent::db:figure/db:title"/>
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
                    <xsl:call-template name="topic_title"/>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>

    <xsl:template match="db:mediaobject | db:imageobject">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="db:imagedata">
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

    <xsl:template match="db:index | db:indexdiv"/>

    <xsl:template match="db:indexentry">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="db:primary">
        <xsl:element name="indexterm">
            <xsl:attribute name="class">- topic/indexterm </xsl:attribute>
            <xsl:call-template name="attribute_manager"/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="db:secondary">
        <xsl:element name="indexterm">
            <xsl:attribute name="class">- topic/indexterm </xsl:attribute>
            <xsl:call-template name="attribute_manager"/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="db:tertiary">
        <xsl:element name="indexterm">
            <xsl:attribute name="class">- topic/indexterm </xsl:attribute>
            <xsl:call-template name="attribute_manager"/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="db:inlinemediaobject">
        <xsl:for-each select="db:imageobject/db:imagedata">
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

    <xsl:template match="db:itemizedlist">
        <xsl:choose>
            <xsl:when test="count(child::db:listitem) &gt; 1">
                <xsl:element name="ul">
                    <xsl:call-template name="attribute_manager"/>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="preceding-sibling::db:itemizedlist[count(child::db:listitem) = 1]"/>
            <xsl:otherwise>
                <xsl:element name="ul">
                    <xsl:call-template name="attribute_manager"/>
                    <xsl:call-template name="itemizedlist-master-processor"/>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="db:orderedlist">
        <xsl:choose>
            <xsl:when test="count(child::db:listitem) &gt; 1">
                <xsl:if test="db:title">
                    <xsl:element name="p">
                        <xsl:attribute name="class">- topic/p </xsl:attribute>
                        <xsl:call-template name="attribute_manager"/>
                        <xsl:value-of select="db:title"/>
                    </xsl:element>
                </xsl:if>
                <xsl:element name="ol">
                    <xsl:attribute name="class">- topic/ol </xsl:attribute>
                    <xsl:call-template name="attribute_manager"/>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="preceding-sibling::db:orderlist[count(child::db:listitem) = 1]"/>
            <xsl:otherwise>
                <xsl:if test="db:title">
                    <xsl:element name="p">
                        <xsl:attribute name="class">- topic/p </xsl:attribute>
                        <xsl:call-template name="attribute_manager"/>
                        <xsl:value-of select="db:title"/>
                    </xsl:element>
                </xsl:if>
                <xsl:element name="ol">
                    <xsl:attribute name="class">- topic/ol </xsl:attribute>
                    <xsl:call-template name="attribute_manager"/>
                    <xsl:call-template name="orderedlist-master-processor"/>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="db:substeps">
        <xsl:if test="db:title">
            <xsl:element name="p">
                <xsl:attribute name="class">- topic/p </xsl:attribute>
                <xsl:call-template name="attribute_manager"/>
                <xsl:value-of select="db:title"/>
            </xsl:element>
        </xsl:if>
        <xsl:element name="ol">
            <xsl:attribute name="class">- topic/ol </xsl:attribute>
            <xsl:call-template name="attribute_manager"/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="db:orderedlist/db:title | db:substeps/db:title"/>

    <xsl:template match="db:procedure">
        <xsl:element name="p">
            <xsl:attribute name="class">- topic/p </xsl:attribute>
            <xsl:call-template name="attribute_manager"/>
            <xsl:element name="b">
                <xsl:attribute name="class">+ topic/ph hi-d/b </xsl:attribute>
                <xsl:value-of select="db:title"/>
            </xsl:element>
        </xsl:element>
        <xsl:element name="ol">
            <xsl:attribute name="class">- topic/ol </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="db:listitem | db:step | db:member">
        <xsl:choose>
            <xsl:when test="parent::db:simplelist">
                <xsl:element name="sli">
                    <xsl:attribute name="class">- topic/sli </xsl:attribute>
                    <xsl:call-template name="attribute_manager"/>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="li">
                    <xsl:attribute name="class">- topic/li </xsl:attribute>
                    <xsl:call-template name="attribute_manager"/>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>

    <xsl:template match="db:phrase">
        <xsl:element name="ph">
            <xsl:attribute name="class">- topic/ph </xsl:attribute>
            <xsl:call-template name="attribute_manager"/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="db:emphasis">
        <xsl:choose>
            <xsl:when test="contains(@role, 'bold')">
                <xsl:element name="b">
                    <xsl:attribute name="class">+ topic/ph hi-d/b </xsl:attribute>
                    <xsl:call-template name="attribute_manager"/>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="i">
                    <xsl:attribute name="class">+ topic/ph hi-d/i </xsl:attribute>
                    <xsl:call-template name="attribute_manager"/>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="db:programlisting">
        <xsl:element name="codeblock">
            <xsl:attribute name="class">- topic/pre topic/codeblock </xsl:attribute>
            <xsl:call-template name="attribute_manager"/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="db:remark">
        <xsl:element name="draft-comment">
            <xsl:attribute name="class">- topic/draft-comment </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="db:simplelist">
        <xsl:element name="sl">
            <xsl:attribute name="class">- topic/sl </xsl:attribute>
            <xsl:call-template name="attribute_manager"/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="db:subscript">
        <xsl:element name="sub">
            <xsl:attribute name="class">- topic/ph hi-d/sub </xsl:attribute>
            <xsl:call-template name="attribute_manager"/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="db:superscript">
        <xsl:element name="sup">
            <xsl:attribute name="class">- topic/ph hi-d/sup </xsl:attribute>
            <xsl:call-template name="attribute_manager"/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="db:subtitle"/>

    <xsl:template match="db:symbol">
        <xsl:element name="ph">
            <xsl:attribute name="class">- topic/ph </xsl:attribute>
            <xsl:call-template name="attribute_manager"/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="db:variablelist">
        <xsl:element name="parml">
            <xsl:call-template name="attribute_manager"/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="db:varlistentry">
        <xsl:element name="plentry">
            <xsl:call-template name="attribute_manager"/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="db:varlistentry/db:term">
        <xsl:element name="pt">
            <xsl:call-template name="attribute_manager"/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="db:varlistentry/db:listitem">
        <xsl:element name="pd">
            <xsl:call-template name="attribute_manager"/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="db:trademark">
        <xsl:element name="tm">
            <xsl:attribute name="class">- topic/tm </xsl:attribute>
            <xsl:call-template name="attribute_manager"/>
            <xsl:attribute name="tmtype">tm</xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <!-- Cross refertences are tricky. In particular, we need to detect if the xref is to the current file, and if so avoid adding the filename. -->

    <xsl:template match="db:xref" priority="1">
        <!-- Grab the ID of the xref endpoint  -->
        <xsl:variable name="temp_id">
            <xsl:value-of select="@linkend"/>
        </xsl:variable>
        <!-- Start forming the Xref  -->
        <xsl:element name="xref">
            <xsl:attribute name="class">- topic/xref </xsl:attribute>
            <xsl:attribute name="href">
                <xsl:choose>
                    <xsl:when
                        test="//db:section[@xml:id=$temp_id] | //db:preface[@xml:id=$temp_id] | //db:appendix[@xml:id=$temp_id] | //db:chapter[@xml:id=$temp_id]">
                        <xsl:variable name="rewritten_id">
                            <xsl:call-template name="id_processing"><xsl:with-param name="link"
                                        ><xsl:value-of select="$temp_id"
                                /></xsl:with-param></xsl:call-template>
                        </xsl:variable>
                        <xsl:value-of select="concat($rewritten_id, '.xml')"/>#<xsl:value-of
                            select="$rewritten_id"/>
                    </xsl:when>
                    <!-- When the xref is not a section, it is an inside join, so we'll have to determine the section element that contains it before we can link to it -->
                    <xsl:otherwise>
                        <xsl:variable name="sections" select="ancestor::db:section[.]"/>
                        <xsl:variable name="current_section" select="$sections[last()]/@xml:id"/>
                        <xsl:call-template name="find_xref_target_parent_section">
                            <xsl:with-param name="temp_id">
                                <xsl:value-of select="$temp_id"/>
                            </xsl:with-param>
                            <xsl:with-param name="current_section">
                                <xsl:value-of select="$current_section"/>
                            </xsl:with-param>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:call-template name="attribute_manager"/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <!-- accept two parameters; the target of the xref and the id of the nearest section/chapter/preface/appendix -->
    <!-- if the target of the xref is the same value as the id of current node, form the xref as an internal link -->
    <!-- if the target of the xref is in a different section, form the xref as pointing to an external target -->

    <xsl:template name="find_xref_target_parent_section">
        <xsl:param name="temp_id"/>
        <xsl:param name="current_section">current_section</xsl:param>
        <xsl:variable name="sections" select="//db:section[descendant::*[@xml:id=$temp_id]]"/>
        <xsl:message>comparing <xsl:value-of select="$sections[last()]/@xml:id"/> and <xsl:value-of
                select="$current_section"/></xsl:message>
        <xsl:choose>
            <xsl:when test="not(//*[@xml:id = $temp_id])">NoMatchingIDFor_<xsl:value-of
                    select="$temp_id"/>.xml</xsl:when>

            <xsl:when test="$sections[last()]/@xml:id = $current_section">#<xsl:call-template
                    name="id_processing">
                    <xsl:with-param name="link"><xsl:value-of select="$current_section"/>
                    </xsl:with-param>
                </xsl:call-template>/<xsl:call-template name="id_processing">
                    <xsl:with-param name="link"><xsl:value-of select="$temp_id"/></xsl:with-param>
                </xsl:call-template>
            </xsl:when>

            <xsl:when test="$current_section = 'current_section'">#<xsl:call-template
                    name="id_processing">
                    <xsl:with-param name="link"><xsl:value-of select="$sections[last()]/@xml:id"/>
                    </xsl:with-param>
                </xsl:call-template>/<xsl:call-template name="id_processing">
                    <xsl:with-param name="link"><xsl:value-of select="$temp_id"/></xsl:with-param>
                </xsl:call-template>
            </xsl:when>

            <xsl:otherwise>
                <xsl:call-template name="id_processing">
                    <xsl:with-param name="link"><xsl:value-of select="$sections[last()]/@xml:id"
                        /></xsl:with-param>
                </xsl:call-template>.xml#<xsl:call-template name="id_processing">
                    <xsl:with-param name="link"><xsl:value-of select="$sections[last()]/@xml:id"
                        /></xsl:with-param>
                </xsl:call-template>/<xsl:call-template name="id_processing">
                    <xsl:with-param name="link"><xsl:value-of select="$temp_id"/>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!--
    <xsl:template name="sanitize_id">
        <xsl:value-of
            select="translate(translate(translate(translate(child::db:title, ':;[]{}~!@#$%^*()?µ\/=ΘΩ≠≥√∑±°&#xA;-.,–‘’-“”&amp;­', '_'), $quot, '_'), $apos, '_'), ' ', '_')"
        />
    </xsl:template>
-->
    <xsl:template name="generate_tablefigureexample_indexentry">
        <xsl:variable name="temp_id">
            <xsl:value-of select="@xml:id"/>
        </xsl:variable>
        <xsl:element name="p">
            <xsl:attribute name="class">- topic/p </xsl:attribute>
            <xsl:element name="indexterm">
                <xsl:attribute name="class">- topic/indexterm </xsl:attribute>
                <xsl:call-template name="attribute_manager"/>
                <xsl:choose>
                    <xsl:when test="//db:procedure[@xml:id=$temp_id]">Procedures</xsl:when>
                    <xsl:when test="//db:table[@xml:id=$temp_id]">Tables</xsl:when>
                    <xsl:when test="//db:figure[@xml:id=$temp_id]">Figures</xsl:when>
                    <xsl:when test="//db:example[@xml:id=$temp_id]">Examples</xsl:when>
                </xsl:choose>
                <xsl:element name="indexterm">
                    <xsl:attribute name="class">- topic/indexterm </xsl:attribute>
                    <xsl:call-template name="attribute_manager"/>
                    <xsl:value-of select="//db:info/db:title"/>
                    <xsl:element name="indexterm">
                        <xsl:attribute name="class">- topic/indexterm </xsl:attribute>
                        <xsl:call-template name="attribute_manager"/>
                        <xsl:choose>
                            <xsl:when test="//db:procedure[@xml:id=$temp_id]">Procedure <xsl:number
                                    select="//db:procedure[@xml:id=$temp_id]" format="001"
                                    level="any" count="db:procedure"/>: <xsl:call-template
                                    name="get_index_topic_title"/></xsl:when>
                            <xsl:when test="//db:table[@xml:id=$temp_id]">Table <xsl:number
                                    select="//db:table[@xml:id=$temp_id]" format="001" level="any"
                                    count="db:table"/>: <xsl:call-template
                                    name="get_index_topic_title"/></xsl:when>
                            <xsl:when test="//db:figure[@xml:id=$temp_id]">Figure <xsl:number
                                    select="//db:figure[@xml:id=$temp_id]" format="001" level="any"
                                    count="db:figure"/>: <xsl:call-template
                                    name="get_index_topic_title"/></xsl:when>
                            <xsl:when test="//db:example[@xml:id=$temp_id]">Example <xsl:number
                                    select="//db:example[@xml:id=$temp_id]" format="001" level="any"
                                    count="db:example"/>: <xsl:call-template
                                    name="get_index_topic_title"/></xsl:when>
                        </xsl:choose>
                    </xsl:element>
                </xsl:element>
            </xsl:element>
        </xsl:element>
    </xsl:template>

    <xsl:template match="db:procedure/db:title"/>

    <!-- INFO element -->

    <xsl:template match="db:info/db:title">
        <xsl:element name="title">
            <xsl:attribute name="class">- topic/title </xsl:attribute>
            <xsl:call-template name="attribute_manager"/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template name="info_element">
        <table class="- topic/table ">
            <tgroup class="- topic/tgroup " cols="4">
                <colspec class="- topic/colspec " colname="_1"/>
                <colspec class="- topic/colspec " colname="_2" colnum="2"/>
                <colspec class="- topic/colspec " colname="_3"/>
                <colspec class="- topic/colspec " colname="_4"/>
                <tbody class="- topic/tbody ">
                    <row class="- topic/row ">
                        <entry class="- topic/entry ">Title:</entry>
                        <entry class="- topic/entry " nameend="_4" namest="_2">
                            <xsl:value-of select="//db:info/db:title"/>
                        </entry>
                    </row>
                    <row class="- topic/row ">
                        <entry class="- topic/entry ">Abstract:</entry>
                        <entry class="- topic/entry " nameend="_4" namest="_2">
                            <xsl:for-each select="db:abstract/db:para">
                                <xsl:element name="p">
                                    <xsl:attribute name="class">- topic/p </xsl:attribute>
                                    <xsl:apply-templates/>
                                </xsl:element>
                            </xsl:for-each>
                        </entry>
                    </row>
                    <row class="- topic/row ">
                        <entry class="- topic/entry ">Document Type:</entry>
                        <entry class="- topic/entry " nameend="_4" namest="_2">
                            <xsl:value-of select="//db:info/db:pmc_doc_type"/>
                        </entry>
                    </row>
                    <row class="- topic/row ">
                        <entry class="- topic/entry ">Marketing No:</entry>
                        <entry class="- topic/entry ">
                            <xsl:value-of select="//db:info/db:pmc_productnumber"/>
                        </entry>
                        <entry class="- topic/entry ">Doc Issue: </entry>
                        <entry class="- topic/entry ">
                            <xsl:value-of select="db:issuenum"/>
                        </entry>
                    </row>
                    <row class="- topic/row ">
                        <entry class="- topic/entry ">Document No:</entry>
                        <entry class="- topic/entry ">
                            <xsl:value-of select="//db:info/db:pmc_document_id"/>
                        </entry>
                        <entry class="- topic/entry ">Issue Date:</entry>
                        <entry class="- topic/entry ">
                            <xsl:value-of select="//db:info/db:pubdate"/>
                        </entry>
                    </row>
                    <row class="- topic/row ">
                        <entry class="- topic/entry ">Keywords</entry>
                        <entry class="- topic/entry " nameend="_4" namest="_2">
                            <xsl:element name="p">
                                <xsl:attribute name="class">- topic/p </xsl:attribute>
                                <xsl:for-each select="//db:info/db:keywords/db:keywords"
                                        ><xsl:value-of select="."/>, </xsl:for-each>
                            </xsl:element>
                        </entry>
                    </row>
                    <row class="- topic/row ">
                        <entry class="- topic/entry ">Patents</entry>
                        <entry class="- topic/entry " nameend="_4" namest="_2">
                            <xsl:for-each select="//db:info/db:pmc_patents/db:para">
                                <xsl:element name="p">
                                    <xsl:attribute name="class">- topic/p </xsl:attribute>
                                    <xsl:apply-templates/>
                                </xsl:element>
                            </xsl:for-each>
                        </entry>
                    </row>
                </tbody>
            </tgroup>
        </table>
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

    <xsl:template match="db:info/*"/>

    <xsl:template match="db:remark" mode="resource_list"/>

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
        <xsl:for-each select="parent::db:figure/@*">
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
        <xsl:for-each select="descendant::db:tfoot/db:row/db:entry">
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
            select="db:listitem | following-sibling::db:itemizedlist[count(child::db:listitem) = 1]/db:listitem"/>
        <xsl:apply-templates select="$itemizedlists"/>
    </xsl:template>

    <xsl:template name="orderedlist-master-processor">
        <xsl:variable name="orderedlists"
            select="db:listitem | following-sibling::db:orderedlist[count(child::db:listitem) = 1]/db:listitem"/>
        <xsl:apply-templates select="$orderedlists"/>
    </xsl:template>


    <xsl:template name="project-converter">
        <xsl:choose>
            <xsl:when test="//db:article/@version = '5.0-extension pmc-1.0-Luxor'">
                <xsl:attribute name="base">Luxor</xsl:attribute>
            </xsl:when>
            <xsl:when test="//db:article/@version = '5.0-extension pmc-1.0-Princeton'">
                <xsl:attribute name="base">Princeton</xsl:attribute>
            </xsl:when>
            <xsl:when test="//db:article/@version = '5.0-extension pmc-1.0-Chiplink'">
                <xsl:attribute name="base">Chiplink</xsl:attribute>
            </xsl:when>
            <xsl:when test="//db:article/@version = '5.0-extension pmc-1.0-WinPath'">
                <xsl:attribute name="base">WIN_WDDI</xsl:attribute>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>
