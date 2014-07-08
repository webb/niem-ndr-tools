<?xml version="1.0" encoding="UTF-8"?>
<sch:schema
    xmlns:sch="http://purl.oclc.org/dsdl/schematron"
    queryBinding="xslt2">
    <sch:pattern>
        <sch:rule context="xs:notation">
            <sch:assert test="false()"
                >The schema SHALL NOT contain the element xs:notation.</sch:assert>
        </sch:rule>
    </sch:pattern>
</sch:schema>
