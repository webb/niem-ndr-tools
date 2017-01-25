<?xml version="1.0" encoding="US-ASCII"?>
<stylesheet 
   version="1.0"
   xmlns:ann="https://github.com/webb/niem-ndr-tools/ns/svrl-annotation"
   xmlns:map="http://example.org/ns/map"
   xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
   xmlns="http://www.w3.org/1999/XSL/Transform">

  <output method="xml" version="1.0" indent="yes"/>

  <param name="ndr-id-map"/>

  <variable name="map" select="document($ndr-id-map)/map:map"/>

  <template match="/">
    <if test="0 = string-length($ndr-id-map)">
      <message terminate="yes"
               >ERROR: XSLT parameter $ndr-id-map must be set.</message>
    </if>
    <if test="not($map)">
      <message terminate="yes"
               >ERROR: NDR ID map (<value-of select="$map"/>) is empty.</message>
    </if>
    <copy>
      <apply-templates/>
    </copy>
  </template>

  <template match="@*|node()" priority="-1">
    <copy>
      <apply-templates select="@*|node()"/>
    </copy>
  </template>

  <template match="*">
    <copy>
      <if test="@id">
        <call-template name="put-descriptive-id"/>
      </if>
      <apply-templates select="@*|node()"/>
    </copy>
  </template>

  <template name="put-descriptive-id">
    <variable name="id" select="@id"/>
    <attribute name="ann:descriptive-id">
      <value-of select="$map/map:rule[@ruleID = $id]/@descriptiveID"/>
    </attribute>
  </template>

</stylesheet>
