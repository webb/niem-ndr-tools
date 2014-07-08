<?xml version="1.0" encoding="UTF-8"?>
<sch:schema
    xmlns:sch="http://purl.oclc.org/dsdl/schematron"
    queryBinding="xslt2">
    <sch:pattern>
        <sch:rule context="xs:element[exists(@type)
            and resolve-QName(@type, .) = xs:QName('xs:anySimpleType')]">
            <sch:assert test="exists(@abstract)
                and xs:boolean(@abstract) = true()"
                >An element declaration that has a type xs:anySimpleType MUST be abstract.</sch:assert>
        </sch:rule>
    </sch:pattern>
</sch:schema>
