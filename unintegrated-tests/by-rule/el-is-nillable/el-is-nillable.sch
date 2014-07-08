<?xml version="1.0" encoding="UTF-8"?>
<sch:schema
    xmlns:sch="http://purl.oclc.org/dsdl/schematron"
    queryBinding="xslt2">
    <sch:pattern>
        <sch:rule context="xs:element[exists(@name)
            and (empty(@abstract)
            or xs:boolean(@abstract) = false())]">
            <sch:assert test="exists(@nillable)
                and xs:boolean(@nillable) = true()"
                >An [element declaration schema component] MUST have the nillable property with a value of true.</sch:assert>
        </sch:rule>
    </sch:pattern>
</sch:schema>
