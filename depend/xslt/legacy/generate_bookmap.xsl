<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
    xmlns:db="http://docbook.org/ns/docbook" xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:svg="http://www.w3.org/2000/svg" xmlns:mml="http://www.w3.org/1998/Math/MathML"
    xmlns:dbx="http://sourceforge.net/projects/docbook/defguide/schema/extra-markup"
    xmlns:ditaarch="http://dita.oasis-open.org/architecture/2005/"
    xmlns:xi="http://www.w3.org/2001/XInclude" xmlns:html="http://www.w3.org/1999/xhtml"
    exclude-result-prefixes="xsl db xlink svg mml dbx xi html">

    <!-- This stylesheet takes a PMC article and flips it into a DITA bookmap. The next stylesheet will take the content of the article and generate topics that connect to the bookmap -->

    <xsl:variable name="quot">"</xsl:variable>
    <xsl:variable name="apos">'</xsl:variable>

    <xsl:output method="xml" media-type="text/xml" indent="yes" encoding="UTF-8"
        doctype-public="-//OASIS//DTD DITA BookMap//EN"
        doctype-system="bookmap.dtd"/>

    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>

    <!-- Remove processing instructions -->

    <xsl:template match="processing-instruction()"/>
    
    <xsl:template match="db:cover"/>

    <!-- Turn the info element into pmc_iso elements -->
    <xsl:template name="info_element">
        <xsl:for-each select="db:info">
            <xsl:element name="bookmeta">
                <xsl:attribute name="class">- map/topicmeta bookmap/bookmeta </xsl:attribute>
                <xsl:element name="pmc_iso">
                    <xsl:attribute name="class"> + bookmap/pmc_iso </xsl:attribute>
                    <xsl:call-template name="attribute_manager"/>
                    <xsl:apply-templates mode="info"/>
                </xsl:element>
            </xsl:element>
        </xsl:for-each>
    </xsl:template>


    <xsl:template match="db:article">
        <xsl:element name="bookmap">
            <xsl:attribute name="class">- map/map bookmap/bookmap </xsl:attribute>
            <xsl:attribute name="domains">(map mapgroup-d) (topic indexing-d) (topic
                xnal-d)</xsl:attribute>
            <xsl:attribute name="ditaarch:DITAArchVersion">1.1</xsl:attribute>
            <xsl:attribute name="id">org.pmc.help.<xsl:value-of select="//db:info[1]/db:pmc_document_id[1]"
            />v<xsl:value-of select="//db:info[1]/db:issuenum[1]"/></xsl:attribute>
            <xsl:call-template name="convert-attributes"/>
            <xsl:call-template name="project-converter"/>
            <xsl:call-template name="attribute_manager"/>
            <title class="- topic/title ">
                <xsl:for-each select="/db:article/db:info/db:title">
                <xsl:call-template name="process-ditamap-title"/>
                </xsl:for-each>
            </title>
            <xsl:call-template name="info_element"/>
            <frontmatter class="- map/topicref bookmap/frontmatter ">
                <booklists class="- map/topicref bookmap/booklists ">
                    <toc class="- map/topicref bookmap/toc "/>
                </booklists>
            </frontmatter>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <!-- Eliminate the info element that is already being processed inside the article element -->

    <xsl:template match="db:info"> </xsl:template>

    <xsl:template match="db:table | db:informaltable" priority="10"/>

    <xsl:template match="db:article/db:preface">
        <xsl:element name="chapter">
            <xsl:attribute name="class">- map/topicref bookmap/chapter </xsl:attribute>
            <xsl:call-template name="attribute_manager"/>            
            <xsl:call-template name="convert-attributes"/>
            <!-- Add attributes needed to connect the chapter to a file named after the section ID -->
            <xsl:apply-templates/>
            <xsl:attribute name="href"><xsl:call-template name="id_processing"/>.xml</xsl:attribute>
        </xsl:element>
    </xsl:template>

    <xsl:template match="db:article/db:section">
        <xsl:element name="chapter">
            <xsl:attribute name="class">- map/topicref bookmap/chapter </xsl:attribute>
            <xsl:call-template name="attribute_manager"/>           
            <xsl:call-template name="convert-attributes"/>
            <xsl:attribute name="href"><xsl:call-template name="id_processing"/>.xml</xsl:attribute>
            <!-- Add attributes needed to connect the chapter to a file named after the section ID -->
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="db:article/db:appendix">
        <xsl:element name="appendix">
            <xsl:attribute name="class">- map/topicref bookmap/appendix </xsl:attribute>
            <xsl:call-template name="attribute_manager"/>           
            <xsl:call-template name="convert-attributes"/>
            <xsl:attribute name="href"><xsl:call-template name="id_processing"/>.xml</xsl:attribute>
            <!-- Add attributes needed to connect the appendix to a file named after the section ID -->
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>


    <xsl:template match="db:section">
        <xsl:element name="topicref">
            <xsl:attribute name="class">- map/topicref </xsl:attribute>
            <xsl:call-template name="attribute_manager"/>
            <xsl:attribute name="collection-type">sequence</xsl:attribute>            
            <xsl:call-template name="convert-attributes"/>
            <xsl:attribute name="href"><xsl:call-template name="id_processing"/>.xml</xsl:attribute>
            <!-- Add attributes needed to connect the topicref to a file named after the section ID -->
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template name="convert-attributes">
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
        <xsl:if test="db:title">
            <xsl:attribute name="navtitle">
                <xsl:value-of select="db:title/text()"/>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>

    <xsl:template name="deep-copy">
        <xsl:for-each select="child::node()">
            <xsl:copy-of select="."/>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="* | text()"/>

    <!-- ISO data -->

    <xsl:template match="db:info/*"/>

    <xsl:template match="db:subtitle" mode="info">
        <xsl:element name="pmc_title">
            <xsl:attribute name="class"> + pmciso-d/pmc_subtitle </xsl:attribute>
            <xsl:call-template name="convert-attributes"/>
            <xsl:apply-templates mode="info"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="db:abstract" mode="info">
        <xsl:element name="pmc_abstract">
            <xsl:attribute name="class"> + pmciso-d/pmc_abstract </xsl:attribute>
            <xsl:call-template name="convert-attributes"/>
            <xsl:apply-templates mode="info"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="db:pmc_productnumber" mode="info">
        <xsl:element name="pmc_productnumber">
            <xsl:attribute name="class"> + pmciso-d/pmc_productnumber </xsl:attribute>
            <xsl:call-template name="convert-attributes"/>
            <xsl:apply-templates mode="info"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="db:pmc_productname" mode="info">
        <xsl:element name="pmc_productname">
            <xsl:attribute name="class"> + pmciso-d/pmc_productname </xsl:attribute>
            <xsl:call-template name="convert-attributes"/>
            <xsl:apply-templates mode="info"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="db:pmc_document_id" mode="info">
        <xsl:element name="pmc_document_id">
            <xsl:attribute name="class"> + pmciso-d/pmc_document_id </xsl:attribute>
            <xsl:call-template name="convert-attributes"/>
            <xsl:apply-templates mode="info"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="db:pmc_issue_date" mode="info">
        <xsl:element name="pmc_issue_date">
            <xsl:attribute name="class"> + pmciso-d/pmc_issue_date </xsl:attribute>
            <xsl:call-template name="convert-attributes"/>
            <xsl:apply-templates mode="info"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="db:pmc_file_name" mode="info">
        <xsl:element name="pmc_file_name">
            <xsl:attribute name="class"> + pmciso-d/pmc_file_name </xsl:attribute>
            <xsl:call-template name="convert-attributes"/>
            <xsl:apply-templates mode="info"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="db:pmc_filing_path" mode="info">
        <xsl:element name="pmc_filing_path">
            <xsl:attribute name="class"> + pmciso-d/pmc_filing_path </xsl:attribute>
            <xsl:call-template name="convert-attributes"/>
            <xsl:apply-templates mode="info"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="db:pmc_inclusion" mode="info">
        <xsl:element name="pmc_inclusion">
            <xsl:attribute name="class"> + pmciso-d/pmc_inclusion </xsl:attribute>
            <xsl:call-template name="convert-attributes"/>
            <xsl:apply-templates mode="info"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="db:pmc_dev_status" mode="info">
        <xsl:element name="pmc_dev_status">
            <xsl:attribute name="class"> + pmciso-d/pmc_dev_status </xsl:attribute>
            <xsl:call-template name="convert-attributes"/>
            <xsl:attribute name="dev_status">
                <xsl:value-of select="@dev_status"/>
            </xsl:attribute>
            <xsl:apply-templates mode="info"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="db:pmc_doc_status" mode="info">
        <xsl:element name="pmc_doc_status">
            <xsl:attribute name="class"> + pmciso-d/pmc_doc_status </xsl:attribute>
            <xsl:call-template name="convert-attributes"/>
            <xsl:attribute name="doc_status">
                <xsl:value-of select="@doc_status"/>
            </xsl:attribute>
            <xsl:apply-templates mode="info"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="db:pmc_doc_type" mode="info">
        <xsl:element name="pmc_doc_type">
            <xsl:attribute name="class"> + pmciso-d/pmc_doc_type </xsl:attribute>
            <xsl:call-template name="convert-attributes"/>
            <xsl:apply-templates mode="info"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="db:pmc_dcp_phase" mode="info">
        <xsl:element name="pmc_dcp_phase">
            <xsl:attribute name="class"> + pmciso-d/pmc_dcp_phase </xsl:attribute>
            <xsl:call-template name="convert-attributes"/>
            <xsl:attribute name="dcp_phase">
                <xsl:value-of select="@phase"/>
            </xsl:attribute>
            <xsl:apply-templates mode="info"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="db:issuenum" mode="info">
        <xsl:element name="pmc_issuenum">
            <xsl:attribute name="class"> + pmciso-d/pmc_issuenum </xsl:attribute>
            <xsl:call-template name="convert-attributes"/>
            <xsl:apply-templates mode="info"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="db:pmc_copyright_year" mode="info">
        <xsl:element name="pmc_copyright_year">
            <xsl:attribute name="class"> + pmciso-d/pmc_copyright_year </xsl:attribute>
            <xsl:call-template name="convert-attributes"/>
            <xsl:apply-templates mode="info"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="db:pmc_keywords" mode="info">
        <xsl:element name="pmc_keywords">
            <xsl:attribute name="class"> + pmciso-d/pmc_keywords </xsl:attribute>
            <xsl:call-template name="convert-attributes"/>
            <xsl:apply-templates mode="info"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="db:pmc_keyword" mode="info">
        <xsl:element name="pmc_keyword">
            <xsl:attribute name="class"> + pmciso-d/pmc_keyword </xsl:attribute>
            <xsl:call-template name="convert-attributes"/>
            <xsl:apply-templates mode="info"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="db:pmc_footertext" mode="info">
        <xsl:element name="pmc_footertext">
            <xsl:attribute name="class"> + pmciso-d/pmc_footertext </xsl:attribute>
            <xsl:call-template name="convert-attributes"/>
            <xsl:apply-templates mode="info"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="db:pmc_revhistory" mode="info">
        <xsl:element name="pmc_revhistory">
            <xsl:attribute name="class"> + pmciso-d/pmc_revhistory </xsl:attribute>
            <xsl:call-template name="convert-attributes"/>
            <xsl:apply-templates mode="info"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="db:pmc_revision" mode="info">
        <xsl:element name="pmc_revision">
            <xsl:attribute name="class"> + pmciso-d/pmc_revision </xsl:attribute>
            <xsl:call-template name="convert-attributes"/>
            <xsl:apply-templates mode="info"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="db:revnumber" mode="info">
        <xsl:element name="pmc_rev_number">
            <xsl:attribute name="class"> + pmciso-d/pmc_rev_number </xsl:attribute>
            <xsl:call-template name="convert-attributes"/>
            <xsl:apply-templates mode="info"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="db:date" mode="info">
        <xsl:element name="pmc_date">
            <xsl:attribute name="class"> + pmciso-d/pmc_date </xsl:attribute>
            <xsl:call-template name="convert-attributes"/>
            <xsl:apply-templates mode="info"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="db:pmc_name" mode="info">
        <xsl:element name="pmc_name">
            <xsl:attribute name="class"> + pmciso-d/pmc_name </xsl:attribute>
            <xsl:call-template name="convert-attributes"/>
            <xsl:apply-templates mode="info"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="db:pmc_revdescription" mode="info">
        <xsl:element name="pmc_revdescription">
            <xsl:attribute name="class"> + pmciso-d/pmc_revdescription </xsl:attribute>
            <xsl:call-template name="convert-attributes"/>
            <xsl:apply-templates mode="info"/>
        </xsl:element>
    </xsl:template>


    <xsl:template name="topic_title">
        <xsl:for-each select="db:title">
            <xsl:choose>
                <xsl:when
                    test="parent::db:table | parent::db:figure | parent::db:example | parent::db:procedure | parent::db:preface">
                    <xsl:element name="title">
                        <xsl:attribute name="class">- topic/title </xsl:attribute>
                        <xsl:call-template name="attribute_manager"/>
                        <xsl:apply-templates mode="info"/>
                    </xsl:element>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:element name="title">
                        <xsl:attribute name="class">- topic/title </xsl:attribute>
                        <xsl:call-template name="attribute_manager"/>
                        <xsl:apply-templates mode="info"/>
                    </xsl:element>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="get_topic_title">
        <xsl:for-each select="db:title">
            <xsl:apply-templates mode="info"/>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="get_index_topic_title">
        <xsl:for-each select="db:title">
            <xsl:value-of select="."/>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="db:para | db:caption" mode="info">
        <xsl:element name="p">
            <xsl:attribute name="class">- topic/p </xsl:attribute>
            <xsl:call-template name="attribute_manager"/>
            <xsl:apply-templates mode="info"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="db:title" mode="info">
        <xsl:choose>
            <xsl:when
                test="parent::db:section | parent::db:appendix | parent::db:preface | parent::db:table | parent::db:example | parent::db:figure"/>
            <xsl:when test="parent::db:info">
                <xsl:element name="pmc_title">
                    <xsl:attribute name="class"> + pmciso-d/pmc_title </xsl:attribute>
                    <xsl:call-template name="convert-attributes"/>
                    <xsl:apply-templates mode="info"/>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="title">
                    <xsl:attribute name="class">- topic/title </xsl:attribute>
                    <xsl:call-template name="attribute_manager"/>
                    <xsl:apply-templates mode="info"/>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>



    <xsl:template match="db:bridgehead" mode="info">
        <xsl:element name="p">
            <xsl:if test="@xml:id">
                <xsl:attribute name="id">
                    <xsl:call-template name="id_processing"><xsl:with-param name="link"><xsl:value-of select="@xml:id"></xsl:value-of></xsl:with-param></xsl:call-template>
                </xsl:attribute>
            </xsl:if>
            <xsl:attribute name="class">- topic/p </xsl:attribute>
            <xsl:call-template name="attribute_manager"/>
            <xsl:apply-templates mode="info"/>
        </xsl:element>
    </xsl:template>



    <xsl:template match="db:table" mode="info">
        <xsl:choose>
            <xsl:when test="ancestor::db:table">
                <xsl:element name="p">
                    <xsl:call-template name="attribute_manager"/>
                    <xsl:element name="table">
                        <xsl:if test="@xml:id">
                            <xsl:attribute name="id">
                                <xsl:value-of select="@xml:id"/>
                            </xsl:attribute>
                        </xsl:if>
                        <xsl:attribute name="class">- topic/table </xsl:attribute>
                        <xsl:attribute name="otherprops">
                            <xsl:number format="1" level="any"/>
                        </xsl:attribute>
                        <xsl:call-template name="topic_title"/>
                        <xsl:apply-templates mode="info"/>
                    </xsl:element>
                </xsl:element>
                <xsl:call-template name="externalize-tfooters"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="table">
                    <xsl:if test="@xml:id">
                        <xsl:attribute name="id">
                            <xsl:value-of select="@xml:id"/>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:attribute name="class">- topic/table </xsl:attribute>
                    <xsl:call-template name="attribute_manager"/>
                    <xsl:call-template name="topic_title"/>
                    <xsl:apply-templates mode="info"/>
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
                                <xsl:value-of select="@xml:id"/>
                            </xsl:attribute>
                        </xsl:if>
                        <xsl:attribute name="class">- topic/table </xsl:attribute>
                        <xsl:element name="title"/>
                        <xsl:apply-templates mode="info"/>
                    </xsl:element>
                </xsl:element>
                <xsl:call-template name="externalize-tfooters"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="table">
                    <xsl:if test="@xml:id">
                        <xsl:attribute name="id">
                            <xsl:value-of select="@xml:id"/>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:attribute name="class">- topic/table </xsl:attribute>
                    <xsl:call-template name="attribute_manager"/>
                    <xsl:element name="title"/>
                    <xsl:apply-templates mode="info"/>
                </xsl:element>
                <xsl:call-template name="externalize-tfooters"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="db:tgroup" mode="info">
        <xsl:element name="tgroup">
            <xsl:attribute name="class">- topic/tgroup </xsl:attribute>
            <xsl:attribute name="cols">
                <xsl:value-of select="@cols"/>
            </xsl:attribute>
            <xsl:call-template name="attribute_manager"/>
            <xsl:apply-templates mode="info"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="db:tbody" mode="info">
        <xsl:element name="tbody">
            <xsl:attribute name="class">- topic/tbody </xsl:attribute>
            <xsl:call-template name="attribute_manager"/>
            <xsl:apply-templates mode="info"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="db:thead" mode="info">
        <xsl:element name="thead">
            <xsl:attribute name="class">- topic/thead </xsl:attribute>
            <xsl:call-template name="attribute_manager"/>
            <xsl:apply-templates mode="info"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="db:tfoot" mode="info">
        <!-- tfoots are not part of the DITA CALS table spec, so we're moving the content outside the table with the externalize-tfooters template  -->
        <!-- 
        <xsl:element name="tfoot">
            <xsl:attribute name="class">- topic/tfoot </xsl:attribute>
            <xsl:call-template name="attribute_manager"/>
            <xsl:apply-templates/>
        </xsl:element>  -->
    </xsl:template>

    <xsl:template match="db:row" mode="info">
        <xsl:choose>
            <xsl:when test="(ancestor::db:informaltable) and (ancestor::db:thead)">
                <xsl:element name="row">
                    <xsl:attribute name="class">- topic/row </xsl:attribute>
                    <xsl:call-template name="attribute_manager"/>
                    <xsl:apply-templates mode="info"/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="(ancestor::db:informaltable) and (ancestor::db:tbody)">
                <xsl:element name="row">
                    <xsl:attribute name="class">- topic/row </xsl:attribute>
                    <xsl:call-template name="attribute_manager"/>
                    <xsl:apply-templates mode="info"/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="(ancestor::db:table) and (ancestor::db:thead)">
                <xsl:element name="row">
                    <xsl:attribute name="class">- topic/row </xsl:attribute>
                    <xsl:call-template name="attribute_manager"/>
                    <xsl:apply-templates mode="info"/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="(ancestor::db:table) and (ancestor::db:tbody)">
                <xsl:element name="row">
                    <xsl:attribute name="class">- topic/row </xsl:attribute>
                    <xsl:call-template name="attribute_manager"/>
                    <xsl:apply-templates mode="info"/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="(ancestor::db:entrytbl) and (ancestor::db:thead)">
                <xsl:element name="row">
                    <xsl:attribute name="class">- topic/row </xsl:attribute>
                    <xsl:call-template name="attribute_manager"/>
                    <xsl:apply-templates mode="info"/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="(ancestor::db:entrytbl) and (ancestor::db:tbody)">
                <xsl:element name="row">
                    <xsl:attribute name="class">- topic/row </xsl:attribute>
                    <xsl:call-template name="attribute_manager"/>
                    <xsl:apply-templates mode="info"/>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="row">
                    <xsl:attribute name="class">- topic/row </xsl:attribute>
                    <xsl:call-template name="attribute_manager"/>
                    <xsl:apply-templates/>
                    <xsl:element name="entry">
                        <xsl:attribute name="class">- topic/entry </xsl:attribute>
                        <xsl:call-template name="attribute_manager"/> Missing options in the db:row
                        template </xsl:element>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="db:entry" mode="info">
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
                    <xsl:apply-templates mode="info"/>
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
                    <xsl:apply-templates mode="info"/>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="db:colspec" mode="info">
        <xsl:element name="colspec">
            <xsl:copy-of select="@*"/>
            <xsl:if test="@colwidth">
                <xsl:choose>
                    <xsl:when test="contains(@colwidth, 'in')">
                        <xsl:attribute name="colwidth">
                            <xsl:value-of select="substring-before(@colwidth, 'in')"/>
                        </xsl:attribute>
                    </xsl:when>
                    <xsl:when test="contains(@colwidth, 'cm')">
                        <xsl:attribute name="colwidth">
                            <xsl:value-of select="substring-before(@colwidth, 'cm') "/>
                        </xsl:attribute>
                    </xsl:when>
                    <xsl:when test="contains(@colwidth, 'mm')">
                        <xsl:attribute name="colwidth">
                            <xsl:value-of select="substring-before(@colwidth, 'mm')"/>
                        </xsl:attribute>
                    </xsl:when>
                    <xsl:when test="contains(@colwidth, 'px')">
                        <xsl:attribute name="colwidth">
                            <xsl:value-of select="substring-before(@colwidth, 'px')"/>
                        </xsl:attribute>
                    </xsl:when>
                </xsl:choose>
            </xsl:if>
            <xsl:attribute name="class">- topic/colspec </xsl:attribute>
            <xsl:call-template name="attribute_manager"/>
            <xsl:apply-templates mode="info"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="db:spanspec" mode="info">
        <xsl:element name="spanspec">
            <xsl:copy-of select="@*"/>
            <xsl:attribute name="class">- topic/spanspec </xsl:attribute>
            <xsl:call-template name="attribute_manager"/>
            <xsl:apply-templates mode="info"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="db:caution | db:warning | db:note | db:tip | db:important" mode="info">
        <xsl:element name="note">
            <xsl:attribute name="class">- topic/note </xsl:attribute>
            <xsl:call-template name="attribute_manager"/>
            <xsl:apply-templates mode="info"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="db:code | db:command | db:filename" mode="info">
        <xsl:element name="codeph">
            <xsl:attribute name="class">- topic/ph pr-d/codeph </xsl:attribute>
            <xsl:call-template name="attribute_manager"/>
            <xsl:apply-templates mode="info"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="db:example" mode="info">
        <xsl:element name="example">
            <xsl:attribute name="id">
                <xsl:value-of select="@xml:id"/>
            </xsl:attribute>
            <xsl:attribute name="class">- topic/example </xsl:attribute>
            <xsl:call-template name="attribute_manager"/>
            <xsl:call-template name="topic_title"/>
            <xsl:apply-templates mode="info"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="db:footnote" mode="info">
        <xsl:element name="fn">
            <xsl:attribute name="id">
                <xsl:value-of select="xml:id"/>
            </xsl:attribute>
            <xsl:attribute name="class">- topic/fn </xsl:attribute>
            <xsl:call-template name="attribute_manager"/>
            <xsl:apply-templates mode="info"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="db:footnoteref" mode="info">
        <xsl:element name="xref">
            <xsl:copy-of select="@*"/>
            <xsl:attribute name="class">- topic/fn </xsl:attribute>
            <xsl:call-template name="attribute_manager"/>
            <xsl:apply-templates mode="info"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="db:figure" mode="info">
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
                        <xsl:call-template name="attribute_manager_figuretables"/>
                        <xsl:element name="title">
                            <xsl:apply-templates select="parent::db:figure/db:title"/>
                        </xsl:element>
                        <xsl:apply-templates select="./*" mode="info"/>
                    </xsl:element>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="fig">
                    <xsl:if test="@xml:id">
                        <xsl:attribute name="id">
                            <xsl:value-of select="@xml:id"/>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:attribute name="class">- topic/fig </xsl:attribute>
                    <xsl:call-template name="attribute_manager"/>
                    <xsl:call-template name="topic_title"/>
                    <xsl:apply-templates mode="info"/>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>

    <xsl:template match="db:mediaobject | db:imageobject" mode="info">
        <xsl:apply-templates mode="info"/>
    </xsl:template>

    <xsl:template match="db:imagedata" mode="info">
        <xsl:element name="image">
            <xsl:attribute name="class">- topic/image </xsl:attribute>
            <xsl:attribute name="placement">break</xsl:attribute>
            <xsl:call-template name="attribute_manager"/>
            <xsl:if test="@width or @depth">
                <xsl:choose>
                    <xsl:when test="contains(@width, 'in')">
                        <xsl:attribute name="width"><xsl:value-of
                                select="number(substring-before(@width, 'in')) * 72"
                            />px</xsl:attribute>
                    </xsl:when>
                    <xsl:when test="contains(@width, 'cm')">
                        <xsl:attribute name="width"><xsl:value-of
                                select="number(substring-before(@width, 'cm')) * 25"
                            />px</xsl:attribute>
                    </xsl:when>
                    <xsl:when test="contains(@width, 'mm')">
                        <xsl:attribute name="width"><xsl:value-of
                                select="number(substring-before(@width, 'mm')) * 3"
                            />px</xsl:attribute>
                    </xsl:when>
                    <xsl:when test="contains(@depth, 'in')">
                        <xsl:attribute name="height"><xsl:value-of
                                select="number(substring-before(@width, 'in')) * 72"
                            />px</xsl:attribute>
                    </xsl:when>
                    <xsl:when test="contains(@depth, 'cm')">
                        <xsl:attribute name="height"><xsl:value-of
                                select="number(substring-before(@width, 'cm')) * 25"
                            />px</xsl:attribute>
                    </xsl:when>
                    <xsl:when test="contains(@depth, 'mm')">
                        <xsl:attribute name="height"><xsl:value-of
                                select="number(substring-before(@width, 'mm')) * 3"
                            />px</xsl:attribute>
                    </xsl:when>
                </xsl:choose>
            </xsl:if>
            <xsl:attribute name="href">
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
            </xsl:attribute>
            <xsl:apply-templates mode="info"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="db:index | db:indexdiv" mode="info"/>

    <xsl:template match="db:indexentry" mode="info">
        <xsl:apply-templates mode="info"/>
    </xsl:template>

    <xsl:template match="db:primary" mode="info">
        <xsl:element name="indexterm">
            <xsl:attribute name="class">- topic/indexterm </xsl:attribute>
            <xsl:call-template name="attribute_manager"/>
            <xsl:apply-templates mode="info"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="db:secondary" mode="info">
        <xsl:element name="indexterm">
            <xsl:attribute name="class">- topic/indexterm </xsl:attribute>
            <xsl:call-template name="attribute_manager"/>
            <xsl:apply-templates mode="info"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="db:tertiary" mode="info">
        <xsl:element name="indexterm">
            <xsl:attribute name="class">- topic/indexterm </xsl:attribute>
            <xsl:call-template name="attribute_manager"/>
            <xsl:apply-templates mode="info"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="db:inlinemediaobject" mode="info">
        <xsl:for-each select="db:imageobject/db:imagedata">
            <xsl:element name="image">
                <xsl:attribute name="class">- topic/image </xsl:attribute>
                <xsl:attribute name="placement">inline</xsl:attribute>
                <xsl:attribute name="href">
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
                </xsl:attribute>
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
                <xsl:apply-templates mode="info"/>
            </xsl:element>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="db:itemizedlist" mode="info">
        <xsl:element name="ul">
            <xsl:attribute name="class">- topic/ul </xsl:attribute>
            <xsl:call-template name="attribute_manager"/>
            <xsl:apply-templates mode="info"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="db:orderedlist  | db:substeps" mode="info">
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
            <xsl:apply-templates mode="info"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="db:orderedlist/db:title | db:substeps/db:title" mode="info"/>

    <xsl:template match="db:procedure" mode="info">
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
            <xsl:apply-templates mode="info"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="db:listitem | db:step | db:member" mode="info">
        <xsl:choose>
            <xsl:when test="parent::db:simplelist">
                <xsl:element name="sli">
                    <xsl:attribute name="class">- topic/sli </xsl:attribute>
                    <xsl:apply-templates mode="info"/>
                    <xsl:call-template name="attribute_manager"/>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="li">
                    <xsl:attribute name="class">- topic/li </xsl:attribute>
                    <xsl:call-template name="attribute_manager"/>
                    <xsl:apply-templates mode="info"/>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>

    <xsl:template match="db:phrase" mode="info">
        <xsl:element name="ph">
            <xsl:attribute name="class">- topic/ph </xsl:attribute>
            <xsl:call-template name="attribute_manager"/>
            <xsl:apply-templates mode="info"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="db:emphasis" mode="info">
        <xsl:choose>
            <xsl:when test="contains(@role, 'bold')">
                <xsl:element name="b">
                    <xsl:attribute name="class">+ topic/ph hi-d/b </xsl:attribute>
                    <xsl:call-template name="attribute_manager"/>
                    <xsl:apply-templates mode="info"/>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="i">
                    <xsl:attribute name="class">+ topic/ph hi-d/i </xsl:attribute>
                    <xsl:call-template name="attribute_manager"/>
                    <xsl:apply-templates mode="info"/>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="db:programlisting" mode="info">
        <xsl:element name="codeblock">
            <xsl:attribute name="class">- topic/pre topic/codeblock </xsl:attribute>
            <xsl:call-template name="attribute_manager"/>
            <xsl:apply-templates mode="info"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="db:remark" mode="info"/>

    <xsl:template match="db:simplelist" mode="info">
        <xsl:element name="sl">
            <xsl:attribute name="class">- topic/sl </xsl:attribute>
            <xsl:call-template name="attribute_manager"/>
            <xsl:apply-templates mode="info"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="db:subscript" mode="info">
        <xsl:element name="sub">
            <xsl:attribute name="class">- topic/ph hi-d/sub </xsl:attribute>
            <xsl:call-template name="attribute_manager"/>
            <xsl:apply-templates mode="info"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="db:superscript" mode="info">
        <xsl:element name="sup">
            <xsl:attribute name="class">- topic/ph hi-d/sup </xsl:attribute>
            <xsl:call-template name="attribute_manager"/>
            <xsl:apply-templates mode="info"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="db:subtitle" mode="info"/>

    <xsl:template match="db:symbol" mode="info">
        <xsl:element name="ph">
            <xsl:attribute name="class">- topic/ph </xsl:attribute>
            <xsl:call-template name="attribute_manager"/>
            <xsl:apply-templates mode="info"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="db:variablelist" mode="info">
        <xsl:element name="parml">           
            <xsl:call-template name="attribute_manager"/>
            <xsl:apply-templates mode="info"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="db:varlistentry" mode="info">
        <xsl:element name="plentry">
            <xsl:call-template name="attribute_manager"/>
            <xsl:apply-templates mode="info"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="db:varlistentry/db:term" mode="info">
        <xsl:element name="pt">
            <xsl:call-template name="attribute_manager"/>
            <xsl:apply-templates mode="info"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="db:varlistentry/db:listitem" mode="info">
        <xsl:element name="pd">
            <xsl:call-template name="attribute_manager"/>
            <xsl:apply-templates mode="info"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="db:trademark" mode="info">
        <xsl:element name="tm">
            <xsl:call-template name="attribute_manager"/>
            <xsl:attribute name="tmtype">tm</xsl:attribute>
            <xsl:apply-templates mode="info"/>
        </xsl:element>
    </xsl:template>

    <!-- Cross references are tricky. In particular, we need to detect if the xref is to the current file, and if so avoid adding the filename. -->

    <xsl:template match="db:xref" priority="1" mode="info">
        <!-- Grab the ID of the xref endpoint  -->
        <xsl:variable name="temp_id">
            <xsl:value-of select="@linkend"/>      
        </xsl:variable>
        <!-- Start forming the Xref  -->
        <xsl:element name="xref">
            <xsl:attribute name="class">- topic/xref </xsl:attribute>
            <xsl:attribute name="href">
                <xsl:choose>
                    <!-- Form the href value of the xref. When the id is the id of a section or the preface, simply form the href by adding an .xml to the end of the id -->
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
            <xsl:apply-templates mode="info"/>
        </xsl:element>
    </xsl:template>
    
    <!-- accept two parameters; the target of the xref and the id of the nearest section/chapter/preface/appendix -->
    <!-- if the target of the xref is the same value as the id of current node, form the xref as an internal link -->
    <!-- if the target of the xref is in a different section, form the xref as pointing to an external target -->

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

    <xsl:template match="db:procedure/db:title" mode="info"/>

    <xsl:template match="@colwidth">
        <xsl:attribute name="colwidth">
            <xsl:value-of select="substring-before(@colwidth, 'in') * 92"/>
        </xsl:attribute>
    </xsl:template>

    <xsl:template name="generate_prolog">
        <xsl:if test="@xml:id">
            <xsl:element name="prolog">
                <xsl:attribute name="class">- topic/prolog </xsl:attribute>
                <xsl:element name="data">
                    <xsl:attribute name="class">- topic/data </xsl:attribute>
                    <xsl:attribute name="type">pdf_name</xsl:attribute>
                    <xsl:attribute name="id"><xsl:value-of select="@xml:id"/></xsl:attribute>
                </xsl:element>
            </xsl:element>
        </xsl:if>
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
    </xsl:template>

    <!-- for some bizarre reason, someone nested a bunch of table in figure elements. This is just me busting them out. -->

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
        <xsl:call-template name="id_processing"></xsl:call-template>
    </xsl:template>



    <!-- manage tfooters, which are not allowed in the DITA version of CALS tables. Call this template immediately after processing the table itself -->

    <xsl:template name="externalize-tfooters">
        <xsl:for-each select="descendant::db:tfoot/db:row/db:entry">
            <xsl:apply-templates/>
        </xsl:for-each>

    </xsl:template>
    <xsl:template name="process_id">
        <xsl:choose>
            <xsl:when test="@xml:id">
                <xsl:variable name="sectionNumber">
                    <xsl:call-template name="id_processing"/>
                </xsl:variable>
                <xsl:value-of select="$sectionNumber"/></xsl:when>
            <xsl:otherwise>
                <xsl:variable name="sectionNumber">
                    <xsl:value-of select="generate-id()"/>
                </xsl:variable>
                <xsl:value-of select="$sectionNumber"/></xsl:otherwise>
        </xsl:choose>
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
                    <!-- Form the href value of the xref. When the id is the id of a section or the preface, simply form the href by adding an .xml to the end of the id -->
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
            <xsl:when test="not(//*[@xml:id = $temp_id])">NoMatchingIDFor_<xsl:value-of select="$temp_id"/>.xml</xsl:when>
            
            <xsl:when test="$sections[last()]/@xml:id = $current_section">#<xsl:call-template name="id_processing">
                <xsl:with-param name="link"><xsl:value-of select="$current_section"/>
                </xsl:with-param>
            </xsl:call-template>/<xsl:call-template name="id_processing">
                <xsl:with-param name="link"><xsl:value-of select="$temp_id"/></xsl:with-param>
            </xsl:call-template>
            </xsl:when>
            
            <xsl:when test="$current_section = 'current_section'">#<xsl:call-template name="id_processing">
                <xsl:with-param name="link"><xsl:value-of select="$sections[last()]/@xml:id"/>
                </xsl:with-param>
            </xsl:call-template>/<xsl:call-template name="id_processing">
                <xsl:with-param name="link"><xsl:value-of select="$temp_id"/></xsl:with-param>
            </xsl:call-template>
            </xsl:when>
            
            <xsl:otherwise>
                <xsl:call-template name="id_processing">
                    <xsl:with-param name="link"><xsl:value-of select="$sections[last()]/@xml:id"/></xsl:with-param>
                </xsl:call-template>.xml#<xsl:call-template name="id_processing">
                    <xsl:with-param name="link"><xsl:value-of select="$sections[last()]/@xml:id"/></xsl:with-param>
                </xsl:call-template>/<xsl:call-template name="id_processing">
                    <xsl:with-param name="link"><xsl:value-of select="$temp_id"/>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="process-ditamap-title">
        <xsl:element name="ph">
            <xsl:attribute name="class">- topic/ph </xsl:attribute>
            <xsl:call-template name="attribute_manager"/>
            <xsl:apply-templates mode="title"/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="text()" mode="title">
        <xsl:copy></xsl:copy>
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
