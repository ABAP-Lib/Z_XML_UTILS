class ZCL_HTML_UTILS definition
  public
  final
  create public .

    public section.

        class-methods:

            class_constructor,

            to_html_table_header
                importing
                    it_header_titles type stringtab
                returning
                    value(rv_result) type string,

            to_html_table_line
                importing
                    is_data type any
                returning
                    value(rv_result) type string,

            to_html_table_lines
                importing
                    it_data type table
                returning
                    value(rv_result) type string,

            to_html_table
                importing
                    it_header_titles type stringtab
                    it_data type table
                returning
                    value(rv_result) type string.

        class-data:
            lv_Border type string,
            lv_Table_Style type string,
            lv_Cell_Style type string,
            lv_Cell_Style_Center type string.

    protected section.
    private section.

ENDCLASS.



CLASS ZCL_HTML_UTILS IMPLEMENTATION.

    method class_constructor.

        lv_Border = 'border: 1px solid black;'.
        lv_Table_Style = |style="margin: 1em; { lv_Border }"|.
        lv_Cell_Style = |style="padding: 5px; { lv_Border }"|.
        lv_Cell_Style_Center = |style="padding: 5px; { lv_Border }"|.

    endmethod.

    method to_html_table_line.

        data(lv_cells) = conv string( '' ).

        do.
            assign component sy-index of structure is_data to field-symbol(<lv_field>).

            if sy-subrc ne 0.
                exit.
            endif.

            data:
                lv_content(100) type c.

            write <lv_field> to lv_content.
            condense lv_content.

            lv_cells = lv_cells &&
                zcl_xml_utils=>xml_element( iv_tag = 'td' iv_attr = lv_cell_style iv_content = lv_content ).

        enddo.

        rv_result = zcl_xml_utils=>xml_element(
            iv_tag = 'tr'
            iv_content = lv_cells
            iv_escape_content = abap_false
        ).

    endmethod.

    method to_html_table_lines.

        rv_result = ''.

        loop at it_data assigning field-symbol(<ls_data>).

            rv_result = rv_result &&
                to_html_table_line( <ls_data> ).

        endloop.

    endmethod.

    method to_html_table_header.

        rv_result = zcl_xml_utils=>xml_element(
            iv_tag = 'tr'
            iv_content = concat_lines_of(
                value stringtab(
                    for lv_title in it_header_titles
                        ( zcl_xml_utils=>xml_element( iv_tag = 'th' iv_attr = lv_cell_style iv_content = lv_title ) )
                )
            )
            iv_escape_content = abap_false
        ).

    endmethod.

    method to_html_table.


        data(lv_table_content) =
            to_html_table_header( it_header_titles ) &&
            to_html_table_lines( it_data ).

        rv_result = zcl_xml_utils=>xml_element(
            iv_tag = 'table'
            iv_attr = lv_table_style
            iv_content = lv_table_content
            iv_escape_content = abap_false
        ).

    endmethod.

ENDCLASS.
