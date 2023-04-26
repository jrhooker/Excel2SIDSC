<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
    xmlns="http://docbook.org/ns/docbook" xmlns:db="http://docbook.org/ns/docbook" xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:svg="http://www.w3.org/2000/svg" xmlns:mml="http://www.w3.org/1998/Math/MathML"
    xmlns:dbx="http://sourceforge.net/projects/docbook/defguide/schema/extra-markup"
    xmlns:ditaarch="http://dita.oasis-open.org/architecture/2005/"
    xmlns:xi="http://www.w3.org/2001/XInclude" xmlns:html="http://www.w3.org/1999/xhtml"
    exclude-result-prefixes="xsl db xlink svg mml dbx xi html">

    <xsl:output method="xml" media-type="text/xml" indent="yes" encoding="UTF-8"> </xsl:output>

    <xsl:variable name="quot">"</xsl:variable>
    <xsl:variable name="apos">'</xsl:variable>

    <xsl:template match="/">
        <section version="5.0-extension pmc-1.0" xmlns="http://docbook.org/ns/docbook"
            xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xi="http://www.w3.org/2001/XInclude"
            xmlns:svg="http://www.w3.org/2000/svg" xmlns:mml="http://www.w3.org/1998/Math/MathML"
            xmlns:html="http://www.w3.org/1999/xhtml"
            xmlns:dbx="http://sourceforge.net/projects/docbook/defguide/schema/extra-markup"
            xmlns:db="http://docbook.org/ns/docbook">
          <xsl:call-template name="iso"></xsl:call-template>       
            <section>
                <title>Available Reference Points</title>
              
                    <itemizedlist>
                <xsl:call-template name="generate-phrases"></xsl:call-template>
                    </itemizedlist>
               
            </section>
        </section>
    </xsl:template>
    <!-- Remove processing instructions -->

    <xsl:template match="processing-instruction()"/>

    <!-- Turn the info element into pmc_iso elements -->

<xsl:template name="generate-phrases">
    <xsl:variable name="xrefs" select="//db:section[@xml:id] | //db:table[@xml:id] | //db:figure[@xml:id]"></xsl:variable>
    <xsl:for-each select="$xrefs">
        <listitem>
            <para>
        <xsl:element name="phrase">
            <xsl:attribute name="xml:id">phrase_<xsl:value-of select="@xml:id"></xsl:value-of></xsl:attribute>
            <xsl:element name="phrase">
             
                <xsl:value-of select="//db:subtitle"></xsl:value-of>, <xsl:call-template name="topic_title"></xsl:call-template>
            </xsl:element>
            <xsl:element name="phrase">
           
                <xsl:attribute name="xlink:href">org.pmc.help.<xsl:value-of select="//pmc_document_id"></xsl:value-of>v<xsl:value-of select="//issuenum"></xsl:value-of>/<xsl:value-of select="@xml:id"></xsl:value-of>.html</xsl:attribute>
              <xsl:value-of select="//db:subtitle"></xsl:value-of>, <xsl:call-template name="topic_title"></xsl:call-template>
            </xsl:element>          
        </xsl:element>
            </para>
        </listitem>
    </xsl:for-each>    
