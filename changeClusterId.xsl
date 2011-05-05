
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    
<xsl:output doctype-public="-//The Apache Software Foundation//DTD Jackrabbit 2.0//EN" doctype-system="http://jackrabbit.apache.org/dtd/repository-2.0.dtd"/>
    <xsl:param name="cluster_id" select="'foo'"/>
    <xsl:template match="/|comment()|processing-instruction()">
        <xsl:copy>
            <xsl:apply-templates />
        </xsl:copy>
    </xsl:template>


    <xsl:template match="@*">
        <xsl:copy-of select="."/>
    </xsl:template>

    <xsl:template match="*">
        <xsl:element name="{local-name()}">
            <xsl:apply-templates select="@*" />
            <xsl:apply-templates />
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="/Repository/Cluster/@id">
      <xsl:attribute name="id"><xsl:value-of select="$cluster_id"/></xsl:attribute>
    </xsl:template>



</xsl:stylesheet>
