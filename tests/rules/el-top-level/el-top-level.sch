<?xml version="1.0" encoding="UTF-8"?>
<sch:schema
    xmlns:sch="http://purl.oclc.org/dsdl/schematron"
    queryBinding="xslt2">
    <sch:pattern>
        <sch:rule context="xs:element[exists(@name)]">
            <sch:assert test="exists(parent::xs:schema)">An element declaration MUST be top-level.</sch:assert>
        </sch:rule>
    </sch:pattern>
</sch:schema>
