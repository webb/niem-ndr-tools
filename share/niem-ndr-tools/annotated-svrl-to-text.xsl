<?xml version="1.0" encoding="US-ASCII"?>
<stylesheet 
  version="1.0"
  xmlns:sch-cli="https://github.com/webb/schematron-cli/ns/svrl-annotation"
  xmlns:ndr-tools="https://github.com/webb/niem-ndr-tools/ns/svrl-annotation"
  xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
  xmlns="http://www.w3.org/1999/XSL/Transform">

  <output method="text"/>

  <template match="svrl:successful-report | svrl:failed-assert">
    <variable name="pattern" select="preceding-sibling::svrl:active-pattern[1]"/>
    <value-of select="concat(@sch-cli:line-number, ':', local-name(), ':', $pattern/@ndr-tools:descriptive-id, ':', $pattern/@id, ':', normalize-space($pattern/@name))"/>
    <if test="svrl:text">
      <text>:</text>
      <value-of select="normalize-space(svrl:text)"/>
    </if>
    <text>&#10;</text>
  </template>

  <template match="text()"/>

</stylesheet>
