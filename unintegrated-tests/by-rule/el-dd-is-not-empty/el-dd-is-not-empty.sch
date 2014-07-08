<?xml version="1.0" encoding="UTF-8"?>
<sch:schema
    xmlns:sch="http://purl.oclc.org/dsdl/schematron"
    queryBinding="xslt2">
    <sch:pattern>
        <sch:rule context="xs:element[exists(@name)]/xs:annotation/xs:documentation[
            . is (../../xs:annotation/xs:documentation)[1]]">
            <sch:assert test="string-length(normalize-space(string-join(text(), ''))) &gt; 0"
                >A data definition MUST NOT be empty.</sch:assert>
        </sch:rule>
    </sch:pattern>
</sch:schema>
