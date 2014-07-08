<?xml version="1.0" encoding="UTF-8"?>
<sch:schema
    xmlns:sch="http://purl.oclc.org/dsdl/schematron"
    queryBinding="xslt2">
    <sch:pattern>
        <sch:rule context="xs:element">
            <sch:assert test="empty(@default)"
                >An element xs:element MUST NOT have an attribute {}default.</sch:assert>
        </sch:rule>
    </sch:pattern>
</sch:schema>
