class ZCL_XML_UTILS definition
  public
  final
  create public .

    public section.

        class-methods:

            xml_element
                importing
                    iv_tag type csequence
                    iv_attr type csequence optional
                    iv_content type csequence
                    iv_escape_content type abap_bool default abap_true
                returning
                    value(rv_result) type string.


    protected section.
    private section.
ENDCLASS.



CLASS ZCL_XML_UTILS IMPLEMENTATION.

    method xml_element.

        rv_result =
            |<{ iv_tag }{
                cond string(
                    when iv_attr is supplied then
                        | { iv_attr }|
                    else
                        ''
                )
            }>| &&

            cond string(
                when iv_escape_content eq abap_true then
                    escape( val = iv_content format = cl_abap_format=>e_xml_text )
                else
                    iv_content
            ) &&

            |</{ iv_tag }>|.

    endmethod.

ENDCLASS.
