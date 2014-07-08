<?xml version="1.0" encoding="UTF-8"?>
<sch:schema
    xmlns:sch="http://purl.oclc.org/dsdl/schematron"
    queryBinding="xslt2">
    <sch:pattern>
        <sch:rule context="xs:element[exists(@name)]">
            <sch:assert test="exists(xs:annotation/xs:documentation)">An element declaration MUST be a documented component.</sch:assert>
        </sch:rule>
    </sch:pattern>
</sch:schema>
