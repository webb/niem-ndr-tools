<?xml version="1.0" encoding="UTF-8"?>
<sch:schema
    xmlns:sch="http://purl.oclc.org/dsdl/schematron"
    queryBinding="xslt2">
    <sch:pattern>
        <sch:rule context="xs:attribute">
            <sch:assert test="empty(@fixed)"
                >An element xs:attribute MUST NOT have an attribute {}fixed.</sch:assert>
        </sch:rule>
    </sch:pattern>
</sch:schema>
