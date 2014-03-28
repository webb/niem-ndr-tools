<?xml version="1.0" encoding="UTF-8"?>
<sch:schema
    xmlns:sch="http://purl.oclc.org/dsdl/schematron"
    queryBinding="xslt2">
    <sch:pattern>
        <sch:rule context="xs:element[exists(@type)]">
            <sch:assert test="not(namespace-uri-from-QName(resolve-QName(@type, .))
                = (xs:anyURI('http://www.w3.org/XML/1998/namespace'),
                xs:anyURI('urn:us:gov:ic:ism'),
                xs:anyURI('urn:us:gov:ic:ntk')))"
                >An element type MUST NOT have a namespace name that is in a special namespace.</sch:assert>
        </sch:rule>
    </sch:pattern>
</sch:schema>
