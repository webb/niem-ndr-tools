<?xml version="1.0" encoding="UTF-8"?>
<sch:schema
    xmlns:sch="http://purl.oclc.org/dsdl/schematron"
    queryBinding="xslt2">
    <sch:pattern>
        <sch:rule context="xs:attribute[exists(@type)]">
            <sch:assert test="resolve-QName(@type, .) != xs:QName('xs:ID')"
                >A schema component MUST NOT have an attribute {}type with a value of xs:ID.</sch:assert>
        </sch:rule>
    </sch:pattern>
</sch:schema>
