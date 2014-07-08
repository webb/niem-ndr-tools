<?xml version="1.0" encoding="UTF-8"?>
<sch:schema
    xmlns:sch="http://purl.oclc.org/dsdl/schematron"
    queryBinding="xslt2">
    <sch:pattern>
        <sch:rule context="xs:element[exists(@type)]">
            <sch:assert test="for $type-qname in resolve-QName(@type, .) return
                $type-qname = xs:QName('xs:anySimpleType')
                or namespace-uri-from-QName($type-qname) != xs:anyURI('http://www.w3.org/2001/XMLSchema')"
                >An element type that is not xs:anySimpleType MUST NOT have a namespace name xs.</sch:assert>
        </sch:rule>
    </sch:pattern>
</sch:schema>
