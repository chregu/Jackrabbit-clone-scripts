<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    
<xsl:output doctype-public="-//The Apache Software Foundation//DTD Jackrabbit 2.0//EN" 
doctype-system="http://jackrabbit.apache.org/dtd/repository-2.0.dtd"
method="text"
/>


    <xsl:param name="cluster_id" select="'foo'"/>
    <xsl:template match="*">
            <xsl:apply-templates />
    </xsl:template>
    
    <xsl:template match="text()">
    </xsl:template>

    <xsl:template match="/Repository/Cluster[1]"><xsl:value-of select="@id"/></xsl:template>



</xsl:stylesheet>