</xsl:template>


    <!-- Eliminate the info element that is already being processed inside the article element -->

        
    <xsl:template name="iso">        
       <xsl:copy-of select="//db:info"></xsl:copy-of>
    </xsl:template>

    <xsl:template name="generate_numbering">
        <xsl:number format="1. " level="multiple" count="child::db:section"/>
    </xsl:template>

    <xsl:template name="topic_title">
        <xsl:for-each select="db:title">
            <xsl:choose>
                <xsl:when
                    test="parent::db:table | parent::db:figure | parent::db:example | parent::db:procedure | parent::db:preface">                  
                        <xsl:apply-templates/>                  
                </xsl:when>
                 <xsl:otherwise>               
                        <xsl:call-template name="generate_numbering"/>
                        <xsl:apply-templates/>                 
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
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- Cross references are tricky. In particular, we need to detect if the xref is to the current file, and if so avoid adding the filename. -->

    <xsl:template match="db:xref">
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
                    <xsl:when test="//db:section[@xml:id=$temp_id] | //db:preface[@xml:id=$temp_id]">
                        <xsl:value-of select="concat($temp_id, '.xml')"/>
                    </xsl:when>
                    <!-- When the xref is the id of a table, figure, example, sect1, or listitem, it is an inside join  -->
                    <xsl:when
                        test="(//db:table[@xml:id=$temp_id]) | (//db:figure[@xml:id=$temp_id]) | (//db:example[@xml:id=$temp_id])  | (//db:sect1[@xml:id=$temp_id]) | (//db:listitem[@xml:id=$temp_id])">
                        <xsl:call-template name="find_xerf_target_parent_section">
                            <xsl:with-param name="temp_id">
                                <xsl:value-of select="$temp_id"/>
                            </xsl:with-param>
                        </xsl:call-template>
                        <xsl:value-of select="$temp_id"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="find_xerf_target_parent_section">
                            <xsl:with-param name="temp_id">
                                <xsl:value-of select="$temp_id"/>
                            </xsl:with-param>
                        </xsl:call-template>
                        <xsl:value-of select="$temp_id"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:choose>
                <!-- when the endpoint is a sect1, it can be assumed to be a reg_bit -->
                <xsl:when test="//db:sect1[@xml:id=$temp_id]"><xsl:value-of
                    select="//db:sect1[@xml:id=$temp_id]/db:title"/></xsl:when>
                <xsl:when test="//db:listitem[@xml:id=$temp_id]">[<xsl:value-of
                select="count(//db:listitem[@xml:id=$temp_id])"/>]</xsl:when>
                <xsl:when test="//db:preface[@xml:id=$temp_id]">[Preface]</xsl:when>
                <xsl:when test="//db:section[@xml:id=$temp_id]">[Section <xsl:number
                        select="//db:section[@xml:id=$temp_id]" format="1." level="multiple"
                        count="child::db:section"/>]</xsl:when>
                <xsl:when test="//db:table[@xml:id=$temp_id]">[Table <xsl:number
                        select="//db:table[@xml:id=$temp_id]" format="1" level="any"
                        count="db:table"/>]</xsl:when>
                <xsl:when test="//db:figure[@xml:id=$temp_id]">[Figure <xsl:number
                        select="//db:figure[@xml:id=$temp_id]" format="1" level="any"
                        count="db:figure"/>]</xsl:when>
                <xsl:when test="//db:example[@xml:id=$temp_id]">[Example <xsl:number
                        select="//db:example[@xml:id=$temp_id]" format="1" level="any"
                        count="db:example"/>]</xsl:when>
                <xsl:otherwise>
                    <xsl:variable name="parent_section">
                        <xsl:call-template name="find_xerf_target_parent_section">
                            <xsl:with-param name="temp_id">
                                <xsl:value-of select="$temp_id"/>
                            </xsl:with-param>
                        </xsl:call-template>
                    </xsl:variable>
                    <xsl:value-of select="//db:section[@xml:id=$parent_section]/db:title"/>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <!-- Find the parent section for  -->

    <xsl:template name="find_xerf_target_parent_section">
        <xsl:param name="temp_id">section</xsl:param>
        <xsl:choose>
            <xsl:when test="//db:section[@xml:id=$temp_id]"><xsl:value-of
                    select="//db:section[*[@xml:id=$temp_id]]/@xml:id"/>.xml#<xsl:value-of
                    select="//db:section[*[@xml:id=$temp_id]]/@xml:id"/>__</xsl:when>
            <xsl:when test="//db:section/*[@xml:id=$temp_id]"><xsl:value-of
                    select="//db:section[*[@xml:id=$temp_id]]/@xml:id"/>.xml#<xsl:value-of
                    select="//db:section[*[@xml:id=$temp_id]]/@xml:id"/>__</xsl:when>
            <xsl:when test="//db:preface/*[@xml:id=$temp_id]"><xsl:value-of
                select="//db:preface[*[@xml:id=$temp_id]]/@xml:id"/>.xml#<xsl:value-of
                select="//db:preface[*[@xml:id=$temp_id]]/@xml:id"/>__</xsl:when>
             <xsl:when test="//db:section/*/*[@xml:id=$temp_id]"><xsl:value-of
                    select="//db:section[*/*[@xml:id=$temp_id]]/@xml:id"/>.xml#<xsl:value-of
                    select="//db:section[*/*[@xml:id=$temp_id]]/@xml:id"/>__</xsl:when>
            <xsl:when test="//db:preface/*/*[@xml:id=$temp_id]"><xsl:value-of
                select="//db:preface[*/*[@xml:id=$temp_id]]/@xml:id"/>.xml#<xsl:value-of
                    select="//db:preface[*/*[@xml:id=$temp_id]]/@xml:id"/>__</xsl:when>
            <xsl:when test="//db:section/*/*/*[@xml:id=$temp_id]"><xsl:value-of
                    select="//db:section[*/*/*[@xml:id=$temp_id]]/@xml:id"/>.xml#<xsl:value-of
                    select="//db:section[*/*/*[@xml:id=$temp_id]]/@xml:id"/>__</xsl:when>
            <xsl:when test="//db:preface/*/*/*[@xml:id=$temp_id]"><xsl:value-of
                select="//db:preface[*/*/*[@xml:id=$temp_id]]/@xml:id"/>.xml#<xsl:value-of
                    select="//db:preface[*/*/*[@xml:id=$temp_id]]/@xml:id"/>__</xsl:when>
            <xsl:when test="//db:section/*/*/*/*[@xml:id=$temp_id]"><xsl:value-of
                    select="//db:section[*/*/*/*[@xml:id=$temp_id]]/@xml:id"/>.xml#<xsl:value-of
                    select="//db:section[*/*/*/*[@xml:id=$temp_id]]/@xml:id"/>__</xsl:when>
            <xsl:when test="//db:preface/*/*/*/*[@xml:id=$temp_id]"><xsl:value-of
                select="//db:preface[*/*/*/*[@xml:id=$temp_id]]/@xml:id"/>.xml#<xsl:value-of
                    select="//db:preface[*/*/*/*[@xml:id=$temp_id]]/@xml:id"/>__</xsl:when>
            <xsl:when test="//db:section/*/*/*/*/*[@xml:id=$temp_id]"><xsl:value-of
                    select="//db:section[*/*/*/*/*[@xml:id=$temp_id]]/@xml:id"/>.xml#<xsl:value-of
                    select="//db:section[*/*/*/*/*[@xml:id=$temp_id]]/@xml:id"/>__</xsl:when>
            <xsl:when test="//db:preface/*/*/*/*/*[@xml:id=$temp_id]"><xsl:value-of
                select="//db:preface[*/*/*/*/*[@xml:id=$temp_id]]/@xml:id"/>.xml#<xsl:value-of
                    select="//db:preface[*/*/*/*/*[@xml:id=$temp_id]]/@xml:id"/>__</xsl:when>
            <xsl:when test="//db:section/*/*/*/*/*/*[@xml:id=$temp_id]"><xsl:value-of
                    select="//db:section[*/*/*/*/*/*[@xml:id=$temp_id]]/@xml:id"/>.xml#<xsl:value-of
                    select="//db:section[*/*/*/*/*/*[@xml:id=$temp_id]]/@xml:id"/>__</xsl:when>
            <xsl:when test="//db:preface/*/*/*/*/*/*[@xml:id=$temp_id]"><xsl:value-of
                select="//db:preface[*/*/*/*/*/*[@xml:id=$temp_id]]/@xml:id"/>.xml#<xsl:value-of
                    select="//db:preface[*/*/*/*/*/*[@xml:id=$temp_id]]/@xml:id"/>__</xsl:when>
            <xsl:otherwise>find_xref_target_parent_section_failed.xml_tempID=<xsl:value-of select="$temp_id"></xsl:value-of>#</xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="sanitize_id">
        <xsl:value-of
            select="translate(translate(translate(translate(child::db:title, ':;[]{}~!@#$%^*()?µ\/=ΘΩ≠≥√∑±°&#xA;-.,–‘’-“”&amp;­', '_'), $quot, '_'), $apos, '_'), ' ', '_')"
        />
    </xsl:template>


  
    <xsl:template match="db:procedure/db:title"/>

    <!-- INFO element -->

</xsl:stylesheet>
