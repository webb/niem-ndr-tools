<?xml version="1.0" encoding="UTF-8"?>
<sch:schema
    xmlns:sch="http://purl.oclc.org/dsdl/schematron"
    queryBinding="xslt2">
    <sch:pattern>
        <sch:rule context="xs:element">
            <sch:assert test="empty(@final)"
                >An element xs:element MUST NOT have an attribute {}final.</sch:assert>
        </sch:rule>
    </sch:pattern>
</sch:schema>
