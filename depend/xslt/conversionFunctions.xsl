<stylesheet
    xmlns      = "http://www.w3.org/1999/XSL/Transform" 
    xmlns:str  = "http://exslt.org/strings" 
    xmlns:math = "http://exslt.org/math" 
    version="1.0"
    exclude-result-prefixes="str math">
    
    <variable name="str:digits"     select="'0123456789'"
    />
    <variable name="str:alphabet"
        select="'abcdefghijklmnopqrstuvwxyz'"/>
    <variable name="str:ALPHABET"
        select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
    <variable name="math:base-list" select="concat($str:digits,
        $str:alphabet, $str:ALPHABET)"/>
    
    <template name="math:base-convert">
        <param name="from-base"/>
        <param name="to-base"/>
        <param name="value"/>
        <call-template name="math:decimal-to-base">
            <with-param name="base" select="$to-base"/>
            <with-param name="value">
                <call-template name="math:base-to-decimal">
                    <with-param name="base" select="$from-base"/>
                    <with-param name="value">
                        <choose>
                            <when test="$from-base &gt; 36">
                                <value-of select="$value"/>
                            </when>
                            <otherwise>
                                <value-of select="translate($value, $str:ALPHABET,
                                    $str:alphabet)"/>
                            </otherwise>
                        </choose>
                    </with-param>
                </call-template>
            </with-param>
        </call-template>
    </template>
    
    <template name="math:base-to-decimal">
        <param name="base"/>
        <param name="value"/>
        <variable name="base-recurse">
            <choose>
                <when test="string($value)">
                    <call-template name="math:base-to-decimal">
                        <with-param name="base" select="$base"/>
                        <with-param name="value" select="substring($value, 1,
                            string-length($value) - 1)"/>
                    </call-template>
                </when>
                <otherwise>0</otherwise>
            </choose>
        </variable>
        <value-of select="string-length(substring-before($math:base-list,
            substring($value, string-length($value)))) + $base * $base-recurse"/>
    </template>
    
    <template name="math:decimal-to-base">
        <param name="base"/>
        <param name="value" select="0"/>
        <if test="number($value)">
            <call-template name="math:decimal-to-base">
                <with-param name="base" select="$base"/>
                <with-param name="value" select="floor($value div $base)"/>
            </call-template>
            <value-of select="substring($math:base-list, ($value mod $base) +
                1, 1)"/>
        </if>
    </template>
    
</stylesheet>