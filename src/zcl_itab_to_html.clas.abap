class zcl_itab_to_html definition public create public.
  public section.
    methods constructor
      importing
        table_id    type string optional
        table_class type string optional
        table_style type string optional

        tr_class    type string optional
        tr_style    type string optional

        th_class    type string optional
        th_style    type string optional

        td_class    type string optional
        td_style    type string optional.


    methods convert importing tbl type any table returning value(ret) type string.

  protected section.
    types:
      begin of t_table_description,
        name        type string,
        title       type string,
        description type string,
      end of t_table_description,
      t_table_description_t type standard table of t_table_description with key name.


    data:
      cellpadding type i value 0,
      cellspacing type i value 0,

      table_class type string value '',
      table_id    type string value '',
      table_style type string value '',

      tr_class    type string value '',
      tr_style    type string value '',

      th_class    type string value '',
      th_style    type string value '',

      td_class    type string value '',
      td_style    type string value ''.

    methods get_description importing tbl type any table returning value(ret) type t_table_description_t.

    methods title importing desc type t_table_description_t returning value(ret) type string.

    methods table_params returning value(ret) type string.
    methods tr_params returning value(ret) type string.
    methods th_params returning value(ret) type string.
    methods td_params returning value(ret) type string.

    methods value_to_string importing field type string val type any returning value(ret) type string.

    methods footer importing desc type t_table_description_t returning value(ret) type string.
endclass.

class zcl_itab_to_html implementation.
  method constructor.
    if table_id is supplied.
      me->table_id = table_id.
    endif.
    if table_class is supplied.
      me->table_class = table_class.
    endif.
    if table_style is supplied.
      me->table_style = table_style.
    endif.

    if tr_class is supplied.
      me->tr_class = tr_class.
    endif.
    if tr_style is supplied.
      me->tr_style = tr_style.
    endif.

    if th_class is supplied.
      me->th_class = th_class.
    endif.
    if th_style is supplied.
      me->th_style = th_style.
    endif.

    if td_class is supplied.
      me->td_class = td_class.
    endif.
    if td_style is supplied.
      me->td_style = td_style.
    endif.
  endmethod.

  method convert.
    data(descr) = get_description( tbl ).
    data(tr) = tr_params( ).
    data(td) = td_params( ).

    data row type string value ''.
    loop at tbl assigning field-symbol(<row>).
      clear row.
      loop at descr assigning field-symbol(<struct>).
        assign component <struct>-name of structure <row> to field-symbol(<value>).
        row = |{ row }\n  <td{ td }>{ value_to_string( field = <struct>-name val = <value> ) }</td>|.
      endloop.

      ret = |{ ret }\n <tr{ tr }>{ row }\n </tr>|.
    endloop.


    ret = |{ title( descr ) }{ ret }{ footer( descr ) }|.
  endmethod.

  method get_description.
    data(description) = cast cl_abap_tabledescr( cl_abap_tabledescr=>describe_by_data( tbl ) ).
    data(components) = cast cl_abap_structdescr( description->get_table_line_type( ) )->get_components( ).

    loop at components assigning field-symbol(<component>).
      data(elem) = cast cl_abap_elemdescr( <component>-type )->get_ddic_field( ).
      append value #( name = <component>-name title = elem-reptext description = elem-fieldtext ) to ret.
    endloop.
  endmethod.

  method title.
    data(th) = th_params( ).

    loop at desc assigning field-symbol(<item>).
      ret = |{ ret }\n  <th{ th }>{ <item>-title }</th>|.
    endloop.

    ret = |<table{ table_params( ) }>\n <tr{ tr_params( ) }>{ ret }\n </tr>|.
  endmethod.

  method table_params.
    if table_id <> ''.
      ret = |{ ret } id="{ table_id }"|.
    endif.

    if table_class <> ''.
      ret = |{ ret } class="{ table_class }"|.
    endif.

    if table_style <> ''.
      ret = |{ ret } style="{ table_style }"|.
    endif.
  endmethod.

  method tr_params.
    if tr_class <> ''.
      ret = |{ ret } class="{ tr_class }"|.
    endif.

    if tr_style <> ''.
      ret = |{ ret } style="{ tr_style }"|.
    endif.
  endmethod.

  method th_params.
    if th_class <> ''.
      ret = |{ ret } class="{ th_class }"|.
    endif.

    if th_style <> ''.
      ret = |{ ret } style="{ th_style }"|.
    endif.
  endmethod.

  method td_params.
    if td_class <> ''.
      ret = |{ ret } class="{ td_class }"|.
    endif.

    if td_style <> ''.
      ret = |{ ret } style="{ td_style }"|.
    endif.
  endmethod.

  method value_to_string.
    ret = conv string( val ).
  endmethod.

  method footer.
    ret = |\n</table>|.
  endmethod.
endclass.