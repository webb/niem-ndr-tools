<?xml version="1.0" encoding="UTF-8"?>
<sch:schema
    xmlns:sch="http://purl.oclc.org/dsdl/schematron"
    queryBinding="xslt2">
    <sch:pattern>
        <sch:rule context="xs:schema/xs:element[empty(@type)]">
            <sch:assert test="exists(@abstract)
                and xs:boolean(@abstract) = true()"
                >A top-level element declaration that has no type MUST be abstract.</sch:assert>
        </sch:rule>
    </sch:pattern>
</sch:schema>
